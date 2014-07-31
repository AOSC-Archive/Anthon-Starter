/*
 * Anthon-Starter: Installation helper for AOSC OS series, version 0.2.0
 * Copyright (C) 2014 Anthon Open Source Community
 * This file is a part of Anthon-Starter.
 * 
 * Anthon-Starter is licensed under GNU LGPL: you can redistribute it
 * and/or modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation, either
 * version 3 of the License, or (at your option) any later version.
 * 
 * Anthon-Starter is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with Anthon-Starter. If not, see
 * <http://www.gnu.org/licenses/>.
 */

/* Note: This function is based on Heroin's "colourful console"
 * ( http://www.oschina.net/code/snippet_48783_329 ).
 * Thanks to his code.
 */

# include <stdio.h>
# include <windows.h>

# include "funcs.h"
# include "defs.h"

void clrprint ( char* str, WORD color )
{
    WORD colorOld;
    HANDLE handle = GetStdHandle ( STD_OUTPUT_HANDLE );
    CONSOLE_SCREEN_BUFFER_INFO csbi;
    GetConsoleScreenBufferInfo ( handle, &csbi );
    colorOld = csbi.wAttributes;
    SetConsoleTextAttribute ( handle, color );
    printf ( str );
    SetConsoleTextAttribute ( handle, colorOld );
}
