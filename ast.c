# include <stdio.h>
# include <stdlib.h>

int main ( int argc, char *argv[] )
{
	/*printf("\n%d", argc);
	printf("\n%s", argv[0]);
	printf("\n%s\n", argv[1]);*/
	if (argc > 1)
	{
		if (strcmp(argv[1], "install") == 0)
		{
			puts("We haven\'t finished it yet!");
			exit(0);
		}
		
		if (strcmp(argv[1], "help") == 0)
		{
			puts("We haven\'t finished it yet!");
			exit(0);
		}
		
		if (strcmp(argv[1], "about") == 0)
		{
			puts("We haven\'t finished it yet!");
			exit(0);
		}
	}
	puts("Anthon-Starter 0.x.x-Dev  Copyright (C) 2014 AOSC-JDS");
	puts("\nUsage: ast <command> <image_file> <install_route> [<install_mode>...]");
	puts("\n<Commands>\n");
	puts("  install: Install Anthon GNU/Linux to the computer\n  help: Show the help\n  about: Show bbout information");
	puts("\nNotes:");
	puts("  1. lalal\n  2. alala\n  3. Just a test!\n");

	return 0;
}
