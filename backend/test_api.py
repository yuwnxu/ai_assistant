import os, tempfile
os.environ["DB_PATH"] = os.path.join(tempfile.mkdtemp(), "t.db")
os.environ["OPENROUTER_API_KEY"] = "test"
os.environ["JWT_SECRET"] = "x" * 32

from fastapi.testclient import TestClient
import main

client = TestClient(main.app)


class FakeResp:
    def __init__(self, code, body=None):
        self.status_code, self._body = code, body or {}
    def json(self):
        return self._body


def fake_post_factory(fail_first=False):
    calls = []
    async def post(self, url, headers=None, json=None):
        calls.append(json["model"])
        if fail_first and len(calls) == 1:
            return FakeResp(429)
        return FakeResp(200, {"choices": [{"message": {"content": "Я рядом, расскажи подробнее."}}]})
    return post, calls


def auth(email="a@b.ru"):
    r = client.post("/api/auth/register", json={"email": email, "password": "secret1", "name": "Юля"})
    assert r.status_code == 200, r.text
    return {"Authorization": "Bearer " + r.json()["token"]}


def test_auth_flow():
    h = auth()
    assert client.post("/api/auth/register", json={"email": "a@b.ru", "password": "secret1"}).status_code == 409
    assert client.post("/api/auth/register", json={"email": "bad", "password": "secret1"}).status_code == 400
    assert client.post("/api/auth/login", json={"email": "a@b.ru", "password": "wrong!!"}).status_code == 401
    r = client.post("/api/auth/login", json={"email": "A@b.ru", "password": "secret1"})
    assert r.status_code == 200 and r.json()["user"]["name"] == "Юля"
    assert client.get("/api/me").status_code == 401
    assert client.get("/api/me", headers=h).json()["email"] == "a@b.ru"
    # пароль в базе не хранится открытым текстом
    with main.db() as c:
        assert "secret1" not in c.execute("select password_hash from users").fetchone()[0]


def test_profile_and_chat(monkeypatch):
    h = auth("c@d.ru")
    r = client.patch("/api/me", json={"name": "Аня", "tone": "Аналитический"}, headers=h)
    assert r.json()["tone"] == "Аналитический"
    assert client.patch("/api/me", json={"tone": "x"}, headers=h).status_code == 400

    post, calls = fake_post_factory(fail_first=True)
    monkeypatch.setattr("httpx.AsyncClient.post", post)
    r = client.post("/api/chats/m1/messages", json={"text": "Мне тревожно"}, headers=h)
    assert r.status_code == 200 and "рядом" in r.json()["text"]
    assert len(calls) >= 2 and calls[0] != calls[1]  # сработал запасной вариант
    chat = client.get("/api/chats/m1", headers=h).json()
    assert [m["isUser"] for m in chat] == [True, False]
    assert client.get("/api/chats/m2", headers=h).json() == []
    assert client.get("/api/chats/zzz", headers=h).status_code == 404
    client.delete("/api/chats/m1", headers=h)
    assert client.get("/api/chats/m1", headers=h).json() == []
    assert len(client.get("/api/models").json()) == 5


def test_free_model_discovery():
    data = [
        {"id": "meta-llama/llama-x:free", "name": "Llama X (free)", "context_length": 128000, "pricing": {"prompt": "0", "completion": "0"}, "architecture": {"output_modalities": ["text"]}},
        {"id": "google/gemma-y:free", "name": "Gemma Y (free)", "context_length": 32000, "pricing": {"prompt": "0", "completion": "0"}},
        {"id": "paid/model", "name": "Paid", "context_length": 128000, "pricing": {"prompt": "0.001", "completion": "0.002"}},
        {"id": "free/image-gen:free", "name": "Img", "context_length": 128000, "pricing": {"prompt": "0", "completion": "0"}, "architecture": {"output_modalities": ["image"]}},
    ]
    picked = main._pick_free_models(data)
    assert [m["model"] for m in picked] == ["meta-llama/llama-x:free", "google/gemma-y:free"]
    assert picked[0]["title"] == "Llama X" and picked[0]["key"] == "m1"
