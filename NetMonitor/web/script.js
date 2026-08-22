const downEl = document.getElementById('down');
const upEl   = document.getElementById('up');
const totalEl = document.getElementById('total');
const timeEl  = document.getElementById('time');

function updateClock() {
  const now = new Date();
  timeEl.textContent = now.toLocaleTimeString();
}

async function fetchStats() {
  try {
    const res = await fetch('/data');
    if (!res.ok) throw new Error('Network error');
    const data = await res.json();
    downEl.textContent  = data.down  ?? '--';
    upEl.textContent    = data.up    ?? '--';
    totalEl.textContent = data.total ?? '--';
  } catch (e) {
    downEl.textContent = '⚠️';
    upEl.textContent   = '⚠️';
    totalEl.textContent = '⚠️';
  }
}

updateClock();
setInterval(() => { updateClock(); fetchStats(); }, 1000);
fetchStats();
