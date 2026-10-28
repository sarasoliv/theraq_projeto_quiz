// ==========================================================
// TheraQ - Configuração e elementos da interface
// ==========================================================
const RANKING_KEY = 'techq-rank';
const els = {
  introScreen: document.querySelector('.screen-intro'),
  quizScreen: document.querySelector('.screen-quiz'),
  finalScreen: document.querySelector('.screen-final'),
  sidebar: document.querySelector('.sidebar'),
  mainLayout: document.querySelector('.main-layout'),
  startQuizButton: document.getElementById('start-quiz-btn'),
  confirmButton: document.getElementById('confirm-answer'),
  finalButton: document.getElementById('play-again'),
  playerNameInput: document.getElementById('player-name'),
  questionText: document.getElementById('question-text'),
  topbarStatus: document.getElementById('topbar-status'),
  answersContainer: document.getElementById('answers-container'),
  explanationBox: document.getElementById('explanation-box'),
  explanationText: document.getElementById('explanation-text'),
  finalScore: document.getElementById('final-score'),
  finalRankingList: document.getElementById('final-ranking-list'),
  sessionRankingList: document.getElementById('session-ranking-list'),
  statusPill: document.getElementById('status-pill')
};

// ==========================================================
// Banco de questões do quiz
// ==========================================================
let questions = [];

// Função para buscar as perguntas do banco SQL assim que a página abrir
async function carregarPerguntasDoBanco() {
  try {
    const resposta = await fetch('/api/perguntas'); // Chama a rota da API da Vercel
    if (!resposta.ok) throw new Error('Erro ao carregar do banco');

    questions = await resposta.json();
    console.log("Perguntas carregadas do banco:", questions);

    // Se o seu código tiver uma função para iniciar o quiz (ex: iniciarJogo ou carregarPrimeiraPergunta), chame-a aqui:
    iniciarQuiz();
  } catch (erro) {
    console.error("Erro ao buscar perguntas:", erro);
    alert("Não foi possível carregar as perguntas do banco de dados.");
  }
}

// Chame essa função quando a página carregar
window.addEventListener('DOMContentLoaded', carregarPerguntasDoBanco);
// ==========================================================
// Estado atual da partida
// ==========================================================
const state = {
  currentQuestionIndex: 0,
  selectedAnswerIndex: null,
  answered: false,
  playerName: '',
  score: 0
};

// ==========================================================
// Armazenamento local do ranking
// ==========================================================
const readStorage = (key) => {
  const stored = localStorage.getItem(key);
  if (!stored) return [];

  try {
    return JSON.parse(stored);
  } catch {
    return [];
  }
};

const writeStorage = (key, value) => localStorage.setItem(key, JSON.stringify(value));
const getRanking = () => readStorage(RANKING_KEY);
const saveRanking = (ranking) => writeStorage(RANKING_KEY, ranking);
const updateTopbar = () => {
  els.topbarStatus.textContent = `${state.currentQuestionIndex + 1} / ${questions.length}`;
};

// ==========================================================
// Navegação entre telas
// ==========================================================

function showScreen(screenName) {
  Object.entries({ intro: els.introScreen, quiz: els.quizScreen, final: els.finalScreen })
    .forEach(([name, el]) => el.classList.toggle('active', name === screenName));

  els.sidebar.classList.remove('hidden');
  els.mainLayout.classList.remove('single-column');

  if (screenName === 'quiz') {
    els.sidebar.classList.add('hidden');
    els.mainLayout.classList.add('single-column');
    els.statusPill.classList.remove('hidden');
    updateTopbar();
  } else {
    els.statusPill.classList.add('hidden');
  }
}

// ==========================================================
// Ranking e renderização da interface
// ==========================================================
function renderSidebarRanking() {
  const ranking = getRanking()
    .filter((entry) => entry && entry.nickname)
    .sort((a, b) => b.score - a.score || a.nickname.localeCompare(b.nickname));

  els.sessionRankingList.innerHTML = '';

  if (!ranking.length) {
    els.sessionRankingList.innerHTML = `
      <li>
        <span class="rank-number">0</span>
        <span class="player-name">Nenhum jogador</span>
        <span class="score">-</span>
      </li>
    `;
    return;
  }

  ranking.slice(0, 8).forEach((entry, index) => {
    const item = document.createElement('li');
    item.innerHTML = `
      <span class="rank-number">${index + 1}</span>
      <span class="player-name">${entry.nickname}</span>
      <span class="score">${entry.score}</span>
    `;
    els.sessionRankingList.appendChild(item);
  });
}

function renderQuestion() {
  const question = questions[state.currentQuestionIndex];
  state.selectedAnswerIndex = null;
  state.answered = false;

  els.questionText.textContent = question.question;
  updateTopbar();
  els.explanationBox.classList.add('hidden');
  els.explanationText.textContent = '';
  els.confirmButton.textContent = 'Confirmar resposta';
  els.confirmButton.disabled = false;
  els.answersContainer.innerHTML = '';

  question.options.forEach((option, index) => {
    const label = document.createElement('label');
    const input = document.createElement('input');
    const mark = document.createElement('span');
    const text = document.createElement('span');
    const status = document.createElement('span');

    label.className = 'option-item';
    input.type = 'radio';
    input.name = 'answer';
    input.value = index;
    input.addEventListener('change', ({ target }) => {
      state.selectedAnswerIndex = Number(target.value);
      document.querySelectorAll('.option-item').forEach((item) => {
        item.classList.toggle('selected', item.querySelector('input').checked);
      });
    });

    mark.className = 'radio-mark';
    text.className = 'option-text';
    text.textContent = option;
    status.className = 'option-status';

    label.append(input, mark, text, status);
    els.answersContainer.appendChild(label);
  });
}

// ==========================================================
// Feedback da resposta e explicação
// ==========================================================
function showAnswerFeedback() {
  const question = questions[state.currentQuestionIndex];
  document.querySelectorAll('.option-item').forEach((item, index) => {
    const input = item.querySelector('input');
    const status = item.querySelector('.option-status');
    input.disabled = true;
    item.classList.remove('selected', 'correct', 'wrong');

    if (Number(input.value) === state.selectedAnswerIndex) item.classList.add('selected');
    if (index === question.correctIndex) {
      item.classList.add('correct');
      status.textContent = 'Correta';
    }
    if (index === state.selectedAnswerIndex && index !== question.correctIndex) {
      item.classList.add('wrong');
      status.textContent = 'Incorreta';
    }
  });

  els.explanationText.textContent = question.explanation;
  els.explanationBox.classList.remove('hidden');
  els.confirmButton.textContent = state.currentQuestionIndex === questions.length - 1 ? 'Ver resultado' : 'Próxima questão';
}

function updateGlobalRanking() {
  const ranking = getRanking()
    .filter((entry) => entry && entry.nickname)
    .concat({ nickname: state.playerName, score: state.score })
    .filter((entry, index, array) => array.findIndex((item) => item.nickname.toLowerCase() === entry.nickname.toLowerCase()) === index)
    .sort((a, b) => b.score - a.score || a.nickname.localeCompare(b.nickname));

  saveRanking(ranking);
  renderSidebarRanking();

  els.finalRankingList.innerHTML = '';
  ranking.slice(0, 5).forEach((item, index) => {
    const li = document.createElement('li');
    li.innerHTML = `<span>${index + 1}. ${item.nickname}</span><strong>${item.score} pts</strong>`;
    els.finalRankingList.appendChild(li);
  });
}

function finishQuiz() {
  updateGlobalRanking();
  els.finalScore.textContent = `${state.score} / ${questions.length}`;
  showScreen('final');
}

// ==========================================================
// Fluxo do quiz
// ==========================================================
function nextStep() {
  if (!state.answered) {
    alert('Selecione uma alternativa antes de confirmar.');
    return;
  }

  state.currentQuestionIndex += 1;
  if (state.currentQuestionIndex < questions.length) {
    renderQuestion();
    showScreen('quiz');
    return;
  }

  finishQuiz();
}

function startQuiz() {
  const name = els.playerNameInput.value.trim();

  if (!name) {
    els.playerNameInput.focus();
    els.playerNameInput.placeholder = 'Digite seu nickname antes de iniciar';
    return;
  }

  state.playerName = name;
  state.currentQuestionIndex = 0;
  state.score = 0;
  renderQuestion();
  showScreen('quiz');
}

// ==========================================================
// Eventos e inicialização
// ==========================================================
els.startQuizButton.addEventListener('click', startQuiz);
els.confirmButton.addEventListener('click', () => {
  if (state.selectedAnswerIndex === null) {
    alert('Selecione uma alternativa antes de confirmar.');
    return;
  }

  if (state.answered) {
    nextStep();
    return;
  }

  if (state.selectedAnswerIndex === questions[state.currentQuestionIndex].correctIndex) state.score += 1;
  state.answered = true;
  showAnswerFeedback();
});
els.finalButton.addEventListener('click', () => {
  els.playerNameInput.value = '';
  els.playerNameInput.placeholder = 'Digite seu nickname';
  state.currentQuestionIndex = 0;
  state.score = 0;
  state.playerName = '';
  renderSidebarRanking();
  showScreen('intro');
});

showScreen('intro');
renderSidebarRanking();
updateTopbar();

els.playerNameInput.addEventListener('keydown', (event) => {
  if (event.key === 'Enter') {
    startQuiz();
  }
});
