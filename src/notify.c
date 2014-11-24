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
        case SUCC: /* Success */
            clrprintf ( GREEN, "[S] " );
            break;
        case INFO: /* Information */
            clrprintf ( CYAN, "[I] " );
            break;
        case WARN: /* Warning */
            clrprintf ( YELLOW, "[W] " );
            break;
        case FAIL: /* Failure (Fatal error) */
            fclrprintf ( stderr, RED, "[E] " );
            break;
    }
    
    /* Print original messages */
    if ( TNotice == FAIL )
        vfprintf ( stderr, format, args );
    else
        vprintf ( format, args );
    
    printf ( "\n" );
    
    va_end ( args );
}