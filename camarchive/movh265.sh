#! /bin/bash

TARGET_DIR=`date +"%Y%m%d" --date '-1 day'`
TMP_FLIST=tmpfname

cd $1
find $TARGET_DIR -name '*.jpg' | awk '{print "file '\''" $1 "'\''"}' > $TMP_FLIST
ffmpeg -f concat -i $TMP_FLIST -r 10 -an -crf 28 -c:v libx265 -preset veryfast -pix_fmt yuv420p $TARGET_DIR.mp4

