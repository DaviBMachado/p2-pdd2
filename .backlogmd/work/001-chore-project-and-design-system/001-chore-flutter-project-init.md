<!-- METADATA -->

```yaml
task: Inicializar projeto Flutter, estrutura /lib e dependências base
status: done
priority: 10
dep: []
assignee: ""
requiresHumanReview: false
expiresAt: null
```

<!-- DESCRIPTION -->

## Description

Criar o projeto Flutter na raiz `Z:\p2-pdd2`, estruturar os diretórios `/lib/theme`, `/lib/models`, `/lib/services`, `/lib/screens`, `/lib/widgets` e `assets/fonts/`, e declarar as dependências aprovadas no `pubspec.yaml` (`sqflite`, `path`, `shared_preferences`, `crypto`).

### Escopo
- **Inclui**: `flutter create .`, criação das pastas em `lib/` e `assets/fonts/`, adição das 4 dependências no `pubspec.yaml`, execução de `flutter pub get`.
- **Não inclui**: Implementação de código de domínio, telas ou tema (cobertos pelas tasks seguintes).

### Skills Recomendadas
- `backlogmd` — Controle de status da task.
- `ponytail` — Manter `pubspec.yaml` enxuto, sem dependências supérfluas.

### Quando Parar o Desenvolvimento (Stop Conditions)
- Parar imediatamente se `flutter` não estiver instalado/acessível no PATH ou se `flutter pub get` falhar por erro de rede/ambiente; registrar em `-feedback.md` e reportar.
- Não começar a codificar `app_theme.dart` ou modelos nesta task; encerrar assim que o projeto base compilar limpo.

### Comandos de Validação (Terminal)
```powershell
flutter --version
flutter pub get
flutter analyze
```

<!-- ACCEPTANCE -->

## Acceptance criteria

- [x] Projeto Flutter criado na raiz `Z:\p2-pdd2` com suporte Android.
- [x] Pastas `lib/theme`, `lib/models`, `lib/services`, `lib/screens`, `lib/widgets` e `assets/fonts` existem.
- [x] `pubspec.yaml` contém apenas `sqflite`, `path`, `shared_preferences`, `crypto` além do template padrão.
- [x] `flutter pub get` e `flutter analyze` executam com código de saída 0.
