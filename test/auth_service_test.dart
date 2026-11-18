import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/services/auth_service.dart';

void main() {
  final authService = AuthService();

  group('AuthService cryptography', () {
    test('generateSalt produces distinct non-empty values', () {
      final salt1 = authService.generateSalt();
      final salt2 = authService.generateSalt();

      expect(salt1, isNotEmpty);
      expect(salt2, isNotEmpty);
      expect(salt1, isNot(equals(salt2)));
    });

    test('hashPassword never returns plaintext and is deterministic per salt', () {
      const password = 'secret-password-123';
      final salt1 = authService.generateSalt();
      final salt2 = authService.generateSalt();

      final hash1a = authService.hashPassword(password, salt1);
      final hash1b = authService.hashPassword(password, salt1);
      final hash2 = authService.hashPassword(password, salt2);

      expect(hash1a, isNot(equals(password)));
      expect(hash1a, equals(hash1b));
      expect(hash1a, isNot(equals(hash2)));
    });

    test('verifyPassword returns true for valid password and false otherwise', () {
      const password = 'my-strong-password';
      final salt = authService.generateSalt();
      final hash = authService.hashPassword(password, salt);

      expect(authService.verifyPassword(password, salt, hash), isTrue);
      expect(authService.verifyPassword('wrong-password', salt, hash), isFalse);
      expect(authService.verifyPassword(password, 'wrong-salt', hash), isFalse);
    });
  });
}
