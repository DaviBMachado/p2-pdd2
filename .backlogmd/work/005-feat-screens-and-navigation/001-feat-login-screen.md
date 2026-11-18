<!-- METADATA -->

```yaml
task: Implementar LoginScreen em lib/screens/login_screen.dart
status: done
priority: 10
dep:
  - "work/003-feat-auth-and-session/003-feat-session-persistence.md"
  - "work/004-feat-retro-analog-widgets/001-feat-custom-text-field.md"
assignee: ""
requiresHumanReview: false
expiresAt: null
```

<!-- DESCRIPTION -->

## Description

Criar `LoginScreen` em `lib/screens/login_screen.dart` com identidade *Retro Analog*: cabeçalho editorial TaskFlow, campos de e-mail e senha (com toggle de visibilidade via `CustomTextField`), validação de campos obrigatórios e formato de e-mail, botão *Solid Retro* "Entrar" com estado de carregamento, exibição clara de erro para credenciais inválidas, navegação para `RegisterScreen` e redirecionamento para `HomeScreen` com `pushAndRemoveUntil`.

### Escopo
- **Inclui**: Formulário completo de login, feedback de carregamento/erro, navegação para cadastro e `HomeScreen`.
- **Não inclui**: Login social ou recuperação de senha.

### Skills Recomendadas
- `frontend-design` / `ui-design-patterns` — Layout mobile-first centralizado com `SafeArea` e `SingleChildScrollView`.
- `cybersecurity` — Tratamento seguro de credenciais e limpeza de pilha pós-login.

### Quando Parar o Desenvolvimento (Stop Conditions)
- Parar se `LoginScreen` permitir retorno após autenticar (falta de `pushAndRemoveUntil`) ou não verificar `mounted` após `await`.
- Parar após `flutter analyze` passar sem erros.

### Comandos de Validação (Terminal)
```powershell
flutter analyze lib/screens/login_screen.dart
```

<!-- ACCEPTANCE -->

## Acceptance criteria

- [x] Valida e-mail obrigatório + formato válido e senha obrigatória.
- [x] Exibe loading durante autenticação e mensagem clara em erro de credenciais.
- [x] Navega para `RegisterScreen` ao tocar no link de cadastro.
- [x] Navega para `HomeScreen` usando `pushAndRemoveUntil` após login válido.
- [x] `flutter analyze` passa sem erros.
