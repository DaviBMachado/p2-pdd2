<!-- METADATA -->

```yaml
task: Implementar HomeScreen com indicadores, CRUD e Retro Dock em lib/screens/home_screen.dart
status: done
priority: 40
dep:
  - "work/003-feat-auth-and-session/003-feat-session-persistence.md"
  - "work/004-feat-retro-analog-widgets/002-feat-empty-state.md"
  - "work/004-feat-retro-analog-widgets/003-feat-task-card.md"
  - "work/005-feat-screens-and-navigation/003-feat-task-form-screen.md"
assignee: ""
requiresHumanReview: false
expiresAt: null
```

<!-- DESCRIPTION -->

## Description

Criar `HomeScreen` em `lib/screens/home_screen.dart` como painel principal autenticado: AppBar com nome do usuário e botão Logout (encerramento direto sem modal → `pushAndRemoveUntil` para `LoginScreen`), 3 contadores gerais em `Space Mono` (Total, Pendentes, Concluídas — sempre refletindo todas as tarefas do usuário), listagem dinâmica com `TaskCard`/`EmptyState`, alternância rápida de status, `AlertDialog` de confirmação antes de excluir, FAB *Solid Retro* para `TaskFormScreen` e barra inferior **Retro Dock** para os filtros (`Todas`, `Pendentes`, `Concluídas`).

### Escopo
- **Inclui**: Carregamento assíncrono de tarefas do usuário (`DatabaseService.getTasksByUser`), filtro em memória preservando os contadores gerais, exclusão com `AlertDialog`, atualização automática após CRUD, proteção de rota caso sessão esteja inválida e `Retro Dock`.
- **Não inclui**: Tela de perfil ou modal de confirmação no logout.

### Skills Recomendadas
- `frontend-design` / `impeccable` — Estética *Retro Analog* com *Retro Dock*, *Paper Cards* e contadores `Space Mono`.
- `cybersecurity` — Garantir isolamento por `user.id` e redirecionamento imediato no logout.

### Quando Parar o Desenvolvimento (Stop Conditions)
- Parar se os contadores mudarem quando o filtro `Pendentes`/`Concluídas` for selecionado (devem sempre mostrar os totais gerais).
- Parar se exclusão ocorrer sem `AlertDialog` de confirmação ou se logout exibir modal.
- Parar após `flutter analyze` passar sem erros.

### Comandos de Validação (Terminal)
```powershell
flutter analyze lib/screens/home_screen.dart
```

<!-- ACCEPTANCE -->

## Acceptance criteria

- [x] Exibe nome do usuário autenticado e botão de Logout direto (sem `AlertDialog`).
- [x] Contadores Total, Pendentes e Concluídas em `Space Mono` sempre refletem todas as tarefas do usuário.
- [x] Barra inferior *Retro Dock* filtra corretamente entre `Todas`, `Pendentes` e `Concluídas`.
- [x] Toque no card abre `TaskFormScreen` em edição; checkbox alterna status; lixeira pede confirmação em `AlertDialog` antes de excluir.
- [x] Lista vazia ou filtro sem resultados exibe `EmptyState` contextual.
- [x] `flutter analyze` passa sem erros.
