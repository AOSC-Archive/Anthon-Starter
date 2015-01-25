# Makefile for Anthon-Starter 0.2.0

EXENAME = ast

HOST = i686-w64-mingw32
CC = ${HOST}-gcc
RES = ${HOST}-windres

# Seconds to wait the object files saved for -j option
WAIT = 5

CFLAGS = -O0 -g -Wall -pipe
LDFLAGS = 
SRCDIR = src
BUILDDIR = build
DESTDIR = 
MKDIR = mkdir

.PHONY: all link clean ASSISTANCE mkdir

all: mkdir ${BUILDDIR}/main.o ASSISTANCE link

# Main function block
mkdir:
	@-rm -rf ${BUILDDIR}
	${MKDIR} ${BUILDDIR}

${BUILDDIR}/main.o: ${BUILDDIR}/chkargs.o ${BUILDDIR}/run.o ${BUILDDIR}/help_message.o \
        ${SRCDIR}/main.c ${SRCDIR}/ast.h
	${CC} ${CFLAGS} -c -o ${BUILDDIR}/main.o ${SRCDIR}/main.c

${BUILDDIR}/chkargs.o: ${SRCDIR}/chkargs.c ${SRCDIR}/ast.h
	${CC} ${CFLAGS} -c -o ${BUILDDIR}/chkargs.o ${SRCDIR}/chkargs.c

${BUILDDIR}/help_message.o: ${SRCDIR}/help_message.c ${SRCDIR}/ast.h
	${CC} ${CFLAGS} -c -o ${BUILDDIR}/help_message.o ${SRCDIR}/help_message.c

${BUILDDIR}/run.o: ${BUILDDIR}/init.o ${BUILDDIR}/getsysinfo.o ${BUILDDIR}/backup.o ${BUILDDIR}/extract.o ${BUILDDIR}/verify.o ${BUILDDIR}/deploy.o \
       ${SRCDIR}/run.c ${SRCDIR}/ast.h
	${CC} ${CFLAGS} -c -o ${BUILDDIR}/run.o ${SRCDIR}/run.c

# Run function block
${BUILDDIR}/init.o: ${SRCDIR}/init.c ${SRCDIR}/ast.h
	${CC} ${CFLAGS} -c -o ${BUILDDIR}/init.o ${SRCDIR}/init.c

${BUILDDIR}/getsysinfo.o: ${SRCDIR}/getsysinfo.c ${SRCDIR}/ast.h
	${CC} ${CFLAGS} -c -o ${BUILDDIR}/getsysinfo.o ${SRCDIR}/getsysinfo.c

${BUILDDIR}/backup.o: ${SRCDIR}/backup.c ${SRCDIR}/ast.h
	${CC} ${CFLAGS} -c -o ${BUILDDIR}/backup.o ${SRCDIR}/backup.c

${BUILDDIR}/extract.o: ${SRCDIR}/extract.c ${SRCDIR}/ast.h
	${CC} ${CFLAGS} -c -o ${BUILDDIR}/extract.o ${SRCDIR}/extract.c

${BUILDDIR}/verify.o: ${SRCDIR}/verify.c ${SRCDIR}/ast.h
	${CC} ${CFLAGS} -c -o ${BUILDDIR}/verify.o ${SRCDIR}/verify.c

${BUILDDIR}/deploy.o: ${SRCDIR}/deploy.c ${SRCDIR}/ast.h
	${CC} ${CFLAGS} -c -o ${BUILDDIR}/deploy.o ${SRCDIR}/deploy.c

# Assistance function block
ASSISTANCE: ${BUILDDIR}/oops.o ${BUILDDIR}/md5sum.o ${BUILDDIR}/notify.o

${BUILDDIR}/oops.o: ${SRCDIR}/oops.c ${SRCDIR}/ast.h
	${CC} ${CFLAGS} -c -o ${BUILDDIR}/oops.o ${SRCDIR}/oops.c

${BUILDDIR}/md5sum.o: ${SRCDIR}/md5sum.c ${SRCDIR}/ast.h
	${CC} ${CFLAGS} -c -o ${BUILDDIR}/md5sum.o ${SRCDIR}/md5sum.c

${BUILDDIR}/notify.o: ${BUILDDIR}/fclrprintf.o \
          ${SRCDIR}/notify.c ${SRCDIR}/ast.h
	${CC} ${CFLAGS} -c -o ${BUILDDIR}/notify.o ${SRCDIR}/notify.c

${BUILDDIR}/fclrprintf.o: ${SRCDIR}/fclrprintf.c ${SRCDIR}/ast.h
	${CC} ${CFLAGS} -c -o ${BUILDDIR}/fclrprintf.o ${SRCDIR}/fclrprintf.c

# Resource file
${BUILDDIR}/rc.o:
	${RES} -i ${SRCDIR}/ast.rc -o ${BUILDDIR}rc.o

link:
	${CC} ${LDFLAGS} -o ${DESTDIR}${EXENAME}.exe ${BUILDDIR}/*.o

clean:
	@-rm -rf ${BUILDDIR}
	@-rm -f ast.exe

