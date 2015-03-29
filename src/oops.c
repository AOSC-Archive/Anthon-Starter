/*
 * Anthon-Starter: Installation helper for AOSC OS series, version 0.2.0
 * Copyright (C) 2012-2015 Anthon Open Source Community
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

# define WARNINGS "\
Warning: You may have some unfinished process when this exception was caught.\n\
         If so, remember to check the availability of these files:\n\
           - Native boot loader\n\
           - Extracted files (if exist)\n\
           - MBR/ESP\n\
           - Backed-up files (if exist)\n\
         You can find backup files in folder %systemdrive%\\ast_bkup."

void oops ( int signo )
{
    time_t timer = time ( NULL );
    printf ( "\n========== STOP: At %s", ctime ( &timer ) );
    switch ( signo )
    {
        case SIGINT: /* Control-C */
            printf ( "Program received SIGINT (#%d).\nThis is usually because you have pressed \"Control-C\".\n\n%s\n\nExit.\n", SIGINT, WARNINGS );
            exit ( 255 );
        case SIGTERM:
            printf ( "Program received SIGTERM (#%d).\nThis is usually because you have sent a terminal signal.\n\n%s\n\nExit.\n", SIGTERM, WARNINGS );
            exit ( 255 );
        case SIGBREAK: /* Control-Pause (Break) */
            printf ( "Program received SIGBREAK (#%d).\nThis is ususlly because you have pressed \"Control-Break\".\n\n%s\n\nExit.\n", SIGBREAK, WARNINGS );
            exit ( 255 );
        case SIGSEGV: /* Segmentation violation */
            printf ( "Program received SIGSEGV (Segmentation Fault: #%d).\nThis is usually because of an internal error (BUG).\nPlease report this bug to:\n  <https://bugs.anthonos.org> or\n  <https://github.com/AOSC-Dev/Anthon-Starter/issues>\n\n%s\n\nExit.\n", SIGSEGV, WARNINGS );
            exit ( SIGSEGV ); /* Signal #11 (May be changed later) */
            // break;
    }
}

