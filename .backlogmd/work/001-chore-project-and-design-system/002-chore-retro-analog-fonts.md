<!-- METADATA -->

```yaml
task: Empacotar fontes locais Retro Analog e registrar no pubspec.yaml
status: done
priority: 20
dep: ["work/001-chore-project-and-design-system/001-chore-flutter-project-init.md"]
assignee: ""
requiresHumanReview: false
expiresAt: null
```

<!-- DESCRIPTION -->

## Description

Garantir que as três famílias tipográficas oficiais (**Bricolage Grotesque**, **DM Sans** e **Space Mono**) estejam disponíveis offline em `assets/fonts/` e declaradas na seção `flutter.fonts` do `pubspec.yaml`.

### Escopo
- **Inclui**: Download/cópia dos arquivos `.ttf` (pesos regular, medium, bold necessários) para `assets/fonts/` e declaração de `BricolageGrotesque`, `DMSans` e `SpaceMono` no `pubspec.yaml`.
- **Não inclui**: Criação do `TextTheme` em Dart (task `003`).

### Skills Recomendadas
- `backlogmd` — Gestão do fluxo da task.

### Quando Parar o Desenvolvimento (Stop Conditions)
- Parar caso não seja possível obter algum `.ttf` das fontes oficiais (nunca substituir por outra fonte silenciosamente sem aprovação); registrar bloqueio em `-feedback.md`.
- Parar após `flutter pub get` validar o `pubspec.yaml` sem erros de asset.

### Comandos de Validação (Terminal)
```powershell
dir assets\fonts
flutter pub get
flutter analyze
```

<!-- ACCEPTANCE -->

## Acceptance criteria

- [x] Arquivos `.ttf` de `Bricolage Grotesque`, `DM Sans` e `Space Mono` presentes em `assets/fonts/`.
- [x] `pubspec.yaml` declara as 3 famílias com caminhos e pesos válidos.
- [x] `flutter pub get` conclui sem avisos de assets ausentes.
