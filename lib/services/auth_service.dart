import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import 'database_service.dart';

/// Exceção lançada quando ocorre algum erro de validação ou autenticação.
class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => message;
}

/// Gerencia cadastro, login, hash de senha e sessão do usuário autenticado.
class AuthService {
  static const _sessionKey = 'current_user_id';
  static const _hashIterations = 10000;
  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final AuthService instance = AuthService();

  /// Valida o formato do e-mail para formulários; retorna null se for válido.
  static String? validateEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Informe seu e-mail';
    if (!_emailRegex.hasMatch(trimmed)) return 'Informe um e-mail válido';
    return null;
  }

  final DatabaseService _db;

  AuthService({DatabaseService? db}) : _db = db ?? DatabaseService.instance;

  /// Gera um salt aleatório de 16 bytes codificado em base64.
  String generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64Encode(bytes);
  }

  /// Gera o hash da senha combinada ao [salt] usando SHA-256 repetido.
  String hashPassword(String password, String salt) {
    List<int> digest = utf8.encode('$salt:$password');
    for (var i = 0; i < _hashIterations; i++) {
      digest = sha256.convert(digest).bytes;
    }
    return base64Encode(digest);
  }

  /// Verifica se a [password] informada corresponde ao [expectedHash].
  bool verifyPassword(String password, String salt, String expectedHash) {
    final actualBytes = utf8.encode(hashPassword(password, salt));
    final expectedBytes = utf8.encode(expectedHash);
    if (actualBytes.length != expectedBytes.length) return false;

    // Compara byte a byte sem parar cedo para evitar vazamento por tempo de resposta.
    var diff = 0;
    for (var i = 0; i < actualBytes.length; i++) {
      diff |= actualBytes[i] ^ expectedBytes[i];
    }
    return diff == 0;
  }

  /// Valida os dados, cria um novo usuário no SQLite e inicia a sessão.
  Future<UserModel> register(String name, String email, String password) async {
    final trimmedName = name.trim();
    if (trimmedName.length < 3) {
      throw const AuthException('O nome deve ter pelo menos 3 caracteres.');
    }

    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty || !normalizedEmail.contains('@')) {
      throw const AuthException('Informe um e-mail válido.');
    }

    if (password.length < 6) {
      throw const AuthException('A senha deve ter pelo menos 6 caracteres.');
    }

    final existing = await _db.getUserByEmail(normalizedEmail);
    if (existing != null) {
      throw const AuthException('Este e-mail já está cadastrado.');
    }

    final salt = generateSalt();
    final hash = hashPassword(password, salt);
    final createdAt = DateTime.now();

    final id = await _db.insertUser(
      UserModel(
        name: trimmedName,
        email: normalizedEmail,
        passwordHash: hash,
        passwordSalt: salt,
        createdAt: createdAt,
      ),
    );

    final user = UserModel(
      id: id,
      name: trimmedName,
      email: normalizedEmail,
      passwordHash: hash,
      passwordSalt: salt,
      createdAt: createdAt,
    );

    await _saveSession(id);
    return user;
  }

  /// Autentica o usuário pelo e-mail e senha e salva a sessão localmente.
  Future<UserModel> login(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty || password.isEmpty) {
      throw const AuthException('E-mail ou senha inválidos.');
    }

    final user = await _db.getUserByEmail(normalizedEmail);
    if (user == null ||
        !verifyPassword(password, user.passwordSalt, user.passwordHash)) {
      throw const AuthException('E-mail ou senha inválidos.');
    }

    if (user.id != null) {
      await _saveSession(user.id!);
    }
    return user;
  }

  /// Retorna o usuário da sessão atual ou null se não houver sessão válida.
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(_sessionKey);
    if (userId == null) return null;

    final user = await _db.getUserById(userId);
    if (user == null) {
      await prefs.remove(_sessionKey);
      return null;
    }
    return user;
  }

  /// Remove o identificador da sessão atual das preferências locais.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  /// Salva o ID do usuário autenticado nas preferências locais.
  Future<void> _saveSession(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sessionKey, userId);
  }
}
