# T21 — Agregação, GROUP BY, HAVING, ORDER BY

## Conceito Central

> **Agregação resume várias tuplas em UM valor.** Sem GROUP BY → resumo da tabela inteira. Com GROUP BY → um resumo por grupo.

---

## Estrutura SELECT Completa

```sql
SELECT     atributos-de-projeção
FROM       relações
WHERE      filtro-de-tuplas         -- antes do grupo
GROUP BY   atributos-de-agrupamento
HAVING     filtro-de-grupos         -- depois do grupo
ORDER BY   atributos-de-ordenação;
```

### Ordem lógica de execução

```
FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY
```

> Por que importa? Porque **WHERE não vê funções agregadas** (`COUNT`, `SUM`) — só `HAVING` vê. E **alias do SELECT não funciona no WHERE** mas funciona no ORDER BY.

---

## Funções Agregadas

| Função | Faz |
|--------|-----|
| `COUNT(*)` | Conta linhas (incluindo NULL) |
| `COUNT(coluna)` | Conta linhas onde coluna **não é NULL** |
| `COUNT(DISTINCT coluna)` | Conta valores distintos não-NULL |
| `SUM(coluna)` | Soma valores não-NULL |
| `AVG(coluna)` | Média de valores não-NULL |
| `MIN(coluna)` | Menor valor |
| `MAX(coluna)` | Maior valor |

### Detalhe crítico: agregação ignora NULL

```sql
-- Se há 10 funcionários e 3 têm Cpf_supervisor NULL:
SELECT COUNT(*)              FROM FUNCIONARIO; -- 10
SELECT COUNT(Cpf_supervisor) FROM FUNCIONARIO; -- 7  (ignora os NULL)
SELECT COUNT(DISTINCT Cpf_supervisor) FROM FUNCIONARIO; -- nº de supervisores únicos
```

---

## Exemplos Graduados

### 1. Agregação sem grupo (tabela inteira)

```sql
-- Quantidade, soma, média de salários
SELECT COUNT(Cpf), SUM(Salario), AVG(Salario)
FROM FUNCIONARIO;
```

### 2. Contar distintos

```sql
-- Quantos salários distintos?
SELECT COUNT(DISTINCT Salario) FROM FUNCIONARIO;

-- Equivalente com subquery
SELECT COUNT(*) FROM (SELECT DISTINCT Salario FROM FUNCIONARIO) AS S;
```

### 3. Contar supervisores (cuidado com NULL)

```sql
-- Quantos funcionários são supervisores?
SELECT COUNT(DISTINCT Cpf_supervisor) FROM FUNCIONARIO;
-- NÃO use COUNT(*) numa subquery DISTINCT de coluna com NULL —
-- vai contar o NULL como um "valor distinto" e dar resultado errado!
```

---

## GROUP BY

> **Forma grupos pelos valores das colunas listadas.** Cada grupo vira UMA linha do resultado.

### 4. Agregação por grupo

```sql
-- Quantidade e média salarial POR departamento
SELECT Dnr, COUNT(Cpf), AVG(Salario)
FROM FUNCIONARIO
GROUP BY Dnr;
```

### 5. Com alias e join

```sql
SELECT
    Dnr   AS Departamento,
    Dnome AS Nome_Depto,
    COUNT(Cpf) AS Qtd_Funcionarios,
    AVG(Salario) AS Salario_Medio
FROM FUNCIONARIO JOIN DEPARTAMENTO
    ON Dnr = Dnumero
GROUP BY Dnr, Dnome;
```

> **Regra de ouro do GROUP BY:** toda coluna no SELECT que NÃO está dentro de uma função agregada DEVE estar no GROUP BY. Senão erro de sintaxe (ou comportamento indefinido).

```sql
-- ❌ Erro: Pnome não está agregado nem agrupado
SELECT Dnr, Pnome, COUNT(*) FROM FUNCIONARIO GROUP BY Dnr;

-- ✅ Correto
SELECT Dnr, Pnome, COUNT(*) FROM FUNCIONARIO GROUP BY Dnr, Pnome;
```

---

## HAVING — Filtro de Grupos

> **HAVING filtra DEPOIS do GROUP BY**, com base em agregação. WHERE filtra ANTES.

### 6. Funcionários com 2+ dependentes

```sql
-- ✅ Correto: HAVING com COUNT
SELECT Cpf, Pnome, Unome, COUNT(Fcpf) AS Qtde_dep
FROM FUNCIONARIO JOIN DEPENDENTE
    ON Cpf = Fcpf
GROUP BY Cpf, Pnome, Unome
HAVING COUNT(Fcpf) >= 2;
```

### ⚠️ Cuidado ao escolher colunas do GROUP BY

```sql
-- ❌ Incorreto se houver dois funcionários com mesmo Pnome+Unome
-- (eles seriam agrupados juntos e dependentes somariam errado)
GROUP BY Pnome, Unome

-- ✅ Inclui sempre a PK para evitar agrupamento errado
GROUP BY Cpf, Pnome, Unome
```

### Alternativa sem HAVING (com subquery)

```sql
SELECT Pnome, Unome, Qtde_dep
FROM FUNCIONARIO JOIN
    (SELECT Fcpf, COUNT(*) AS Qtde_dep
     FROM DEPENDENTE
     GROUP BY Fcpf) AS R
    ON Cpf = Fcpf
WHERE Qtde_dep >= 2;
```

> As duas versões funcionam. **HAVING é mais idiomático**, subquery é mais explícita.

---

## WHERE vs HAVING — Pegadinha

| | WHERE | HAVING |
|---|-------|--------|
| Filtra | Tuplas individuais | Grupos |
| Quando roda | Antes do GROUP BY | Depois do GROUP BY |
| Pode usar agregação? | **NÃO** | **SIM** |
| Pode usar coluna comum? | SIM | Só se estiver no GROUP BY |

```sql
-- ❌ Erro: agregação no WHERE
SELECT Dnr, AVG(Salario)
FROM FUNCIONARIO
WHERE AVG(Salario) > 30000
GROUP BY Dnr;

-- ✅ Correto: agregação no HAVING
SELECT Dnr, AVG(Salario)
FROM FUNCIONARIO
GROUP BY Dnr
HAVING AVG(Salario) > 30000;

-- ✅ Também correto: WHERE filtra antes (só funcionários M)
SELECT Dnr, AVG(Salario)
FROM FUNCIONARIO
WHERE Sexo = 'M'
GROUP BY Dnr
HAVING AVG(Salario) > 30000;
```

---

## ORDER BY

> Ordena o resultado final. Roda **por último** (depois do SELECT).

### Forma básica

```sql
SELECT Pnome, Unome, Salario
FROM FUNCIONARIO
ORDER BY Salario;            -- ASC implícito
```

### ASC / DESC

```sql
ORDER BY Salario DESC;
ORDER BY Dnome ASC, Salario DESC;
```

### Por posição do SELECT (1, 2, 3...)

```sql
SELECT Dnome, Unome, Pnome
FROM ...
ORDER BY 1, 2, 3;           -- ordena por Dnome, Unome, Pnome
ORDER BY 1 DESC, 3 DESC;    -- mistura ASC/DESC
```

### Por alias

```sql
SELECT Salario * 1.1 AS NovoSalario
FROM FUNCIONARIO
ORDER BY NovoSalario DESC;   -- ✅ funciona (ORDER BY vê alias)
```

### Múltiplos níveis

```sql
SELECT D.Dnome, F.Unome, F.Pnome, P.Projnome
FROM DEPARTAMENTO AS D
    JOIN FUNCIONARIO AS F ON D.Dnumero = F.Dnr
    JOIN TRABALHA_EM AS T ON F.Cpf     = T.Fcpf
    JOIN PROJETO     AS P ON T.Pnr     = P.Projnumero
ORDER BY D.Dnome, F.Unome, F.Pnome;
```

> **Estabilidade:** quando duas tuplas têm mesmo valor no primeiro critério, o segundo desempata. E assim por diante.

---

## NULL em ORDER BY

Depende do SGBD:
- **PostgreSQL:** NULLs vão pro fim em ASC, início em DESC. Use `NULLS FIRST` / `NULLS LAST`.
- **MariaDB/MySQL:** NULLs primeiro em ASC, último em DESC.

```sql
-- PostgreSQL
ORDER BY Cpf_supervisor NULLS LAST;
```

---

## Subqueries com Agregação (comum em prova)

### Maior valor

```sql
-- Funcionários com maior salário
SELECT Pnome, Unome, Salario
FROM FUNCIONARIO
WHERE Salario = (SELECT MAX(Salario) FROM FUNCIONARIO);
```

### Filtro por MIN/MAX em escopo

```sql
-- Funcionários com salário >= mínimo + 13000
SELECT Salario
FROM FUNCIONARIO
WHERE Salario >= 13000 + (SELECT MIN(Salario) FROM FUNCIONARIO);
```

Para salários {10000, 20000, 30000, 25000}:
- MIN = 10000
- Filtro: `Salario >= 23000`
- Retorna: 30000, 25000
- **Soma = 55000**

### Aninhamento profundo (resolvido de dentro pra fora)

```sql
SELECT Salario FROM FUNCIONARIO WHERE Salario >
    (SELECT MIN(Salario) FROM FUNCIONARIO WHERE Salario <
        (SELECT MAX(Salario) FROM FUNCIONARIO WHERE Salario <
            (SELECT MAX(Salario) FROM FUNCIONARIO)
        )
    );
```

Para 6 salários distintos S1<S2<S3<S4<S5<S6:
1. Subquery mais interna: `MAX(Salario)` = S6
2. Próxima: `MAX(Salario) WHERE Salario < S6` = S5
3. Próxima: `MIN(Salario) WHERE Salario < S5` = S1
4. Externa: `WHERE Salario > S1` → retorna S2, S3, S4, S5, S6

Sentenças verdadeiras: S2 (02), S3 (04), S4 (08), S5 (16), S6 (32). **Soma = 62.**

> **Dica:** sempre resolva subqueries **de dentro pra fora**. Marca cada nível.

---

## Erros Comuns

| ❌ Erro | ✅ Correto |
|---------|-----------|
| `WHERE COUNT(*) > 5` | `HAVING COUNT(*) > 5` |
| Coluna do SELECT fora do GROUP BY (e fora de agregação) | Inclui no GROUP BY ou agrega |
| `COUNT(coluna_com_NULL)` esperando contar tudo | Use `COUNT(*)` |
| `COUNT(DISTINCT col)` quando quer linhas, não distintos | Use `COUNT(col)` |
| Agrupar por nome quando há homônimos | Inclui PK no GROUP BY |
| Esquecer NULLS LAST/FIRST quando importa | Especifica explícito |

---

## Checklist Agregação

- [ ] Sei os 5 agregadores e o que cada um faz com NULL
- [ ] Sei a diferença entre `COUNT(*)`, `COUNT(col)`, `COUNT(DISTINCT col)`
- [ ] Sei quando usar WHERE vs HAVING
- [ ] Sei a regra: tudo no SELECT (não agregado) → no GROUP BY
- [ ] Sei agrupar por mais de uma coluna
- [ ] Sei usar ORDER BY com ASC/DESC, posição numérica, e alias
- [ ] Sei resolver subquery com MIN/MAX aninhada
- [ ] Sei por que `Salario = NULL` no WHERE não funciona, mas `WHERE Salario IN (SELECT...)` precifica NULL
