FROM python:3.12-slim

RUN adduser docker-app01

WORKDIR /app
COPY requirements.txt .

RUN su - root -c 'pip install --no-cache-dir -r requirements.txt'

COPY . .

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

