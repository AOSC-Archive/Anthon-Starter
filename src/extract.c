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

int extract ( int will_extract, char *osimage, char *ostarget )
{
    if (will_extract)
    {
        if (access("res\\7z.exe", X_OK) == 0)
        {
            char cmdline[MAX_PATH] = {0},
                 temp_path[MAX_PATH] = {0};
            long retval = 0; /* For GetExitCodeProcess() */
            STARTUPINFO si;
            PROCESS_INFORMATION pi;

            /* Set these structures zero to prevent from exceptions */
            ZeroMemory (&si, sizeof (si));
            ZeroMemory (&pi, sizeof (pi));

            GetTempPath (MAX_PATH, temp_path); // Get temporary directory
            if (access (temp_path, R_OK + W_OK) == 0)
            {
                /* Files will be extracted in the priority of:
                * - (osimage)/boot/vmlinuz
                * - (osimage)/boot/initrd.img
                * - (osimage)/live/live.squashfs
                * TODO: Encapsulate these jobs.
                */

                /* Now is (osimage)/boot/vmlinuz */
                notify (INFO, "Extracting pre-install environment kernel...");
                snprintf (cmdline, MAX_PATH, "res\\7z.exe x %s -o%s boot\\vmlinuz -y", osimage, temp_path); // 7-Zip use these arguments to extract files
                //printf ("%s\n", cmdline);
                si.cb = sizeof (si); // Initialize STARTUPINFO structure
                if (!CreateProcess (NULL,
                                    TEXT(cmdline), /* NOTICE: According to MSDN Library, here cmdline should be able to modify in Unicode version. */
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
                    notify (FAIL, "Failed to invoke 7-Zip to extract files from the image. We cannot do more.\n    Abort.");
                    exit (1);
                }

                /* Wait until child process (7-Zip) exits. */
                WaitForSingleObject (pi.hProcess, INFINITE);

                /* Get 7-Zip's return value and check if it worked */
                GetExitCodeProcess (pi.hProcess, (LPDWORD)&retval);

                /* TODO: Judge whether 7-Zip succeeded or not. */
                if (retval == 0)
                    notify (SUCC, "Extracted pre-install environment kernel.");
                else
                {
                    switch (retval)
                    {
                        case STILL_ACTIVE:
                            /* 7-Zip is still active (This should never happen) */
                            break;
                        case 1: /* General error */
                            notify (FAIL, "7-Zip returns %d, reporting that it was failed to extract \"vmlinuz\".\n    We cannot do more. Abort.", retval);
                            exit (1);
                        case 2: /* File not found */
                        case 7: /* I forget it... */
                        default:
                            notify (FAIL, "We meet an unknown error with 7-Zip: %d\n    We cannot do more. Abort.", retval);
                            exit (1);
                    } /* switch (retval) */
                }

                /* Close process and thread handles. */
                CloseHandle (pi.hProcess);
                CloseHandle (pi.hThread);

                /* TODO: And (osimage)/boot/initrd.img */
                notify (INFO, "Extracting pre-install environment RAM disk... (Skipped: Not finished)");
                /* TODO: Finally (osimage)/live/live.squashfs */
                notify (INFO, "Extracting the operating system... (Skipped: Not finished)\n    It may take a few minutes, please wait patiently...");

                return 0; // Back to run()
            } /* if (access (temp_path, R_OK + W_OK) == 0) */
            else
            {
                notify (FAIL, "Got temp directory but it is unavaliable. We cannot do more.\n    Abort.");
                exit (2);
            }
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
