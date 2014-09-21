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

# include <stdio.h>
# include <stdlib.h>
# include <unistd.h>
# include <windows.h>

# include "funcs.h"
# include "defs.h"

int getsysinfo ( int loader, int ptable, char *systemdrive )
{
    ULARGE_INTEGER sysdrive_space; /* Free space on system drive */
    SYSTEM_INFO sysinfo;
    MEMORYSTATUS meminfo; /* For memory info */
    char *tmp = NULL; /* Temp use */

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
    clrprint ( "[I]", 11 );
    printf ( " Free space on %s: %lu bytes\n", systemdrive, ( unsigned long ) sysdrive_space.QuadPart );
    if ( sysdrive_space.QuadPart < 5368709120 ) /* 5 GiB */
    {
        clrprint ( "[W]", 14 );
        puts ( " You may have no enough free space on your system drive." );
    }

    /* Detect CPU architecture, use WinAPI
     * NOTICE: A VERY SPECIAL THANKS to Daming Yang ( @Lion ). F**king MinGW!
     */
    typedef void ( WINAPI *PGNSI ) ( LPSYSTEM_INFO );
    /* Well... The library of MinGW does not contain many new WinAPIs, such as GetNativeSystemInfo(). */
    PGNSI pGNSI = ( PGNSI ) GetProcAddress ( GetModuleHandle ( TEXT ( "kernel32.dll" ) ), "GetNativeSystemInfo" );
    if ( pGNSI != NULL ) /* Get the pointer to "GetNativeSystemInfo" */
    {
        pGNSI ( &sysinfo ); /* If it has, invoke GetNativeSystemInfo */
    }
    else
    {
        GetSystemInfo ( &sysinfo ); /* If not, invoke GetSystemInfo */
    }
    /* Now judge the valve. */
    switch ( sysinfo.wProcessorArchitecture )
    {
        case PROCESSOR_ARCHITECTURE_AMD64:
        {
            clrprint ( "[I]", 11 );
            printf ( " wProcessorArchitecture = %d\n", ( int ) sysinfo.wProcessorArchitecture );
            /* x86-64. It's okay. */
            /* printf ( "x86_64 architecture" ); */
            break;
        }
        default:
        {
            clrprint ( "[W]", 14 );
            puts ( " Your CPU may not support x86_64, but AOSC OSes do." );
            break;
        }
    }
    /* w */

    /* Detect memory size, use WinAPI */
    GlobalMemoryStatus ( &meminfo );
    clrprint ( "[I]", 11 );
    printf ( " RAM size: %lu bytes\n", ( unsigned long ) meminfo.dwTotalPhys );
    if ( meminfo.dwTotalPhys < 1610612736 ) /* 1.5 GiB */
    {
        clrprint ( "[W]", 14 );
        puts ( " You may have no enough free space on your RAM." );
    }
    
    /* Free the memory */
    free ( tmp );
    tmp = NULL;
    
    return 0;
}
