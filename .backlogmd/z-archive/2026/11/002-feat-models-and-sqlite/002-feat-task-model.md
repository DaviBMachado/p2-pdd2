<!-- METADATA -->

```yaml
task: Implementar TaskModel em lib/models/task_model.dart
status: done
priority: 20
dep: ["work/001-chore-project-and-design-system/001-chore-flutter-project-init.md"]
assignee: ""
requiresHumanReview: false
expiresAt: null
```

<!-- DESCRIPTION -->

## Description

Criar a classe `TaskModel` em `lib/models/task_model.dart` com mapeamento para a tabela `tasks`, suporte à prioridade inteira (`1=Baixa`, `2=Média`, `3=Alta`), `isCompleted` (`bool` ↔ `0|1`), `fromMap`, `toMap` e `copyWith`.

### Escopo
- **Inclui**: Campos (`id`, `userId`, `title`, `description`, `priority`, `isCompleted`, `createdAt`, `updatedAt`), helpers de rótulo de prioridade (`Baixa`, `Média`, `Alta`), `fromMap`, `toMap`, `copyWith`.
- **Não inclui**: Widgets visuais de badge ou chamadas SQLite.

### Skills Recomendadas
- `codebase-design` — Encapsular conversão `0/1` e rótulos de prioridade no próprio modelo.
- `ponytail` — Evitar classes extras desnecessárias se um enum/helper simples no próprio arquivo resolver.

### Quando Parar o Desenvolvimento (Stop Conditions)
- Parar após `flutter analyze` passar limpo em `lib/models/task_model.dart`.

### Comandos de Validação (Terminal)
```powershell
flutter analyze lib/models/task_model.dart
```

<!-- ACCEPTANCE -->

## Acceptance criteria

- [x] `TaskModel` mapeia `is_completed` (`int` `0`/`1`) ↔ `bool` e `priority` (`1`, `2`, `3`).
- [x] Possui `copyWith` facilitando atualizações imutáveis na edição e alternância de status.
- [x] `created_at` e `updated_at` serializados em ISO-8601.
- [x] `flutter analyze lib/models/task_model.dart` passa sem erros.
