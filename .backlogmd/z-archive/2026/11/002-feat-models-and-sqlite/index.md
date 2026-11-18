<!-- METADATA -->

```yaml
work: Modelos de Domínio e Persistência SQLite
status: done
assignee: ""
```

<!-- DESCRIPTION -->

Implementação das entidades `UserModel` e `TaskModel` e do serviço `DatabaseService` utilizando `sqflite` e `path`, com versionamento v1, `PRAGMA foreign_keys = ON`, índice em `tasks(user_id)` e operações CRUD estritamente isoladas por usuário.

<!-- CONTEXT -->

- **Tabelas**:
  - `users`: `id` (PK), `name`, `email` (UNIQUE), `password_hash`, `password_salt`, `created_at` (ISO-8601 TEXT).
  - `tasks`: `id` (PK), `user_id` (FK → `users.id` `ON DELETE CASCADE`), `title`, `description`, `priority` (`1=Baixa, 2=Média, 3=Alta`), `is_completed` (`0|1`), `created_at`, `updated_at`.
- **Ordenação padrão**: `ORDER BY is_completed ASC, priority DESC, created_at DESC`.
- **Segurança**: Queries 100% parametrizadas (`?` / `whereArgs`), nunca concatenação de strings SQL.
