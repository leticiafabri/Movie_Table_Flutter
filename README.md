# Movie Table

Aplicativo mobile desenvolvido em Flutter como projeto somativo da disciplina de **Desenvolvimento Mobile**.

O **Movie Table** é uma aplicação para consulta e organização de filmes, permitindo ao usuário visualizar um catálogo, pesquisar títulos, consultar detalhes, favoritar filmes e marcar conteúdos como assistidos.

O projeto utiliza a **API do TMDb (The Movie Database)** para obtenção das informações dos filmes e armazenamento local para gerenciamento de contas, favoritos, filmes assistidos e sessão do usuário.

---

## Funcionalidades

- Cadastro e login de usuários
- Catálogo de filmes
- Carregamento paginado de filmes
- Busca de filmes
- Visualização de detalhes dos filmes
- Adição e remoção de favoritos
- Marcação de filmes como assistidos
- Persistência local dos dados
- Dados de favoritos e assistidos separados por usuário
- Encerramento da sessão
- Recursos de acessibilidade
- Navegação por abas entre filmes, favoritos e assistidos

---

## Tecnologias utilizadas

- **Flutter**
- **Dart**
- **Provider** — gerenciamento de estado
- **HTTP** — comunicação com a API
- **Shared Preferences** — persistência local
- **TMDb API** — fonte dos dados dos filmes

---

## API utilizada

O projeto utiliza a API do **The Movie Database (TMDb)** para consultar os filmes.

Principais operações utilizadas:

- Listagem de filmes populares
- Busca de filmes
- Consulta dos detalhes de um filme específico
- Obtenção das imagens dos pôsteres

A aplicação utiliza autenticação por **Bearer Token** para realizar as requisições.

---

## Configuração da API

Por questões de segurança, o token da API não é armazenado diretamente no código-fonte ou versionado no GitHub.

Para executar o projeto localmente, crie um arquivo chamado:

```text
env.json
```

na raiz do projeto, seguindo o formato:

```json
{
  "TMDB_ACCESS_TOKEN": "SEU_TOKEN_AQUI"
}
```

O arquivo `env.json` está incluído no `.gitignore` e não foi enviado ao repositório.

Para executar o projeto:

```bash
flutter pub get
```

e:

```bash
flutter run -d emulator-5554 --dart-define-from-file=env.json
```

> O identificador do dispositivo pode variar.

---

## Arquitetura do projeto

O projeto foi organizado de forma a separar as responsabilidades entre modelos, serviços, gerenciamento de estado e telas.

```text
lib/
├── main.dart
│
├── models/
│   └── movie.dart
│
├── providers/
│   ├── auth_provider.dart
│   ├── favorites_provider.dart
│   └── watched_provider.dart
│
├── screens/
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── session_screen.dart
│   ├── home_screen.dart
│   ├── catalog_screen.dart
│   ├── movie_detail_screen.dart
│   ├── favorites_screen.dart
│   └── watched_screen.dart
│
├── services/
│   ├── local_storage_service.dart
│   └── movie_service.dart
│
└── widgets/
    └── movie_card.dart
```

### Organização das responsabilidades

**Models**

Responsáveis pela representação dos dados utilizados pela aplicação.

**Services**

Responsáveis pela comunicação com a API do TMDb e pela persistência local.

**Providers**

Responsáveis pelo gerenciamento global dos estados de autenticação, favoritos e filmes assistidos.

**Screens**

Responsáveis pelas principais interfaces e fluxos de navegação da aplicação.

**Widgets**

Diretório destinado aos componentes reutilizáveis da interface.

---

## Autenticação e sessão

A aplicação possui um sistema de autenticação local para atender ao requisito de acesso ao catálogo somente após o login.

O usuário pode:

1. Criar uma conta;
2. Informar e-mail e senha;
3. Realizar login;
4. Permanecer autenticado entre execuções;
5. Encerrar a sessão utilizando a opção **Sair**.

As informações de usuários e a sessão são armazenadas localmente utilizando `SharedPreferences`.

A autenticação é local, visto que é para projeto acadêmico.

---

## Persistência

A persistência local é realizada utilizando **SharedPreferences**.

São persistidos:

- Contas cadastradas;
- Sessão atual;
- Filmes favoritos;
- Filmes assistidos.

Os favoritos e filmes assistidos são associados ao usuário atualmente autenticado, utilizando chaves específicas para cada conta.

---

## Requisitos Funcionais

### RF01 — Catálogo

Implementado catálogo de filmes utilizando a API do TMDb.

A aplicação apresenta os filmes em uma grade (`GridView`) contendo pôster e título. O botão **Carregar Mais** realiza a busca da próxima página e adiciona os novos resultados ao catálogo existente.

Também existe um placeholder para filmes que não possuem imagem disponível.


---

### RF02 — Navegação para detalhes

Ao selecionar um filme no catálogo, o usuário é direcionado para uma tela de detalhes utilizando o sistema de navegação do Flutter (`Navigator`).

O mesmo comportamento está disponível nas telas de favoritos e assistidos.


---

### RF03 — Detalhes do filme

A tela de detalhes realiza uma nova consulta à API utilizando o identificador do filme selecionado.

São apresentadas informações como:

- Título;
- Pôster;
- Avaliação;
- Quantidade de votos;
- Data de lançamento;
- Sinopse.

---

### RF04 — Favoritos

O gerenciamento dos filmes favoritos é realizado utilizando `Provider`.

O usuário pode adicionar ou remover um filme dos favoritos por meio do botão de estrela disponível na tela de detalhes.

O estado da estrela é atualizado de acordo com a situação atual do filme.

---

### RF05 — Tela de favoritos

A aplicação possui uma tela específica para os filmes favoritos.

As alterações realizadas nos favoritos são refletidas automaticamente por meio do gerenciamento de estado com `Provider`.

---

### RF06 — Persistência de favoritos e assistidos

Os filmes favoritos e assistidos são armazenados localmente utilizando `SharedPreferences`.

Os dados permanecem disponíveis após o encerramento e reabertura da aplicação.

Além disso, as listas são separadas por usuário.

---

### RF07 — Login e filmes assistidos

O acesso ao catálogo é realizado somente após autenticação.

O usuário pode marcar um filme como assistido ou remover essa marcação.

A aplicação possui uma aba específica para visualização dos filmes assistidos.


---

### RF08 — Busca

A aplicação possui um campo de busca utilizando `TextField` e `TextEditingController`.

Ao selecionar **Buscar**, uma requisição é realizada ao endpoint de pesquisa do TMDb e os resultados são apresentados na tela.

Os resultados da busca podem ser selecionados para acessar a tela de detalhes do filme.

---

### RF09 — Indicadores de carregamento e tratamento de erros

A aplicação apresenta indicadores de carregamento durante operações assíncronas, incluindo:

- Carregamento inicial do catálogo;
- Carregamento de novas páginas;
- Busca;
- Carregamento dos detalhes;
- Verificação da sessão;
- Login.

Também são apresentados feedbacks amigáveis em situações de erro ou ausência de resultados.

---

### RF10 — Acessibilidade

Foram implementados recursos de acessibilidade utilizando funcionalidades disponíveis no Flutter.

Entre eles:

- `Semantics` nos cards de filmes;
- `semanticLabel` para imagens dos pôsteres;
- Descrição acessível para informações de avaliação;
- `tooltip` no botão de favoritos;
- Áreas de toque adequadas;
- Suporte ao redimensionamento do texto;
- `SingleChildScrollView` nas telas de login e cadastro para evitar overflow com fontes maiores e teclado aberto;
- Teste com leitor de tela do Android.

---

## Acessibilidade

Foram realizados testes utilizando:

- Aumento do tamanho da fonte;
- Teclado virtual com fonte aumentada;
- Leitor de tela do Android;
- Navegação pelos principais elementos interativos.

Os componentes interativos possuem descrições que permitem sua identificação por tecnologias assistivas.

---

## Execução do projeto

### Pré-requisitos

Para executar o projeto, é necessário ter instalado:

- Flutter SDK;
- Dart SDK;
- Android Studio ou outro ambiente compatível;
- Android SDK;
- Um dispositivo Android físico ou emulador.

### Instalação

Clone o repositório:

```bash
git clone https://github.com/leticiafabri/Movie_Table_Flutter.git
```

Entre na pasta do projeto:

```bash
cd Movie_Table_Flutter/movie_table
```

Instale as dependências:

```bash
flutter pub get
```

Configure o arquivo `env.json` conforme descrito anteriormente.

Execute a aplicação:

```bash
flutter run --dart-define-from-file=env.json
```

---

## Verificação do código

O projeto foi formatado utilizando:

```bash
dart format lib
```

E validado utilizando:

```bash
flutter analyze
```

## Estrutura de navegação

Após iniciar a aplicação, o fluxo principal é:

```text
Sessão
   │
   ├── Usuário não autenticado
   │       ↓
   │     Login
   │       ↓
   │     Cadastro
   │
   └── Usuário autenticado
           ↓
        Movie Table
           │
           ├──  Filmes
           │      ├── Busca
           │      └── Detalhes
           │
           ├──  Favoritos
           │
           └──  Assistidos
```


