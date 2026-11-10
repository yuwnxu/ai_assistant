# AI Психолог (ai_assistant)

Веб-приложение с чатами для эмоциональной поддержки. Состоит из двух частей:

* **Клиент** — Flutter Web (папка `lib/`), адаптивный: работает на компьютере и на телефоне.
* **Сервер** — Python + FastAPI (папка `backend/`): регистрация и вход, хранение переписки в SQLite,
  запросы к бесплатным нейросетям через [OpenRouter](https://openrouter.ai).
  Ключ API лежит только на сервере и в браузер не попадает.

```
Браузер (Flutter Web)  ──HTTP/JSON──▶  FastAPI  ──▶  OpenRouter ──▶ бесплатные модели
                                          │
                                       SQLite (пользователи, история чатов)
```

## Запуск на своём компьютере

### 1. Сервер

1. Получите бесплатный ключ на <https://openrouter.ai/keys> (карта не нужна).
2. В папке `backend`:

```bash
cd backend
python -m venv .venv && source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt
cp .env.example .env        # откройте .env и впишите OPENROUTER_API_KEY
uvicorn main:app --reload --port 8000
```

Документация API откроется на <http://localhost:8000/docs>. Тесты: `pytest`.

### 2. Клиент

```bash
flutter pub get
flutter run -d chrome
```

Адрес сервера клиент берёт из файла `web/config.json` (по умолчанию `http://localhost:8000`).

## Публикация (для демонстрации с телефона)

GitHub Pages умеет отдавать только статику, поэтому сервер нужно разместить отдельно.

1. На <https://render.com> выберите **New → Blueprint**, подключите этот репозиторий — файл `render.yaml` создаст сервис.
   В настройках сервиса вручную добавьте переменную `OPENROUTER_API_KEY`.
2. Скопируйте адрес сервиса (вида `https://ai-assistant-api.onrender.com`) и пересоберите сайт:

```bash
./build_web.sh https://ai-assistant-api.onrender.com
git add -A && git commit -m "Обновление сайта" && git push
```

> На бесплатном тарифе Render сервис «засыпает» после 15 минут простоя, а первый запрос после этого
> занимает около минуты — откройте сайт заранее перед защитой. База SQLite на бесплатном тарифе
> сбрасывается при каждом перезапуске, поэтому аккаунты лучше создать прямо перед показом.

## Бесплатные модели

Бесплатные модели OpenRouter часто переименовывают, поэтому сервер раз в час сам берёт из публичного списка
OpenRouter актуальные бесплатные текстовые модели (Llama, Gemma, Mistral, DeepSeek, Qwen и др.) и показывает пять из них.
Если выбранная модель не отвечает, пробуются остальные. Фиксированный список можно задать переменной
`OPENROUTER_MODELS` (см. `backend/.env.example`), список моделей: <https://openrouter.ai/models?max_price=0>.

## API

| Метод | Адрес | Описание |
|-------|-------|----------|
| POST | `/api/auth/register`, `/api/auth/login` | регистрация и вход, возвращают токен |
| GET / PATCH | `/api/me` | профиль (имя, тон общения) |
| GET | `/api/models` | список нейросетей |
| GET / DELETE | `/api/chats/{model}` | история и очистка чата |
| POST | `/api/chats/{model}/messages` | отправить сообщение, получить ответ |
