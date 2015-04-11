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

static int do_extract (const char *image, const char *target, const char *file_to_extract);
extern int duplicate ( const char *src, char *dest ); /* FIXME: HEAD FILE LOST (in src/duplicate.c, should include duplicate.h) */

int extract ( int will_extract, char *systemdrive, char *osimage, char *ostarget )
{
    if (will_extract)
    {
        if (access("res\\7z.exe", X_OK) == 0)
        {
            char temp_path[MAX_PATH] = {0};
            char bufSrc[MAX_PATH] = {0}, bufTgt[MAX_PATH] = {0};

            /* Get temporary directory */
            GetTempPath (MAX_PATH, temp_path);

            /* Files will be extracted in the priority of:
             * - (osimage)/boot/vmlinuz
             * - (osimage)/boot/initrd.img
             * - (osimage)/live/live.squashfs
             * First these files will be extracted to %temp%. According to comments in AST 0.1.2.0 (main.bat: 799-801):
             *
             *   :: While extracting the files in [image_file]/boot/ , the new folder "boot" will be created by 7-Zip too.
             *   :: For some users would install some recovery software (like "One-key Ghost", they will create a folder named "boot" too),
             *   ::   we first extract them into %temp%\ and then copy them into ast_strt\ .
             *
             * After extracted these files, we will move them into correct directories.
             */

            /* Now is (osimage)/boot/vmlinuz */
            notify (INFO, "Extracting pre-install environment kernel to temporary directory...");
            if (do_extract (osimage, temp_path, "boot\\vmlinuz") == EXIT_SUCCESS)
                notify (SUCC, "Extracted pre-install environment kernel.");
            else
                ; /* Program will be aborted inside the function do_extract() if exceptions was caught, so nothing to do here. */

            /* And (osimage)/boot/initrd.img */
            notify (INFO, "Extracting pre-install environment RAM disk to temporary directory...");
            if (do_extract (osimage, temp_path, "boot\\initrd") == EXIT_SUCCESS)
                notify (SUCC, "Extracted pre-install environment RAM disk.");

            /* Finally (osimage)/live/live.squashfs */
            notify (INFO, "Extracting the Live environment...\n    It may take a few minutes, please wait patiently...");
            if (do_extract (osimage, ostarget, "live\\live.squashfs") == EXIT_SUCCESS)
                notify (SUCC, "Extracted the Live environment.");

            /* Make target directory to put files */
            /* For pre-install environment */
            snprintf (bufTgt, MAX_PATH, "%s\\ast_strt\\", systemdrive);
            if (_mkdir (bufTgt) != EXIT_SUCCESS)
            {
                notify (FAIL, "Failed to create startup directory (Error %d). Abort.", errno);
                exit (1);
            }

            /* Move files */
            /* First (osimage)/boot/vmlinuz, to %SystemDrive% */
            notify (INFO, "Copying pre-install environment kernel to the actual directory...");
            snprintf (bufSrc, MAX_PATH, "%s\\boot\\vmlinuz", temp_path);
            snprintf (bufTgt, MAX_PATH, "%s\\ast_strt\\vmlinuz", systemdrive);
            duplicate (bufSrc, bufTgt);
            notify (SUCC, "Copied pre-install environment kernel.");
            /* Then (osimage)/boot/initrd.img */
            notify (INFO, "Copying pre-install environment RAM disk to the actual directory...");
            snprintf (bufSrc, MAX_PATH, "%s\\boot\\initrd", temp_path);
            snprintf (bufTgt, MAX_PATH, "%s\\ast_strt\\initrd", systemdrive);
            duplicate (bufSrc, bufTgt);
            notify (SUCC, "Copied pre-install environment RAM disk.");
            /* No need to copy (osimage)/live/live.squashfs (done by extract directly) */

            return 0; // Back to run()
        } /* if (access("res\\7z.exe", X_OK) == 0) */
        else
        {
            notify (FAIL, "Fatal: Cannot find 7-Zip executable, files cannot be extracted. Abort.");
            exit (2);
        }
    } /* if (will_extract) */
    else
    {
        notify (INFO, "Extract procedure skipped by user.");
        return 0;
    }
}


static int do_extract (const char *image, const char *target, const char *file_to_extract)
{
    char cmdline[MAX_PATH] = {0};
    long retval = 0; /* For GetExitCodeProcess() */
    STARTUPINFO si;
    PROCESS_INFORMATION pi;

    /* Set these structures zero to prevent from exceptions */
    ZeroMemory (&si, sizeof (si));
    ZeroMemory (&pi, sizeof (pi));

    if (access (target, R_OK + W_OK) == 0)
    {
        snprintf (cmdline, MAX_PATH, "res\\7z.exe x %s -o%s %s -y", image, target, file_to_extract); // 7-Zip use these arguments to extract files
        //printf ("%s\n", cmdline);
        si.cb = sizeof (si); // Initialize STARTUPINFO structure
        if (!CreateProcess (NULL,
                            TEXT(cmdline), /* NOTICE: According to MSDN Library, here cmdline should be able to be modified in Unicode version. */
                            NULL,
                            NULL,
                            FALSE,
                            CREATE_NO_WINDOW,
                            NULL,
                            NULL,
                            &si,
                            &pi))
        {
            /* CreateProcess failed */
            notify (FAIL, "Failed to invoke 7-Zip to extract files from the image. We cannot do more.\nAbort.");
            exit (1);
        }

        /* Wait until child process (7-Zip) exits. */
        WaitForSingleObject (pi.hProcess, INFINITE);

        /* Get 7-Zip's return value and check if it worked */
        GetExitCodeProcess (pi.hProcess, (LPDWORD)&retval);

        /* TODO: Judge whether 7-Zip succeeded or not. */
        if (retval != 0)
        {
            switch (retval)
            {
                case STILL_ACTIVE:
                    /* 7-Zip is still active (This should never happen) */
                    break;
                case 1: /* General error */
                    notify (FAIL, "7-Zip returns %d, reporting that it was failed to extract \"vmlinuz\".\nWe cannot do more. Abort.", retval);
                    exit (1);
                case 2: /* File not found */
                case 7: /* I forget it... */
                default:
                    notify (FAIL, "We meet an unknown error with 7-Zip: %d\nWe cannot do more. Abort.", retval);
                    exit (1);
            } /* switch (retval) */
        } /* if (retval != 0) */
    } /* if (access (temp_path, R_OK + W_OK) == 0) */
    else
    {
        notify (FAIL, "Target directory:\n    %s\n    is unavaliable. We cannot do more. Abort.", target);
        exit (2);
    }

    /* Close process and thread handles. */
    CloseHandle (pi.hProcess);
    CloseHandle (pi.hThread);

    return EXIT_SUCCESS;
}
