#!/usr/bin/env bash
mv ~/Downloads/*.{mp3,flac} ~/Music
cd ~/Music
find ~/Music -name '*.flac' | xargs -I $ ffmpeg -i $ -acodec libmp3lame "`basename $ .flac`".mp3
find ~/Music -name '*.flac' | xargs rm
