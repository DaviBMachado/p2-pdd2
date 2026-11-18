<!-- METADATA -->

```yaml
task: Implementar Paper Card de tarefa em lib/widgets/task_card.dart
status: done
priority: 30
dep:
  - "work/001-chore-project-and-design-system/003-feat-retro-analog-theme.md"
  - "work/002-feat-models-and-sqlite/002-feat-task-model.md"
assignee: ""
requiresHumanReview: false
expiresAt: null
```

<!-- DESCRIPTION -->

## Description

Criar `TaskCard` em `lib/widgets/task_card.dart` como um *Paper Card* (`#FFF9ED`, borda `#B8A98E`) exibindo: checkbox/botão de status à esquerda, título e descrição opcional (com `lineThrough` e opacidade reduzida quando concluída), badge de prioridade em `Space Mono` (`ALTA` em `#D96C3B`, `MÉDIA` em `#E8D7B5`, `BAIXA` em `#68734B`), data formatada em `Space Mono` e ícone de lixeira para exclusão.

### Escopo
- **Inclui**: Callbacks `onToggleStatus`, `onTap` (editar) e `onDelete`; microinteração discreta (`AnimatedContainer`/`AnimatedOpacity`).
- **Não inclui**: Diálogo de confirmação de exclusão (responsabilidade da `HomeScreen`) ou chamadas diretas ao `DatabaseService`.

### Skills Recomendadas
- `frontend-design` / `high-end-visual-design` — Estética *Paper Card* limpa, hierarquia clara e áreas de toque adequadas.
- `ponytail` — Sem lógica de banco dentro do widget visual.

### Quando Parar o Desenvolvimento (Stop Conditions)
- Parar se o card importar `DatabaseService` diretamente ou usar cores fora da paleta oficial.
- Parar após `flutter analyze` passar sem erros.

### Comandos de Validação (Terminal)
```powershell
flutter analyze lib/widgets/task_card.dart
```

<!-- ACCEPTANCE -->

## Acceptance criteria

- [x] Exibe título, descrição (quando presente), badge de prioridade em `Space Mono` e data.
- [x] Diferencia visualmente tarefa concluída (risco no título, opacidade suave, checkbox marcado em `#68734B`).
- [x] Expõe `onToggleStatus`, `onTap` e `onDelete` com áreas de toque ≥ 48dp.
- [x] `flutter analyze` passa sem erros.
