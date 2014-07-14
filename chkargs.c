/*
 * Anthon-Starter: Installation helper for AOSC OS series, version 0.2.0
 * Copyright (C) 2014 Anthon Open Source Community
 * This file is a part of Anthon-Starter.
 * 
 * Anthon-Starter is licensed under GNU LGPL: you can redistribute it
 * and/or modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation, either version 3 of
 * the License, or (at your option) any later version.
 * 
 * Anthon-Starter is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with Anthon-Starter.
 * If not, see <http://www.gnu.org/licenses/>.
 */

# include <stdio.h>
# include <stdlib.h>
# include <getopt.h>

# include "funcs.h"
# include "defs.h"

int chkargs ( int argc, char **argv )
{
    int i = 0;
    char opttmp = '\0';
    
    struct option longopts[] = {
        { "live", required_argument, NULL, 'l' },
        { "verbose", no_argument, NULL, 'v' },
        { "quiet", no_argument, NULL, 'q' },
        { "pause", no_argument, NULL, 'p' },
        { "reboot", no_argument, NULL, 'r' },
        { "form", required_argument, NULL, 'f' },
        { "no-verify", no_argument, NULL, NO_VERIFY },
        { "no-extract", no_argument, NULL, NO_EXTRACT },
        { "help", no_argument, NULL, 'h' },
        {  0, 0, 0, 0},
    };

    /* These are for getopt() */
    extern char *optarg;
    extern int optind, opterr, optopt;

    /* Debug information, will remove when release. */
    printf("\n========== Debug Information ==========");
    printf("\nCompile Time: %s %s\nGCC Version: %s\n", __DATE__, __TIME__, __VERSION__);
    printf("%i Parameters detected.\n", argc-1);
    for( i = 0; i<argc; i++)
        printf("%s is argv[%i]\n", argv[i], i);
    printf("=======================================\n");
    
    /* argv[1] is command */

    if ( argc < 2 )
        return 3;

    if ( strcmp ( argv[1], "install" ) == 0 )
    {
        while ( ( opttmp = getopt_long ( argc, argv, "l:vqprfh", longopts, NULL ) ) != -1 )
        {
            switch ( opttmp )
            {
                case 'l':
                    printf ( "The iso image is at %s\n", optarg );
                    break;
                case 'v':
                    puts ( "Verbose mode enabled" );
                    break;
                case 'q':
                    puts ( "Quiet mode enabled" );
                    break;
                case 'p':
                    puts ( "Will pause after operation" );
                    break;
                case 'r':
                    puts ( "Will automatically reboot" );
                    break;
                case 'f':
                    printf ( "You've set the install formula: %s\n", optarg );
                    break;
                case 'h':
                    return 1;
                case '?':
                    puts ( "Unknown switch." );
                    break;
                case ':':
                    puts ( "Not enouth arguments" );
                    break;
            }
        }
    }

    if ( strcmp ( argv[1], "help" ) == 0 )
        return 1;
    
    if ( strcmp ( argv[1], "startup" ) == 0 )
        return 2;

    /* Whatever... return unknown. */
    return 3;
}
