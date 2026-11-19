import 'package:flutter/material.dart';
import 'package:taskflow/models/task_model.dart';
import 'package:taskflow/models/user_model.dart';
import 'package:taskflow/services/auth_service.dart';
import 'package:taskflow/services/database_service.dart';
import 'package:taskflow/theme/app_theme.dart';
import 'package:taskflow/widgets/empty_state.dart';
import 'package:taskflow/widgets/task_card.dart';

import 'login_screen.dart';
import 'task_form_screen.dart';

/// Filtros de exibição disponíveis na barra inferior da Home.
enum _TaskFilter { all, pending, completed }

/// Tela principal com contadores, filtros e lista de tarefas do usuário.
class HomeScreen extends StatefulWidget {
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TaskModel> _tasks = const [];
  _TaskFilter _filter = _TaskFilter.all;
  TaskCategory? _selectedCategory;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.user.id == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _redirectToLogin());
      return;
    }
    _loadTasks();
  }

  /// Redireciona para a tela de login limpando a pilha de navegação.
  void _redirectToLogin() {
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  /// Carrega do SQLite todas as tarefas do usuário autenticado.
  Future<void> _loadTasks() async {
    final userId = widget.user.id;
    if (userId == null) {
      _redirectToLogin();
      return;
    }

    setState(() => _isLoading = true);
    try {
      final tasks = await DatabaseService.instance.getTasksByUser(userId);
      if (!mounted) return;
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível carregar as tarefas.')),
      );
    }
  }

  /// Encerra a sessão atual e volta para a tela de login.
  Future<void> _logout() async {
    await AuthService.instance.logout();
    _redirectToLogin();
  }

  /// Abre o formulário para criar uma nova tarefa ou editar uma existente.
  Future<void> _openTaskForm([TaskModel? task]) async {
    final userId = widget.user.id;
    if (userId == null) {
      _redirectToLogin();
      return;
    }

    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => TaskFormScreen(userId: userId, task: task),
      ),
    );
    if (saved == true && mounted) {
      await _loadTasks();
    }
  }

  /// Alterna o status da tarefa entre pendente e concluída no banco.
  Future<void> _toggleTask(TaskModel task) async {
    final userId = widget.user.id;
    final taskId = task.id;
    if (userId == null || taskId == null) return;

    try {
      await DatabaseService.instance.toggleTaskStatus(
        taskId,
        userId,
        !task.isCompleted,
      );
      if (!mounted) return;
      await _loadTasks();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível atualizar a tarefa.')),
      );
    }
  }

  /// Solicita confirmação e exclui a tarefa selecionada do banco.
  Future<void> _confirmDelete(TaskModel task) async {
    final userId = widget.user.id;
    final taskId = task.id;
    if (userId == null || taskId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            side: const BorderSide(color: AppColors.border),
          ),
          title: const Text('Excluir tarefa?'),
          content: Text('Deseja excluir "${task.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    try {
      await DatabaseService.instance.deleteTask(taskId, userId);
      if (!mounted) return;
      await _loadTasks();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível excluir a tarefa.')),
      );
    }
  }

  /// Retorna as tarefas filtradas pela aba do Retro Dock e pela categoria.
  List<TaskModel> get _filteredTasks {
    return _tasks.where((t) {
      final matchesStatus = switch (_filter) {
        _TaskFilter.all => true,
        _TaskFilter.pending => !t.isCompleted,
        _TaskFilter.completed => t.isCompleted,
      };
      final matchesCategory =
          _selectedCategory == null || t.category == _selectedCategory;
      return matchesStatus && matchesCategory;
    }).toList();
  }

  Widget _buildEmptyState() {
    if (_tasks.isEmpty) {
      return EmptyState(
        icon: Icons.inbox_outlined,
        title: 'Nenhuma tarefa ainda',
        subtitle: 'Crie sua primeira tarefa para começar o dia.',
        actionLabel: 'Nova tarefa',
        onAction: () => _openTaskForm(),
      );
    }

    if (_selectedCategory != null) {
      return EmptyState(
        icon: _selectedCategory!.icon,
        title: 'Nenhuma tarefa em ${_selectedCategory!.label}',
        subtitle: 'Limpe o filtro ou crie uma tarefa nesta categoria.',
      );
    }

    return switch (_filter) {
      _TaskFilter.pending => const EmptyState(
          icon: Icons.check_circle_outline,
          title: 'Tudo em dia',
          subtitle: 'Você não tem tarefas pendentes no momento.',
        ),
      _TaskFilter.completed => const EmptyState(
          icon: Icons.hourglass_empty_outlined,
          title: 'Nenhuma concluída',
          subtitle: 'Conclua uma tarefa para vê-la aqui.',
        ),
      _TaskFilter.all => const SizedBox.shrink(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final total = _tasks.length;
    final completed = _tasks.where((t) => t.isCompleted).length;
    final pending = total - completed;
    final visibleTasks = _filteredTasks;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('TaskFlow'),
            Text(
              widget.user.name,
              style: textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _logout,
            tooltip: 'Sair',
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingMd,
                AppTheme.spacingSm,
                AppTheme.spacingMd,
                AppTheme.spacingSm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _CounterCard(label: 'Total', count: total),
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  Expanded(
                    child: _CounterCard(
                      label: 'Pendentes',
                      count: pending,
                      accentColor: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  Expanded(
                    child: _CounterCard(
                      label: 'Concluídas',
                      count: completed,
                      accentColor: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
            _CategoryFilterBar(
              selected: _selectedCategory,
              onSelect: (cat) => setState(() => _selectedCategory = cat),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    )
                  : visibleTasks.isEmpty
                      ? _buildEmptyState()
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(
                            AppTheme.spacingMd,
                            0,
                            AppTheme.spacingMd,
                            AppTheme.spacingMd * 5,
                          ),
                          itemCount: visibleTasks.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppTheme.spacingSm),
                          itemBuilder: (_, index) {
                            final task = visibleTasks[index];
                            return TaskCard(
                              task: task,
                              onTap: () => _openTaskForm(task),
                              onToggleStatus: () => _toggleTask(task),
                              onDelete: () => _confirmDelete(task),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTaskForm(),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          side: const BorderSide(color: AppColors.border),
        ),
        tooltip: 'Nova tarefa',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: _RetroDock(
        selected: _filter,
        onSelect: (filter) => setState(() => _filter = filter),
      ),
    );
  }
}

class _CategoryFilterBar extends StatelessWidget {
  final TaskCategory? selected;
  final ValueChanged<TaskCategory?> onSelect;

  const _CategoryFilterBar({
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    Widget chip(String label, IconData? icon, TaskCategory? value) {
      final isSelected = selected == value;
      return Material(
        color: isSelected ? AppColors.primary : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: InkWell(
          onTap: () => onSelect(value),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 14,
                    color: isSelected ? AppColors.surface : AppColors.text,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isSelected ? AppColors.surface : AppColors.text,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
        children: [
          chip('Todas', null, null),
          for (final cat in TaskCategory.values) ...[
            const SizedBox(width: AppTheme.spacingSm),
            chip(cat.label, cat.icon, cat),
          ],
        ],
      ),
    );
  }
}

class _CounterCard extends StatelessWidget {
  final String label;
  final int count;
  final Color? accentColor;

  const _CounterCard({
    required this.label,
    required this.count,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical: AppTheme.spacingSm * 1.25,
      ),
      decoration: AppTheme.paperCardDecoration,
      child: Column(
        children: [
          Text(
            count.toString().padLeft(2, '0'),
            style: textTheme.titleLarge?.copyWith(
              fontFamily: 'SpaceMono',
              color: accentColor ?? AppColors.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: textTheme.labelSmall,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _RetroDock extends StatelessWidget {
  final _TaskFilter selected;
  final ValueChanged<_TaskFilter> onSelect;

  const _RetroDock({
    required this.selected,
    required this.onSelect,
  });

  static const _items = [
    (_TaskFilter.all, 'Todas', Icons.list_alt_outlined),
    (_TaskFilter.pending, 'Pendentes', Icons.radio_button_unchecked),
    (_TaskFilter.completed, 'Concluídas', Icons.task_alt),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: AppTheme.spacingSm,
          ),
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++) ...[
                if (i > 0) const SizedBox(width: AppTheme.spacingSm),
                Expanded(
                  child: Material(
                    color: selected == _items[i].$1
                        ? AppColors.primary
                        : AppColors.secondary,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    child: InkWell(
                      onTap: () => onSelect(_items[i].$1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      child: SizedBox(
                        height: 44,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _items[i].$3,
                              size: 16,
                              color: selected == _items[i].$1
                                  ? AppColors.surface
                                  : AppColors.text,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                _items[i].$2,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: selected == _items[i].$1
                                      ? AppColors.surface
                                      : AppColors.text,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
