# T20 — Joins, NULL, Outer Join

> **Esse tópico é o mais cobrado.** Domina ele = passa.

---

## Tipos de JOIN

| Tipo | O que retorna |
|------|---------------|
| `INNER JOIN` (ou só `JOIN`) | Só tuplas que **casam** dos dois lados |
| `LEFT [OUTER] JOIN` | Todas da esquerda + casadas da direita (NULL na direita se não casar) |
| `RIGHT [OUTER] JOIN` | Todas da direita + casadas da esquerda |
| `FULL [OUTER] JOIN` | Todas dos dois lados (NULL onde não casa) |
| `NATURAL JOIN` | INNER JOIN automático em atributos com **mesmo nome** |
| `CROSS JOIN` | Produto cartesiano (todas combinações) |

```
              A         B
            ┌───┐     ┌───┐
INNER:      │ ∩ │     │ ∩ │   só interseção
LEFT:       │AAA│ + ∩ │   │   tudo de A + match de B
RIGHT:      │   │ ∩ + │BBB│   tudo de B + match de A
FULL:       │AAA│ + ∩ + │BBB│ tudo dos dois
```

---

## INNER JOIN — Padrão

### Sintaxe moderna (PREFERIR)

```sql
SELECT Pnome, Unome, Dnome
FROM FUNCIONARIO JOIN DEPARTAMENTO
    ON Dnr = Dnumero
WHERE Dnome = 'Pesquisa';
```

### Sintaxe antiga (vírgula no FROM)

```sql
SELECT Pnome, Unome, Dnome
FROM FUNCIONARIO, DEPARTAMENTO
WHERE Dnr = Dnumero
  AND Dnome = 'Pesquisa';
```

> As duas funcionam. Moderna é mais legível porque separa **condição de junção** do **filtro**.

---

## Desambiguação de Atributos

Quando duas tabelas têm coluna com mesmo nome → **qualifica**:

```sql
-- FUNCIONARIO.Sexo e DEPENDENTE.Sexo ambos existem → ambíguo
SELECT Pnome, F.Sexo, Nome_dependente, D.Sexo
FROM FUNCIONARIO AS F JOIN DEPENDENTE AS D
    ON Cpf = Fcpf;
```

**Alias de tabela** (`AS F`, `AS D`) ajuda a encurtar e desambiguar.

---

## Auto-Junção (Self-Join)

Mesma tabela duas vezes com aliases diferentes — clássico pra hierarquias (chefe/subordinado, supervisor):

```sql
-- Funcionário + nome do supervisor
SELECT FUNC.Pnome, FUNC.Unome, SUPER.Pnome AS SuperPnome, SUPER.Unome AS SuperUnome
FROM FUNCIONARIO AS FUNC JOIN FUNCIONARIO AS SUPER
    ON FUNC.Cpf_supervisor = SUPER.Cpf;
```

> Sem aliases isso não compila. Não dá pra referenciar a mesma tabela duas vezes sem nome distinto.

---

## NATURAL JOIN

Junta automaticamente por **todas as colunas com nome igual**.

```sql
-- Funciona se Cpf existir nas duas tabelas com mesmo nome
SELECT Pnome, Unome
FROM FUNCIONARIO NATURAL JOIN DEPENDENTE;
```

**Problema:** no BD Empresa, FK em DEPENDENTE chama `Fcpf` (não `Cpf`). Então NATURAL JOIN não junta direto — precisa **renomear** com subquery:

```sql
SELECT Pnome, Sexo, Nome_dependente, Sexo_dependente
FROM FUNCIONARIO NATURAL JOIN
    ( SELECT Fcpf AS Cpf, Nome_dependente, Sexo AS Sexo_dependente
      FROM DEPENDENTE ) AS D;
```

> **Conselho prático:** evita NATURAL JOIN. Usa `JOIN ... ON` sempre. É mais explícito, menos sujeito a quebrar quando alguém adiciona coluna com nome casual.

> Mas se cair na prova "transforme em natural join", sabe que precisa renomear pra alinhar nomes das colunas de junção.

---

## JOIN com 3+ Tabelas

Encadeia:

```sql
-- Projetos em São Paulo, nome do depto e gerente
SELECT Projnome, Dnome, Pnome, Unome
FROM PROJETO
    JOIN DEPARTAMENTO ON Dnumero = Dnum
    JOIN FUNCIONARIO  ON Cpf_gerente = Cpf
WHERE Projlocal = 'Sao Paulo';

-- 4 tabelas: funcionário, depto, alocações, projetos
SELECT Pnome, Unome, Dnome, Projnome
FROM FUNCIONARIO
    JOIN DEPARTAMENTO ON Dnr = Dnumero
    JOIN TRABALHA_EM  ON Cpf = Fcpf
    JOIN PROJETO      ON Pnr = Projnumero;
```

**Padrão mental:**
1. Começa pela tabela "mais à direita" do relacionamento (ou qualquer uma — dá no mesmo).
2. Adiciona JOIN pra cada FK que você precisa atravessar.
3. Cada JOIN precisa de `ON` com a condição de igualdade da FK.

---

## NULL — Comportamento

> **Regra de ouro:** NULL ≠ NULL. NULL não é zero, não é string vazia. É **ausência**.

### Sempre teste com IS NULL / IS NOT NULL

```sql
-- ✅ Correto
WHERE Cpf_supervisor IS NULL
WHERE Cpf_supervisor IS NOT NULL

-- ❌ NÃO faça isso (sempre retorna desconhecido/false)
WHERE Cpf_supervisor = NULL
WHERE Cpf_supervisor <> NULL
```

### Aritmética com NULL → NULL

```
(5 + NULL)    → NULL
(NULL * 10)   → NULL
```

### Comparações com NULL → NULL (UNKNOWN)

```
(5 < NULL)    → NULL
(NULL = NULL) → NULL
(NULL <> NULL)→ NULL
```

### Tabela-verdade de 3 valores (TRUE, FALSE, NULL)

| Operação | Resultado |
|----------|-----------|
| `TRUE  OR  NULL` | `TRUE`  |
| `FALSE OR  NULL` | `NULL`  |
| `NULL  OR  NULL` | `NULL`  |
| `TRUE  AND NULL` | `NULL`  |
| `FALSE AND NULL` | `FALSE` |
| `NULL  AND NULL` | `NULL`  |
| `NOT NULL`       | `NULL`  |

### Regra do WHERE

> **WHERE só seleciona tupla quando o predicado avalia para TRUE.**
> NULL e FALSE são descartados.

Isso significa: se o filtro envolve coluna com NULL, a tupla geralmente é **excluída** silenciosamente. Esse é o ponto que cai em prova.

---

## Funções para Tratar NULL

```sql
-- COALESCE (PADRÃO SQL, funciona em MariaDB e PostgreSQL)
SELECT Cpf, Pnome, COALESCE(Cpf_supervisor, 'sem supervisor') AS Sup
FROM FUNCIONARIO;

-- CASE WHEN (verboso mas universal)
SELECT Cpf, Pnome,
    CASE WHEN Cpf_supervisor IS NULL THEN 'sem supervisor'
         ELSE Cpf_supervisor
    END AS Sup
FROM FUNCIONARIO;

-- ISNULL (só MariaDB/SQL Server, NÃO usa em PostgreSQL)
SELECT Cpf, Pnome, ISNULL(Cpf_supervisor, 'sem supervisor') AS Sup
FROM FUNCIONARIO;
```

> **Usa `COALESCE`** — é padrão SQL e portável.

---

## OUTER JOIN

### LEFT OUTER JOIN (mais comum)

Pega tudo da esquerda mesmo sem match na direita:

```sql
-- Lista todos os funcionários, com supervisor se houver
SELECT FUNC.Pnome, FUNC.Unome, SUPER.Pnome AS Sup_Pnome, SUPER.Unome AS Sup_Unome
FROM FUNCIONARIO AS FUNC
    LEFT OUTER JOIN FUNCIONARIO AS SUPER
    ON FUNC.Cpf_supervisor = SUPER.Cpf;
```

Resultado: funcionário sem supervisor aparece com `NULL` nas colunas SUPER.*.

### RIGHT OUTER JOIN

Espelhado. Raramente usado — gente prefere reescrever como LEFT trocando ordem das tabelas.

### FULL OUTER JOIN

Tudo dos dois lados. PostgreSQL suporta nativo; MariaDB não tem direto (simula com UNION de LEFT e RIGHT).

```
Mnemônico:
- INNER  = só interseção
- LEFT   = tudo da esquerda (mesmo que não case)
- RIGHT  = tudo da direita
- FULL   = tudo dos dois
```

---

## Pegadinhas Clássicas (caem em prova!)

### Pegadinha 1: NULL no WHERE

```sql
-- Relação R = (12, 15, 5100), (13, NULL, 3500), (14, NULL, NULL), (15, 12, NULL)
SELECT * FROM R WHERE (at2 < 12) OR (at3 < 3000);
```

Avaliando linha a linha:
- `(12, 15, 5100)`: `(15<12) OR (5100<3000)` = `F OR F` = **F** → ❌
- `(13, NULL, 3500)`: `(NULL<12) OR (3500<3000)` = `NULL OR F` = **NULL** → ❌
- `(14, NULL, NULL)`: `NULL OR NULL` = **NULL** → ❌
- `(15, 12, NULL)`: `(12<12) OR (NULL<3000)` = `F OR NULL` = **NULL** → ❌

**Retorna 0 tuplas.**

### Pegadinha 2: Tautologia com NULL

```sql
SELECT * FROM R WHERE (at2 > 12) OR NOT (at2 > 12);
```

Para `at2 = NULL` (linhas 2 e 3):
- `(NULL>12) OR NOT (NULL>12)` = `NULL OR NOT NULL` = `NULL OR NULL` = **NULL** → ❌

Para `at2 = 15`: `(15>12) OR NOT (15>12)` = `T OR F` = **T** → ✅
Para `at2 = 12`: `(12>12) OR NOT (12>12)` = `F OR T` = **T** → ✅

**Retorna 2 tuplas** (não 4 como "intuição" sugere!).

### Pegadinha 3: Auto-comparação com NULL

```sql
SELECT * FROM R WHERE (NOT at2 < at2) AND (at3 > at2);
```

Para `at2 = NULL`: `NOT(NULL<NULL)` = `NOT NULL` = NULL → AND derruba pra NULL → ❌
Para `(12, 15, 5100)`: `NOT(15<15) AND (5100>15)` = `T AND T` = **T** → ✅
Para `(15, 12, NULL)`: `NOT(12<12) AND (NULL>12)` = `T AND NULL` = NULL → ❌

**Retorna 1 tupla.**

---

## Erros Comuns

| ❌ Erro | ✅ Correto |
|---------|-----------|
| `WHERE x = NULL` | `WHERE x IS NULL` |
| Esquecer `ON` no JOIN | Sempre `JOIN T2 ON cond` |
| Auto-join sem alias | Usa `T AS A JOIN T AS B` |
| Assumir que `NOT NULL = TRUE` em WHERE | NOT NULL = NULL → tupla é excluída |
| Usar NATURAL JOIN sem checar nomes | Use `JOIN ... ON` |
| FULL OUTER JOIN no MariaDB | Não suporta; usa UNION |

---

## Checklist Joins + NULL

- [ ] Sei diferenciar INNER, LEFT, RIGHT, FULL
- [ ] Sei escrever JOIN com 3+ tabelas
- [ ] Sei fazer auto-join com aliases
- [ ] Sei desambiguar colunas com `Tabela.coluna`
- [ ] Sei a regra: predicado NULL → tupla excluída do WHERE
- [ ] Sei tabela-verdade de 3 valores (TRUE/FALSE/NULL)
- [ ] Uso `IS NULL` (nunca `= NULL`)
- [ ] Sei usar `COALESCE`
- [ ] Resolvo exercício de avaliação de NULL no WHERE
