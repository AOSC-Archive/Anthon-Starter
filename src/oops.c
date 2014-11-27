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

void oops ( int signo )
{
    time_t timer = time ( NULL );
    printf ( "\n========== At %s", ctime ( &timer ) );
    switch ( signo )
    {
        case SIGINT:
            puts ( "Program received SIGINT. Exit." );
            exit ( 255 );
        case SIGTERM:
            puts ( "Program received SIGTERM. Exit." );
            exit ( 255 );
        case SIGBREAK:
            puts ( "Program received SIGBREAK. Exit." );
            exit ( 255 );
        case SIGSEGV:
            printf ( "Program received SIGSEGV (Segmentation Fault)." );
            break;
    }
}