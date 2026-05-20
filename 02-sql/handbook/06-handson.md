# Hands-On — BD Empresa do Zero

> **Objetivo:** rodar tudo de SQL no SGBD, **vendo o resultado de cada query**, do mais básico ao mais cobrado. Use [SQLite Online](https://sqliteonline.com/) → **PostgreSQL** (recomendado) ou **MariaDB**.

## Como usar este arquivo

1. Abre [sqliteonline.com](https://sqliteonline.com/), clica em **PostgreSQL** (esquerda), depois **click to connect**.
2. Cola o bloco **Setup** uma vez. Run.
3. Cola cada bloco de query individualmente. Lê a pergunta antes, **tenta prever o resultado**, então roda.
4. Se algo quebrar — releia a query, identifica o erro. Não passa pro próximo sem entender.

> **Se quiser zerar e refazer:** roda o bloco Setup de novo (tem `DROP TABLE IF EXISTS` no início).

---

## 1. SETUP — Cria + Popula BD Empresa

Cola tudo isso de uma vez:

```sql
-- ============================================================
-- LIMPEZA (drop em ordem reversa pra não violar FK)
-- ============================================================
DROP TABLE IF EXISTS DEPENDENTE      CASCADE;
DROP TABLE IF EXISTS TRABALHA_EM     CASCADE;
DROP TABLE IF EXISTS PROJETO         CASCADE;
DROP TABLE IF EXISTS LOCALIZACAO_DEP CASCADE;
DROP TABLE IF EXISTS FUNCIONARIO     CASCADE;
DROP TABLE IF EXISTS DEPARTAMENTO    CASCADE;

-- ============================================================
-- DDL — Criação das tabelas
-- ============================================================

-- Cria DEPARTAMENTO sem FK pro gerente (FK circular — resolve depois)
CREATE TABLE DEPARTAMENTO (
    Dnumero              INT          NOT NULL,
    Dnome                VARCHAR(20)  NOT NULL,
    Cpf_gerente          CHAR(11),
    Data_inicio_gerente  DATE,
    PRIMARY KEY (Dnumero),
    UNIQUE (Dnome)
);

CREATE TABLE FUNCIONARIO (
    Pnome           VARCHAR(20)   NOT NULL,
    Minicial        CHAR(1),
    Unome           VARCHAR(20)   NOT NULL,
    Cpf             CHAR(11)      NOT NULL,
    Datanasc        DATE,
    Endereco        VARCHAR(60),
    Sexo            CHAR(1),
    Salario         NUMERIC(10,2),
    Cpf_supervisor  CHAR(11),
    Dnr             INT           NOT NULL,
    PRIMARY KEY (Cpf),
    FOREIGN KEY (Cpf_supervisor) REFERENCES FUNCIONARIO(Cpf),
    FOREIGN KEY (Dnr)            REFERENCES DEPARTAMENTO(Dnumero),
    CHECK (Sexo IN ('M', 'F'))
);

-- Agora resolve FK circular: gerente do departamento
ALTER TABLE DEPARTAMENTO
    ADD CONSTRAINT FK_DEPTO_GERENTE
        FOREIGN KEY (Cpf_gerente) REFERENCES FUNCIONARIO(Cpf);

CREATE TABLE LOCALIZACAO_DEP (
    Dnumero  INT          NOT NULL,
    Dlocal   VARCHAR(20)  NOT NULL,
    PRIMARY KEY (Dnumero, Dlocal),
    FOREIGN KEY (Dnumero) REFERENCES DEPARTAMENTO(Dnumero)
);

CREATE TABLE PROJETO (
    Projnumero  INT          NOT NULL,
    Projnome    VARCHAR(20)  NOT NULL,
    Projlocal   VARCHAR(20),
    Dnum        INT          NOT NULL,
    PRIMARY KEY (Projnumero),
    UNIQUE (Projnome),
    FOREIGN KEY (Dnum) REFERENCES DEPARTAMENTO(Dnumero)
);

CREATE TABLE TRABALHA_EM (
    Fcpf   CHAR(11)      NOT NULL,
    Pnr    INT           NOT NULL,
    Horas  NUMERIC(4,1),
    PRIMARY KEY (Fcpf, Pnr),
    FOREIGN KEY (Fcpf) REFERENCES FUNCIONARIO(Cpf),
    FOREIGN KEY (Pnr)  REFERENCES PROJETO(Projnumero)
);

CREATE TABLE DEPENDENTE (
    Fcpf              CHAR(11)     NOT NULL,
    Nome_dependente   VARCHAR(20)  NOT NULL,
    Sexo              CHAR(1),
    Datanasc          DATE,
    Parentesco        VARCHAR(15),
    PRIMARY KEY (Fcpf, Nome_dependente),
    FOREIGN KEY (Fcpf) REFERENCES FUNCIONARIO(Cpf)
);

-- ============================================================
-- DML — Carga inicial
-- ============================================================

-- Departamentos (sem gerente ainda — vamos atualizar depois)
INSERT INTO DEPARTAMENTO (Dnumero, Dnome) VALUES
    (1, 'Matriz'),
    (4, 'Administracao'),
    (5, 'Pesquisa');

-- Funcionários (ordem importa: supervisores antes dos subordinados)
INSERT INTO FUNCIONARIO VALUES
    ('Jorge',     'E', 'Brito',   '88866555576', '1937-11-10', 'Rua do Horto 80',         'M', 55000.00, NULL,          1),
    ('Fernando',  'T', 'Wong',    '33344555587', '1955-12-08', 'Rua da Lua 34',           'M', 40000.00, '88866555576', 5),
    ('Jennifer',  'S', 'Souza',   '98765432168', '1941-06-20', 'Av Arthur de Lima 54',    'F', 43000.00, '88866555576', 4),
    ('Joao',      'B', 'Silva',   '12345678966', '1965-01-09', 'Rua dos Tucanos 1',       'M', 30000.00, '33344555587', 5),
    ('Ronaldo',   'K', 'Lima',    '66688444476', '1962-09-15', 'Rua Reboucas 65',         'M', 38000.00, '33344555587', 5),
    ('Joice',     'A', 'Leite',   '45345345376', '1972-07-31', 'Av Lucas Obes 74',        'F', 25000.00, '33344555587', 5),
    ('Alice',     'J', 'Zelaya',  '99988777767', '1968-01-19', 'Rua Souza Lima 35',       'F', 25000.00, '98765432168', 4),
    ('Andre',     'V', 'Pereira', '98798798733', '1969-03-29', 'Rua Timbira 35',          'M', 25000.00, '98765432168', 4);

-- Agora atualiza gerentes (depende de FUNCIONARIO existir)
UPDATE DEPARTAMENTO SET Cpf_gerente = '88866555576', Data_inicio_gerente = '1981-06-19' WHERE Dnumero = 1;
UPDATE DEPARTAMENTO SET Cpf_gerente = '98765432168', Data_inicio_gerente = '1995-01-01' WHERE Dnumero = 4;
UPDATE DEPARTAMENTO SET Cpf_gerente = '33344555587', Data_inicio_gerente = '1988-05-22' WHERE Dnumero = 5;

-- Locais dos departamentos
INSERT INTO LOCALIZACAO_DEP VALUES
    (1, 'Sao Paulo'),
    (4, 'Maua'),
    (5, 'Santo Andre'),
    (5, 'Itu'),
    (5, 'Sao Paulo');

-- Projetos
INSERT INTO PROJETO VALUES
    (1,  'ProdutoX',         'Santo Andre', 5),
    (2,  'ProdutoY',         'Itu',         5),
    (3,  'ProdutoZ',         'Sao Paulo',   5),
    (10, 'Informatizacao',   'Maua',        4),
    (20, 'Reorganizacao',    'Sao Paulo',   1),
    (30, 'NovosBeneficios',  'Maua',        4);

-- Alocações (TRABALHA_EM)
INSERT INTO TRABALHA_EM VALUES
    ('12345678966', 1,  32.5),
    ('12345678966', 2,  7.5),
    ('66688444476', 3,  40.0),
    ('45345345376', 1,  20.0),
    ('45345345376', 2,  20.0),
    ('33344555587', 2,  10.0),
    ('33344555587', 3,  10.0),
    ('33344555587', 10, 10.0),
    ('33344555587', 20, 10.0),
    ('99988777767', 30, 30.0),
    ('99988777767', 10, 10.0),
    ('98798798733', 10, 35.0),
    ('98798798733', 30, 5.0),
    ('98765432168', 30, 20.0),
    ('98765432168', 20, 15.0),
    ('88866555576', 20, NULL);   -- horas NULL: presidente sem registro

-- Dependentes
INSERT INTO DEPENDENTE VALUES
    ('33344555587', 'Alicia',    'F', '1986-04-05', 'Filha'),
    ('33344555587', 'Tiago',     'M', '1983-10-25', 'Filho'),
    ('33344555587', 'Janaina',   'F', '1958-05-03', 'Esposa'),
    ('98765432168', 'Antonio',   'M', '1942-02-28', 'Marido'),
    ('12345678966', 'Michael',   'M', '1988-01-04', 'Filho'),
    ('12345678966', 'Alice',     'F', '1988-12-30', 'Filha'),
    ('12345678966', 'Elizabeth', 'F', '1967-05-05', 'Esposa');
```

### Confere se carregou

```sql
SELECT 'FUNCIONARIO' AS tabela, COUNT(*) AS qtd FROM FUNCIONARIO
UNION ALL SELECT 'DEPARTAMENTO',     COUNT(*) FROM DEPARTAMENTO
UNION ALL SELECT 'LOCALIZACAO_DEP',  COUNT(*) FROM LOCALIZACAO_DEP
UNION ALL SELECT 'PROJETO',          COUNT(*) FROM PROJETO
UNION ALL SELECT 'TRABALHA_EM',      COUNT(*) FROM TRABALHA_EM
UNION ALL SELECT 'DEPENDENTE',       COUNT(*) FROM DEPENDENTE;
```

**Esperado:** FUNCIONARIO 8, DEPARTAMENTO 3, LOCALIZACAO_DEP 5, PROJETO 6, TRABALHA_EM 16, DEPENDENTE 7.

---

## 2. SELECT BÁSICO

### Q01 — Tudo de FUNCIONARIO

```sql
SELECT * FROM FUNCIONARIO;
```

### Q02 — Projeção de colunas

> Quais o CPF e nome completo dos funcionários?

```sql
SELECT Cpf, Pnome, Unome FROM FUNCIONARIO;
```

### Q03 — Filtro WHERE simples

> CPF e nome dos funcionários do sexo feminino.

```sql
SELECT Cpf, Pnome, Unome
FROM FUNCIONARIO
WHERE Sexo = 'F';
```

**Esperado:** 3 linhas (Jennifer, Joice, Alice).

### Q04 — Múltiplas condições com AND

> Funcionários masculinos com salário acima de 30000.

```sql
SELECT Pnome, Unome, Salario
FROM FUNCIONARIO
WHERE Sexo = 'M' AND Salario > 30000;
```

### Q05 — BETWEEN

> Funcionários com salário entre 25000 e 35000 (inclusive).

```sql
SELECT Pnome, Unome, Salario
FROM FUNCIONARIO
WHERE Salario BETWEEN 25000 AND 35000;
```

### Q06 — IN

> Funcionários do departamento 4 ou 5.

```sql
SELECT Pnome, Unome, Dnr
FROM FUNCIONARIO
WHERE Dnr IN (4, 5);
```

### Q07 — LIKE — termina com 'a'

> Funcionários cujo primeiro nome termina em 'a'.

```sql
SELECT Pnome, Unome
FROM FUNCIONARIO
WHERE Pnome LIKE '%a';
```

**Pegadinha:** LIKE é case-sensitive. `'A'` no fim não casa com `'a'` no padrão.

### Q08 — LIKE — segunda letra é 'o'

```sql
SELECT Pnome, Unome
FROM FUNCIONARIO
WHERE Pnome LIKE '_o%';
```

### Q09 — Expressão na projeção

> Lista nome + salário + salário com 10% de aumento.

```sql
SELECT Pnome, Unome, Salario, Salario * 1.1 AS NovoSalario
FROM FUNCIONARIO;
```

### Q10 — DISTINCT

> Quantos salários distintos existem?

```sql
SELECT DISTINCT Salario FROM FUNCIONARIO ORDER BY Salario;
```

**Esperado:** 6 valores (25000, 30000, 38000, 40000, 43000, 55000).

---

## 3. JOINS

### Q11 — JOIN simples (2 tabelas)

> Nome do funcionário + nome do departamento.

```sql
SELECT F.Pnome, F.Unome, D.Dnome
FROM FUNCIONARIO AS F JOIN DEPARTAMENTO AS D
    ON F.Dnr = D.Dnumero;
```

### Q12 — JOIN com filtro

> Funcionários do departamento 'Pesquisa'.

```sql
SELECT F.Pnome, F.Unome, F.Salario
FROM FUNCIONARIO AS F JOIN DEPARTAMENTO AS D
    ON F.Dnr = D.Dnumero
WHERE D.Dnome = 'Pesquisa';
```

**Esperado:** 4 funcionários (Fernando, João, Ronaldo, Joice).

### Q13 — AUTO-JOIN (clássico de prova)

> Cada funcionário com nome do seu supervisor direto.

```sql
SELECT F.Pnome AS Func_Pnome, F.Unome AS Func_Unome,
       S.Pnome AS Sup_Pnome,  S.Unome AS Sup_Unome
FROM FUNCIONARIO AS F JOIN FUNCIONARIO AS S
    ON F.Cpf_supervisor = S.Cpf;
```

**Esperado:** 7 linhas (todos exceto Jorge, que é o presidente sem supervisor).

### Q14 — JOIN com 3 tabelas

> Para cada projeto, nome do projeto + nome do depto que controla.

```sql
SELECT P.Projnome, D.Dnome
FROM PROJETO AS P JOIN DEPARTAMENTO AS D
    ON P.Dnum = D.Dnumero;
```

### Q15 — JOIN com 4 tabelas

> Funcionário + departamento + projeto em que trabalha + horas.

```sql
SELECT F.Pnome, F.Unome, D.Dnome, P.Projnome, T.Horas
FROM FUNCIONARIO AS F
    JOIN DEPARTAMENTO AS D ON F.Dnr = D.Dnumero
    JOIN TRABALHA_EM  AS T ON F.Cpf = T.Fcpf
    JOIN PROJETO      AS P ON T.Pnr = P.Projnumero;
```

### Q16 — JOIN + filtro complexo

> Para projetos em 'Sao Paulo', mostra nome do projeto, depto que controla, e nome do gerente.

```sql
SELECT P.Projnome, D.Dnome, G.Pnome, G.Unome
FROM PROJETO     AS P
    JOIN DEPARTAMENTO AS D ON P.Dnum = D.Dnumero
    JOIN FUNCIONARIO  AS G ON D.Cpf_gerente = G.Cpf
WHERE P.Projlocal = 'Sao Paulo';
```

### Q17 — Desambiguação (Sexo aparece em F e D)

> Para cada dependente, mostra nome+sexo do dependente + nome+sexo do responsável.

```sql
SELECT F.Pnome, F.Sexo AS Sexo_func,
       D.Nome_dependente, D.Sexo AS Sexo_dep
FROM FUNCIONARIO AS F JOIN DEPENDENTE AS D
    ON F.Cpf = D.Fcpf;
```

---

## 4. NULL — Comportamento

### Q18 — IS NULL

> Funcionários SEM supervisor direto.

```sql
SELECT Pnome, Unome
FROM FUNCIONARIO
WHERE Cpf_supervisor IS NULL;
```

**Esperado:** 1 linha (Jorge — presidente).

### Q19 — IS NOT NULL

> Funcionários COM supervisor direto.

```sql
SELECT Pnome, Unome
FROM FUNCIONARIO
WHERE Cpf_supervisor IS NOT NULL;
```

**Esperado:** 7 linhas.

### Q20 — Demonstração: `= NULL` NÃO funciona

```sql
-- Quantas tuplas retorna?
SELECT * FROM FUNCIONARIO WHERE Cpf_supervisor = NULL;
```

**Esperado:** **0 linhas.** Porque `x = NULL` sempre avalia para NULL (não TRUE), e WHERE só seleciona TRUE.

### Q21 — Aritmética com NULL

```sql
-- Horas registradas + 10. NULL + 10 = NULL.
SELECT Fcpf, Pnr, Horas, Horas + 10 AS HorasMais10
FROM TRABALHA_EM
WHERE Horas IS NULL OR Horas > 30;
```

### Q22 — COALESCE pra tratar NULL

> Lista funcionários — mostrar "sem supervisor" quando Cpf_supervisor for NULL.

```sql
SELECT Pnome, Unome,
       COALESCE(Cpf_supervisor, 'sem supervisor') AS Supervisor
FROM FUNCIONARIO;
```

---

## 5. OUTER JOIN

### Q23 — LEFT JOIN: todos os funcionários, mesmo sem supervisor

```sql
SELECT F.Pnome AS Func, F.Unome,
       S.Pnome AS Sup_Pnome, S.Unome AS Sup_Unome
FROM FUNCIONARIO AS F
    LEFT OUTER JOIN FUNCIONARIO AS S ON F.Cpf_supervisor = S.Cpf;
```

**Esperado:** 8 linhas. Jorge aparece com Sup_Pnome e Sup_Unome em NULL.

### Q24 — LEFT JOIN: todos funcionários + dependentes (mesmo sem dependentes)

```sql
SELECT F.Pnome, F.Unome, D.Nome_dependente
FROM FUNCIONARIO AS F
    LEFT OUTER JOIN DEPENDENTE AS D ON F.Cpf = D.Fcpf;
```

**Esperado:** funcionários sem dependente aparecem com `Nome_dependente` em NULL.

### Q25 — Combinação LEFT JOIN + IS NULL pra "negar"

> Funcionários que NÃO TÊM dependentes.

```sql
SELECT F.Pnome, F.Unome
FROM FUNCIONARIO AS F
    LEFT OUTER JOIN DEPENDENTE AS D ON F.Cpf = D.Fcpf
WHERE D.Fcpf IS NULL;
```

**Padrão clássico** pra "quem não tem X" → LEFT JOIN com tabela de X + filtro `WHERE X.PK IS NULL`.

---

## 6. AGREGAÇÃO

### Q26 — Agregadores sem grupo

> Total de funcionários, soma e média salarial.

```sql
SELECT COUNT(*) AS Qtd, SUM(Salario) AS Total, AVG(Salario) AS Media
FROM FUNCIONARIO;
```

### Q27 — COUNT(*) vs COUNT(coluna)

```sql
SELECT
    COUNT(*)              AS qtd_linhas,
    COUNT(Cpf_supervisor) AS qtd_com_supervisor,
    COUNT(DISTINCT Cpf_supervisor) AS qtd_supervisores_unicos
FROM FUNCIONARIO;
```

**Esperado:** 8, 7 (ignora o NULL), 3 (Jorge, Fernando, Jennifer).

### Q28 — GROUP BY por departamento

> Quantidade de funcionários e média salarial por departamento.

```sql
SELECT Dnr, COUNT(*) AS Qtd, AVG(Salario) AS Media_Sal
FROM FUNCIONARIO
GROUP BY Dnr;
```

### Q29 — GROUP BY + JOIN (mostra NOME do depto)

```sql
SELECT D.Dnumero, D.Dnome,
       COUNT(F.Cpf) AS Qtd_Func,
       AVG(F.Salario) AS Media_Sal
FROM DEPARTAMENTO AS D JOIN FUNCIONARIO AS F
    ON D.Dnumero = F.Dnr
GROUP BY D.Dnumero, D.Dnome;
```

### Q30 — HAVING — filtra grupos (clássico de prova!)

> Funcionários com 2 ou mais dependentes.

```sql
SELECT F.Cpf, F.Pnome, F.Unome, COUNT(D.Fcpf) AS Qtde_dep
FROM FUNCIONARIO AS F JOIN DEPENDENTE AS D
    ON F.Cpf = D.Fcpf
GROUP BY F.Cpf, F.Pnome, F.Unome
HAVING COUNT(D.Fcpf) >= 2;
```

**Esperado:** Fernando (3 dep) e João (3 dep).

### Q31 — WHERE + GROUP BY + HAVING (combinação completa)

> Para funcionários do sexo masculino, lista departamento, qtd e média salarial — só depto com média > 30000.

```sql
SELECT D.Dnome,
       COUNT(F.Cpf)   AS Qtd,
       AVG(F.Salario) AS Media
FROM FUNCIONARIO AS F JOIN DEPARTAMENTO AS D
    ON F.Dnr = D.Dnumero
WHERE F.Sexo = 'M'
GROUP BY D.Dnumero, D.Dnome
HAVING AVG(F.Salario) > 30000;
```

### Q32 — Subquery com MIN

> Funcionários com salário acima do mínimo + 13000.

```sql
SELECT Pnome, Unome, Salario
FROM FUNCIONARIO
WHERE Salario >= 13000 + (SELECT MIN(Salario) FROM FUNCIONARIO);
```

### Q33 — Subquery com MAX

> Funcionário(s) com o MAIOR salário.

```sql
SELECT Pnome, Unome, Salario
FROM FUNCIONARIO
WHERE Salario = (SELECT MAX(Salario) FROM FUNCIONARIO);
```

### Q34 — Subquery aninhada (resolve de dentro pra fora)

> Salários estritamente maiores que o segundo menor salário.

```sql
SELECT DISTINCT Salario
FROM FUNCIONARIO
WHERE Salario > (
    SELECT MIN(Salario)
    FROM FUNCIONARIO
    WHERE Salario > (SELECT MIN(Salario) FROM FUNCIONARIO)
)
ORDER BY Salario;
```

---

## 7. ORDER BY

### Q35 — Ordenação simples

```sql
SELECT Pnome, Unome, Salario
FROM FUNCIONARIO
ORDER BY Salario DESC;
```

### Q36 — Ordenação por múltiplas colunas

> Lista por departamento (alfabético), sobrenome, nome.

```sql
SELECT D.Dnome, F.Unome, F.Pnome
FROM FUNCIONARIO AS F JOIN DEPARTAMENTO AS D
    ON F.Dnr = D.Dnumero
ORDER BY D.Dnome ASC, F.Unome ASC, F.Pnome ASC;
```

### Q37 — Ordenação por posição (alternativa compacta)

```sql
SELECT D.Dnome, F.Unome, F.Pnome
FROM FUNCIONARIO AS F JOIN DEPARTAMENTO AS D
    ON F.Dnr = D.Dnumero
ORDER BY 1, 2, 3;
```

### Q38 — ORDER BY usando alias do SELECT

```sql
SELECT Pnome, Salario * 1.1 AS NovoSalario
FROM FUNCIONARIO
ORDER BY NovoSalario DESC;
```

---

## 8. CONSULTAS-DESAFIO (estilo prova)

### Q39 — Funcionários alocados em 2+ projetos

```sql
SELECT F.Cpf, F.Pnome, F.Unome, COUNT(T.Pnr) AS Qtd_proj
FROM FUNCIONARIO AS F JOIN TRABALHA_EM AS T ON F.Cpf = T.Fcpf
GROUP BY F.Cpf, F.Pnome, F.Unome
HAVING COUNT(T.Pnr) >= 2
ORDER BY Qtd_proj DESC;
```

### Q40 — Soma de horas por projeto

```sql
SELECT P.Projnome, SUM(T.Horas) AS Total_horas
FROM PROJETO AS P JOIN TRABALHA_EM AS T ON P.Projnumero = T.Pnr
GROUP BY P.Projnumero, P.Projnome
ORDER BY Total_horas DESC NULLS LAST;
```

> Em MariaDB tira o `NULLS LAST`.

### Q41 — Para cada projeto, total de horas e lista de quem trabalha

> (Aqui é só o total; pra "lista" precisaria de string_agg/group_concat)

```sql
SELECT P.Projnome,
       COUNT(DISTINCT T.Fcpf) AS Qtd_pessoas,
       SUM(T.Horas) AS Total_horas
FROM PROJETO AS P JOIN TRABALHA_EM AS T ON P.Projnumero = T.Pnr
GROUP BY P.Projnumero, P.Projnome;
```

### Q42 — Funcionários ganhando MAIS que o gerente do seu próprio departamento

```sql
SELECT F.Pnome, F.Unome, F.Salario, G.Pnome AS Gerente, G.Salario AS Sal_Gerente
FROM FUNCIONARIO AS F
    JOIN DEPARTAMENTO AS D ON F.Dnr = D.Dnumero
    JOIN FUNCIONARIO  AS G ON D.Cpf_gerente = G.Cpf
WHERE F.Salario > G.Salario;
```

**Esperado:** nessa base, 0 linhas (gerentes ganham mais que subordinados).

### Q43 — Para cada depto, salário médio comparado ao geral

```sql
SELECT D.Dnome,
       AVG(F.Salario) AS Media_depto,
       (SELECT AVG(Salario) FROM FUNCIONARIO) AS Media_geral,
       AVG(F.Salario) - (SELECT AVG(Salario) FROM FUNCIONARIO) AS Diferenca
FROM DEPARTAMENTO AS D JOIN FUNCIONARIO AS F ON D.Dnumero = F.Dnr
GROUP BY D.Dnumero, D.Dnome;
```

### Q44 — Quem trabalha em projeto que NÃO é do seu departamento

```sql
SELECT F.Pnome, F.Unome, D_F.Dnome AS Depto_func,
       P.Projnome, D_P.Dnome AS Depto_proj
FROM FUNCIONARIO AS F
    JOIN DEPARTAMENTO AS D_F ON F.Dnr = D_F.Dnumero
    JOIN TRABALHA_EM  AS T   ON F.Cpf = T.Fcpf
    JOIN PROJETO      AS P   ON T.Pnr = P.Projnumero
    JOIN DEPARTAMENTO AS D_P ON P.Dnum = D_P.Dnumero
WHERE F.Dnr <> P.Dnum;
```

### Q45 — Departamentos SEM nenhum projeto

```sql
SELECT D.Dnumero, D.Dnome
FROM DEPARTAMENTO AS D
    LEFT JOIN PROJETO AS P ON D.Dnumero = P.Dnum
WHERE P.Projnumero IS NULL;
```

> Padrão "quem não tem X" com LEFT JOIN + IS NULL.

---

## 9. UPDATE e DELETE (DML que não foi muito coberto mas é trivial)

### Q46 — UPDATE

> Aumenta salário em 10% pra todos do depto 5.

```sql
-- Antes
SELECT Pnome, Unome, Salario FROM FUNCIONARIO WHERE Dnr = 5;

UPDATE FUNCIONARIO
SET Salario = Salario * 1.1
WHERE Dnr = 5;

-- Depois
SELECT Pnome, Unome, Salario FROM FUNCIONARIO WHERE Dnr = 5;
```

### Q47 — DELETE

> Remove dependentes com parentesco 'Marido'.

```sql
DELETE FROM DEPENDENTE WHERE Parentesco = 'Marido';
SELECT * FROM DEPENDENTE;
```

> Pra reverter: roda o bloco SETUP de novo.

---

## 10. Checklist Final do Hands-On

- [ ] Rodei o SETUP sem erro
- [ ] Conferi as contagens das tabelas
- [ ] SELECT com WHERE simples (Q01-Q06)
- [ ] LIKE com `%` e `_` (Q07-Q08)
- [ ] DISTINCT (Q10)
- [ ] JOIN 2 tabelas (Q11-Q12)
- [ ] AUTO-JOIN com aliases (Q13)
- [ ] JOIN 3-4 tabelas (Q14-Q15)
- [ ] LEFT OUTER JOIN (Q23-Q25)
- [ ] IS NULL / IS NOT NULL (Q18-Q19)
- [ ] Vi que `= NULL` NÃO funciona (Q20)
- [ ] COALESCE (Q22)
- [ ] COUNT/SUM/AVG/MIN/MAX (Q26-Q27)
- [ ] GROUP BY simples (Q28-Q29)
- [ ] HAVING (Q30-Q31)
- [ ] Subquery com MIN/MAX (Q32-Q34)
- [ ] ORDER BY com ASC/DESC, múltiplas colunas, posição (Q35-Q38)
- [ ] Resolvi os 7 desafios estilo prova (Q39-Q45)

---

## Próximo Passo

Se sobrar tempo: pega cada questão dos exercícios em `02-sql/repo-ufg/topico-19.md`, `topico-20.md`, `topico-21.md` e escreve a SQL diretamente sobre o BD Empresa que já está carregado. **Treina SOB pressão de tempo.**
