# dwm version
VERSION = 6.1

# Customize below to fit your system

# paths
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man

X11INC = /usr/local/include
X11LIB = /usr/local/lib


XFTINC = -I/usr/local/include/freetype2
XFTLIBS = -L${X11LIB} -lXft
XFTFLAGS = -DXFT


# Xinerama, comment if you don't want it
XINERAMALIBS  = -lXinerama
XINERAMAFLAGS = -DXINERAMA

# includes and libs
INCS = -I${X11INC} ${XFTINC}
LIBS = -lc -L${X11LIB} -lX11 -lutil -lXext ${XINERAMALIBS} ${XFTLIBS}

# flags
CPPFLAGS = -D_BSD_SOURCE -D_POSIX_C_SOURCE=2 -DVERSION=\"${VERSION}\" ${XINERAMAFLAGS} ${XFTFLAGS}
#CFLAGS   = -g -std=c99 -pedantic -Wall -O0 ${INCS} ${CPPFLAGS}
CFLAGS   = -std=c99 -pedantic -Wall -Os ${INCS} ${CPPFLAGS}
LDFLAGS  = -s -lm ${LIBS}

# Solaris
#CFLAGS = -fast ${INCS} -DVERSION=\"${VERSION}\"
#LDFLAGS = ${LIBS}

# compiler and linker
CC = cc
