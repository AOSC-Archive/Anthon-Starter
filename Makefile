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

# Pseudo Makefile, true Makefiles are in build/

ifdef WIN32
    SRCDIR    = $(shell cd)\\src
    BUILDDIR  = $(shell cd)\\build
    DESTDIR  ?= $(shell cd)\\
else
    SRCDIR    = $(shell pwd)/src
    BUILDDIR  = $(shell pwd)/build
    DESTDIR  ?= $(shell pwd)
endif

# ========== Compiler settings
ifdef DEBUG
#   Debug option: should use 64-bits GDB to debug 64-bits executable.
    HOST ?= x86_64-w64-mingw32
else
ifndef WIN32
#   Release option: should make sure that it can work on 32-bits computers.
#   Windows native toolchain (TDM-GCC-64) needn't to do it.
    HOST ?= i686-w64-mingw32
endif
endif

CC := ${HOST}-gcc
LD := ${HOST}-gcc
ifdef WIN32
    RES := windres
else
    RES := ${HOST}-windres
endif

# ========== Parameter settings
ifdef DEBUG
#   Debug option: should use 64-bits GDB to debug 64-bits executable (without -m32).
ifdef WIN32
    CFLAGS  = -O0 -ggdb3 -Wall -pipe
    LDFLAGS =
    RCFLAGS = --output-format=coff
else
    CFLAGS  = -O0 -ggdb3 -Wall -pipe
    LDFLAGS =
    RCFLAGS =
endif
else
#   Release option: should make sure that it can work on 32-bits computers (with -m32).
ifdef WIN32
    CFLAGS  = -m32 -O0 -Wall -pipe
    LDFLAGS = -m32
    RCFLAGS = --output-format=coff --target=pe-i386
else
    CFLAGS  = -O0 -Wall -pipe
    LDFLAGS =
    RCFLAGS =
endif
endif

# ========== Makefile settings
ifdef WIN32
    MKFILE = Makefile.win32.mk
else
    MKFILE = Makefile.posix.mk
endif

# ========== Just do it
export SRCDIR BUILDDIR DESTDIR HOST CC LD RES CFLAGS LDFLAGS RCFLAGS MAKEFLAGS
.PHONY: all clean

all:
	cd ${BUILDDIR} && $(MAKE) -f ${MKFILE}

clean:
	cd ${BUILDDIR} && $(MAKE) -f ${MKFILE} clean
