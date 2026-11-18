<!-- METADATA -->

```yaml
work: Fundação Flutter, Fontes e Design System Retro Analog
status: done
assignee: ""
```

<!-- DESCRIPTION -->

Inicialização do projeto Flutter em `Z:\p2-pdd2`, configuração das dependências aprovadas (`sqflite`, `path`, `shared_preferences`, `crypto`), empacotamento offline das fontes oficiais (`Bricolage Grotesque`, `DM Sans`, `Space Mono`) e criação do Design System centralizado *Retro Analog* em `lib/theme/app_theme.dart`.

<!-- CONTEXT -->

- **Stack aprovada**: Flutter, Dart, `sqflite`, `path`, `shared_preferences`, `crypto`. Não adicionar Firebase, Supabase, `provider`, `bloc` ou `riverpod`.
- **Paleta oficial Retro Analog**:
  - Background: `#F4EBD8`
  - Surface: `#FFF9ED`
  - Secondary: `#E8D7B5`
  - Primary: `#D96C3B`
  - Accent: `#68734B`
  - Text: `#293B35`
  - Border: `#B8A98E`
- **Fontes**: `Bricolage Grotesque` (títulos), `DM Sans` (corpo/forms/botões), `Space Mono` (contadores/datas/badges). Devem rodar offline via `assets/fonts/`.
