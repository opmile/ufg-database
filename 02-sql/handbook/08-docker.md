# PostgreSQL via Docker

> Roda Postgres em container — sem instalar nada no host. Isola, deleta quando quiser.

---

## 1. Pré-requisito

Docker Desktop instalado e rodando.

```bash
docker --version    # confere instalação
docker ps           # lista containers ativos (vazio se não tem nada)
```

Não tem? Baixa em https://www.docker.com/products/docker-desktop/

---

## 2. Opção A — `docker run` rápido

### Container efêmero (perde dados ao remover)

```bash
docker run --name pg-empresa \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=bd_empresa \
  -p 5432:5432 \
  -d postgres:16
```

### Container com volume nomeado (dados persistem)

```bash
docker run --name pg-empresa \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=bd_empresa \
  -p 5432:5432 \
  -v pg_empresa_data:/var/lib/postgresql/data \
  -d postgres:16
```

| Flag | Faz |
|------|-----|
| `--name pg-empresa` | Nome do container (referenciar depois) |
| `-e POSTGRES_PASSWORD=...` | Senha do superuser (`postgres`) — obrigatório |
| `-e POSTGRES_DB=bd_empresa` | Cria esse banco no boot |
| `-e POSTGRES_USER=milena` | (Opcional) muda nome do superuser |
| `-p 5432:5432` | Expõe porta `host:container` |
| `-v nome:/path` | Volume persistente |
| `-d` | Detached (roda em background) |
| `postgres:16` | Imagem oficial, versão 16 |

---

## 3. Opção B — Docker Compose (recomendado)

`docker-compose.yml` na raiz do projeto:

```yaml
services:
  db:
    image: postgres:16
    container_name: pg-empresa
    restart: unless-stopped
    environment:
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: bd_empresa
    ports:
      - "5432:5432"
    volumes:
      - pg_data:/var/lib/postgresql/data
      - ./setup.sql:/docker-entrypoint-initdb.d/01-setup.sql

volumes:
  pg_data:
```

### Como rodar

```bash
docker compose up -d        # sobe em background
docker compose logs -f      # acompanha logs (Ctrl+C pra sair)
docker compose ps           # lista serviços
docker compose down         # para e remove containers (dados ficam)
docker compose down -v      # para + remove containers + apaga volume
```

### Truque: setup automático

Qualquer `.sql` montado em `/docker-entrypoint-initdb.d/` **roda automaticamente na primeira inicialização** do container (banco vazio).

```bash
# 1. Cria setup.sql com o bloco Setup do 06-handson.md
# 2. docker compose up -d
# 3. PRONTO — banco já com tabelas e dados
```

Pra rodar de novo (re-popular): `docker compose down -v && docker compose up -d`.

---

## 4. Conectar no container

### A. psql dentro do container (zero install no host)

```bash
docker exec -it pg-empresa psql -U postgres -d bd_empresa
```

Sai com `\q`.

### B. psql do host (precisa ter psql local)

```bash
psql -h localhost -p 5432 -U postgres -d bd_empresa
# senha: postgres
```

### C. pgAdmin

**Register → Server:**

| Campo | Valor |
|-------|-------|
| Name | `pg-docker` (qualquer) |
| Host | `localhost` |
| Port | `5432` |
| Maintenance database | `postgres` |
| Username | `postgres` |
| Password | `postgres` |

> Se rodar pgAdmin **também via Docker**, host fica `pg-empresa` (nome do container) e os containers precisam estar na mesma network.

### D. Rodar script SQL do host no container

```bash
docker exec -i pg-empresa psql -U postgres -d bd_empresa < setup.sql
```

> `-i` (sem `t`) pra aceitar stdin redirecionado.

### E. Query inline

```bash
docker exec pg-empresa psql -U postgres -d bd_empresa -c "SELECT COUNT(*) FROM FUNCIONARIO;"
```

---

## 5. Comandos Docker Essenciais

```bash
docker ps                       # containers rodando
docker ps -a                    # todos (incluindo parados)
docker logs pg-empresa          # ver logs
docker logs -f pg-empresa       # acompanha em tempo real
docker stop pg-empresa          # para
docker start pg-empresa         # retoma (não perde dados do volume)
docker restart pg-empresa       # reinicia
docker rm pg-empresa            # remove container (precisa parar antes)
docker rm -f pg-empresa         # força remove (para + remove)

docker volume ls                # lista volumes
docker volume inspect pg_empresa_data
docker volume rm pg_empresa_data   # apaga dados de vez

docker images                   # imagens baixadas
docker rmi postgres:16          # remove imagem (libera espaço)
```

---

## 6. Importar/Exportar Dados

### Backup (host)

```bash
docker exec pg-empresa pg_dump -U postgres bd_empresa > backup.sql
```

### Restore

```bash
docker exec -i pg-empresa psql -U postgres -d bd_empresa < backup.sql
```

### Copiar arquivo host → container

```bash
docker cp setup.sql pg-empresa:/tmp/setup.sql
docker exec -it pg-empresa psql -U postgres -d bd_empresa -f /tmp/setup.sql
```

### Copiar arquivo container → host

```bash
docker cp pg-empresa:/var/log/postgresql/postgresql.log ./log.txt
```

---

## 7. Setup Completo BD Empresa via Docker (passo a passo)

```bash
# 1. Cria estrutura
mkdir bd-empresa-docker && cd bd-empresa-docker

# 2. Cria docker-compose.yml (copia o YAML da seção 3)
# 3. Cria setup.sql com o bloco Setup do handbook/06-handson.md
#    (só o conteúdo SQL — sem fences markdown)

# 4. Sobe tudo
docker compose up -d

# 5. Aguarda ~5s o Postgres iniciar
docker compose logs db | tail -20    # vê se subiu OK

# 6. Confere tabelas criadas
docker exec pg-empresa psql -U postgres -d bd_empresa -c "\dt"

# 7. Confere contagem
docker exec pg-empresa psql -U postgres -d bd_empresa -c "
SELECT 'FUNCIONARIO' tabela, COUNT(*) qtd FROM FUNCIONARIO
UNION ALL SELECT 'DEPARTAMENTO', COUNT(*) FROM DEPARTAMENTO
UNION ALL SELECT 'PROJETO', COUNT(*) FROM PROJETO
UNION ALL SELECT 'DEPENDENTE', COUNT(*) FROM DEPENDENTE;"
```

---

## 8. pgAdmin Também em Container (stack completa)

`docker-compose.yml` com pgAdmin junto:

```yaml
services:
  db:
    image: postgres:16
    container_name: pg-empresa
    environment:
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: bd_empresa
    ports:
      - "5432:5432"
    volumes:
      - pg_data:/var/lib/postgresql/data
      - ./setup.sql:/docker-entrypoint-initdb.d/01-setup.sql

  pgadmin:
    image: dpage/pgadmin4
    container_name: pgadmin
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@local.com
      PGADMIN_DEFAULT_PASSWORD: admin
    ports:
      - "5050:80"
    depends_on:
      - db

volumes:
  pg_data:
```

```bash
docker compose up -d
```

pgAdmin abre em http://localhost:5050 (login: `admin@local.com` / `admin`).

**Conectar nesse pgAdmin ao Postgres do compose:**
- Host: `db` (não `localhost` — é o nome do serviço dentro da network)
- Port: `5432`
- User: `postgres`
- Password: `postgres`

---

## 9. Troubleshooting

| Problema | Causa / Fix |
|----------|-------------|
| `port is already allocated` | Outro Postgres rodando na 5432. Para ele (`brew services stop postgresql`) ou troca pra `-p 5433:5432`. |
| `password authentication failed` | Senha errada. Confere `POSTGRES_PASSWORD` no compose. Lembra: muda só com volume vazio. |
| Container morre logo após subir | `docker logs pg-empresa` mostra motivo. Geralmente erro no setup.sql. |
| Setup.sql não rodou | Só roda se volume **vazio**. `docker compose down -v` + `up -d`. |
| pgAdmin não conecta | Se ambos em compose, host é `db` (serviço), não `localhost`. |
| Dados sumiram | Container sem volume nomeado. Sempre usa `-v nome:/path`. |

---

## 10. Limpeza Total (recomeçar do zero)

```bash
docker compose down -v          # para tudo + apaga volumes
docker system prune -a          # remove imagens não usadas (libera GB)
docker volume prune             # remove volumes órfãos
```

---

## 11. Vantagens vs Local

| Aspecto | Container | Local (brew) |
|---------|-----------|--------------|
| Isolamento | ✅ Não suja host | ❌ Polui sistema |
| Reset rápido | ✅ `compose down -v` | ⚠️ Manual |
| Versão específica | ✅ `postgres:16`, `postgres:15` | Uma só por vez |
| Compartilhar setup | ✅ `docker-compose.yml` no git | ❌ Cada um instala |
| Performance | ⚠️ Levemente menor | ✅ Nativo |
| Recursos (RAM) | ⚠️ Mais consumo | ✅ Menos |

Pra estudo: **container ganha** (limpo, descartável, reproduzível).
