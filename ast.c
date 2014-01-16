# include <stdio.h>
# include <stdlib.h>

void help_message( void );
void check( char *img[], char *tgt[] );
int i;

int main ( int argc, char *argv[] )
{
	printf("\n==========Testing area");
	printf("\nCompile Time: %s %s\nGCC Version: %s\n", __DATE__, __TIME__, __VERSION__);
	printf("%d Parameters detected.\n", argc-1);
	for( i = 0; i<argc; i++)
		printf("%s is argv[%d]\n", argv[i], i);
	printf("======================\n");
	
	/*printf("%ld %ld", &argv[2], &argv[3]);*/
	/*puts(argv[2]);*/
	
	if ( argc > 1)
	{
		if (strcmp(argv[1], "install") == 0)
		{
			check( &argv[2], &argv[3] );
			printf("\nWe haven\'t finished it yet!\n");
			exit(1);
		}
		
		if (strcmp(argv[1], "help") == 0)
		{
			help_message();
			exit(0);
		}
	}
	help_message();
	return 0;
}

void help_message( void )
{
	printf("\nAnthon-Starter 0.2.0-Dev  Copyright (C) 2014 AOSC-JDS\n");
	printf("\nUsage: ast <command> <image_file> <install_target> [<switches>...]\n");
	printf("\n<Commands>\n");
	printf("\tinstall: Install the specify AOSC distro to the computer\n\thelp: Show the help\n\tabout: Show bbout information");
	printf("\n\n<Switches>\n");
	printf("\t--no--verify\tDo not verify the image file\n\t--loader=\tSet the installation of bootloader\n\t\t\t  Available parameters:\n\t\t\t    edit_present (Edit the present NT loader, default)\n\t\t\t    write_mbr (Edit the MBR)\n\t--step-by-step\tStepping\n\t--verbose\tShow all information\n\t--reboot\tAutomatically reboot the system\n\t--quiet\t\tExecute quietly\n");
	printf("\nFor any more information, please visit http://wiki.anthonos.org/\n");
	printf("To report bugs please visit http://bugs.anthonos.org/\n");
}

void check( char *img[], char *tgt[] )
{
	printf("%s %s", *img, *tgt );
}
