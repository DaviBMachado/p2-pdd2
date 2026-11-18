<!-- METADATA -->

```yaml
task: Executar análise estática, testes e build Android debug
status: in-progress
priority: 20
dep:
  - "work/005-feat-screens-and-navigation/005-feat-main-session-router.md"
  - "work/006-test-validation-and-qa/001-test-auth-unit-tests.md"
assignee: "agent"
requiresHumanReview: false
expiresAt: null
```

<!-- DESCRIPTION -->

## Description

Executar verificação completa de qualidade no projeto compilado: `flutter analyze`, `flutter test` e `flutter build apk --debug`, garantindo que não haja erros de lint, falhas de teste ou problemas de build no Android.

### Escopo
- **Inclui**: Execução dos comandos de análise, teste e build; correção de eventuais avisos/erros encontrados.
- **Não inclui**: Build de release assinado.

### Skills Recomendadas
- `diagnosing-bugs` — Caso o build Android ou `flutter analyze` reporte erro.
- `ponytail-review` — Revisão final de qualidade do diff completo.

### Quando Parar o Desenvolvimento (Stop Conditions)
- Parar imediatamente e registrar em `-feedback.md` se o SDK Android não estiver configurado para `flutter build apk --debug`.
- Parar após todos os comandos retornarem código de saída 0.

### Comandos de Validação (Terminal)
```powershell
flutter analyze
flutter test
flutter build apk --debug
```

<!-- ACCEPTANCE -->

## Acceptance criteria

- [ ] `flutter analyze` retorna 0 issues.
- [ ] `flutter test` passa todos os testes.
- [ ] `flutter build apk --debug` gera o APK sem erros.
