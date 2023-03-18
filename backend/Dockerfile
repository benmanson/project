FROM python:3.10

WORKDIR /app

RUN apt-get update -y && apt-get install -y tree netcat unzip

COPY backend/ .
COPY config/gunicorn /usr/src/app/config

# Download bootstrap and jquery
RUN wget https://code.jquery.com/jquery-3.6.4.min.js -O /app/static/js/jquery.3.6.4.min.js
RUN wget https://github.com/twbs/bootstrap/releases/download/v5.3.0-alpha1/bootstrap-5.3.0-alpha1-dist.zip -O /app/static/bootstrap-5.3.0-alpha1-dist.zip
RUN unzip /app/static/bootstrap-5.3.0-alpha1-dist.zip -d /app/static
RUN rm -rf /app/static/bootstrap-5.3.0-alpha1-dist*

RUN mkdir -pv /var/{log,run}/gunicorn

ENTRYPOINT [ "sh", "docker-entrypoint.sh" ]