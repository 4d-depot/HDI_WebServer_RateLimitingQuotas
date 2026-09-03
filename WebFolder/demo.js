// Démo Rate Limiting — 4D Web Server
// Toutes les requêtes visent la même URL de base.
const BASE_URL = 'http://127.0.0.1/runDemo';

// --- Etat global / statistiques ---
const stats = { total: 0, ok: 0, e429: 0 };
let burstRunning = false;

// --- Références DOM ---
const logEl = document.getElementById('log');
const statTotalEl = document.getElementById('statTotal');
const statOkEl = document.getElementById('statOk');
const stat429El = document.getElementById('stat429');
const burstProgressEl = document.getElementById('burstProgress');
const btnBurstStart = document.getElementById('btnBurstStart');
const btnBurstStop = document.getElementById('btnBurstStop');

// --- Utilitaires ---

// Construit une chaîne de la taille demandée (en octets, approximatif car UTF-8 sur 1 octet pour ces caractères)
function makeBody(sizeInBytes) {
  return 'x'.repeat(Math.max(0, sizeInBytes));
}

function timestamp() {
  const d = new Date();
  return d.toLocaleTimeString('fr-FR', { hour12: false }) + '.' + String(d.getMilliseconds()).padStart(3, '0');
}

function logLine(text, cssClass) {
  const line = document.createElement('div');
  if (cssClass) line.className = cssClass;
  line.textContent = text;
  logEl.appendChild(line);
  logEl.scrollTop = logEl.scrollHeight;
}

function updateStats() {
  statTotalEl.textContent = stats.total;
  statOkEl.textContent = stats.ok;
  stat429El.textContent = stats.e429;
}

// Envoie une requête et journalise le résultat.
// params: { method, body, querySize, newSession }
async function sendRequest({ method = 'GET', body = null, querySize = null, newSession = false } = {}) {
  let url = BASE_URL;
  if (querySize !== null) {
    url += '?size=' + encodeURIComponent(querySize);
  }

  const options = {
    method,
    credentials: newSession ? 'omit' : 'include', // 'omit' = pas de cookie envoyé => nouvelle session côté serveur
  };
  if (body !== null) {
    options.body = body;
    options.headers = { 'Content-Type': 'text/plain' };
  }

  const start = performance.now();
  stats.total++;

  try {
    const response = await fetch(url, options);
    const duration = Math.round(performance.now() - start);
    const buf = await response.arrayBuffer();
    const receivedBytes = buf.byteLength;
    const sentBytes = body ? body.length : 0;

    let cssClass = 'lok';
    if (response.status === 429) {
      stats.e429++;
      cssClass = 'l429';
    } else if (response.ok) {
      stats.ok++;
    }

    const retryAfter = response.headers.get('Retry-After');
    let details = `${timestamp()}  ${method.padEnd(4)} ${url}  →  ${response.status}  (${duration}ms, envoyé ${sentBytes}o, reçu ${receivedBytes}o)`;
    if (retryAfter !== null) details += `  Retry-After: "${retryAfter}"`;
    if (newSession) details += '  [nouvelle session]';

    logLine(details, cssClass);
    updateStats();
    return response;
  } catch (err) {
    logLine(`${timestamp()}  ${method.padEnd(4)} ${url}  →  ERREUR: ${err.message}`, 'lerr');
    updateStats();
    return null;
  }
}

// --- Requête unique : GET sans corps ---
document.getElementById('btnGetSimple').addEventListener('click', () => {
  sendRequest({ method: 'GET' });
});

// --- Requête unique : POST avec corps ---
document.getElementById('btnPostBody').addEventListener('click', () => {
  const size = parseInt(document.getElementById('bodySize').value, 10) || 0;
  sendRequest({ method: 'POST', body: makeBody(size) });
});

// --- Requête unique : GET avec taille de réponse demandée ---
document.getElementById('btnGetData').addEventListener('click', () => {
  const size = parseInt(document.getElementById('respSize').value, 10) || 0;
  sendRequest({ method: 'GET', querySize: size });
});

// --- Rafale de requêtes ---
function buildBurstRequestOptions() {
  const type = document.getElementById('burstType').value;
  const size = parseInt(document.getElementById('burstSize').value, 10) || 0;
  const newSession = document.getElementById('burstNewSession').checked;

  if (type === 'simple') return { method: 'GET', newSession };
  if (type === 'body') return { method: 'POST', body: makeBody(size), newSession };
  if (type === 'data') return { method: 'GET', querySize: size, newSession };
}

btnBurstStart.addEventListener('click', async () => {
  const count = parseInt(document.getElementById('burstCount').value, 10) || 0;
  const delay = parseInt(document.getElementById('burstDelay').value, 10) || 0;

  burstRunning = true;
  btnBurstStart.disabled = true;
  btnBurstStop.disabled = false;

  for (let i = 1; i <= count && burstRunning; i++) {
    burstProgressEl.textContent = `Requête ${i} / ${count}`;
    await sendRequest(buildBurstRequestOptions());
    if (delay > 0 && i < count) {
      await new Promise((resolve) => setTimeout(resolve, delay));
    }
  }

  burstProgressEl.textContent = burstRunning ? 'Rafale terminée' : 'Rafale arrêtée';
  burstRunning = false;
  btnBurstStart.disabled = false;
  btnBurstStop.disabled = true;
});

btnBurstStop.addEventListener('click', () => {
  burstRunning = false;
});

// --- Sessions concurrentes (nbSessions / nbGuestSessions) ---
document.getElementById('btnOpenSessions').addEventListener('click', async () => {
  const count = parseInt(document.getElementById('sessionCount').value, 10) || 0;
  for (let i = 1; i <= count; i++) {
    await sendRequest({ method: 'GET', newSession: true });
  }
});

// --- Divers ---
document.getElementById('btnClearLog').addEventListener('click', () => {
  logEl.innerHTML = '';
  stats.total = 0;
  stats.ok = 0;
  stats.e429 = 0;
  updateStats();
});
