#FROM python:3.9-slim AS builder
#WORKDIR /app
#COPY . .
#RUN pip install -r requirements.txt

#FROM python:3.9-alpine
#RUN adduser -D appuser
#USER appuser
#WORKDIR /app
#COPY --from=builder /app /app
#CMD ["python","app.py"]

FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .

#RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r requirements.txt --default-timeout=100

COPY . .

CMD ["python","app.py"]
