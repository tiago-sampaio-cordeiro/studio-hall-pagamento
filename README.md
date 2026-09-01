# Studio Hall Pagamento

Sistema de gestão de funcionários e folha de pagamento desenvolvido com Ruby on Rails 8.

## Requisitos

- Ruby 3.2.10
- Rails 8.1+
- PostgreSQL

## Configuração do ambiente (Ubuntu)

Caso esteja em uma instância Ubuntu limpa (ex: Multipass), siga os passos abaixo antes de instalar o projeto.

**1 — Atualizar o sistema:**
```bash
sudo apt update && sudo apt upgrade -y
```

**2 — Instalar dependências do sistema:**
```bash
sudo apt install -y git curl libssl-dev libreadline-dev zlib1g-dev libyaml-dev libffi-dev \
  build-essential libpq-dev postgresql postgresql-contrib
```

**3 — Instalar rbenv e Ruby:**
```bash
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv install 3.2.10
rbenv local 3.2.10
```

**4 — Instalar Bundler e Rails:**
```bash
gem install bundler
gem install rails
```

**5 — Configurar PostgreSQL:**
```bash
sudo -u postgres psql -c "CREATE USER seu_usuario WITH PASSWORD 'sua_senha' CREATEDB;"
```

## Dependências principais

| Gem | Descrição |
|-----|-----------|
| `rails 8.1` | Framework principal |
| `pg` | Banco de dados PostgreSQL |
| `puma` | Servidor web |
| `propshaft` | Pipeline de assets |
| `turbo-rails` | Navegação SPA-like (Hotwire) |
| `stimulus-rails` | JavaScript modesto (Hotwire) |
| `importmap-rails` | Gerenciamento de imports JS |
| `tailwindcss-rails` | Estilização CSS |
| `view_component` | Componentização de views |
| `bcrypt` | Autenticação com has_secure_password |
| `foreman` | Execução de múltiplos processos |
| `rails-i18n` | Internacionalização (pt-BR) |
| `solid_cache` | Cache no banco de dados |
| `solid_queue` | Filas no banco de dados |
| `solid_cable` | Action Cable no banco de dados |

## Instalação

Clone o repositório:

```bash
git clone git@github.com:tiago-sampaio-cordeiro/employee-pay.git
cd employee-pay
```

Instale as dependências:

```bash
bundle install
```

Configure o banco de dados no arquivo `config/database.yml` com suas credenciais do PostgreSQL:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: seu_usuario
  password: sua_senha

development:
  <<: *default
  database: studio_hall_pagamento_development

test:
  <<: *default
  database: studio_hall_pagamento_test
```


Crie e migre o banco:

```bash
rails db:create
```
Se acontecer um erro referente a Peer authentication 
você precisa editar o arquivo **/etc/postgresql/*/main/pg_hba.conf**:

```bash
sudo nano /etc/postgresql/*/main/pg_hba.conf
```
encontra essa linha:
```bash
local   all             all                                     peer
```
e altera para:
```bash
local   all             all                                     md5
```
Agora postgres usa senha em vez de usuário do sistema.
Após isso deve funcionar.
```bash
rails db:create
rails db:migrate
```

## Rodando a aplicação

O projeto usa **Foreman** para rodar o servidor Rails e o watcher do Tailwind simultaneamente:

```bash
bin/dev
```
Acesse em `http://localhost:3000`.

ou o comando abaixo se estiver usando vm do multipass:

```bash
rails s -b 0.0.0.0
```
Acesse em `http://ip-da-vm:3000`
## Testes

O projeto usa RSpec para testes:

```bash
bundle exec rspec
```

## Ferramentas de desenvolvimento

| Gem | Descrição |
|-----|-----------|
| `pry-rails` | Debug interativo no console |
| `dotenv-rails` | Variáveis de ambiente |
| `letter_opener` | Preview de emails no browser |
| `brakeman` | Análise de segurança |
| `rubocop-rails-omakase` | Linting de código |
| `bundler-audit` | Auditoria de vulnerabilidades em gems |
| `rspec-rails` | Testes |
| `factory_bot_rails` | Factories para testes |
| `faker` | Dados falsos para testes |
| `capybara` | Testes de sistema |

## serviço de email

O projeto possui um mecanismo de recuperação de senha usando o mailgun, onde pode ser usado o gmail.
para funcionar é preciso criar uma conta no site do mailgun, cadastrar um funcionario
com um email real e valido e adicionar esse email no site do mailgun permitindo o envio 
de emails  e alterar o ip em `config/environments/development.rb` para que o mailgun possa encontrar.