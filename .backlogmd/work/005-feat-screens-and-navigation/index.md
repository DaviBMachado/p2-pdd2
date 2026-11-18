<!-- METADATA -->

```yaml
work: Telas, Retro Dock e Proteção de Rotas
status: done
assignee: ""
```

<!-- DESCRIPTION -->

Implementação das 4 telas do aplicativo (`LoginScreen`, `RegisterScreen`, `TaskFormScreen`, `HomeScreen` com *Retro Dock*) e do ponto de entrada `main.dart` com verificação de sessão inicial e proteção de rotas.

<!-- CONTEXT -->

- **Segurança/Rotas**:
  - Login e Cadastro bem-sucedidos usam `Navigator.pushAndRemoveUntil(..., (_) => false)` para impedir retorno via botão Back.
  - Logout limpa a sessão e navega imediatamente (sem modal de confirmação) via `pushAndRemoveUntil` para `LoginScreen`.
  - Sempre verificar `if (!mounted) return;` após `await` antes de usar `BuildContext`.
- **Retro Dock**: Barra inferior na `HomeScreen` contendo os 3 filtros (`Todas`, `Pendentes`, `Concluídas`).
