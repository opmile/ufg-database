# Banco de Dados - Visão Geral

## Mapa Mental da Disciplina

```
┌─────────────────────────────────────────────────────────────────┐
│                    BANCO DE DADOS                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  FUNDAMENTOS          MODELOS           IMPLEMENTAÇÃO           │
│  ────────────         ───────           ─────────────          │
│  • O que é BD?        • Modelo de       • SGBD                 │
│  • Dados vs          Dados             • Arquitetura           │
│    Metadados          • MER             • Transações           │
│  • Requisitos        • MR               • Escalonamento        │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│                    MODELO RELACIONAL                            │
│                    ─────────────────                            │
│  ┌──────────┐    ┌──────────┐    ┌──────────────┐               │
│  │ Relação  │───▶│ Chaves   │───▶│ Restrições   │               │
│  │ Tupla    │    │ PK/FK    │    │ Integridade  │               │
│  │ Atributo │    │ Candidata│    │ Domínio      │               │
│  └──────────┘    └──────────┘    └──────────────┘               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Ordem de Estudo (Fundamental → Avançado)

| Etapa | Tópico | Dependências | Prioridade |
|-------|--------|--------------|------------|
| 1 | O que é Banco de Dados | - | ALTA |
| 2 | Dados vs Metadados | Etapa 1 | ALTA |
| 3 | Conceitos Básicos (Checklist) | Etapa 1-2 | ALTA |
| 4 | Requisitos de Dados | Etapa 1-3 | MÉDIA |
| 5 | SGBD - Conceitos | Etapa 1-4 | ALTA |
| 6 | SGBD - Transações | Etapa 5 | MÉDIA |
| 7 | Modelo de Dados | Etapa 2-5 | **CRÍTICA** |
| 8 | Modelo Relacional - Fundamentos | Etapa 7 | **CRÍTICA** |
| 9 | Restrições de Integridade | Etapa 8 | **CRÍTICA** |
| 10 | Exercícios MR | Etapa 8-9 | ALTA |

## Tópicos Mais Cobrados

1. **Modelo Relacional** - aparece em 5 tópicos (08, 09, 10a, 10b, 10c)
2. **Restrições de Integridade** - PK, FK, domínio, entidade
3. **SGBD** - funções, arquitetura, componentes
4. **Independência de Dados** - lógica vs física
5. **Chaves** - primária, estrangeira, candidata, superchave

## Gargalos de Entendimento

```
METADADOS ──▶ SGBD ──▶ MODELO DE DADOS ──▶ MODELO RELACIONAL
   │            │              │                  │
   │            │              │                  ▼
   │            │              │           RESTRIÇÕES DE
   │            │              │             INTEGRIDADE
   │            │              │                  │
   └────────────┴──────────────┴──────────────────┘
                        ▼
               ENTENDIMENTO COMPLETO
```

**Não pule etapas!** Cada tema é pré-requisito do próximo.