#!/bin/sh
pip install -q -r requirements.txt

while ! nc -z db 3306; do
    echo "MySQL is unavailable - sleeping"
    sleep 2
done

echo "MySQL is up - executing commands...."
python manage.py makemigrations
python manage.py migrate

echo "Creating default superuser...."
echo "from django.contrib.auth import get_user_model;get_user_model().objects.create_superuser(username='admin', password='pass');" | python manage.py shell 2> /dev/null

python manage.py collectstatic --no-input

gunicorn -c /usr/src/app/config/dev.py