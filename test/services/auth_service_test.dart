import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:taskflow/services/auth_service.dart';
import 'package:taskflow/services/database_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late AuthService auth;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    auth = AuthService.instance;
    final db = await DatabaseService.instance.database;
    await db.delete('users');
  });

  group('AuthService hashing', () {
    test('generateSalt produces unique 16-byte base64 salts', () {
      final s1 = auth.generateSalt();
      final s2 = auth.generateSalt();
      expect(s1, isNot(equals(s2)));
      expect(s1.length, 24); // 16 bytes in base64
    });

    test('hashPassword and verifyPassword validate matching credentials', () {
      final salt = auth.generateSalt();
      final hash = auth.hashPassword('secret123', salt);

      expect(hash, isNot(equals('secret123')));
      expect(auth.verifyPassword('secret123', salt, hash), isTrue);
      expect(auth.verifyPassword('wrong123', salt, hash), isFalse);
      expect(auth.verifyPassword('secret123', auth.generateSalt(), hash), isFalse);
    });
  });

  group('AuthService register, login and session', () {
    test('register validates inputs, normalizes email and persists session', () async {
      await expectLater(
        auth.register('Ab', 'user@example.com', '123456'),
        throwsA(isA<AuthException>()),
      );
      await expectLater(
        auth.register('Ana', 'invalid', '123456'),
        throwsA(isA<AuthException>()),
      );
      await expectLater(
        auth.register('Ana', 'user@example.com', '12345'),
        throwsA(isA<AuthException>()),
      );

      final user = await auth.register('  Ana Silva  ', '  ANA@Example.COM ', '123456');
      expect(user.id, isNotNull);
      expect(user.name, 'Ana Silva');
      expect(user.email, 'ana@example.com');
      expect(user.passwordHash, isNot('123456'));

      final current = await auth.getCurrentUser();
      expect(current?.id, user.id);

      await expectLater(
        auth.register('Outra', 'ana@example.com', '123456'),
        throwsA(isA<AuthException>()),
      );
    });

    test('login validates credentials with generic error and manages session', () async {
      await auth.register('Carlos', 'carlos@example.com', '123456');
      await auth.logout();
      expect(await auth.getCurrentUser(), isNull);

      await expectLater(
        auth.login('carlos@example.com', 'wrongpass'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            'E-mail ou senha inválidos.',
          ),
        ),
      );
      await expectLater(
        auth.login('missing@example.com', '123456'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            'E-mail ou senha inválidos.',
          ),
        ),
      );

      final loggedIn = await auth.login('  CARLOS@example.com ', '123456');
      expect(loggedIn.email, 'carlos@example.com');
      expect((await auth.getCurrentUser())?.id, loggedIn.id);
    });

    test('getCurrentUser clears orphan session if user is missing in SQLite', () async {
      SharedPreferences.setMockInitialValues({'current_user_id': 99999});
      expect(await auth.getCurrentUser(), isNull);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey('current_user_id'), isFalse);
    });
  });
}
