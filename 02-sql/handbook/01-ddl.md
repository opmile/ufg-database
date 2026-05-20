# T18 — DDL (Data Definition Language)

## Conceito Central

> **DDL define a estrutura.** Cria, altera, remove tabelas e restrições. NÃO mexe em dados (isso é DML).

---

## Comandos DDL — Essenciais

| Comando | Função |
|---------|--------|
| `CREATE TABLE` | Cria relação (tabela) |
| `ALTER TABLE ... ADD COLUMN` | Adiciona atributo |
| `ALTER TABLE ... DROP COLUMN` | Remove atributo |
| `ALTER TABLE ... ADD CONSTRAINT` | Adiciona restrição |
| `ALTER TABLE ... DROP CONSTRAINT` | Remove restrição |
| `ALTER TABLE ... ALTER COLUMN` | Muda definição de coluna (tipo/null) |
| `DROP TABLE` | Remove tabela inteira |

---

## CREATE TABLE — Forma Canônica

```sql
CREATE TABLE FUNCIONARIO (
    Pnome           VARCHAR(20)   NOT NULL,
    Minicial        CHAR(1)       NOT NULL,
    Unome           VARCHAR(20)   NOT NULL,
    Cpf             CHAR(9)       NOT NULL,
    Datanasc        DATE          NOT NULL,
    Endereco        VARCHAR(40)   NOT NULL,
    Sexo            CHAR(1)       NOT NULL,
    Salario         NUMERIC(20,2) NOT NULL,
    Cpf_supervisor  CHAR(9)       NULL,
    Dnr             INT           NOT NULL,
    PRIMARY KEY (Cpf),
    FOREIGN KEY (Cpf_supervisor) REFERENCES FUNCIONARIO(Cpf)
);
```

### Tipos comuns

| Tipo | Uso |
|------|-----|
| `INT` / `INTEGER` | Inteiro |
| `NUMERIC(p,s)` / `DECIMAL(p,s)` | Decimal exato (dinheiro!) |
| `CHAR(n)` | String tamanho fixo |
| `VARCHAR(n)` | String tamanho variável |
| `DATE` | Data |
| `TIMESTAMP` | Data + hora |
| `BOOLEAN` | Verdadeiro/falso |

---

## Restrições de Integridade

| Restrição | Sintaxe inline | Sintaxe nomeada |
|-----------|----------------|------------------|
| Domínio | `Sexo CHAR(1) NOT NULL` | — |
| NOT NULL | `Salario NUMERIC(20,2) NOT NULL` | — |
| PK | `PRIMARY KEY (Cpf)` | `CONSTRAINT FUNC_PK PRIMARY KEY (Cpf)` |
| FK | `FOREIGN KEY (Dnr) REFERENCES DEPARTAMENTO(Dnumero)` | `CONSTRAINT FUNC_FK_DEPTO FOREIGN KEY ...` |
| UNIQUE | `UNIQUE (Cpf)` | `CONSTRAINT FUNC_UQ UNIQUE (Cpf)` |
| CHECK | `CHECK (Sexo IN ('M','F'))` | `CONSTRAINT FUNC_CK_SEXO CHECK (...)` |
| DEFAULT | `Sexo CHAR(1) DEFAULT 'M'` | — |

### Por que nomear constraint?
Pra poder removê-la depois com `DROP CONSTRAINT nome_da_constraint`. Constraint anônima não dá pra dropar facilmente.

---

## ALTER TABLE — Padrões

```sql
-- Adicionar PK depois da criação
ALTER TABLE FUNCIONARIO
    ADD CONSTRAINT FUNCIONARIO_PK PRIMARY KEY (Cpf);

-- Adicionar FK
ALTER TABLE FUNCIONARIO
    ADD CONSTRAINT FUNCIONARIO_FK_SUPERVISAO
        FOREIGN KEY (Cpf_supervisor) REFERENCES FUNCIONARIO(Cpf);

-- Adicionar coluna
ALTER TABLE FUNCIONARIO
    ADD Email VARCHAR(255) NOT NULL;

-- Remover coluna
ALTER TABLE FUNCIONARIO
    DROP COLUMN Email;

-- Adicionar CHECK
ALTER TABLE FUNCIONARIO
    ADD CONSTRAINT FUNCIONARIO_CK_SEXO
        CHECK (Sexo IN ('M','F','m','f'));

-- Remover constraint
ALTER TABLE FUNCIONARIO
    DROP CONSTRAINT FUNCIONARIO_PK;
```

---

## Mapeamento Restrições → DDL

| Restrição teórica | Como aparece no DDL |
|-------------------|----------------------|
| Integridade de **domínio** | Tipo + `NOT NULL` + `CHECK` |
| Integridade de **chave** | `PRIMARY KEY` + `UNIQUE` |
| Integridade de **entidade** | `PRIMARY KEY` (que implica NOT NULL) |
| Integridade **referencial** | `FOREIGN KEY ... REFERENCES ...` |

---

## Ordem de Criação (importa!)

FK só pode referenciar tabela que **já existe**. Logo:

```
1. Tabelas sem FK (DEPARTAMENTO básico)
2. Tabelas com FK pra (1)        (FUNCIONARIO referencia DEPARTAMENTO)
3. Resolve dependência circular   (ALTER TABLE depois pra adicionar FK do gerente)
4. Tabelas associativas/composição (TRABALHA_EM, DEPENDENTE, LOCALIZACAO_DEP)
```

**Truque do BD Empresa:** FUNCIONARIO ↔ DEPARTAMENTO têm referência circular (funcionário trabalha em depto, depto tem funcionário gerente). Cria DEPARTAMENTO sem FK_GERENTE primeiro, depois `ALTER TABLE` pra adicionar.

---

## ⚠️ SQLite — Limitações de DDL

SQLite (usado no hands-on) tem ALTER TABLE bem **restrito**:

| Comando | SQLite | Padrão (Postgres/MariaDB) |
|---------|--------|----------------------------|
| `ALTER TABLE ... ADD COLUMN` | ✅ | ✅ |
| `ALTER TABLE ... DROP COLUMN` | ✅ (3.35+) | ✅ |
| `ALTER TABLE ... ADD CONSTRAINT` | ❌ **NÃO** | ✅ |
| `ALTER TABLE ... DROP CONSTRAINT` | ❌ **NÃO** | ✅ |
| `ALTER TABLE ... ALTER COLUMN TYPE` | ❌ **NÃO** | ✅ |

**Workaround SQLite:** toda constraint precisa entrar no `CREATE TABLE`. Pra alterar constraint depois, tem que recriar a tabela (CREATE nova → INSERT SELECT da antiga → DROP antiga → RENAME).

> Mas pra **prova**, escreve a sintaxe ANSI (com ALTER ADD CONSTRAINT) — é o padrão. SQLite é só pra prática local.

---

## Erros Comuns

| ❌ Erro | ✅ Correto |
|---------|-----------|
| FK referenciando tabela que ainda não foi criada | Criar primeiro a tabela referenciada |
| PK como NOT NULL explícito (redundante) | `PRIMARY KEY` já implica NOT NULL |
| `VARCHAR` sem tamanho | Sempre `VARCHAR(n)` |
| Confundir `CHAR(n)` com `VARCHAR(n)` | CHAR é fixo (preenche com espaços); VARCHAR é variável |
| Esquecer constraint nomeada | Nomeia se for ALTER depois |

---

## Checklist DDL

- [ ] Sei diferenciar DDL, DML, DCL
- [ ] Escrevo `CREATE TABLE` com PK e FK
- [ ] Sei adicionar/remover constraint via `ALTER TABLE`
- [ ] Sei adicionar/remover coluna via `ALTER TABLE`
- [ ] Mapeio as 4 restrições de integridade pra DDL
- [ ] Sei a ordem de criação quando há FK circular
