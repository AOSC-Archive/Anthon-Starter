/* A color-on-console test from http://www.oschina.net/code/piece_full?code=329 */
#include <iostream>
#include <Windows.h>
#include <stdio.h>
#include <stdarg.h>
 
using namespace std;
 
void cprintf(char* str, WORD color, ...);
 
int main() {
    char *str = ( char * ) malloc ( 512 );
    scanf ( "%s", str );
    for ( int i = 0; i <= 500; i++ )
    {
        cprintf(str, i);
        printf ("\n");
    }
    return 0;
}
 
void cprintf(char* str, WORD color, ...) {
    WORD colorOld;
    HANDLE handle = ::GetStdHandle(STD_OUTPUT_HANDLE);
    CONSOLE_SCREEN_BUFFER_INFO csbi;
    GetConsoleScreenBufferInfo(handle, &csbi);
    colorOld = csbi.wAttributes;
    SetConsoleTextAttribute(handle, color);
    cout << str;
    SetConsoleTextAttribute(handle, colorOld);
}

