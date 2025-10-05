# Dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY . .

RUN python -m pip install --upgrade pip && pip install -e .

# 데모: 컨테이너 실행 시 add(2,3) 출력
CMD ["python", "-c", "from py_actions_demo import add; print(add(2,3))"]
