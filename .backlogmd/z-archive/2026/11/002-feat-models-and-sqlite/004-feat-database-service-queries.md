<!-- METADATA -->

```yaml
task: Implementar operações CRUD parametrizadas e isoladas no DatabaseService
status: done
priority: 40
dep: ["work/002-feat-models-and-sqlite/003-feat-database-service-schema.md"]
assignee: ""
requiresHumanReview: false
expiresAt: null
```

<!-- DESCRIPTION -->

## Description

Adicionar em `lib/services/database_service.dart` todas as operações de leitura e escrita para usuários e tarefas, utilizando exclusivamente queries parametrizadas e garantindo isolamento estrito por `user_id` em toda operação de tarefa.

### Escopo
- **Inclui**:
  - Usuários: `insertUser(UserModel)`, `getUserByEmail(String)`, `getUserById(int)`.
  - Tarefas: `insertTask(TaskModel)`, `getTasksByUser(int userId)` (ordenado por `is_completed ASC, priority DESC, created_at DESC`), `updateTask(TaskModel)` (filtrando `id = ? AND user_id = ?`), `toggleTaskStatus(int taskId, int userId, bool isCompleted)` (atualizando `updated_at`), `deleteTask(int taskId, int userId)`.
  - Tratamento de erros de leitura/escrita lançando exceções descritivas.
- **Não inclui**: Lógica de hash ou sessão.

### Skills Recomendadas
- `SQLite Database Expert` — Prevenção de SQL injection e transações seguras.
- `cybersecurity` — Garantir cláusula `AND user_id = ?` em `update`, `toggle` e `delete`.

### Quando Parar o Desenvolvimento (Stop Conditions)
- Parar se qualquer query usar interpolação de string em vez de `whereArgs` / placeholders `?`.
- Parar após `flutter analyze` passar sem erros.

### Comandos de Validação (Terminal)
```powershell
flutter analyze lib/services/database_service.dart
```

<!-- ACCEPTANCE -->

## Acceptance criteria

- [x] Todos os métodos CRUD de `users` e `tasks` implementados com `whereArgs` parametrizados.
- [x] `getTasksByUser` ordena por `is_completed ASC, priority DESC, created_at DESC`.
- [x] `updateTask`, `toggleTaskStatus` e `deleteTask` exigem e filtram por `user_id` além de `id`.
- [x] `updateTask` e `toggleTaskStatus` atualizam `updated_at` com timestamp atual.
- [x] `flutter analyze` passa sem erros.
