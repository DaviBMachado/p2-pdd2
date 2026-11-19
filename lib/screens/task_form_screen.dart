import 'package:flutter/material.dart';
import 'package:taskflow/models/task_model.dart';
import 'package:taskflow/services/database_service.dart';
import 'package:taskflow/theme/app_theme.dart';
import 'package:taskflow/widgets/task_form.dart';

/// Tela usada tanto para criar uma nova tarefa quanto para editar uma existente.
class TaskFormScreen extends StatefulWidget {
  final int userId;
  final TaskModel? task;

  const TaskFormScreen({
    super.key,
    required this.userId,
    this.task,
  });

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  bool _isLoading = false;

  bool get _isEditing => widget.task != null;

  /// Salva a tarefa criada ou editada no SQLite e retorna para a Home.
  Future<void> _handleSubmit(
    String title,
    String? description,
    String? location,
    int priority,
    bool isCompleted,
    TaskCategory category,
  ) async {
    setState(() => _isLoading = true);

    try {
      final now = DateTime.now();
      if (_isEditing) {
        final updated = widget.task!.copyWith(
          title: title,
          description: description ?? '',
          location: location ?? '',
          priority: priority,
          isCompleted: isCompleted,
          category: category,
          updatedAt: now,
        );
        await DatabaseService.instance.updateTask(updated);
      } else {
        await DatabaseService.instance.insertTask(
          TaskModel(
            userId: widget.userId,
            title: title,
            description: description ?? '',
            location: location ?? '',
            priority: priority,
            isCompleted: isCompleted,
            category: category,
            createdAt: now,
            updatedAt: now,
          ),
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível salvar a tarefa. Tente novamente.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Tarefa' : 'Nova Tarefa'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: TaskForm(
                initialTask: widget.task,
                isLoading: _isLoading,
                onSubmit: _handleSubmit,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
