Anthon-Starter
==============

[![Travis-CI Build Status](https://travis-ci.org/AOSC-Dev/Anthon-Starter.svg?branch=0.2.5-devel)](https://travis-ci.org/AOSC-Dev/Anthon-Starter)
[![Coverity Project 2952](https://scan.coverity.com/projects/2952/badge.svg)](https://scan.coverity.com/projects/2952)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/AOSC-Dev/Anthon-Starter?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

Installation helper for AOSC OSes, written with C.

Homepage:[https://portal.anthonos.org/ast](https://portal.anthonos.org/ast)

Building
--------

```Bash
autoreconf -fis -Wall;
# -m32 is for our poor x86
CFLAGS='-O2 -pipe -Wall -m32' ./configure --target=i686-w64-mingw32;
make -j4
```

To build Anthon-Starter, you need these tools be installed:

- In Microsoft(R) Windows(R)
    - **i686-mingw-w64**
        - Cygwin, TDM-GCC-64, win-builds, all are okay.
    - **GNU Make** (of cource, and usually integrated in compiler toolkits)
- In Linux(R)
    - **binutils-mingw-w64-i686**
    - **gcc-mingw-w64-i686**

We are making experimental autotool builds.

These parameters are for TDM-GCC-64 (including mingw-w64),
and added `-m32` compiling options to generate x86 code.

Developers
----------

* Junde Yi <lmy441900@gmail.com>
* Tom Li <biergaizi@member.fsf.org>
* Jeff Bai <jeffbaichina@members.fsf.org>
* Mike Manilone <crtmike@gmail.com>
* Minhui Du <duminghui@126.com>
* Zixing Liu <liushuyu011@gmail.com>

For a full list of developers, refer to
[GitHub](https://github.com/AOSC-Dev/Anthon-Starter/graphs/contributors) or `git log`.

License
-------

Anthon-Starter is released under [GNU GPLv2](http://www.gnu.org/licenses/gpl.html) or later.
