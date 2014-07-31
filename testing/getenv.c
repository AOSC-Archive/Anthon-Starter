/* A test for getenv().
 * The result is, getenv() returns the environment variable's containing,
 * but not the whole string.
 */
 
# include <stdio.h>
# include <stdlib.h>

int main ( void )
{
    char *env = ( char * ) malloc ( 512 );
    
    env = getenv ( "SystemDrive" );
    puts ( env );
    return 0;
}
