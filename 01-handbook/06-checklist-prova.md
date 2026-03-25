# Checklist Pré-Prova

## Conceitos Fundamentais

### Banco de Dados
- [ ] Definir BD (coleção de dados relacionados, propósito definido)
- [ ] Listar propriedades implícitas do BD
- [ ] Explicar diferença: dados vs metadados

### SGBD
- [ ] Definir SGBD e suas 4 funções
- [ ] Explicar: SGBD geral vs metadados específicos
- [ ] Listar benefícios do uso de SGBD
- [ ] Nomear componentes da arquitetura SGBD

### Abstração de Dados
- [ ] Nomear os 3 níveis de abstração
- [ ] Explicar onde dados são armazenados (nível interno!)
- [ ] Diferenciar independência lógica vs física

---

## Modelo Relacional

### Terminologia
- [ ] Definir: relação, tupla, atributo, domínio, grau, cardinalidade
- [ ] Explicar esquema de relação: R(A₁, A₂, ..., Aₙ)
- [ ) Explicar valor NULL

### Chaves
- [ ] Diferenciar: superchave, chave, chave candidata, chave primária
- [ ] Explicar minimalidade da chave
- [ ] Dar exemplo de superchave que NÃO é chave

### Restrições de Integridade
- [ ] Definir restrição de domínio
- [ ] Definir restrição de chave
- [ ] Definir restrição de integridade de entidade
- [ ] Definir restrição de integridade referencial
- [ ] Explicar por que PK não pode ser NULL
- [ ] Usar notação: RELAÇÃO(FK) REFERENCIA RELAÇÃO(PK)

---

## Tópicos Mais Cobrados

### ⭐⭐⭐ Alta Probabilidade
1. **Identificar chaves (PK, FK, candidatas)**
2. **Detectar violações de integridade** em operações
3. **Definir restrições de integridade**
4. **Diferenciar níveis de abstração**

### ⭐⭐ Média Probabilidade
1. Componentes da arquitetura SGBD
2. Independência lógica vs física
3. Escalonamento serial vs serializável
4. Tipos de metadados

### ⭐ Menor Probabilidade
1. Detalhes de escalonamento de transações
2. Exercícios complexos de consultas

---

## Pegadinhas Comuns

### Sobre Chaves
| Pegadinha | Resposta |
|-----------|----------|
| "Toda superchave é chave?" | **NÃO** - pode ter atributos supérfluos |
| "FK pode ser NULL?" | **SIM** - se a relação é opcional |
| "PK pode ser NULL?" | **NUNCA** - viola integridade de entidade |

### Sobre Relações
| Pegadinha | Resposta |
|-----------|----------|
| "Pode haver tuplas duplicadas?" | **NÃO** - relação é conjunto |
| "Ordem de tuplas importa?" | **NÃO** - são elementos de conjunto |
| "Relação = Tabela?" | **APROXIMAÇÃO** - mas relação é conceito matemático |

### Sobre SGBD
| Pegadinha | Resposta |
|-----------|----------|
| "SGBD é específico para cada BD?" | **NÃO** - é propósito geral |
| "Metadados mudam mais que dados?" | **NÃO** - dados mudam mais |

---

## Verdadeiro ou Falso - Treino

Marque V ou F:

1. ( ) Um banco de dados é qualquer coleção de dados
2. ( ) Metadados descrevem a estrutura dos dados
3. ( ) SGBD é software de propósito específico
4. ( ) Dados são armazenados no nível conceitual
5. ( ) Uma relação pode ter tuplas duplicadas
6. ( ) Toda chave é uma superchave
7. ( ) Toda superchave é uma chave
8. ( ) A chave primária pode conter NULL
9. ( ) A chave estrangeira pode conter NULL
10. ( ) Independência física é mais difícil que lógica

**Respostas:** 1F, 2V, 3F, 4F, 5F, 6V, 7F, 8F, 9V, 10F

---

## Exercício Prático: BD Empresa

Identifique as chaves estrangeiras:

```
FUNCIONARIO(Cpf, Pnome, Unome, Salario, Dnr, Cpf_supervisor)
DEPARTAMENTO(Dnumero, Dnome, Cpf_gerente)
TRABALHA_EM(Fcpf, Prn, Horas)
PROJETO(Projnumero, Projnome, Dnum)
DEPENDENTE(Fcpf, Nome, Parentesco)
```

**Respostas:**
- FUNCIONARIO(Dnr) → DEPARTAMENTO(Dnumero)
- FUNCIONARIO(Cpf_supervisor) → FUNCIONARIO(Cpf)
- DEPARTAMENTO(Cpf_gerente) → FUNCIONARIO(Cpf)
- TRABALHA_EM(Fcpf) → FUNCIONARIO(Cpf)
- TRABALHA_EM(Prn) → PROJETO(Projnumero)
- PROJETO(Dnum) → DEPARTAMENTO(Dnumero)
- DEPENDENTE(Fcpf) → FUNCIONARIO(Cpf)