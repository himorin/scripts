#! /bin/sh

# OPTIONS
#  1: directory to save
#  2: IP of AXIS cam
#  3: cam user
#  4: cam pass


TARGET_ROOT=$1/
TARGET_DATED=$TARGET_ROOT`date +"%Y%m%d"`/
TARGET_FNAME=$TARGET_DATED`date +"%H%M"`.jpg

mkdir -p $TARGET_DATED
wget --http-user=$3 \
     --http-password=$4 \
     -O $TARGET_FNAME \
     http://$2/jpg/1/image.jpg \
     2> /dev/null
if [ ! -s $TARGET_FNAME ]; then
  rm $TARGET_FNAME
fi

