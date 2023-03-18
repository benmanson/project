FROM python:3.10

WORKDIR /app

RUN apt-get update -y && apt-get install -y tree netcat

COPY backend/ .
COPY config/gunicorn /usr/src/app/config

RUN mkdir -pv /var/{log,run}/gunicorn

ENTRYPOINT [ "sh", "docker-entrypoint.sh" ]