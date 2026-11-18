<!-- METADATA -->

```yaml
task: Implementar formulário reutilizável TaskForm em lib/widgets/task_form.dart
status: done
priority: 40
dep:
  - "work/004-feat-retro-analog-widgets/001-feat-custom-text-field.md"
  - "work/002-feat-models-and-sqlite/002-feat-task-model.md"
assignee: ""
requiresHumanReview: false
expiresAt: null
```

<!-- DESCRIPTION -->

## Description

Criar `TaskForm` em `lib/widgets/task_form.dart` reutilizável tanto para criação quanto para edição de tarefas. Campos: título (obrigatório após `trim()`, máx. 100 chars), descrição (opcional, máx. 500 chars), seletor de prioridade (`Baixa`, `Média`, `Alta` — iniciando em `Média`), seletor/switch de status (`Pendente`/`Concluída` — iniciando em `Pendente`) e botão *Solid Retro* "Salvar" com estado de carregamento.

### Escopo
- **Inclui**: `GlobalKey<FormState>`, preenchimento inicial via `initialTask` opcional, validações de título/descrição e callback `onSubmit(String title, String? description, int priority, bool isCompleted)`.
- **Não inclui**: Navegação (`Navigator`) ou chamadas ao `DatabaseService`.

### Skills Recomendadas
- `ui-design-patterns` — Validação inline clara e seletores táteis acessíveis.
- `ponytail` — Formulário único para criar/editar sem duplicação.

### Quando Parar o Desenvolvimento (Stop Conditions)
- Parar se `TaskForm` acoplar `Navigator` ou `DatabaseService` diretamente.
- Parar após `flutter analyze` passar sem erros.

### Comandos de Validação (Terminal)
```powershell
flutter analyze lib/widgets/task_form.dart
```

<!-- ACCEPTANCE -->

## Acceptance criteria

- [x] Título validado como obrigatório (`trim().isNotEmpty`) e limitado a 100 caracteres; descrição limitada a 500 caracteres.
- [x] Modo criação inicia com Prioridade = `Média` (`2`) e Status = `Pendente` (`false`).
- [x] Modo edição pré-carrega todos os dados de `initialTask`.
- [x] Botão exibe `CircularProgressIndicator` quando `isLoading: true` e bloqueia duplo envio.
- [x] `flutter analyze` passa sem erros.
