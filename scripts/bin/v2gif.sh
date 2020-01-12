#!/bin/sh

ffmpeg -i "$1" -ss $2 -t $3 -vf scale=350:-1 raw.gif
gifsicle --loop -O3 raw.gif > $4
rm raw.gif

