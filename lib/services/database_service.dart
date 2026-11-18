import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../models/task_model.dart';
import '../models/user_model.dart';

class DatabaseService {
  DatabaseService._internal();

  static final DatabaseService instance = DatabaseService._internal();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }

    final path = kIsWeb
        ? 'taskflow.db'
        : join(await getDatabasesPath(), 'taskflow.db');

    return openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL,
        password_salt TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        priority INTEGER NOT NULL DEFAULT 2,
        is_completed INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('CREATE INDEX idx_tasks_user_id ON tasks (user_id)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<T> _guard<T>(String operation, Future<T> Function(Database db) fn) async {
    try {
      final db = await database;
      return await fn(db);
    } catch (e) {
      throw Exception('Falha ao $operation: $e');
    }
  }

  // --- Users ---

  Future<int> insertUser(UserModel user) {
    return _guard('inserir usuário', (db) {
      return db.insert('users', user.toMap());
    });
  }

  Future<UserModel?> getUserByEmail(String email) {
    return _guard('buscar usuário por e-mail', (db) async {
      final rows = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );
      if (rows.isEmpty) return null;
      return UserModel.fromMap(rows.first);
    });
  }

  Future<UserModel?> getUserById(int id) {
    return _guard('buscar usuário por id', (db) async {
      final rows = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (rows.isEmpty) return null;
      return UserModel.fromMap(rows.first);
    });
  }

  // --- Tasks ---

  Future<int> insertTask(TaskModel task) {
    return _guard('inserir tarefa', (db) {
      return db.insert('tasks', task.toMap());
    });
  }

  Future<List<TaskModel>> getTasksByUser(int userId) {
    return _guard('listar tarefas do usuário', (db) async {
      final rows = await db.query(
        'tasks',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'is_completed ASC, priority DESC, created_at DESC',
      );
      return rows.map(TaskModel.fromMap).toList();
    });
  }

  Future<int> updateTask(TaskModel task) {
    final taskId = task.id;
    if (taskId == null) {
      throw ArgumentError('Task id é obrigatório para atualização.');
    }
    return _guard('atualizar tarefa', (db) {
      final data = task.copyWith(updatedAt: DateTime.now()).toMap()..remove('id');
      return db.update(
        'tasks',
        data,
        where: 'id = ? AND user_id = ?',
        whereArgs: [taskId, task.userId],
      );
    });
  }

  Future<int> toggleTaskStatus(int taskId, int userId, bool isCompleted) {
    return _guard('alternar status da tarefa', (db) {
      return db.update(
        'tasks',
        {
          'is_completed': isCompleted ? 1 : 0,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ? AND user_id = ?',
        whereArgs: [taskId, userId],
      );
    });
  }

  Future<int> deleteTask(int taskId, int userId) {
    return _guard('excluir tarefa', (db) {
      return db.delete(
        'tasks',
        where: 'id = ? AND user_id = ?',
        whereArgs: [taskId, userId],
      );
    });
  }
}
