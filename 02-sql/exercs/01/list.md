# Lista progressiva de SQL — banco MÚSICA

Baseada nos 4 erros da sua prova:

1. Confundir `WHERE` (filtra linhas) com `HAVING` (filtra grupos).
2. Agrupar pela coluna errada (você agrupou por `Comida`; o certo era `Pessoa`).
3. Ambiguidade de colunas no `JOIN` (`ON Comida = Comida`).
4. Usar `!= 2` no lugar de `>= 2`.

Rode o `musica.sql` primeiro. Tente cada exercício antes de olhar o gabarito (no fim).

Esquema:
- `ARTISTA(id, nome, pais)`
- `MUSICA(id, titulo, genero, duracao_seg, artista_id)`
- `USUARIO(id, nome, cidade)`
- `CURTE(usuario_id, musica_id)`

---

## Nível 0 — Aquecimento (SELECT + WHERE puro)

**0.1** Liste `titulo` e `genero` das músicas com duração maior que 240 segundos.

**0.2** Liste o `nome` dos usuários da cidade `'Goiânia'`.

---

## Nível 1 — WHERE vs HAVING (erro 1)

**1.1** Quantas músicas existem de cada gênero? (mostre o gênero e a contagem)

**1.2** Quais gêneros têm **mais de 2** músicas? Use `HAVING`.

**1.3** (Conceitual) Por que `WHERE COUNT(*) > 2` não funciona? Em que ordem o banco aplica `WHERE` e `HAVING`?

**1.4** Quais gêneros têm duração **média** acima de 300 segundos?

---

## Nível 2 — Agrupar pela entidade certa (erro 2)

**2.1** De quantas músicas **cada usuário** gosta? (nome do usuário + contagem). A pergunta é "por usuário" → agrupe pela entidade certa.

**2.2** (Conceitual) Se a pergunta fosse "por gênero", você agruparia por qual coluna? E "por usuário"? Por quê?

**2.3** Quantos usuários **distintos** curtem cada gênero? (gênero + nº de usuários). Cuidado: conte usuário, não curtida.

---

## Nível 3 — JOIN e qualificação de colunas (erro 3)

**3.1** Liste o `titulo` de cada música e o `nome` do artista. As duas tabelas têm coluna `id` — qualifique tudo (use apelidos de tabela).

**3.2** (Conceitual) Por que `SELECT id, nome FROM MUSICA JOIN ARTISTA ON ...` dá erro de ambiguidade? Reescreva resolvendo.

**3.3** Liste o `nome` do usuário e o `titulo` das músicas que ele curte.

---

## Nível 4 — Tudo junto (estilo da prova)

**4.1** (= Questão 2) Quais usuários curtem **pelo menos uma** música de `rock`? Sem agrupar — use `DISTINCT`.

**4.2** (= Questão 3) Quais usuários curtem **duas ou mais** músicas de `rock`?

**4.3** (= Questão 1) Quais artistas têm **2 ou mais** músicas cadastradas? Conte músicas por artista e use `HAVING`.

**4.4** Quais usuários curtem músicas de artistas **brasileiros**? (3 tabelas + filtro no país)

---

## Nível 5 — Armadilhas e desafios

**5.1** (erro 4) Rode a 4.2 trocando `HAVING COUNT(*) >= 2` por `HAVING COUNT(*) != 2`. Quem aparece? Por que está errado para "duas ou mais"?

**5.2** Quais usuários curtem **exatamente 2** músicas de `rock`?

**5.3** Quais músicas **não são curtidas por ninguém**? (use `LEFT JOIN` ou `NOT IN`)

**5.4** Quais usuários curtem **mais** músicas que a Carla? (subconsulta)

**5.5** Quais usuários curtem `rock` mas **não** curtem nenhuma música de `rap`?

---
---

# Gabarito

## Nível 0

**0.1**
```sql
SELECT titulo, genero
FROM MUSICA
WHERE duracao_seg > 240;
```
Retorna: Let It Happen, Diário de um Detento, Negro Drama, Get Lucky, Around the World, Karma Police.

**0.2**
```sql
SELECT nome
FROM USUARIO
WHERE cidade = 'Goiânia';
```
Retorna: Ana, Carla.

## Nível 1

**1.1**
```sql
SELECT genero, COUNT(*)
FROM MUSICA
GROUP BY genero;
```
rock 5, rap 2, eletronica 3, mpb 3.

**1.2**
```sql
SELECT genero
FROM MUSICA
GROUP BY genero
HAVING COUNT(*) > 2;
```
rock, eletronica, mpb.

**1.3** `WHERE` é avaliado **antes** do agrupamento, linha a linha — nesse momento `COUNT(*)` ainda não existe. `HAVING` roda **depois** do `GROUP BY`, sobre cada grupo já formado, então é lá que vão condições sobre agregações (`COUNT`, `SUM`, `AVG`).

**1.4**
```sql
SELECT genero, AVG(duracao_seg)
FROM MUSICA
GROUP BY genero
HAVING AVG(duracao_seg) > 300;
```
rap (395), eletronica (~340). (rock ~284 e mpb ~193 ficam de fora.)

## Nível 2

**2.1**
```sql
SELECT u.nome, COUNT(*)
FROM USUARIO u
JOIN CURTE c ON u.id = c.usuario_id
GROUP BY u.id, u.nome;
```
Ana 4, Bruno 3, Carla 3, Diego 3, Elis 3.

**2.2** "Por gênero" → `GROUP BY genero`. "Por usuário" → `GROUP BY usuario`. Você agrupa pela entidade da qual quer **uma linha de resultado por valor**. Na prova você queria uma linha por pessoa, então deveria ter agrupado por `Pessoa`, nunca por `Comida`.

**2.3**
```sql
SELECT m.genero, COUNT(DISTINCT c.usuario_id)
FROM MUSICA m
JOIN CURTE c ON m.id = c.musica_id
GROUP BY m.genero;
```
rock 4, rap 2, eletronica 1, mpb 2. Sem `DISTINCT` você contaria curtidas, não usuários.

## Nível 3

**3.1**
```sql
SELECT m.titulo, a.nome
FROM MUSICA m
JOIN ARTISTA a ON m.artista_id = a.id;
```

**3.2** Tanto `MUSICA` quanto `ARTISTA` têm as colunas `id` e `nome`; sem qualificar, o banco não sabe de qual tabela. Correto:
```sql
SELECT m.id, a.nome
FROM MUSICA m
JOIN ARTISTA a ON m.artista_id = a.id;
```
Mesmo problema da prova: `ON Comida = Comida` → escreva `G.Comida = V.Comida`.

**3.3**
```sql
SELECT u.nome, m.titulo
FROM USUARIO u
JOIN CURTE c  ON u.id = c.usuario_id
JOIN MUSICA m ON c.musica_id = m.id;
```

## Nível 4

**4.1**
```sql
SELECT DISTINCT u.nome
FROM USUARIO u
JOIN CURTE c  ON u.id = c.usuario_id
JOIN MUSICA m ON c.musica_id = m.id
WHERE m.genero = 'rock';
```
Ana, Bruno, Carla, Elis. Sem `DISTINCT`, Ana apareceria 3 vezes.

**4.2**
```sql
SELECT u.nome
FROM USUARIO u
JOIN CURTE c  ON u.id = c.usuario_id
JOIN MUSICA m ON c.musica_id = m.id
WHERE m.genero = 'rock'
GROUP BY u.id, u.nome
HAVING COUNT(*) >= 2;
```
Ana (3), Bruno (2), Elis (3). Note: filtro do gênero no `WHERE`, contagem no `HAVING`.

**4.3**
```sql
SELECT a.nome
FROM ARTISTA a
JOIN MUSICA m ON a.id = m.artista_id
GROUP BY a.id, a.nome
HAVING COUNT(*) >= 2;
```
Tame Impala, Racionais MCs, Daft Punk, Tim Maia, Radiohead. (Anavitória tem só 1, fica de fora.)

**4.4**
```sql
SELECT DISTINCT u.nome
FROM USUARIO u
JOIN CURTE c   ON u.id = c.usuario_id
JOIN MUSICA m  ON c.musica_id = m.id
JOIN ARTISTA a ON m.artista_id = a.id
WHERE a.pais = 'Brasil';
```
Bruno, Carla, Diego.

## Nível 5

**5.1** Com `!= 2`: Ana (3), Carla (1), Elis (3). Está errado porque **inclui Carla**, que curte só 1 música de rock, e **exclui Bruno**, que curte exatamente 2. "Duas ou mais" é `>= 2`.

**5.2**
```sql
... WHERE m.genero = 'rock'
GROUP BY u.id, u.nome
HAVING COUNT(*) = 2;
```
Só Bruno.

**5.3**
```sql
SELECT m.titulo
FROM MUSICA m
LEFT JOIN CURTE c ON m.id = c.musica_id
WHERE c.musica_id IS NULL;
```
Harder Better Faster Stronger, Around the World, Trevo.

**5.4**
```sql
SELECT u.nome
FROM USUARIO u
JOIN CURTE c ON u.id = c.usuario_id
GROUP BY u.id, u.nome
HAVING COUNT(*) > (SELECT COUNT(*) FROM CURTE WHERE usuario_id = 3);
```
Carla curte 3; só Ana (4) curte mais. Retorna: Ana.

**5.5**
```sql
SELECT DISTINCT u.nome
FROM USUARIO u
JOIN CURTE c  ON u.id = c.usuario_id
JOIN MUSICA m ON c.musica_id = m.id
WHERE m.genero = 'rock'
  AND u.id NOT IN (
        SELECT c2.usuario_id
        FROM CURTE c2
        JOIN MUSICA m2 ON c2.musica_id = m2.id
        WHERE m2.genero = 'rap'
  );
```
Rock: Ana, Bruno, Carla, Elis. Rap: Bruno, Diego. Resultado: Ana, Carla, Elis.