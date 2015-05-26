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

ifdef DEBUG
#   Debug option: should use 64-bits GDB to debug 64-bits executable.
    HOST ?= x86_64-w64-mingw32
else
#   Release option: should make sure that it can work on 32-bits computers.
    HOST ?= i686-w64-mingw32
endif

CC    := ${HOST}-gcc
LD    := ${HOST}-gcc
RES   := ${HOST}-windres

ifdef DEBUG
#   Debug option: to add debug information into the executable as much as possible.
    CFLAGS    = -O0 -ggdb3 -Wall -pipe
    LDFLAGS   =
    RCFLAGS   =
else
#   Release option: to optimize the executable as much as possible. (Except LTO)
    CFLAGS    = -O2 -Wall -pipe
    LDFLAGS   =
    RCFLAGS   =
endif

SRCDIR    = src
BUILDDIR  = build
DESTDIR  ?= $(shell pwd)

vpath %.c  ${SRCDIR}
vpath %.h  ${SRCDIR}
vpath %.rc ${SRCDIR}
vpath %.o  ${BUILDDIR}

.PHONY: all clean mkdir

OBJS := rc.o main.o chkargs.o run.o init.o getsysinfo.o backup.o extract.o verify.o deploy.o help_message.o oops.o notify.o md5sum.o fclrprintf.o duplicate.o mem_alloc.o

all: mkdir ast.exe

mkdir:
#	Make "./build" directory first (to store object files)
	-$@ -p ${BUILDDIR}

ast.exe: ${OBJS}
#	FIXME: Automatic variables not used. (not advanced enough :P)
	${LD} ${LDFLAGS} -o ${DESTDIR}/$@ $(foreach i,${OBJS},${BUILDDIR}/${i})

%.o: %.c ast.h
	${CC} ${CFLAGS} -c -o ${BUILDDIR}/$@ $<

rc.o: ast.rc
	${RES} ${RCFLAGS} -i $< -o ${BUILDDIR}/$@

clean:
	-rm -rf ${BUILDDIR}

