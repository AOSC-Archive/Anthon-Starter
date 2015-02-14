# Anthon-Starter: Installation helper for AOSC OS series, version 0.2.0
# Copyright (C) 2014-2015 Anthon Open Source Community
# This is a make file for Anthon-Starter 0.2.0.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

HOST ?= i686-w64-mingw32
CC   := ${HOST}-gcc
LD   := ${HOST}-gcc
RES  := ${HOST}-windres

CFLAGS    = -O0 -g -Wall -pipe
LDFLAGS   =
SRCDIR    = src
BUILDDIR  = build
DESTDIR  ?= $(shell pwd)

vpath %.c  ${SRCDIR}
vpath %.h  ${SRCDIR}
vpath %.rc ${SRCDIR}
vpath %.o  ${BUILDDIR}

.PHONY: all clean mkdir ast.exe

OBJS := rc.o main.o chkargs.o run.o init.o getsysinfo.o backup.o extract.o verify.o deploy.o help_message.o oops.o notify.o md5sum.o fclrprintf.o

all: mkdir ast.exe

mkdir:
#	Make "./build" directory first (to store object files)
	-$@ -p ${BUILDDIR}

ast.exe: ${OBJS}
#	FIXME: Automatic variables not used. (not advanced enouth :P)
	${LD} ${LDFLAGS} -o ${DESTDIR}/$@ $(foreach i,${OBJS},${BUILDDIR}/${i})

%.o: %.c ast.h
	${CC} ${CFLAGS} -c -o ${BUILDDIR}/$@ $<

rc.o: ast.rc
	${RES} -i $< -o ${BUILDDIR}/$@

clean:
	-rm -rf ${BUILDDIR}

