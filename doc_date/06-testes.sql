-- Passo 9 — Testes das regras de negócio
-- Rode depois da carga. Cada bloco deve falhar.
-- Colem a mensagem de erro do PostgreSQL no comentário Resultado.
-- Troquem os nomes pelos do dicionário.

-- Regra: Não entra pergunta sem categoria (nível de dificuldade) preenchida.
-- Resultado:
-- ERROR: null value in column "dificuldade_nivel" of relation "questoes" violates not-null constraint
-- DETAIL: Failing row contains (fact-999, Enunciado de teste, 1, A, null, 1).

INSERT INTO questoes (id, enunciado, opcao_id, resposta_correta, dificuldade_nivel, fonte_id)
VALUES ('fact-999', 'Enunciado de teste', 1, 'A', NULL, 1);


-- Regra: Não existem duas fontes com a mesma URL.
-- Resultado:
-- ERROR: duplicate key value violates unique constraint "fonte_url_key"
-- DETAIL: Key (url)=(https://sitem.herts.ac.uk/aer/papers/therac25.pdf) already exists.

INSERT INTO fonte (referencia, url)
VALUES ('Fonte Duplicada Teste', 'https://sitem.herts.ac.uk/aer/papers/therac25.pdf');


-- Regra: Pergunta sem enunciado não entra.
-- Resultado:
-- ERROR: null value in column "enunciado" of relation "questoes" violates not-null constraint
-- DETAIL: Failing row contains (fact-998, null, 1, A, facil, 1).

INSERT INTO questoes (id, enunciado, opcao_id, resposta_correta, dificuldade_nivel, fonte_id)
VALUES ('fact-998', NULL, 1, 'A', 'facil', 1);
