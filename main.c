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
# include <string.h>

# include "funcs.h" /* Dunction prototypes */
# include "defs.h" /* Definitions */

int main ( int argc, char **argv )
{
    /* Declare variables and initialize them. */
    int instform = EDIT_PRESENT,
        verbose_mode = NO, quiet_mode = NO,
        will_pause = NO, will_reboot = NO, will_verify = YES, will_extract = YES;
    char *osimage = ( char* ) NULL, *ostarget = ( char* ) NULL;

    struct img
    {
        int os;
        char *dist,
             *ver,
             *lang;
    } imginfo = { UNKN, NULL, NULL, NULL };
    /* End of variable declaration */
    
    puts (
"\n\
Anthon-Starter 0.2.0 Development Preview\n\
Copyright (C) 2014 Anthon Open Source Community"
         );
    /* Check the arguments. */
    switch ( chkargs ( argc, argv,
                       osimage, ostarget,
                       instform, verbose_mode, quiet_mode,
                       will_pause, will_reboot, will_verify, will_extract
                     ) )
    {
        case 0:
            /* It works! (Or chkargs() just want main to return 1. AHHH what I'm doing...) */
            return 1;
        case 1:
            /* Need help */
            help_message();
            return 0;
        case 2:
            /* Start running */
            /* printf ( "\033[0;32;1mDone. Now run.\033[0m\n" ); */
            printf ( "Done. Now run.\n" );
            run ( osimage, ostarget,
                  instform, verbose_mode, quiet_mode,
                  will_pause, will_reboot, will_verify, will_extract );
            return 0;
        case 3:
            /* startup */
            puts ( "Active startup." );
            /* startup */
            break;
        case 4:
            /* unknown argument */
            help_message();
            return 1;
    }

    /* TODO:
     * chkargs( ... );
     * switch ( xxx );
     * ...
     */
    
    return 1;
}
