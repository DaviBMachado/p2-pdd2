import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/models/task_model.dart';
import 'package:taskflow/models/user_model.dart';

void main() {
  test('UserModel toMap/fromMap round-trip', () {
    final now = DateTime.utc(2026, 11, 18, 12, 0);
    final user = UserModel(
      id: 1,
      name: 'Ana',
      email: 'ana@example.com',
      passwordHash: 'hash',
      passwordSalt: 'salt',
      createdAt: now,
    );

    final restored = UserModel.fromMap(user.toMap());
    expect(restored.id, 1);
    expect(restored.name, 'Ana');
    expect(restored.email, 'ana@example.com');
    expect(restored.passwordHash, 'hash');
    expect(restored.passwordSalt, 'salt');
    expect(restored.createdAt, now);

    final withoutId = UserModel(
      name: 'Bob',
      email: 'bob@example.com',
      passwordHash: 'h',
      passwordSalt: 's',
      createdAt: now,
    );
    expect(withoutId.toMap().containsKey('id'), isFalse);
  });

  test('TaskModel toMap/fromMap, priorityLabel and copyWith', () {
    final created = DateTime.utc(2026, 11, 18, 10, 0);
    final updated = DateTime.utc(2026, 11, 18, 11, 0);
    final task = TaskModel(
      id: 7,
      userId: 1,
      title: 'Estudar',
      description: 'SQLite',
      location: 'Biblioteca',
      priority: 3,
      isCompleted: true,
      category: TaskCategory.study,
      createdAt: created,
      updatedAt: updated,
    );

    final map = task.toMap();
    expect(map['is_completed'], 1);
    expect(map['category'], 'study');
    expect(map['location'], 'Biblioteca');
    expect(task.priorityLabel, 'Alta');

    final restored = TaskModel.fromMap({
      ...map,
      'description': null,
      'location': null,
    });
    expect(restored.description, '');
    expect(restored.location, '');
    expect(restored.isCompleted, isTrue);
    expect(restored.category, TaskCategory.study);

    final fallback = TaskModel.fromMap({...map, 'category': 'invalida'});
    expect(fallback.category, TaskCategory.other);
    expect(fallback.location, 'Biblioteca');

    final toggled = restored.copyWith(
      isCompleted: false,
      priority: 2,
      category: TaskCategory.work,
      location: 'Escritório',
    );
    expect(toggled.isCompleted, isFalse);
    expect(toggled.priorityLabel, 'Média');
    expect(toggled.category, TaskCategory.work);
    expect(toggled.location, 'Escritório');
    expect(toggled.copyWith(priority: 1).priorityLabel, 'Baixa');
  });
}
