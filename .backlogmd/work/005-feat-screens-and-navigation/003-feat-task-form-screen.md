<!-- METADATA -->

```yaml
task: Implementar TaskFormScreen em lib/screens/task_form_screen.dart
status: done
priority: 30
dep:
  - "work/002-feat-models-and-sqlite/004-feat-database-service-queries.md"
  - "work/004-feat-retro-analog-widgets/004-feat-task-form.md"
assignee: ""
requiresHumanReview: false
expiresAt: null
```

<!-- DESCRIPTION -->

## Description

Criar `TaskFormScreen` em `lib/screens/task_form_screen.dart` recebendo o usuário autenticado (`UserModel` ou `userId`) e `TaskModel? task` opcional (nulo = criação; preenchido = edição). Deve encapsular `TaskForm`, persistir no SQLite via `DatabaseService` (`insertTask` ou `updateTask`), tratar erros e retornar `true` via `Navigator.pop(context, true)` com feedback.

### Escopo
- **Inclui**: AppBar *Retro Analog* ("Nova Tarefa" ou "Editar Tarefa"), verificação de sessão válida, persistência via `DatabaseService`, feedback de erro via `SnackBar` e retorno com `pop`.
- **Não inclui**: Lógica de listagem ou exclusão.

### Skills Recomendadas
- `codebase-design` — Responsabilidade clara de orquestração entre `TaskForm` e `DatabaseService`.
- `ponytail` — Reutilização total do `TaskForm` sem duplicar campos.

### Quando Parar o Desenvolvimento (Stop Conditions)
- Parar se `TaskFormScreen` não associar `userId` corretamente ao criar tarefa ou não atualizar `updatedAt` ao editar.
- Parar após `flutter analyze` passar sem erros.

### Comandos de Validação (Terminal)
```powershell
flutter analyze lib/screens/task_form_screen.dart
```

<!-- ACCEPTANCE -->

## Acceptance criteria

- [x] Título da AppBar alterna entre criação e edição conforme `task == null`.
- [x] Salva nova tarefa associada ao `userId` autenticado ou atualiza tarefa existente respeitando isolamento.
- [x] Trata exceções de banco exibindo `SnackBar` amigável sem travar a tela.
- [x] Retorna `true` no `Navigator.pop` após salvar com sucesso.
- [x] `flutter analyze` passa sem erros.
