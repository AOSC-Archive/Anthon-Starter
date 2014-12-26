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
# include <time.h>

# define BUF_SIZE 512

int duplicate ( const char *src, char *dest );

int main ( int argc, char **argv )
{
    time_t a=time(NULL);
    duplicate ( argv[1], argv[2] );
    printf("used %lds", (time(NULL) - a) );
    
    return 0;
}

int duplicate ( const char *src, char *dest )
{
    FILE *fin  = NULL,
         *fout = NULL;
    
    if ( access ( src, R_OK ) == 0 )
    {
            fin  = fopen ( src , "rb" );
            fout = fopen ( dest, "wb" );
            //setvbuf ( fin , NULL, _IOFBF, 40960 );
            setvbuf ( fout, NULL, _IOFBF, 40960 );
            while ( !feof ( fin ) )
                fputc ( fgetc ( fin ), fout );
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