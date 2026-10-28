import { sql } from '@vercel/postgres';

export default async function handler(request, response) {
  try {
    // Busca todas as perguntas cadastradas no banco SQL
    const { rows } = await sql`SELECT * FROM perguntas;`;
    
    // Retorna as perguntas em formato JSON para o seu site
    return response.status(200).json(rows);
  } catch (error) {
    console.error("Erro ao buscar perguntas:", error);
    return response.status(500).json({ error: 'Erro ao carregar as perguntas do banco.' });
  }
}
