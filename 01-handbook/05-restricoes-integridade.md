# Restrições de Integridade

## Visão Geral

```
┌─────────────────────────────────────────────────┐
│           RESTRIÇÕES DE INTEGRIDADE             │
├─────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌──────────┐ │
│  │   DOMÍNIO   │  │    CHAVE    │  │ ENTIDADE │ │
│  └─────────────┘  └─────────────┘  └──────────┘ │
│         │               │               │        │
│         └───────────────┼───────────────┘        │
│                         ▼                        │
│               ┌─────────────────┐                │
│               │ REFERENCIAL     │                │
│               │ (FK)            │                │
│               └─────────────────┘                │
└─────────────────────────────────────────────────┘
```

---

## 1. Restrição de Domínio

> Cada valor de atributo deve ser **atômico** e pertencer ao **domínio definido**.

```
∀ tⱼ ∈ r(R)  ∧  ∀ Aᵢ de R:
    t[Aᵢ] ∈ dom(Aᵢ)
```

**Implementação:** tipos de dados, faixas, enumerações.

---

## 2. Restrição de Chave

> **Exclusividade:** duas tuplas não podem ter mesma combinação de valores para a chave.

```
Se SK é chave de R:
    Para quaisquer t₁, t₂ ∈ r(R):
        t₁[SK] ≠ t₂[SK]
```

---

## 3. Restrição de Integridade de Entidade

> **Nenhum atributo da chave primária pode ser NULL.**

```
Se PK é chave primária de R:
    ∀ t ∈ r(R): t[PK] ≠ NULL
```

**Por que?** PK identifica unicamente cada tupla. NULL = identificação impossível.

---

## 4. Restrição de Integridade Referencial

> Garante que **referências entre tuplas sejam consistentes**.

### Chave Estrangeira (FK)

**Definição:** Atributos em R que referenciam a PK de S.

```
FK em R referencia PK de S se:
1. FK e PK têm o mesmo domínio
2. Para cada t₁ ∈ r(R):
   - t₁[FK] = t₂[PK] para algum t₂ ∈ s(S), OU
   - t₁[FK] = NULL
```

### Exemplo

```
PRODUTO(CodProduto, Descrição, Preço, Categ)
                                    ↑
                                   FK

CATEGORIA(CodCateg, Nome)
     ↑
     PK

PRODUTO(Categ) REFERENCIA CATEGORIA(CodCateg)
```

---

## Resumo Comparativo

| Restrição | O que garante | Onde aplica |
|-----------|---------------|-------------|
| **Domínio** | Valores válidos | Cada atributo |
| **Chave** | Exclusividade | Chave candidata |
| **Entidade** | PK não nula | Chave primária |
| **Referencial** | Referências consistentes | Chave estrangeira |

---

## Operações e Violações

### Ao Inserir Tupla

| Restrição | Violação se... |
|-----------|----------------|
| Domínio | Valor fora do domínio |
| Chave | PK duplicada |
| Entidade | PK com NULL |
| Referencial | FK não existe na tabela referenciada |

### Ao Excluir Tupla

| Restrição | Violação se... |
|-----------|----------------|
| Referencial | FK em outra tabela aponta para tupla excluída |

### Ao Modificar Tupla

| Restrição | Violação se... |
|-----------|----------------|
| Todas | Novos valores violam qualquer restrição |

---

## Notação para FK

```
RELAÇÃO(FK) REFERENCIA RELAÇÃO(PK)
```

**Exemplos BD Empresa:**
```
FUNCIONARIO(Dnr) REFERENCIA DEPARTAMENTO(Dnumero)
FUNCIONARIO(Cpf_supervisor) REFERENCIA FUNCIONARIO(Cpf)
TRABALHA_EM(Fcpf) REFERENCIA FUNCIONARIO(Cpf)
TRABALHA_EM(Prn) REFERENCIA PROJETO(Projnumero)
DEPENDENTE(Fcpf) REFERENCIA FUNCIONARIO(Cpf)
DEPARTAMENTO(Cpf_gerente) REFERENCIA FUNCIONARIO(Cpf)
```

---

## Erros Comuns

| ❌ Erro | ✅ Correto |
|---------|-----------|
| "FK pode ter qualquer valor" | FK deve existir na PK ou ser NULL |
| "PK pode ter NULL" | **Nunca!** Viola integridade de entidade |
| "Excluir tupla referenciada é simples" | Pode violar integridade referencial |
| "FK é sempre PK de outra tabela" | FK referencia PK, mas FK **não é** PK |

---

## Checklist Rápido

- [ ] Definir as 4 restrições de integridade
- [ ] Explicar por que PK não pode ser NULL
- [ ] Dar exemplo de violação de integridade referencial
- [ ] Usar notação correta para FK
- [ ] Explicar o que acontece ao excluir tupla referenciada