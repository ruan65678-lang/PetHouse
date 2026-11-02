# Pet House

Projeto de banco de dados para um pet shop de pequeno porte, desenvolvido pelo **Grupo 7** para a disciplina de Modelagem de Dados.

A Pet House é um pet shop que vende produtos (rações, acessórios, higiene) e oferece serviços agendados (banho e tosa, entre outros). Hoje o controle é feito em cadernos e planilhas. Este projeto apresenta um banco de dados para centralizar os registros.

---

## Integrantes do grupo

1. Breno de Alencar Oliveira
2. Estefany Isidro Pachacuti
3. Giovanni Ferreira dos Santos
4. Jhoselia Abigail Pilco Mollo
5. Joana Manoele Freitas da Silva
6. Julia Vilela
7. Klener Nilmar Quispe Cari
8. Luan de Oliveira
9. Raphael David Silva Freitas
10. Ruan Silva Costa

## Repositório oficial no GitHub

**Acesse o projeto:** https://github.com/ruan65678-lang/PetHouse

---

## O que tem nesta pasta

```
PetHouse/
├── MANUAL DA ENTREGA FINAL.pdf                    ← manual do professor
├── README.md                                        ← este arquivo
├── documentacao/
│   ├── Documentacao_DER_PetHouse.docx               ← explicação completa do projeto e do DER
│   ├── DER_PetHouse.png                             ← imagem do DER
│   └── DER_PetHouse.dot                             ← arquivo do diagrama
└── banco_de_dados/
    ├── pethouse_script_sql_phpMyadmin.sql            ← script principal (MySQL, importar pelo phpMyAdmin)
    ├── pethouse_script_sql_postgre.sql               ← arquivo antigo de referência (não usar nesta entrega)
    └── pethouse_backup.dump                          ← backup antigo de referência (não usar nesta entrega)
```

---

## Como rodar o banco de dados

O banco de dados foi feito no **MySQL** e pode ser importado diretamente pelo **phpMyAdmin**.

### Passo a passo

1. Abra o phpMyAdmin no seu navegador (normalmente em `http://localhost/phpmyadmin`).
2. Clique em **Importar** no menu superior.
3. Selecione o arquivo `pethouse_script_sql_phpMyadmin.sql` da pasta `banco_de_dados/`.
4. Clique em **Executar**.

O script foi preparado para criar o banco `pethouse`, as 17 tabelas, os dados fictícios e os relacionamentos. Depois da importação, confira no phpMyAdmin se a execução terminou sem erros.

> **Requisito:** MySQL 8.0.16 ou superior (para suporte a `CHECK`), ou MariaDB equivalente.

---

## O que a documentação explica

O arquivo `.docx` na pasta `documentacao/` apresenta a análise e a modelagem do projeto:

- como o pet shop funciona hoje e quais são os problemas que ele enfrenta;
- o que o sistema precisa fazer (requisitos funcionais e não funcionais);
- as regras de negócio do pet shop;
- fluxogramas dos principais processos;
- o Diagrama Entidade-Relacionamento (DER) com justificativa de cada decisão;
- o modelo lógico convertido do DER;
- a análise de normalização (1FN, 2FN e 3FN);
- o dicionário de dados com todas as tabelas e colunas;
- o script SQL completo (CREATE, INSERT, SELECT com JOIN, UPDATE, DELETE);
- consultas gerenciais e de auditoria;
- indicadores de BI e possibilidades de uso de IA.

---

## O script SQL — o que tem dentro

O arquivo `pethouse_script_sql_phpMyadmin.sql` foi gerado a partir da versão PostgreSQL e adaptado para MySQL. Ele contém:

| O que faz | Descrição |
|---|---|
| `CREATE DATABASE` | Cria o banco `pethouse` com suporte a acentos (utf8mb4) |
| `CREATE TABLE` | Cria as 17 tabelas com chaves primárias, restrições e tipos MySQL |
| `INSERT INTO` | Insere os dados de teste (clientes, pets, produtos, pedidos etc.) |
| `ALTER TABLE` | Adiciona as chaves estrangeiras e os relacionamentos entre tabelas |

---

## As tabelas do banco

| Tabela | Para que serve |
|---|---|
| `cliente` | Cadastro dos clientes do pet shop |
| `pet` | Cadastro dos animais de cada cliente |
| `agendamento` | Reservas de banho, tosa e consultas |
| `produto` | Produtos vendidos pela loja |
| `categoria` | Categorias dos produtos (ração, higiene, brinquedos...) |
| `estoque` | Quantidade atual e mínima de cada produto |
| `fornecedor` | Empresas que abastecem a loja |
| `fornecedor_produto` | Qual fornecedor vende qual produto e por qual preço |
| `pedido` | Vendas realizadas |
| `item_pedido` | Produtos de cada pedido (quantidade e preço cobrado) |
| `orcamento` | Propostas feitas antes da venda |
| `feedback` | Avaliações dos clientes sobre os pedidos |
| `funcionario` | Cadastro dos funcionários |
| `servico` | Serviços oferecidos e seus preços |
| `conta_pagar` | Despesas e pagamentos |
| `conta_receber` | Valores a receber dos pedidos |
| `movimento_caixa` | Entradas, saídas e conciliação |

---

## Diferenças entre a versão MySQL e a versão PostgreSQL

O professor pediu que o banco fosse implementado em MySQL/phpMyAdmin. A versão anterior estava em PostgreSQL. As principais adaptações feitas foram:

| PostgreSQL | MySQL (versão atual) |
|---|---|
| `SERIAL` | `INT NOT NULL AUTO_INCREMENT` |
| `NOW()` | `CURRENT_TIMESTAMP` |
| `\c pet_house` (conectar) | `USE pethouse;` |
| `TO_CHAR(data, 'YYYY-MM')` | `DATE_FORMAT(data, '%Y-%m')` |
| `STRING_AGG(...)` | `GROUP_CONCAT(...)` |
| `INTERVAL '7 days'` | `INTERVAL 7 DAY` |

Os arquivos PostgreSQL e `.dump` são versões antigas, mantidas apenas como referência. Eles não fazem parte da implementação atual. Para esta entrega, considere somente `pethouse_script_sql_phpMyadmin.sql`.

---

## Grupo 7

1. Breno de Alencar Oliveira
2. Estefany Isidro Pachacuti
3. Giovanni Ferreira dos Santos
4. Jhoselia Abigail Pilco Mollo
5. Joana Manoele Freitas da Silva
6. Julia Vilela
7. Klener Nilmar Quispe Cari
8. Luan de Oliveira
9. Raphael David Silva Freitas
10. Ruan Silva Costa
