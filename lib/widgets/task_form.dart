import 'package:flutter/material.dart';
import 'package:taskflow/models/task_model.dart';
import 'package:taskflow/theme/app_theme.dart';
import 'package:taskflow/widgets/custom_text_field.dart';

/// Formulário reutilizável para preencher ou editar os dados de uma tarefa.
class TaskForm extends StatefulWidget {
  final TaskModel? initialTask;
  final bool isLoading;
  final void Function(
    String title,
    String? description,
    String? location,
    int priority,
    bool isCompleted,
    TaskCategory category,
  ) onSubmit;

  const TaskForm({
    super.key,
    this.initialTask,
    this.isLoading = false,
    required this.onSubmit,
  });

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late int _priority;
  late bool _isCompleted;
  late TaskCategory _category;

  static const _priorities = [
    (1, 'Baixa', AppColors.accent, AppColors.surface),
    (2, 'Média', AppColors.secondary, AppColors.text),
    (3, 'Alta', AppColors.primary, AppColors.surface),
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTask?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.initialTask?.description ?? '',
    );
    _locationController = TextEditingController(
      text: widget.initialTask?.location ?? '',
    );
    _priority = widget.initialTask?.priority ?? 2;
    _isCompleted = widget.initialTask?.isCompleted ?? false;
    _category = widget.initialTask?.category ?? TaskCategory.other;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  /// Valida os campos e envia os dados normalizados para a tela pai.
  void _submit() {
    if (widget.isLoading || !(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final title = _titleController.text.trim();
    final desc = _descriptionController.text.trim();
    final location = _locationController.text.trim();
    widget.onSubmit(
      title,
      desc.isEmpty ? null : desc,
      location.isEmpty ? null : location,
      _priority,
      _isCompleted,
      _category,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: _titleController,
            label: 'Título',
            hint: 'Ex.: Estudar Flutter',
            maxLength: 100,
            textInputAction: TextInputAction.next,
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'Informe o título da tarefa'
                : null,
          ),
          const SizedBox(height: AppTheme.spacingMd),
          CustomTextField(
            controller: _locationController,
            label: 'Local (opcional)',
            hint: 'Ex.: Biblioteca, Escritório, Casa...',
            maxLength: 100,
            prefixIcon: Icons.location_on_outlined,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppTheme.spacingMd),
          CustomTextField(
            controller: _descriptionController,
            label: 'Descrição (opcional)',
            hint: 'Detalhes ou observações...',
            maxLines: 3,
            maxLength: 500,
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Text('Prioridade', style: textTheme.labelLarge),
          const SizedBox(height: AppTheme.spacingSm),
          Row(
            children: [
              for (var i = 0; i < _priorities.length; i++) ...[
                if (i > 0) const SizedBox(width: AppTheme.spacingSm),
                Expanded(
                  child: _PriorityOption(
                    label: _priorities[i].$2,
                    selected: _priority == _priorities[i].$1,
                    selectedBg: _priorities[i].$3,
                    selectedFg: _priorities[i].$4,
                    onTap: widget.isLoading
                        ? null
                        : () => setState(() => _priority = _priorities[i].$1),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Text('Categoria', style: textTheme.labelLarge),
          const SizedBox(height: AppTheme.spacingSm),
          Wrap(
            spacing: AppTheme.spacingSm,
            runSpacing: AppTheme.spacingSm,
            children: [
              for (final cat in TaskCategory.values)
                _CategoryOption(
                  category: cat,
                  selected: _category == cat,
                  onTap: widget.isLoading
                      ? null
                      : () => setState(() => _category = cat),
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Material(
            color: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              side: const BorderSide(color: AppColors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: SwitchListTile(
              title: Text('Status', style: textTheme.labelLarge),
              subtitle: Text(
                _isCompleted ? 'Concluída' : 'Pendente',
                style: textTheme.bodySmall,
              ),
              value: _isCompleted,
              activeThumbColor: AppColors.surface,
              activeTrackColor: AppColors.accent,
              onChanged: widget.isLoading
                  ? null
                  : (value) => setState(() => _isCompleted = value),
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd * 1.5),
          ElevatedButton(
            onPressed: widget.isLoading ? null : _submit,
            child: widget.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.surface,
                    ),
                  )
                : const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}

class _PriorityOption extends StatelessWidget {
  final String label;
  final bool selected;
  final Color selectedBg;
  final Color selectedFg;
  final VoidCallback? onTap;

  const _PriorityOption({
    required this.label,
    required this.selected,
    required this.selectedBg,
    required this.selectedFg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: selected ? selectedBg : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        side: BorderSide(
          color: selected && selectedBg != AppColors.secondary
              ? selectedBg
              : AppColors.border,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: SizedBox(
          height: 48,
          child: Center(
            child: Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                color: selected ? selectedFg : AppColors.text,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryOption extends StatelessWidget {
  final TaskCategory category;
  final bool selected;
  final VoidCallback? onTap;

  const _CategoryOption({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final fg = selected && category != TaskCategory.other
        ? AppColors.surface
        : AppColors.text;
    final bg = selected
        ? (category == TaskCategory.other ? AppColors.secondary : category.color)
        : AppColors.surface;

    return Material(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        side: BorderSide(
          color: selected && category != TaskCategory.other
              ? category.color
              : AppColors.border,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingSm * 1.5,
            vertical: 10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(category.icon, size: 16, color: fg),
              const SizedBox(width: 6),
              Text(
                category.label,
                style: textTheme.labelMedium?.copyWith(color: fg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
