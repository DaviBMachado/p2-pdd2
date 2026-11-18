<!-- METADATA -->

```yaml
task: Implementar EmptyState em lib/widgets/empty_state.dart
status: done
priority: 20
dep: ["work/001-chore-project-and-design-system/003-feat-retro-analog-theme.md"]
assignee: ""
requiresHumanReview: false
expiresAt: null
```

<!-- DESCRIPTION -->

## Description

Criar `EmptyState` em `lib/widgets/empty_state.dart` com visual editorial *Retro Analog* para exibir quando não houver tarefas cadastradas ou quando o filtro ativo (`Pendentes`/`Concluídas`) não retornar resultados.

### Escopo
- **Inclui**: Ícone emoldurado com borda `#B8A98E` e fundo `#E8D7B5`, título em `Bricolage Grotesque`, subtítulo em `DM Sans` e botão opcional *Solid Retro*.
- **Não inclui**: Lógica de filtragem ou estado da Home.

### Skills Recomendadas
- `frontend-design` / `impeccable` — Composição minimalista e acolhedora sem poluição visual.

### Quando Parar o Desenvolvimento (Stop Conditions)
- Parar após `flutter analyze` passar sem erros.

### Comandos de Validação (Terminal)
```powershell
flutter analyze lib/widgets/empty_state.dart
```

<!-- ACCEPTANCE -->

## Acceptance criteria

- [x] `EmptyState` aceita `title`, `subtitle`, `icon` e ação opcional (`actionLabel`/`onAction`).
- [x] Usa exclusivamente tokens do `AppTheme`/`AppColors`.
- [x] `flutter analyze` passa sem erros.
