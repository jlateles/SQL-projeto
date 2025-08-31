/*Projeto insight_places/*

/*Para começar, criação do nosso database usando a ferramenta SQL WORKBENCH*/
CREATE DATABASE insight_places;

/* Criando as tabelas solicitadas pelo cliente */
USE insight_places;

CREATE TABLE proprietarios (
proprietario_id VARCHAR(255) PRIMARY KEY,
nome VARCHAR(255),
cpf_cnpj VARCHAR(20),
contato VARCHAR(255)
);

CREATE TABLE clientes (
    cliente_id VARCHAR(255) PRIMARY KEY,
    nome VARCHAR(255),
    cpf VARCHAR(14),
    contato VARCHAR(255)
);

CREATE TABLE enderecos (
    endereco_id VARCHAR(255) PRIMARY KEY,
    rua VARCHAR(255),
    numero INT,
    bairro VARCHAR(255),
    cidade VARCHAR(255),
    estado VARCHAR(2),
    cep VARCHAR(10)
);

CREATE TABLE hospedagens (
    hospedagem_id VARCHAR(255) PRIMARY KEY,
    tipo VARCHAR(50),
    endereco_id VARCHAR(255),
    proprietario_id VARCHAR(255),
        ativo bool,
    FOREIGN KEY (endereco_id) REFERENCES enderecos(endereco_id),
    FOREIGN KEY (proprietario_id) REFERENCES proprietarios(proprietario_id)
);

CREATE TABLE alugueis (
    aluguel_id VARCHAR(255) PRIMARY KEY,
    cliente_id VARCHAR(255),
    hospedagem_id VARCHAR(255),
    data_inicio DATE,
    data_fim DATE,
    preco_total DECIMAL(10, 2),
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id),
    FOREIGN KEY (hospedagem_id) REFERENCES hospedagens(hospedagem_id)
);

CREATE TABLE avaliacoes (
avaliacao_id VARCHAR(255) PRIMARY KEY,
cliente_id VARCHAR(255),
hospedagem_id VARCHAR(255),
nota INT,
comentario TEXT,
FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id),
FOREIGN KEY (hospedagem_id) REFERENCES hospedagens(hospedagem_id)
);

/*Importado os dados nas tabelas criados e depois faremos as consultas que nos foram solicitadas com os códigos a seguir*/

/*O cliente solicita a consulta de avaliações dos hotéis com mais de 4 de avaliação*/

SELECT * FROM avaliacoes
WHERE nota >= 4

/*Depois, o cliente gostaria de conhecer todos os hotéis que estão ativos (nosso banco armazena 1 para ativo e 0 para inativo)*/

SELECT * FROM hospedagens
WHERE tipo = 'hotel' AND ativo = 1;

/*Nosso cliente agora solicitou uma consulta para saber quanto os clientes gastam em média com hospedagem*/

SELECT cliente_id, AVG(preco_total) AS ticket_medio
FROM reservas
GROUP BY cliente_id;

/*Abaixo, faremos uma busca para ver quanto tempo em media de estadia os hospedes ficam nos hotéis*/

SELECT cliente_id, AVG(DATEDIFF(data_fim, data_inicio)) AS media_dias_estadia
FROM reservas
GROUP BY cliente_id
ORDER BY media_dias_estadia DESC;

/*Agora a empresa solicitou os dados para saber quem são os top 10 locadores que possuem hotéis cadastrados*/

SELECT p.nome AS nome_proprietario, COUNT(h.hospedagem_id) AS total_hospedagens_ativas
FROM proprietarios p
JOIN hospedagens h ON p.proprietario_id = h.proprietario_id
WHERE h.ativo = 1
GROUP BY p.nome
ORDER BY total_hospedagens_ativas DESC
LIMIT 10;

/*Pensando em uma limpeza no sistema foi nos solicitado os proprietários que possuem e quantos possuem hotéis e hospedagens desativadas na plataforma*/

SELECT p.nome AS nome_proprietario, COUNT(*) AS total_hospedagens_inativas
FROM proprietarios p
JOIN hospedagens h ON p.proprietario_id = h.proprietario_id
WHERE h.ativo = 0
GROUP BY p.nome
ORDER BY total_hospedagens_inativas  DESC;

/*Agora faremos uma busca para saber em qual mes do ano temos mais reservas*/

SELECT YEAR(data_inicio) AS ano,
MONTH(data_inicio) AS mes,
COUNT(*) AS total_reservas
FROM reservas
GROUP BY ano, mes
ORDER BY total_reservas DESC;

/*Agora vamos fazer alterações solicitadas pelo proprietário*/

ALTER TABLE proprietarios ADD COLUMN qtd_hospedagens INT;

ALTER TABLE alugueis RENAME TO reservas;

ALTER TABLE reservas RENAME COLUMN aluguel_id TO reserva_id;

UPDATE hospedagens
SET ativo=1
WHERE hospedagem_id IN ('1', '10', '100');

UPDATE proprietarios
SET contato = 'daniele_120@email.com'
WHERE proprietario_id = '1009';

DELETE FROM avaliacoes
WHERE hospedagem_id IN('10000', '1001');

DELETE FROM reservas
WHERE hospedagem_id IN('10000', '1001');

DELETE FROM hospedagens
WHERE hospedagem_id IN('10000', '1001');





