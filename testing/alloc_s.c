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

/* alloc_s: A safer memory allocation function, which depends on checking availability. */

/* # include "ast.h" */
# include <stdio.h>
# include <stdlib.h>
# include <string.h>

/* Return code */
# define ALLOC_SUCC 0
# define ALLOC_FAIL 1
# define ALLOC_ALRD 2

# define take(ptr) if(ptr!=NULL){free(ptr);ptr=NULL;}
int alloc_s ( void *pointer, const size_t size, const int isclear );

int main ( void )
{
    char *test = NULL;
    int  isclear = 0;
    
    scanf("%d",&isclear);
    
    switch ( alloc_s ( test, 100 * sizeof ( char ), isclear ) )
    {
        case ALLOC_SUCC:
            puts("Succeeded");
            break;
        case ALLOC_FAIL:
            puts("Failed");
            break;
        case ALLOC_ALRD:
            puts("Already allocated");
            break;
    }
    take(test);
    
    return 0;
}

int alloc_s ( void *pointer, const size_t size, const int isclear )
{
    if ( pointer == NULL )
    {
        pointer = malloc ( size );
        
        /* Check availability */
        if ( pointer == NULL )
        {
            /* Memory allocation failed */
            return ALLOC_FAIL;
        }
        else
        {
            /* Succeeded */
            if ( isclear )
                memset(pointer,0,size);
            return ALLOC_SUCC;
        }
    }
    
    return ALLOC_ALRD;
}
