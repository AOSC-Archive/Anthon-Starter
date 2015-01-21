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

void do_backup_ntldr ( char *systemdrive );
void do_backup_bcd ( char *systemdrive );

int backup ( char *systemdrive, int loader, int ptable )
{
    char *cmdbuf = malloc ( CMD_BUF );
    /* TODO: MBR / ESP first. */
    
    /* Native system's boot loader */
    /* Use this to store the backup files. */
    snprintf ( cmdbuf, CMD_BUF, "%s\\ast_bkup%c", systemdrive, '\0' );
    if ( mkdir ( cmdbuf ) == 0 )
    {
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
    }
    else
    {
        notify ( FAIL, "Failed to create backup directory. For safe, program exits." );
        exit ( 1 );
    }
    
    take ( cmdbuf );
    return 0;
}

void do_backup_ntldr ( char *systemdrive )
{
    
}

void do_backup_bcd ( char *systemdrive )
{
    char *cmdbuf = malloc ( CMD_BUF );
    if ( cmdbuf != NULL )
    {
        system ( "C:\\Windows\\System32\\bcdedit.exe /export %systemdrive%\\ast_bkup\\BCDbckup" );
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
