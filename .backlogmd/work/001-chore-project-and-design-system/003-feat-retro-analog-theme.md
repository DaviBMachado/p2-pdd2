<!-- METADATA -->

```yaml
task: Implementar Design System Retro Analog em lib/theme/app_theme.dart
status: done
priority: 30
dep: ["work/001-chore-project-and-design-system/002-chore-retro-analog-fonts.md"]
assignee: ""
requiresHumanReview: false
expiresAt: null
```

<!-- DESCRIPTION -->

## Description

Criar `lib/theme/app_theme.dart` centralizando todos os tokens visuais *Retro Analog*: paleta de 7 cores oficiais, `ColorScheme`, `TextTheme` com as 3 fontes, espaçamentos/raios padrão e temas de `ElevatedButton`, `InputDecoration`, `Card`, `AppBar` e `SnackBar`.

### Escopo
- **Inclui**: `AppColors` (tokens exatos `#F4EBD8`, `#FFF9ED`, `#E8D7B5`, `#D96C3B`, `#68734B`, `#293B35`, `#B8A98E`), `AppTheme.retroAnalog` (`ThemeData` Material 3), estilos de *Paper Card* e *Solid Retro Button*.
- **Não inclui**: Widgets ou telas individuais.

### Skills Recomendadas
- `frontend-design` / `ui-design-patterns` — Coerência de tokens, contraste e hierarquia tipográfica.
- `ponytail` — Manter apenas os tokens e estilos efetivamente usados.

### Quando Parar o Desenvolvimento (Stop Conditions)
- Parar se surgir necessidade de introduzir uma cor fora da paleta oficial (solicitar aprovação antes).
- Parar após `flutter analyze` passar sem warnings em `lib/theme/app_theme.dart`.

### Comandos de Validação (Terminal)
```powershell
flutter analyze lib/theme/app_theme.dart
```

<!-- ACCEPTANCE -->

## Acceptance criteria

- [x] Todos os 7 hexadecimais oficiais definidos como constantes em `AppColors`.
- [x] `ThemeData` configura `scaffoldBackgroundColor` (`#F4EBD8`), `ColorScheme` e `TextTheme` usando `BricolageGrotesque`, `DMSans` e `SpaceMono`.
- [x] Temas padrão de input, card (borda `#B8A98E`) e botão sólido (`#D96C3B`) definidos.
- [x] `flutter analyze` retorna 0 erros/warnings.
