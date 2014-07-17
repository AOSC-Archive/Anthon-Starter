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
# include <unistd.h>
# include <stdlib.h>
# include <string.h>
# include <getopt.h>

# include "funcs.h"
# include "defs.h"

int chkargs ( int argc, char **argv,
              char *osimage, char *ostarget,
              struct img *imginfo, int instform, int verbose_mode, int quiet_mode,
              int will_pause, int will_reboot, int will_verify, int will_extract )
{
    char opttmp = '\0';

    struct option longopts[] = {
        { "live", required_argument, NULL, 'l' },
        { "output", required_argument, NULL, 'o' },
        { "verbose", no_argument, NULL, 'v' },
        { "quiet", no_argument, NULL, 'q' },
        { "pause", no_argument, NULL, 'p' },
        { "reboot", no_argument, NULL, 'r' },
        { "form", required_argument, NULL, 'f' },
        { "no-verify", no_argument, NULL, NO_VERIFY },
        { "no-extract", no_argument, NULL, NO_EXTRACT },
        { "help", no_argument, NULL, 'h' },
        { 0, 0, 0, 0 },
    };

    /* These are for getopt_long() */
    extern char *optarg;
    
    /* argv[1] is command */

    if ( argc < 2 )
        return 4;

    if ( strcmp ( argv[1], "install" ) == 0 )
    {
        while ( ( opttmp = getopt_long ( argc, argv, "l:o:vqprf:h", longopts, NULL ) ) != -1 )
        {
            switch ( opttmp )
            {
                case 'l': /* --live=, -l */
                    osimage = malloc ( strlen ( optarg ) + 1 );
                    strcpy ( osimage, optarg );
                    /* Check if the image file exists. */
                    if ( access ( osimage, R_OK ) != 0 )
                    {
                        /* printf ( "\n  \033[0;31;1m*** [E] ISO image %s is not avaliable.\033[0m\n          You may not have sufficient privileges, or it doesn\'t exist.\n", osimage ); */
                        printf ( "\n  *** [E] ISO image %s is not avaliable.\n          You may not have sufficient privileges, or it doesn\'t exist.\n", osimage );
                        return 0;
                    }
                    
                    /* TODO: Extract md5sum.ast to check the image file is from AOSC, and store those inside into struct imginfo. */
                    
                    break;
                
                case 'o': /* --output, -o */
                    ostarget = malloc ( strlen ( optarg ) + 1 );
                    strcpy ( ostarget, optarg );
                    /* Check if the install route exists. */
                    if ( access ( ostarget, ( W_OK + R_OK ) ) != 0 )
                    {
                        /* printf ( "\n  \033[0;31;1m*** [E] The install route %s is not avaliable.\033[0m\n          You may not have sufficient privileges, or it doesn\'t exist.\n", ostarget ); */
                        printf ( "\n  *** [E] The install route %s is not avaliable.\n          You may not have sufficient privileges, or it doesn\'t exist.\n", ostarget );
                        return 0;
                    }
                    break;
                
                case 'v': /* --verbose, -v */
                    verbose_mode = 1;
                    break;
                    
                case 'q': /* --quiet, -q */
                    quiet_mode = 1;
                    break;
                    
                case 'p': /* --pause, -p */
                    will_pause = 1;
                    break;
                    
                case 'r': /* --reboot, -r */
                    will_reboot = 1;
                    break;
                    
                case 'f': /* --form=, -f */
                    /* Set the install formula */
                    if ( strcmp ( optarg, "edit" ) == 0 )
                        instform = EDIT_PRESENT;
                    else if ( strcmp ( optarg, "mbr" ) == 0 )
                             instform = EDIT_MBR;
                    else if ( strcmp ( optarg, "gpt" ) == 0 )
                             instform = EDIT_ESP;
                    else if ( strcmp ( optarg, "nodeploy" ) == 0 )
                             instform = EDIT_DONOT;
                    else
                    {
                        puts ( "Wrong formula." );
                        return 0;
                    }
                    break;
                    
                case 'h': /* --help, -h */
                    return 1;
                    
                case NO_VERIFY: /* --no-verify */
                    will_verify = 0;
                    break;
                    
                case NO_EXTRACT: /* --no-extract */
                    will_extract = 0;
                    break;
                    
                case '?': /* Unknown switch */
                    return 4;
                    
                /* It seems that GNU getopt_long() hasn't got this.
                case ':':
                    puts ( "Not enouth arguments" );
                    return 4;
                */
            }
        }
        /* Well... What if user forget to set osimage and ostarget? */
        if ( ( osimage == NULL ) || ( ostarget == NULL ) )
        {
            puts ( "\nIt seems that you forget to set image file and install route!" );
            return 0;
        }
        return 2;
    }

    if ( strcmp ( argv[1], "help" ) == 0 )
        return 1;
    
    if ( strcmp ( argv[1], "startup" ) == 0 )
        return 3;

    /* Whatever... return unknown. */
    return 4;
}
