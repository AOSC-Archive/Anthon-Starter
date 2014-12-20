# Makefile in $(SRCDIR)
BUILDIR = ../build
all: main.o ASSISTANCE

# Main function block
main.o: main.c chkargs.o run.o help_message.o
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/main.o $(SRCDIR)/main.c

chkargs.o:
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/chkargs.o $(SRCDIR)/chkargs.c

help_message.o:
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/help_message.o $(SRCDIR)/help_message.c

run.o: init.o getsysinfo.o backup.o extract.o verify.o deploy.o
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/run.o $(SRCDIR)/run.c

# Run function block
init.o:
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/init.o $(SRCDIR)/init.c

getsysinfo.o:
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/getsysinfo.o $(SRCDIR)/getsysinfo.c

backup.o:
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/backup.o $(SRCDIR)/backup.c

extract.o:
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/extract.o $(SRCDIR)/extract.c

verify.o:
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/verify.o $(SRCDIR)/verify.c

deploy.o:
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/deploy.o $(SRCDIR)/deploy.c

# Assistance function block
ASSISTANCE: oops.o md5sum.o notify.o

oops.o:
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/oops.o $(SRCDIR)/oops.c

md5sum.o:
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/md5sum.o $(SRCDIR)/md5sum.c

notify.o: fclrprintf.o
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/notify.o $(SRCDIR)/notify.c

fclrprintf.o:
	$(CC) $(CFLAGS) -c -o $(BUILDIR)/fclrprintf.o $(SRCDIR)/fclrprintf.c

# Resource file
rc.o:
	$(RES) -i $(SRCDIR)/ast.rc -o $(BUILDIR)rc.o
