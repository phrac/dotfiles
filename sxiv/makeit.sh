#!/bin/sh

doas make CC=clang CFLAGS="-I/usr/X11R6/include -I/usr/X11R6/include/freetype2 -I/usr/local/include -I/usr/local/include/inotify" LDFLAGS="-L/usr/X11R6/lib -L/usr/local/lib -L/usr/local/lib/inotify -linotify -Wl,-rpath /usr/local/lib/inotify" install
