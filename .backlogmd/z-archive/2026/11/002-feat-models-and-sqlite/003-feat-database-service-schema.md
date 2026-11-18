<!-- METADATA -->

```yaml
task: Implementar schema, versionamento e PRAGMA FK no DatabaseService
status: done
priority: 30
dep:
  - "work/002-feat-models-and-sqlite/001-feat-user-model.md"
  - "work/002-feat-models-and-sqlite/002-feat-task-model.md"
assignee: ""
requiresHumanReview: false
expiresAt: null
```

<!-- DESCRIPTION -->

## Description

Criar `lib/services/database_service.dart` como singleton gerenciando o ciclo de vida do banco SQLite (`taskflow.db`, `version: 1`) via `sqflite` e `path`. Deve habilitar `PRAGMA foreign_keys = ON` no `onConfigure`, criar tabelas `users`, `tasks` e índice `idx_tasks_user_id` no `onCreate`, e definir `onUpgrade`.

### Escopo
- **Inclui**: Singleton `DatabaseService.instance`, getter `database`, `_initDatabase`, `onConfigure` (`PRAGMA foreign_keys = ON`), `onCreate` (DDL completo), `onUpgrade` preparado.
- **Não inclui**: Métodos CRUD (task `004`).

### Skills Recomendadas
- `SQLite Database Expert` — Boas práticas de `sqflite`, `onConfigure` e migrations.
- `database-schema-designer` — Constraints (`UNIQUE`, `NOT NULL`, `FOREIGN KEY ... ON DELETE CASCADE`) e índice.

### Quando Parar o Desenvolvimento (Stop Conditions)
- Parar se `PRAGMA foreign_keys = ON` não estiver no `onConfigure` (não colocar apenas no `onCreate`, pois precisa rodar a cada abertura do banco).
- Parar após `flutter analyze` passar sem erros.

### Comandos de Validação (Terminal)
```powershell
flutter analyze lib/services/database_service.dart
```

<!-- ACCEPTANCE -->

## Acceptance criteria

- [x] `DatabaseService` implementa singleton com abertura preguiçosa e segura de `taskflow.db`.
- [x] `onConfigure` executa `await db.execute('PRAGMA foreign_keys = ON')`.
- [x] `onCreate` cria `users` (com `email TEXT NOT NULL UNIQUE`), `tasks` (com `FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE`) e `idx_tasks_user_id`.
- [x] `flutter analyze lib/services/database_service.dart` passa sem erros.
