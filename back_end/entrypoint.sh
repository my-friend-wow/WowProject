#!/bin/bash
echo "0 15 * * * root /usr/bin/python3 /app/server/cron/reset_step_by_count.py" > /etc/cron.d/cronjob
chmod 644 /etc/cron.d/cronjob
crontab /etc/cron.d/cronjob

cron -f &

gunicorn -b 0.0.0.0:5000 run:app --error-logfile=/var/log/gunicorn/error.log --access-logfile=/var/log/gunicorn/access.log --max-requests 1000 --max-requests-jitter 50
