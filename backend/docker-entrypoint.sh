#!/bin/sh
pip install --no-cache-dir -q -r requirements.txt

if [ ! -f "/var/www/localhost/static/js/jquery.3.6.4.min.js" ]; then
    wget https://github.com/twbs/bootstrap/releases/download/v5.3.0-alpha1/bootstrap-5.3.0-alpha1-dist.zip -O /var/www/localhost/static/bootstrap-5.3.0-alpha1-dist.zip
    unzip -o /var/www/localhost/static/bootstrap-5.3.0-alpha1-dist.zip -d /var/www/localhost/static
    mv /var/www/localhost/static/bootstrap-5.3.0-alpha1-dist/* /var/www/localhost/static
    rm -rf /var/www/localhost/static/bootstrap-5.3.0-alpha1-dist*
    wget https://code.jquery.com/jquery-3.6.4.min.js -O /var/www/localhost/static/js/jquery.3.6.4.min.js
fi

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