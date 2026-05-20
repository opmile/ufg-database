# SQL — Visão Geral

## Mapa Mental

```
┌──────────────────────────────────────────────────────────────────┐
│                              SQL                                 │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│   DDL                  DML                       DCL             │
│   ─────                ─────                     ─────           │
│   CREATE TABLE         SELECT  ◄── FOCO          GRANT           │
│   ALTER TABLE          INSERT                    REVOKE          │
│   DROP TABLE           UPDATE                                    │
│                        DELETE                                    │
│                                                                  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│                 ANATOMIA DO SELECT COMPLETO                      │
│                 ───────────────────────────                      │
│                                                                  │
│   SELECT      atributos / expressões / agregações                │
│   FROM        relações + JOINs                                   │
│   WHERE       filtro de tuplas (antes do grupo)                  │
│   GROUP BY    forma grupos                                       │
│   HAVING      filtro de grupos (depois do GROUP BY)              │
│   ORDER BY    ordenação do resultado                             │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

## Ordem Lógica de Execução

> **NÃO é a ordem que você escreve!** É a ordem que o SGBD avalia.

```
1. FROM       → quais tabelas + joins
2. WHERE      → filtra tuplas
3. GROUP BY   → forma grupos
4. HAVING     → filtra grupos
5. SELECT     → projeta colunas / aplica agregações
6. ORDER BY   → ordena resultado
```

Isso explica:
- Por que **não dá pra usar alias do SELECT no WHERE** (WHERE roda antes do SELECT).
- Por que **HAVING vê agregações e WHERE não**.

## Ordem de Estudo

| Etapa | Tópico | Prioridade |
|-------|--------|------------|
| 1 | DDL básico (CREATE TABLE, constraints) | MÉDIA |
| 2 | SELECT/FROM/WHERE simples | **CRÍTICA** |
| 3 | JOIN com 2+ tabelas | **CRÍTICA** |
| 4 | NULL e IS NULL | ALTA |
| 5 | OUTER JOIN (LEFT/RIGHT) | ALTA |
| 6 | Agregação + GROUP BY + HAVING | **CRÍTICA** |
| 7 | ORDER BY | MÉDIA |

## Tópicos Mais Cobrados (probabilidade alta na prova)

1. **Escrever JOIN entre 2-4 tabelas** (T20 inteiro)
2. **GROUP BY + HAVING com contagem** (T21 Exemplo 06)
3. **Avaliação de predicados com NULL** (T20 lógica 3-valorada — questão clássica)
4. **DISTINCT + COUNT** (T21 Exemplos 02-03)
5. **Subqueries com MIN/MAX no WHERE** (T21 exercícios)
6. **LIKE com `%` e `_`** (T19 Exemplo 08)

## Não pula etapas

```
DDL → SELECT simples → JOIN → NULL → OUTER JOIN → AGREGAÇÃO → GROUP BY → HAVING
```

JOIN é pré-requisito de quase tudo. Domina JOIN antes de tentar agregação com múltiplas tabelas.
