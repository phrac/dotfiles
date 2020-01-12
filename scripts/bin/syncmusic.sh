#!/bin/sh

rsync -asLv goliath:/tank/media/playlist  ~/Music
~/bin/mkmp3.sh
~/bin/cmusu.sh

