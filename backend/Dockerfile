FROM python:3.10

WORKDIR /app

COPY backend/ .
COPY config/gunicorn/ ./config

RUN pip install -r requirements.txt
RUN mkdir -pv /var/{log,run}/gunicorn

CMD ["gunicorn", "-c", "config/dev.py"]