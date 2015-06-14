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

#define MAX_BUF    128 /* Command line buffer size */
#define UID_LENGTH 39  /* 36(UID) + 2("{}") + 1('\0') = 39 */

// Parameters are not decided yet
static void deploy_edit_bcd (const char *systemdrive);
static void deploy_edit_ntldr (void);
static void deploy_edit_mbr (void);
static void deploy_edit_esp (void);

static void gen_grub_cfg (void);
static void copy_files (void);


int deploy ( int instform, int loader, int ptable, const char *systemdrive )
{
    /* Step 1: Write boot loader
     * Judge the "instform" (--form={edit,mbr,gpt,nodeploy}) and do it.
     */
    switch (instform)
    {
        case 0:
            /* Default (--form not set) */
            notify (WARN, "You haven\'t chose an install method yet.\n    Will use default setting (Edit present boot loader).");
        case EDIT_PRESENT:
            /* Edit native boot loader's configuration file to boot grub and boot live environment. */
            switch (loader)
            {
                case LOADER_NTLDR:
                    /* Windows NT5 (2k/XP) */
                    deploy_edit_ntldr ();
                    break;
                case LOADER_BCD:
                    /* Windows NT6 (Vista or later) */
                    deploy_edit_bcd (systemdrive);
                    break;
                case LOADER_UNKNOWN:
                    /* Unknown loader type */
                    notify (WARN, "Unknown loader type. We cannot do more.");
                    break;
                default:
                    /* Shenmegui (This should not happen) */
                    notify (FAIL, "Unknown internal error: tainted data: loader type: %d\n    We cannot do more. Abort.", loader);
                    abort ();
            }
            break; /* case EDIT_PRESENT */
        case EDIT_MBR:
            /* Write GRUB to Master Boot Record */
            /* NOTICE: What if user choose to write MBR but it's GPT? */
            switch (ptable)
            {
                case PTABLE_MBR:
                    /* Nice and proceed. */
                    deploy_edit_mbr ();
                    break;
                case PTABLE_GPT:
                    /* Want hybrid MBR? */
                    notify (WARN, "You\'ve got GUID Partition Table,\n    but you choose to install boot loader to MBR. (Not recommended)");
                    deploy_edit_esp ();
                    break;
                case PTABLE_UNKNOWN: /* fall through */
                default:
                    /* Shenmegui (These should not happen) */
                    notify (FAIL, "Unknown internal error: tainted data: ptable: %d\n    We cannot do more. Abort.", ptable);
                    abort ();
            }
            break; /* case EDIT_MBR */
        case EDIT_ESP:
            /* Write GRUB to GPT's ESP */
            /* NOTICE: Write ESP on MBR disks is not permitted. */
            switch (ptable)
            {
                case PTABLE_GPT:
                    /* Nice and proceed */
                    deploy_edit_esp ();
                    break;
                case PTABLE_MBR:
                    /* WTF there just have no ESP for me */
                    notify (FAIL, "You\'ve got Master Boot Record,\n    but you choose to install boot loader to ESP on GPT.\n    You just cannot do that. Abort.");
                    exit (1);
                case PTABLE_UNKNOWN: /* fall through */
                default:
                    /* Shenmegui (These should not happen) */
                    notify (FAIL, "Unknown internal error: tainted data: ptable: %d\n    We cannot do more. Abort.", ptable);
                    abort ();
            }
            break; /* case EDIT_ESP */
        case EDIT_DONOT:
            /* No deployment. */
            notify (INFO, "Deployment skipped by user.");
            return 0;
        default:
            /* Shenmegui (This should not happen) */
            notify (FAIL, "Unknown internal error: tainted data: instform: %d.\n    We cannot do more. Abort.", instform);
            abort ();
    }

    /* Step 2: Generate grub.cfg */
    gen_grub_cfg ();

    /* Step 3: Put GRUB image and necessities to ast_strt folder */
    copy_files ();

    /* Step 4: Generate information file for start-up procedure to use (info.ast) */

    return 0;
}





static void deploy_edit_bcd (const char *systemdrive)
{
    char pipeBuf[MAX_BUF] = {0};
    char uid[UID_LENGTH] = {0};
    FILE *pipe;
    void *OldValue = NULL;
    void (*func)();

    notify (INFO, "Processing Bootmgr deployment...");

    /* Redirect to the native System32 folder (See issue #11) */
    /* Avoid invoking it in Windows XP or earlier systems (See issue #12) */
    func = (void (*)()) GetProcAddress (GetModuleHandle (TEXT("kernel32.dll")), "Wow64DisableWow64FsRedirection");
    if (func != NULL)
        func (&OldValue);
    else
        ; // Nothing to do

    /* First execute bcdedit to get the UID of BCD item */
    if ((pipe = _tpopen ("bcdedit /create /d \"Start AOSC LiveKit\" /application bootsector", "rt")) && (pipe != NULL))
    {
        while (fgets (pipeBuf, MAX_BUF, pipe));
        if (sscanf (pipeBuf, "%*s %s %*s", uid))
        {
            char bufPart[16] = {0};

            notify (INFO, "Got BCD boot item UID: %s", uid);

            /* Work around: "partition=[systemdrive]" */
            snprintf (bufPart, 15, "%s%c%c", "partition=", systemdrive[0], systemdrive[1]);

            /* NOTE: Here we use detach mode, for these 5 procedures may fail when they're run
             *         in synchronous mode. (Tested on Windows 8.1)
             */
            _tspawnlp (_P_DETACH, "bcdedit.exe", "bcdedit", "/set", uid, "device", bufPart, NULL);
            _tspawnlp (_P_DETACH, "bcdedit.exe", "bcdedit", "/set", uid, "path", "\\ast_strt\\g2ldr.mbr", NULL);
            _tspawnlp (_P_DETACH, "bcdedit.exe", "bcdedit", "/displayorder", uid, "/addlast", NULL);
            _tspawnlp (_P_DETACH, "bcdedit.exe", "bcdedit", "/default", uid, NULL);
            _tspawnlp (_P_DETACH, "bcdedit.exe", "bcdedit", "/timeout", "5", NULL);
        }
        else
        {
            /* Read buffer error */
            notify (FAIL, "Buffer reading error: in %s:\n    \"%s\"\n    Abort.", __func__, pipeBuf);
            exit (1);
        }
    }
    else
    {
        /* Pipe open error */
        notify (FAIL, "Error when creating pipe in %s (Error %d)\n    Abort.", __func__, errno);
        exit (1);
    }

    /* Immediately re-enable redirection. */
    func = (void (*)()) GetProcAddress (GetModuleHandle (TEXT("kernel32.dll")), "Wow64RevertWow64FsRedirection");
    if (func != NULL)
        func (OldValue);
    else
        ;

    notify (SUCC, "Bootmgr deployment completed.");
}

static void deploy_edit_ntldr (void)
{
    notify (INFO, "NT5 Loader deployment not completed yet :P");
}

static void deploy_edit_mbr (void)
{
    notify (INFO, "MBR deployment not completed yet :P");
}

static void deploy_edit_esp (void)
{
    notify (INFO, "ESP deployment on GPT not completed yet :P");
}

static void gen_grub_cfg (void)
{
    notify (INFO, "Generating grub.cfg... (Not implemented yet)");
    /* Generate grub.cfg */
    notify (SUCC, "Generated grub.cfg.");
}

static void copy_files (void)
{
    notify (INFO, "Copying necessities... (Not implemented yet)");
    /* Copy necessities */
    notify (SUCC, "Necessary files are all at thier posts.");
}
