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

static void do_backup_mbr ( char *systemdrive, char *folder );
static void do_backup_esp ( char *systemdrive, char *folder );
static void do_backup_ntldr ( char *systemdrive, char *folder );
static void do_backup_bcd ( char *systemdrive, char *folder );

int backup ( char *systemdrive, int loader, int ptable )
{
    char *cmdbuf = xmalloc (MAX_PATH);
    /* We use this directory to store the backup files. */
    snprintf ( cmdbuf, MAX_PATH, "%s\\ast_bkup", systemdrive );

    /* TODO: A folder or file of the same name.
     *   According to version 0.1.2 (init.bat), when this happens, rename this existing folder, and make "ast_bkup" normally.
     */
    if ( access ( cmdbuf, F_OK ) == 0 )
    {
        /* A folder or file of the same name exists. Rename it. */
        /* First generate temporary folder name. */
        char template[]= "ast_backup_XXXXXX";
        _mktemp (template); //Use mkstemp to work around tmpnam's bug.
        /* NOTICE: We just CANNOT directly rename a folder (tested on Windows 8.1: retval=-1 errno=13(EACCES))
         * Solution: Use a new folder. Needed better solution. (FIXME)
         */
        //printf("retval=%d, errno=%d",retval,errno);
        snprintf (cmdbuf, MAX_PATH, "%s\\%s", systemdrive, template);
    }

    if ( mkdir ( cmdbuf ) == 0 )
    {
        /* MBR / ESP backup comes first. */
        switch ( ptable )
        {
            case PTABLE_MBR:
                do_backup_mbr ( systemdrive, cmdbuf );
                break;
            case PTABLE_GPT:
                do_backup_esp ( systemdrive, cmdbuf );
                break;
            default:
                /* This is impossible at present, for the program will abort when getting partition table.
                 * But for safety, abort.
                 */
                notify ( FAIL, "Unknown error: Unknown partition table when backing up. Program exits." );
                exit ( 1 );
        }

        /* Native system's boot loader */
        switch ( loader )
        {
            case LOADER_NTLDR:
                do_backup_ntldr ( systemdrive, cmdbuf );
                break;
            case LOADER_BCD:
                do_backup_bcd ( systemdrive, cmdbuf );
                break;
            default:
                /* LOADER_UNKNOWN??? But I've never used it!
                 * I'd better abort the program...
                 */
                notify ( FAIL, "Unknown error: Unknown boot loader when backing up. Program exits." );
                exit ( 1 );
        }
    } /* if ( mkdir ( cmdbuf ) == 0 ) */
    else
    {
        notify (FAIL, "Failed to create another backup directory (Error %d)", errno);
        exit ( 1 );
    }

    xfree ( cmdbuf );
    return 0;
}

static void do_backup_mbr ( char *systemdrive, char *folder )
{
    char *mbrbkup_path = xmalloc (MAX_PATH);
    snprintf (mbrbkup_path, MAX_PATH, "%s%s", systemdrive, "\\ast_bkup\\MBRbckup");
    TCHAR szDevice[MAX_PATH] = _T ( "\\\\.\\PhysicalDrive0" ); /* FIXME */
    HANDLE hDevice = CreateFile ( szDevice, GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL, OPEN_EXISTING, 0, NULL );
    BYTE mbr[0x200] = {0};
    DWORD dwBeRead = 0;

    if ( hDevice == INVALID_HANDLE_VALUE )
    {
        notify ( FAIL, "Fatal: Can\'t determine the partition table! (CreateFile)\n    Program exists." );
        exit ( 1 );
    }

    BOOL bRet = ReadFile ( hDevice, &mbr, 0x200, &dwBeRead, NULL );
    if ( bRet && dwBeRead )
    {
        FILE *fp = fopen ( mbrbkup_path, "wb" );
        if ( fp )
        {
            int iBeWrite = fwrite ( &mbr, sizeof ( BYTE ), 0x200, fp );
            if ( iBeWrite == 0x200 )
                notify ( SUCC, "Master Boot Record data is saved to:\n     %s", mbrbkup_path );
            else
                notify ( WARN, "Failed to backup Master Boot Record!" );
        }
        fclose ( fp );
    }
    else
    {
        notify ( FAIL, "Fatal: Can\'t determine the partition table! (ReadFile: %d)\n    Program exists.", GetLastError() );
        exit ( 1 );
    }
    CloseHandle ( hDevice );
}

static void do_backup_esp ( char *systemdrive, char *folder )
{
    /* TODO: ESP (GPT) backup
     *   This problem even hasn't been solved in version 0.1.2:
     *     - In 0.1.2 we execute "mountvol W:\ /s" and check if it is an ESP.
     *     - But this does not function well, for on systems support GPT but using MBR this will fail.
     */
    notify (INFO, "ESP Backup skipped (not finished yet :P)");
}

static void do_backup_ntldr ( char *systemdrive, char *folder )
{
    char *cmdbuf = xmalloc (MAX_PATH);
    snprintf ( cmdbuf, MAX_PATH, "%s%s", systemdrive, "\\boot.ini" ); /* File that will be backed up */
    if ( access ( cmdbuf, R_OK + W_OK ) == 0 )
    {
        char *backup_target = xmalloc (MAX_PATH);
        snprintf ( backup_target, MAX_PATH, "%s%s", systemdrive, "\\ast_bkup\\boot.ini.bak" ); /* Backup target */

        // SetFileAttributes ( cmdbuf, FILE_ATTRIBUTE_NORMAL );
        duplicate ( cmdbuf, backup_target );
        /* Check the file's existance */
        if ( access ( backup_target, F_OK ) == 0 )
            notify ( SUCC, "NT Loader configuration file (boot.ini) has been saved to:\n    %s", backup_target );
        else
            notify ( WARN, "Failed to backup NT Loader configuration file (boot.ini)" );

        xfree ( backup_target );
    } /* if ( access ( cmdbuf, R_OK + W_OK ) == 0 ) */
    else
        notify ( WARN, "NT Loader configuration file (boot.ini) not found" ); /* boot.ini not existing? */

    xfree ( cmdbuf );
}

static void do_backup_bcd ( char *systemdrive, char *folder )
{
    char backup_file[MAX_PATH] = {0};
    PVOID OldValue = NULL;
    /* FIXME:
     *   1. This does not work at all. (Fixed)
     *   2. system() is not safe enough.(Fixed)
     */

    snprintf (backup_file, MAX_PATH, "%s\\%s", folder, "BCDbckup");

    /* Redirect to the native System32 folder (See issue #11) */
    Wow64DisableWow64FsRedirection (&OldValue);

    /* Execute bcdedit.exe to backup BCD file */
    if (!(spawnlp (_P_WAIT,"bcdedit.exe", "bcdedit", "/export", backup_file, NULL)))
        notify (INFO, "Boot Configuration Data has been saved to:\n    %s", backup_file);
    else
        notify (WARN, "Failed to backup the Boot Configuration Data: %d", errno); /* File doesn't exist */

    /* Immediately re-enable redirection. */
    Wow64RevertWow64FsRedirection (OldValue);
}

