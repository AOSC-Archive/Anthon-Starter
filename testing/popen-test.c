#include <stdio.h>
#include <windows.h>
#include <tchar.h>

#define MAXBUF 10240

int main (void)
{
    char pipeBuf[MAXBUF] = {0};
    char input[MAX_PATH] = {0};
    FILE *pipe;

    scanf ("%512s", input);

    if ((pipe = _tpopen (input, "rt")) && (pipe != NULL)) {
        puts ("Get pipe contents done, now output buffer...");
        while (fgets (pipeBuf, MAXBUF, pipe))
            printf (pipeBuf);
    } else {
        printf ("_popen error: %d", errno);
    }

    return 0;
}
