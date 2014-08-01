/*
 * Anthon-Starter: Installation helper for AOSC OS series, version 0.2.0
 * Copyright (C) 2014 Anthon Open Source Community
 * This file is a part of Anthon-Starter.
 * 
 * Anthon-Starter is licensed under GNU LGPL: you can redistribute it
 * and/or modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation, either
 * version 3 of the License, or (at your option) any later version.
 * 
 * Anthon-Starter is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with Anthon-Starter. If not, see
 * <http://www.gnu.org/licenses/>.
 */

# include <stdio.h>
# include <stdlib.h>
# include <unistd.h>
# include <windows.h>

# include "funcs.h"
# include "defs.h"

int getsysinfo ( int loader, int ptable, char *systemdrive )
{
    ULARGE_INTEGER sysdrive_space; /* Free space on system drive */
    //SYSTEM_INFO sysInfo; /* For CPU architecture */
    MEMORYSTATUS meminfo; /* For memory info */
    char *tmp = NULL; /* Temp use */
    
    printf ( "( 2 of 6 ) Getting system info...  ");
    
    /* Get system drive
     * NOTICE: I think there can't be AB:\ or such kind of volume...
     */
    systemdrive = malloc ( 4 );
    sprintf ( systemdrive, "%s%c%c", getenv ( "SystemDrive" ), '\\', '\0' );
    
    /* Get partition table.
     * But I don't know how to do it...
     */
    
    /* Get loader type.
     * If detected NTLDR: Windows 2k/XP
     * If detected BOOTMGR: Windows Vista+
     */
    tmp = malloc ( strlen ( systemdrive ) + strlen ( "NTLDR" ) + 1 );
    sprintf ( tmp, "%s%c%s%c", systemdrive, '\\', "NTLDR", '\0' );
    if ( access ( tmp, R_OK ) == 0 )
        loader = LOADER_NTLDR;
    else
    {
        tmp = realloc ( tmp, strlen ( systemdrive ) + strlen ( "\\Windows\\boot\\" ) + 1 );
        sprintf ( tmp, "%s%s%c", systemdrive, "\\Windows\\boot\\", '\0' );
        if ( access ( tmp, R_OK ) == 0 )
            loader = LOADER_BCD;
        else
            loader = LOADER_UNKNOWN;
    }
    
    /* Detect free spaces on system drive, use WinAPI */
    GetDiskFreeSpaceEx ( systemdrive, &sysdrive_space, ( PULARGE_INTEGER ) NULL, ( PULARGE_INTEGER ) NULL );
    if ( sysdrive_space.QuadPart < 5368709120 ) /* 5 GiB */
        clrprint ( "\n  [WARNING] You may have no enough free space on your system drive.  ", 14 );
    
    /* TODO: Detect CPU architecture, use WinAPI
     * NOTICE: Except CPUID, we can only detect whether system is x86_32 or x86_64, or even WOW64.
     *   So either make a function to use CPUID to detect CPU architecture, or use WinAPI to
     *   detect system architecture.
     */
    
    /* Detect memory size, use WinAPI */
    GlobalMemoryStatus ( &meminfo );
    if ( meminfo.dwTotalPhys < 1610612736 ) /* 1.5 GiB */
        clrprint ( "\n  [WARNING] You may have no enough free space on your RAM.  ", 14 );
    
    clrprint ( "Done.\n", 10 );
    return 0;
}