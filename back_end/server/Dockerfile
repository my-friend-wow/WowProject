# .env 파일을 /back_end/server 안에 생성 후 실행하세요
FROM python:3.8-slim

WORKDIR /app

# using cache, pip install
COPY requirements.txt /app

RUN apt-get update && \
    apt-get install -y curl && \
    pip install --upgrade pip && \
    pip install -r ./requirements.txt

# copy all files & dirs
COPY . /app

# flask with gunicorn
ENV FLASK_APP=run

RUN mkdir -p /var/log/gunicorn && \
    touch /var/log/gunicorn/error.log && \
    touch /var/log/gunicorn/access.log

# mssql
RUN curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc && \
    curl https://packages.microsoft.com/config/debian/11/prod.list | tee /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql18

# cron job
RUN apt-get install -y python-is-python3

RUN apt-get install -y cron
RUN cp /app/cronjob /etc/cron.d/cronjob && \
    chmod +x /etc/cron.d/cronjob && \
    crontab /etc/cron.d/cronjob

EXPOSE 5000

# run shell
RUN chmod +x /app/entrypoint.sh
CMD ["./entrypoint.sh"]
