# Dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN python -m pip install --upgrade pip && pip install -r requirements.txt

COPY . .
RUN pip install -e .

# 데모: 컨테이너 실행 시 add(2,3) 출력
CMD ["uvicorn", "py_actions_demo.app:app", "--host", "0.0.0.0", "--port", "8000"]
