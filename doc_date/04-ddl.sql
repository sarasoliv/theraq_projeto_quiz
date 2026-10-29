-- Passo 7 — Modelo físico
-- Equipe: Sara dos Santos de Oliveira, Rodrygo Schadeck Gomes, Yasmin Santos de Lima, Isabella de Almeida Santos
-- PostgreSQL. Por que este SGBD: A escolha do PostgreSQL justifica-se pelo domínio técnico que a equipe já possui sobre a tecnologia e pela sua utilização prática nas disciplinas da faculdade durante o semestre atual dos integrantes do projeto.
-- Contrato com Aplicativos para Web: os nomes abaixo são os acordados.
-- Tabelas e colunas oficiais:
-- - cadastro_usuario (id_usuario, nome)
-- - tabela_ranking (id_jogador, nome_jogador, pontuacao_jogador, data_jogado)
-- - opcao_questoes (id_opcao, opcao_a, opcao_b, opcao_c, opcao_d, opcao_e)
-- - fontes (id, referencia)
-- - questoes (id, enunciado, opcao_id, resposta_correta, dificuldade_nivel, fonte_id)
-- - questoes_respondidas (id_resposta, usuario_id, questao_id, resposta_usuario, acerto, data_resposta)
-- Banco vazio:
--   createdb projeto_quiz_irsy
--   psql -d projeto_quiz_IMRSY -v ON_ERROR_STOP=1 -f 04-ddl.sql
-- Só esquema e domínio fixo (idiomas, alternativas).
-- Categorias, publicadores, fontes e perguntas ficam no passo 8.

BEGIN;

-- TODO: CREATE TABLE, na ordem em que as FK permitem.
-- PK id_<tabela>. Nomes em português, minúsculos, sem acento, singular.
-- PK, FK, NOT NULL, UNIQUE e CHECK declarados aqui, como no dicionário.

-- TODO: INSERT do domínio fixo.

CREATE DATABASE projeto_quiz_irsy;

CREATE TABLE cadastro_usuario(
	id_usuario SERIAL PRIMARY KEY NOT NULL,
	nome VARCHAR(50) NOT NULL
);

CREATE TABLE tabela_ranking(
	id_ranking SERIAL PRIMARY KEY,
	pontuacao_jogador SMALLINT NOT NULL,
	data_jogado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	usuario_id INT NOT NULL,
	questoes_respondidas_id INT NOT NULL
 	
	CONSTRAINT fk_usuario FOREIGN KEY (usuario_id) REFERENCES cadastro_usuario(id_usuario) 
	CONSTRAINT fk_questoes_respondidas FOREIGN KEY (questoes_respondidas_id) REFERENCES questoes_respondidas(id_resposta) 
);

CREATE TABLE opcao_questoes(
	id_opcao SERIAL PRIMARY KEY,
	opcao_a	TEXT NOT NULL,
	opcao_b TEXT NOT NULL,
	opcao_c	TEXT NOT NULL,
	opcao_d	TEXT NOT NULL,
	opcao_e	TEXT NOT NULL
);

CREATE TABLE fonte (
    id SERIAL PRIMARY KEY,
    referencia TEXT UNIQUE NOT NULL,
	url VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE questoes (
    id VARCHAR(100) PRIMARY KEY,
    enunciado TEXT NOT NULL,
    resposta_correta CHAR(1),
    dificuldade_nivel VARCHAR(50),
    fonte_id INT,
	opcao_id INT,
	
    CONSTRAINT fk_fonte FOREIGN KEY (fonte_id) REFERENCES fonte(id) 
	CONSTRAINT fk_opcao FOREIGN KEY (opcao_id) REFERENCES opcao_questoes(id_opcao)
);

CREATE TABLE questoes_respondidas(
	id_resposta SERIAL PRIMARY KEY,
	resposta_usuario VARCHAR(1) NOT NULL,
	acerto BOOLEAN NOT NULL, 
	data_resposta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	usuario_id INT NOT NULL,
	questao_id VARCHAR(100) NOT NULL,
	
	CONSTRAINT fk_usuario FOREIGN KEY(usuario_id) REFERENCES cadastro_usuario(id_usuario) ON DELETE CASCADE,
	CONSTRAINT fk_questao FOREIGN KEY(questao_id) REFERENCES questoes(id) ON DELETE CASCADE
);


COMMIT;
