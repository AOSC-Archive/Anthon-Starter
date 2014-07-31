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
    cprintf(str, 10);
    cprintf(str, 9);
    cprintf(str, 12);
    cprintf(str, 11);
    cprintf(str, 13);
    cprintf(str, 10);
    cprintf(str, 15);
    cprintf(str, 2);
    cprintf(str, 5);
    cprintf(str, 8);
    cprintf(str, 14);
    cprintf(str, 4);
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

