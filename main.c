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
# include <sys/io.h>
# include <stdlib.h>
# include <string.h>

# include "funcs.h"

# define PTABLE_UNKNOWN 0
# define PTABLE_MBR 5
# define PTABLE_GPT 6

# define LOADER_NTLDR 7
# define LOADER_BCD 8
# define LOADER_UNKNOWN 9

# define EDIT_PRESENT 15
# define EDIT_MBR 16
# define EDIT_ESP 17

# define ANOS 25
# define ANCP 26
# define ICNL 27
# define SPIN 28
# define UNKN 29

int main ( int argc, char **argv, char **envp )
{
    /* Declare variables */
    int loader = LOADER_UNKNOWN, instform = EDIT_PRESENT, ptable = PTABLE_UNKNOWN;
    char *osimage = ( char* ) NULL, *ostarget = ( char* ) NULL;

    struct img
    {
        int os;
        char *dist,
             *ver,
             *lang;
    } imginfo = { UNKN,
                  NULL,
                  NULL,
                  NULL
                };
    
    /*
    switch ( chkargs() )
    {
        case 0:
            // run 
            break;
        case 1:
            // help
            break;
        default:
            // wtf?
    }
    */
    
    /* TODO:
     * chkargs( ... );
     * switch ( xxx );
     * ...
     */
    help_message();
    return 1;
}