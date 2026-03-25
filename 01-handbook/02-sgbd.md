# Sistema Gerenciador de Banco de Dados (SGBD)

## Definição
> **SGBD é um software de propósito geral que apoia usuários na criação e manutenção de bancos de dados.**

> **O SGBD é de propósito geral. Os metadados são de propósito específico.**

---

## Funções do SGBD

| Função | Ação | Linguagem |
|--------|------|-----------|
| **Definição** | Tipos, estruturas, regras, restrições | DDL |
| **Construção** | Armazenamento inicial (carga) | - |
| **Manipulação** | Consultar e modificar dados | DML |
| **Compartilhamento** | Acesso simultâneo | - |

---

## Benefícios do SGBD

```
┌─────────────────────────────────────────┐
│           BENEFÍCIOS DO SGBD           │
├─────────────────────────────────────────┤
│ ✓ Múltiplas visões dos dados           │
│ ✓ Compartilhamento multiusuário        │
│ ✓ Consistência transacional            │
│ ✓ Controle de acesso (segurança)       │
│ ✓ Redundância controlada               │
│ ✓ Restrições de integridade            │
│ ✓ Backup e recuperação                 │
└─────────────────────────────────────────┘
```

---

## Arquitetura de um SGBD

### Componentes Principais

| Componente | Função |
|------------|--------|
| **Query Compiler** | Compila consultas |
| **Execution Engine** | Executa operações |
| **Transaction Manager** | Gerencia transações |
| **Concurrency Control** | Controle de concorrência |
| **Buffer Manager** | Gerencia memória |
| **Logging and Recovery** | Recuperação após falhas |

---

## Escalonamento de Transações

### Tipos de Escalonamento

| Tipo | Característica |
|------|----------------|
| **Serial** | Transações executam uma após outra |
| **Não-serial** | Transações intercaladas |

### Critérios de Validade

1. **Serializável**: Resultado equivalente a algum escalonamento serial
2. **Recuperável**: Se T1 lê de T2, então T2 deve commitar antes de T1

### Hierarquia de Escalonamentos

```
Todos os Escalonamentos
         │
         ├──▶ Recuperáveis
         │         │
         │         └──▶ Serializáveis
         │                   │
         │                   └──▶ Seriais
```

---

## Erros Comuns

| ❌ Erro | ✅ Correto |
|---------|-----------|
| "SGBD é feito para uma aplicação específica" | SGBD é **propósito geral** |
| "Definição de dados fica nos programas" | Definição fica no **catálogo** (metadados) |
| "Escalonamento não-serial é sempre inválido" | Pode ser **serializável** |

---

## Checklist Rápido

- [ ] Definir SGBD e suas 4 funções principais
- [ ] Explicar diferença: SGBD geral vs metadados específicos
- [ ] Listar 6 componentes da arquitetura SGBD
- [ ] Diferenciar escalonamento serial vs serializável
- [ ] Explicar o que é transação recuperável