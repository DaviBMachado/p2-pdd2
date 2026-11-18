<!-- METADATA -->

```yaml
task: Implementar register e login com validação de e-mail duplicado no AuthService
status: done
priority: 20
dep:
  - "work/003-feat-auth-and-session/001-feat-password-hashing.md"
  - "work/002-feat-models-and-sqlite/004-feat-database-service-queries.md"
assignee: ""
requiresHumanReview: false
expiresAt: null
```

<!-- DESCRIPTION -->

## Description

Implementar os métodos `register(String name, String email, String password)` e `login(String email, String password)` no `AuthService`, aplicando normalização de e-mail (`trim().toLowerCase()`), verificação de e-mail já cadastrado, hash+salt no cadastro e validação de credenciais no login.

### Escopo
- **Inclui**: `register` e `login` retornando `UserModel`, classe de exceção amigável (`AuthException`) para erros de negócio (e-mail já cadastrado, credenciais inválidas).
- **Não inclui**: UI de formulários ou `SharedPreferences` (task `003`).

### Skills Recomendadas
- `cybersecurity` — Mensagem genérica de erro no login (*"E-mail ou senha inválidos"*) para não enumerar contas existentes.
- `codebase-design` — Tratamento claro de erros via `AuthException`.

### Quando Parar o Desenvolvimento (Stop Conditions)
- Parar se `register` não verificar duplicidade de e-mail antes/durante inserção ou se `login` revelar qual campo falhou (e-mail vs. senha).
- Parar após `flutter analyze` passar sem erros.

### Comandos de Validação (Terminal)
```powershell
flutter analyze lib/services/auth_service.dart
```

<!-- ACCEPTANCE -->

## Acceptance criteria

- [x] `register` normaliza e-mail, rejeita e-mail já existente com `AuthException` e salva usuário com `password_hash` + `password_salt`.
- [x] `login` normaliza e-mail, verifica hash+salt e lança `AuthException` com mensagem clara e genérica em caso de falha.
- [x] Nenhuma senha em texto puro é logada ou persistida.
- [x] `flutter analyze` passa sem erros.
