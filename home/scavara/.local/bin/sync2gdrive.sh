#!/bin/sh
TODAY=$(date +%Y/%m/%d)
REMOTE_HOST=homeassistant.lan
REMOTE_USER=root
REMOTE_DIR=/media/usb-sda1/FTP
REMOTE_SUBDIRS="back-camera-1 backyard-camera-2 front-camera-1"
GDRIVE_DIR="Home Surveillance Recordings"
LOCAL_DIR="$HOME/gdrive"
RSYNC_CMD="/usr/bin/rsync"
RSYNC_ARGS="--compress --archive --update --quiet --mkpath"

for subdir in $REMOTE_SUBDIRS
do
	ssh $REMOTE_USER@$REMOTE_HOST "ls \"$REMOTE_DIR/$subdir/$TODAY\"" 2>/dev/null | \
	ssh $REMOTE_USER@$REMOTE_HOST "mkdir -p \"$REMOTE_DIR/$subdir/$TODAY\"" 
	$RSYNC_CMD $RSYNC_ARGS "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/$subdir/$TODAY/" "$LOCAL_DIR/$GDRIVE_DIR/$subdir/$TODAY/"
done
