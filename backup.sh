#!/bin/bash
TODAY=`date '+%d-%m-%Y_%H_%M'`

TEMP_DIR=/home/wordpress/temp
BACKUP_NAME="wordpress"
DB_NAME="wordpress"
DB_USER="wordpress"
MYSQL_PWD="wordpress"
SITE_PATH=/home/wordpress/www
BACKUP_PATH=/mnt/yandex_backup

echo "Mount Yandex disk..."
mount -t davfs -o noexec https://webdav.yandex.ru $BACKUP_PATH

echo "Starting Backup..."/
mkdir $TEMP_DIR
mysqldump -u $DB_USER -p$MYSQL_PWD $DB_NAME > $TEMP_DIR/database.sql
tar --exclude="updraft" -zcf $TEMP_DIR/files.tar.gz $SITE_PATH
tar -zcf $BACKUP_NAME-$TODAY.tar.gz -C $TEMP_DIR .
cp $BACKUP_NAME-$TODAY.tar.gz $BACKUP_PATH

echo "Backup Complete [$(du -sh $BACKUP_NAME-$TODAY.tar.gz | awk '{print $1}')]"

echo "Cleanup..."
rm -Rf $TEMP_DIR
rm -rf $BACKUP_NAME-$TODAY.tar.gz

echo "Unmount Yandex disk..."
sleep 20
sync
umount $BACKUP_PATH
