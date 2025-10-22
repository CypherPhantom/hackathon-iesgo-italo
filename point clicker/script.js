const canvas = document.getElementById('game');
const ctx = canvas.getContext('2d', {alpha:false});
let w = canvas.width, h = canvas.height;

const hitsEl = document.getElementById('hits');
const missesEl = document.getElementById('misses');
const levelEl = document.getElementById('level');
const difficultyFill = document.getElementById('difficultyFill');
const flash = document.getElementById('flash');
const gameoverDiv = document.getElementById('gameover');
const finalstats = document.getElementById('finalstats');

const startBtn = document.getElementById('startBtn');
const pauseBtn = document.getElementById('pauseBtn');
const resetBtn = document.getElementById('resetBtn');
const restartBtn = document.getElementById('restartBtn');

const baseSizeInput = document.getElementById('baseSize');
const baseSpeedInput = document.getElementById('baseSpeed');
const maxMissInput = document.getElementById('maxMiss');

let baseRadius = parseInt(baseSizeInput.value,10);
let baseSpeed = Number(baseSpeedInput.value);
let maxMisses = parseInt(maxMissInput.value,10);

baseSizeInput.oninput = ()=> baseRadius = parseInt(baseSizeInput.value,10);
baseSpeedInput.oninput = ()=> baseSpeed = Number(baseSpeedInput.value);
maxMissInput.oninput = ()=> maxMisses = Math.max(1, parseInt(maxMissInput.value,10));

let running = false, paused=false;
let hits=0, misses=0, level=1;

function resetStats(){
  hits=0; misses=0; level=1;
  updateUI();
  gameoverDiv.style.display='none';
}

function updateUI(){
  hitsEl.textContent = hits;
  missesEl.textContent = misses;
  levelEl.textContent = level;
  // difficulty proportional to level; cap at 100%
  const pct = Math.min(100, Math.round((level/10)*20));
  difficultyFill.style.width = pct + '%';
}

resetStats();

// target state
let target = {
  x: w/2,
  y: h/2,
  vx: baseSpeed * (Math.random()<0.5?-1:1),
  vy: baseSpeed * (Math.random()<0.5?-1:1),
  r: baseRadius
};

// tune on hit: shrinkFactor and speed increase
const SHRINK_STEP = 0.92; // each hit multiplies radius
const SPEED_STEP = 1.15;  // each hit multiplies speed

function spawnTarget(randomize=true){
  target.r = baseRadius * Math.pow(SHRINK_STEP, hits); // smaller with hits
  target.x = Math.max(target.r+5, Math.min(w - target.r-5, (randomize ? (Math.random()*(w-2*target.r)+target.r) : w/2)));
  target.y = Math.max(target.r+5, Math.min(h - target.r-5, (randomize ? (Math.random()*(h-2*target.r)+target.r) : h/2)));
  // velocity scaled by baseSpeed and level
  const speed = baseSpeed * Math.pow(SPEED_STEP, hits) * (1 + level*0.05);
  // random direction
  const angle = Math.random()*Math.PI*2;
  target.vx = Math.cos(angle) * (speed * (Math.random()*0.4 + 0.8));
  target.vy = Math.sin(angle) * (speed * (Math.random()*0.4 + 0.8));
}

// simple beep with WebAudio
const audioCtx = new (window.AudioContext || window.webkitAudioContext)();
function beep(freq=440, duration=0.06, type='sine', vol=0.06){
  try{
    const o = audioCtx.createOscillator();
    const g = audioCtx.createGain();
    o.type = type;
    o.frequency.value = freq;
    g.gain.value = vol;
    o.connect(g);
    g.connect(audioCtx.destination);
    o.start();
    g.gain.exponentialRampToValueAtTime(0.0001, audioCtx.currentTime + duration);
    o.stop(audioCtx.currentTime + duration + 0.02);
  }catch(e){}
}

// rendering
function draw(){
  // background
  ctx.fillStyle = '#061526';
  ctx.fillRect(0,0,w,h);

  // target shadow
  ctx.beginPath();
  ctx.fillStyle = 'rgba(0,0,0,0.35)';
  ctx.ellipse(target.x+4, target.y+6, target.r*1.02, target.r*0.55, 0, 0, Math.PI*2);
  ctx.fill();

  // target
  const g = ctx.createLinearGradient(target.x - target.r, target.y - target.r, target.x + target.r, target.y + target.r);
  g.addColorStop(0, '#ffd86b');
  g.addColorStop(1, '#ff4d4d');
  ctx.beginPath();
  ctx.fillStyle = g;
  ctx.arc(target.x, target.y, target.r, 0, Math.PI*2);
  ctx.fill();

  // target center sparkle
  ctx.beginPath();
  ctx.fillStyle = 'rgba(255,255,255,0.25)';
  ctx.arc(target.x - target.r*0.25, target.y - target.r*0.25, Math.max(2, target.r*0.18), 0, Math.PI*2);
  ctx.fill();

  // HUD overlay small
  ctx.fillStyle = 'rgba(255,255,255,0.02)';
  ctx.fillRect(8,8,220,56);
  ctx.fillStyle = '#dbe9ff';
  ctx.font = '600 14px Inter, system-ui';
  ctx.fillText('Acertos: '+hits, 16, 28);
  ctx.fillText('Erros: '+misses, 16, 46);
}

// physics update
function step(dt){
  target.x += target.vx * dt;
  target.y += target.vy * dt;

  // bounce on edges
  if(target.x - target.r < 0){
    target.x = target.r;
    target.vx *= -1;
  }
  if(target.x + target.r > w){
    target.x = w - target.r;
    target.vx *= -1;
  }
  if(target.y - target.r < 0){
    target.y = target.r;
    target.vy *= -1;
  }
  if(target.y + target.r > h){
    target.y = h - target.r;
    target.vy *= -1;
  }
}

// main loop
let last = performance.now();
function loop(now){
  if(!running || paused) { last = now; requestAnimationFrame(loop); return; }
  const dt = Math.min(0.05, (now - last)/1000);
  last = now;
  // increase small difficulty over time
  step(dt);
  draw();
  requestAnimationFrame(loop);
}

// click handling
canvas.addEventListener('pointerdown', (e)=>{
  if(!running || paused) return;
  const rect = canvas.getBoundingClientRect();
  // convert to canvas coordinates (canvas may be scaled by CSS)
  const scaleX = canvas.width / rect.width;
  const scaleY = canvas.height / rect.height;
  const cx = (e.clientX - rect.left) * scaleX;
  const cy = (e.clientY - rect.top) * scaleY;

  const dx = cx - target.x;
  const dy = cy - target.y;
  const distSq = dx*dx + dy*dy;
  if(distSq <= target.r * target.r){
    // hit
    hits += 1;
    level = 1 + Math.floor(hits / 3); // level up every 3 hits
    // increase speed slightly and shrink (spawn will recalc r based on hits)
    // push the target away a bit for visual feedback
    const push = Math.max(30, target.r*1.2);
    const angle = Math.atan2(dy, dx);
    target.x += Math.cos(angle) * push;
    target.y += Math.sin(angle) * push;
    // randomize direction more
    const speedMul = Math.pow(SPEED_STEP, hits) * (1 + level*0.04);
    const newAngle = Math.random()*Math.PI*2;
    target.vx = Math.cos(newAngle) * baseSpeed * speedMul * (Math.random()*0.6 + 0.7);
    target.vy = Math.sin(newAngle) * baseSpeed * speedMul * (Math.random()*0.6 + 0.7);

    spawnTarget(false);
    updateUI();
    beep(880, 0.05, 'triangle', 0.08);
    // tiny visual pulse
    canvas.style.boxShadow = '0 0 0 rgba(255,255,255,0.0)';
    setTimeout(()=> canvas.style.boxShadow = '', 80);
  } else {
    // miss
    misses += 1;
    updateUI();
    beep(220, 0.12, 'sawtooth', 0.08);
    // flash red
    flash.style.opacity = '1';
    setTimeout(()=> flash.style.opacity = '0', 150);
    // small camera shake/target jitter
    const jitter = 6 + Math.min(20, misses*0.6);
    target.x = Math.max(target.r+1, Math.min(w-target.r-1, target.x + (Math.random()*2-1)*jitter));
    target.y = Math.max(target.r+1, Math.min(h-target.r-1, target.y + (Math.random()*2-1)*jitter));
    if(misses >= maxMisses){
      // game over
      running = false;
      paused = false;
      gameoverDiv.style.display = 'flex';
      finalstats.textContent = `Acertos: ${hits} — Erros: ${misses} — Nível: ${level}`;
    }
  }
});

// controls
startBtn.addEventListener('click', ()=>{
  if(!running){
    running = true;
    paused = false;
    // initialize and spawn
    resetStats();
    spawnTarget(true);
    last = performance.now();
    requestAnimationFrame(loop);
  }
});

pauseBtn.addEventListener('click', ()=>{
  if(!running) return;
  paused = !paused;
  pauseBtn.textContent = paused ? 'Retomar' : 'Pausar';
});

resetBtn.addEventListener('click', ()=>{
  running = false;
  paused = false;
  resetStats();
  spawnTarget(true);
  draw();
});

restartBtn.addEventListener('click', ()=>{
  running = true;
  paused = false;
  resetStats();
  spawnTarget(true);
  last = performance.now();
  requestAnimationFrame(loop);
});

// handle resize: maintain canvas internal resolution
function handleResize(){
  // keep canvas internal resolution fixed but adapt CSS size
  const containerWidth = Math.min(window.innerWidth - 80, 900);
  canvas.style.width = containerWidth + 'px';
  canvas.style.height = '600px';
}
window.addEventListener('resize', handleResize);
handleResize();

// initial paint
spawnTarget(true);
draw();

