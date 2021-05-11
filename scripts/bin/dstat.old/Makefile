# $Id: Makefile 34 2017-06-21 19:57:22Z umaxx $
# Copyright (c) 2016-2017 Joerg Jung <mail@umaxx.net>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

CC?=gcc
INSTALL?=install
RM?=rm -f

PREFIX?=/usr/local

BINDIR?=$(PREFIX)/bin
INCDIR?=$(PREFIX)/include
LIBDIR?=$(PREFIX)/lib
MANDIR?=$(PREFIX)/man

CFLAGS?=-Os
CFLAGS+=-ansi -pedantic -Wall -Wextra
CFLAGS+=-Isrc -I/usr/include -I$(INCDIR) -I/usr/X11R6/include

LDFLAGS+=-L/usr/lib -L$(LIBDIR) -L/usr/X11R6/lib

LIBS+=-lX11 -lutil

OBJECTS=dstat.o

all: dstat

.c.o:
	$(CC) -c $(CFLAGS) -o $@ $<

dstat: $(OBJECTS)
	$(CC) $(LDFLAGS) -o dstat $(OBJECTS) $(LIBS)

clean:
	$(RM) $(OBJECTS) dstat dstat.core

install: dstat
	$(INSTALL) -m0755 dstat $(BINDIR)
	$(INSTALL) -m0444 dstat.1 $(MANDIR)/man1

uninstall:
	$(RM) $(BINDIR)/dstat $(MANDIR)/man1/dstat.1

.PHONY: all clean install uninstall
