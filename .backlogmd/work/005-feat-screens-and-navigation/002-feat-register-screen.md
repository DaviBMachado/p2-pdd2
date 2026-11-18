<!-- METADATA -->

```yaml
task: Implementar RegisterScreen em lib/screens/register_screen.dart
status: done
priority: 20
dep:
  - "work/003-feat-auth-and-session/003-feat-session-persistence.md"
  - "work/004-feat-retro-analog-widgets/001-feat-custom-text-field.md"
assignee: ""
requiresHumanReview: false
expiresAt: null
```

<!-- DESCRIPTION -->

## Description

Criar `RegisterScreen` em `lib/screens/register_screen.dart` com campos: nome completo (mín. 3 chars após `trim()`), e-mail (formato válido), senha (mín. 6 chars, toggle visibilidade) e confirmação de senha (idêntica à senha, toggle visibilidade). Ao cadastrar com sucesso, exibe feedback e navega diretamente para `HomeScreen` limpando a pilha.

### Escopo
- **Inclui**: Validações inline, tratamento de e-mail já cadastrado (`AuthException`), feedback visual e `pushAndRemoveUntil` para `HomeScreen`.
- **Não inclui**: Confirmação por e-mail externo.

### Skills Recomendadas
- `frontend-design` / `ui-design-patterns` — Formulário claro e responsivo com `SafeArea` e `SingleChildScrollView`.
- `cybersecurity` — Validação de tamanho mínimo e tratamento de e-mail duplicado.

### Quando Parar o Desenvolvimento (Stop Conditions)
- Parar se a confirmação de senha não validar igualdade ou se o cadastro não redirecionar para `HomeScreen` com sessão ativa.
- Parar após `flutter analyze` passar sem erros.

### Comandos de Validação (Terminal)
```powershell
flutter analyze lib/screens/register_screen.dart
```

<!-- ACCEPTANCE -->

## Acceptance criteria

- [x] Nome valida mínimo de 3 caracteres após `trim()`.
- [x] E-mail valida formato e trata erro de duplicidade com mensagem compreensível.
- [x] Senha valida mínimo de 6 caracteres e correspondência exata com confirmação.
- [x] Cadastro bem-sucedido grava sessão e navega para `HomeScreen` com `pushAndRemoveUntil`.
- [x] `flutter analyze` passa sem erros.
