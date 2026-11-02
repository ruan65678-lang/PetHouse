-- PetHouse - conversao de PostgreSQL para MySQL
-- Importar este arquivo pelo phpMyAdmin em um banco MySQL/MariaDB.
-- Conteudo: estrutura, dados, chaves, indices e restricoes.
-- Recomendado: MySQL 8.0.16+ ou MariaDB com suporte a CHECK.

CREATE DATABASE IF NOT EXISTS `pethouse`
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `pethouse`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE `cliente` (
  `id_cliente` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(120) NOT NULL,
  `telefone` VARCHAR(20) DEFAULT NULL,
  `email` VARCHAR(150) DEFAULT NULL,
  `endereco` VARCHAR(255) DEFAULT NULL,
  `data_cadastro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cliente`),
  UNIQUE KEY `cliente_email_key` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `categoria` (
  `id_categoria` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `descricao` TEXT DEFAULT NULL,
  PRIMARY KEY (`id_categoria`),
  UNIQUE KEY `categoria_nome_key` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `fornecedor` (
  `id_fornecedor` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(150) NOT NULL,
  `cnpj` VARCHAR(18) NOT NULL,
  `telefone` VARCHAR(20) DEFAULT NULL,
  `email` VARCHAR(150) DEFAULT NULL,
  `endereco` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`id_fornecedor`),
  UNIQUE KEY `fornecedor_cnpj_key` (`cnpj`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `pet` (
  `id_pet` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `tipo` VARCHAR(50) NOT NULL,
  `raca` VARCHAR(100) DEFAULT NULL,
  `idade` SMALLINT DEFAULT NULL,
  `cliente_id` INT NOT NULL,
  PRIMARY KEY (`id_pet`),
  CONSTRAINT `pet_idade_check` CHECK (`idade` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `produto` (
  `id_produto` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(150) NOT NULL,
  `descricao` TEXT DEFAULT NULL,
  `preco` DECIMAL(10,2) NOT NULL,
  `categoria_id` INT NOT NULL,
  PRIMARY KEY (`id_produto`),
  CONSTRAINT `produto_preco_check` CHECK (`preco` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `pedido` (
  `id_pedido` INT NOT NULL AUTO_INCREMENT,
  `data` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` VARCHAR(30) NOT NULL DEFAULT 'pendente',
  `total` DECIMAL(10,2) NOT NULL DEFAULT 0,
  `cliente_id` INT NOT NULL,
  PRIMARY KEY (`id_pedido`),
  CONSTRAINT `pedido_status_check` CHECK (`status` IN ('pendente','pago','enviado','entregue','cancelado')),
  CONSTRAINT `pedido_total_check` CHECK (`total` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `funcionario` (
  `id_funcionario` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(120) NOT NULL,
  `telefone` VARCHAR(20) DEFAULT NULL,
  `cargo` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`id_funcionario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `servico` (
  `id_servico` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `descricao` VARCHAR(255) DEFAULT NULL,
  `preco` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id_servico`),
  UNIQUE KEY `servico_nome_key` (`nome`),
  CONSTRAINT `servico_preco_check` CHECK (`preco` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `agendamento` (
  `id_agendamento` INT NOT NULL AUTO_INCREMENT,
  `data` DATE NOT NULL,
  `horario` TIME NOT NULL,
  `tipo_procedimento` VARCHAR(100) NOT NULL,
  `status` VARCHAR(30) NOT NULL DEFAULT 'agendado',
  `pet_id` INT NOT NULL,
  `servico_id` INT NOT NULL,
  `funcionario_id` INT NOT NULL,
  PRIMARY KEY (`id_agendamento`),
  CONSTRAINT `agendamento_status_check` CHECK (`status` IN ('agendado','confirmado','concluido','cancelado'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `estoque` (
  `id_estoque` INT NOT NULL AUTO_INCREMENT,
  `quantidade` INT NOT NULL DEFAULT 0,
  `estoque_minimo` INT NOT NULL DEFAULT 0,
  `produto_id` INT NOT NULL,
  PRIMARY KEY (`id_estoque`),
  UNIQUE KEY `estoque_produto_id_key` (`produto_id`),
  CONSTRAINT `estoque_estoque_minimo_check` CHECK (`estoque_minimo` >= 0),
  CONSTRAINT `estoque_quantidade_check` CHECK (`quantidade` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `feedback` (
  `id_feedback` INT NOT NULL AUTO_INCREMENT,
  `nota` SMALLINT NOT NULL,
  `comentario` TEXT DEFAULT NULL,
  `pedido_id` INT NOT NULL,
  PRIMARY KEY (`id_feedback`),
  CONSTRAINT `feedback_nota_check` CHECK (`nota` BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `fornecedor_produto` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `fornecedor_id` INT NOT NULL,
  `produto_id` INT NOT NULL,
  `preco_compra` DECIMAL(10,2) NOT NULL,
  `data_fornecimento` DATE NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fornecedor_produto` (`fornecedor_id`,`produto_id`),
  KEY `idx_fp_produto` (`produto_id`),
  CONSTRAINT `fornecedor_produto_preco_compra_check` CHECK (`preco_compra` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `item_pedido` (
  `id_item` INT NOT NULL AUTO_INCREMENT,
  `quantidade` INT NOT NULL,
  `preco_unitario` DECIMAL(10,2) NOT NULL,
  `pedido_id` INT NOT NULL,
  `produto_id` INT NOT NULL,
  PRIMARY KEY (`id_item`),
  KEY `idx_item_pedido_pedido` (`pedido_id`),
  UNIQUE KEY `uq_item_pedido_produto` (`pedido_id`,`produto_id`),
  KEY `idx_item_pedido_produto` (`produto_id`),
  CONSTRAINT `item_pedido_preco_unitario_check` CHECK (`preco_unitario` >= 0),
  CONSTRAINT `item_pedido_quantidade_check` CHECK (`quantidade` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `orcamento` (
  `id_orcamento` INT NOT NULL AUTO_INCREMENT,
  `data` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` VARCHAR(30) NOT NULL DEFAULT 'aberto',
  `total` DECIMAL(10,2) NOT NULL DEFAULT 0,
  `cliente_id` INT NOT NULL,
  `pedido_id` INT DEFAULT NULL,
  PRIMARY KEY (`id_orcamento`),
  KEY `idx_orcamento_cliente` (`cliente_id`),
  UNIQUE KEY `uq_orcamento_pedido` (`pedido_id`),
  CONSTRAINT `orcamento_status_check` CHECK (`status` IN ('aberto','aprovado','recusado','expirado')),
  CONSTRAINT `orcamento_total_check` CHECK (`total` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `conta_receber` (
  `id_conta_receber` INT NOT NULL AUTO_INCREMENT,
  `pedido_id` INT NOT NULL,
  `data_vencimento` DATE NOT NULL,
  `valor` DECIMAL(10,2) NOT NULL,
  `status` VARCHAR(20) NOT NULL,
  `data_recebimento` DATE DEFAULT NULL,
  PRIMARY KEY (`id_conta_receber`),
  CONSTRAINT `fk_conta_receber_pedido` FOREIGN KEY (`pedido_id`) REFERENCES `pedido` (`id_pedido`),
  CONSTRAINT `conta_receber_valor_check` CHECK (`valor` >= 0),
  CONSTRAINT `conta_receber_status_check` CHECK (`status` IN ('pendente','recebido','atrasado'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `conta_pagar` (
  `id_conta_pagar` INT NOT NULL AUTO_INCREMENT,
  `fornecedor_id` INT DEFAULT NULL,
  `descricao` VARCHAR(150) NOT NULL,
  `data_vencimento` DATE NOT NULL,
  `valor` DECIMAL(10,2) NOT NULL,
  `status` VARCHAR(20) NOT NULL,
  `data_pagamento` DATE DEFAULT NULL,
  PRIMARY KEY (`id_conta_pagar`),
  CONSTRAINT `fk_conta_pagar_fornecedor` FOREIGN KEY (`fornecedor_id`) REFERENCES `fornecedor` (`id_fornecedor`),
  CONSTRAINT `conta_pagar_valor_check` CHECK (`valor` >= 0),
  CONSTRAINT `conta_pagar_status_check` CHECK (`status` IN ('pendente','pago','atrasado'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `movimento_caixa` (
  `id_movimento` INT NOT NULL AUTO_INCREMENT,
  `tipo_movimento` VARCHAR(10) NOT NULL,
  `data_movimento` DATE NOT NULL,
  `descricao` VARCHAR(150) NOT NULL,
  `valor` DECIMAL(10,2) NOT NULL,
  `conta_receber_id` INT DEFAULT NULL,
  `conta_pagar_id` INT DEFAULT NULL,
  `status_conciliacao` VARCHAR(20) NOT NULL DEFAULT 'pendente',
  PRIMARY KEY (`id_movimento`),
  CONSTRAINT `fk_movimento_receber` FOREIGN KEY (`conta_receber_id`) REFERENCES `conta_receber` (`id_conta_receber`),
  CONSTRAINT `fk_movimento_pagar` FOREIGN KEY (`conta_pagar_id`) REFERENCES `conta_pagar` (`id_conta_pagar`),
  CONSTRAINT `movimento_valor_check` CHECK (`valor` >= 0),
  CONSTRAINT `movimento_tipo_check` CHECK (`tipo_movimento` IN ('entrada','saida')),
  CONSTRAINT `movimento_conciliacao_check` CHECK (`status_conciliacao` IN ('pendente','conciliado'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Dados originais exportados do PostgreSQL.


INSERT INTO `cliente` (`id_cliente`, `nome`, `telefone`, `email`, `endereco`, `data_cadastro`) VALUES
  ('1', 'Ana Beatriz Souza', '(11) 98765-4321', 'ana.souza@email.com', 'Rua das Acacias, 120 - Vila Mariana, Sao Paulo/SP', '2026-01-15 10:30:00'),
  ('2', 'Carlos Eduardo Lima', '(11) 97654-3210', 'carlos.lima@email.com', 'Av. Paulista, 1578 - Bela Vista, Sao Paulo/SP', '2026-02-03 14:10:00'),
  ('3', 'Fernanda Oliveira', '(11) 96543-2109', 'fernanda.oliveira@email.com', 'Rua Augusta, 900 - Consolacao, Sao Paulo/SP', '2026-02-20 09:45:00'),
  ('4', 'Ricardo Mendes', '(11) 95432-1098', 'ricardo.mendes@email.com', 'Rua Oscar Freire, 455 - Pinheiros, Sao Paulo/SP', '2026-03-11 16:00:00'),
  ('5', 'Juliana Castro', '(11) 94321-0987', 'juliana.castro@email.com', 'Rua Vergueiro, 2300 - Liberdade, Sao Paulo/SP', '2026-04-07 11:20:00'),
  ('6', 'Marcos Vinicius Rocha', '(11) 93210-9876', 'marcos.rocha@email.com', 'Rua Domingos de Morais, 640 - Vila Mariana, Sao Paulo/SP', '2026-05-18 13:35:00'),
  ('7', 'Patricia Almeida', '(11) 92109-8765', 'patricia.almeida@email.com', 'Av. Brigadeiro Faria Lima, 3000 - Itaim Bibi, Sao Paulo/SP', '2026-06-25 15:50:00'),
  ('8', 'Lucas Ferreira', '(11) 91098-7654', 'lucas.ferreira@email.com', 'Rua Teodoro Sampaio, 780 - Pinheiros, Sao Paulo/SP', '2026-08-02 08:15:00');


INSERT INTO `categoria` (`id_categoria`, `nome`, `descricao`) VALUES
  ('1', 'Alimentacao', 'Racoes, saches e petiscos para caes e gatos'),
  ('2', 'Higiene e Beleza', 'Shampoos, condicionadores e escovas'),
  ('3', 'Brinquedos', 'Brinquedos e arranhadores para diversao e enriquecimento'),
  ('4', 'Acessorios', 'Coleiras, peitorais, camas e guias'),
  ('5', 'Saude e Bem-estar', 'Vermifugos, antipulgas e suplementos');


INSERT INTO `fornecedor` (`id_fornecedor`, `nome`, `cnpj`, `telefone`, `email`, `endereco`) VALUES
  ('1', 'NutriPet Alimentos Ltda', '12.345.678/0001-90', '(11) 3456-7890', 'contato@nutripet.com.br', 'Av. das Industrias, 1500 - Sao Paulo/SP'),
  ('2', 'BelaPet Cosmeticos', '23.456.789/0001-01', '(11) 3567-8901', 'vendas@belapet.com.br', 'Rua das Flores, 220 - Guarulhos/SP'),
  ('3', 'Diverte Pet Acessorios', '34.567.890/0001-12', '(19) 3678-9012', 'comercial@divertepet.com', 'Rod. Anhanguera km 98 - Campinas/SP'),
  ('4', 'VetSaude Distribuidora', '45.678.901/0001-23', '(11) 3789-0123', 'pedidos@vetsaude.com.br', 'Rua Dr. Almeida, 85 - Sao Paulo/SP');


INSERT INTO `pet` (`id_pet`, `nome`, `tipo`, `raca`, `idade`, `cliente_id`) VALUES
  ('1', 'Thor', 'Cao', 'Golden Retriever', '4', '1'),
  ('2', 'Mel', 'Gato', 'Siames', '2', '1'),
  ('3', 'Bobby', 'Cao', 'Poodle', '7', '2'),
  ('4', 'Luna', 'Gato', 'Persa', '3', '3'),
  ('5', 'Rex', 'Cao', 'Pastor Alemao', '5', '4'),
  ('6', 'Nina', 'Cao', 'Shih Tzu', '2', '5'),
  ('7', 'Pipoca', 'Coelho', 'Mini Lop', '1', '5'),
  ('8', 'Zeca', 'Cao', 'Vira-lata', '9', '6'),
  ('9', 'Mimi', 'Gato', 'SRD', '6', '7'),
  ('10', 'Bidu', 'Cao', 'Beagle', '3', '7'),
  ('11', 'Kiwi', 'Ave', 'Calopsita', '2', '8'),
  ('12', 'Fred', 'Cao', 'Bulldog Frances', '4', '8');


INSERT INTO `produto` (`id_produto`, `nome`, `descricao`, `preco`, `categoria_id`) VALUES
  ('1', 'Racao Premium Caes Adultos 15kg', 'Racao super premium sabor frango e arroz para caes adultos', '189.90', '1'),
  ('2', 'Racao Premium Gatos Castrados 10kg', 'Racao com controle de peso para gatos castrados', '159.90', '1'),
  ('3', 'Petisco Bifinho Carne 500g', 'Petisco macio sabor carne para caes', '24.90', '1'),
  ('4', 'Sache Gatos Filhotes 85g', 'Alimento umido para gatos filhotes', '4.50', '1'),
  ('5', 'Shampoo Neutro 500ml', 'Shampoo hipoalergenico para caes e gatos', '32.00', '2'),
  ('6', 'Condicionador Pelos Longos 500ml', 'Facilita o desembaraco e deixa o pelo macio', '35.50', '2'),
  ('7', 'Escova Removedora de Pelos', 'Escova com cerdas macias para remocao de pelos soltos', '29.90', '2'),
  ('8', 'Bola de Borracha Macica', 'Brinquedo resistente para caes de medio porte', '18.90', '3'),
  ('9', 'Arranhador Torre para Gatos', 'Torre com 3 andares e esconderijo', '119.00', '3'),
  ('10', 'Corda Mordedor', 'Corda de algodao trancado para brincar e limpar os dentes', '15.50', '3'),
  ('11', 'Coleira Ajustavel M', 'Coleira de nylon com fecho de seguranca, tamanho M', '39.90', '4'),
  ('12', 'Cama Pet Media', 'Cama acolchoada lavavel para caes e gatos de porte medio', '89.90', '4'),
  ('13', 'Peitoral com Guia', 'Peitoral acolchoado com guia de 1,2m', '54.90', '4'),
  ('14', 'Vermifugo Caes 4 comprimidos', 'Vermifugo de amplo espectro para caes', '49.90', '5'),
  ('15', 'Antipulgas Gatos Pipeta', 'Pipeta antipulgas e carrapatos para gatos', '69.90', '5');


INSERT INTO `pedido` (`id_pedido`, `data`, `status`, `total`, `cliente_id`) VALUES
  ('1', '2026-10-02 10:15:00', 'entregue', '239.70', '1'),
  ('2', '2026-10-05 15:40:00', 'entregue', '186.90', '2'),
  ('3', '2026-10-10 11:05:00', 'pago', '97.40', '3'),
  ('4', '2026-10-14 17:30:00', 'enviado', '150.00', '4'),
  ('5', '2026-10-16 09:20:00', 'entregue', '94.80', '5'),
  ('6', '2026-10-22 13:55:00', 'pendente', '189.70', '6'),
  ('7', '2026-10-24 16:10:00', 'entregue', '146.60', '1'),
  ('8', '2026-10-25 12:00:00', 'cancelado', '189.90', '7');


INSERT INTO `funcionario` (`id_funcionario`, `nome`, `telefone`, `cargo`) VALUES
  (1, 'Mariana Alves', '(11) 98888-1001', 'Banho e tosa'),
  (2, 'Paulo Mendes', '(11) 98888-1002', 'Atendimento'),
  (3, 'Camila Rocha', '(11) 98888-1003', 'Atendimento');

INSERT INTO `servico` (`id_servico`, `nome`, `descricao`, `preco`) VALUES
  (1, 'Banho', 'Banho para animais', 50.00),
  (2, 'Tosa higienica', 'Tosa higienica', 40.00),
  (3, 'Consulta veterinaria', 'Consulta de rotina', 100.00),
  (4, 'Banho e tosa', 'Banho completo com tosa', 85.00),
  (5, 'Vacinacao', 'Aplicacao de vacina', 75.00),
  (6, 'Corte de unhas', 'Corte de unhas', 20.00),
  (7, 'Check-up geral', 'Avaliacao geral', 120.00);

INSERT INTO `agendamento` (`id_agendamento`, `data`, `horario`, `tipo_procedimento`, `status`, `pet_id`, `servico_id`, `funcionario_id`) VALUES
  ('1', '2026-10-20', '09:00:00', 'Banho', 'concluido', '1', 1, 1),
  ('2', '2026-10-21', '10:30:00', 'Tosa higienica', 'concluido', '3', 2, 2),
  ('3', '2026-10-22', '14:00:00', 'Consulta veterinaria', 'concluido', '4', 3, 3),
  ('4', '2026-10-23', '11:00:00', 'Banho e tosa', 'cancelado', '5', 4, 1),
  ('5', '2026-10-27', '09:30:00', 'Banho', 'confirmado', '6', 1, 1),
  ('6', '2026-10-27', '15:00:00', 'Vacinacao', 'confirmado', '2', 5, 2),
  ('7', '2026-10-28', '10:00:00', 'Banho e tosa', 'agendado', '10', 4, 1),
  ('8', '2026-10-29', '13:30:00', 'Consulta veterinaria', 'agendado', '9', 3, 2),
  ('9', '2026-10-30', '16:00:00', 'Corte de unhas', 'agendado', '7', 6, 1),
  ('10', '2026-11-03', '09:00:00', 'Banho', 'agendado', '12', 1, 1),
  ('11', '2026-11-05', '11:30:00', 'Tosa higienica', 'agendado', '8', 2, 1),
  ('12', '2026-11-10', '14:30:00', 'Check-up geral', 'agendado', '11', 7, 2);


INSERT INTO `estoque` (`id_estoque`, `quantidade`, `estoque_minimo`, `produto_id`) VALUES
  ('1', '25', '10', '1'),
  ('2', '18', '8', '2'),
  ('3', '60', '20', '3'),
  ('4', '150', '50', '4'),
  ('5', '40', '15', '5'),
  ('6', '35', '15', '6'),
  ('7', '22', '10', '7'),
  ('8', '45', '15', '8'),
  ('9', '8', '5', '9'),
  ('10', '70', '25', '10'),
  ('11', '30', '12', '11'),
  ('12', '12', '6', '12'),
  ('13', '20', '8', '13'),
  ('14', '28', '10', '14'),
  ('15', '4', '10', '15');


INSERT INTO `feedback` (`id_feedback`, `nota`, `comentario`, `pedido_id`) VALUES
  ('1', '5', 'Entrega rapida e produtos de otima qualidade. Meu Thor adorou a racao!', '1'),
  ('2', '4', 'Gostei muito, so demorou um pouco para chegar.', '2'),
  ('3', '5', 'Atendimento excelente e a coleira e muito confortavel.', '5'),
  ('4', '4', 'A cama e otima, as bolinhas poderiam ser um pouco maiores.', '7'),
  ('5', '3', 'Produtos bons, mas o pedido veio sem a nota fiscal.', '3');


INSERT INTO `fornecedor_produto` (`id`, `fornecedor_id`, `produto_id`, `preco_compra`, `data_fornecimento`) VALUES
  ('1', '1', '1', '135.00', '2026-09-10'),
  ('2', '1', '2', '112.00', '2026-09-10'),
  ('3', '1', '3', '14.50', '2026-09-10'),
  ('4', '1', '4', '2.80', '2026-09-10'),
  ('5', '2', '5', '19.00', '2026-09-15'),
  ('6', '2', '6', '21.50', '2026-09-15'),
  ('7', '2', '7', '16.00', '2026-09-15'),
  ('8', '3', '7', '17.50', '2026-09-20'),
  ('9', '3', '8', '9.50', '2026-09-20'),
  ('10', '3', '9', '75.00', '2026-09-20'),
  ('11', '3', '10', '8.00', '2026-09-20'),
  ('12', '3', '11', '22.00', '2026-09-22'),
  ('13', '3', '12', '55.00', '2026-09-22'),
  ('14', '3', '13', '32.00', '2026-09-22'),
  ('15', '4', '14', '31.00', '2026-10-01'),
  ('16', '4', '15', '45.00', '2026-10-01');


INSERT INTO `item_pedido` (`id_item`, `quantidade`, `preco_unitario`, `pedido_id`, `produto_id`) VALUES
  ('1', '1', '189.90', '1', '1'),
  ('2', '2', '24.90', '1', '3'),
  ('3', '1', '159.90', '2', '2'),
  ('4', '6', '4.50', '2', '4'),
  ('5', '1', '32.00', '3', '5'),
  ('6', '1', '35.50', '3', '6'),
  ('7', '1', '29.90', '3', '7'),
  ('8', '1', '119.00', '4', '9'),
  ('9', '2', '15.50', '4', '10'),
  ('10', '1', '39.90', '5', '11'),
  ('11', '1', '54.90', '5', '13'),
  ('12', '1', '49.90', '6', '14'),
  ('13', '2', '69.90', '6', '15'),
  ('14', '1', '89.90', '7', '12'),
  ('15', '3', '18.90', '7', '8'),
  ('16', '1', '189.90', '8', '1');


INSERT INTO `orcamento` (`id_orcamento`, `data`, `status`, `total`, `cliente_id`, `pedido_id`) VALUES
  ('1', '2026-10-01 18:00:00', 'aprovado', '239.70', '1', '1'),
  ('2', '2026-10-09 10:30:00', 'aprovado', '97.40', '3', '3'),
  ('3', '2026-10-15 14:20:00', 'aprovado', '94.80', '5', '5'),
  ('4', '2026-10-20 09:10:00', 'aberto', '320.00', '8', NULL),
  ('5', '2026-10-21 16:45:00', 'recusado', '85.00', '2', NULL);


INSERT INTO `conta_receber` (`pedido_id`, `data_vencimento`, `valor`, `status`, `data_recebimento`) VALUES
  (1, '2026-10-02', 239.70, 'recebido', '2026-10-02'),
  (2, '2026-10-05', 186.90, 'recebido', '2026-10-05'),
  (6, '2026-10-29', 189.70, 'pendente', NULL);

INSERT INTO `conta_pagar` (`fornecedor_id`, `descricao`, `data_vencimento`, `valor`, `status`, `data_pagamento`) VALUES
  (1, 'Compra de racoes e petiscos', '2026-10-10', 500.00, 'pago', '2026-10-10'),
  (2, 'Compra de produtos de higiene', '2026-11-10', 250.00, 'pendente', NULL);

INSERT INTO `movimento_caixa` (`tipo_movimento`, `data_movimento`, `descricao`, `valor`, `conta_receber_id`, `conta_pagar_id`, `status_conciliacao`) VALUES
  ('entrada', '2026-10-02', 'Recebimento do pedido 1', 239.70, 1, NULL, 'conciliado'),
  ('entrada', '2026-10-05', 'Recebimento do pedido 2', 186.90, 2, NULL, 'conciliado'),
  ('saida', '2026-10-10', 'Pagamento ao fornecedor 1', 500.00, NULL, 1, 'conciliado');


-- Relacionamentos (chaves estrangeiras).
ALTER TABLE `pet`
  ADD CONSTRAINT `fk_pet_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `cliente` (`id_cliente`) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE `produto`
  ADD CONSTRAINT `fk_produto_categoria` FOREIGN KEY (`categoria_id`) REFERENCES `categoria` (`id_categoria`) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE `pedido`
  ADD CONSTRAINT `fk_pedido_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `cliente` (`id_cliente`) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE `agendamento`
  ADD CONSTRAINT `fk_agendamento_pet` FOREIGN KEY (`pet_id`) REFERENCES `pet` (`id_pet`) ON UPDATE CASCADE ON DELETE CASCADE,
  ADD CONSTRAINT `fk_agendamento_servico` FOREIGN KEY (`servico_id`) REFERENCES `servico` (`id_servico`),
  ADD CONSTRAINT `fk_agendamento_funcionario` FOREIGN KEY (`funcionario_id`) REFERENCES `funcionario` (`id_funcionario`);

ALTER TABLE `estoque`
  ADD CONSTRAINT `fk_estoque_produto` FOREIGN KEY (`produto_id`) REFERENCES `produto` (`id_produto`) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE `feedback`
  ADD CONSTRAINT `fk_feedback_pedido` FOREIGN KEY (`pedido_id`) REFERENCES `pedido` (`id_pedido`) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE `fornecedor_produto`
  ADD CONSTRAINT `fk_fp_fornecedor` FOREIGN KEY (`fornecedor_id`) REFERENCES `fornecedor` (`id_fornecedor`) ON UPDATE CASCADE ON DELETE CASCADE,
  ADD CONSTRAINT `fk_fp_produto` FOREIGN KEY (`produto_id`) REFERENCES `produto` (`id_produto`) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE `item_pedido`
  ADD CONSTRAINT `fk_item_pedido` FOREIGN KEY (`pedido_id`) REFERENCES `pedido` (`id_pedido`) ON UPDATE CASCADE ON DELETE CASCADE,
  ADD CONSTRAINT `fk_item_produto` FOREIGN KEY (`produto_id`) REFERENCES `produto` (`id_produto`) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE `orcamento`
  ADD CONSTRAINT `fk_orcamento_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `cliente` (`id_cliente`) ON UPDATE CASCADE ON DELETE CASCADE,
  ADD CONSTRAINT `fk_orcamento_pedido` FOREIGN KEY (`pedido_id`) REFERENCES `pedido` (`id_pedido`) ON UPDATE CASCADE ON DELETE SET NULL;

SET FOREIGN_KEY_CHECKS = 1;


-- Consultas simples de apoio à gestão
SELECT * FROM `conta_pagar` ORDER BY `data_vencimento`;
SELECT * FROM `conta_receber` ORDER BY `data_vencimento`;
SELECT `tipo_movimento`, SUM(`valor`) AS `total`
FROM `movimento_caixa` GROUP BY `tipo_movimento`;
SELECT * FROM `movimento_caixa` WHERE `status_conciliacao` = 'pendente';

SELECT a.`data`, a.`horario`, p.`nome` AS `pet`,
       s.`nome` AS `servico`, f.`nome` AS `funcionario`
FROM `agendamento` a
JOIN `pet` p ON p.`id_pet` = a.`pet_id`
JOIN `servico` s ON s.`id_servico` = a.`servico_id`
JOIN `funcionario` f ON f.`id_funcionario` = a.`funcionario_id`;

SELECT fb.`id_feedback`, fb.`nota`, fb.`comentario`, c.`nome` AS `cliente`
FROM `feedback` fb
JOIN `pedido` ped ON ped.`id_pedido` = fb.`pedido_id`
JOIN `cliente` c ON c.`id_cliente` = ped.`cliente_id`;


-- Consultas de leitura, atualizacao, exclusao, gerenciais e auditoria
-- Q01: Agenda do dia (todos os agendamentos de hoje)
SELECT a.data, a.horario, a.tipo_procedimento, a.status,
p.nome AS pet, c.nome AS tutor, c.telefone
FROM agendamento a
JOIN pet p ON p.id_pet = a.pet_id
JOIN cliente c ON c.id_cliente = p.cliente_id
WHERE a.data = CURRENT_DATE
ORDER BY a.horario;
-- Q02: Histórico de pedidos de um cliente
SELECT ped.id_pedido, ped.data, ped.status, ped.total
FROM pedido ped
JOIN cliente c ON c.id_cliente = ped.cliente_id
WHERE c.email = 'ana.souza@email.com'
ORDER BY ped.data DESC;
-- Q03: Itens de um pedido com nome do produto
SELECT ip.id_item, pr.nome AS produto, ip.quantidade,
ip.preco_unitario,
(ip.quantidade * ip.preco_unitario) AS subtotal
FROM item_pedido ip
JOIN produto pr ON pr.id_produto = ip.produto_id
WHERE ip.pedido_id = 1;
-- Q04: Estoque abaixo do mínimo (alerta de reposição - RF13)
SELECT pr.nome, e.quantidade, e.estoque_minimo,
(e.estoque_minimo - e.quantidade) AS falta
FROM estoque e
JOIN produto pr ON pr.id_produto = e.produto_id
WHERE e.quantidade < e.estoque_minimo
ORDER BY falta DESC;
-- Q05: Menor preço de compra por produto (comparativo de fornecedores)
SELECT pr.nome AS produto,
f.nome  AS fornecedor_mais_barato,
fp.preco_compra AS menor_preco
FROM fornecedor_produto fp
JOIN produto    pr ON pr.id_produto    = fp.produto_id
JOIN fornecedor f  ON f.id_fornecedor = fp.fornecedor_id
WHERE fp.preco_compra = (
SELECT MIN(fp2.preco_compra)
FROM fornecedor_produto fp2
WHERE fp2.produto_id = fp.produto_id
)
ORDER BY pr.nome;
-- Q06: Feedback com dados do cliente (via JOIN - sem cliente_id em feedback)
SELECT fb.id_feedback, fb.nota, fb.comentario,
c.nome AS cliente, ped.data AS data_pedido
FROM feedback fb
JOIN pedido ped ON ped.id_pedido = fb.pedido_id
JOIN cliente c  ON c.id_cliente  = ped.cliente_id
ORDER BY fb.nota DESC;
-- U01: Atualizar status de agendamento para concluído
UPDATE agendamento SET status = 'concluido'
WHERE id_agendamento = 4;
-- U02: Ajustar estoque após venda de 2 unidades do produto 1
UPDATE estoque SET quantidade = quantidade - 2
WHERE produto_id = 1 AND quantidade >= 2;
-- U03: Alterar preço de venda de um produto
UPDATE produto SET preco = 179.90
WHERE id_produto = 1;
-- U04: Alterar a situação de um orçamento ainda aberto
UPDATE orcamento SET status = 'recusado'
WHERE id_orcamento = 4;
-- D01: Excluir feedback (quando solicitado pelo cliente - LGPD)
DELETE FROM feedback WHERE id_feedback = 5;
-- D02: Cancelar agendamento
UPDATE agendamento SET status = 'cancelado'
WHERE id_agendamento = 9;
-- Nota: não deletar agendamentos; manter histórico com status cancelado.
As consultas a seguir respondem a perguntas de negócio e verificam a integridade dos dados. Elas são essenciais para o uso operacional e gerencial do sistema.
-- G01: Vendas por período (faturamento mensal)
SELECT
DATE_FORMAT(data, '%Y-%m') AS mes,
COUNT(id_pedido) AS qtd_pedidos,
SUM(total) AS faturamento
FROM pedido
WHERE status IN ('pago','entregue')
AND data BETWEEN '2026-10-01' AND '2026-10-31'
GROUP BY DATE_FORMAT(data, '%Y-%m')
ORDER BY mes;
-- G02: Produtos mais vendidos (TOP 5 por quantidade)
SELECT pr.nome, SUM(ip.quantidade) AS total_vendido
FROM item_pedido ip
JOIN produto pr ON pr.id_produto = ip.produto_id
JOIN pedido ped ON ped.id_pedido = ip.pedido_id
WHERE ped.status IN ('pago','entregue')
GROUP BY pr.nome
ORDER BY total_vendido DESC
LIMIT 5;
-- G03: Clientes com maior gasto total (TOP 10)
SELECT c.nome, c.telefone,
COUNT(ped.id_pedido) AS pedidos,
SUM(ped.total) AS gasto_total
FROM cliente c
JOIN pedido ped ON ped.cliente_id = c.id_cliente
WHERE ped.status IN ('pago','entregue')
GROUP BY c.id_cliente, c.nome, c.telefone
ORDER BY gasto_total DESC
LIMIT 10;
-- G04: Média de avaliação por cliente (feedback está ligado ao pedido)
SELECT c.nome AS cliente, ROUND(AVG(fb.nota),2) AS media_nota,
COUNT(fb.id_feedback) AS qtd_avaliacoes
FROM feedback fb
JOIN pedido ped ON ped.id_pedido = fb.pedido_id
JOIN cliente c ON c.id_cliente = ped.cliente_id
GROUP BY c.id_cliente, c.nome
ORDER BY media_nota DESC;
-- G05: Agendamentos por tipo de procedimento no mês
SELECT tipo_procedimento,
COUNT(*) AS total,
SUM(CASE WHEN status = 'concluido' THEN 1 ELSE 0 END) AS concluidos,
SUM(CASE WHEN status = 'cancelado' THEN 1 ELSE 0 END) AS cancelados
FROM agendamento
WHERE data BETWEEN '2026-10-01' AND '2026-10-31'
GROUP BY tipo_procedimento
ORDER BY total DESC;
-- G06: Margem de lucro bruta por produto (preço venda - menor preço compra)
SELECT pr.nome,
pr.preco AS preco_venda,
MIN(fp.preco_compra) AS menor_custo,
(pr.preco - MIN(fp.preco_compra)) AS margem_bruta,
ROUND(((pr.preco - MIN(fp.preco_compra)) / pr.preco * 100),2) AS margem_pct
FROM produto pr
JOIN fornecedor_produto fp ON fp.produto_id = pr.id_produto
GROUP BY pr.id_produto, pr.nome, pr.preco
ORDER BY margem_pct DESC;
-- G07: Pets mais frequentes (mais agendamentos)
SELECT p.nome AS pet, p.tipo, c.nome AS tutor,
COUNT(a.id_agendamento) AS total_agendamentos
FROM pet p
JOIN agendamento a ON a.pet_id = p.id_pet
JOIN cliente c ON c.id_cliente = p.cliente_id
GROUP BY p.id_pet, p.nome, p.tipo, c.nome
ORDER BY total_agendamentos DESC
LIMIT 10;
-- G08: Orçamentos abertos há mais de 7 dias (pendentes de resposta)
SELECT o.id_orcamento, c.nome AS cliente, c.telefone,
o.data, o.total,
DATEDIFF(CURRENT_DATE, DATE(o.data)) AS dias_aberto
FROM orcamento o
JOIN cliente c ON c.id_cliente = o.cliente_id
WHERE o.status = 'aberto'
AND o.data < NOW() - INTERVAL 7 DAY
ORDER BY dias_aberto DESC;
-- G09: Pedidos pendentes (a receber)
SELECT ped.id_pedido, c.nome, c.telefone,
ped.data, ped.total
FROM pedido ped
JOIN cliente c ON c.id_cliente = ped.cliente_id
WHERE ped.status = 'pendente'
ORDER BY ped.data;
-- G10: Resumo de estoque por categoria
SELECT cat.nome AS categoria,
COUNT(pr.id_produto) AS qtd_produtos,
SUM(e.quantidade) AS estoque_total,
SUM(CASE WHEN e.quantidade < e.estoque_minimo THEN 1 ELSE 0 END) AS produtos_baixo_estoque
FROM categoria cat
JOIN produto pr ON pr.categoria_id = cat.id_categoria
JOIN estoque e  ON e.produto_id = pr.id_produto
GROUP BY cat.nome
ORDER BY produtos_baixo_estoque DESC;
-- A01: Total do pedido diverge da soma dos itens (anomalia de integridade)
SELECT ped.id_pedido, ped.total AS total_gravado,
COALESCE(SUM(ip.quantidade * ip.preco_unitario),0) AS total_calculado,
ABS(ped.total - COALESCE(SUM(ip.quantidade * ip.preco_unitario),0)) AS diferenca
FROM pedido ped
LEFT JOIN item_pedido ip ON ip.pedido_id = ped.id_pedido
GROUP BY ped.id_pedido, ped.total
HAVING ABS(ped.total - COALESCE(SUM(ip.quantidade * ip.preco_unitario),0)) > 0.01;
-- A02: Orçamentos aprovados sem pedido vinculado (inconsistência de fluxo)
SELECT o.id_orcamento, c.nome AS cliente, o.data, o.total
FROM orcamento o
JOIN cliente c ON c.id_cliente = o.cliente_id
WHERE o.status = 'aprovado'
AND o.pedido_id IS NULL;
-- A03: Pedidos sem nenhum item (pedido vazio - viola RN05)
SELECT ped.id_pedido, c.nome AS cliente, ped.data, ped.total
FROM pedido ped
JOIN cliente c ON c.id_cliente = ped.cliente_id
LEFT JOIN item_pedido ip ON ip.pedido_id = ped.id_pedido
WHERE ip.id_item IS NULL
AND ped.status != 'cancelado';
-- A04: Produtos abaixo do estoque minimo e fornecedores cadastrados
-- Para saber o fornecedor ideal, use FORNECEDOR_PRODUTO.
-- Esta consulta lista produtos com estoque abaixo do mínimo
-- e seus fornecedores cadastrados:
SELECT e.produto_id, pr.nome, e.quantidade, e.estoque_minimo,
f.nome AS fornecedor_sugerido, fp.preco_compra
FROM estoque e
JOIN produto pr ON pr.id_produto = e.produto_id
JOIN fornecedor_produto fp ON fp.produto_id = e.produto_id
JOIN fornecedor f ON f.id_fornecedor = fp.fornecedor_id
WHERE e.quantidade < e.estoque_minimo
ORDER BY pr.nome, fp.preco_compra;
-- A05: Clientes duplicados por telefone (possível duplicidade de cadastro)
SELECT telefone, COUNT(*) AS ocorrencias,
GROUP_CONCAT(nome SEPARATOR ' / ') AS nomes
FROM cliente
GROUP BY telefone
HAVING COUNT(*) > 1
ORDER BY ocorrencias DESC;