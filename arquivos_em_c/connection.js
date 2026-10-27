// Usa a função de banco já configurada pela API e consultas parametrizadas.
export async function salvarResultadoQuiz(db, resultado) {
  if (!db || typeof db.query !== 'function') {
    throw new TypeError('É necessário fornecer uma conexão PostgreSQL com método query().');
  }
  const { nome_usuario, total_acertos, pontuacao_final } = resultado;
  if (typeof nome_usuario !== 'string' || !nome_usuario.trim()) {
    throw new Error('O nome do usuário é obrigatório.');
  }
  if (!Number.isInteger(total_acertos) || !Number.isInteger(pontuacao_final)) {
    throw new TypeError('Acertos e pontuação devem ser números inteiros.');
  }

  // A tabela/colunas devem existir no schema usado pelo projeto.
  return db.query(
    'INSERT INTO ranking_quiz (nome_usuario, total_acertos, pontuacao_final) VALUES ($1, $2, $3)',
    [nome_usuario.trim(), total_acertos, pontuacao_final]
  );
}
