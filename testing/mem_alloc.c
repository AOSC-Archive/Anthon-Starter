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

/* # include "ast.h" */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define LET_IT_FAIL 1

void *xmalloc (const size_t size);
#define xfree(ptr) if(ptr!=NULL){free(ptr);ptr=NULL;}
// void xfree (void *ptr);

int main ( void )
{
    char *test = xmalloc (512);
    (puts ("Allocation"), test != NULL) ? (puts("SUCC\n")) : (puts("FAIL\n"));
    
    // Try to write something in it.
    memset (test, 'T', 512);
    puts (test);
    
    xfree (test);
    (puts ("\nFree"), test == NULL) ? (puts("SUCC")) : (puts("FAIL"));
    return 0;
}





void *xmalloc (const size_t size)
{
    void *ptr;
    (LET_IT_FAIL) ? (ptr = NULL) : (ptr = malloc (size));

    /* Check availability */
    if (ptr == NULL)
    {
        /* Memory allocation failed, exit the whole program */
        puts ("*** Fatal: libast: Memory allocation failed. ***");
        abort ();
    }
    else
        return ptr;
}

/*
void xfree (void *ptr)
{
    
}
*/

