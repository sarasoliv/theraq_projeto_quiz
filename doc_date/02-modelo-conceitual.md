# Passo 4 — Modelo conceitual

Marco M1. A entrega deste passo é o modelo conceitual: o desenho em `entregas/02-conceitual.pdf` (ou `.png`) e as tabelas abaixo.

É um DER na notação de Chen, no brModelo ou no Visual Paradigm Online. Entidades, atributos, relacionamentos e cardinalidades. Ainda não aparecem tabela, chave estrangeira nem tipo de coluna: isso é o modelo lógico, no passo 5.

Versão 1.0
***[Baixar DER em PDF] [02_conceitual_isabella_rodrygo_sara_yasmin.pdf](https://github.com/user-attachments/files/33519047/02_conceitual_isabella_rodrygo_sara_yasmin.pdf)***


## Entidades

| Entidade | Atributos | Identificador |
| --- | --- | --- |
| Cadastro_usuario | id_usuario, nome | id_usuario |
| Tabela_ranking | id_jogador, nome_jogador, pontuacao_jogador, data_jogado | id_jogador |
| Opcao_questoes | id_opcao, opcao_a, opcao_b, opcao_c, opcao_d, opcao_e | id_opcao |
| Fonte | id, referencia, url | id |
| Questoes | id, enunciado, explicacao, opcao_id, resposta_correta, dificuldade_nivel, fonte_id | id |
| Questoes_respondidas | id_resposta, usuario_id, questao_id, resposta_usuario, acerto, data_resposta | id_resposta |

## Relacionamentos

Uma frase por linha, ligada a um requisito. Cardinalidade dos dois lados, mínimo e máximo.

| Relacionamento | Cardinalidade | Justificativa | Requisito |
| --- | --- | --- | --- |
| Possui (Questões / Opções) | (1,1) , (0,N) | Cada questão possui obrigatoriamente 1 conjunto de alternativas, e um conjunto de opções pode estar associado a nenhuma ou a várias questões. | Requisitos funcionais |
| Baseia-se (Questões / Fonte) | (0,N) , (1,1) | Uma questão está associada a exatamente 1 fonte de referência, e uma fonte pode fundamentar nenhuma ou várias questões. | Requisitos funcionais |
| Responde (Usuário / Questões Respondidas) | (1,N) , (1,1) | Um usuário pode registrar uma ou várias respostas no histórico, e cada registro de resposta pertence obrigatoriamente a 1 usuário. | Regras de negócios |
| Avalia (Questões / Questões Respondidas) | (1,N) , (1,1) | Uma questão pode aparecer em zero ou várias respostas no histórico, e cada registro de resposta avalia obrigatoriamente 1 questão específica. | Regras de negócios |


O diagrama e esta tabela descrevem o mesmo modelo. Toda entidade do desenho está na tabela.
