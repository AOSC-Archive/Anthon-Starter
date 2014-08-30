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

# include <stdio.h>
# include <stdlib.h>
# include <string.h>

# include "funcs.h"
# include "defs.h"

int main ( int argc, char **argv )
{
    /* Declare variables and initialize them. */
    int instform = EDIT_PRESENT,
        verbose_mode = 0, quiet_mode = 0,
        will_pause = 0, will_reboot = 0, will_verify = 1, will_extract = 1;
    char *osimage = ( char* ) NULL, *ostarget = ( char* ) NULL;

    img imginfo = { 0, NULL, NULL, NULL, NULL, NULL, NULL };
    /*
    ( img * ) malloc ( sizeof ( img ) );
    memset ( imginfo, 0, sizeof ( img ) );
    */
    /* End of variable declaration */

    /* It's just, just, have fun. */
    if ( argv[1] == NULL )
    {
        MessageBox ( NULL, "Sorry we haven't finished GUI design yet.\nPlease feel free using CLI :)", "Anthon-Starter 0.2", MB_ICONINFORMATION|MB_OK );
        return 1;
    }




    puts ( "Anthon-Starter 0.2.0 Development Preview\nCopyright (C) 2014 Anthon Open Source Community\n" );

    /* Check the arguments. */
    switch ( chkargs ( argc, argv,
                       osimage, ostarget,
                       &imginfo, &instform, &verbose_mode, &quiet_mode,
                       &will_pause, &will_reboot, &will_verify, &will_extract) )
    {
        case 0:
            /* It works! (Or chkargs() just want main to return 1. AHHH what I'm doing...) */
            return 1;
        case 1:
            /* Need help */
            help_message( argv[0] );
            return 0;
        case 2:
            printf ("os: %d\ndist: %s\nver: %s\nlang: %s\nvml: %s\nini: %s\nliv: %s\n", imginfo.os, imginfo.dist, imginfo.ver, imginfo.lang, imginfo.vmlinuz_chksum, imginfo.initrd_chksum, imginfo.livesq_chksum );
            /* Start running */
            /* printf ( "\033[0;32;1mDone. Now run.\033[0m\n" ); */
            puts ( "Parameters and image checking done." );
            run ( osimage, ostarget,
                  &imginfo, instform, verbose_mode, quiet_mode,
                  will_pause, will_reboot, will_verify, will_extract );
            return 0;
        case 3:
            /* startup */
            puts ( "Active startup." );
            /* startup */
            break;
        case 4:
            /* unknown argument */
            help_message( argv[0] );
            return 1;
    }
    return 1;
}
