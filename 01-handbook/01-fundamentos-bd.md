# Fundamentos de Banco de Dados

## O que é Banco de Dados?

### Definição Central
> **Banco de dados é uma coleção de dados relacionados, com propósito definido, gerenciados por software.**

### Propriedades Implícitas
- Coleção **logicamente coerente** (não é arranjo aleatório)
- **Propósito específico** (usuários e aplicações definidas)
- Representa **aspecto do mundo real** (reflete mudanças)

### Papéis do Software (SGBD)

| Função | Descrição |
|--------|-----------|
| **Definição** | Especificar esquemas, tipos, restrições (DDL) |
| **Construção** | Carga inicial dos dados |
| **Manipulação** | Consultas e atualizações (DML) |
| **Compartilhamento** | Acesso simultâneo multiusuário |
| **Proteção** | Durabilidade, recuperação, segurança |

---

## Dados vs Metadados

### Dados
- Valores brutos armazenados
- Representam fatos do mundo real
- Alteram com frequência

### Metadados
> **"Dados sobre dados"** - descrevem estrutura e significado

| Tipo | Função | Exemplo |
|------|--------|---------|
| **Descritivos** | Identificação e busca | título, autor, palavras-chave |
| **Estruturais** | Organização | como páginas formam capítulos |
| **Administrativos** | Gerenciamento | data criação, tipo arquivo |

### Termos Sinônimos de Metadados
- Esquema de dados
- Dicionário de dados
- Catálogo de dados
- Descrição/Definição de dados

---

## Erros Comuns

| ❌ Erro | ✅ Correto |
|---------|-----------|
| "Metadados são dados" | Metadados **descrevem** dados |
| "BD é qualquer conjunto de dados" | BD tem **propósito** e é **logicamente coerente** |
| "SGBD é específico para cada aplicação" | SGBD é **propósito geral**, metadados são **específicos** |

---

## Checklist Rápido

- [ ] Definir BD com suas próprias palavras
- [ ] Diferenciar dados de metadados
- [ ] Listar 5 funções do SGBD
- [ ] Explicar por que BD precisa ter propósito