#!/bin/bash






CRON_SCHEDULE=$CRON_SCHEDULE
CRON_ENVIRONMENT="
MONGO_INITDB_ROOT_USERNAME=$MONGO_INITDB_ROOT_USERNAME
MONGO_INITDB_ROOT_PASSWORD=$MONGO_INITDB_ROOT_PASSWORD
MONGO_DB_APP_USERNAME=$MONGO_DB_APP_USERNAME
MONGO_DB_APP_PASSWORD=$MONGO_DB_APP_PASSWORD
MONGO_DB_APP_DATABASE=$MONGO_DB_APP_DATABASE
AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
S3_BUCKET=$S3_BUCKET
MONGO_PORT=$MONGO_PORT
"



mongod --bind_ip_all

if [[ "$1" == 'no-cron' ]]; then
    exec /script/backup.sh
else
    LOGFIFO='/var/log/cron.fifo'
    if [[ ! -e "$LOGFIFO" ]]; then
        mkfifo "$LOGFIFO"
    fi
    echo -e "$CRON_ENVIRONMENT\n$CRON_SCHEDULE /script/backup.sh > $LOGFIFO 2>&1" | crontab -
    crontab -l
    cron
    tail -f "$LOGFIFO"
fi

