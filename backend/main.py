"""Серверная часть AI Assistant (FastAPI).

Что делает сервер:
  * регистрация и вход (пароли хранятся только в виде хеша, вход по JWT-токену);
  * хранение истории переписки в SQLite;
  * проксирование сообщений в бесплатные модели через OpenRouter
    (ключ API лежит только на сервере и никогда не попадает в браузер).
"""
import hashlib
import hmac
import os
import re
import secrets
import sqlite3
import time
from collections import defaultdict, deque
from contextlib import contextmanager
from pathlib import Path
from typing import Optional

import httpx
import jwt
from fastapi import Depends, FastAPI, Header, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

BASE_DIR = Path(__file__).parent


def _load_dotenv() -> None:
    """Минимальная загрузка .env без внешних библиотек."""
    env_file = BASE_DIR / ".env"
    if not env_file.exists():
        return
    for line in env_file.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        os.environ.setdefault(key.strip(), value.strip())


_load_dotenv()

OPENROUTER_URL = os.getenv("OPENROUTER_URL", "https://openrouter.ai/api/v1/chat/completions")
JWT_SECRET = os.getenv("JWT_SECRET") or secrets.token_urlsafe(32)
JWT_TTL = 60 * 60 * 24 * 7  # токен живёт 7 дней
DB_PATH = os.getenv("DB_PATH", str(BASE_DIR / "data.db"))
MAX_MESSAGE_LEN = 2000
HISTORY_LIMIT = 20  # сколько последних сообщений отправляем модели
RATE_LIMIT = 12  # сообщений в минуту на пользователя (чтобы не выбить лимит бесплатного API)

# Бесплатные модели OpenRouter. Список бесплатных моделей меняется со временем,
# поэтому его можно переопределить переменной OPENROUTER_MODELS (см. .env.example).
DEFAULT_MODELS = (
    "m1|Llama 3.3 70B|meta-llama/llama-3.3-70b-instruct:free;"
    "m2|Gemma 3 27B|google/gemma-3-27b-it:free;"
    "m3|Mistral Small 3.1|mistralai/mistral-small-3.1-24b-instruct:free;"
    "m4|DeepSeek V3|deepseek/deepseek-chat-v3-0324:free;"
    "m5|Qwen3 235B|qwen/qwen3-235b-a22b:free"
)


def _parse_models(raw: str) -> list[dict]:
    models = []
    for part in raw.split(";"):
        bits = [b.strip() for b in part.split("|")]
        if len(bits) == 3 and all(bits):
            models.append({"key": bits[0], "title": bits[1], "model": bits[2]})
    return models


PINNED_MODELS = _parse_models(os.getenv("OPENROUTER_MODELS", ""))  # если задано вручную — используем только их
MODELS_URL = os.getenv("OPENROUTER_MODELS_URL", "https://openrouter.ai/api/v1/models")
MODELS_TTL = 3600  # список бесплатных моделей обновляем раз в час
SHOWN_MODELS = 5  # сколько нейросетей показываем в интерфейсе
# Семейства моделей, которые предпочитаем показывать (по порядку)
PREFERRED_FAMILIES = ["llama", "gemma", "mistral", "deepseek", "qwen", "gpt-oss", "glm", "nemotron"]
_models_cache: dict = {"at": 0.0, "models": []}


def _pick_free_models(data: list[dict]) -> list[dict]:
    """Выбирает из списка OpenRouter бесплатные текстовые модели."""
    free = []
    for m in data:
        try:
            pricing = m.get("pricing") or {}
            if float(pricing.get("prompt", 1)) != 0 or float(pricing.get("completion", 1)) != 0:
                continue
        except (TypeError, ValueError):
            continue
        arch = m.get("architecture") or {}
        if arch.get("output_modalities") not in (None, ["text"]) or int(m.get("context_length") or 0) < 8000:
            continue
        mid = m.get("id", "")
        if not mid or mid.startswith("openrouter/") or any(w in mid for w in ("embed", "vision", "image", "audio")):
            continue
        free.append({"model": mid, "title": re.sub(r"\s*\(free\)\s*$", "", m.get("name") or mid), "ctx": int(m.get("context_length") or 0)})
    free.sort(key=lambda m: -m["ctx"])

    chosen, used = [], set()
    for family in PREFERRED_FAMILIES:  # по одной модели от каждого семейства
        for m in free:
            if family in m["model"].lower() and m["model"] not in used:
                chosen.append(m)
                used.add(m["model"])
                break
    chosen += [m for m in free if m["model"] not in used]  # остальные — запасные
    return [{"key": f"m{i + 1}", "title": m["title"], "model": m["model"]} for i, m in enumerate(chosen)]


async def get_models() -> list[dict]:
    """Актуальный список моделей: заданный вручную, иначе бесплатные с OpenRouter (с запасным списком)."""
    if PINNED_MODELS:
        return PINNED_MODELS
    now = time.time()
    if _models_cache["models"] and now - _models_cache["at"] < MODELS_TTL:
        return _models_cache["models"]
    try:
        async with httpx.AsyncClient(timeout=10) as client:
            resp = await client.get(MODELS_URL)
        models = _pick_free_models(resp.json()["data"]) if resp.status_code == 200 else []
    except (httpx.HTTPError, KeyError, ValueError):
        models = []
    if models:
        _models_cache.update(at=now, models=models)
        return models
    return _models_cache["models"] or _parse_models(DEFAULT_MODELS)

TONES = {
    "Поддерживающий": "Общайся мягко и тепло, больше сопереживай, отражай чувства собеседника, задавай бережные уточняющие вопросы.",
    "Аналитический": "Общайся чётко и структурно: помогай разобрать ситуацию, найти причины и логические связи, предлагай рациональные шаги.",
}
DEFAULT_TONE = "Поддерживающий"

SYSTEM_PROMPT = (
    "Ты — AI-ассистент для эмоциональной поддержки в приложении «AI Психолог». "
    "Отвечай на русском языке, кратко (3–6 предложений), без осуждения. "
    "Ты не заменяешь врача или психотерапевта и не ставишь диагнозов. "
    "Если пользователь пишет о мыслях о самоубийстве или самоповреждении, мягко порекомендуй "
    "обратиться за срочной помощью: единый телефон доверия 8 (800) 2000 122 (бесплатно по РФ) или 112. "
    "{tone}{name}"
)


# ---------------------------------------------------------------- база данных
@contextmanager
def db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    try:
        yield conn
        conn.commit()
    finally:
        conn.close()


def init_db() -> None:
    with db() as conn:
        conn.executescript(
            """
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                email TEXT NOT NULL UNIQUE,
                name TEXT NOT NULL DEFAULT '',
                tone TEXT NOT NULL DEFAULT 'Поддерживающий',
                password_hash TEXT NOT NULL,
                created_at REAL NOT NULL
            );
            CREATE TABLE IF NOT EXISTS messages (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                model_key TEXT NOT NULL,
                role TEXT NOT NULL,
                content TEXT NOT NULL,
                created_at REAL NOT NULL
            );
            CREATE INDEX IF NOT EXISTS idx_messages_chat ON messages(user_id, model_key, id);
            """
        )


# ------------------------------------------------------------------- пароли
def hash_password(password: str) -> str:
    salt = secrets.token_bytes(16)
    digest = hashlib.scrypt(password.encode(), salt=salt, n=2**14, r=8, p=1)
    return f"{salt.hex()}${digest.hex()}"


def verify_password(password: str, stored: str) -> bool:
    try:
        salt_hex, digest_hex = stored.split("$")
        digest = hashlib.scrypt(password.encode(), salt=bytes.fromhex(salt_hex), n=2**14, r=8, p=1)
    except ValueError:
        return False
    return hmac.compare_digest(digest.hex(), digest_hex)


def make_token(user_id: int) -> str:
    return jwt.encode({"sub": str(user_id), "exp": int(time.time()) + JWT_TTL}, JWT_SECRET, algorithm="HS256")


def current_user(authorization: Optional[str] = Header(default=None)) -> sqlite3.Row:
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(401, "Требуется вход в аккаунт")
    try:
        payload = jwt.decode(authorization[7:], JWT_SECRET, algorithms=["HS256"])
        user_id = int(payload["sub"])
    except (jwt.PyJWTError, KeyError, ValueError):
        raise HTTPException(401, "Сессия истекла, войдите снова")
    with db() as conn:
        user = conn.execute("SELECT * FROM users WHERE id = ?", (user_id,)).fetchone()
    if user is None:
        raise HTTPException(401, "Пользователь не найден")
    return user


# ------------------------------------------------------------ схемы запросов
EMAIL_RE = re.compile(r"^[\w.+-]+@([\w-]+\.)+[\w-]{2,}$")


class Credentials(BaseModel):
    email: str = Field(max_length=254)
    password: str = Field(max_length=128)
    name: str = Field(default="", max_length=60)


class ProfileUpdate(BaseModel):
    name: Optional[str] = Field(default=None, max_length=60)
    tone: Optional[str] = None


class SendMessage(BaseModel):
    text: str = Field(min_length=1, max_length=MAX_MESSAGE_LEN)


# ---------------------------------------------------------------- приложение
app = FastAPI(title="AI Assistant API")
origins = [o.strip() for o in os.getenv("CORS_ORIGINS", "*").split(",") if o.strip()]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=False,  # токен передаётся заголовком, куки не нужны
    allow_methods=["*"],
    allow_headers=["*"],
)
init_db()
_recent: dict[int, deque] = defaultdict(deque)


def user_public(user: sqlite3.Row) -> dict:
    return {"email": user["email"], "name": user["name"], "tone": user["tone"]}


@app.get("/")
def root():
    return {"service": "AI Assistant API", "docs": "/docs", "health": "/api/health"}


@app.get("/api/health")
def health():
    return {"status": "ok", "ai_configured": bool(os.getenv("OPENROUTER_API_KEY"))}


@app.post("/api/auth/register")
def register(data: Credentials):
    email = data.email.strip().lower()
    if not EMAIL_RE.match(email):
        raise HTTPException(400, "Введите корректный email")
    if len(data.password) < 6:
        raise HTTPException(400, "Пароль должен быть не менее 6 символов")
    try:
        with db() as conn:
            cur = conn.execute(
                "INSERT INTO users (email, name, password_hash, created_at) VALUES (?, ?, ?, ?)",
                (email, data.name.strip(), hash_password(data.password), time.time()),
            )
            user_id = cur.lastrowid
            user = conn.execute("SELECT * FROM users WHERE id = ?", (user_id,)).fetchone()
    except sqlite3.IntegrityError:
        raise HTTPException(409, "Пользователь с таким email уже существует")
    return {"token": make_token(user_id), "user": user_public(user)}


@app.post("/api/auth/login")
def login(data: Credentials):
    email = data.email.strip().lower()
    with db() as conn:
        user = conn.execute("SELECT * FROM users WHERE email = ?", (email,)).fetchone()
    if user is None or not verify_password(data.password, user["password_hash"]):
        raise HTTPException(401, "Неверный email или пароль")
    return {"token": make_token(user["id"]), "user": user_public(user)}


@app.get("/api/me")
def me(user=Depends(current_user)):
    return user_public(user)


@app.patch("/api/me")
def update_me(data: ProfileUpdate, user=Depends(current_user)):
    name = user["name"] if data.name is None else data.name.strip()
    tone = user["tone"]
    if data.tone is not None:
        if data.tone not in TONES:
            raise HTTPException(400, "Неизвестный тон общения")
        tone = data.tone
    with db() as conn:
        conn.execute("UPDATE users SET name = ?, tone = ? WHERE id = ?", (name, tone, user["id"]))
    return {"email": user["email"], "name": name, "tone": tone}


@app.get("/api/models")
async def list_models():
    return [{"key": m["key"], "title": m["title"]} for m in (await get_models())[:SHOWN_MODELS]]


async def _get_model(key: str) -> dict:
    for m in (await get_models())[:SHOWN_MODELS]:
        if m["key"] == key:
            return m
    raise HTTPException(404, "Такой модели нет")


@app.get("/api/chats")
def chats_summary(user=Depends(current_user)):
    """Ключ чата, в котором пользователь писал последним (None, если он ещё не писал)."""
    with db() as conn:
        row = conn.execute("SELECT model_key FROM messages WHERE user_id = ? ORDER BY id DESC LIMIT 1", (user["id"],)).fetchone()
    return {"last": row["model_key"] if row else None}


@app.get("/api/chats/{model_key}")
async def get_chat(model_key: str, user=Depends(current_user)):
    await _get_model(model_key)
    with db() as conn:
        rows = conn.execute(
            "SELECT role, content FROM messages WHERE user_id = ? AND model_key = ? ORDER BY id",
            (user["id"], model_key),
        ).fetchall()
    return [{"text": r["content"], "isUser": r["role"] == "user"} for r in rows]


@app.delete("/api/chats/{model_key}")
async def clear_chat(model_key: str, user=Depends(current_user)):
    await _get_model(model_key)
    with db() as conn:
        conn.execute("DELETE FROM messages WHERE user_id = ? AND model_key = ?", (user["id"], model_key))
    return {"ok": True}


def _check_rate_limit(user_id: int) -> None:
    now = time.time()
    window = _recent[user_id]
    while window and now - window[0] > 60:
        window.popleft()
    if len(window) >= RATE_LIMIT:
        raise HTTPException(429, "Слишком много сообщений, подождите минуту")
    window.append(now)


async def ask_model(primary: dict, messages: list[dict]) -> str:
    """Спрашивает выбранную модель; если она недоступна — пробует остальные бесплатные."""
    api_key = os.getenv("OPENROUTER_API_KEY")
    if not api_key:
        raise HTTPException(503, "На сервере не задан OPENROUTER_API_KEY")
    candidates = [primary] + [m for m in (await get_models())[:8] if m["model"] != primary["model"]]
    headers = {
        "Authorization": f"Bearer {api_key}",
        "HTTP-Referer": "https://github.com/yuwnxu/ai_assistant",
        "X-Title": "AI Assistant",
    }
    last_error = "нет ответа"
    async with httpx.AsyncClient(timeout=45) as client:
        for model in candidates:
            try:
                resp = await client.post(
                    OPENROUTER_URL,
                    headers=headers,
                    json={"model": model["model"], "messages": messages, "max_tokens": 600},
                )
                if resp.status_code == 200:
                    text = resp.json()["choices"][0]["message"]["content"].strip()
                    if text:
                        return text
                    last_error = "пустой ответ"
                else:
                    last_error = f"HTTP {resp.status_code}, {model['model']}"
                    if resp.status_code in (401, 402):  # проблема с ключом — перебор моделей не поможет
                        break
            except (httpx.HTTPError, KeyError, IndexError, ValueError) as exc:
                last_error = type(exc).__name__
    raise HTTPException(502, f"ИИ сейчас недоступен ({last_error}). Попробуйте ещё раз через минуту")


@app.post("/api/chats/{model_key}/messages")
async def send_message(model_key: str, data: SendMessage, user=Depends(current_user)):
    model = await _get_model(model_key)
    text = data.text.strip()
    if not text:
        raise HTTPException(400, "Пустое сообщение")
    _check_rate_limit(user["id"])

    with db() as conn:
        rows = conn.execute(
            "SELECT role, content FROM messages WHERE user_id = ? AND model_key = ? ORDER BY id DESC LIMIT ?",
            (user["id"], model_key, HISTORY_LIMIT),
        ).fetchall()
    history = [{"role": r["role"], "content": r["content"]} for r in reversed(rows)]

    name = f" Обращайся к собеседнику по имени: {user['name']}." if user["name"] else ""
    system = SYSTEM_PROMPT.format(tone=TONES.get(user["tone"], TONES[DEFAULT_TONE]), name=name)
    reply = await ask_model(model, [{"role": "system", "content": system}, *history, {"role": "user", "content": text}])

    now = time.time()
    with db() as conn:
        conn.executemany(
            "INSERT INTO messages (user_id, model_key, role, content, created_at) VALUES (?, ?, ?, ?, ?)",
            [(user["id"], model_key, "user", text, now), (user["id"], model_key, "assistant", reply, now)],
        )
    return {"text": reply, "isUser": False}
