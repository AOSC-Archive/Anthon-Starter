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

int getsysinfo ( int *loader, int *ptable, char *systemdrive, char *ostarget )
{
    ULARGE_INTEGER tgtdrive_space; /* Free space on target drive (ostarget) */
    SYSTEM_INFO sysinfo;
    MEMORYSTATUSEX meminfo;  /* For memory info */
    char *tmp = NULL;      /* Temp use */
    TCHAR szDevice[MAX_PATH] = _T("\\\\.\\PhysicalDrive0"); /* Device which stores the signature of GPT(?) */
    HANDLE hDevice = NULL; /* Handle of szDevice */
    BYTE efi[0x200] = {0}; /* Buffer for EFI PART signature (read 0x200 once is indispensable) */
    DWORD dwBeRead = 0;    /* For ReadFile() to judge if it is invoked successfully */

    /* Get system drive
     * NOTICE: I think there can't be AB:\ or such kind of volume...
     */
    snprintf ( systemdrive, 4, "%s%c", getenv ( "SystemDrive" ), '\\' );

    /* Get partition table. Wow. */
    hDevice = CreateFile ( szDevice, GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL, OPEN_EXISTING, 0, NULL );
    if ( hDevice == INVALID_HANDLE_VALUE )
    {
        notify ( FAIL, "Fatal: Can\'t determine the partition table! (CreateFile)\n    Program exists." );
        exit ( 1 );
    }

    SetFilePointer ( hDevice, 0x200, NULL, FILE_BEGIN );
    BOOL bRet = ReadFile ( hDevice, &efi, 0x200, &dwBeRead, NULL );
    if ( bRet && dwBeRead )
    {
        if ( ( efi[0] == 0x45 ) && ( efi[1] == 0x46 ) && ( efi[2] == 0x49 ) && ( efi[3] == 0x20 ) &&
             ( efi[4] == 0x50 ) && ( efi[5] == 0x41 ) && ( efi[6] == 0x52 ) && ( efi[7] == 0x54 ) ) /* "EFI PART" */
        {
            *ptable = PTABLE_GPT;
            notify ( INFO, "Partition table: GUID Partition Table (GPT)" );
        }
        else
        {
            *ptable = PTABLE_MBR;
            notify ( INFO, "Partition table: Master Boot Record (MBR)" );
        }
    }
    else
    {
        notify ( FAIL, "Fatal: Can\'t determine the partition table! (ReadFile)\n    Program exists." );
        exit ( 1 );
    }
    CloseHandle ( hDevice );

    /* Get loader type.
     * If detected NTLDR: Windows 2k/XP
     * If detected BOOTMGR: Windows Vista+
     */
    tmp = xmalloc ( CMD_BUF );
    snprintf ( tmp, CMD_BUF, "%s%c%s", systemdrive, '\\', "NTLDR" );
    if ( access ( tmp, R_OK ) == 0 )
        *loader = LOADER_NTLDR;
    else
    {
        tmp = realloc ( tmp, strlen ( systemdrive ) + strlen ( "\\Windows\\boot\\" ) + 1 ); /* xrealloc() not implemented yet */
        snprintf ( tmp, CMD_BUF, "%s%s", systemdrive, "\\Windows\\boot\\" );
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

    /* Detect free spaces on target drive, use WinAPI */
    GetDiskFreeSpaceEx ( ostarget, &tgtdrive_space, ( PULARGE_INTEGER ) NULL, ( PULARGE_INTEGER ) NULL );
    notify ( INFO, "Free space on %s: %I64d bytes", ostarget, tgtdrive_space.QuadPart );
    if ( tgtdrive_space.QuadPart < 5368709120 ) /* 5 GiB */
    {
        notify ( WARN, "You may have no enough free space on %s. (less than 5 GiB)", ostarget );
    }

    /* Detect CPU architecture, use WinAPI
     * NOTICE: A VERY SPECIAL THANKS to Daming Yang ( @LionNatsu ).
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
        notify ( WARN, "You may have no enough free space on your RAM. (less than 1.5 GiB)" );
    
    /* Free the memory */
    xfree ( tmp );

    return 0;
}
