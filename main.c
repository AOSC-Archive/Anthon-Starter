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
/* In MinGW io.h is directory put in root directory.
 * For I'm working with Linux now so it is in directory "sys". Will change when returning to Windows (w)
 * # include <io.h>
 */
# include <sys/io.h>
# include <stdlib.h>
# include <string.h>

# include "funcs.h" /* Dunction prototypes */
# include "defs.h" /* Definitions */

int main ( int argc, char **argv )
{
    /* Declare variables and initialize them. */
    int loader = LOADER_UNKNOWN, instform = EDIT_PRESENT, ptable = PTABLE_UNKNOWN;
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
    switch ( chkargs ( argc, argv ) )
    {
        case 0:
            // run 
            break;
        case 1:
            help_message();
            return 0;
        case 2:
            // startup
            puts ( "Active startup." );
            break;
        case 3:
            // Debug use
            return 0;
        case 4:
            // unknown argument
            printf ( "Unknown command: %s\n", argv[1] );
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
