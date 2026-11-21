# Finanças

Aplicação Rails 8.1 para controle de despesas, empréstimos e importação via CSV. Stack: Ruby 4.0.10, SQLite (multi-database: primary, queue, cache, cable em produção), Active Storage em disco, Solid Queue.

Desenvolvimento e produção local rodam em Docker. Dados ficam em `./storage` no disco principal; backups automáticos vão para um HD secundário configurável.

## Pré-requisitos

- [Docker](https://docs.docker.com/engine/install/) e Docker Compose plugin
- Fedora (ou outra distro com Docker)
- Para produção: `config/master.key` ou `RAILS_MASTER_KEY` no `.env`

Habilitar o Docker no boot (recomendado para produção local):

```bash
sudo systemctl enable --now docker
```

Adicione seu usuário ao grupo `docker` se ainda não estiver, e faça login de novo.

## Configuração inicial

```bash
cp .env.example .env
```

Edite `.env`:

| Variável | Uso |
|----------|-----|
| `RAILS_MASTER_KEY` | Obrigatório em produção (conteúdo de `config/master.key`) |
| `FINANCES_BACKUP_PATH` | Caminho **absoluto** no HD secundário (ex.: `/run/media/ramonsantos/Backup/finances`) |
| `FINANCES_BACKUP_INTERVAL_SECONDS` | Intervalo entre backups (padrão `3600`) |
| `FINANCES_BACKUP_RETENTION_DAYS` | Retenção das pastas datadas (padrão `14`) |

Crie o diretório de backup no HD secundário com permissão de escrita para o UID `1000` (usuário `rails` no container):

```bash
mkdir -p /run/media/SEU_USUARIO/Backup/finances
# Se necessário:
# chown 1000:1000 /run/media/SEU_USUARIO/Backup/finances
```

## Desenvolvimento (Docker)

Na raiz do projeto:

```bash
export UID GID   # opcional; padrão 1000
docker compose build
docker compose up
```

Acesse [http://localhost:3000](http://localhost:3000).

O serviço `app` executa `bin/dev` (Foreman): servidor Rails, Tailwind watch e Solid Queue no mesmo container.

Banco e uploads ficam em `./storage` no host.

### Console e setup

```bash
docker compose run --rm app bin/rails console
docker compose run --rm app bin/setup --skip-server
```

### Testes

```bash
docker compose run --rm app bundle exec rspec
docker compose run --rm -e CI=1 -e COVERAGE=1 app bundle exec rspec
docker compose run --rm -e CI=1 app bin/ci
```

### Parar desenvolvimento

```bash
docker compose down
```

## Produção local (Docker)

Produção **só** via containers. A URL é [http://localhost:3099](http://localhost:3099) (host `3099` → Thruster no container).

```bash
cp .env.example .env
# Preencha RAILS_MASTER_KEY e FINANCES_BACKUP_PATH

docker compose -f docker-compose.production.yml build
docker compose -f docker-compose.production.yml up -d
```

Serviços:

- **web** — aplicação Rails + Solid Queue (`SOLID_QUEUE_IN_PUMA`)
- **backup** — loop com `bin/backup` (SQLite `.backup` + `rsync` dos blobs)

Ambos usam `restart: unless-stopped`. Depois do primeiro `up -d`, reiniciar o Fedora sobe os containers de novo **desde que** o daemon Docker esteja habilitado. Um `docker compose -f docker-compose.production.yml down` remove os containers até o próximo `up -d`.

### Onde ficam os dados

Em `./storage/` no disco principal do projeto:

| Arquivo / pasta | Função |
|-----------------|--------|
| `production.sqlite3` | Banco principal |
| `production_queue.sqlite3` | Solid Queue |
| `production_cache.sqlite3` | Solid Cache |
| `production_cable.sqlite3` | Solid Cable |
| Demais arquivos/pastas | Active Storage (CSVs importados, etc.) |

### Logs e console

```bash
docker compose -f docker-compose.production.yml logs -f web
docker compose -f docker-compose.production.yml exec web bin/rails console
```

### Backup manual

```bash
docker compose -f docker-compose.production.yml run --rm \
  -e STORAGE_PATH=/rails/storage -e BACKUP_PATH=/backup \
  backup /rails/bin/backup
```

(No serviço `backup` isso roda automaticamente no intervalo configurado.)

Estrutura no HD secundário (`FINANCES_BACKUP_PATH`):

```text
20261121-1430/
  production.sqlite3
  production_queue.sqlite3
  production_cache.sqlite3
  production_cable.sqlite3
  storage/          # blobs (rsync), sem duplicar os .sqlite3 da raiz da pasta
```

## Restaurar após formatar o HD principal

Use o backup no HD secundário. **Não** rode `db:reset` nem `db:drop`.

1. Instale Docker, clone o repositório, configure `.env` (`RAILS_MASTER_KEY`, `FINANCES_BACKUP_PATH`).
2. Garanta que o HD secundário está montado e o path de backup existe.
3. Escolha a pasta datada mais recente em `FINANCES_BACKUP_PATH` (ex.: `20261121-1430`).
4. Pare a produção, se estiver rodando:

   ```bash
   docker compose -f docker-compose.production.yml stop
   ```

5. Crie `./storage` e copie os arquivos do backup:

   ```bash
   mkdir -p storage
   cp BACKUP/20261121-1430/*.sqlite3 storage/
   rsync -a BACKUP/20261121-1430/storage/ storage/
   ```

   Os quatro `*.sqlite3` na raiz do backup devem ter exatamente os nomes de produção listados acima.

6. Suba de novo:

   ```bash
   docker compose -f docker-compose.production.yml up -d --build
   ```

   O `bin/docker-entrypoint` executa `db:prepare` só se faltar schema; migrations pendentes são aplicadas sem apagar dados.

7. Acesse [http://localhost:3099](http://localhost:3099) e valide lançamentos e um anexo de importação CSV.

### Substituir dados com a app parada (mesmo disco)

```bash
docker compose -f docker-compose.production.yml stop
# substitua o conteúdo de ./storage pelos arquivos do backup
docker compose -f docker-compose.production.yml start
```

## Desenvolvimento sem Docker (opcional)

Requer Ruby 4.0.10, Bundler e SQLite no host.

```bash
bundle install
bin/setup
bin/dev          # Foreman: web + css + jobs
bundle exec rspec
bin/ci
```

## Kamal

O arquivo `config/deploy.yml` permanece para deploy remoto com Kamal, mas **não** faz parte do fluxo de produção local descrito aqui.