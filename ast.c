# include <stdio.h>
# include <stdlib.h>

int main ( int argc, char* argv[] )
{
	if (argc == 1)
	{
		puts("Anthon-Starter 0.x.x-Dev  Copyright (C) 2014 AOSC-JDS");
		puts("\nUsage: ast <command> <image_file> <install_route> [<install_mode>...]");
		puts("\n<Commands>\n");
		puts("  i: Install Anthon GNU/Linux to the computer\n  c: Check the system and put them into .\\info.ast\n  v: Verify the image file\n  a: show About information");
		puts("\nNotes:");
		puts("  1. lalal\n  2. alala\n  3. Just a test!\n");
	}
	/*printf("\n%d", argc);
	printf("\nName: %s", argv[0]);
	printf("\nImage file is: %s", argv[1]);
	printf("\nLocation: %s\n", argv[2]);*/
	return 0;
}
