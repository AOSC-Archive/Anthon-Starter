# Makefile for Anthon-Starter 0.2.0

EXENAME = anthon-starter

CC = gcc
# RES = windres

CFLAGS = -O0 -g -Wall
LDFLAGS =
SRCDIR =
DESTDIR =

FILES = main.c chkargs.c clrprint.c run.c init.c getsysinfo.c backup.c extract.c verify.c deploy.c help_message.c

all:
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(EXENAME).exe $(FILES)

resource:
# 	$(RES) -i ast.rc -o $(DESTDIR)ast_rc.o

clean:
	rm -f $(EXENAME).exe
