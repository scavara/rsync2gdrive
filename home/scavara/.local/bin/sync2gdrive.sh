#!/bin/sh

start_time=$(date +%s)

TODAY=$(date +%Y/%m/%d)
REMOTE_HOST=homeassistant.lan
REMOTE_USER=root
REMOTE_DIR=/media/usb-sda1/FTP
REMOTE_SUBDIRS="back-camera-1 backyard-camera-2 front-camera-1"
GDRIVE_DIR="Home Surveillance Recordings"
LOCAL_DIR="/home/scavara/gdrive"
RSYNC_CMD="/usr/bin/rsync"
RSYNC_ARGS="--compress --archive --update --quiet"

for subdir in $REMOTE_SUBDIRS
do
	ssh $REMOTE_USER@$REMOTE_HOST "ls \"$REMOTE_DIR/$subdir/$TODAY\"" # 2>/dev/null | \
	ssh $REMOTE_USER@$REMOTE_HOST "mkdir -p \"$REMOTE_DIR/$subdir/$TODAY\""
        if [ ! -d "$LOCAL_DIR/$GDRIVE_DIR/$subdir/$TODAY" ]
	then
	mkdir "$LOCAL_DIR/$GDRIVE_DIR/$subdir/$TODAY"
	fi
	rsync -e "ssh -l root" $RSYNC_ARGS "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/$subdir/$TODAY/" "$LOCAL_DIR/$GDRIVE_DIR/$subdir/$TODAY/"
done

end_time=$(date +%s)
runtime=$(echo "$end_time - $start_time" | bc)

if [ $runtime -lt 10 ] # proces metric sraper frequency is 10s
then
sleep 10
fi

