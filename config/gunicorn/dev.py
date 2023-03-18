accesslog = errorlog = "/var/log/gunicorn/dev.log"

loglevel = "debug"

wsgi_app = "benmanson.wsgi:application"
bind = "0.0.0.0:8000"
workers = 2

reload = True
reload_extra_files = "/app/templates"
capture_output = True
