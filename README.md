# TaskFlow

Aplicativo multiplataforma de gerenciamento de tarefas (**To-Do List**) desenvolvido em **Flutter** e **Dart**, com autenticação local de usuários, persistência de dados em **SQLite** e interface inspirada em papel e tinta (*Retro Analog*).

---

## 1. Descrição do Aplicativo

O **TaskFlow** permite que cada usuário crie sua própria conta, acesse suas tarefas de forma privada e organize o dia a dia com foco e simplicidade. Cada tarefa possui título, descrição opcional, nível de prioridade (**Baixa**, **Média** ou **Alta**) e status de conclusão (**Pendente** ou **Concluída**), mantendo os dados salvos localmente no dispositivo ou navegador.

---

## 2. Funcionalidades Principais

- **Autenticação de usuários:**
  - Cadastro de novos usuários com validação de nome, e-mail, senha e confirmação de senha.
  - Login com validação de formulário e tratamento de erros (campos inválidos, e-mail já cadastrado, credenciais incorretas).
  - Persistência de sessão e proteção de telas via `AuthGate` (usuários não autenticados são redirecionados para o login).
  - Logout com limpeza de sessão e da pilha de navegação.
- **CRUD completo de tarefas (após autenticação):**
  - **Criar:** criação de tarefas com título, descrição opcional, prioridade e status inicial.
  - **Ler:** listagem ordenada por status, prioridade e data de criação, com contadores (*Total*, *Pendentes*, *Concluídas*) e filtros rápidos na barra inferior (*Todas*, *Pendentes*, *Concluídas*).
  - **Atualizar:** edição completa dos dados da tarefa ou alternância rápida de conclusão diretamente no cartão.
  - **Excluir:** remoção de tarefas com diálogo de confirmação.

---

## 3. Tecnologias Utilizadas

- **Flutter** & **Dart** (SDK `^3.13.5`)
- **SQLite** (`sqflite` para dispositivos móveis e `sqflite_common_ffi_web` para execução Web)
- **Shared Preferences** (`shared_preferences`) para persistência da sessão do usuário autenticado
- **Crypto** (`crypto`) para geração de hash de senha com SHA-256 e *salt* aleatório
- **Path** (`path`) para resolução do caminho do banco de dados local
- **Flutter Lints** (`flutter_lints`) e **sqflite_common_ffi** para análise estática e testes automatizados

---

## 4. Instruções para Executar o Projeto

### Pré-requisitos
- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado e configurado no `PATH` (Dart `^3.13.5` ou compatível)
- Um emulador Android/iOS, dispositivo físico conectado, desktop ou navegador (Chrome/Edge para Web)

### Passo a passo

1. **Acesse a pasta do projeto:**
   ```bash
   cd p2-pdd2
   ```

2. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

3. **Execute a aplicação:**
   ```bash
   flutter run
   ```
   *(Opcional: para rodar no navegador, utilize `flutter run -d chrome`.)*

4. **Executar análise estática e testes automatizados:**
   ```bash
   flutter analyze
   flutter test
   ```

---

## 5. Autenticação e Base de Dados

### Autenticação (`AuthService` + `AuthGate`)
- A autenticação é gerenciada localmente pela classe `AuthService` (`lib/services/auth_service.dart`).
- No cadastro, um *salt* aleatório de 16 bytes (`Random.secure()`) é gerado e combinado à senha do usuário usando **10.000 iterações de SHA-256**, evitando o armazenamento de senhas em texto puro.
- A verificação de login compara os hashes em tempo constante.
- O ID do usuário autenticado é salvo via `SharedPreferences` (`current_user_id`), permitindo que o `AuthGate` (`lib/main.dart`) proteja a `HomeScreen` e redirecione automaticamente para a `LoginScreen` quando não houver sessão ativa.

### Base de Dados (`DatabaseService`)
- A persistência utiliza **SQLite** gerenciado por `DatabaseService` (`lib/services/database_service.dart`), com `PRAGMA foreign_keys = ON` habilitado.
- O banco `taskflow.db` possui duas tabelas principais:
  - **`users`**: armazena `id`, `name`, `email` (único), `password_hash`, `password_salt` e `created_at`.
  - **`tasks`**: armazena `id`, `user_id` (chave estrangeira para `users.id` com `ON DELETE CASCADE`), `title`, `description`, `priority`, `is_completed`, `created_at` e `updated_at`, além do índice `idx_tasks_user_id` para consultas rápidas por usuário.
- Todas as operações de leitura, atualização e exclusão de tarefas filtram explicitamente por `user_id`, garantindo o isolamento dos dados de cada usuário.

---

## Estrutura do Projeto

```text
lib/
 ├── main.dart                  # Ponto de entrada e AuthGate (proteção de rotas)
 ├── models/
 │    ├── task_model.dart       # Modelo de tarefa e serialização
 │    └── user_model.dart       # Modelo de usuário e serialização
 ├── screens/
 │    ├── login_screen.dart     # Tela de login
 │    ├── register_screen.dart  # Tela de cadastro
 │    ├── home_screen.dart      # Listagem, filtros, contadores e exclusão
 │    └── task_form_screen.dart # Tela de criação e edição de tarefas
 ├── services/
 │    ├── auth_service.dart     # Regras de autenticação, hash e sessão
 │    └── database_service.dart # Conexão SQLite e operações CRUD
 ├── theme/
 │    └── app_theme.dart        # Paleta, tipografia e estilos visuais
 └── widgets/
      ├── custom_text_field.dart
      ├── empty_state.dart
      ├── task_card.dart
      └── task_form.dart
```
