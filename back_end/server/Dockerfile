# .env 파일을 /back_end/server 안에 생성 후 실행하세요
FROM debian:11
FROM python:3.8-slim

WORKDIR /app

COPY . .

ENV PYTHONPATH=/app/server
ENV FLASK_APP=run

RUN mkdir -p /var/log/gunicorn
RUN touch /var/log/gunicorn/error.log && \
    touch /var/log/gunicorn/access.log

RUN apt-get update && \
    apt-get install -y curl && \
    pip install --upgrade pip && \
    pip install --no-cache-dir -r ./requirements.txt

RUN curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc
RUN curl https://packages.microsoft.com/config/debian/11/prod.list | tee /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18

EXPOSE 5000

CMD ["gunicorn", "-b", "0.0.0.0:5000", "run:app", "--error-logfile=/var/log/gunicorn/error.log", "--access-logfile=/var/log/gunicorn/access.log", "--max-requests", "1000", "--max-requests-jitter", "50"]
