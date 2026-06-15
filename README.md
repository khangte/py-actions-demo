# py-actions-demo

GitHub Actions CI/CD 파이프라인 데모 프로젝트입니다.

## 프로젝트 구조

```
py-actions-demo/
├── src/py_actions_demo/
│   └── app.py              # FastAPI 애플리케이션
├── tests/
│   └── test_endpoints_sync.py  # 엔드포인트 테스트
├── .github/workflows/
│   ├── ci.yml              # 린트 + 테스트 (main push/PR)
│   ├── docker-publish.yml  # Docker 이미지 빌드 & GHCR 푸시 (태그)
│   └── deploy.yml          # EC2 배포 (태그)
├── dockerfile
├── requirements.txt
└── pyproject.toml
```

## GitHub Actions 워크플로우

### `ci.yml` — 코드 품질 검사

- **트리거:** `main` 브랜치 push 또는 PR
- Python 3.12 설치 → 의존성 설치 → ruff 린트 → pytest 테스트

### `docker-publish.yml` — Docker 이미지 빌드 & 푸시

- **트리거:** `v*.*.*` 태그 push
- GHCR(GitHub Container Registry)에 이미지 빌드 & 푸시
- 태그: `v0.1.1`, `latest` 두 개 생성

### `deploy.yml` — EC2 배포

- **트리거:** `v*.*.*` 태그 push
- EC2에 SSH 접속 → `docker compose pull` → `docker compose up -d`

### 전체 흐름

```
push to main     →  ci.yml (린트 + 테스트)

push tag v*.*.*  →  docker-publish.yml (이미지 빌드 & GHCR 푸시)
                 →  deploy.yml (EC2 배포)
```

## 로컬 개발 환경 설정

```bash
# 1. 가상환경 생성 (최초 1회)
uv venv .venv

# 2. 활성화
source .venv/bin/activate

# 3. 의존성 설치 (최초 1회 or requirements.txt 변경 시)
pip install -r requirements.txt
pip install -e .

# 4. 테스트 실행
pytest -q

# 5. 린트
ruff check .
```

## 배포 순서

```bash
# 1. 로컬 검증
pytest -q && ruff check .

# 2. main push → ci.yml 트리거
git add .
git commit -m "feat: ..."
git push origin main

# 3. 태그 push → docker-publish + deploy 트리거
git tag v0.1.1
git push origin v0.1.1
```

## GitHub Secrets 설정 (EC2 배포 시 필요)

| Secret     | 설명                                |
| ---------- | ----------------------------------- |
| `SSH_HOST` | EC2 공인 IP 또는 도메인             |
| `SSH_USER` | EC2 접속 유저 (ec2-user, ubuntu 등) |
| `SSH_KEY`  | PEM 키 내용 (멀티라인)              |
