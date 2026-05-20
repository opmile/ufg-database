# Handbook SQL — Tópicos 18 a 21

> Material condensado para estudo rápido. Foco no que cai: **SQL prática** sobre modelo relacional. Álgebra relacional fica de fora (ruído do professor que não ajuda a escrever query).

## Estrutura do Handbook

| Arquivo | Conteúdo | Tempo |
|---------|----------|-------|
| [00-visao-geral](./00-visao-geral.md) | Mapa, ordem, anatomia do SELECT completo | 5 min |
| [01-ddl](./01-ddl.md) | CREATE TABLE, ALTER, constraints (T18) | 10 min |
| [02-select-basico](./02-select-basico.md) | SELECT/FROM/WHERE, BETWEEN/IN/LIKE, DISTINCT (T19) | 15 min |
| [03-joins-nulls](./03-joins-nulls.md) | JOIN, NATURAL, OUTER, NULL, COALESCE (T20) | 20 min |
| [04-agregacao](./04-agregacao.md) | COUNT/SUM/AVG/MIN/MAX, GROUP BY, HAVING, ORDER BY (T21) | 15 min |
| [05-checklist-prova](./05-checklist-prova.md) | Pegadinhas, V/F, padrões de questão | 10 min |
| [06-handson](./06-handson.md) | **BD Empresa do zero: CREATE + INSERT + 30+ queries guiadas** | 60+ min |

## Ordem de Leitura

```
00 → 01 → 02 → 03 → 04 → 05 → 06 (hands-on)
```

**Tempo total:** ~2h teoria + tempo livre no hands-on.

## Tópicos Originais

| Tópico | Correspondência |
|--------|-----------------|
| T18 | 01-ddl |
| T19 | 02-select-basico |
| T20 | 03-joins-nulls |
| T21 | 04-agregacao |

## Como usar

1. Lê o resumo do tópico → fixa estrutura mental.
2. Vai pro hands-on **rodando cada bloco** no SQLite Online (MariaDB ou PostgreSQL).
3. Revisa checklist na véspera.

## Ferramenta recomendada

- **SQLite Online:** https://sqliteonline.com/ → MariaDB ou PostgreSQL (clique "click to connect").
- Cola o bloco de `06-handson.md` → ➤Run.

> **Foco da avaliação:** escrever consultas SQL corretas. Não decorar derivação de álgebra. Saber resolver com SQL = ponto.
