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


int init ( img *imginfo, char *osimage, char *ostarget )
{
    char *tmp = NULL, *temp = getenv ( "TEMP" );
    FILE *sum = NULL;
    
    if ( access ( "res\\7z.exe", X_OK ) == 0 )
    {
        tmp = malloc ( 64 + strlen ( osimage ) ); /* I can't be bothered to allocate accurate memory. */
        snprintf ( tmp, CMD_BUF, "%s %s %s%s %s%c", "res\\7z.exe x", osimage, "-o", "%temp%\\", "md5sum.ast -y > nul", '\0' ); /* NOTICE: ">nul" is not portable */
        system ( tmp ); /* Extract md5sum.ast to %TEMP% */

        snprintf ( tmp, CMD_BUF, "%s%s", temp, "\\md5sum.ast" );
        if ( ( sum = fopen ( tmp, "rt" ) ) != NULL ) /* Open md5sum.ast as text, read only */
        {
            /* Memory allocation first */
            imginfo -> dist           = malloc ( 5 ); /* anos'\0' */
            imginfo -> ver            = malloc ( CMD_BUF );
            imginfo -> lang           = malloc ( 6 ); /* en_US'\0' */
            imginfo -> vmlinuz_chksum = malloc ( MD5SUM_LENGTH );
            imginfo -> initrd_chksum  = malloc ( MD5SUM_LENGTH );
            imginfo -> livesq_chksum  = malloc ( MD5SUM_LENGTH );

            if ( fscanf ( sum, "%*[^\n] %*s os%1d %4s %512s %5s %32s %*s %32s %*s %32s",
                                &(imginfo->os), imginfo->dist, imginfo->ver, imginfo->lang, /* FIXME: Some image files do not include "lang" field, and this will make mistakes in md5sum fields. */
                                imginfo->vmlinuz_chksum, imginfo->initrd_chksum, imginfo->livesq_chksum ) != 7 )
            {
                notify ( FAIL, "Failed to read md5sum.ast! Program exits." );
                exit ( 1 );
            }

            notify ( INFO, "Image info:\n      os    : %d\n      dist  : %s\n      ver   : %s\n      lang  : %s\n      vmlchk: %s\n      inichk: %s\n      livchk: %s\n", imginfo->os, imginfo->dist, imginfo->ver, imginfo->lang, imginfo->vmlinuz_chksum, imginfo->initrd_chksum, imginfo->livesq_chksum );

            fclose ( sum );
            sum = NULL; /* FILE *sum */
            /* FIXME: Not deleting the file extracted. */
            take ( tmp );
        }
        else
        {
            notify ( FAIL, "This ISO image is not supported.\n" );
            take ( tmp );
            exit ( 1 );
        }
    }
    else
    {
        notify ( FAIL, "Cannot find 7-Zip executable. Program exits.\n" );
        exit ( 1 );
    }

    return 0;
}
