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

# define BUFSIZE 40960 /* 4 MiB */

int duplicate ( const char *src, char *dest )
{
    int errVal = 0;
    
    switch (CopyFile (src, dest, TRUE))
    {
        case 0:
            /* Copying procedure failed (according to MSDN Library) */
            errVal = GetLastError ();
            switch (errVal)
            {
                case ERROR_FILE_NOT_FOUND:
                    notify (FAIL, "File not found: %s\n    We cannot do more. Abort.", src);
                default:
                    notify (FAIL, "Unknown error (%d) occurred when copying %s\n    Abort.", errVal, src);
                    exit (1);
            }
        default:
            break; /* Copying procedure succeeded */
    }
    
    return 0;
}

