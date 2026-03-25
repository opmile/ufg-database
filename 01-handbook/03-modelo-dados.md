# Modelos de Dados

## Abstração de Dados

### Arquitetura de Três Esquemas

```
┌─────────────────────────────────────────────────┐
│ NÍVEL EXTERNO (Visão)                           │  ← Mais abstrato
│ • Visão parcial para cada grupo de usuários     │
├─────────────────────────────────────────────────┤
│ NÍVEL CONCEITUAL (Lógico)                       │
│ • Entidades, relacionamentos, restrições        │
│ • Oculta detalhes físicos                       │
├─────────────────────────────────────────────────┤
│ NÍVEL INTERNO (Físico)                          │  ← Menos abstrato
│ • Estrutura de armazenamento real               │
│ • Caminhos de acesso                            │
└─────────────────────────────────────────────────┘
```

**Os dados reais só existem no nível interno!**

---

## Independência de Dados

### Independência Lógica
> Capacidade de alterar o esquema **conceitual** sem alterar esquemas **externos** ou programas.

**Exemplos de alterações:**
- Adicionar/remover tipo de registro
- Adicionar/remover item de dados

### Independência Física
> Capacidade de alterar o esquema **interno** sem alterar o esquema **conceitual**.

**Exemplos de alterações:**
- Ordenar registros de arquivo
- Criar índice

### Comparação

| Tipo | Facilidade | Frequência |
|------|------------|------------|
| **Física** | Mais fácil de alcançar | Mais comum |
| **Lógica** | Mais difícil | Menos comum |

---

## Modelos de Dados

> **Modelo de dados** = coleção de conceitos para descrever estrutura, relacionamentos, semântica e restrições.

### Principais Modelos

| Modelo | Nível | Representação |
|--------|-------|---------------|
| **Entidade-Relacionamento (MER)** | Conceitual | Entidades, relacionamentos, atributos |
| **Relacional (MR)** | Lógico | Relações (tabelas) |
| **Semiestruturado** | - | JSON, XML (atributos variáveis) |

**Este curso:** MER (conceitual) → MR (lógico)

---

## Erros Comuns

| ❌ Erro | ✅ Correto |
|---------|-----------|
| "Os três níveis armazenam dados" | Dados só no **nível interno** |
| "Independência física é mais difícil" | Independência **física** é mais **fácil** |
| "MER e MR são a mesma coisa" | MER = **conceitual**, MR = **lógico** |

---

## Checklist Rápido

- [ ] Nomear os 3 níveis de abstração
- [ ] Explicar onde os dados são realmente armazenados
- [ ] Diferenciar independência lógica vs física
- [ ] Explicar a diferença entre MER e MR
- [ ] Dar exemplo de alteração em cada nível