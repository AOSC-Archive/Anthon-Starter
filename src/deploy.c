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

#define BUF_MAX    128  /* Command line buffer size */
#define LINE_MAX   4096 /* File line buffer size */
#define UID_LENGTH 39   /* 36(UID) + 2("{}") + 1('\0') = 39 */

// Parameters are not decided yet
static void deploy_edit_bcd (const _TCHAR *systemdrive);
static void deploy_edit_ntldr (const _TCHAR *systemdrive);
static void deploy_edit_mbr (void);
static void deploy_edit_esp (void);

static void gen_grub_cfg (const _TCHAR *systemdrive, const _TINT instform);
static void copy_files (const _TCHAR *systemdrive, const _TINT instform);


int deploy ( int instform, int loader, int ptable, const char *systemdrive )
{
    /* Step 1: Write boot loader
     * Judge the "instform" (--form={edit,mbr,gpt,nodeploy}) and do it.
     */
    switch (instform)
    {
        case 0:
            /* Default (--form not set) */
            notify (WARN, "You haven\'t chosen an install method yet.\n    Will use default setting (Edit present boot loader).");
            instform = EDIT_PRESENT; // Don't worry, only deploy() uses it.
            /* fall through */
        case EDIT_PRESENT:
            /* Edit native boot loader's configuration file to boot grub and boot live environment. */
            switch (loader)
            {
                case LOADER_NTLDR:
                    /* Windows NT5 (2k/XP) */
                    deploy_edit_ntldr (systemdrive);
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
    gen_grub_cfg (systemdrive, instform);

    /* Step 3: Put GRUB image and necessities to ast_strt folder */
    copy_files (systemdrive, instform);

    /* Step 4: Generate information file for start-up procedure to use (info.ast) */

    return 0;
}





static void deploy_edit_bcd (const _TCHAR *systemdrive)
{
    _TCHAR pipeBuf[BUF_MAX] = {0};
    _TCHAR uid[UID_LENGTH] = {0};
    FILE *pipe;
    void *OldValue = NULL;
    void (*func)();

    notify (INFO, "Processing Bootmgr deployment...");

    /* Redirect to the native System32 folder (See issue #11) */
    /* Avoid invoking it in Windows XP or earlier systems (See issue #12) */
    func = (void (*)()) GetProcAddress (GetModuleHandle (_T("kernel32.dll")), _T("Wow64DisableWow64FsRedirection"));
    if (func != NULL)
        func (&OldValue);
    else
        ; // Nothing to do

    /* First execute bcdedit to get the UID of BCD item */
    if ((pipe = _tpopen (_T("bcdedit /create /d \"Start AOSC LiveKit\" /application bootsector"), _T("rt"))) && (pipe != NULL))
    {
        while (_fgetts (pipeBuf, BUF_MAX, pipe));
        if (_stscanf (pipeBuf, "%*s %s %*s", uid))
        {
            _TCHAR bufPart[16] = {0};

            notify (INFO, "Got BCD boot item UID: %s", uid);

            /* Work around: "partition=[systemdrive]" */
            /* "Let len be the length of the formatted data string,... If len > count,
             *  count characters are stored in buffer, no null-terminator is appended, and a negative value is returned."
             *    -- MSDN Library (https://msdn.microsoft.com/en-us/library/2ts7cx93.aspx)
             */
            if (_sntprintf (bufPart, 15, _T("%s%c%c"), _T("partition="), systemdrive[0], systemdrive[1]) > 0)
            {
                /* NOTE: "You must explicitly flush (using fflush or _flushall) or close any stream
                *         before calling a _spawn function."
                *           -- MSDN Library (https://msdn.microsoft.com/en-us/library/20y988d2.aspx)
                *  NOTE: Sleep 0.5 seconds after every BCD editing procedure for frequently operate BCD
                *        could lead to data loss (I don't know but it does don't add some critical items).
                */
                int retVal[5]    = {0}; // For _cwait to store result codes.
                int i;                  // Temporary variable

                _flushall ();
                retVal[0] = _tspawnlp (_P_WAIT, _T("bcdedit.exe"), _T("bcdedit"), _T("/set"), uid, _T("device"), bufPart, NULL);
                Sleep (500);
                _flushall ();
                retVal[1] = _tspawnlp (_P_WAIT, _T("bcdedit.exe"), _T("bcdedit"), _T("/set"), uid, _T("path"), _T("\\ast_strt\\g2ldr.mbr"), NULL);
                Sleep (500);
                _flushall ();
                retVal[2] = _tspawnlp (_P_WAIT, _T("bcdedit.exe"), _T("bcdedit"), _T("/displayorder"), uid, _T("/addlast"), NULL);
                Sleep (500);
                _flushall ();
                retVal[3] = _tspawnlp (_P_WAIT, _T("bcdedit.exe"), _T("bcdedit"), _T("/default"), uid, NULL);
                Sleep (500);
                _flushall ();
                retVal[4] = _tspawnlp (_P_WAIT, _T("bcdedit.exe"), _T("bcdedit"), _T("/timeout"), _T("5"), NULL);

                /* Check return values */
                for (i = 0; i < 5; i++)
                {
                    if (retVal[i] == 0)
                        continue;
                    else
                        notify (WARN, "It seems that something went wrong when editing BCD. (Step %d)", i);
                }
            } /* if (_sntprintf (bufPart, 15, _T("%s%c%c"), _T("partition="), systemdrive[0], systemdrive[1]) > 0) */
            else
            {
                notify (FAIL, "Error in %s: meet a fatal error when formatting a string.\n    Cannot set BCD. Abort.");
                exit (1);
            }
        } /* if (_stscanf (pipeBuf, "%*s %s %*s", uid)) */
        else
        {
            /* Read buffer error */
            notify (FAIL, "Buffer reading error: in %s:\n    \"%s\"\n    Abort.", __func__, pipeBuf);
            exit (1);
        }
    } /* if ((pipe = _tpopen (_T("bcdedit /create /d \"Start AOSC LiveKit\" /application bootsector"), _T("rt"))) && (pipe != NULL)) */
    else
    {
        /* Pipe open error */
        notify (FAIL, "Error when creating pipe in %s (Error %d)\n    Abort.", __func__, errno);
        exit (1);
    }

    /* Immediately re-enable redirection. */
    func = (void (*)()) GetProcAddress (GetModuleHandle (_T("kernel32.dll")), _T("Wow64RevertWow64FsRedirection"));
    if (func != NULL)
        func (OldValue);
    else
        ;

    pclose (pipe);
    notify (SUCC, "Bootmgr deployment completed.");
}

static void deploy_edit_ntldr (const _TCHAR *systemdrive)
{
    _TCHAR lineBuf[LINE_MAX] = {0};
    _TCHAR template[] = _T("boot.ini.XXXXXX"); // For _tmktemp
    _TCHAR cmdBuf[PATH_MAX] = {0};         // misc
    _TCHAR cmdBuf2[PATH_MAX] = {0};        // misc 2
    FILE   *origBootIni, *tgtBootIni;      // Original boot.ini and target boot.ini
    DWORD  fileAttr = 0;                   // For GetFileAttributes

    notify (INFO, "Processing NT5 Loader deployment...");


    /* Generate file name for target boot.ini */
    if (_tmktemp (template) == NULL)
    {
        notify (FAIL, "Failed to generate target boot.ini. Abort.");
        exit (1);
    }

    _sntprintf (cmdBuf, PATH_MAX, _T("%s\\%s"), systemdrive, _T("boot.ini"));

    /* Do not change the attributes of the original boot.ini */
    fileAttr = GetFileAttributes (cmdBuf);
    if (fileAttr == INVALID_FILE_ATTRIBUTES)
    {
        /* Failed to get original boot.ini attributes.
         * NOTE: I don't think this is serious.
         */
        notify (WARN, "Failed to get attributes of the original boot.ini. (not urgent)");
    }

    /* Open the original and target boot.ini. Read from the original one,
     *   and write to the new(target) one.
     */
    if ((origBootIni = _tfopen (cmdBuf, _T("rt"))) && (origBootIni != NULL)) // cmdBuf is still the original boot.ini
    {
        _sntprintf (cmdBuf, PATH_MAX, _T("%s\\%s"), systemdrive, template);
        if ((tgtBootIni = _tfopen (cmdBuf, _T("wt"))) && (tgtBootIni != NULL))
        {
            _TCHAR bootItem[PATH_MAX] = {0}; // For adding boot item
            _TINT  isAoscItemExists   = 0;

            /* Search lines need to be modified, and write to target boot.ini */
            while (_fgetts (lineBuf, LINE_MAX, origBootIni))
            {
                /* Convert lineBuf to lowercase before comparing. (See issue #17) */
                strToLower (lineBuf);

                /* timeout=5 */
                if (_tcsstr (lineBuf, _T("timeout")) != NULL) // tchar version of strstr
                {
                    /* Currently timeout line. We need a 5-second wait.
                     *   timeout=23333'\0' ; Well this is possible... Need to deal with it.
                     * ; ^       ^           (See below)
                     * ; 0       8         --> a[8] is what we want.
                     */
                    lineBuf[8] = '5';

                    /* What if the line longer than 8 characters? */
                    if (_tcslen (lineBuf) > 8)
                    {
                        _TINT i;
                        /* Clean it. */
                        for (i = _tcslen (lineBuf); i > 9; i--)
                            lineBuf[i] = '\0';
                        lineBuf[9] = '\n'; // Line break
                    }

                    goto write_line;
                }

                /* default=C:\g2ldr.mbr */
                if (_tcsstr (lineBuf, _T("default")) != NULL)
                {
                    _TCHAR *bufPtr = lineBuf + 8;
                    _TCHAR ldrPath[PATH_MAX] = {0};
                    /* default=multi(0)disk(0)rdisk(0)partition(1)\WINDOWS'\0'
                     * ^0      ^8    --> from a[8]
                     *         ^ bufPtr points to here
                     */
                    _sntprintf (ldrPath, PATH_MAX, _T("%s\\%s"), systemdrive, _T("ast_strt\\g2ldr.mbr"));
                    if (_tcsncpy (bufPtr, ldrPath, _tcsclen (bufPtr)) != NULL)
                    {
                        /* Succeeded, and clean useless characters behind.
                         * default=C:\\g2ldr.mbr'\0''\0'......
                         *                       ^^ <= '\n'
                         */
                        lineBuf[_tcsclen (lineBuf)] = '\n'; // Line break
                    }
                    else
                    {
                        /* Set default string error
                         * NOTE: I don't think this is serious enough to break the program.
                         */
                        notify (WARN, "Failed to set default item.");
                    }

                    goto write_line;
                }

                /* Same boot item as we want to add: that's interesting...
                 * Mark a bit and do not add a same item.
                 */
                if (_tcsstr (lineBuf, _T("Start AOSC LiveKit")) != NULL)
                    isAoscItemExists = 1; // Exists

                /* PHILOSOPHY: USING "GOTO"
                 * Why not? Those lines are definite, why not print them immediately?
                 */
                write_line:
                /* Write current line into the target boot.ini */
                if (_fputts (lineBuf, tgtBootIni) == EOF)
                {
                    notify (FAIL, "Failed to write target boot.ini (Met EOF). Current line is:\n    %s\n    Error code: %d. We cannot do more. Abort.", lineBuf, errno);
                    exit (1);
                }
            } /* while (_fgetts (lineBuf, LINE_MAX, origBootIni)) */

            /* Add boot item (at the end of the file). Don't add an existing "Start AOSC LiveKit" boot item */
            if (isAoscItemExists)
            {
                fseek (tgtBootIni, 0, SEEK_END);
                _sntprintf (bootItem, PATH_MAX, _T("%s\\ast_strt\\g2ldr.mbr=\"Start AOSC LiveKit\"\n"), systemdrive);

                if (_fputts (bootItem, tgtBootIni) == EOF)
                {
                    notify (FAIL, "Failed to add boot item to boot.ini (Met EOF, error code %d)\n    We cannot do more. Abort.", errno);
                    exit (1);
                }
            }
            else
                notify (INFO, "It seems that you have added an AOSC LiveKit boot item! Skipped.");
        } /* if (tgtBootIni = _tfopen (cmdBuf, "wt")) */
        else
        {
            notify (FAIL, "Failed to open target boot.ini: %s\n    Abort.", cmdBuf);
            exit (1);
        }
    } /* if (origBootIni = _tfopen (cmdBuf, "rt")) */
    else
    {
        notify (FAIL, "Failed to open original boot.ini. Abort.");
        exit (1);
    }

    /*  Close files */
    fclose (origBootIni);
    fclose (tgtBootIni);

    /* Set attributes of the target boot.ini to the same as the original one. */
    if (fileAttr != INVALID_FILE_ATTRIBUTES)
    {
        _sntprintf (cmdBuf2, PATH_MAX, _T("%s\\%s"), systemdrive, template);
        if (SetFileAttributes (cmdBuf2, fileAttr) == 0)
        {
            /* It failed. NOTE: Not urgent. */
            notify (WARN, "Failed to set attributes for the target boot.ini (Error %d, not urgent)", GetLastError ());
        }
    }

    /* Delete the original one. Only the target boot.ini is useful.
     * A duplicate of the original one have been copied to the backup folder.
     */
    _sntprintf (cmdBuf, PATH_MAX, _T("%s\\boot.ini"), systemdrive);
    if (SetFileAttributes (cmdBuf, FILE_ATTRIBUTE_NORMAL) != 0) // Take all attributes away
    {
        if (_tremove (cmdBuf) == -1)
        {
            notify (FAIL, "Failed to delete the original boot.ini (Error %d)", GetLastError ());
            exit (1);
        }
    }
    else
    {
        notify (FAIL, "Failed to replace the original boot.ini (Error %d)\n    Abort.", GetLastError ());
        exit (1);
    }

    /* Rename the target boot.ini so that can be read by NTLDR */
    //_sntprintf (cmdBuf2, PATH_MAX, "%s\\%s", systemdrive, template); // Already set
    if (_trename (cmdBuf2, cmdBuf) != 0)
    {
        notify (FAIL, "Failed to rename %s to boot.ini (Error %d)\n    We cannot do more. Abort.", template);
    }

    notify (SUCC, "NT5 Loader deployment completed.");
}

static void deploy_edit_mbr (void)
{
    notify (INFO, "MBR deployment not completed yet :P");
}

static void deploy_edit_esp (void)
{
    notify (INFO, "ESP deployment on GPT not completed yet :P");
}

static void gen_grub_cfg (const _TCHAR *systemdrive, const _TINT instform)
{
    _TCHAR bufCmd[PATH_MAX] = {0};
    FILE   *GrubCfg;
    notify (INFO, "Generating grub.cfg...");

    /* Open grub.cfg and write the head */
    _sntprintf (bufCmd, PATH_MAX, _T("%s\\ast_strt\\%s"), systemdrive, _T("grub.cfg"));
    if ((GrubCfg = _tfopen (bufCmd, _T("wt+"))) && (GrubCfg != NULL))
    {
        _fputts ("# Grub.cfg Generated by Anthon Starter 0.2\n\n", GrubCfg);
        /* Set modes */
        _fputts (
            "set gfxmode=1024x768\n"
            "terminal_output gfxterm\n"
            "set timeout=\"0\"\n"
            // "loadfont /ast_strt/unicode.pf2\n"
            "background_image /ast_strt/splash.png\n"
            "\n"
        , GrubCfg);
    }
    else
    {
        notify (FAIL, "Failed to create grub.cfg at %s", systemdrive);
        exit (1);
    }

    switch (instform)
    {
        /* grub.cfg sequence:
         *   1. AOSC OS LiveKit (only and default)
         * with 0 second's wait
         */
        default:
            notify (WARN, "Unknown situation: unknown instform code: %d.\n    If you choose to continue, we will try editing present Windows boot loader.", instform);
            /* fall through */
        case EDIT_PRESENT: // fall through
        case EDIT_MBR:
            /* Item 0: AOSC OS LiveKit */
            _fputts (
                "menuentry \'AOSC OS LiveKit\' {\n"
                "  search --no-floppy --set=root --file /ast_strt/vmlinuz\n"
                "  echo \"Now loading the AOSC OS LiveKit kernel...\"\n"
                "  linux /ast_strt/vmlinuz ro quiet\n"
                "  echo \"Now loading the AOSC OS LiveKit initial RAM disk...\"\n"
                "  initrd /ast_strt/initrd.img\n"
                "  boot\n"
                "}\n"
            , GrubCfg);
            break;

        case EDIT_ESP:
            /* Not implemented yet */
        case EDIT_DONOT:
            break; // Nothing to do, and impossible
    }

    fflush (GrubCfg);
    fclose (GrubCfg);

    notify (SUCC, "Generated grub.cfg.");
}

static void copy_files (const _TCHAR *systemdrive, const _TINT instform)
{
    notify (INFO, "Copying necessities...");
    _TCHAR bufCmd[PATH_MAX] = {0};

    /* 1. GRUB2 bootable image */
    if ((instform == EDIT_PRESENT) || (instform == EDIT_MBR))
    {
        /* Using g2ldr.mbr to boot GRUB2 (i386-pc GRUB2 image) */
        if (access ("res\\g2ldr.pc", R_OK) == 0)
        {
            _sntprintf (bufCmd, PATH_MAX, "%s\\g2ldr", systemdrive); // Rename: g2ldr.pc -> g2ldr
            duplicate ("res\\g2ldr.pc", bufCmd);
        }
        else
        {
            notify (FAIL, "Cannot find res\\g2ldr.pc! We cannot do more. Abort.");
            exit (2);
        }

        notify (SUCC, "  - Copied g2ldr");
    }
    else
        if (instform == EDIT_ESP)
        {
            /* Using EFI to boot grub2 (x86_64-efi GRUB2 image) */
            if (access ("res\\grubx64.efi", R_OK) == 0)
            {
                /* 1. Mount ESP
                 * 2. Copy grubx64.efi
                 * >>> NOT IMPL <<<
                 */
            }
        }
        else
            ; // Needn't to consider EDIT_DONOT (Already skipped deploy())

    /* 2. GRUB2 MBR file for booting the image
     *    NOTE: Only using EDIT_PRESENT needs to copy this
     */
    if (instform == EDIT_PRESENT)
    {
        if (access ("res\\g2ldr.mbr", R_OK) == 0)
        {
            _sntprintf (bufCmd, PATH_MAX, "%s\\ast_strt\\g2ldr.mbr", systemdrive);
            duplicate ("res\\g2ldr.mbr", bufCmd);
        }
        else
        {
            notify (FAIL, "Cannot find res\\g2ldr.mbr! We cannot do more. Abort.");
            exit (1);
        }

        notify (SUCC, "  - Copied g2ldr.mbr");
    }
    else
        ;

    /* 3. Unicode font file for GRUB2 (may be unnecessary?) */

    /* 4. Splash image */
    if (access ("res\\splash.png", R_OK) == 0)
    {
        switch (instform)
        {
            case EDIT_MBR: // fall through
            case EDIT_PRESENT:
                _sntprintf (bufCmd, PATH_MAX, "%s\\ast_strt\\splash.png", systemdrive);
                duplicate ("res\\splash.png", bufCmd);
                break;

            case EDIT_ESP:
                /* 1. Mount ESP
                 * 2. Copy splash.png
                 * >>> NOT IMPL <<<
                 */
            case EDIT_DONOT:
            default:
                /* ?????? (Should never happen) */
                notify (WARN, "Unknown instform number %d when copying splash.png", instform);
        }

        notify (SUCC, "  - Copied splash.png");
    }
    else
    {
        /* NOTE: WARN: Missing a picture won't let somebody be killed. */
        notify (WARN, "Cannot find res\\splash.png (not urgent)");
    }

    notify (SUCC, "Necessary files are all at thier posts.");
}
