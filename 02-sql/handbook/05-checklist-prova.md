# Checklist Pré-Prova — SQL

## Conceitos Fundamentais

### Categorias da SQL
- [ ] Diferenciar DDL, DML, DCL
- [ ] Listar comandos de cada categoria
- [ ] Saber que SQL é mais que SELECT

### Estrutura do SELECT
- [ ] Ordem que se escreve: `SELECT-FROM-WHERE-GROUP-HAVING-ORDER`
- [ ] Ordem que executa: `FROM-WHERE-GROUP-HAVING-SELECT-ORDER`
- [ ] Por que alias do SELECT não funciona no WHERE
- [ ] Por que HAVING vê agregação e WHERE não

---

## DDL (T18)

- [ ] Escrever `CREATE TABLE` completo com PK + FK
- [ ] Conhecer tipos: `INT`, `NUMERIC(p,s)`, `VARCHAR(n)`, `CHAR(n)`, `DATE`
- [ ] Adicionar/remover constraint via `ALTER TABLE`
- [ ] Adicionar/remover coluna via `ALTER TABLE`
- [ ] Resolver FK circular com `ALTER TABLE` depois

---

## SELECT Básico (T19)

- [ ] Projeção (lista colunas), alias com `AS`
- [ ] Filtro com `WHERE`, conectivos `AND/OR/NOT`
- [ ] `BETWEEN x AND y` (inclusivo!)
- [ ] `IN (...)` e `NOT IN (...)`
- [ ] `LIKE` com `%` (qualquer) e `_` (um caractere)
- [ ] `DISTINCT` pra eliminar duplicatas
- [ ] Expressão na projeção (`Salario * 1.1`)
- [ ] Funções: `CONCAT`, `CHAR_LENGTH`, `UPPER`, `LOWER`

---

## Joins + NULL (T20) ⭐⭐⭐

- [ ] INNER JOIN com `ON`
- [ ] LEFT/RIGHT/FULL OUTER JOIN
- [ ] Auto-join com aliases (`F AS FUNC JOIN F AS SUPER`)
- [ ] JOIN com 3+ tabelas encadeado
- [ ] Desambiguar coluna repetida com `T.coluna`
- [ ] **NUNCA** `= NULL` → sempre `IS NULL` / `IS NOT NULL`
- [ ] Tabela-verdade de 3 valores (TRUE/FALSE/NULL)
- [ ] WHERE só seleciona quando predicado = TRUE (NULL e FALSE descartam)
- [ ] `COALESCE(col, valor_default)` pra substituir NULL

---

## Agregação (T21) ⭐⭐⭐

- [ ] 5 agregadores: `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`
- [ ] `COUNT(*)` vs `COUNT(col)` vs `COUNT(DISTINCT col)`
- [ ] `SUM/AVG/MIN/MAX` ignoram NULL
- [ ] `GROUP BY` — toda coluna não-agregada do SELECT
- [ ] `HAVING` filtra grupos com agregação
- [ ] `ORDER BY` com `ASC/DESC`, posição numérica, alias
- [ ] Subqueries aninhadas (resolver de dentro pra fora)

---

## Tópicos Mais Cobrados

### ⭐⭐⭐ Alta Probabilidade

1. **Avaliação de predicado com NULL** (T20 — questão modelo: 4 tuplas, 3 predicados, quantas linhas retorna cada um)
2. **GROUP BY + HAVING com COUNT** (T21 — funcionários com N+ dependentes)
3. **JOIN de 3-4 tabelas** (T20 Ex. 06-07)
4. **Auto-join com alias** (T20 Ex. 03)
5. **Subquery com MIN/MAX no WHERE** (T21 exercícios)

### ⭐⭐ Média Probabilidade

1. LEFT OUTER JOIN (T20 Ex. 11)
2. DISTINCT + COUNT
3. NATURAL JOIN com renomeação
4. LIKE com `%` e `_`
5. Tipos de dados e constraints DDL

### ⭐ Menor Probabilidade

1. CASE WHEN
2. Funções de data (YEAR, MONTH — variam por SGBD)
3. CROSS JOIN explícito
4. ALTER TABLE em detalhe

---

## Pegadinhas

### Sobre NULL

| Pegadinha | Resposta |
|-----------|----------|
| `WHERE x = NULL` retorna o quê? | NADA (predicado = NULL, não TRUE) |
| `5 + NULL` é igual a `5`? | **NÃO** — é NULL |
| `NULL = NULL` é TRUE? | **NÃO** — é NULL |
| `COUNT(col)` conta NULL? | **NÃO** |
| `COUNT(*)` conta NULL? | **SIM** (conta linhas) |
| `SUM(col)` com NULL na coluna? | Ignora NULL, soma o resto |
| Tabela sem nenhuma linha — `COUNT(*)`? | Retorna **0** |
| Tabela sem nenhuma linha — `SUM(col)`? | Retorna **NULL** (não 0!) |

### Sobre JOIN

| Pegadinha | Resposta |
|-----------|----------|
| INNER JOIN inclui tuplas sem match? | **NÃO** — só com match dos dois lados |
| LEFT JOIN: o que aparece se não casa? | NULLs nas colunas da direita |
| Auto-join precisa de alias? | **SIM**, senão ambiguidade |
| NATURAL JOIN junta por nome de coluna? | **SIM** — por isso renomear às vezes é necessário |
| `JOIN ... ON` é igual a `,` no FROM com WHERE? | Equivalente em resultado, mas ON é mais legível |

### Sobre WHERE / HAVING / GROUP

| Pegadinha | Resposta |
|-----------|----------|
| Posso usar `COUNT(*)` no WHERE? | **NÃO** — só em HAVING |
| Posso usar alias do SELECT no WHERE? | **NÃO** (WHERE roda antes) |
| Posso usar alias do SELECT no ORDER BY? | **SIM** |
| Coluna do SELECT precisa estar no GROUP BY? | **SIM**, se não estiver agregada |
| Posso ter SELECT sem FROM? | Depende do SGBD; PostgreSQL sim, MariaDB sim |

### Sobre LIKE

| Pegadinha | Resposta |
|-----------|----------|
| `LIKE 'a%'` casa com 'a' sozinho? | **SIM** (`%` casa zero ou mais) |
| `LIKE '_'` casa com string vazia? | **NÃO** (`_` casa exatamente 1) |
| `LIKE` é case-sensitive? | Em geral **SIM** em MariaDB/PostgreSQL |

---

## V ou F — Treino

1. ( ) `WHERE x = NULL` retorna tuplas onde x é NULL
2. ( ) `COUNT(*)` ignora linhas com algum NULL
3. ( ) `SUM(col)` retorna 0 se a tabela está vazia
4. ( ) Em SQL, uma relação pode ter tuplas duplicadas no resultado
5. ( ) `HAVING` é avaliado antes do `GROUP BY`
6. ( ) `DISTINCT` afeta o GROUP BY
7. ( ) INNER JOIN é simétrico (ordem das tabelas não muda resultado)
8. ( ) LEFT JOIN é simétrico
9. ( ) `BETWEEN 10 AND 20` inclui o 10 e o 20
10. ( ) `NULL OR TRUE` retorna NULL
11. ( ) Pode usar alias do SELECT no WHERE
12. ( ) Pode usar alias do SELECT no ORDER BY
13. ( ) `COUNT(DISTINCT col)` conta NULL como valor distinto
14. ( ) FK pode ser NULL
15. ( ) PK pode ser NULL

**Respostas:** 1F, 2F, 3F (retorna NULL!), 4V, 5F, 6F, 7V, 8F, 9V, 10F (retorna TRUE), 11F, 12V, 13F, 14V, 15F

---

## Padrões de Questão Típicos

### Padrão 1: "Quais funcionários X..."
→ SELECT + FROM + WHERE simples
→ Se "X" envolve outra tabela → JOIN

### Padrão 2: "Para cada Y, ..."
→ Provavelmente `GROUP BY Y`
→ Verifica se precisa de agregação ou só listar

### Padrão 3: "Funcionários que têm pelo menos N..."
→ JOIN + GROUP BY + HAVING COUNT(...) >= N

### Padrão 4: "Funcionários sem X"
→ LEFT JOIN + WHERE X IS NULL
→ OU `NOT EXISTS` / `NOT IN` (subquery)

### Padrão 5: "O que tem maior/menor X"
→ Subquery com MAX/MIN no WHERE
→ `WHERE col = (SELECT MAX(col) FROM ...)`

### Padrão 6: "Avaliação de NULL"
→ Aplica tabela-verdade linha por linha
→ Só TRUE seleciona (NULL e FALSE descartam)

---

## Exercício Resolvido: BD Empresa

**"Para cada departamento, lista o nome do departamento, a quantidade de funcionários e a média salarial, mas só departamentos com 2+ funcionários, ordenado por média salarial decrescente."**

```sql
SELECT D.Dnome,
       COUNT(F.Cpf) AS Qtd_Func,
       AVG(F.Salario) AS Media_Sal
FROM DEPARTAMENTO AS D
    JOIN FUNCIONARIO AS F ON D.Dnumero = F.Dnr
GROUP BY D.Dnumero, D.Dnome
HAVING COUNT(F.Cpf) >= 2
ORDER BY Media_Sal DESC;
```

**Checklist do que precisa estar certo:**
- ✅ JOIN com ON
- ✅ Alias de tabela (`D`, `F`)
- ✅ GROUP BY com PK do depto (Dnumero) + Dnome
- ✅ HAVING com agregação (não WHERE!)
- ✅ ORDER BY com alias do SELECT
- ✅ DESC explícito
