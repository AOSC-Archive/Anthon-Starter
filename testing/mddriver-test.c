#include <stdio.h>
#include <windows.h>
#include "md5sum.h"
#define FILETOVERIFY "C:\\cygwin.7z"
int main () {
    char sumres;
    md5sum ( &sumres, FILETOVERIFY );
	 printf("%s \n",&sumres);
    return 0;
}

