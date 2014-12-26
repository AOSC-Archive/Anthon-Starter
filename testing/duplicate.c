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

/* # include "ast.h" */
# include <stdio.h>
# include <stdlib.h>
# include <unistd.h>

# define BUF_SIZE 512

int duplicate ( const char *src, char *dest );

int main ( void )
{
    char *src  = malloc ( BUF_SIZE ),
         *dest = malloc ( BUF_SIZE );
    
    scanf ( "%512s %512s", src, dest );
    
    duplicate ( src, dest );
    
    return 0;
}

int duplicate ( const char *src, char *dest )
{
    FILE *fin  = NULL,
         *fout = NULL;
    char *bufin  = malloc ( BUF_SIZE ),
         *bufout = malloc ( BUF_SIZE );
    
    if ( access ( src, R_OK ) == 0 )
    {
        if ( access ( dest, ( W_OK + R_OK ) ) == 0 )
        {
            fin  = fopen ( src , "rb" );
            snprintf(dest, BUF_SIZE, "%s%s", dest, "tgt.mp4");
            fout = fopen ( dest, "wb" );
            //setvbuf ( fin , bufin , _IOFBF, 4096 );
            //setvbuf ( fout, bufout, _IOFBF, 4096 );
            while ( !feof ( fin ) )
                fputc ( fgetc ( fin ), fout );
        }
        else
        {
            puts("Destination not available");
            exit(2);
        }
    }
    else
    {
        puts("Source not available");
        exit(2);
    }

    
    fclose ( fin  );
    fclose ( fout );
    
    return 0;
}