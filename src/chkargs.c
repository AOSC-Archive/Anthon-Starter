/*
 * Anthon-Starter: Installation helper for AOSC OS series, version 0.2.0
 * Copyright (C) 2014 Anthon Open Source Community
 * This file is a part of Anthon-Starter.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

# include "ast.h"

int chkargs ( int argc, char **argv,
              char *osimage, char *ostarget,
              img *imginfo, int *instform, int *verbose_mode, int *quiet_mode,
              int *will_pause, int *will_reboot, int *will_verify, int *will_extract )
{

    struct option longopts[] = {
        { "live"       , required_argument , NULL, 'l'        },
        { "output"     , required_argument , NULL, 'o'        },
        { "verbose"    , no_argument       , NULL, 'v'        },
        { "quiet"      , no_argument       , NULL, 'q'        },
        { "pause"      , no_argument       , NULL, 'p'        },
        { "reboot"     , no_argument       , NULL, 'r'        },
        { "form"       , required_argument , NULL, 'f'        },
        { "no-verify"  , no_argument       , NULL, NO_VERIFY  },
        { "no-extract" , no_argument       , NULL, NO_EXTRACT },
        { "help"       , no_argument       , NULL, 'h'        },
        { 0            , 0                 , 0   , 0          }  };

    /* These are for getopt_long() */
    extern char *optarg;
    char opttmp = '\0';
    
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
                        notify ( FAIL, "The ISO image is not avaliable.\n    You may not have sufficient privileges, or it doesn\'t exist.\n" );
                        return 0; /* main() returns 1 */
                    }
                    break;

                case 'o': /* --output, -o */
                    ostarget = malloc ( strlen ( optarg ) + 1 );
                    strcpy ( ostarget, optarg );
                    /* Check if the install route exists. */
                    if ( access ( ostarget, ( W_OK + R_OK ) ) != 0 )
                    {
                        notify ( FAIL, "The install route is not avaliable.\n    You may not have sufficient privileges, or it doesn\'t exist.\n" );
                        return 0; /* main() returns 1 */
                    }
                    break;

                case 'v': /* --verbose, -v */
                    *verbose_mode = 1;
                    break;

                case 'q': /* --quiet, -q */
                    *quiet_mode = 1;
                    break;

                case 'p': /* --pause, -p */
                    *will_pause = 1;
                    break;

                case 'r': /* --reboot, -r */
                    *will_reboot = 1;
                    break;

                case 'f': /* --form=, -f */
                    /* Set the install formula */
                    if ( strcmp ( optarg, "edit" ) == 0 )
                        *instform = EDIT_PRESENT;
                    else if ( strcmp ( optarg, "mbr" ) == 0 )
                             *instform = EDIT_MBR;
                    else if ( strcmp ( optarg, "gpt" ) == 0 )
                             *instform = EDIT_ESP;
                    else if ( strcmp ( optarg, "nodeploy" ) == 0 )
                             *instform = EDIT_DONOT;
                    else
                    {
                        puts ( "Wrong formula." );
                        return 0;
                    }
                    break;

                case 'h': /* --help, -h */
                    return 1;

                case NO_VERIFY: /* --no-verify */
                    *will_verify = 0;
                    break;

                case NO_EXTRACT: /* --no-extract */
                    *will_extract = 0;
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
            notify ( FAIL, "It seems that you forget to set the image file and the install route!\n" );
            return 0;
        }
        take ( ostarget );
        return 2; /* after getopt_long(), main() invokes run() */
    }

    if ( strcmp ( argv[1], "help" ) == 0 )
        return 1; /* main() invokes help_message() */

    if ( strcmp ( argv[1], "startup" ) == 0 )
        return 3; /* main() invokes startup() */

    /* Whatever... return unknown. */
    return 4;
}
