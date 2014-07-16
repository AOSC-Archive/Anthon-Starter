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
    int loader = LOADER_UNKNOWN, instform = EDIT_PRESENT, ptable = PTABLE_UNKNOWN,
        verbose_mode = 0, quiet_mode = 0,
        will_pause = 0, will_reboot = 0, will_verify = 1, will_extract = 1;
    char *osimage = ( char* ) NULL, *ostarget = ( char* ) NULL;

    struct img
    {
        int os;
        char *dist,
             *ver,
             *lang;
    } imginfo = { UNKN, NULL, NULL, NULL };
    /* End of variable declaration */
    
    /* Check the arguments. */
    switch ( chkargs ( argc, argv,
                       osimage, ostarget,
                       instform, verbose_mode, quiet_mode,
                       will_pause, will_reboot, will_verify, will_extract
                     ) )
    {
        case 0:
            // It works! (Or chkargs() just want main to return 1.)
            break;
        case 1:
            // Need help
            help_message();
            return 0;
        case 2:
            // Start running
            puts ( "Now run." );
            return 0;
        case 3:
            // startup
            puts ( "Active startup." );
            break;
        case 4:
            // unknown argument
            help_message();
            return 1;
        default:
            break;
            // wtf?
    }

    /* TODO:
     * chkargs( ... );
     * switch ( xxx );
     * ...
     */
    
    return 1;
}
