<!-- METADATA -->

```yaml
task: Validar cenários acadêmicos E2E e identidade Retro Analog em Android
status: open
priority: 30
dep: ["work/006-test-validation-and-qa/002-test-static-analysis-and-build.md"]
assignee: ""
requiresHumanReview: true
expiresAt: null
```

<!-- DESCRIPTION -->

## Description

Executar o aplicativo em emulador ou dispositivo físico Android e validar os 4 cenários acadêmicos + conformidade visual *Retro Analog* (paleta, 3 fontes, *Paper Cards*, *Solid Retro* e *Retro Dock*). Como exige inspeção visual e aprovação final da banca/usuário, esta task possui `requiresHumanReview: true`.

### Escopo
- **Inclui**: Execução com `flutter run`, validação dos 4 cenários (Cadastro/E-mail duplicado, Persistência de Sessão após fechar app, CRUD + ordenação + filtros + confirmação ao excluir, Isolamento entre Usuário A e Usuário B).
- **Não inclui**: Alterações de código além de correções pontuais caso algum cenário falhe.

### Skills Recomendadas
- `impeccable` — Auditoria visual final da estética *Retro Analog* em tela real.
- `diagnosing-bugs` — Investigação caso algum fluxo apresente erro em runtime.

### Quando Parar o Desenvolvimento (Stop Conditions)
- **STOP obrigatório**: Ao concluir a verificação e mover para `status: review`, o agente DEVE parar e aguardar aprovação explícita do usuário para marcar como `done`.

### Comandos de Validação (Terminal)
```powershell
flutter devices
flutter run
```

<!-- ACCEPTANCE -->

## Acceptance criteria

- [ ] Cenário 1: Usuário A cadastrado; tentativa de e-mail duplicado bloqueada com mensagem clara.
- [ ] Cenário 2: Fechar e reabrir app mantém Usuário A logado na `HomeScreen`.
- [ ] Cenário 3: Criar, editar, concluir, filtrar via *Retro Dock*, ordenar (Pendentes + Prioridade) e excluir (com `AlertDialog`) funcionam e persistem.
- [ ] Cenário 4: Logout + cadastro de Usuário B exibe lista vazia (isolada); relogar Usuário A restaura suas tarefas intactas.
- [ ] Identidade visual *Retro Analog* validada pelo usuário.
