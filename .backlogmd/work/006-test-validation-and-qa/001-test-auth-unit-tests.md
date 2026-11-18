<!-- METADATA -->

```yaml
task: Criar testes unitários de hash, salt e verificação em test/auth_service_test.dart
status: done
priority: 10
dep: ["work/003-feat-auth-and-session/001-feat-password-hashing.md"]
assignee: ""
requiresHumanReview: false
expiresAt: null
```

<!-- DESCRIPTION -->

## Description

Criar `test/auth_service_test.dart` validando a geração de salt único (dois salts nunca iguais), geração de hash diferente da senha em texto puro, consistência determinística de `hashPassword` com mesmo salt e `verifyPassword` retornando `true` para senha correta e `false` para senha incorreta.

### Escopo
- **Inclui**: Testes unitários puros das funções criptográficas do `AuthService`.
- **Não inclui**: Testes de integração com SQLite nativo no host Windows caso `sqflite` exija emulador.

### Skills Recomendadas
- `tdd` — Testes objetivos cobrindo casos de sucesso e falha.
- `cybersecurity` — Verificação explícita de não-determinismo do salt e rejeição de senha errada.

### Quando Parar o Desenvolvimento (Stop Conditions)
- Parar após `flutter test test/auth_service_test.dart` passar 100%.

### Comandos de Validação (Terminal)
```powershell
flutter test test/auth_service_test.dart
```

<!-- ACCEPTANCE -->

## Acceptance criteria

- [x] Testa que `generateSalt()` produz valores distintos em chamadas consecutivas.
- [x] Testa que `hashPassword` nunca retorna a senha em texto puro.
- [x] Testa que `verifyPassword` valida senha correta (`true`) e rejeita incorreta (`false`).
- [x] `flutter test test/auth_service_test.dart` passa com código de saída 0.
