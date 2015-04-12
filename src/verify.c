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

/* For do_verify's first parameter, to choose which checksum should be taken */
# define VMLINUZ  0
# define INITRD   1
# define LIVESQ   2

static int do_verify (img *imginfo, int which_file, char *file_to_verify);

int verify ( img *imginfo, int will_verify, char *systemdrive, char *ostarget )
{
    char file[MAX_PATH] = {0};

    /* First (osimage)/boot/vmlinuz */
    snprintf (file, MAX_PATH, "%s\\ast_strt\\vmlinuz", systemdrive);
    if (access (file, R_OK) == EXIT_SUCCESS)
    {
        if (do_verify (imginfo, VMLINUZ, file) == 0)
            ; /* Nothing to do! */
        else
            notify (WARN, "Failed to verify %s: File tainted.", file);
    }
    else
        notify (WARN, "Failed to verify %s: File lost.", file);

    /* Then (osimage)/boot/initrd */
    snprintf (file, MAX_PATH, "%s\\ast_strt\\initrd", systemdrive);
    if (access (file, R_OK) == EXIT_SUCCESS)
    {
        if (do_verify (imginfo, INITRD,file) == 0)
            ;
        else
            notify (WARN, "Failed to verify %s: File tainted.", file);
    }
    else
        notify (WARN, "Failed to verify %s: File lost.", file);

    /* Finally (osimage)/live/live.squashfs */
    snprintf (file, MAX_PATH, "%s\\live\\live.squashfs", ostarget);
    if (access (file, R_OK) == EXIT_SUCCESS)
    {
        if (do_verify (imginfo, LIVESQ, file) == 0)
            ;
        else
            notify (WARN, "Failed to verify %s: File tainted.", file);
    }
    else
        notify (WARN, "Failed to verify %s: File lost.", file);

    return 0; /* Return to run() */
}


static int do_verify (img *imginfo, int which_file, char *file_to_verify)
{
    # define compare(a,b,n) \
             if (strncmp (a, b, n) == 0) \
                 ;                                            \
             else                                             \
                 return 1;

    char sum[MD5SUM_LENGTH] = {0};
    int retVal = 0;

    retVal = md5sum(sum, file_to_verify);
    if (retVal == 0)
    {
        /* Verify succeeded, check if it marks */
        switch (which_file)
        {
            case VMLINUZ:
                compare (imginfo->vmlinuz_chksum, sum, MD5SUM_LENGTH);
            case INITRD:
                compare (imginfo->initrd_chksum, sum, MD5SUM_LENGTH);
            case LIVESQ:
                compare (imginfo->livesq_chksum, sum, MD5SUM_LENGTH);
        }
    }
    else
        notify (WARN, "Verify procedure failed (Error %d).", retVal); /* Verify procedure failed. Should have had sent error messages. */

    return 0;
}
