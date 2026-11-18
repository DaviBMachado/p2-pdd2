<!-- METADATA -->

```yaml
task: Implementar geração de salt e hash iterado SHA-256 no AuthService
status: done
priority: 10
dep: ["work/001-chore-project-and-design-system/001-chore-flutter-project-init.md"]
assignee: ""
requiresHumanReview: false
expiresAt: null
```

<!-- DESCRIPTION -->

## Description

Criar a base de `lib/services/auth_service.dart` com funções puras e testáveis para geração de salt aleatório de 16 bytes via `Random.secure()`, derivação de hash `SHA-256` iterado (com `crypto`) e verificação de senha em tempo constante.

### Escopo
- **Inclui**: `generateSalt()`, `hashPassword(String password, String salt)`, `verifyPassword(String password, String salt, String expectedHash)`.
- **Não inclui**: Persistência em banco ou `SharedPreferences`.

### Skills Recomendadas
- `cybersecurity` — Uso correto de CSPRNG (`Random.secure()`), iterações de hash e comparação segura.
- `ponytail` — Funções enxutas e legíveis, sem bibliotecas criptográficas extras.

### Quando Parar o Desenvolvimento (Stop Conditions)
- Parar se for tentado uso de `Random()` não-seguro ou hash sem salt.
- Parar após `flutter analyze` passar limpo.

### Comandos de Validação (Terminal)
```powershell
flutter analyze lib/services/auth_service.dart
```

<!-- ACCEPTANCE -->

## Acceptance criteria

- [x] `generateSalt()` usa `Random.secure()` com 16 bytes aleatórios codificados em Base64/Hex.
- [x] `hashPassword` combina senha + salt usando `SHA-256` iterado (`crypto`).
- [x] `verifyPassword` compara hashes sem vazar diferença por curto-circuito simples (comparação byte a byte).
- [x] `flutter analyze` passa sem erros.
