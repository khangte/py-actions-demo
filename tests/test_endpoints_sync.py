from fastapi.testclient import TestClient
from py_actions_demo.app import app

client = TestClient(app)  # 동기 클라이언트

def test_health():
    res = client.get("/health")
    assert res.status_code == 200
    assert res.json() == {"ok": True}

def test_add_ok():
    res = client.get("/add", params={"a": 2, "b": 3})
    assert res.status_code == 200
    assert res.json() == {"result": 5}
