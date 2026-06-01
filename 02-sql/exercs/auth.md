# Auth Database

No PostgreSQL, "usuário" e "role" são a mesma coisa — um role com a flag `LOGIN` é o que chamamos de usuário. O par usuário/senha existe para **autenticação**: provar quem está conectando. Separado disso há a **autorização** (o que esse role pode fazer: quais tabelas, schemas, etc.).

**Significado e relevância**

O usuário identifica *quem* conecta; a senha é uma das formas de provar essa identidade. A relevância prática vai além de segurança: você normalmente cria roles distintos por aplicação/serviço para isolar permissões (princípio do menor privilégio) e para auditoria — saber qual conexão fez o quê.

**Podem ser aleatórios? Pode não ter auth?**

Sim para ambos, com ressalvas:

- **Senha aleatória**: não só pode como é recomendado para serviços. O Postgres não liga para o conteúdo da senha; quem injeta no app costuma ser uma variável de ambiente ou um secret manager. Gerar algo como `openssl rand -base64 32` é prática comum.
- **Sem autenticação**: depende do `pg_hba.conf`, que decide *como* cada conexão é autenticada antes mesmo da senha entrar em jogo. Métodos relevantes:
  - `trust` — conecta sem senha alguma (útil só em dev local, perigoso em rede aberta).
  - `scram-sha-256` — o padrão moderno e recomendado para senha.
  - `md5` — legado, evite.
  - `peer` — mapeia o usuário do SO local ao role do banco (comum em conexões locais via socket Unix).

Ou seja: a senha pode ser irrelevante se o `pg_hba.conf` usar `trust` ou `peer`. O nome do usuário em si não é "aleatório" — é um identificador, então use algo legível e estável.

**Criando um usuário via psql**

```sql
CREATE ROLE milena WITH LOGIN PASSWORD 'senha_forte_aqui';
```

`LOGIN` é o que torna o role um usuário capaz de conectar. Sem isso, vira um role de agrupamento de permissões.

Flags úteis conforme o caso:

```sql
CREATE ROLE app_service WITH LOGIN PASSWORD 'xxx'
  NOSUPERUSER NOCREATEDB NOCREATEROLE
  CONNECTION LIMIT 20;
```

Depois você concede privilégios explicitamente:

```sql
GRANT CONNECT ON DATABASE meu_banco TO app_service;
GRANT USAGE ON SCHEMA public TO app_service;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_service;
```

Pelo terminal, sem entrar no prompt interativo:

```bash
psql -U postgres -c "CREATE ROLE milena WITH LOGIN PASSWORD 'senha';"
```

Uma observação de segurança: senha em comando SQL pode vazar no histórico do shell e nos logs do servidor. Para algo sensível, use `\password milena` dentro do psql (ele pede a senha interativamente e não registra em texto claro) ou a variável `PGPASSWORD`/arquivo `.pgpass` para a conexão.