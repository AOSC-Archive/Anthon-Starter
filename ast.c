//Anthon-Starter: Installation helper for :Next Linux distribution series, version 0.2.0
//Copyright (C) 2014 Anthon Open Source Community - Junde Studio
//
//This software is under GNU Genereal Public License 3 and WITHOUT ANY WARRANTY.
//So you know it...

# include <stdio.h>
# include <io.h>
# include <stdlib.h>
# include <string.h>
# include "lang_en-US.h"

# define CMD_BUFFER 512
# define LOADER_EDIT_PRESENT 15
# define LOADER_WRITE_MBR 16

void init ( void );
int verify ( const int imgv_status, const char *osimage, const char *ostarget );
int backup ( void );
int extract ( const char *osimage, const char *ostarget );
int deploy ( const int ins_mode );
void help_message ( void );

char *g_cmdtmp;
FILE *g_logfile;

int main ( int argc, char **argv )
{
	int imgv_status = 1, ins_mode = LOADER_EDIT_PRESENT,reboot = 0, tmp = 0;
	g_cmdtmp = malloc ( CMD_BUFFER );
	
	g_logfile = fopen( ".\\ast.log", "w" );
	
	if ( argc < 2 )
		help_message();
	
	if ( argc >= 2 )
	{	
		if ( strcmp ( argv[1], "install" ) == 0 )
		{
			if ( ( argv[2] == NULL ) || ( argv[3] == NULL ) )
			{
				fprintf( stderr, MISSING_PARAMETERS );
				fprintf( g_logfile, MISSING_PARAMETERS );
				return 1;
			}
			
			for ( tmp = 3; tmp < argc; tmp++ )
			{
				if ( strcmp ( argv[tmp], "--no-verify" ) == 0 )
					imgv_status = 0;
				if ( strcmp ( argv[tmp], "--quiet" ) == 0 )
					{
					}
				if ( strcmp ( argv[tmp], "--reboot" ) == 0 )
					{
						reboot = 1;
					}
			}
			
			fprintf ( stdout, MAIN_TITLE );
			fprintf ( g_logfile, MAIN_TITLE );
			
			init ();
			
			switch ( verify ( imgv_status, argv[2], argv[3] ) )
			{
				case 1:
					fprintf( stderr, ERROR_CANNOT_FIND_IMAGE, argv[2] );
					fprintf( g_logfile, ERROR_CANNOT_FIND_IMAGE, argv[2] );
					exit ( 1 );
				case 2:
					fprintf( stderr, ERROR_CANNOT_FIND_TARGET, argv[3], argv[3] );
					fprintf( g_logfile, ERROR_CANNOT_FIND_TARGET, argv[3], argv[3] );
					exit ( 1 );
				case 7:
					fprintf( stderr, ERROR_WHEN_VERIFYING );
					fprintf( g_logfile, ERROR_WHEN_VERIFYING );
					exit ( 1 );
			}
		}
	}
}


void init ( void )
{
	int init_rtn = 0;
	fprintf( stdout, INIT_TITLE );
	fprintf( g_logfile, INIT_TITLE );
	if ( access ( ".\\src\\7z.exe", 00 ) == -1 )
	{
		fprintf ( stderr, CANNOT_FIND_7ZEXE );
		fprintf ( g_logfile, CANNOT_FIND_7ZEXE );
		if ( init_rtn == 0 )
			init_rtn = init_rtn + 1;
	}
	if ( access ( ".\\src\\7z.exe", 00 ) == -1 )
	{
		fprintf ( stderr, CANNOT_FIND_7ZDLL );
		fprintf ( g_logfile, CANNOT_FIND_7ZDLL );
		if ( init_rtn == 0 )
			init_rtn = init_rtn + 1;
	}
		if ( access ( ".\\src\\wget.exe", 00 ) == -1 )
	{
		fprintf ( stderr, CANNOT_FIND_WGET );
		fprintf ( g_logfile, CANNOT_FIND_WGET );
		if ( init_rtn == 0 )
			init_rtn = init_rtn + 1;
	}
		if ( access ( ".\\src\\sha256sum.exe", 00 ) == -1 )
	{
		fprintf ( stderr, CANNOT_FIND_SHA256SUMEXE );
		fprintf ( g_logfile, CANNOT_FIND_SHA256SUMEXE );
		if ( init_rtn == 0 )
			init_rtn = init_rtn + 1;
	}
	
	if ( init_rtn != 0)
	{
		fprintf ( stderr, ERROR_WHEN_INITIALIZING );
		fprintf ( g_logfile, ERROR_WHEN_INITIALIZING );
		exit ( 1 );
	}
}


int verify ( const int imgv_status, const char *osimage, const char *ostarget )
{
	fprintf ( stdout, VERIFY_TITLE );
	fprintf ( g_logfile, VERIFY_TITLE );
	if ( access ( osimage, 00 ) == -1 )
		return 1;
	if ( access ( ostarget, 06 ) == -1 )
		return 2;
	
	if ( imgv_status == 1 )
	{
		char *verify_shasum = malloc ( 66 );
		
		sprintf ( g_cmdtmp, "%s %s", ".\\src\\sha256sum.exe -b", osimage );
		//printf ( "%s\n", strncpy ( verify_shasum, system ( g_cmdtmp ), 65 ) );
			return 0;
	}
	
}


int backup ( void )
{
}


int extract ( const char *osimage, const char *ostarget )
{
}


int deploy ( const int ins_mode )
{
}


void help_message( void )
{
	printf("\nAnthon-Starter 0.2.0-Dev  Copyright (C) 2014 AOSC-JDS\n");
	printf("\nUsage: ast <command> <image_file> <install_target> [<switches>...]\n");
	printf("\n<Commands>\n");
	printf("\tinstall: Install the specify AOSC distro to the computer\n\thelp: Show this help");
	printf("\n\n<Switches>\n");
	printf("\t--no--verify\tDo not verify the image file\n\t--loader=\tSet the installation of bootloader\n\t\t\t  Available parameters:\n\t\t\t    edit_present (Edit the present NT loader, default)\n\t\t\t    write_mbr (Edit the MBR)\n\t--reboot\tAutomatically reboot the system\n\t--quiet\t\tExecute quietly\n");
	printf("\nFor any more information, please visit http://wiki.anthonos.org/\n");
	printf("To report bugs please visit http://bugs.anthonos.org/\n");
}
