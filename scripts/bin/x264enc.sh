#!/bin/bash
infile="$1"
tmpfile="$1.mkv"
outfile="$1.mkv"
options="-vcodec libx264 -x264opts crf=20:keyint=240:min-keyint=200:colormatrix=bt709:level=3.1 \
		-filter:v yadif -acodec aac -strict experimental -ar 44100 -ab 128k"

ffmpeg -y -i "$infile" -threads 0 $options "$outfile"

