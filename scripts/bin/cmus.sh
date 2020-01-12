#!/bin/sh
echo -n `cmus-remote -Q | grep "tag artist" | sed s/"tag artist"/""/g | sed '1s/^.//' | head -n 1`
echo -n " - "
echo -n `cmus-remote -Q | grep "tag title" | sed s/"tag title"/""/g |  sed '1s/^.//'`
echo -n " ("
s=`cmus-remote -Q | grep "status" | sed s/"status"/""/g |  sed '1s/^.//'`
if [[ $s = "playing" ]] then
    status=""
else
    status=""
fi
echo -n $status
echo -n ")"
