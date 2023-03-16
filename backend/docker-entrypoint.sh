#!/bin/sh
while ! nc -z db 3306; do
    echo "MySQL is unavailable - sleeping"
    sleep 2
done

echo "MySQL is up - executing commands...."
python manage.py makemigrations
python manage.py migrate
python manage.py collectstatic --no-input

gunicorn -c /usr/src/app/config/dev.py