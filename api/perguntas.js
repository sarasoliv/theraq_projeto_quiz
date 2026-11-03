// Handler compatível com plataformas serverless que fornecem DATABASE_URL.
const { Pool } = require("pg");
let pool;
module.exports = async function handler(request, response) {
  if (!process.env.DATABASE_URL) return response.status(503).json({ error: "DATABASE_URL não configurada." });
  try {
    pool ||= new Pool({ connectionString: process.env.DATABASE_URL, ssl: { rejectUnauthorized: false } });
    const requestUrl = new URL(request.url, "postgresql://postgres:RjhnQBHp7sY8CMyH@db.zwsabtozrjnpmhjiidmd.supabase.co:5432/postgres");
    const dificuldade = normalizarDificuldade(requestUrl.searchParams.get("dificuldade"));

    let query = `
      SELECT q.id, q.enunciado, q.resposta_correta, q.dificuldade_nivel,
             f.referencia, o.opcao_a, o.opcao_b, o.opcao_c, o.opcao_d, o.opcao_e
      FROM questoes q JOIN opcao_questoes o ON o.id_opcao = q.opcao_id
      LEFT JOIN fonte f ON f.id = q.fonte_id
    `;
    const params = [];

    if (dificuldade) {
      query += " WHERE lower(trim(q.dificuldade_nivel)) = lower($1)";
      params.push(dificuldade);
    }

    query += " ORDER BY q.id";

    const { rows } = await pool.query(query, params);
    return response.status(200).json(rows.map(q => ({ ...q, alternativas: [q.opcao_a, q.opcao_b, q.opcao_c, q.opcao_d, q.opcao_e] })));
  } catch (error) {
    console.error("Erro ao consultar perguntas:", error.message);
    return response.status(500).json({ error: "Erro ao carregar perguntas." });
  }
};

function normalizarDificuldade(value) {
  if (typeof value !== "string") return "";
  const normalized = value
    .trim()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/\s+/g, "");

  if (!normalized || normalized === "todas") return "";
  if (["facil", "fácil"].includes(normalized)) return "facil";
  if (["medio", "media", "médio", "média"].includes(normalized)) return "medio";
  if (["dificil", "difícil"].includes(normalized)) return "dificil";
  return normalized;
}
