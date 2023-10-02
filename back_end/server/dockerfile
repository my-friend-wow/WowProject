FROM python:3.8-slim

WORKDIR /app

COPY . .

ENV PYTHONPATH=/app/server
ENV FLASK_APP=run

RUN sudo apt-get update && \
    pip install --upgrade pip && \
    pip install --no-cache-dir -r ./requirements.txt

RUN sudo su && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    exit

RUN sudo ACCEPT_EULA=Y apt-get install msodbcsql18

EXPOSE 5000

CMD ["python3", "run.py"]
