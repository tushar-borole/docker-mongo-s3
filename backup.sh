#!/bin/bash

echo "Mongo backup started"
S3PATH="s3://"$S3_BUCKET"/"
S3BACKUP=$S3PATH`date +"%Y%m%d_%H%M%S"`.dump.gz
S3LATEST=$S3PATH"latest".dump.gz
mongodump --quiet  -u $MONGO_DB_APP_USERNAME -p "$MONGO_DB_APP_PASSWORD" -d $MONGO_DB_APP_DATABASE --gzip --archive | /usr/local/bin/aws s3 cp - $S3BACKUP
/usr/local/bin/aws s3 cp $S3BACKUP $S3LATEST
echo "Mongo backup completed successfully"
