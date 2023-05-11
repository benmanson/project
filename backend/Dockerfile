FROM python:3.11.3-bullseye
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV PYTHONDONTWRITEBYTECODE 1

WORKDIR /app

RUN apt-get update -y; apt-get install -y tree netcat unzip

COPY config/gunicorn /usr/src/app/config

# Download and install AWS CLI
RUN wget "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -O "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN rm -rf aws*

RUN mkdir -p /var/log/gunicorn
RUN mkdir -p /var/run/gunicorn

ENTRYPOINT [ "sh", "docker-entrypoint.sh" ]