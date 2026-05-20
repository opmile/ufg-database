# RESUMO ÚNICO — SQL (T18-T21) para Prova

> Tudo que precisa, em ordem de prioridade. Lê de cima pra baixo. Salta DDL se já sabe.

---

## 1. Anatomia do SELECT — saber de cor

```sql
SELECT     atributos / agregações
FROM       relações + JOINs
WHERE      filtro de tuplas         -- antes do grupo
GROUP BY   atributos de agrupamento
HAVING     filtro de grupos         -- agregação SÓ aqui (não no WHERE)
ORDER BY   atributos de ordenação
```

### Ordem **lógica** de execução (não é a que se escreve)

```
FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY
```

**Consequências importantes:**
- Alias do SELECT **NÃO** funciona no WHERE (WHERE roda antes).
- Alias do SELECT **funciona** no ORDER BY.
- Agregação (`COUNT`, `SUM`...) **só** no HAVING ou SELECT — nunca no WHERE.
- Coluna no SELECT que não está agregada **DEVE** estar no GROUP BY.

---

## 2. JOIN — domina isso, passa a prova ⭐⭐⭐

### Tipos

| Tipo | Retorna |
|------|---------|
| `INNER JOIN` (ou só `JOIN`) | Só tuplas que casam dos dois lados |
| `LEFT [OUTER] JOIN` | Tudo da esquerda + match da direita (NULL se não casa) |
| `RIGHT [OUTER] JOIN` | Tudo da direita + match da esquerda |
| `FULL [OUTER] JOIN` | Tudo dos dois lados |
| `NATURAL JOIN` | INNER automático pelas colunas com **mesmo nome** |
| `CROSS JOIN` | Produto cartesiano (todas combinações) |

### Sintaxe (decora essa)

```sql
SELECT F.Pnome, F.Unome, D.Dnome
FROM FUNCIONARIO AS F JOIN DEPARTAMENTO AS D
    ON F.Dnr = D.Dnumero
WHERE D.Dnome = 'Pesquisa';
```

### Auto-join (clássico — supervisor, hierarquia)

```sql
SELECT F.Pnome, F.Unome, S.Pnome AS Sup, S.Unome AS SupUnome
FROM FUNCIONARIO AS F JOIN FUNCIONARIO AS S
    ON F.Cpf_supervisor = S.Cpf;
```

**SEM aliases não compila.** Sempre usa `AS X JOIN ... AS Y`.

### JOIN com 3-4 tabelas — encadeia

```sql
SELECT Pnome, Unome, Dnome, Projnome
FROM FUNCIONARIO
    JOIN DEPARTAMENTO ON Dnr = Dnumero
    JOIN TRABALHA_EM  ON Cpf = Fcpf
    JOIN PROJETO      ON Pnr = Projnumero;
```

### LEFT JOIN + IS NULL = "quem NÃO tem X"

```sql
-- Funcionários SEM dependentes
SELECT F.Pnome, F.Unome
FROM FUNCIONARIO AS F
    LEFT JOIN DEPENDENTE AS D ON F.Cpf = D.Fcpf
WHERE D.Fcpf IS NULL;
```

### Desambiguação

Coluna com mesmo nome em 2 tabelas → qualifica: `F.Sexo`, `D.Sexo`.

---

## 3. NULL — regras críticas ⭐⭐⭐

> **Cai TODA prova.** Sabe a tabela-verdade na ponta da língua.

### Regras

```
x = NULL          → NULL  (NÃO TRUE!)
x <> NULL         → NULL
NULL = NULL       → NULL
5 + NULL          → NULL
5 < NULL          → NULL
```

### Use sempre `IS NULL` / `IS NOT NULL`

```sql
WHERE Cpf_supervisor IS NULL       -- ✅
WHERE Cpf_supervisor IS NOT NULL   -- ✅
WHERE Cpf_supervisor = NULL        -- ❌ retorna 0 linhas!
```

### Tabela-verdade 3-valorada

| `OR`  | T | F | NULL |    | `AND` | T | F | NULL |
|-------|---|---|------|----|-------|---|---|------|
| **T** | T | T | T    |    | **T** | T | F | NULL |
| **F** | T | F | NULL |    | **F** | F | F | F    |
| **N** | T | NULL | NULL |  | **N** | NULL | F | NULL |

`NOT NULL` → `NULL`

### Regra de ouro do WHERE

> **WHERE só seleciona tupla quando predicado = TRUE.**
> NULL e FALSE descartam.

### Pegadinha modelo — questão típica de prova

Relação R com 4 tuplas: `(12,15,5100)`, `(13,NULL,3500)`, `(14,NULL,NULL)`, `(15,12,NULL)`

```sql
(C1) WHERE (at2<12) OR (at3<3000)            → 0 tuplas
(C2) WHERE (at2>12) OR NOT (at2>12)          → 2 tuplas (as com at2 não-NULL)
(C3) WHERE (NOT at2<at2) AND (at3>at2)       → 1 tupla
```

Resolva linha a linha aplicando tabela-verdade.

### COALESCE — substitui NULL

```sql
SELECT Pnome, COALESCE(Cpf_supervisor, 'sem supervisor') AS Sup
FROM FUNCIONARIO;
```

---

## 4. GROUP BY + HAVING ⭐⭐⭐

### Regra de ouro

> Tudo no SELECT que **não está dentro de função agregada** TEM que estar no `GROUP BY`.

### Padrão clássico — "quem tem N+ X"

```sql
-- Funcionários com 2+ dependentes
SELECT F.Cpf, F.Pnome, F.Unome, COUNT(D.Fcpf) AS Qtde
FROM FUNCIONARIO AS F JOIN DEPENDENTE AS D
    ON F.Cpf = D.Fcpf
GROUP BY F.Cpf, F.Pnome, F.Unome    -- inclui PK pra evitar agrupar homônimos!
HAVING COUNT(D.Fcpf) >= 2;
```

### WHERE vs HAVING

| | WHERE | HAVING |
|---|-------|--------|
| Quando roda | Antes do GROUP BY | Depois |
| Filtra | Tuplas | Grupos |
| Pode usar agregação? | ❌ NÃO | ✅ SIM |

```sql
-- ✅ WHERE filtra antes, HAVING filtra grupos
SELECT Dnr, AVG(Salario)
FROM FUNCIONARIO
WHERE Sexo = 'M'           -- filtra tuplas
GROUP BY Dnr
HAVING AVG(Salario) > 30000;  -- filtra grupos
```

---

## 5. Funções Agregadas

| Função | Conta/Soma o quê | NULL |
|--------|------------------|------|
| `COUNT(*)` | Linhas (todas) | Inclui linhas com NULL |
| `COUNT(col)` | Linhas onde `col` não é NULL | Ignora NULL |
| `COUNT(DISTINCT col)` | Valores distintos não-NULL | Ignora NULL |
| `SUM(col)` | Soma | Ignora NULL |
| `AVG(col)` | Média | Ignora NULL no cálculo |
| `MIN(col)` / `MAX(col)` | Min/max | Ignora NULL |

⚠️ **`SUM` em tabela vazia → NULL**, não 0.
⚠️ **`COUNT(*)` em tabela vazia → 0.**

---

## 6. ORDER BY

```sql
ORDER BY Salario DESC                    -- decrescente
ORDER BY Dnome ASC, Salario DESC         -- multi-nível
ORDER BY 1, 2, 3                         -- por posição
ORDER BY NovoSalario DESC                -- por alias do SELECT (OK!)
```

ASC é default.

---

## 7. Subqueries — padrão com MIN/MAX

```sql
-- Quem ganha o maior salário
SELECT Pnome, Unome, Salario
FROM FUNCIONARIO
WHERE Salario = (SELECT MAX(Salario) FROM FUNCIONARIO);

-- Salário acima do mínimo + 13000
SELECT Salario FROM FUNCIONARIO
WHERE Salario >= 13000 + (SELECT MIN(Salario) FROM FUNCIONARIO);
```

**Aninhamento:** resolve de **dentro pra fora**, marca cada nível.

Exemplo: 6 salários distintos S1<S2<S3<S4<S5<S6:
```sql
SELECT Salario FROM FUNCIONARIO WHERE Salario >
  (SELECT MIN(Salario) FROM FUNCIONARIO WHERE Salario <
    (SELECT MAX(Salario) FROM FUNCIONARIO WHERE Salario <
      (SELECT MAX(Salario) FROM FUNCIONARIO) ) );
```
1. Mais interna: `MAX = S6`
2. `MAX WHERE < S6 = S5`
3. `MIN WHERE < S5 = S1`
4. Externa: `> S1` → retorna S2, S3, S4, S5, S6

---

## 8. WHERE — operadores

| Operador | Uso |
|----------|-----|
| `=  <>  <  >  <=  >=` | Comparação |
| `BETWEEN x AND y` | Faixa **inclusiva** dos dois lados |
| `IN (v1, v2)` / `NOT IN (...)` | Pertence à lista |
| `LIKE 'padrão'` / `NOT LIKE` | Casamento string |
| `IS NULL` / `IS NOT NULL` | Teste de nulidade |
| `AND  OR  NOT` | Lógicos |

### LIKE

| Curinga | Casa |
|---------|------|
| `%` | Zero ou mais quaisquer |
| `_` | Exatamente 1 caractere |

```sql
WHERE Nome LIKE 'A%'       -- começa com A
WHERE Nome LIKE '%a'       -- termina com a
WHERE Nome LIKE '%SILVA%'  -- contém SILVA
WHERE Nome LIKE '_a%'      -- segunda letra é a
```

### DISTINCT — elimina duplicatas

```sql
SELECT DISTINCT Salario FROM FUNCIONARIO;
```

---

## 9. Funções String/Data (MariaDB — o que cai)

```sql
CONCAT(Pnome, ' ', Unome)               -- concatena
CHAR_LENGTH(Pnome)                      -- tamanho string
UPPER(s) / LOWER(s)                     -- caixa
YEAR(Datanasc)  MONTH(d)  DAY(d)        -- partes de data
NOW()                                   -- agora
```

Em SQLite (hands-on): `||` em vez de CONCAT, `LENGTH`, `strftime('%Y', d)`.

---

## 10. DDL — minimum viable

```sql
-- Criar tabela com tudo
CREATE TABLE FUNCIONARIO (
    Cpf            CHAR(11)      NOT NULL,
    Pnome          VARCHAR(20)   NOT NULL,
    Salario        NUMERIC(10,2),
    Sexo           CHAR(1),
    Dnr            INT           NOT NULL,
    Cpf_supervisor CHAR(11),
    PRIMARY KEY (Cpf),
    FOREIGN KEY (Dnr) REFERENCES DEPARTAMENTO(Dnumero),
    FOREIGN KEY (Cpf_supervisor) REFERENCES FUNCIONARIO(Cpf),
    CHECK (Sexo IN ('M', 'F'))
);

-- Alterar
ALTER TABLE FUNCIONARIO ADD Email VARCHAR(255);
ALTER TABLE FUNCIONARIO DROP COLUMN Email;
ALTER TABLE FUNCIONARIO ADD CONSTRAINT FK_X FOREIGN KEY (Dnr) REFERENCES DEPARTAMENTO(Dnumero);
ALTER TABLE FUNCIONARIO DROP CONSTRAINT FK_X;

-- Restrições mapeadas
-- Domínio       → tipo + NOT NULL + CHECK
-- Chave         → PRIMARY KEY + UNIQUE
-- Entidade      → PRIMARY KEY (implica NOT NULL)
-- Referencial   → FOREIGN KEY ... REFERENCES
```

DML adicional (não muito cobrado mas pode):
```sql
INSERT INTO T (c1, c2) VALUES (v1, v2);
UPDATE T SET col = valor WHERE cond;
DELETE FROM T WHERE cond;
```

---

## 11. Pegadinhas — V/F com gabarito

| # | Afirmação | V/F |
|---|-----------|-----|
| 1 | `WHERE x = NULL` retorna tuplas com x NULL | **F** (retorna 0 linhas) |
| 2 | `COUNT(*)` ignora linhas com algum NULL | **F** (conta tudo) |
| 3 | `SUM(col)` em tabela vazia retorna 0 | **F** (retorna NULL!) |
| 4 | SQL admite tuplas duplicadas no resultado | **V** |
| 5 | HAVING é avaliado antes do GROUP BY | **F** (depois) |
| 6 | INNER JOIN é simétrico (ordem não muda) | **V** |
| 7 | LEFT JOIN é simétrico | **F** (LEFT ≠ RIGHT) |
| 8 | `BETWEEN 10 AND 20` inclui 10 e 20 | **V** |
| 9 | `NULL OR TRUE` retorna NULL | **F** (retorna TRUE) |
| 10 | Pode usar alias do SELECT no WHERE | **F** |
| 11 | Pode usar alias do SELECT no ORDER BY | **V** |
| 12 | `COUNT(DISTINCT col)` conta NULL como distinto | **F** |
| 13 | FK pode ser NULL | **V** |
| 14 | PK pode ser NULL | **F** |
| 15 | `0 OR NULL` → 0 | **N/A** (`F OR NULL = NULL`) |

---

## 12. Padrões de Questão

| Pergunta tipo | Receita |
|---------------|---------|
| "Quais funcionários X..." | SELECT + WHERE simples |
| "Para cada Y, ..." | GROUP BY Y (com agregação geralmente) |
| "Que tem pelo menos N de X" | JOIN + GROUP BY + HAVING COUNT(...) >= N |
| "Que NÃO tem X" | LEFT JOIN tabela_X + WHERE X.fk IS NULL |
| "Maior/menor X" | WHERE col = (SELECT MAX/MIN(col) FROM ...) |
| "Cada X com Y do supervisor" | Auto-join FUNCIONARIO×FUNCIONARIO |
| "Avalia predicado com NULL" | Aplica tabela-verdade linha-a-linha; só TRUE seleciona |
| "X de cada depto + nome do depto" | JOIN FUNCIONARIO×DEPARTAMENTO + GROUP BY |

---

## 13. Exercício resolvido — modelo prova

> "Para cada departamento, lista nome, qtd de funcionários e média salarial — só departamentos com 2+ funcionários, ordenado por média desc."

```sql
SELECT D.Dnome,
       COUNT(F.Cpf)   AS Qtd_Func,
       AVG(F.Salario) AS Media_Sal
FROM DEPARTAMENTO AS D JOIN FUNCIONARIO AS F
    ON D.Dnumero = F.Dnr
GROUP BY D.Dnumero, D.Dnome
HAVING COUNT(F.Cpf) >= 2
ORDER BY Media_Sal DESC;
```

✅ JOIN com ON
✅ Alias de tabela
✅ GROUP BY com PK (Dnumero) + Dnome
✅ HAVING (não WHERE — usa agregação!)
✅ ORDER BY com alias do SELECT
✅ DESC explícito

---

## 14. Hands-On Mínimo (PostgreSQL + pgAdmin)

> Pula se já fez no `handbook/06-handson.md`. Senão usa esse setup compacto.

### Fluxo

1. pgAdmin → conecta servidor local.
2. Databases → Create → Database → `bd_empresa`.
3. Tools → Query Tool. Cola tudo abaixo. ▶ (F5).

```sql
DROP TABLE IF EXISTS DEPENDENTE      CASCADE;
DROP TABLE IF EXISTS TRABALHA_EM     CASCADE;
DROP TABLE IF EXISTS PROJETO         CASCADE;
DROP TABLE IF EXISTS LOCALIZACAO_DEP CASCADE;
DROP TABLE IF EXISTS FUNCIONARIO     CASCADE;
DROP TABLE IF EXISTS DEPARTAMENTO    CASCADE;

CREATE TABLE DEPARTAMENTO (
    Dnumero INTEGER PRIMARY KEY,
    Dnome VARCHAR(20) NOT NULL UNIQUE,
    Cpf_gerente CHAR(11),
    Data_inicio_gerente DATE
);
CREATE TABLE FUNCIONARIO (
    Cpf CHAR(11) PRIMARY KEY,
    Pnome VARCHAR(20) NOT NULL,
    Minicial CHAR(1),
    Unome VARCHAR(20) NOT NULL,
    Datanasc DATE,
    Endereco VARCHAR(60),
    Sexo CHAR(1) CHECK (Sexo IN ('M','F')),
    Salario NUMERIC(10,2),
    Cpf_supervisor CHAR(11) REFERENCES FUNCIONARIO(Cpf),
    Dnr INTEGER NOT NULL REFERENCES DEPARTAMENTO(Dnumero)
);
ALTER TABLE DEPARTAMENTO
    ADD CONSTRAINT FK_DEPTO_GERENTE
    FOREIGN KEY (Cpf_gerente) REFERENCES FUNCIONARIO(Cpf);

CREATE TABLE LOCALIZACAO_DEP (
    Dnumero INTEGER REFERENCES DEPARTAMENTO(Dnumero),
    Dlocal VARCHAR(20),
    PRIMARY KEY (Dnumero, Dlocal)
);
CREATE TABLE PROJETO (
    Projnumero INTEGER PRIMARY KEY,
    Projnome VARCHAR(20) NOT NULL UNIQUE,
    Projlocal VARCHAR(20),
    Dnum INTEGER NOT NULL REFERENCES DEPARTAMENTO(Dnumero)
);
CREATE TABLE TRABALHA_EM (
    Fcpf CHAR(11) REFERENCES FUNCIONARIO(Cpf),
    Pnr INTEGER REFERENCES PROJETO(Projnumero),
    Horas NUMERIC(4,1),
    PRIMARY KEY (Fcpf, Pnr)
);
CREATE TABLE DEPENDENTE (
    Fcpf CHAR(11) REFERENCES FUNCIONARIO(Cpf),
    Nome_dependente VARCHAR(20),
    Sexo CHAR(1),
    Datanasc DATE,
    Parentesco VARCHAR(15),
    PRIMARY KEY (Fcpf, Nome_dependente)
);

INSERT INTO DEPARTAMENTO (Dnumero, Dnome) VALUES (1,'Matriz'),(4,'Administracao'),(5,'Pesquisa');
INSERT INTO FUNCIONARIO VALUES
('88866555576','Jorge','E','Brito','1937-11-10','Rua do Horto 80','M',55000,NULL,1),
('33344555587','Fernando','T','Wong','1955-12-08','Rua da Lua 34','M',40000,'88866555576',5),
('98765432168','Jennifer','S','Souza','1941-06-20','Av Arthur de Lima 54','F',43000,'88866555576',4),
('12345678966','Joao','B','Silva','1965-01-09','Rua dos Tucanos 1','M',30000,'33344555587',5),
('66688444476','Ronaldo','K','Lima','1962-09-15','Rua Reboucas 65','M',38000,'33344555587',5),
('45345345376','Joice','A','Leite','1972-07-31','Av Lucas Obes 74','F',25000,'33344555587',5),
('99988777767','Alice','J','Zelaya','1968-01-19','Rua Souza Lima 35','F',25000,'98765432168',4),
('98798798733','Andre','V','Pereira','1969-03-29','Rua Timbira 35','M',25000,'98765432168',4);

UPDATE DEPARTAMENTO SET Cpf_gerente='88866555576' WHERE Dnumero=1;
UPDATE DEPARTAMENTO SET Cpf_gerente='98765432168' WHERE Dnumero=4;
UPDATE DEPARTAMENTO SET Cpf_gerente='33344555587' WHERE Dnumero=5;

INSERT INTO LOCALIZACAO_DEP VALUES (1,'Sao Paulo'),(4,'Maua'),(5,'Santo Andre'),(5,'Itu'),(5,'Sao Paulo');
INSERT INTO PROJETO VALUES (1,'ProdutoX','Santo Andre',5),(2,'ProdutoY','Itu',5),(3,'ProdutoZ','Sao Paulo',5),
(10,'Informatizacao','Maua',4),(20,'Reorganizacao','Sao Paulo',1),(30,'NovosBeneficios','Maua',4);
INSERT INTO TRABALHA_EM VALUES
('12345678966',1,32.5),('12345678966',2,7.5),('66688444476',3,40),('45345345376',1,20),
('45345345376',2,20),('33344555587',2,10),('33344555587',3,10),('33344555587',10,10),
('33344555587',20,10),('99988777767',30,30),('99988777767',10,10),('98798798733',10,35),
('98798798733',30,5),('98765432168',30,20),('98765432168',20,15),('88866555576',20,NULL);
INSERT INTO DEPENDENTE VALUES
('33344555587','Alicia','F','1986-04-05','Filha'),('33344555587','Tiago','M','1983-10-25','Filho'),
('33344555587','Janaina','F','1958-05-03','Esposa'),('98765432168','Antonio','M','1942-02-28','Marido'),
('12345678966','Michael','M','1988-01-04','Filho'),('12345678966','Alice','F','1988-12-30','Filha'),
('12345678966','Elizabeth','F','1967-05-05','Esposa');
```

### Top 10 queries pra fixar (executa cada uma e confere)

```sql
-- 1. JOIN simples
SELECT F.Pnome, F.Unome, D.Dnome FROM FUNCIONARIO F JOIN DEPARTAMENTO D ON F.Dnr=D.Dnumero;

-- 2. Auto-join supervisor
SELECT F.Pnome, S.Pnome AS Sup FROM FUNCIONARIO F JOIN FUNCIONARIO S ON F.Cpf_supervisor=S.Cpf;

-- 3. JOIN 4 tabelas
SELECT F.Pnome, D.Dnome, P.Projnome, T.Horas
FROM FUNCIONARIO F JOIN DEPARTAMENTO D ON F.Dnr=D.Dnumero
  JOIN TRABALHA_EM T ON F.Cpf=T.Fcpf JOIN PROJETO P ON T.Pnr=P.Projnumero;

-- 4. IS NULL
SELECT Pnome FROM FUNCIONARIO WHERE Cpf_supervisor IS NULL;

-- 5. LEFT JOIN + IS NULL (sem dependentes)
SELECT F.Pnome FROM FUNCIONARIO F
  LEFT JOIN DEPENDENTE D ON F.Cpf=D.Fcpf WHERE D.Fcpf IS NULL;

-- 6. COUNT/AVG por grupo
SELECT D.Dnome, COUNT(F.Cpf), AVG(F.Salario)
FROM DEPARTAMENTO D JOIN FUNCIONARIO F ON D.Dnumero=F.Dnr
GROUP BY D.Dnumero, D.Dnome;

-- 7. HAVING (2+ dependentes)
SELECT F.Pnome, COUNT(D.Fcpf) FROM FUNCIONARIO F JOIN DEPENDENTE D ON F.Cpf=D.Fcpf
GROUP BY F.Cpf, F.Pnome HAVING COUNT(D.Fcpf) >= 2;

-- 8. Subquery MAX
SELECT Pnome, Salario FROM FUNCIONARIO
WHERE Salario = (SELECT MAX(Salario) FROM FUNCIONARIO);

-- 9. WHERE + GROUP + HAVING + ORDER (queijo)
SELECT D.Dnome, COUNT(*) AS Qtd, AVG(F.Salario) AS M
FROM FUNCIONARIO F JOIN DEPARTAMENTO D ON F.Dnr=D.Dnumero
WHERE F.Sexo='M' GROUP BY D.Dnumero, D.Dnome
HAVING AVG(F.Salario) > 30000 ORDER BY M DESC;

-- 10. LIKE
SELECT Pnome FROM FUNCIONARIO WHERE Pnome LIKE '%a';
```

---

## 15. Prioridade Final (se o tempo zerar)

**Memoriza nessa ordem:**
1. **NULL** (seção 3) — questão garantida
2. **JOIN sintaxe + auto-join** (seção 2) — base de tudo
3. **GROUP BY + HAVING** (seção 4) — questão garantida
4. **Padrões de questão** (seção 12) — receitas prontas
5. **Pegadinhas V/F** (seção 11) — pontos fáceis
6. **Subquery MIN/MAX** (seção 7) — comum
7. **LEFT JOIN + IS NULL** (seção 2, último bloco) — padrão "não tem"
8. **DDL** (seção 10) — menor prioridade, sintaxe básica basta

Boa sorte. 💪
