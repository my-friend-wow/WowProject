#!/bin/bash
cron -f &

gunicorn -b 0.0.0.0:5000 run:app --error-logfile=/var/log/gunicorn/error.log --access-logfile=/var/log/gunicorn/access.log --max-requests 1000 --max-requests-jitter 50
