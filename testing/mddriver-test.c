#include <stdio.h>
#include <windows.h>
#include "md5sum.h"
#define FILETOVERIFY "C:\\cygwin.7z"
int main () {
    char *sumres; //declare a pointer to store the result
    sumres = malloc(32); //because the result is more than one byte, so we need to allocate memory first
    md5sum ( sumres, FILETOVERIFY ); //Here, we uses MD5sum function. Usage : md5sum(char *pointer,FILE file)
	  printf("%s \n",sumres); //Output the result
	  free(sumres); //IMPORTANT! To prevent from memory leak, please free the pointer after that.
    return 0;
}
