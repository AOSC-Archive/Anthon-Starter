# Makefile for Anthon-Starter 0.2.0

EXENAME = ast

CC = gcc
RES = windres

# Seconds to wait the object files saved for -j option
WAIT = 5

CFLAGS = -O0 -g -Wall -pipe
LDFLAGS = 
SRCDIR = src
BUILDIR = build
DESTDIR = 

.PHONY: all link clean

all: $(BUILDIR)/main.o ASSISTANCE link

# Main function block
$(BUILDIR)/main.o: $(BUILDIR)/chkargs.o $(BUILDIR)/run.o $(BUILDIR)/help_message.o \
        $(SRCDIR)/main.c $(SRCDIR)/ast.h
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/main.o $(SRCDIR)/main.c

$(BUILDIR)/chkargs.o: $(SRCDIR)/chkargs.c $(SRCDIR)/ast.h
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/chkargs.o $(SRCDIR)/chkargs.c

$(BUILDIR)/help_message.o: $(SRCDIR)/help_message.c $(SRCDIR)/ast.h
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/help_message.o $(SRCDIR)/help_message.c

$(BUILDIR)/run.o: $(BUILDIR)/init.o $(BUILDIR)/getsysinfo.o $(BUILDIR)/backup.o $(BUILDIR)/extract.o $(BUILDIR)/verify.o $(BUILDIR)/deploy.o \
       $(SRCDIR)/run.c $(SRCDIR)/ast.h
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/run.o $(SRCDIR)/run.c

# Run function block
$(BUILDIR)/init.o: $(SRCDIR)/init.c $(SRCDIR)/ast.h
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/init.o $(SRCDIR)/init.c

$(BUILDIR)/getsysinfo.o: $(SRCDIR)/getsysinfo.c $(SRCDIR)/ast.h
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/getsysinfo.o $(SRCDIR)/getsysinfo.c

$(BUILDIR)/backup.o: $(SRCDIR)/backup.c $(SRCDIR)/ast.h
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/backup.o $(SRCDIR)/backup.c

$(BUILDIR)/extract.o: $(SRCDIR)/extract.c $(SRCDIR)/ast.h
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/extract.o $(SRCDIR)/extract.c

$(BUILDIR)/verify.o: $(SRCDIR)/verify.c $(SRCDIR)/ast.h
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/verify.o $(SRCDIR)/verify.c

$(BUILDIR)/deploy.o: $(SRCDIR)/deploy.c $(SRCDIR)/ast.h
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/deploy.o $(SRCDIR)/deploy.c

# Assistance function block
ASSISTANCE: $(BUILDIR)/oops.o $(BUILDIR)/md5sum.o $(BUILDIR)/notify.o

$(BUILDIR)/oops.o: $(SRCDIR)/oops.c $(SRCDIR)/ast.h
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/oops.o $(SRCDIR)/oops.c

$(BUILDIR)/md5sum.o: $(SRCDIR)/md5sum.c $(SRCDIR)/ast.h
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/md5sum.o $(SRCDIR)/md5sum.c

$(BUILDIR)/notify.o: $(BUILDIR)/fclrprintf.o \
          $(SRCDIR)/notify.c $(SRCDIR)/ast.h
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/notify.o $(SRCDIR)/notify.c

$(BUILDIR)/fclrprintf.o: $(SRCDIR)/fclrprintf.c $(SRCDIR)/ast.h
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/fclrprintf.o $(SRCDIR)/fclrprintf.c

# Resource file
$(BUILDIR)/rc.o:
	$(RES) -i $(SRCDIR)/ast.rc -o $(BUILDIR)rc.o

link:
	$(CC) $(LDFLAGS) -o $(DESTDIR)$(EXENAME).exe $(BUILDIR)/*.o

clean:
	@-rm -f $(BUILDIR)/*.o
