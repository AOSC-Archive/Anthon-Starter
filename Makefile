# Makefile for Anthon-Starter 0.2.0

EXENAME = anthon-starter

CC = gcc
# RES = windres

CFLAGS = -O2 -Wall
LDFLAGS =
SRCDIR =
DESTDIR =

all:
	$(CC) $(CCFLAGS) -o $(EXENAME).exe main.c help_message.c

resource:
# 	$(RES) -i ast.rc -o $(DESTDIR)ast_rc.o

clean:
	rm -f $(SRCDIR)*.o $(EXENAME).exe