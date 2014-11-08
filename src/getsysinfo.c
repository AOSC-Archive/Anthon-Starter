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

# include "ast.h"

int getsysinfo ( int *loader, int ptable, char *systemdrive )
{
    ULARGE_INTEGER sysdrive_space; /* Free space on system drive */
    SYSTEM_INFO sysinfo;
    MEMORYSTATUSEX meminfo; /* For memory info */
    char *tmp = NULL; /* Temp use */

    /* Get system drive
     * NOTICE: I think there can't be AB:\ or such kind of volume...
     */
    snprintf ( systemdrive, 4, "%s%c%c", getenv ( "SystemDrive" ), '\\', '\0' );

    /* Get partition table.
     * TODO: But I don't know how to do it...
     */

    /* Get loader type.
     * If detected NTLDR: Windows 2k/XP
     * If detected BOOTMGR: Windows Vista+
     */
    tmp = malloc ( CMD_BUF );
    snprintf ( tmp, CMD_BUF, "%s%c%s%c", systemdrive, '\\', "NTLDR", '\0' );
    if ( access ( tmp, R_OK ) == 0 )
        *loader = LOADER_NTLDR;
    else
    {
        tmp = realloc ( tmp, strlen ( systemdrive ) + strlen ( "\\Windows\\boot\\" ) + 1 );
        snprintf ( tmp, CMD_BUF, "%s%s%c", systemdrive, "\\Windows\\boot\\", '\0' );
        if ( access ( tmp, R_OK ) == 0 )
            *loader = LOADER_BCD;
        else
            *loader = LOADER_UNKNOWN;
    }
    /* Print it */
    switch ( *loader )
    {
        case LOADER_NTLDR:
            notify ( INFO, "Loader type: NTLDR ( Windows 2K/NT/XP )" );
            break;
        case LOADER_BCD:
            notify ( INFO, "Loader type: Bootmgr ( Windows Vista/7/8 )" );
            break;
        case LOADER_UNKNOWN:
            notify ( INFO, "Loader type: Unknown" );
            notify ( WARN, "Unknown loader type may cause unknown errors!" );
            break;
    }

    /* Detect free spaces on system drive, use WinAPI */
    GetDiskFreeSpaceEx ( systemdrive, &sysdrive_space, ( PULARGE_INTEGER ) NULL, ( PULARGE_INTEGER ) NULL );
    notify ( INFO, "Free space on %s: %lld bytes", systemdrive, sysdrive_space.QuadPart );
    if ( sysdrive_space.QuadPart < 5368709120 ) /* 5 GiB */
    {
        notify ( WARN, "You may have no enough free space on your system drive." );
    }

    /* Detect CPU architecture, use WinAPI
     * NOTICE: A VERY SPECIAL THANKS to Daming Yang ( @Lion ).
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
            notify ( INFO, "wProcessorArchitecture = %d", ( int ) sysinfo.wProcessorArchitecture );
            /* x86-64. It's okay. */
            /* printf ( "x86_64 architecture" ); */
            break;
        default:
            notify ( WARN, "Your CPU may not support x86_64, but AOSC OSes do." );
            break;
    }
    /* w */

    /* Detect memory size, use WinAPI */
    meminfo.dwLength = sizeof ( meminfo );
    GlobalMemoryStatusEx ( &meminfo );
    notify ( INFO, "RAM size: %I64d bytes", meminfo.ullTotalPhys );
    if ( meminfo.ullTotalPhys < 1610612736 ) /* 1.5 GiB */
        notify ( WARN, "You may have no enough free space on your RAM." );
    
    /* Free the memory */
    take ( tmp );
    
    return 0;
}
