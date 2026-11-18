<!-- METADATA -->

```yaml
task: Implementar main.dart com checagem de sessão e tema Retro Analog
status: done
priority: 50
dep:
  - "work/001-chore-project-and-design-system/003-feat-retro-analog-theme.md"
  - "work/005-feat-screens-and-navigation/001-feat-login-screen.md"
  - "work/005-feat-screens-and-navigation/004-feat-home-screen-and-dock.md"
assignee: ""
requiresHumanReview: false
expiresAt: null
```

<!-- DESCRIPTION -->

## Description

Configurar `lib/main.dart` com `WidgetsFlutterBinding.ensureInitialized()`, aplicar `AppTheme.retroAnalog` no `MaterialApp`, e implementar o widget inicial de verificação de sessão (`AuthGate` / `FutureBuilder` chamando `AuthService.getCurrentUser()`) exibindo indicador de carregamento em `#F4EBD8`/`#D96C3B` e direcionando para `HomeScreen` (se sessão válida) ou `LoginScreen` (se ausente/inválida).

### Escopo
- **Inclui**: `main()`, `TaskFlowApp`, checagem inicial de sessão, proteção contra estado de erro na inicialização.
- **Não inclui**: Lógica de negócio adicional.

### Skills Recomendadas
- `codebase-design` — Ponto de entrada limpo e previsível.
- `ponytail` — Sem rotas nomeadas complexas desnecessárias.

### Quando Parar o Desenvolvimento (Stop Conditions)
- Parar se `WidgetsFlutterBinding.ensureInitialized()` estiver ausente (necessário antes de `SharedPreferences`/`sqflite` no startup).
- Parar após `flutter analyze` passar limpo em todo o projeto.

### Comandos de Validação (Terminal)
```powershell
flutter analyze
```

<!-- ACCEPTANCE -->

## Acceptance criteria

- [x] `MaterialApp` usa `AppTheme.retroAnalog` e `debugShowCheckedModeBanner: false`.
- [x] Startup verifica `AuthService.getCurrentUser()` e abre `HomeScreen` quando há sessão válida ou `LoginScreen` caso contrário.
- [x] `flutter analyze` em todo o repositório retorna 0 erros.
