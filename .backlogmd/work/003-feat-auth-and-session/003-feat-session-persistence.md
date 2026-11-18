<!-- METADATA -->

```yaml
task: Implementar persistência de sessão (SharedPreferences) e logout no AuthService
status: done
priority: 30
dep: ["work/003-feat-auth-and-session/002-feat-auth-register-login.md"]
assignee: ""
requiresHumanReview: false
expiresAt: null
```

<!-- DESCRIPTION -->

## Description

Integrar `SharedPreferences` ao `AuthService` para salvar `current_user_id` ao finalizar `register` e `login`, implementar `getCurrentUser()` (lendo `current_user_id` e validando no SQLite com `getUserById`) e `logout()` (removendo a chave e limpando qualquer sessão órfã).

### Escopo
- **Inclui**: Persistência automática de sessão em `login` e `register`, `getCurrentUser()`, `logout()`.
- **Não inclui**: Telas ou `Navigator`.

### Skills Recomendadas
- `cybersecurity` — Validação da sessão contra o banco para evitar sessão órfã.
- `ponytail` — Chave única `current_user_id` no `SharedPreferences`, sem estado duplicado.

### Quando Parar o Desenvolvimento (Stop Conditions)
- Parar se `getCurrentUser()` retornar verdadeiro sem consultar `DatabaseService.getUserById`.
- Parar após `flutter analyze` passar limpo.

### Comandos de Validação (Terminal)
```powershell
flutter analyze lib/services/auth_service.dart
```

<!-- ACCEPTANCE -->

## Acceptance criteria

- [x] `login` e `register` gravam `current_user_id` no `SharedPreferences` após sucesso.
- [x] `getCurrentUser()` retorna `UserModel?` somente se o ID existir no `SharedPreferences` E no SQLite; caso inválido no SQLite, limpa a chave.
- [x] `logout()` remove `current_user_id` do `SharedPreferences`.
- [x] `flutter analyze` passa sem erros.
