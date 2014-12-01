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

void notify ( int TNotice, char *format, ... )
{
    va_list args;
    va_start ( args, format );
    
    switch ( TNotice ) /* TNotice is declared in ast.h */
    {
        char tmp;
        case SUCC: /* Success */
            clrprintf ( GREEN, "[S] " );
            vprintf ( format, args );
            break;
        case INFO: /* Information */
            clrprintf ( CYAN, "[I] " );
            vprintf ( format, args );
            break;
        case WARN: /* Warning */
            clrprintf ( YELLOW, "[W] " );
            vprintf ( format, args );
            /* Pause to enquire user whether continue this operation or not. */
            if ( always_yes == 0 )
            {
                printf ( "\n    Continue? ([y]es/[n]o) " );
                while ( 1 )
                {
                    tmp = getch();
                    switch ( tmp )
                    {
                        case 'Y':
                        case 'y':
                            printf ( "\n" );
                            return; /* Exit the function */
                        case 'N':
                        case 'n':
                            puts ( "\nAbort." );
                            exit ( 255 ); /* User Terminated */
                        case '':
                            /* SIGINT */
                            raise ( SIGINT );
                            break;
                        default:
                            break; /* Repeat */
                    }
                }
            }
            else
                ; /* Nothing to do */
            break;
        case FAIL: /* Failure (Fatal error) */
            fclrprintf ( stderr, RED, "[E] " );
            vfprintf ( stderr, format, args );
            break;
    }
    
    printf ( "\n" );
    
    va_end ( args );
}