# Makefile for Anthon-Starter 0.2.0

EXENAME = anthon-starter

CC = gcc
RES = windres

# Release using
# CFLAGS = -O2 -Wall -pipe
# LDFLAGS = -flto
CFLAGS = -O0 -g -Wall -pipe
LDFLAGS = 
SRCDIR = src/
BUILDIR = build/
DESTDIR = 

COMP = rc.o main.o chkargs.o clrprint.o run.o init.o getsysinfo.o backup.o extract.o verify.o deploy.o help_message.o

all: $(COMP) link

rc.o:
	$(RES) -i $(SRCDIR)ast.rc -o $(BUILDIR)rc.o

main.o:
	$(CC) $(CFLAGS) -c -o $(BUILDIR)main.o $(SRCDIR)main.c

chkargs.o:
	$(CC) $(CFLAGS) -c -o $(BUILDIR)chkargs.o $(SRCDIR)chkargs.c

clrprint.o:
	$(CC) $(CFLAGS) -c -o $(BUILDIR)clrprint.o $(SRCDIR)clrprint.c

run.o:
	$(CC) $(CFLAGS) -c -o $(BUILDIR)run.o $(SRCDIR)run.c

init.o:
	$(CC) $(CFLAGS) -c -o $(BUILDIR)init.o $(SRCDIR)init.c

getsysinfo.o:
	$(CC) $(CFLAGS) -c -o $(BUILDIR)getsysinfo.o $(SRCDIR)getsysinfo.c

backup.o:
	$(CC) $(CFLAGS) -c -o $(BUILDIR)backup.o $(SRCDIR)backup.c

extract.o:
	$(CC) $(CFLAGS) -c -o $(BUILDIR)extract.o $(SRCDIR)extract.c

verify.o:
	$(CC) $(CFLAGS) -c -o $(BUILDIR)verify.o $(SRCDIR)verify.c

deploy.o:
	$(CC) $(CFLAGS) -c -o $(BUILDIR)deploy.o $(SRCDIR)deploy.c

help_message.o:
	$(CC) $(CFLAGS) -c -o $(BUILDIR)help_message.o $(SRCDIR)help_message.c

link:
	@sleep 5
	# The statement above is to sleep.
	$(CC) $(LDFLAGS) -o $(DESTDIR)$(EXENAME).exe $(BUILDIR)*.o

clean:
	@for i in $(COMP); do echo Cleaning $(BUILDIR)$$i; rm -f $(BUILDIR)$$i; done
