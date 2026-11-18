<!-- METADATA -->

```yaml
task: Implementar CustomTextField em lib/widgets/custom_text_field.dart
status: done
priority: 10
dep: ["work/001-chore-project-and-design-system/003-feat-retro-analog-theme.md"]
assignee: ""
requiresHumanReview: false
expiresAt: null
```

<!-- DESCRIPTION -->

## Description

Criar `CustomTextField` em `lib/widgets/custom_text_field.dart` padronizando os inputs do app com estética *Retro Analog* (fundo `Surface`, borda `Border`, foco `Primary`, validação visual e botão opcional de visualizar/ocultar senha).

### Escopo
- **Inclui**: Parâmetros de `controller`, `label`, `hint`, `validator`, `obscureText` com toggle interno de olhinho, `keyboardType`, `textInputAction`, `maxLines`, `maxLength`, `prefixIcon`.
- **Não inclui**: Regras de negócio específicas de login/cadastro (passadas via `validator`).

### Skills Recomendadas
- `frontend-design` / `ui-design-patterns` — Feedback visual de foco/erro e acessibilidade do toggle de senha.
- `ponytail` — Widget enxuto envolvendo `TextFormField` sem abstrações excessivas.

### Quando Parar o Desenvolvimento (Stop Conditions)
- Parar se cores hardcoded forem usadas no lugar de `AppColors`/`Theme.of(context)`.
- Parar após `flutter analyze` passar sem erros.

### Comandos de Validação (Terminal)
```powershell
flutter analyze lib/widgets/custom_text_field.dart
```

<!-- ACCEPTANCE -->

## Acceptance criteria

- [x] `CustomTextField` exibe bordas definidas (`#B8A98E`), fundo `#FFF9ED` e foco `#D96C3B`.
- [x] Quando `isPassword: true`, exibe ícone para alternar visibilidade do texto.
- [x] Suporta `validator`, `maxLength` e `maxLines` para uso em autenticação e formulário de tarefa.
- [x] `flutter analyze` passa sem erros.
