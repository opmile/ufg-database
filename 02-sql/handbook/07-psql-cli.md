# psql — CLI Cheatsheet

> Cliente nativo PostgreSQL no terminal. Mais rápido que pgAdmin pra rodar script, inspecionar schema, debug.

---

## 1. Instalação (macOS)

Postgres já instalado? Provavelmente sim. Confere:

```bash
which psql
psql --version
```

Se não tem:
```bash
brew install postgresql@16
brew services start postgresql@16
```

---

## 2. Conexão

### Forma básica (usuário atual, banco `postgres`)

```bash
psql
```

### Banco específico

```bash
psql -d bd_empresa
```

### Tudo explícito

```bash
psql -h localhost -p 5432 -U postgres -d bd_empresa
```

### Via URL (estilo aplicações)

```bash
psql "postgresql://postgres:senha@localhost:5432/bd_empresa"
```

### Variáveis de ambiente (evita re-digitar)

```bash
export PGHOST=localhost
export PGPORT=5432
export PGUSER=postgres
export PGDATABASE=bd_empresa
psql              # já conecta usando as env vars
```

---

## 3. Meta-Comandos (começam com `\`)

| Comando | Faz |
|---------|-----|
| `\q` | Sai |
| `\l` | Lista bancos |
| `\c bd_empresa` | Conecta em outro banco |
| `\dt` | Lista tabelas do schema atual |
| `\dt+` | Lista tabelas com tamanho e descrição |
| `\d FUNCIONARIO` | Descreve tabela (colunas, tipos, índices, FKs) |
| `\d+ FUNCIONARIO` | Versão verbose |
| `\dn` | Lista schemas |
| `\df` | Lista funções |
| `\dv` | Lista views |
| `\di` | Lista índices |
| `\du` | Lista usuários/roles |
| `\dp` | Lista permissões |
| `\timing` | Liga/desliga cronômetro das queries |
| `\x` | Toggle expanded display (1 linha por coluna) |
| `\e` | Abre editor pra montar query grande |
| `\i arquivo.sql` | Executa script SQL |
| `\o resultado.txt` | Redireciona output pra arquivo |
| `\o` | Volta output pro terminal |
| `\?` | Help dos meta-comandos |
| `\h SELECT` | Help da sintaxe SQL do comando |
| `\copy tabela FROM 'arq.csv' CSV HEADER` | Importa CSV (lado cliente) |
| `\copy tabela TO 'arq.csv' CSV HEADER` | Exporta CSV |

---

## 4. Workflow Típico

### A. Cria banco + roda setup

```bash
# Cria banco direto pela CLI
createdb bd_empresa

# Roda script SQL (modo "menos digitação")
psql -d bd_empresa -f 02-sql/handbook/06-handson.md
# ⚠️ Esse comando NÃO funciona porque 06-handson.md tem markdown. Extrai SQL puro.

# Melhor: cria um setup.sql separado e roda
psql -d bd_empresa -f setup.sql
```

### B. Sessão interativa

```bash
psql -d bd_empresa
```

```
bd_empresa=# \dt
bd_empresa=# SELECT * FROM FUNCIONARIO LIMIT 5;
bd_empresa=# \d FUNCIONARIO
bd_empresa=# \q
```

### C. Query inline (sem entrar na shell)

```bash
psql -d bd_empresa -c "SELECT COUNT(*) FROM FUNCIONARIO;"
```

### D. Múltiplas queries via heredoc

```bash
psql -d bd_empresa <<EOF
SELECT D.Dnome, COUNT(F.Cpf) AS qtd
FROM DEPARTAMENTO D JOIN FUNCIONARIO F ON D.Dnumero = F.Dnr
GROUP BY D.Dnumero, D.Dnome;
EOF
```

---

## 5. Administração de Banco

```bash
# Cria
createdb bd_empresa
createdb -O milena bd_empresa     # com owner especifico

# Dropa
dropdb bd_empresa

# Restart limpo (drop + create)
dropdb bd_empresa && createdb bd_empresa
```

Equivalente via psql:
```sql
CREATE DATABASE bd_empresa;
DROP DATABASE bd_empresa;
```

> **Cuidado:** `DROP DATABASE` é irreversível. Confirma antes.

---

## 6. Dump / Restore

```bash
# Dump completo (schema + dados)
pg_dump bd_empresa > dump.sql

# Só schema
pg_dump --schema-only bd_empresa > schema.sql

# Só dados
pg_dump --data-only bd_empresa > data.sql

# Restore
psql -d bd_empresa_novo -f dump.sql
```

---

## 7. Atalhos de Display (sessão psql)

### Modo expandido (linhas grandes ficam legíveis)

```
bd_empresa=# \x on
bd_empresa=# SELECT * FROM FUNCIONARIO LIMIT 1;
-[ RECORD 1 ]--+----------------------
pnome          | Jorge
minicial       | E
unome          | Brito
cpf            | 88866555576
...
```

### Cronometrar queries

```
bd_empresa=# \timing
Timing is on.
bd_empresa=# SELECT COUNT(*) FROM FUNCIONARIO;
 count
-------
     8
(1 row)
Time: 0.412 ms
```

### Salvar resultado em arquivo

```
bd_empresa=# \o saida.txt
bd_empresa=# SELECT * FROM FUNCIONARIO;
bd_empresa=# \o
```

---

## 8. Comandos Úteis pra Estudar SQL

### Ver query plan (EXPLAIN)

```sql
EXPLAIN ANALYZE
SELECT F.Pnome, D.Dnome
FROM FUNCIONARIO F JOIN DEPARTAMENTO D ON F.Dnr = D.Dnumero;
```

Mostra como Postgres executa: sequential scan, index scan, hash join, etc.

### Ver constraints de uma tabela

```sql
SELECT conname, contype, pg_get_constraintdef(oid)
FROM pg_constraint
WHERE conrelid = 'funcionario'::regclass;
```

Ou meta-comando:
```
\d funcionario
```

### Ver FKs apontando pra uma tabela

```sql
SELECT
    conname AS fk_nome,
    conrelid::regclass AS tabela_origem,
    pg_get_constraintdef(oid)
FROM pg_constraint
WHERE confrelid = 'departamento'::regclass AND contype = 'f';
```

---

## 9. Atalhos de Teclado (na sessão psql)

| Atalho | Faz |
|--------|-----|
| `↑` / `↓` | Histórico de comandos |
| `Ctrl+R` | Busca reversa no histórico (igual bash/zsh) |
| `Ctrl+A` / `Ctrl+E` | Início / fim da linha |
| `Ctrl+L` | Limpa tela |
| `Ctrl+C` | Cancela query rodando ou comando em digitação |
| `Ctrl+D` (linha vazia) | Sai (equivalente a `\q`) |
| `Tab` | Auto-completa nome de tabela/coluna/comando |

---

## 10. Setup Rápido do BD Empresa via CLI

Salva o script setup como arquivo e roda:

```bash
# 1. Cria banco
createdb bd_empresa

# 2. Cria arquivo setup.sql com conteúdo do bloco Setup do 06-handson.md
# (manualmente — copia/cola do markdown removendo as fences ```)

# 3. Roda
psql -d bd_empresa -f setup.sql

# 4. Verifica
psql -d bd_empresa -c "\dt"
psql -d bd_empresa -c "SELECT COUNT(*) FROM FUNCIONARIO;"
```

---

## 11. Queries de Sanity Check

```bash
psql -d bd_empresa -c "
SELECT 'FUNCIONARIO' AS tabela, COUNT(*) AS qtd FROM FUNCIONARIO
UNION ALL SELECT 'DEPARTAMENTO',     COUNT(*) FROM DEPARTAMENTO
UNION ALL SELECT 'LOCALIZACAO_DEP',  COUNT(*) FROM LOCALIZACAO_DEP
UNION ALL SELECT 'PROJETO',          COUNT(*) FROM PROJETO
UNION ALL SELECT 'TRABALHA_EM',      COUNT(*) FROM TRABALHA_EM
UNION ALL SELECT 'DEPENDENTE',       COUNT(*) FROM DEPENDENTE;
"
```

Esperado: 8, 3, 5, 6, 16, 7.

---

## 12. Comparação Rápida pgAdmin ↔ psql

| Tarefa | pgAdmin | psql |
|--------|---------|------|
| Conectar banco | clicar árvore | `psql -d X` |
| Listar tabelas | expandir árvore | `\dt` |
| Ver estrutura | clicar tabela → Properties | `\d tabela` |
| Rodar query | Query Tool + ▶ | digita + Enter (ou `\i arquivo`) |
| Ver dados | View/Edit Data | `SELECT * FROM x LIMIT 10` |
| Importar SQL | abrir + executar | `psql -f arquivo.sql` |
| Exportar resultado | botão CSV | `\copy ... TO 'arq.csv' CSV HEADER` |
| Ver query plan | menu Explain | `EXPLAIN ANALYZE` |

> Pra estudo do dia-a-dia: **psql é mais rápido**. pgAdmin é melhor pra explorar visualmente schema desconhecido.

---

## 13. Configuração Pessoal (~/.psqlrc)

Opcional — cria `~/.psqlrc` pra customizar comportamento:

```
\set QUIET 1
\timing on
\x auto
\set HISTSIZE 2000
\set HISTCONTROL ignoredups
\set PROMPT1 '%[%033[1;33m%]%n@%/%[%033[0m%]%R%# '
\unset QUIET
```

Próxima vez que abrir psql: timing automático, expanded display inteligente, prompt colorido.
