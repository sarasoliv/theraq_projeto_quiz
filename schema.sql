CREATE DATABASE projeto_quiz_irsy;

-- Conecte-se ao banco criado antes de rodar o restante, se necessário.

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
    opcao_id INT,
    resposta_correta CHAR(1),
    dificuldade_nivel VARCHAR(50),
    fonte_id INT,
	
    CONSTRAINT fk_fonte FOREIGN KEY (fonte_id) REFERENCES fonte(id) 
);

CREATE TABLE questoes_respondidas(
	id_resposta SERIAL PRIMARY KEY,
	usuario_id INT NOT NULL,
	questao_id VARCHAR(100) NOT NULL, -- Corrigido para VARCHAR para bater com a tabela questoes
	resposta_usuario VARCHAR(1) NOT NULL,
	acerto BOOLEAN NOT NULL, 
	data_resposta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	
	CONSTRAINT fk_usuario FOREIGN KEY(usuario_id) REFERENCES cadastro_usuario(id_usuario) ON DELETE CASCADE,
	CONSTRAINT fk_questao FOREIGN KEY(questao_id) REFERENCES questoes(id) ON DELETE CASCADE
);

select * from fonte;

INSERT INTO fonte (id, referencia, url) VALUES 
(1, 'Leveson, Nancy G., & Turner, Clark S. (1993). An Investigation of the Therac-25 Accidents. IEEE Computer', 'https://web.stanford.edu/class/cs240/old/sp2014/readings/therac-25.pdf'),
(2, 'Leveson, Nancy G. (1995). Safeware: System Safety and Computers', 'https://mitpress.mit.edu/9780201631210/safeware/'),
(3, 'U.S. Food and Drug Administration (FDA) / CDRH (1986–1987) - Documentos de Recall e CAP', 'https://www.fda.gov/medical-devices/medical-device-recalls'),
(4, 'Baase, Sara. (2008). A Gift of Fire / Códigos de Ética IEEE/ACM', 'https://www.ieee.org/about/corporate/governance/code-of-ethics.html'),
(5, 'Física Médica, Dosimetria e Radiobiologia', 'https://www.aapm.org/pubs/reports/');

INSERT INTO questoes (id, Enunciado, opcao_id, Resposta_correta, dificuldade_nivel, fonte_id) VALUES
('fact-001', 'O que era exatamente o Therac-25 e qual era a sua finalidade primária na medicina?', 1, 'B', 'facil', 1),
('fact-002', 'Qual foi a empresa canadense responsável pelo projeto e fabricação do Therac-25?', 2, 'D', 'facil', 1),
('fact-003', 'Entre quais anos ocorreram os acidentes graves de sobredosagem de radiação documentados?', 3, 'A', 'medio', 1),
('fact-004', 'Quantos acidentes de sobredosagem massiva de radiação foram oficialmente confirmados pelo estudo de Leveson?', 4, 'C', 'medio', 1),
('fact-005', 'Quais são os dois modos de tratamento terapêutico que a máquina Therac-25 oferecia?', 5, 'E', 'facil', 1),
('fact-006', 'O que era o Therac-25: um equipamento totalmente novo ou a evolução de modelos anteriores?', 6, 'B', 'facil', 1),
('fact-007', 'Qual era a principal inovação técnica do Therac-25 em relação aos seus antecessores Therac-6 e Therac-20?', 7, 'D', 'medio', 1),
('fact-008', 'Que sintoma imediato e incomum os pacientes relatavam sentir durante os disparos acidentais?', 8, 'A', 'facil', 1),
('fact-009', 'Qual era o erro exibido na tela do operador quando o sistema aplicava uma overdose sem aviso prévio?', 9, 'C', 'medio', 1),
('fact-010', 'O que significavam os códigos de erro genéricos ("MALFUNCTION") exibidos no terminal de controle?', 10, 'E', 'medio', 1),
('fact-011', 'Qual foi a principal consequência para a saúde das vítimas expuestas às sobredosagens do Therac-25?', 11, 'C', 'facil', 1),
('fact-012', 'O software do Therac-25 foi escrito em qual linguagem de programação?', 12, 'A', 'medio', 1),
('fact-013', 'Em qual processador o sistema de controle do Therac-25 era executado?', 13, 'E', 'medio', 1),
('fact-014', 'Quantas vezes acima da dose prescrita a máquina aplicava quando ocorria a falha de feixe direto?', 14, 'B', 'medio', 1),
('fact-015', 'Quem foi a pesquisadora de segurança de software responsável pelo relatório clássico que analisou o caso?', 15, 'D', 'facil', 1),
('fact-016', 'Que componente físico crucial de segurança (intertrava mecânica) foi removido no Therac-25?', 16, 'C', 'dificil', 1),
('fact-017', 'A interface do operador utilizava que tipo de terminal para entrada de dados e comandos?', 17, 'A', 'dificil', 1),
('fact-018', 'O que acontecía quando o operador pressionava a tecla \P'' ''(Proceed) após o erro "Malfunction 5"?', 18, 'E', 'dificil', 1),
('fact-019', 'Qual era a reação inicial dos técnicos do fabricante quando os hospitais notificavam suspeitas de overdose?', 19, 'B', 'medio', 1),
('fact-020', 'Qual órgão regulador governamental dos EUA interveio no caso exigindo planos de ação corretiva?', 20, 'D', 'facil', 3),
('fact-021', 'O código de software do Therac-25 foi testado de forma independente antes de ser colocado no mercado comercial?', 21, 'D', 'medio', 1),
('fact-022', 'Quantas pessoas morreram diretamente em decorrência dos acidentes de radiação do Therac-25?', 22, 'B', 'facil', 1),
('fact-023', 'O que é uma "condição de corrida" (race condition) no contexto de software?', 23, 'C', 'medio', 1),
('fact-024', 'Qual era a função do "alvo de tungstênio/ouro" (target) no modo de Raio-X de alta energia?', 24, 'A', 'medio', 1),
('fact-025', 'O Therac-25 continuou sendo vendido normalmente após os relatórios de acidentes fatais?', 25, 'E', 'medio', 1),
('fact-026', 'Como os operadores podiam pausar e retomar um tratamento no console da máquina?', 26, 'D', 'dificil', 1),
('fact-027', 'O que acontecia se o operador tentasse alterar um valor digitado incorretamente no terminal?', 27, 'B', 'dificil', 1),
('fact-028', 'Qual era a promessa comercial da AECL em relação à automação no Therac-25?', 28, 'C', 'medio', 1),
('fact-029', 'Em que país ficava a sede da AECL (Atomic Energy of Canada Limited)?', 29, 'A', 'facil', 1),
('fact-030', 'Qual era o objetivo da radiação aplicada pelo Therac-25 em pacientes com câncer?', 30, 'E', 'facil', 1),
('fact-031', 'Quais eram as unidades de medida utilizadas para definir a dose de radiação administrada?', 31, 'A', 'facil', 1),
('fact-032', 'Como a máquina sinalizava visualmente que o feixe de radiação estava ativo?', 32, 'C', 'medio', 1),
('fact-033', 'Os operadores do Therac-25 ficavam na mesma sala que o paciente durante o disparo do feixe?', 33, 'B', 'facil', 1),
('fact-034', 'Qual foi o destino final das máquinas Therac-25 instaladas nos hospitais após as investigações?', 34, 'E', 'medio', 1),
('fact-035', 'Como a velocidade de digitação de operadores experientes contribuiu diretamente para o disparo do bug no Therac-25?', 35, 'D', 'dificil', 1),
('fact-036', 'Qual é a diferença física e operacional fundamental entre o modo "Eletrons" e o modo "Photons" (Raio-X)?', 36, 'A', 'medio', 1),
('fact-037', 'Descreva a falha do estouro de variável (overflow) no código de verificação do posicionamento do braço giratório.', 37, 'C', 'dificil', 1),
('fact-038', 'Por que o reuso de código do Therac-6 e Therac-20 para o Therac-25 criou uma falsa sensação de segurança?', 38, 'B', 'medio', 1),
('fact-039', 'Qual era a sequência de ações no terminal que ativava o bug de edição rápida de parâmetros?', 39, 'E', 'dificil', 1),
('fact-040', 'O que acontecia fisicamente com o feixe de elétrons quando a máquina disparava no modo Raio-X sem o alvo metálico posicionado?', 40, 'D', 'dificil', 1),
('fact-041', 'Como a ausência de feedback claro de erro levou os operadores a repetirem a aplicação de dose no mesmo paciente?', 41, 'E', 'medio', 1),
('fact-042', 'O que caracterizava a rotina do sistema operacional de tempo real (RTOS) do Therac-25?', 42, 'D', 'dificil', 1),
('fact-043', 'De que maneira a AECL testou a confiabilidade do software antes de declarar que o sistema era seguro?', 43, 'A', 'medio', 1),
('fact-044', 'Por que as intertravas físicas de hardware presentes no Therac-20 mascaravam os bugs de software que já existiam?', 44, 'B', 'dificil', 1),
('fact-045', 'Qual foi o papel do físico hospitalar Fritz Hager no Northfield Cancer Center (Tyler, Texas)?', 45, 'C', 'dificil', 1),
('fact-046', 'Explique como a variável `Class` incrementava e por que o valor zero liberava o feixe inapropriadamente.', 46, 'E', 'dificil', 1),
('fact-047', 'Quantas rads (unidade de radiação) eram entregues em um disparo acidental versus a dose terapêutica normal?', 47, 'D', 'medio', 1),
('fact-048', 'Quais foram alguns dos locais onde ocorreram acidentes documentados do Therac-25?', 48, 'A', 'medio', 1),
('fact-049', 'Como a arquitetura multithreading sem mecanismos adequados de sincronização (mutexes) afetou o sistema?', 49, 'B', 'dificil', 1),
('fact-050', 'Qual foi a resposta e exigência oficial da FDA americana após a notificação dos acidentes?', 50, 'C', 'medio', 3),
('fact-051', 'Por que a rotina `Datain` permitia que o operador modificasse a configuração enquanto o curvamento do feixe se ajustava?', 51, 'B', 'dificil', 1),
('fact-052', 'O que significava o termo "segurança por design" (safety-by-design) e como ele foi violado no Therac-25?', 52, 'E', 'dificil', 2),
('fact-053', 'Como a documentação técnica deficiente do software dificultou as investigações internas da própria AECL?', 53, 'D', 'medio', 1),
('fact-054', 'Qual era a proporção da taxa de corrente do feixe de elétrons no modo Raio-X comparada com o modo Elétrons direto?', 54, 'C', 'dificil', 1),
('fact-055', 'Como os engenheiros da AECL tentaram reproduzir o erro inicialmente e por que falharam em seus primeiros testes?', 55, 'A', 'dificil', 1),
('fact-056', 'O que era o "Pencil Beam" e por que sua aplicação direta e sem espalhamento foi devastadora?', 56, 'B', 'dificil', 1),
('fact-057', 'Qual foi o impacto de responsabilizar inicialmente o operador por "erro humano" na gestão da tragédia?', 57, 'E', 'medio', 4),
('fact-058', 'De que modo as modificações temporárias de hardware aplicadas pela AECL falharam em resolver a causa raiz?', 58, 'D', 'dificil', 1),
('fact-059', 'Que importante norma/princípio de engenharia médica emergiu diretamente das lições do Therac-25?', 59, 'C', 'medio', 2),
('fact-060', 'Como era realizada a calibração dos sensores de radiação e por que ela não preveniu os disparos incorretos?', 60, 'A', 'dificil', 1),
('fact-061', 'Qual era o papel do carrossel (turntable) no funcionamento físico do Therac-25?', 61, 'C', 'medio', 1),
('fact-062', 'De que forma a interface de usuário do Therac-25 omitia informações sobre o estado real do feixe?', 62, 'D', 'dificil', 1),
('fact-063', 'Por que o teste de software em isolamento não conseguiu identificar a condição de corrida em ambiente multitarefa?', 63, 'B', 'dificil', 1),
('fact-064', 'Como as alterações na tela podiam ser gravadas sem validação no Therac-25?', 64, 'E', 'dificil', 1),
('fact-065', 'Qual foi a diferença na atitude investigativa da clínica de Tyler (Texas) em relação às outras instituições afetadas?', 65, 'A', 'medio', 1),
('fact-066', 'Por que a AECL continuou afirmando que era "impossível" haver overdose por software mesmo após múltiplos casos?', 66, 'C', 'medio', 1),
('fact-067', 'Qual era a função da folha espalhadora (foil) no modo de elétrons e como sua ausência alterava a dosimetria?', 67, 'D', 'dificil', 1),
('fact-068', 'Como era a estrutura da tabela de estados do carrossel no microprocessador?', 68, 'E', 'dificil', 1),
('fact-069', 'Explique a mecânica exata do bug do contador de testes de calibração que resetava a cada 5 execuções no loop de checagem (Yakima).', 69, 'A', 'dificil', 1),
('fact-070', 'Como a ausência de uma arquitetura de proteção de memória no processador PDP-11 afeta sistemas críticos como o do Therac-25?', 70, 'D', 'dificil', 1),
('fact-071', 'Detalhe o papel do espelho de alinhamento óptico no carrossel de posições.', 71, 'A', 'dificil', 1),
('fact-072', 'Por que o uso de sinalizadores (flags) de um único byte sem operações atômicas (*read-modify-write*) gerava inconsistências?', 72, 'E', 'dificil', 1),
('fact-073', 'Quais foram as falhas na gestão de configuração de software que permitiram os problemas no Therac-25?', 73, 'C', 'dificil', 1),
('fact-074', 'Explique como o software tratava o estado de "Pause" e como isso podia acumular parâmetros incorretos antes da liberação.', 74, 'B', 'dificil', 2),
('fact-075', 'De que maneira a dosimetria por software era afetada pela saturação das câmaras de ionização?', 75, 'D', 'dificil', 1),
('fact-076', 'Avalie a responsabilidade ética dos engenheiros envolvidos no caso sob os códigos modernos (IEEE/ACM).', 76, 'A', 'medio', 1),
('fact-077', 'Qual foi a mecânica do acidente em Tyler, Texas, e como diferiu do acidente em Yakima?', 77, 'E', 'dificil', 4),
('fact-078', 'Como a premissa errônea de que "software não desgasta nem falha" afetou a análise FMEA da AECL?', 78, 'C', 'dificil', 1),
('fact-079', 'Descreva o funcionamento das câmaras de ionização duplas e por que não interromperam o feixe a tempo durante o disparo massivo.', 79, 'B', 'dificil', 2),
('fact-080', 'Como o sistema tratava as interrupções de hardware geradas pelo teclado na velocidade do buffer UART?', 80, 'E', 'dificil', 1),
('fact-081', 'Analise o papel da cultura organizacional da AECL na negação inicial das falhas.', 81, 'B', 'medio', 1),
('fact-082', 'Por que a inclusão de um microswitch de hardware no carrossel teria evitado os acidentes mesmo com bugs de software?', 82, 'C', 'dificil', 3),
('fact-083', 'Explique como a rotina `Set_Bending_Magnet` interagia com os conversores digital-analógico (DAC).', 83, 'D', 'dificil', 1),
('fact-084', 'Como a validação baseada em testes de "caixa-preta" falhou em revelar os caminhos de execução contendo race conditions?', 84, 'A', 'dificil', 1),
('fact-085', 'Qual foi o impacto de falta de logs persistentes em disco/fita na reconstrução post-mortem dos acidentes?', 85, 'E', 'dificil', 1),
('fact-086', 'Como as diretrizes do FDA "Corrective Action Plan" (CAP) reformularam a aprovação de dispositivos médicos de Classe III?', 86, 'B', 'medio', 1),
('fact-087', 'Qual era a função da rotina de verificação de consistência de fundo (*background check*) e por que ela não suspendeu o feixe?', 87, 'C', 'dificil', 3),
('fact-088', 'Explique o fenômeno físico da Queimadura Radiológica Profunda provocada pelo feixe direto de feixe sem atenuação.', 88, 'D', 'dificil', 1),
('fact-089', 'Como a modelagem por métodos formais (como Redes de Petri) teria identificado os estados inválidos do sistema?', 89, 'A', 'dificil', 5),
('fact-090', 'Qual foi o papel da imprensa e das publicações científicas na divulgação do problema antes dos recalls oficiais?', 90, 'A', 'medio', 2),
('fact-091', 'Compare o modelo de acoplamento do sistema do Therac-25 com a teoria de "Acidentes Normais" de Charles Perrow.', 91, 'D', 'dificil', 4),
('fact-092', 'Desenvolva conceitualmente o topo de uma Árvore de Análise de Falhas (FTA) para o evento: "Emissão de feixe de alta corrente sem espalhador".', 92, 'B', 'dificil', 2),
('fact-093', 'Por que o uso de buffers de entrada sem tratamento de overflow contribuiu para a corrupção do estado da interface?', 93, 'E', 'dificil', 2),
('fact-094', 'Como a alteração de requisitos durante o ciclo de vida do projeto comprometeu a coerência do código original do Therac-25?', 94, 'C', 'dificil', 1),
('fact-095', 'De que modo a análise estática de código moderno preveniria o estouro de variáveis e atalhos na interface do Therac-25?', 95, 'A', 'dificil', 1),
('fact-096', 'Como o Efeito Cherenkov foi observado visualmente por pacientes atingidos pelo feixe durante o disparo?', 96, 'D', 'medio', 2),
('fact-097', 'Qual é a importância da redundância diversificada (hardware vs. software) na engenharia de sistemas críticos de segurança?', 97, 'B', 'medio', 5),
('fact-098', 'Proponha a arquitetura de uma intertrava física independente para ser acoplada em um acelerador linear moderno.', 98, 'E', 'dificil', 2),
('fact-099', 'Que lição fundamental sobre a relação entre automação e responsabilidade humana o caso Therac-25 ensina?', 99, 'C', 'medio', 2),
('fact-100', 'Qual das alternativas abaixo descreve corretamente a falha de concorrência que ocorria na interface do Therac-25?', 100, 'D', 'dificil', 2);

INSERT INTO opcao_questoes (Opcao_a, Opcao_b, Opcao_c, Opcao_d, Opcao_e) VALUES
('Um sistema de diagnóstico por imagem para detecção de tumores.', 'Um acelerador linear de elétrons utilizado em radioterapia para destruição de tecidos cancerígenos.', 'Um equipamento de ressonância magnética de alta precisão.', 'Um tomógrafo computadorizado com emissão de pósitrons (PET-Scan).', 'Um robô cirúrgico para procedimentos minimamente invasivos.'),
('General Electric Medical Systems Canada.', 'Siemens Healthineers Canada.', 'Bombardier Medical Robotics.', 'Atomic Energy of Canada Limited (AECL).', 'Philips Medical Systems Canada.'),
('985 e 98.', '95 e 98.', '99 e 99.', '998 e 00.', '980 e 98.'),
('8 acidentes.', '5 acidentes.', '6 acidentes.', '7 acidentes.', 'acidente acumululado.'),
('Modo Ultrassom e Modo Laser de Alta Intensidade.', 'Modo Radiação Gama e Modo Próton-terapia.', 'Modo Termoterapia e Modo Crioterapia.', 'Modo Tomografia e Modo Ressonância.', 'Modo Eletrons (direto) e Modo Photons (Raio-X de alta energia).'),
('Projeto criado do zero, sem reaproveitamento de conceitos.', 'Evolução dos modelos Therac- e Therac-0.', 'Versão modificada de um acelerador industrial europeu.', 'Protótipo acadêmico nunca comercializado antes.', 'Cópia direta de um acelerador americano concorrente.'),
('O uso de inteligência artificial para calcular a dose.', 'A inclusão de um braço robótico articulado de eixos.', 'A substituição do terminal por tela touchscreen.', 'A eliminação das intertravas mecânicas de hardware, confiando a segurança totalmente ao software.', 'A utilização de supercondutores criogênicos.'),
('Sensação de choque elétrico, dor aguda e sensação de queimadura/calor intenso.', 'Tontura instantânea e perda temporária da visão.', 'Parestesia súbita nos membros inferiores.', 'Náuseas violentas e perda auditiva imediata.', 'Paralisia temporária dos membros superiores.'),
('CRITICAL HARDWARE FAILURE.', 'RADIATION OVERFLOW DETECTED.', 'MALFUNCTION 5 (ou outro número genérico de Malfunction).', 'SYSTM SHUTDOWN EMERGENCY.', 'FATAL MEMORY OVERFLOW.'),
('O número indicava exatamente qual peça estava quebrada.', 'Aviso de que o paciente se movimentou durante o disparo.', 'Confirmação de que o tratamento fora concluído.', 'Falha crítica no disco rígido do computador principal.', 'Mensagens genéricas indicando que o feixe parou por inconsistência, sem especificar a gravidade.'),
('Desenvolvimento de catarata precoce sem lesões cutâneas.', 'Apenas eritemas leves que desapareciam em horas.', 'Queimaduras radiológicas severas, necrose tecidual e morte de vários pacientes.', 'Alterações assintomáticas detectadas apenas em exames de sangue.', 'Perda total dos movimentos musculares sem lesões na pele.'),
('Assembly (PDP-).', 'C++', 'FORTRAN .', 'Pascal.', 'Cobol.'),
('Intel 808.', 'Motorola 8000.', 'Zilog Z80.', 'PowerPC G.', 'PDP- (DEC).'),
('Cerca de ,5 a vezes a dose.', 'Cerca de 00 a 5 vezes a dose normal.', 'Exatamente 0 vezes a dose.', 'Aproximadamente 500 vezes a dose.', '000 vezes a dose prescrita.'),
('Grace Hopper.', 'Margaret Hamilton.', 'Barbara Liskov.', 'Nancy Leveson.', 'Ada Lovelace.'),
('Os fusíveis elétricos da tomada de parede.', 'O botão de desligamento de emergência da sala.', 'O circuito independente de intertrava de hardware do carrossel/placa de alvo.', 'A blindagem de chumbo das paredes do bunker.', 'O disjuntor geral do gerador de alta voltagem.'),
('Terminal de vídeo DEC VT00 com teclado.', 'Leitor de cartões perfurados IBM.', 'Painel analógico com chaves comutadoras.', 'Teclado numérico com display de segmentos.', 'Monitor LCD touchscreen resistivo.'),
('O sistema abortava o tratamento e reiniciava.', 'A máquina abria o manual de instruções na tela.', 'O feixe era reduzido automaticamente para %.', 'O computador entrava em modo de segurança.', 'O erro era ignorado e a máquina aplicava mais uma dose massiva de radiação.'),
('Interrompiam as vendas imediatamente.', 'Afirmavam que era impossível haver overdose por software e atribuíam ao erro do operador.', 'Contratavam auditorias externas no mesmo dia.', 'Substituíam todos os computadores das clínicas.', 'Realizavam recall voluntário em 8 horas.'),
('NASA.', 'FCC.', 'OSHA.', 'FDA (Food and Drug Administration).', 'EPA.'),
('Sim, por três órgãos de certificação internacionais.', 'Sim, por uma equipe de hackers especializados.', 'Sim, através de simulação formal em supercomputadores.', 'Não, os testes de software foram mínimos e não houve validação independente.', 'Sim, por auditores do governo canadense.'),
('Nenhuma (houve apenas ferimentos leves).', 'Pelo menos a 5 fatalidades diretamente comprovadas.', 'Mais de 00 pessoas.', 'Exatamente 8 pessoas.', 'Apenas uma pessoa idosa.'),
('Um bug que faz o processador rodar com overclock.', 'Um vírus que acelera o consumo de memória RAM.', 'Uma falha onde o resultado depende da ordem ou do tempo relativo de execução de tarefas concorrentes.', 'Um erro de digitação cometido ao escrever laços de repetição.', 'Um conflito de endereçamento IP na rede local.'),
('Absorver os elétrons para convertê-los em um feixe de fótons (Raio-X).', 'Servir de espelho para alinhar o laser visível.', 'Resfriar os magnéticos de curvamento.', 'Medir a temperatura ambiente do bunker.', 'Filtrar os raios gama indesejados.'),
('Sim, continuou no mercado por mais 0 anos.', 'Sim, mas apenas para clínicas veterinárias.', 'Sim, com desconto de 50% em peças.', 'Sim, sob nova marca comercial.', 'Não, sofreu suspensão e recall até que modificações fossem implementadas.'),
('Cortando a energia elétrica da parede.', 'Girando uma chave física no pedal.', 'Digitando a senha de administrador.', 'Pressionando a tecla \''P\'' ou barra de espaço para pausar/prosseguir no terminal.', 'Desconectando o cabo serial do teclado.'),
('O sistema emitia bipe e bloqueava o teclado por 0 minutos.', 'O cursor subia para corrigir o campo, abrindo a janela de tempo que acionava a condição de corrida.', 'A tela apagava e apagava a ficha do paciente.', 'A máquina executava calibração automática.', 'O computador reiniciava em modo de diagnóstico.'),
('Eliminar a necessidade de físicos hospitalares.', 'Curar o câncer em metade das sessões.', 'Reduzir o tempo de preparação do tratamento e aumentar a eficiência operacional das clínicas.', 'Permitir controle remoto via linha telefônica.', 'Reduzir o custo operacional em 90%.'),
('Canadá.', 'Estados Unidos.', 'Reino Unido.', 'Alemanha.', 'França.'),
('Queimar verrugas superficiais na pele.', 'Aquecer os tecidos para melhorar a circulação.', 'Esterilizar instrumentos cirúrgicos.', 'Reduzir a dor crônica nas articulações.', 'Destruir células tumorais e retardar ou impedir o crescimento de neoplasias.'),
('Rads (ou Grays).', 'Volts e Amperes.', 'Joules por segundo.', 'Candelas e Lumens.', 'Hertz e Decibéis.'),
('Apagando todas as luzes da sala.', 'Ativando um giroscópio luminoso no teto.', 'Por meio de um indicador/luz de "BEAM ON" na tela e no painel do console.', 'Mudando a cor do monitor para vermelho brilhante.', 'Emitindo raios laser coloridos no ambiente.'),
('Sim, ao lado da maca segurando a mão do paciente.', 'Não, ficavam em uma sala de controle externa blindada com intercomunicador e monitor de TV.', 'Dependia do tipo de tumor a ser tratado.', 'Ficavam atrás de uma cortina plástica dentro da sala.', 'Ficavam no andar superior do hospital.'),
('Foram todas destruídas e derretidas no mesmo ano.', 'Doadas sem alterações para países emergentes.', 'Convertidas em aparelhos de raio-X odontológicos.', 'Desmontadas e transformadas em servidores de rede.', 'Sofreram modificações obrigatórias de software e instalação de intertravas mecânicas de hardware.'),
('Os operadores digitavam tão rápido que travavam o teclado fisicamente, gerando um curto-circuito.', 'A velocidade excessiva enviava comandos em código ASCII corrompido para o processador.', 'O sistema interpretava a digitação rápida como um ataque de negação de serviço e reiniciava em modo de emergência.', 'A digitação rápida das correções (em menos de 8 segundos) permitia alterar o modo do feixe enquanto a rotina de configuração do feixe ainda estava em execução em segundo plano sem a trava adequada.', 'Acelerava o relógio interno do computador corrompendo a contagem dos minutos.'),
('O modo Eletrons utiliza corrente baixa e feixe direto; o modo Photons utiliza corrente até 00 vezes maior contra um alvo metálico conversor.', 'O modo Eletrons necessita do alvo de tungstênio, enquanto o modo Photons necessita do espalhador de alumínio.', 'O modo Photons opera com voltagem nula, enquanto o modo Eletrons opera com voltagem máxima.', 'O modo Eletrons é destinado apenas a tumores profundos e o Photons a tumores de pele.', 'Não há diferença física, apenas alteração na cor da interface visual.'),
('Uma variável de bits estourava após .000 horas continuas de uso da máquina.', 'O estouro de memória RAM fazia o sistema operacional sobrescrever os dados cadastrais do paciente.', 'Um contador de byte (0 a 55) incrementava a cada iteração de teste e, ao atingir 5voltava a zero (Class = 0), fazendo o software interpretar erroneamente que o posicionamento estava correto e verificado.', 'O estouro da variável de dosimetria fazia a máquina desligar os motores antes de posicionar a mesa.', 'A variável de controle do relógio estourava a cada horas de operação contínua.'),
('Porque o código original havia sido escrito em uma linguagem de programação moderna e sem erros.', 'Porque nos modelos antigos as intertravas mecânicas de hardware mascaravam e preveniam as falhas de software que já existiam no código reusado.', 'Porque o software antigo havia sido certificado pela NASA para missões espaciais.', 'Porque os modelos antigos utilizavam inteligência artificial para autofixação de bugs.', 'Porque o código reusado era totalmente imune a condições de corrida.'),
('Pressionar a tecla \''Ctrl+Alt+Del\'' repetidamente durante o disparo do feixe.', 'Digitar \''P\'' (Proceed) antes de selecionar o nome do paciente no banco de dados.', 'Segurar a barra de espaço por mais de 0 segundos na tela principal de logon.', 'Executar o comando de formatação do disco rígido pelo terminal.', 'Digitar o modo de Raio-X (\''X\''), perceber o erro, usar a tecla de subir cursor para alterar para Elétrons (\''E\'') e pressionar \''Enter\'' em menos de 8 segundos.'),
('O feixe era bloqueado por uma parede de chumbo móvel sem atingir a sala.', 'O tubo de vácuo do acelerador explodia devido à alta pressão de ar.', 'A máquina emitia apenas uma luz visível azul sem radiação ionizante.', 'Um feixe de elétrons de alta corrente e estreito (pencil beam) atingia diretamente o corpo do paciente sem atenuação ou espalhamento.', 'O feixe desviava automaticamente para o teto da sala de tratamento.'),
('O monitor desligava completamente, forçando o operador a adivinhar o status.', 'O sistema informava na tela que a sessão havia sido cancelada com sucesso antes da emissão.', 'A impressora gerava um comprovante afirmando que o feixe falhara em ligar.', 'O sistema exibia uma tela azul de erro fatal que pedia para reiniciar a máquina.', 'A tela exibia apenas "MALFUNCTION 5" e indicava subdose/não entrega, induzindo o operador a pressionar \''P\'' (Proceed) para tentar reaplicar a dose prescrita.'),
('Um sistema operacional comercial Linux com gerenciamento rigoroso de memória virtual.', 'O uso do Windows NT Workstation em arquitetura de bits.', 'A ausência de qualquer suporte a concorrência ou interrupções de hardware.', 'Um RTOS artesanal e pré-emptivo sem mecanismos adequados de sincronização e proteção de memória compartilhada.', 'Um sistema operacional em tempo real desenvolvido em linguagem C pela Microsoft.'),
('Realizou testes básicos integrados ao hardware, assumindo que o software era perfeito por não ter partes móveis sujeitas a desgaste.', 'Submeteu o código a simulações de verificação formal por Redes de Petri por anos.', 'Contratou uma empresa independente de auditoria em engenharia de software na Europa.', 'Deixou o código em teste aberto na comunidade acadêmica por 8 meses.', 'Executou testes de estresse com 0.000 horas de simulação virtual.'),
('O hardware reescrevia o código do software automaticamente no disco rígido.', 'Quando o software enviava um comando inválido ou perigoso, o circuito mecânico cortava a energia do feixe antes do disparo, impedindo o acidente.', 'As intertravas desligavam a tela do operador para esconder os relatórios de erro.', 'O hardware gerava relatórios semanais de bugs para os engenheiros da AECL.', 'As peças mecânicas bloqueavam o teclado do terminal durante falhas lógicas.'),
('Ele projetou a primeira versão do software do Therac-5.', 'Ele foi o responsável por defender a AECL nos tribunais internacionais.', 'Ele trabalhou rigorosamente com a operadora do hospital para reproduzir a sequência exata de comandos que acionava a falha do software de forma consistente.', 'Ele desenvolveu a vacina contra os efeitos da sobredosagem por radiação.', 'Ele coordenou o recall mundial das máquinas.'),
('A variável `Class` registrava a temperatura do bunker e desativava a segurança ao congelar em zero.', 'O valor zero forçava o processador a entrar em loop infinito de reinicialização.', '`Class` era o identificador do paciente e, se fosse zero, o tratamento era aplicado no modo de teste.', 'A variável contava os ciclos de clock da CPU e liberava o feixe ao esgotar a memória.', 'A variável `Class` acumulava erros de hardware; o valor zero indicava ausência de erros, fazendo o sistema liberar o feixe mesmo com os componentes desalinharados.'),
('Exatamente 50 rads no disparo acidental contra 500 rads na dose normal.', 'Cerca de .000.000 rads no disparo acidental contra 0.000 rads na dose normal.', 'A overdose entregava apenas 5 rads a mais do que a dose prescrita.', 'Cerca de 0.000 a 5.000 rads no disparo acidental, contra uma dose normal de 00 a 00 rads.', '500 rads no disparo acidental contra 50 rads na dose normal.'),
('Kennestone (Georgia), Hamilton (Ontário), Tyler (Texas) e Yakima (Washington).', 'Nova York (EUA), Londres (Reino Unido), Paris (França) e Tóquio (Japão).', 'São Paulo (Brasil), Buenos Aires (Argentina) e Santiago (Chile).', 'Toronto (Canadá), Ottawa (Canadá) e Quebec (Canadá) exclusivamente.', 'Berlim (Alemanha), Roma (Itália) e Madri (Espanha).'),
('Impediu o computador de ligar quando conectado à rede elétrica.', 'Permitiu que a tarefa de interface do usuário alterasse variáveis de configuração críticas enquanto a tarefa de controle do feixe já as lia/processava.', 'Fez a memória RAM apagar todas as variáveis a cada 5 minutos.', 'Duplicou o tamanho do arquivo executável do software.', 'Causou o travamento total da CPU ao tentar ler arquivos em disquete.'),
('Determinou o banimento eterno de qualquer computador em equipamentos médicos.', 'Multou apenas os operadores do hospital sem responsabilizar a fábrica.', 'Exigiu a elaboração e execução de Planos de Ação Corretiva (CAP), incluindo mudanças estruturais de software e instalação de intertravas mecânicas.', 'Aprovou a máquina para venda livre em farmácias e postos de saúde.', 'Encerrou as atividades do órgão regulador por conflito de interesses.'),
('Porque foi desenhada intencionalmente para permitir o ajuste fino durante o tratamento.', 'Porque não havia checagem de concorrência que impedisse o operador de editar a tela durante o ciclo de posicionamento dos magnéticos (que levava cerca de 8 segundos).', 'Para economizar energia elétrica do circuito de refrigeração.', 'Porque a rotina operava em um computador separado instalado na recepção do hospital.', 'Para permitir o cancelamento imediato de comandos digitados por engano.')
