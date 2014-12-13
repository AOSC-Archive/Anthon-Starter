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
    FILE *sumf = NULL;
    
    /* First check if 7-Zip exists :) */
    if ( access ( "res\\7z.exe", X_OK ) == 0 )
    {
        /* tmp: temporary command line buffer */
        tmp = malloc ( CMD_BUF ); /* FIXME: I can't be bothered to allocate accurate memory :P */
        
        /* Execute res\7z.exe to extract the md5sum file inside */
        /* New standard: (osimage)/md5sum */
        
        /* Output the command line to buffer (tmp) first... */
        snprintf ( tmp, CMD_BUF, "%s %s %s%s %s%c", "res\\7z.exe x", osimage, "-o", "%temp%\\", "md5sum -y > nul", '\0' ); /* NOTICE: ">nul" is not portable */
        /* Extract md5sum to %TEMP% */
        system ( tmp ); /* WTF after 7-Zip failed it still returns 0! */
        
        /* So check the file's existence. */
        snprintf ( tmp, CMD_BUF, "%s%s%c", temp, "\\md5sum", '\0' ); /* Put it in the buffer */
        if ( access( tmp, R_OK ) == 0 )
        {
            /* md5sum exists and readable, obey the new standard */
            snprintf ( tmp, CMD_BUF, "%s%s%c", temp, "\\md5sum", '\0' );
            if ( ( sumf = fopen ( tmp, "rt" ) ) != NULL ) /* Open md5sum as text, read only */
            {
                /* Memory allocation first */
                imginfo -> dist            = malloc ( 5 ); /* live'\0' */
                imginfo -> ver             = malloc ( CMD_BUF );
                imginfo -> vmlinuz_chksum  = malloc ( MD5SUM_LENGTH );
                imginfo -> initrd_chksum   = malloc ( MD5SUM_LENGTH );
                imginfo -> livesq_chksum   = malloc ( MD5SUM_LENGTH );
                
                /* Read-in */
                char *ident = malloc ( 12 ); /* Temporary use: #ast-ident:'\0' */
                while ( feof ( sumf ) == 0 )
                {
                    /* FIXME: A better reading method needed! */
                    fscanf ( sumf, "%11s", ident );
                    if ( strcmp ( ident, "#ast-ident:" ) == 0 ) /* #ast-ident: os3 live yyyymmdd */
                    {
                        if ( fscanf ( sumf, " os%1d %4s %8s%*[^\n]", /* 1 Space left still after last fscanf(), and skip the whole line. */
                                            &(imginfo->os), imginfo->dist, imginfo->ver ) == 3 )
                        {
                            /* Verify whether they're valid or not */
                            if (    ( imginfo->os == 0 )
                                 || ( strcmp ( imginfo->dist, "live" ) != 0 )
                                 || ( strlen ( imginfo->ver ) != 8 ) )
                            {
                                /* Not correct */
                                notify ( FAIL, "Error when reading md5sum (ident): It may not a supported AOSC OS.\n    Please contact us to get help. Program exits." );
                                exit ( 1 );
                            }
                            /* else: nothing to do! */
                        } /* if ( fscanf ( sumf, ... ) */
                        else
                        {
                            notify ( FAIL, "Not a correct md5sum file! Program exits." );
                            exit ( 1 );
                        }
                    } /* if ( strcmp ( ident, "#ast-ident:" ) == 0 ) */
                    else
                    {
                        if ( strcmp ( ident, "#md5sum" ) == 0 )
                        {
                            /* MD5 Checksums now reading */
                            if ( fscanf ( sumf, "%32s %*s %32s %*s %32s",
                                                imginfo->vmlinuz_chksum, imginfo->initrd_chksum, imginfo->livesq_chksum ) == 3 )
                            {
                                /* Verify whether they're valid or not */
                                if (    ( strlen ( imginfo->vmlinuz_chksum ) != 32 )
                                     || ( strlen ( imginfo->initrd_chksum  ) != 32 )
                                     || ( strlen ( imginfo->livesq_chksum  ) != 32 ) )
                                {
                                    /* Not correct */
                                    notify ( FAIL, "Error when reading md5sum (chksum): It may not a supported AOSC OS.\n    Please contact us to get help. Program exits." );
                                    exit ( 1 );
                                }
                                /* else: of cource nothing to do! */
                            }
                            else
                            {
                                notify ( FAIL, "Not a correct md5sum file! Program exits." );
                                exit ( 1 );
                            }
                        }
                        else
                            fscanf ( sumf, "%*[^\n]" ); /* Skip this line */
                    }
                } /* while ( feof ( sumf ) == 0 ) */
                take ( ident );
            } /* if ( ( sumf = fopen ( tmp, "rt" ) ) != NULL ) */
            else
            {
                /* File in %TEMP% lost? WTF? */
                notify ( FAIL, "Unknown error: File in %%temp%% not found. Program exits." );
                exit ( 1 );
            }
        } /* if ( access( tmp, R_OK ) == 0 ) */
        else
        {
            /* (osimage)/md5sum not exists. Try old standard (md5sum.ast) */
            snprintf ( tmp, CMD_BUF, "%s %s %s%s %s%c", "res\\7z.exe x", osimage, "-o", "%temp%\\", "md5sum.ast -y > nul", '\0' ); /* NOTICE: ">nul" is not portable */
            system ( tmp );
            
            /* Check the file's existence */
            snprintf ( tmp, CMD_BUF, "%s%s%c", temp, "\\md5sum.ast", '\0' ); /* Put it in the buffer */
            if ( access ( tmp, R_OK ) == 0 )
            {
                /* md5sum.ast exists, obey the old standard */
                snprintf ( tmp, CMD_BUF, "%s%s%c", temp, "\\md5sum.ast", '\0' );
                if ( ( sumf = fopen ( tmp, "rt" ) ) != NULL ) /* Open md5sum.ast as text, read only */
                {
                    /* Memory allocation first */
                    imginfo -> dist            = malloc ( 5 ); /* anos'\0' */
                    imginfo -> ver             = malloc ( CMD_BUF );
                    imginfo -> lang            = malloc ( 6 ); /* en_US'\0' */
                    imginfo -> vmlinuz_chksum  = malloc ( MD5SUM_LENGTH );
                    imginfo -> initrd_chksum   = malloc ( MD5SUM_LENGTH );
                    imginfo -> livesq_chksum   = malloc ( MD5SUM_LENGTH );
                
                    /* Read-in */
                    /* FIXME: A better reading method needed! */
                    if ( fscanf ( sumf, "%*[^\n] %*s os%1d %4s %512s %5s %32s %*s %32s %*s %32s",
                                        &(imginfo->os), imginfo->dist, imginfo->ver, imginfo->lang,
                                        imginfo->vmlinuz_chksum, imginfo->initrd_chksum, imginfo->livesq_chksum ) == 7 )
                    {
                        /* Examine the correction of the image information */
                        if (    ( imginfo->os == 0 )
                             || ( strlen ( imginfo->dist ) != 4 )
                             || ( strlen ( imginfo->ver ) == 0 )
                             || ( strlen ( imginfo->lang ) == 0 )
                             || ( strlen ( imginfo->vmlinuz_chksum ) != 32 )
                             || ( strlen ( imginfo->initrd_chksum  ) != 32 )
                             || ( strlen ( imginfo->livesq_chksum  ) != 32 ) )
                        {
                            /* Not correct */
                            notify ( FAIL, "Error when reading md5sum.ast: It may not a supported AOSC OS.\n    Please contact us to get help. Program exits." );
                            exit ( 1 );
                        }
                        /* else: nothing to do. That's good. */
                    } /* if ( fscanf ( sumf, ... ) */
                    else
                    {
                        notify ( FAIL, "Not a correct md5sum.ast file! Program exits." );
                        exit ( 1 );
                    }
                } /* if ( ( sumf = fopen ( tmp, "rt" ) ) != NULL ) */
                else
                {
                    /* File in %TEMP% lost? WTF? */
                    notify ( FAIL, "Unknown error: File in %%temp%% not found. Program exits." );
                    exit ( 1 );
                }
            } /* if ( access ( "%temp%\\md5sum.ast", R_OK ) == 0 ) */
            else
            {
                /* Not new standard or old standard, there can't be other reasons: Trash. */
                notify ( FAIL, "Fatal: This file is not supported. Program exits." );
                exit ( 1 );
            }
        } /* End of old standard reading */

        /* This will be changed when release. (Won't be so ugly) */
        notify ( INFO, "Image info:\n      os    : %d\n      dist  : %s\n      ver   : %s\n      lang  : %s\n      vmlchk: %s\n      inichk: %s\n      livchk: %s\n", imginfo->os, imginfo->dist, imginfo->ver, imginfo->lang, imginfo->vmlinuz_chksum, imginfo->initrd_chksum, imginfo->livesq_chksum );

        fclose ( sumf );
        /* FIXME: Coverity reports bug here? */
        remove ( tmp ); /* Remove the md5sum file */
        sumf = NULL;    /* FILE *sumf */
        take ( tmp );   /* Take the memory of buffer */
    } /* if ( access ( "res\\7z.exe", X_OK ) == 0 ) */
    else
    {
        /* 7z executable not found */
        notify ( FAIL, "Cannot find 7-Zip executable. Program exits.\n" );
        exit ( 1 );
    }

    return 0;
}
