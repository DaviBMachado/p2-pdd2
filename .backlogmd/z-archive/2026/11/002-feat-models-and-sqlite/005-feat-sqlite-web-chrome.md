<!-- METADATA -->

```yaml
task: Suportar SQLite no Chrome/Web com sqflite_common_ffi_web
status: done
priority: 50
dep: ["work/002-feat-models-and-sqlite/004-feat-database-service-queries.md"]
assignee: ""
requiresHumanReview: false
expiresAt: null
```

<!-- DESCRIPTION -->

## Description

Gerar plataforma Web (`flutter create --platforms=web .`), adicionar `sqflite_common_ffi_web` em `pubspec.yaml` e configurar `databaseFactory = databaseFactoryFfiWeb` quando `kIsWeb` em `lib/services/database_service.dart` (incluindo setup dos assets WASM do `sqflite_common_ffi_web` em `web/`).

<!-- ACCEPTANCE -->

## Acceptance criteria

- [x] Pasta `web/` gerada e `sqflite_common_ffi_web` adicionado em `pubspec.yaml`.
- [x] `DatabaseService` inicializa `databaseFactoryFfiWeb` sob `kIsWeb` sem quebrar Android.
- [x] `flutter analyze` passa sem erros e o build web compila para Chrome.
