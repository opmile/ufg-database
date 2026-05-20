# Gabarito Checklist

Um banco de dados é uma coleção de dados relacionados com propósito específico, gerenciados por um software (referenciado por SGBD)

São propriedades implícitas a representação de um aspecto do mundo real, e por isso o atendimento a um propósito específico com uma coleção logicamente coerente (não é um arranjo aleatório)

dados são valores brutos armazenados, metadatos são dados sobre dados que descrevem a estrutura e significado do dado (também chamado de dicionário de dados, esquema de dados ou catálogo de dados)

---

um sgbd é um software armazenamento dos dados que tem o papel de gerenciá-los auxiliando na criação e manutenção dos dados. tem propósito geral, com apoio a qualquer tipo de aplicação, enquanto metadados são de propósito específico, visto que descrevem justamente a estrutura dos dados referenciados pela aplicação do sgbd

um sgbd tem as funções de: definição (ddl), definindo o tipo dos dados, a estrutura, seus esquemas, regras, restrições; manipulação (dml) com a capacidade de modificar e consultar dados; construção (carga inicial de dados); compartilhamento (acesso a múltiplos usuários simultâneos)

com sgbds temos múltiplas visões dos dados, compartilhamento multiusuários, consistência transacional (transações atômicas), controle de acesso (segurança), restrições de integridade (proteção de dados)

componentes: query compilator, execution engine, transaction manager, concurrency control, buffer manager, logging and recovery

---

os três níveis de abstração

* nível externo: visível pelo usuário final

* nível conceitual: define entidade, relacionamento, restrições

* nível interno: estrutura de armazenamento em si

independência lógica define a capacidade de alterar o esquema conceitual sem alterar esquemas externos (adicionar ou remover tipo de registro (atributo) ou um item de dados)

independência física define a capacidade de alterar o esquema interno sem alterar o esquema conceitual (ordenar registros, crar índice)

---

o modelo relacional permite abstrair uma tabela do banco de dados ao conceito matemático de relação, sendo uma coleção de relações

uma relação é uma tabela, um conjunto de tuplas; uma tupla representa uma linha (registro) único; um atributo representa uma coluna; o domínio representa a abstração que define quais atributos estão sendo descritos pela relação; o grau representa a quantidade de atributos da relação; a cardinalidade representa a quantidade de tuplas da tabela

NULL representa a ausência de dados, valor não aplicável ou desconhecido

sobre minimalidade da chave (chave candidata): uma chave é considerada mínima (candidata ou superchave mínima) quando ela identifica exclusivamente uma linha em uma tabela e, se qualquer um dos seus atributos (colunas) for removido, ela perde essa capacidade de identificação única

superchave é qualquer conjunto de um ou mais atributos que, juntos, identificam de forma única uma tupla

---

restrições de domínio define que cada valor deve ser atômico (indivisível) e pertencer ao domínio específico

restrições de chave garante a exclusividade da chave primária, duas tuplas não podem ter a mesma combinação de valores para a chave

restrições de integridade de entidade garante que uma chave primária nunca seja nula (NULL). como a pk identifica unicamente cada tupla, um valor NULL torna a identificação impossível

restrições de integridade referencial garante que referências entre tuplas sejam consistentes, visto que ao tentar excluir uma tupla que possui referenciação, existe violação visto que a FK de outra tabela aponta para essa tupla excluída, tornando um registro orfão sem referenciação

RELAÇÃO(FK) REFERENCIA RELAÇÃO(PK)

