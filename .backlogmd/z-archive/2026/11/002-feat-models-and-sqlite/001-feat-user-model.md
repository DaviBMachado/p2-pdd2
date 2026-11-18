<!-- METADATA -->

```yaml
task: Implementar UserModel em lib/models/user_model.dart
status: done
priority: 10
dep: ["work/001-chore-project-and-design-system/001-chore-flutter-project-init.md"]
assignee: ""
requiresHumanReview: false
expiresAt: null
```

<!-- DESCRIPTION -->

## Description

Criar a classe imutável `UserModel` em `lib/models/user_model.dart` representando a tabela `users` do SQLite, com `fromMap` e `toMap` mapeando exatamente as colunas `id`, `name`, `email`, `password_hash`, `password_salt` e `created_at`.

### Escopo
- **Inclui**: Campos tipados (`int? id`, `String name`, `String email`, `String passwordHash`, `String passwordSalt`, `DateTime createdAt`), `fromMap`, `toMap`.
- **Não inclui**: Lógica de hash ou validação de formulário.

### Skills Recomendadas
- `codebase-design` — Modelo limpo e sem lógica de infraestrutura acoplada.
- `ponytail` — Apenas os métodos necessários (`fromMap`, `toMap`).

### Quando Parar o Desenvolvimento (Stop Conditions)
- Parar se alguma coluna divergir do schema especificado no item `002/index.md`.
- Parar após `flutter analyze` passar sem erros.

### Comandos de Validação (Terminal)
```powershell
flutter analyze lib/models/user_model.dart
```

<!-- ACCEPTANCE -->

## Acceptance criteria

- [x] `UserModel` possui todos os 6 campos correspondentes à tabela `users`.
- [x] `fromMap` e `toMap` convertem `created_at` (ISO-8601 `String` ↔ `DateTime`) corretamente.
- [x] `flutter analyze lib/models/user_model.dart` passa sem erros ou warnings.
