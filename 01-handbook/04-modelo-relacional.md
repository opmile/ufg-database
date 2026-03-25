# Modelo Relacional (MR)

## Conceito Central

> **O Modelo Relacional representa o BD como uma coleção de relações.**
> Uma relação ≈ tabela (mas há diferenças importantes!)

---

## Terminologia Essencial

| Termo | Sinônimo | Definição |
|-------|----------|-----------|
| **Relação** | Tabela | Conjunto de tuplas |
| **Tupla** | Linha/Registro | Lista ordenada de valores `<v₁, v₂, ..., vₙ>` |
| **Atributo** | Coluna | Nome de uma coluna |
| **Esquema de Relação** | - | `R(A₁, A₂, ..., Aₙ)` |
| **Domínio** | - | Conjunto de valores permitidos para atributo |
| **Grau** | Aridade | Número de atributos (n) |
| **Cardinalidade** | - | Número de tuplas |

---

## Notação Formal

```
Esquema de Relação:  R(A₁, A₂, ..., Aₙ)
Relação:             r(R) ⊆ dom(A₁) × dom(A₂) × ... × dom(Aₙ)
Tupla:               t = <v₁, v₂, ..., vₙ>
Valor de atributo:   t[Aᵢ] ou t.Aᵢ
```

---

## Características da Relação

### Propriedades Fundamentais

1. **Não há tuplas duplicadas** (é um conjunto!)
2. **Ordem de tuplas é irrelevante**
3. **Ordem de atributos é relevante** na notação, mas semanticamente não
4. **Valores são atômicos** (não compostos)

### Valor NULL
> Indica valor desconhecido, não aplicável ou ausente.

---

## Chaves

### Hierarquia de Chaves

```
┌─────────────────────────────────────────────────┐
│                SUPERCHAVE (SK)                  │
│  Conjunto de atributos com exclusividade       │
│  (pode ter atributos supérfluos)               │
├─────────────────────────────────────────────────┤
│                    CHAVE                        │
│  Superchave MÍNIMA (sem atributos supérfluos)  │
├─────────────────────────────────────────────────┤
│               CHAVE CANDIDATA                   │
│  Qualquer chave que pode ser escolhida como PK │
├─────────────────────────────────────────────────┤
│               CHAVE PRIMÁRIA (PK)               │
│  Chave candidata ESCOLHIDA para identificar    │
│  tuplas unicamente                              │
└─────────────────────────────────────────────────┘
```

### Exemplo Prático

```
ALUNO(Matricula, Nome, DataNascimento)

Superchaves: {Matricula}, {Matricula, Nome}, {Matricula, Nome, DataNascimento}...
Chaves: {Matricula}
Chave Candidata: {Matricula}
Chave Primária: Matricula
```

---

## Checklist de Conceitos MR

- [ ] Relação
- [ ] Esquema de relação
- [ ] Tupla
- [ ] Atributo
- [ ] Domínio
- [ ] Grau
- [ ] Cardinalidade
- [ ] NULL
- [ ] Superchave
- [ ] Chave
- [ ] Chave candidata
- [ ] Chave primária
- [ ] Chave estrangeira

---

## Erros Comuns

| ❌ Erro | ✅ Correto |
|---------|-----------|
| "Relação = Tabela" | Semelhantes, mas relação é **conjunto matemático** |
| "Pode haver tuplas iguais" | **Não!** Relação é conjunto (sem repetição) |
| "Superchave é sempre chave" | Superchave pode ter **atributos supérfluos** |
| "NULL é igual a zero ou vazio" | NULL é **ausência de valor** |