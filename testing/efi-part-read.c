// Test code: Read "EFI PART" signature
#define EFISIGN "C:\\efi-part.bin"

#include <windows.h>
#include <tchar.h>
#include <stdio.h>

int main ( int argc, char **argv )
{
    TCHAR szDevice[MAX_PATH] = _T("\\\\.\\PhysicalDrive0");
    HANDLE hDevice = CreateFile ( szDevice, GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL, OPEN_EXISTING, 0, NULL );
    if ( hDevice == INVALID_HANDLE_VALUE )
    {
        printf ( "ERROR! Cannot access the drive!" );
        return 2;
    }
    
    BYTE efi[0x200] = {0};
    DWORD dwBeRead = 0;
    SetFilePointer ( hDevice, 0x200, NULL, FILE_BEGIN );
    BOOL bRet = ReadFile ( hDevice, &efi, 0x200, &dwBeRead, NULL );
    if ( bRet && dwBeRead )
    {
        FILE *fp = fopen ( EFISIGN, "wb+" );//Write to file
        if ( fp )
        {
            int iBeWrite = fwrite ( &efi, sizeof(BYTE), 0x8, fp );
            fclose ( fp );
            printf ( "MBR data was saved to %s", EFISIGN );
        }
    }
    else
    {
        DWORD err = GetLastError();
        printf("GetLastError() = %d",err);
    }
    CloseHandle(hDevice);
    return 0;
}
