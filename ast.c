# include <stdio.h>

# ifdef windows
	# include <io.h>
# else
	# include <sys/io.h>
# endif

# include <stdlib.h>
# include <string.h>


void help_message( void );
int check( char **img, char **tgt );
int extract ( int isquiet, char **img, char **tgt );
int deploy ( char **tgt );
int i;

int main ( int argc, char **argv )
{
	int noverify = 0, reboot = 0, quiet = 0;
	
/* Test Info
	printf("\n==========Execute Information==========");
	printf("\nCompile Time: %s %s\nGCC Version: %s\n", __DATE__, __TIME__, __VERSION__);
	printf("%d Parameters detected.\n", argc-1);
	for( i = 0; i<argc; i++)
		printf("%s is argv[%d]\n", argv[i], i);
	printf("=======================================\n");
	*/
	if ( argc > 1)
	{
		if (strcmp(argv[1], "install") == 0)
		{	
			for ( i = 3; i<argc; i++ )
			{
				if (strcmp(argv[i], "--no-verify") == 0)
					noverify = 1;
				
				if (strcmp(argv[i], "--quiet") == 0)
				{
					freopen( "ast.log", "w", stdout );
					quiet = 1;
				}
				if (strcmp(argv[i], "--reboot") == 0)
					reboot = 1;
			}
			
			//printf("noverify? %d; reboot? %d;\n", noverify, reboot);
			
			// NOW BEGIN!
			
			printf("\nAnthon-Starter 0.2.0-Dev  Copyright (C) 2014 AOSC-JDS\n\n");
			switch ( check( &argv[2], &argv[3] ) )
			{
				case 1:
					fprintf( stderr, "\nCannot find the image file %s! Program exits.\n", argv[2] );
					exit(2);
				case 2:
					fprintf( stderr, "\nCannot find the target directory %s or %s is not ready! Program exits.\n", argv[3], argv[3] );
					exit(2);
			}
			
			if ( (extract( quiet, &argv[2], &argv[3] )) == 1)
			{
				fprintf( stderr, "***Error: Extracting failed. Program exits.\n" );
				exit(1);
			}
			
			if ( (deploy( &argv[3] )) == 1 )
			{
				fprintf( stderr, "Error when deploying.\n" );
				exit(1);
			}
			printf("Done.\n");
			fclose(stdout);
			# ifdef windows
			// if ( reboot == 1 ) system("shutdown -r -t 00");
			# else
			// if ( reboot == 1 ) system("reboot");
			# endif
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
	printf("\nAnthon-Starter 0.2.0-Dev  Copyright (C) 2014 AOSC-JDS\n");
	printf("\nUsage: ast <command> <image_file> <install_target> [<switches>...]\n");
	printf("\n<Commands>\n");
	printf("\tinstall: Install the specify AOSC distro to the computer\n\thelp: Show the help");
	printf("\n\n<Switches>\n");
	printf("\t--no--verify\tDo not verify the image file\n\t--loader=\tSet the installation of bootloader\n\t\t\t  Available parameters:\n\t\t\t    edit_present (Edit the present NT loader, default)\n\t\t\t    write_mbr (Edit the MBR)\n\t--reboot\tAutomatically reboot the system\n\t--quiet\t\tExecute quietly\n");
	printf("\nFor any more information, please visit http://wiki.anthonos.org/\n");
	printf("To report bugs please visit http://bugs.anthonos.org/\n");
}

int check( char **img, char **tgt )
{
	//printf("%s %s\n\n", *img, *tgt );
	printf("Verifying image file...\n");
	if ( (access( *img, 00 )) == -1 )
		return 1;
	if ( (access( *tgt, 06)) == -1 )
		return 2;
	
	// Here we will add wget & sha256sum to verify the image files
	// wget: Get the latest image files' sha256 sum;
	// sha256sum: Verify the image
	// Then we compare the two results.
}

int extract ( int isquiet, char **img, char **tgt )
{
	char *c; // the Commands
	
	printf("Extracting Pre-Install Environment...\n");
	// VMLINUZ
	if ( isquiet == 1 )
	{
		c = malloc( 25 + strlen( *img ) + strlen(*tgt) );
		sprintf( c, "%s%s%s%s%s", "7z x ", *img, " -o", *tgt, " boot/vmlinuz -y" );
	} else
	{
		c = malloc( 31 + strlen( *img ) + strlen(*tgt) );
		sprintf( c, "%s%s%s%s%s", "7z x ", *img, " -o", *tgt, " boot/vmlinuz -y > nul" );
	}
	if ( system(c) != 0 )
	{
		fprintf( stderr, "  ***Error when extracting PE kernel (vmlinuz)!\n" );
		return 1;
	} // WTF!! How to get 7-zip's error code?!
	
	// INITRD
	if ( isquiet == 1 )
	{
		c = realloc( c, 24 + strlen( *img ) + strlen(*tgt) );
		sprintf( c, "%s%s%s%s%s", "7z x ", *img, " -o", *tgt, " boot/initrd -y" );
	} else
	{
		c = realloc( c, 30 + strlen( *img ) + strlen(*tgt) );
		sprintf( c, "%s%s%s%s%s", "7z x ", *img, " -o", *tgt, " boot/initrd -y > nul" );
	}
	if ( system(c) != 0 )
	{
		fprintf( stderr, "  ***Error when extracting PE initial RAM disk (initrd)!\n" );
		return 1;
	}
	
	//SQUASH
	printf("Extracting necessary OS files...\n  Please wait patiently for it may takes a long time...\n");
	if ( isquiet == 1 )
	{
		c = realloc( c, 19 + strlen( *img ) + strlen(*tgt) );
		sprintf( c, "%s%s%s%s%s", "7z x ", *img, " -o", *tgt, " squash -y" );
	} else
	{
		c = realloc( c, 25 + strlen( *img ) + strlen(*tgt) );
		sprintf( c, "%s%s%s%s%s", "7z x ", *img, " -o", *tgt, " squash -y > nul" );
	}
	if ( system(c) != 0 )
	{
		fprintf( stderr, "  ***Error when extracting squashfs file!\n" );
		return 1;
	}
	
	return 0;
}

int deploy ( char **tgt )
{
	printf("Deploying bootloader...\n");
	// Here we will add:
	//   1. if --loader=edit_present we will backup the NT loader and change it;
	//   2. if --loader=write_mbr we will backup the MBR and write GRUB in it;
	//   3. if detected --reboot execute "shutdown" or "halt".
}

