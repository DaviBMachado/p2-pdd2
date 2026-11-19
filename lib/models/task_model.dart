import 'package:flutter/material.dart';
import 'package:taskflow/theme/app_theme.dart';

/// Categorias disponíveis para classificar uma tarefa.
enum TaskCategory {
  work('Trabalho', Icons.work_outline, AppColors.primary),
  study('Faculdade', Icons.school_outlined, AppColors.accent),
  personal('Pessoal', Icons.person_outline, AppColors.text),
  other('Outro', Icons.label_outline, AppColors.border);

  final String label;
  final IconData icon;
  final Color color;

  const TaskCategory(this.label, this.icon, this.color);
}

/// Representa uma tarefa pertencente a um usuário.
class TaskModel {
  final int? id;
  final int userId;
  final String title;
  final String description;
  final String location;
  final int priority;
  final bool isCompleted;
  final TaskCategory category;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TaskModel({
    this.id,
    required this.userId,
    required this.title,
    this.description = '',
    this.location = '',
    this.priority = 2,
    this.isCompleted = false,
    this.category = TaskCategory.other,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Retorna o rótulo legível correspondente ao nível de prioridade (1 a 3).
  String get priorityLabel => switch (priority) {
        3 => 'Alta',
        2 => 'Média',
        _ => 'Baixa',
      };

  static TaskCategory _parseCategory(Object? raw) {
    if (raw is! String) return TaskCategory.other;
    try {
      return TaskCategory.values.byName(raw);
    } catch (_) {
      return TaskCategory.other;
    }
  }

  /// Cria uma [TaskModel] a partir de uma linha retornada pelo SQLite.
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      title: map['title'] as String,
      description: (map['description'] as String?) ?? '',
      location: (map['location'] as String?) ?? '',
      priority: map['priority'] as int,
      isCompleted: (map['is_completed'] as int) == 1,
      category: _parseCategory(map['category']),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// Converte a tarefa para um mapa compatível com o SQLite.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'location': location,
      'priority': priority,
      'is_completed': isCompleted ? 1 : 0,
      'category': category.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Retorna uma cópia da tarefa com os campos informados alterados.
  TaskModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    String? location,
    int? priority,
    bool? isCompleted,
    TaskCategory? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
