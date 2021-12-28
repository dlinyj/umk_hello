#include <stdio.h>

int main ( int argc, char *argv[] ) {
	if ( argc != 2 ) {
		printf( "usage: %s filename", argv[0] );
	} else {
		FILE *file = fopen( argv[1], "r" );
		if ( file == 0 ) {
			printf( "Could not open filen" );
		} else {
			int x;
			int i = 0x0800;
			while  ( ( x = fgetc( file ) ) != EOF ) {
				printf("%04x  %02x\n", i++, (unsigned int)0x00FF & x);
			}
			fclose( file );
		}
	}
	return 0;
}
