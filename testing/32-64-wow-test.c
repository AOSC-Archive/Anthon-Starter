# include <stdio.h>
# include <windows.h>

int main ( void )
{
    SYSTEM_INFO si;
    typedef void ( WINAPI *PGNSI ) ( LPSYSTEM_INFO );
    PGNSI pGNSI = ( PGNSI ) GetProcAddress ( GetModuleHandle ( TEXT( "kernel32.dll" ) ), "GetNativeSystemInfo" );
    if (NULL != pGNSI)
    {
        pGNSI ( &si );
    }
    else
    {
        GetSystemInfo ( &si );
    }
    printf ( "%d", si.wProcessorArchitecture );
    return 0;
}
