#!/usr/bin/env bash
rm /tmp/mpd.fifo
mkfifo /tmp/mpd.fifo

while :; do socat -d -d -T 1 -u UDP4-LISTEN:5555 OPEN:/tmp/mpd.fifo; done

