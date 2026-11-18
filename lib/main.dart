import 'package:flutter/material.dart';
import 'package:taskflow/models/user_model.dart';
import 'package:taskflow/screens/home_screen.dart';
import 'package:taskflow/screens/login_screen.dart';
import 'package:taskflow/services/auth_service.dart';
import 'package:taskflow/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.retroAnalog,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: AuthService.instance.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        final user = snapshot.hasError ? null : snapshot.data;
        if (user != null) {
          return HomeScreen(user: user);
        }
        return const LoginScreen();
      },
    );
  }
}
