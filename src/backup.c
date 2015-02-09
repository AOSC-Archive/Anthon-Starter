/*
 * Anthon-Starter: Installation helper for AOSC OS series, version 0.2.0
 * Copyright (C) 2014-2015 Anthon Open Source Community
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

void do_backup_mbr ( char *systemdrive );
void do_backup_esp ( char *systemdrive );
void do_backup_ntldr ( char *systemdrive );
void do_backup_bcd ( char *systemdrive );

int backup ( char *systemdrive, int loader, int ptable )
{
    char *cmdbuf = malloc ( CMD_BUF );
    /* We use this directory to store the backup files. */
    snprintf ( cmdbuf, CMD_BUF, "%s\\ast_bkup%c", systemdrive, '\0' );
    
    /* TODO: A folder or file of the same name.
     *   According to version 0.1.2 (init.bat), when this happens, rename this existing folder, and make "ast_bkup" normally.
     */
    if ( mkdir ( cmdbuf ) == 0 )
    {
        /* MBR / ESP backup comes first. */
        switch ( ptable )
        {
            case PTABLE_MBR:
                do_backup_mbr ( systemdrive );
                break;
            case PTABLE_GPT:
                do_backup_esp ( systemdrive );
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
                do_backup_ntldr ( systemdrive );
                break;
            case LOADER_BCD:
                do_backup_bcd ( systemdrive );
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
        notify ( FAIL, "Failed to create backup directory. For safety, program exits." );
        exit ( 1 );
    }
    
    take ( cmdbuf );
    return 0;
}

void do_backup_mbr ( char *systemdrive )
{
    char *mbrbkup_path = malloc ( CMD_BUF );
    snprintf ( mbrbkup_path, CMD_BUF, "%s%s%c", systemdrive, "\\ast_bkup\\MBRbckup", '\0' );
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
                notify ( INFO, "Master Boot Record data is saved to:\n     %s", mbrbkup_path );
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

void do_backup_esp ( char *systemdrive )
{
}

void do_backup_ntldr ( char *systemdrive )
{
}

void do_backup_bcd ( char *systemdrive )
{
    char *cmdbuf = malloc ( CMD_BUF );
    if ( cmdbuf != NULL )
    {
        system ( "C:\\Windows\\System32\\bcdedit.exe /export %%systemdrive%%\\ast_bkup\\BCDbckup" );
        snprintf ( cmdbuf, CMD_BUF, "%s\\ast_bkup\\BCDbckup%c", systemdrive, '\0' );
        if ( access ( cmdbuf, F_OK ) == 0 )
            notify ( INFO, "Boot Configuration Data has been saved to:\n    %s", cmdbuf );
        else
            notify ( WARN, "Failed to backup the Boot Configuration Data" ); /* File doesn't exist */
        
        take ( cmdbuf );
    }
    else
        raise ( SIGSEGV ); /* Will be changed later */
}

