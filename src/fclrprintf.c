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

/* Note: This function is based on Heroin's "colourful console"
 * ( http://www.oschina.net/code/snippet_48783_329 ).
 * Thanks to his code.
 * 
 * Color definitions are in defs.h
 */

# include "ast.h"

void fclrprintf ( FILE *stream, WORD color, char* format, ... )
{
    va_list args;
    va_start ( args, format );
    
    WORD colorOld;
    HANDLE handle = GetStdHandle ( STD_OUTPUT_HANDLE );
    CONSOLE_SCREEN_BUFFER_INFO csbi;
    GetConsoleScreenBufferInfo ( handle, &csbi );
    colorOld = csbi.wAttributes;
    SetConsoleTextAttribute ( handle, color );
    
    /* NOTICE:
     *   When stdout is redirected, message will be output successfully,
     *   but the colour won't appear.
     */
    vfprintf ( stream, format, args );
    
    va_end ( args );
    SetConsoleTextAttribute ( handle, colorOld );
}
