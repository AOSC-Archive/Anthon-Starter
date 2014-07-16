# Makefile for Anthon-Starter 0.2.0

EXENAME = anthon-starter

CC = gcc
# RES = windres

CFLAGS = -O0 -g -Wall
LDFLAGS =
SRCDIR =
DESTDIR =

all:
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(EXENAME).exe main.c chkargs.c run.c help_message.c

resource:
# 	$(RES) -i ast.rc -o $(DESTDIR)ast_rc.o

clean:
	rm -f $(EXENAME).exe
