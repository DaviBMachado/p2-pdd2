<!-- METADATA -->

```yaml
work: Autenticação Segura e Gerenciamento de Sessão
status: done
assignee: ""
```

<!-- DESCRIPTION -->

Implementação do `AuthService` em `lib/services/auth_service.dart` com geração de salt criptográfico (`Random.secure()`), hash `SHA-256` iterado (`crypto`), cadastro, login, normalização de e-mail, persistência de sessão (`SharedPreferences`) validada contra o SQLite e logout.

<!-- CONTEXT -->

- **Regras**:
  - Nunca armazenar senha em texto puro.
  - E-mail sempre normalizado com `trim().toLowerCase()`.
  - Nome ≥ 3 caracteres (após `trim()`), senha ≥ 6 caracteres.
  - Sessão salva `current_user_id` (`int`) no `SharedPreferences` e valida existência via `DatabaseService.getUserById`.
