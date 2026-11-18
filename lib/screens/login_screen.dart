import 'package:flutter/material.dart';
import 'package:taskflow/services/auth_service.dart';
import 'package:taskflow/theme/app_theme.dart';
import 'package:taskflow/widgets/custom_text_field.dart';
import 'package:taskflow/widgets/error_banner.dart';

import 'home_screen.dart';
import 'register_screen.dart';

/// Tela de login com validação de formulário e tratamento de erros.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Valida os campos, autentica o usuário e navega para a Home.
  Future<void> _submit() async {
    if (_isLoading || !(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await AuthService.instance.login(
        _emailController.text,
        _passwordController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
        (_) => false,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Não foi possível entrar. Tente novamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingMd * 1.5),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('TaskFlow', style: textTheme.headlineLarge),
                    const SizedBox(height: AppTheme.spacingSm / 2),
                    Text(
                      'Organize seu dia com foco analógico.',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppTheme.spacingMd * 1.5),
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingMd),
                      decoration: AppTheme.paperCardDecoration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomTextField(
                            controller: _emailController,
                            label: 'E-mail',
                            hint: 'voce@exemplo.com',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            prefixIcon: Icons.email_outlined,
                            validator: AuthService.validateEmail,
                          ),
                          const SizedBox(height: AppTheme.spacingMd),
                          CustomTextField(
                            controller: _passwordController,
                            label: 'Senha',
                            isPassword: true,
                            textInputAction: TextInputAction.done,
                            prefixIcon: Icons.lock_outline,
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                    ? 'Informe sua senha'
                                    : null,
                          ),
                          if (_errorMessage != null) ...[
                            const SizedBox(height: AppTheme.spacingMd),
                            ErrorBanner(message: _errorMessage!),
                          ],
                          const SizedBox(height: AppTheme.spacingMd * 1.25),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.surface,
                                    ),
                                  )
                                : const Text('Entrar'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingMd),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              );
                            },
                      child: const Text('Não tem conta? Cadastre-se'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
