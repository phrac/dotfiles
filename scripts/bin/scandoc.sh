#!/bin/bash
rm /tmp/tmp.tif
scanimage --format=tif --resolution 300 > /tmp/tmp.tif
convert -resize 50% /tmp/tmp.tif ./$1.pdf
