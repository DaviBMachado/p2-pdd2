import 'package:flutter/material.dart';
import 'package:taskflow/models/task_model.dart';
import 'package:taskflow/theme/app_theme.dart';

/// Cartão que mostra resumo, prioridade, data e ações de uma tarefa.
class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggleStatus;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggleStatus,
    required this.onTap,
    required this.onDelete,
  });

  /// Retorna o texto e as cores da etiqueta conforme a prioridade (1 a 3).
  (String, Color, Color) _priorityBadge(int priority) => switch (priority) {
        3 => ('ALTA', AppColors.primary, AppColors.surface),
        2 => ('MÉDIA', AppColors.secondary, AppColors.text),
        _ => ('BAIXA', AppColors.accent, AppColors.surface),
      };

  /// Formata a data no padrão DD/MM/AAAA.
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final (priorityLabel, badgeBg, badgeFg) = _priorityBadge(task.priority);
    final decoration = task.isCompleted ? TextDecoration.lineThrough : null;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: task.isCompleted ? 0.65 : 1.0,
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          side: const BorderSide(color: AppColors.border),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingSm,
              vertical: AppTheme.spacingSm * 1.5,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: onToggleStatus,
                  tooltip: task.isCompleted
                      ? 'Marcar como pendente'
                      : 'Marcar como concluída',
                  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  icon: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: task.isCompleted
                          ? AppColors.accent
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: task.isCompleted
                            ? AppColors.accent
                            : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: task.isCompleted
                        ? const Icon(
                            Icons.check,
                            size: 16,
                            color: AppColors.surface,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSm / 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        task.title,
                        style: textTheme.titleMedium?.copyWith(
                          decoration: decoration,
                        ),
                      ),
                      if (task.description.trim().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(
                            decoration: decoration,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppTheme.spacingSm),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: badgeBg,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: badgeBg == AppColors.secondary
                                    ? AppColors.border
                                    : badgeBg,
                              ),
                            ),
                            child: Text(
                              priorityLabel,
                              style: textTheme.labelSmall?.copyWith(
                                color: badgeFg,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingSm),
                          Text(
                            _formatDate(task.createdAt),
                            style: textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  tooltip: 'Excluir tarefa',
                  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
