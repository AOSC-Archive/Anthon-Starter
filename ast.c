//Anthon-Starter: Installation helper for :Next Linux distribution series, version 0.2.0
//Copyright (C) 2014 Anthon Open Source Community - Junde Studio
//
//This software is under GNU Genereal Public License 3 and WITHOUT ANY WARRANTY.
//So you know it...

# include <stdio.h>
# include <io.h>
# include <stdlib.h>
# include <string.h>
# include "lang_en-US.h"			//Language file

# define CMD_BUFFER 512				//Buffer size of command line
# define LOADER_EDIT_PRESENT 15
# define LOADER_WRITE_MBR 16

void init ( void );							//For initialization
int verify ( const int imgv_status, const char *osimage, const char *ostarget );//For verifying and detecting
int backup ( const char *system_drive );	//For backup
int extract ( const char *osimage, const char *ostarget );//For extracting the files
int deploy ( const int ins_mode );			//For deploying the bootloader
void help_message ( void );					//For help

int cpy( const char *fsource, const char *ftarget );//Copy files faster ( Maybe? )

char *g_cmdtmp;								//Temporary variable for command lines
FILE *g_logfile;							//Log file

int main ( int argc, char **argv, char **envp )
{
	int imgv_status = 1, ins_mode = LOADER_EDIT_PRESENT,reboot = 0, tmp = 0;
	char *system_drive, *p;
	system_drive = malloc ( 4 );
	p = malloc ( 15 );
	
	//Get the system drive
	for ( ;;tmp++ )
	{
		if ( envp[tmp] )
		{
			if ( ( p = strstr ( envp[tmp], "SystemDrive=" ) ) != NULL )
			{
				system_drive[0] = p[12];
				system_drive[1] = p[13];
				system_drive[2] = '\\';
				system_drive[3] = '\0';
			}
		}
		else break;
	}
	free ( p );

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
				if ( strcmp ( argv[tmp], "--reboot" ) == 0 )
					reboot = 1;
				if ( strcmp ( argv[tmp], "--loader=write_mbr" ) == 0 )
					ins_mode = LOADER_WRITE_MBR;
			}
			
			fprintf ( stdout, MAIN_TITLE );
			fprintf ( g_logfile, MAIN_TITLE );
			//Now begin!
			
			//Initialization
			init ();
			
			//Verify
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
			
			//Backup
			backup ( system_drive );
			
		}
		
		if ( strcmp ( argv[1], "help" ) == 0 )
		{
			help_message();
			return 0;
		}
		
		//for
		
		/*fprintf ( stderr, UNKNOWN_FIRST_PARAMETER, argv[1] );
		help_message();
		return 0;*/
	}
}


void init ( void )
{
	int init_rtn = 0;
	fprintf( stdout, INIT_TITLE );
	fprintf( g_logfile, INIT_TITLE );
	if ( access ( ".\\src\\7z.exe", 01 ) == -1 )
	{
		fprintf ( stderr, CANNOT_FIND_7ZEXE );
		fprintf ( g_logfile, CANNOT_FIND_7ZEXE );
		if ( init_rtn == 0 )
			init_rtn = init_rtn + 1;
	}
	if ( access ( ".\\src\\7z.exe", 04 ) == -1 )
	{
		fprintf ( stderr, CANNOT_FIND_7ZDLL );
		fprintf ( g_logfile, CANNOT_FIND_7ZDLL );
		if ( init_rtn == 0 )
			init_rtn = init_rtn + 1;
	}
		if ( access ( ".\\src\\wget.exe", 01 ) == -1 )
	{
		fprintf ( stderr, CANNOT_FIND_WGET );
		fprintf ( g_logfile, CANNOT_FIND_WGET );
		if ( init_rtn == 0 )
			init_rtn = init_rtn + 1;
	}
		if ( access ( ".\\src\\sha256sum.exe", 01 ) == -1 )
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
	if ( access ( osimage, 04 ) == -1 )
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


int backup ( const char *system_drive )
{
	char *ftmp;
	ftmp = malloc ( CMD_BUFFER );
	
	system ( "mkdir ast_bkup" );
	
	//NT5.x ( Windows 2k/XP )
	sprintf ( ftmp, "%s%s", system_drive, "NTLDR" );
	if ( access ( ftmp, 06 ) == 0 )
	{
		printf ( "  *** Detected NT5.x loader\n" );
		fprintf ( g_logfile, "  *** Detected NT5.x loader\n");
		system ( "attrib -s -h -r %SystemDrive%\\boot.ini");
		system ( "copy %Systemdrive%\\boot.ini .\\ast_bkup\\ > nul" );
	}
	else
	{
		//NT6.x ( Windows Vista/7/8 )
		sprintf ( ftmp, "%s%s", system_drive, "Windows\\boot\\" );
		if ( access ( ftmp, 01 ) == 0 )
		{
			printf ( "  *** Detected NT6.x loader\n" );
			fprintf ( g_logfile, "  *** Detected NT6.x loader\n");
			//WHY IT CANNOT RUN? IS THE F**KING UAC?
			//system ( "%%SystemRoot%%\\System32\\bcdedit /export %%TEMP%%\\ast_bkup\\BCDbckup" );
		}
	}
	exit ( 0 );
}


int extract ( const char *osimage, const char *ostarget )
{
}


int deploy ( const int ins_mode )
{
		/*FILE *batch_file;
		batch_file = fopen ( "nt6_bcd_edit.bat", "w" );
		

		fprintf ( batch_file, "@echo off\n" );
		fprintf ( batch_file, "for /f \"delims=\" %%%%i in ('bcdedit /create /d \"Start Anthon GNU/Linux Installer\" /application bootsector') do set uid=%%%%i\n" );
		fprintf ( batch_file, "bcdedit /set %%uid:~2,38%% device partition=%%systemdrive%%\n" );
		fprintf ( batch_file, "bcdedit /set %%uid:~2,38%% path \\g2ldr\n" );
		fprintf ( batch_file, "bcdedit /displayorder %%uid:~2,38%% /addlast\n" );
		fprintf ( batch_file, "bcdedit /default %%uid:~2,38%%\n" );
		fprintf ( batch_file, "bcdedit /timeout 10\n" );
		if ( system ( "nt6_bcd_edit.bat" ) != 0 )
		{
			fprintf ( stderr, ERROR_WHEN_EDITING_BCD );
			fprintf ( g_logfile, ERROR_WHEN_EDITING_BCD );
		}*/
}


void help_message( void )
{
	printf("\nAnthon-Starter 0.2.0-Dev  Copyright (C) 2014 AOSC-JDS\n");
	printf("\nUsage: ast <command> <image_file> <install_route> [<switches>...]\n");
	printf("\n<Commands>\n");
	printf("\tinstall\t\tInstall the specify AOSC distro to your computer\n\thelp\t\tShow this help");
	printf("\n\n<Switches>\n");
	printf("\t--no-verify\tDo not verify the image file\n\t--loader=\tSet the installation method of boot loader\n\t\t\t  Available parameters:\n\t\t\t    edit_present (Edit the present NT loader, default)\n\t\t\t    write_mbr (Edit the MBR)\n\t--reboot\tAutomatically reboot the system\n");
	printf("\nFor any more information, please visit http://wiki.anthonos.org/\n");
	printf("To report bugs please visit http://bugs.anthonos.org/\n");
}
