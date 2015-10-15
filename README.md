Anthon-Starter
==============

[![Travis-CI Build Status](https://travis-ci.org/AOSC-Dev/Anthon-Starter.svg?branch=0.2.0-devel)](https://travis-ci.org/AOSC-Dev/Anthon-Starter)
[![Coverity Project 2952](https://scan.coverity.com/projects/2952/badge.svg)](https://scan.coverity.com/projects/2952)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/AOSC-Dev/Anthon-Starter?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

Installation helper for AOSC OSes, written with C.

Homepage:[https://portal.anthonos.org/ast](https://portal.anthonos.org/ast)

Building
--------

To build Anthon-Starter, you need these tools be installed:

- In Microsoft(R) Windows(R)
    - **i686-mingw-w64**
        - Cygwin, TDM-GCC-64, win-builds, all are okay.
    - **GNU Make** (of cource, and usually integrated in compiler toolkits)
- In Linux(R)
    - **binutils-mingw-w64-i686**
    - **gcc-mingw-w64-i686**

At present we haven't prepared `configure` (autotools) yet, but we have specified these variables in `Makefile`:

````Makefile
HOST ?= i686-w64-mingw32
CC   := ${HOST}-gcc
LD   := ${HOST}-gcc
RES  := ${HOST}-windres
````

Unless knowing what you're doing, please use the pre-configured `${HOST}` variable. Mistakenly specify or empty this variable can be failed to compile.

**Note:** In file `Makefile.windows` we have specified some special variables (such as, shell commands) for Windows native toolchains:

````Makefile
HOST ?= x86_64-w64-mingw32
CC   := ${HOST}-gcc
LD   := ${HOST}-gcc
# Note: Often windres has no prefix.
RES  := windres

CFLAGS    = -m32 -O0 -g -Wall -pipe
LDFLAGS   = -m32
RCFLAGS   = --output-format=coff --target=pe-i386
````

These parameters are for TDM-GCC-64 (including mingw-w64),
and added x86_32 compiling options to cross-compile 32 bits program.

Developers
----------

* Junde Yi <lmy441900@gmail.com>
* Tom Li <biergaizi@member.fsf.org>
* Jeff Bai <jeffbaichina@members.fsf.org>
* Mike Manilone <crtmike@gmail.com>
* Minhui Du <duminghui@126.com>
* Zixing Liu <liushuyu011@gmail.com>

License
-------

Anthon-Starter is released under [GNU GPLv2](http://www.gnu.org/licenses/gpl.html) or later.
