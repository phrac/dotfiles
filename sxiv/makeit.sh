#!/bin/sh

make CC=clang CFLAGS="-I/usr/local/include -I/usr/local/include/freetype2 -I/usr/local/include -I/usr/local/include/inotify" LDFLAGS="-L/usr/local/lib -L/usr/local/lib -L/usr/local/lib/inotify -linotify -Wl"
doas make install
