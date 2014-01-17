# include <stdio.h>
# include <io.h>
# include <stdlib.h>
# include <string.h>

void help_message( void );
void check( char **img, char **tgt );
int extract ( char **img, char **tgt );
int deploy ( char **tgt );
int i, tmp;

int main ( int argc, char **argv )
{
	int noverify = 0, stepping = 0, verbose = 0, reboot = 0, quiet = 0;
	
	printf("\nAnthon-Starter 0.2.0-Dev  Copyright (C) 2014 AOSC-JDS\n");
	printf("\n==========Execute Information==========");
	printf("\nCompile Time: %s %s\nGCC Version: %s\n", __DATE__, __TIME__, __VERSION__);
	printf("%d Parameters detected.\n", argc-1);
	for( i = 0; i<argc; i++)
		printf("%s is argv[%d]\n", argv[i], i);
	printf("=======================================\n");
	if ( argc > 1)
	{
		if (strcmp(argv[1], "install") == 0)
		{	
			for ( i = 3; i<argc; i++ )
			{
				if (strcmp(argv[i], "--no-verify") == 0)
					noverify = 1;
					
				if (strcmp(argv[i], "--step-by-step") == 0)
					stepping = 1;
					
				if (strcmp(argv[i], "--verbose") == 0)
				{
					if (quiet == 1)
					{
						printf("You cannot set verbose and quiet at the same time! Program exits.\n");
						exit(1);
					}
					else verbose = 1;
				}
				
				if (strcmp(argv[i], "--quiet") == 0)
				{
					if (verbose == 1)
					{
						printf("You cannot set verbose and quiet at the same time! Program exits.\n");
						exit(1);
					}
					else quiet = 1;
				}
				
				if (strcmp(argv[i], "--reboot") == 0)
					reboot = 1;
			}
			
			printf("noverify? %d; stepping? %d; verbose? %d; quiet? %d; reboot? %d;\n", noverify, stepping, verbose, quiet, reboot);
			
			
			
			check( &argv[2], &argv[3] );
			if ( (extract( &argv[2], &argv[3] )) == 1)
			{
				printf("Error when extracting.\n");
				exit(1);
			}
			if ( (deploy( &argv[3] )) == 1)
			{
				printf("Error when deploying.\n");
				exit(1);
			}
			printf("Done.\n");
			exit(0);
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
	printf("\nUsage: ast <command> <image_file> <install_target> [<switches>...]\n");
	printf("\n<Commands>\n");
	printf("\tinstall: Install the specify AOSC distro to the computer\n\thelp: Show the help\n\tabout: Show bbout information");
	printf("\n\n<Switches>\n");
	printf("\t--no--verify\tDo not verify the image file\n\t--loader=\tSet the installation of bootloader\n\t\t\t  Available parameters:\n\t\t\t    edit_present (Edit the present NT loader, default)\n\t\t\t    write_mbr (Edit the MBR)\n\t--step-by-step\tStepping\n\t--verbose\tShow all information\n\t--reboot\tAutomatically reboot the system\n\t--quiet\t\tExecute quietly\n");
	printf("\nFor any more information, please visit http://wiki.anthonos.org/\n");
	printf("To report bugs please visit http://bugs.anthonos.org/\n");
}

void check( char **img, char **tgt )
{
	printf("%s %s\n\n", *img, *tgt );
	
	if ( (access( *img, 00 )) == -1 )
	{
		printf("Cannot find the image file %s! Program exits.\n", *img);
		exit(-1);
	}
	if ( (access( *tgt, 06)) == -1 )
	{
		printf("Cannot find %s or %s is not ready.\n", *tgt, *tgt);
		exit(-1);
	}
}

int extract ( char **img, char **tgt )
{
	char **t;
	printf("Extracting Pre-Install Environment...\n");
	
	//So how to solve the problem of using malloc().
	//Someone knows?
	
	/*t = malloc( 100 );
	system("pause");
	*t = "7z e ";
	printf("%s\n", *t);
	system("pause");
	*t = strcat(*t, *img);
	system("pause");
	system(*t);*/
	printf("Extracting nessesary OS files...\n");
	return 0;
}

int deploy ( char **tgt )
{
	printf("Deploying bootloader...\n");
	//AHHHHHHHHHH...
}

