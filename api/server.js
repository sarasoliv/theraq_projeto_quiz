const http = require("node:http");
const fs = require("node:fs");
const path = require("node:path");

const projectRoot = path.resolve(__dirname, "..");
const maximumQuestionCount = 10;

loadEnvFile();
const port = Number(process.env.PORT) || 3000;

const server = http.createServer(async (request, response) => {
  try {
    const requestUrl = new URL(request.url, `http://${request.headers.host || "localhost"}`);

    if (request.method === "GET" && requestUrl.pathname === "/api/health") {
      return sendJson(response, 200, {
        status: "ok",
        groqConfigured: Boolean(process.env.GROQ_API_KEY)
      });
    }

    if (request.method === "POST" && requestUrl.pathname === "/api/questions") {
      return await generateQuestions(request, response);
    }

    if (request.method === "GET") {
      return serveFrontend(requestUrl.pathname, response);
    }

    return sendJson(response, 405, { error: "Método não permitido." });
  } catch (error) {
    console.error("Erro no servidor:", error.message);
    if (!response.headersSent) sendJson(response, 500, { error: "Ocorreu um erro no servidor." });
  }
});

async function generateQuestions(request, response) {
  if (!process.env.GROQ_API_KEY) {
    return sendJson(response, 503, { error: "A API da Groq não está configurada no servidor." });
  }

  let body;
  try {
    body = await readJsonBody(request);
  } catch (error) {
    return sendJson(response, error.statusCode || 400, { error: error.message });
  }

  const count = Number.isInteger(body?.quantidade)
    ? Math.min(Math.max(body.quantidade, 1), maximumQuestionCount)
    : 5;
  const topic = typeof body?.tema === "string" ? body.tema.trim().slice(0, 100) : "";
  const difficulty = typeof body?.dificuldade === "string"
    ? body.dificuldade.trim().slice(0, 30)
    : "média";

  if (!topic) return sendJson(response, 400, { error: "Informe um tema para gerar as perguntas." });

  try {
    const groqResponse = await fetch("https://api.groq.com/openai/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${process.env.GROQ_API_KEY}`,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        model: process.env.GROQ_MODEL || "llama-3.3-70b-versatile",
        temperature: 0.7,
        response_format: { type: "json_object" },
        messages: [
          {
            role: "system",
            content: "Você cria perguntas educativas de quiz em português do Brasil. Retorne somente um objeto JSON válido, sem markdown."
          },
          {
            role: "user",
            content: `Crie exatamente ${count} perguntas de múltipla escolha sobre "${topic}" com dificuldade ${difficulty}. Cada pergunta deve ter quatro alternativas plausíveis e uma explicação educativa. Use exatamente este formato: {"perguntas":[{"pergunta":"...","alternativas":["...","...","...","..."],"respostaCorreta":0,"explicacao":"..."}]}. respostaCorreta deve ser o índice numérico da alternativa correta, de 0 a 3.`
          }
        ]
      })
    });

    if (!groqResponse.ok) {
      console.error(`A Groq respondeu com status ${groqResponse.status}.`);
      return sendJson(response, 502, { error: "A Groq não conseguiu gerar perguntas agora. Verifique a chave e tente novamente." });
    }

    const result = await groqResponse.json();
    const content = result.choices?.[0]?.message?.content;
    const parsed = JSON.parse(content || "{}");
    const questions = parsed.perguntas;

    if (!Array.isArray(questions) || questions.length !== count || !questions.every(isValidQuestion)) {
      return sendJson(response, 502, { error: "A IA retornou perguntas em um formato inválido. Tente novamente." });
    }

    return sendJson(response, 200, { perguntas: questions });
  } catch (error) {
    console.error("Falha ao solicitar perguntas à Groq:", error.message);
    return sendJson(response, 502, { error: "Não foi possível gerar perguntas agora. Tente novamente." });
  }
}

function isValidQuestion(question) {
  return question
    && typeof question.pergunta === "string"
    && question.pergunta.trim().length > 0
    && Array.isArray(question.alternativas)
    && question.alternativas.length === 4
    && question.alternativas.every((option) => typeof option === "string" && option.trim().length > 0)
    && Number.isInteger(question.respostaCorreta)
    && question.respostaCorreta >= 0
    && question.respostaCorreta < 4
    && typeof question.explicacao === "string"
    && question.explicacao.trim().length > 0;
}

async function readJsonBody(request) {
  const chunks = [];
  let size = 0;

  for await (const chunk of request) {
    size += chunk.length;
    if (size > 8192) {
      const error = new Error("A requisição é muito grande.");
      error.statusCode = 413;
      throw error;
    }
    chunks.push(chunk);
  }

  try {
    return JSON.parse(Buffer.concat(chunks).toString("utf8"));
  } catch {
    throw new Error("O corpo da requisição deve ser um JSON válido.");
  }
}

function serveFrontend(pathname, response) {
  const files = {
    "/": "index.html",
    "/index.html": "index.html",
    "/script.js": "script.js",
    "/styles.css": "styles.css"
  };
  const fileName = files[pathname];

  if (!fileName) return sendJson(response, 404, { error: "Página não encontrada." });

  const filePath = path.join(projectRoot, fileName);
  const contentTypes = {
    "index.html": "text/html; charset=utf-8",
    "script.js": "text/javascript; charset=utf-8",
    "styles.css": "text/css; charset=utf-8"
  };

  fs.readFile(filePath, (error, content) => {
    if (error) return sendJson(response, 404, { error: "Arquivo não encontrado." });
    response.writeHead(200, { "Content-Type": contentTypes[fileName] });
    response.end(content);
  });
}

function sendJson(response, statusCode, value) {
  response.writeHead(statusCode, { "Content-Type": "application/json; charset=utf-8" });
  response.end(JSON.stringify(value));
}

function loadEnvFile() {
  const envPath = path.join(__dirname, ".env");
  if (!fs.existsSync(envPath)) return;

  const lines = fs.readFileSync(envPath, "utf8").split(/\r?\n/);
  for (const line of lines) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith("#")) continue;

    const separator = trimmed.indexOf("=");
    if (separator < 1) continue;

    const key = trimmed.slice(0, separator).trim();
    let value = trimmed.slice(separator + 1).trim();
    if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) {
      value = value.slice(1, -1);
    }
    if (process.env[key] === undefined) process.env[key] = value;
  }
}

server.listen(port, () => {
  console.log(`TheraQ disponível em http://localhost:${port}`);
  if (!process.env.GROQ_API_KEY) {
    console.warn("GROQ_API_KEY não configurada. O site usará as perguntas locais.");
  }
});
// Variável global para armazenar as perguntas que vieram do banco
let listaDePerguntas = [];
let perguntaAtualIndex = 0;

async function carregarQuizDoBanco() {
  try {
    // Faz a requisição para a rota da API que criamos na Vercel
    const resposta = await fetch('/api/perguntas');
    
    if (!resposta.ok) {
      throw new Error('Falha ao buscar perguntas do servidor.');
    }

    listaDePerguntas = await resposta.json();
    
    console.log("Perguntas carregadas com sucesso:", listaDePerguntas);

    // Se houver perguntas, inicia o quiz na tela
    if (listaDePerguntas.length > 0) {
      mostrarPerguntaAtual();
    } else {
      alert("Nenhuma pergunta encontrada no banco de dados.");
    }

  } catch (erro) {
    console.error("Erro:", erro);
    alert("Não foi possível carregar o quiz.");
  }
}

function mostrarPerguntaAtual() {
  const pergunta = listaDePerguntas[perguntaAtualIndex];
  
  // Exemplo: preenchendo os elementos HTML da sua tela
  // Certifique-se de que os IDs abaixo correspondem ao seu HTML (ex: <h2 id="enunciado"></h2>)
  document.getElementById('enunciado').innerText = pergunta.enunciado;
  document.getElementById('btn-a').innerText = pergunta.opcao_a;
  document.getElementById('btn-b').innerText = pergunta.opcao_b;
  document.getElementById('btn-c').innerText = pergunta.opcao_c;
  document.getElementById('btn-d').innerText = pergunta.opcao_d;
}

// Executa a função assim que a página é totalmente carregada
window.onload = carregarQuizDoBanco;
