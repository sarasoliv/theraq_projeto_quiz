-- Passo 7 — Modelo físico
-- Equipe: Sara dos Santos de Oliveira, Rodrygo Schadeck Gomes, Yasmin Santos de Lima, Isabella de Almeida Santos
-- PostgreSQL. Por que este SGBD: A escolha do PostgreSQL justifica-se pelo domínio técnico que a equipe já possui sobre a tecnologia e pela sua utilização prática nas disciplinas da faculdade durante o semestre atual dos integrantes do projeto.
-- Contrato com Aplicativos para Web: os nomes abaixo são os acordados.
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
	id_jogador SERIAL PRIMARY KEY,
	nome_jogador VARCHAR(50) NOT NULL,
	pontuacao_jogador SMALLINT NOT NULL,
	data_jogado TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE opcao_questoes(
	id_opcao SERIAL PRIMARY KEY,
	Opcao_a	TEXT NOT NULL,
	Opcao_b TEXT NOT NULL,
	Opcao_c	TEXT NOT NULL,
	Opcao_d	TEXT NOT NULL,
	Opcao_e	TEXT NOT NULL
);

CREATE TABLE fontes (
    id SERIAL PRIMARY KEY,
    referencia TEXT NOT NULL
);

CREATE TABLE questoes (
    id SERIAL PRIMARY KEY,
    Enunciado TEXT NOT NULL,
    opcao_id INT,
    Resposta_correta CHAR(1),
    dificuldade_nivel VARCHAR(50),
    fonte_id INT,
	
    FOREIGN KEY (fonte_id) REFERENCES Fontes(id)
);

CREATE TABLE questoes_respondidas(
	id_resposta SERIAL PRIMARY KEY 	,
	usuario_id INT NOT NULL,
	questao_id INT NOT NULL,
	resposta_usuario VARCHAR(1) NOT NULL,
	acerto BOOLEAN NOT NULL, 
	data_resposta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	
	CONSTRAINT fk_usuario FOREIGN KEY(usuario_id) REFERENCES Cadastro_usuario(id_usuario) ON DELETE CASCADE,
	CONSTRAINT fk_questao FOREIGN KEY(questao_id) REFERENCES Questoes(id_questao) ON DELETE CASCADE
);

COMMIT;
