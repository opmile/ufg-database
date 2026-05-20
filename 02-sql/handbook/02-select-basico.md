# T19 — DML: SELECT Básico

## Conceito Central

> **SELECT consulta dados.** Estrutura mínima: `SELECT ... FROM ... WHERE ...`

---

## Anatomia Básica

```sql
SELECT  lista-de-atributos        -- O QUE retornar (projeção)
FROM    lista-de-relações         -- DE ONDE buscar
WHERE   predicado-de-seleção      -- QUAIS tuplas (filtro)
```

### Equivalências SQL ↔ Álgebra (só pra entender, não pra escrever)

| Operação | SQL |
|----------|-----|
| Seleção `σ` | `WHERE` |
| Projeção `π` | lista após `SELECT` |
| Produto cartesiano `×` | `,` ou `CROSS JOIN` |
| Junção `⨝` | `JOIN ... ON ...` |
| Renomeação `ρ` | `AS` |

> Esquece a notação grega na hora de escrever query. **SQL não é álgebra reescrita.**

---

## Exemplos Graduados

### 1. Tudo de uma tabela

```sql
SELECT * FROM FUNCIONARIO;
```

### 2. Projeção (algumas colunas)

```sql
SELECT Cpf, Pnome, Unome FROM FUNCIONARIO;
```

### 3. Seleção (filtro de linhas)

```sql
SELECT Cpf, Pnome, Unome
FROM FUNCIONARIO
WHERE Sexo = 'F';
```

### 4. Literais e expressões na projeção

```sql
SELECT 'Feminino' AS Categoria, Pnome, Unome, 10 AS Constante, NULL AS Obs
FROM FUNCIONARIO
WHERE Sexo = 'F';
```

### 5. Computação no SELECT e no WHERE

```sql
SELECT Cpf, Pnome, Unome, Salario, Salario * 1.1 AS NovoSalario
FROM FUNCIONARIO
WHERE Sexo = 'M'
  AND Salario > 25000
  AND (Salario + 5000) > (Salario * 1.1);
```

### 6. Renomeação (alias) com `AS`

```sql
SELECT FUNC.Cpf,
       FUNC.Pnome AS 'Primeiro Nome',
       'Valor'    AS Constante,
       Salario * 1.1 AS NovoSalario
FROM FUNCIONARIO AS FUNC
WHERE Salario > 30000;
```

> `AS` é **opcional** na maioria dos SGBDs (PostgreSQL, MariaDB):
> `FROM FUNCIONARIO FUNC` funciona igual. Em SELECT pode ficar `Salario * 1.1 NovoSalario`.

---

## Operadores de Comparação

| Operador | Significado |
|----------|-------------|
| `=`  `<>` ou `!=` | Igual / diferente |
| `<`  `>`  `<=`  `>=` | Comparações |
| `BETWEEN x AND y` | Faixa (inclusiva nos dois lados) |
| `NOT BETWEEN x AND y` | Fora da faixa |
| `IN (v1, v2, ...)` | Pertence à lista |
| `NOT IN (...)` | Não pertence |
| `LIKE 'padrão'` | Casamento de string |
| `IS NULL` / `IS NOT NULL` | Teste de nulidade (ver T20) |
| `AND` `OR` `NOT` | Conectivos lógicos |

### BETWEEN, IN, NOT — Exemplos

```sql
-- Faixa
SELECT Cpf, Pnome, Salario
FROM FUNCIONARIO
WHERE Salario BETWEEN 30000 AND 50000;

-- Fora da faixa
WHERE Salario NOT BETWEEN 30000 AND 50000

-- Lista de valores
WHERE Salario IN (40000, 50000, 43000)

-- Negação da lista
WHERE Salario NOT IN (40000, 50000, 43000)
```

---

## LIKE — Casamento de Padrões

| Curinga | Casa |
|---------|------|
| `%` | Zero ou mais caracteres quaisquer |
| `_` | Exatamente UM caractere |

```sql
-- Termina com 'a'
WHERE Pnome LIKE '%a'

-- Começa com 'A'
WHERE Pnome LIKE 'A%'

-- Contém 'SILVA'
WHERE Nome LIKE '%SILVA%'

-- Segunda letra é 'a'
WHERE Pnome LIKE '_a%'

-- Negação
WHERE Pnome NOT LIKE '%a'
```

**Dica:** `LIKE` é case-sensitive em MariaDB/PostgreSQL na configuração padrão. Pra ignorar caso: `LOWER(Pnome) LIKE '%a%'`.

---

## DISTINCT — Eliminar Duplicatas

```sql
-- Salários distintos (sem repetição)
SELECT DISTINCT Salario FROM FUNCIONARIO;

-- Equivalentes (com duplicatas):
SELECT Salario FROM FUNCIONARIO;        -- ALL implícito
SELECT ALL Salario FROM FUNCIONARIO;    -- ALL explícito
```

> Por padrão SQL retorna **com duplicatas** (multiconjunto), diferente da relação matemática que é conjunto. Pra ter comportamento de conjunto → `DISTINCT`.

---

## Funções de String e Data (varia por SGBD)

| O que faz | MariaDB | PostgreSQL | SQLite (hands-on) |
|-----------|---------|------------|--------------------|
| Concatena | `CONCAT(a,b,c)` | `a \|\| b` ou `CONCAT(...)` | `a \|\| b \|\| c` |
| Tamanho da string | `CHAR_LENGTH(s)` | `CHAR_LENGTH(s)` ou `LENGTH(s)` | `LENGTH(s)` |
| Caixa alta/baixa | `UPPER(s)`/`LOWER(s)` | Igual | Igual |
| Data/hora atual | `NOW()` | `NOW()` / `CURRENT_TIMESTAMP` | `datetime('now')` |
| Ano de uma data | `YEAR(d)` | `EXTRACT(YEAR FROM d)` | `strftime('%Y', d)` |
| Mês / dia | `MONTH(d)` / `DAY(d)` | `EXTRACT(MONTH FROM d)` | `strftime('%m', d)` |

### Exemplo SQLite (compatível com DB Browser)

```sql
SELECT
    Pnome || ' ' || Minicial || ' ' || Unome AS 'Nome Completo',
    LENGTH(Pnome) AS 'Tamanho Pnome',
    Datanasc
FROM FUNCIONARIO;
```

### Exemplo padrão MariaDB (cai na prova)

```sql
SELECT
    CONCAT(Pnome, ' ', Minicial, ' ', Unome) AS 'Nome Completo',
    CHAR_LENGTH(Pnome) AS 'Tamanho Pnome',
    Datanasc
FROM FUNCIONARIO;
```

> **Pra prova:** decora a sintaxe **MariaDB** (`CONCAT`, `CHAR_LENGTH`, `YEAR(...)`) — é o que o professor usa. SQLite é pra prática local.

---

## Produto Cartesiano vs JOIN (introdução)

```sql
-- Produto cartesiano (TODAS combinações — quase sempre errado!)
SELECT * FROM FUNCIONARIO, DEPARTAMENTO;
SELECT * FROM FUNCIONARIO CROSS JOIN DEPARTAMENTO;

-- JOIN com condição (correto)
SELECT Pnome, Unome, Salario
FROM FUNCIONARIO, DEPARTAMENTO
WHERE Dnr = Dnumero AND Dnome = 'Pesquisa';

-- Equivalente com JOIN explícito (PREFERIR)
SELECT Pnome, Unome, Salario
FROM FUNCIONARIO JOIN DEPARTAMENTO
    ON Dnr = Dnumero
WHERE Dnome = 'Pesquisa';
```

> Detalhe de T20: JOIN explícito é mais legível e separa claramente **condição de junção** (`ON`) de **filtro de tuplas** (`WHERE`). Vai aprofundar no próximo tópico.

---

## Erros Comuns

| ❌ Erro | ✅ Correto |
|---------|-----------|
| `WHERE Pnome = '%a%'` | `WHERE Pnome LIKE '%a%'` |
| `WHERE Salario = NULL` | `WHERE Salario IS NULL` (ver T20) |
| Esquecer `WHERE` em JOIN com vírgula → produto cartesiano gigante | Sempre escrever condição ou usar `JOIN ... ON` |
| Usar `=` com lista | Usar `IN (v1, v2)` |
| `BETWEEN` exclusivo | É **inclusivo** nos dois lados |
| Alias do SELECT no WHERE | Não funciona (WHERE roda antes do SELECT) |

---

## Checklist SELECT

- [ ] Sei a estrutura `SELECT ... FROM ... WHERE`
- [ ] Sei usar alias com `AS`
- [ ] Domino `BETWEEN`, `IN`, `LIKE` com `%` e `_`
- [ ] Sei o que `DISTINCT` faz e quando usar
- [ ] Sei diferença entre produto cartesiano e JOIN
- [ ] Sei concatenar com `CONCAT` ou `||`
