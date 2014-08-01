# Makefile for Anthon-Starter 0.2.0

EXENAME = anthon-starter

CC = gcc
RES = windres

CFLAGS = -O0 -g -Wall -pipe
LDFLAGS = -flto
DESTDIR =

COMP = rc.o main.o chkargs.o clrprint.o run.o init.o getsysinfo.o backup.o extract.o verify.o deploy.o help_message.o

all: $(COMP) link

rc.o:
	$(RES) -i ast.rc -o $(DESTDIR)rc.o

main.o:
	$(CC) $(CFLAGS) -c -o main.o main.c

chkargs.o:
	$(CC) $(CFLAGS) -c -o chkargs.o chkargs.c

clrprint.o:
	$(CC) $(CFLAGS) -c -o clrprint.o clrprint.c

run.o:
	$(CC) $(CFLAGS) -c -o run.o run.c

init.o:
	$(CC) $(CFLAGS) -c -o init.o init.c

getsysinfo.o:
	$(CC) $(CFLAGS) -c -o getsysinfo.o getsysinfo.c

backup.o:
	$(CC) $(CFLAGS) -c -o backup.o backup.c

extract.o:
	$(CC) $(CFLAGS) -c -o extract.o extract.c

verify.o:
	$(CC) $(CFLAGS) -c -o verify.o verify.c

deploy.o:
	$(CC) $(CFLAGS) -c -o deploy.o deploy.c

help_message.o:
	$(CC) $(CFLAGS) -c -o help_message.o help_message.c

link:
	$(CC) $(LDFLAGS) -o $(EXENAME).exe $(COMP)

clean:
	rm -f $(EXENAME).exe $(COMP)
