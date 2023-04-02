
#include <stdio.h>

int main()
{
    char* fname_text = "program.hex";
    char* fname_data = "data.hex";
    char* fname_result = "memory.hex";

    FILE *f_text = fopen( fname_text, "rt" );
    if( NULL==f_text )
    {
        printf( "Can't open file %s\n", fname_text );
        return 1;
    }

    FILE *f_data = fopen( fname_data, "rt" );
    if( NULL==f_text )
    {
        printf( "Can't open file %s\n", fname_data );
        return 1;
    }

    FILE *f_result = fopen( fname_result, "wt" );
    if( NULL==f_text )
    {
        printf( "Can't open file %s\n", fname_result );
        return 1;
    }

    int index_wr=0;
    char str[128];
    char *ptr;
    for( ; ; )
    {
        ptr = fgets( str, 16, f_text );
        if( NULL==ptr )
            break;

        if( 0x0A==str[0] )
            break;

        fprintf( f_result, "%s", str );
        index_wr++;
    }

    for( int ii=index_wr; ii<2048; ii++ )
    {
        fprintf( f_result, "00000000\n" );
    }

    for( ; ; )
    {
        ptr = fgets( str, 16, f_data );
        if( NULL==ptr )
            break;

        if( 0x0A==str[0] )
            break;

        fprintf( f_result, "%s", str );
        index_wr++;
    }

}