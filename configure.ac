#!/bin/sh
# alternate syntax: sh                          -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.
# 
# TODO: decide CFLAGS based on $(uname) and --enable-debug, etc.

AC_PREREQ([2.69])
AC_INIT([Anthon-Starter], [0.2.5],[lmy441900@gmail.com])
AC_CONFIG_SRCDIR([src/])
AC_CONFIG_HEADERS([src/config.h])

# Checks for programs.
AC_PROG_CC

# Checks for libraries.

# Checks for header files.
AC_CHECK_HEADERS([fcntl.h memory.h stdlib.h string.h stdint.h],[],[AC_MSG_ERROR([Standard library includes missing.])])
AC_CHECK_HEADERS([commctrl.h richedit.h windows.h],[],[AC_MSG_ERROR([Windows library includes missing.])])

# Checks for typedefs, structures, and compiler characteristics.
AC_TYPE_SIZE_T

# Checks for library functions.
AC_FUNC_MALLOC
AC_FUNC_REALLOC
AC_CHECK_FUNCS([memset])

# ----------------------------------------------
# CHECKS FOR MACHINE/VENDOR/OPERATING SYSTEM TYPE
# ----------------------------------------------
# Find out machine type, vendor, and operating system
# What type of host is this?
AC_CANONICAL_HOST
AC_DEFINE_UNQUOTED(HOSTTYPE, "$host",
[Define to be the machine type (microprocessor class or machine model).])
AC_DEFINE_UNQUOTED(BUILDER,   "$build",
[Define to be a string corresponding the vendor of the machine.])
AC_DEFINE_UNQUOTED(CC_NAME,   "$CC",
[Define to be the name of the compiler.])

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
