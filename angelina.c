/*
 * angelina.c
 *
 * Copyright (C) Oscar Linderholm <slime@home.se> 2003.
 * See the included file LICENSE for details.
 *
 * WIN32 version by Nikolai Qveflander <akke@musiker.nu> 2003.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#ifdef WIN32
#include <winsock2.h>
#include <ws2tcpip.h>
#endif

#ifdef UNIX
#include <netdb.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/socket.h>
#endif

#define VERSION      "1.2"
#define BUFF_SIZE    512
#define DEFAULT_TIME 1205
#define DEFAULT_PORT 27500

const char *program_name;

struct server_t
{
  struct sockaddr_in addr;
  int                port;
  int                sock;
} server;

struct timer_t
{
  time_t current;
  time_t start;
  int    mins;
  int    secs;
  int    temp;
  int    time;
} timer;

int  auth_client   (char *);
void banner        (void);
void defaults      (void);
int  init_server   (void);
void parse_time    (void);
int  rdata         (char *, int, struct sockaddr_in *);
int  sdata         (char *, int, struct sockaddr_in *);
int  server_loop   (void);

#ifdef WIN32
int  init_winsock2 (void);
#endif

int
main (int argc, char **argv)
{
  program_name = argv[0];

  defaults ();
  banner   ();

  if (argc == 3)
    {
      if (strncmp (argv[1], "-p", 2) == 0)
	{
	  if (argv[2] != NULL)
	    {
	      server.port = atoi (argv[2]);
	    }
	}

      else
	{
	  fprintf (stderr, "Fatal: Unknown option '%s'\n", argv[1]);
	  return -1;
	}
    }

#ifdef WIN32
  if (init_winsock2 () == 0)
    {
#ifdef DEBUG
      printf ("Winsock initialized.\n");
#endif
    }

  else
    {
      fprintf (stderr, "Fatal: init_winsock2 ()\n" \
	       "Winsock NOT initialized\n"         \
	       "Angelina terminating...\n");
      return -1;
    }
#endif

  if (init_server () == 0)
    {
#ifdef DEBUG
      printf ("Server initialized.\n");
#endif
    }

  else
    {
      fprintf (stderr, "Fatal: init_server ()\n");
    }

  if (server_loop () < 0)
    {
      fprintf (stderr, "Fatal: server_loop ()\n");
    }

  return 0;
}

void
banner (void)
{
  printf ("Angelina QuakeWorld Timer v%s\n" 
	  "Copyright Oscar Linderholm and Nikolai Qveflander\n" 
	  "http://angelina.fettan.org\n" 
	  "\n" 
	  "Options:\n" 
	  "-p PORT     specify which port to listen on (default: %d)\n" 
	  "\n", VERSION, DEFAULT_PORT);
}

void
defaults (void)
{
  memset (&server.addr, '\0', sizeof (server.addr));
  server.port = DEFAULT_PORT;
  timer.time  = DEFAULT_TIME;
}

int
init_server (void)
{
#ifdef WIN32
  if ((server.sock = (int)socket (AF_INET, SOCK_DGRAM, IPPROTO_UDP)) == INVALID_SOCKET)
#endif
#ifdef UNIX
  if ((server.sock = socket (AF_INET, SOCK_DGRAM, 0)) == -1)
#endif
    {
      fprintf (stderr, "Fatal: socket ()");
      return -1;
    }

  server.addr.sin_family      = AF_INET;
  server.addr.sin_addr.s_addr = inet_addr ("127.0.0.1");
  server.addr.sin_port        = htons (server.port);
  memset (&(server.addr.sin_zero), '\0', sizeof (server.addr.sin_zero));

#ifdef WIN32
  if (bind (server.sock, (LPSOCKADDR)&server.addr, sizeof (struct sockaddr)) != 0)
#endif
#ifdef UNIX
  if (bind (server.sock, (struct sockaddr *)&server.addr, sizeof (struct sockaddr)) == -1)
#endif
    {
      fprintf (stderr, "Fatal: bind ()\n");
      
#ifdef WIN32
      closesocket (server.sock);
#endif
#ifdef UNIX
      close (server.sock);
#endif

      return -1;
    }

  printf ("Listening on: %d\n", server.port);

  return 0;
}

void
parse_time ()
{
  timer.temp = (int)(timer.current - timer.start);
  timer.temp = timer.time - timer.temp;
  timer.mins = timer.temp / 60;
  timer.secs = timer.temp - (60 * timer.mins);
}

#ifdef WIN32
int
init_winsock2 (void)
{
  WSADATA data;
  WORD    version;
  int     ret;

  version = (MAKEWORD (2, 2));
  ret     = WSAStartup (version, &data);

  if (ret != 0)
    {
      ret = WSAGetLastError ();

      if (ret == WSANOTINITIALISED)
	fprintf (stderr, "Fatal: WSAStartup ()");

      return -1;
    }

  return 0;
}
#endif

int
rdata (char *buff, int size, struct sockaddr_in *client)
{
  int ret;
  int len;

#ifdef WIN32
  len = sizeof (SOCKADDR);
  ret = recvfrom (server.sock, buff, size, 0, (LPSOCKADDR)client, &len);
#endif

#ifdef UNIX
  len = sizeof (struct sockaddr_in);
  ret = recvfrom (server.sock, buff, size, 0, (struct sockaddr *)client, &len);
#endif

  return ret;
}

int
sdata (char *buff, int size, struct sockaddr_in *client)
{
  int ret;
  int len;

#ifdef WIN32
  len = sizeof (SOCKADDR);
  ret = sendto (server.sock, buff, size, 0, (LPSOCKADDR)client, len);
#endif

#ifdef UNIX
  len = sizeof (struct sockaddr);
  ret = sendto (server.sock, buff, size, 0, (struct sockaddr *)client, len);
#endif

  return ret;
}

int
server_loop (void)
{
  struct sockaddr_in client;
  char               buff[BUFF_SIZE];
  int                ret;
  int                temp;

  for (;;)
    {
      memset (buff, '\0', BUFF_SIZE);
      ret = rdata (buff, BUFF_SIZE - 1, &client);

#ifdef WIN32
      if (ret == SOCKET_ERROR)
#endif
#ifdef UNIX
      if (ret == -1)
#endif
	{
	  fprintf (stderr, "Fatal: SOCKET_ERROR\n");
#ifdef WIN32
	  closesocket (server.sock);
#endif
#ifdef UNIX
	  close (server.sock);
#endif
	  return -1;
	}

      if (strncmp (buff + 4, "start", 5) == 0)
	{
	  if ((int)strlen (buff + 4) > 5)
	    {
	      temp = atoi (buff + 9);

	      if (temp <= 0)
		{
		  sprintf (buff, "%c%c%c%cnTimer value to low\n",
			   0xff, 0xff, 0xff, 0xff);
		  sdata (buff, (int)strlen (buff), &client);
		}

	      else if (temp > 3600)
		{
		  sprintf (buff, "%c%c%c%cnTimer value to high\n",
			   0xff, 0xff, 0xff, 0xff);
		  sdata (buff, (int)strlen (buff), &client);
		}

	      else
		timer.time = temp;
	    }
	  
	  time (&timer.start);
	  sprintf (buff, "%c%c%c%cnTimer started %c%02d%c%02d%c\n",
		   0xff, 0xff, 0xff, 0xff,
		   '-' - 128,
		   timer.time / 60,
		   ':' - 128,
		   timer.time - (60 * (timer.time / 60)),
		   '-' - 128);
	  sdata (buff, (int)strlen (buff), &client);
	}

      else if (strncmp (buff + 4, "status", 6) == 0)
	{
	  time (&timer.current);
	  parse_time ();

	  if ((timer.mins <= 0 && timer.secs <= 0) || timer.mins >= 60)
	    {
	      time (&timer.start);
	      parse_time ();
	    }
                
	  sprintf (buff, "%c%c%c%cn                %c%02d%c%02d%c\n",
		   0xff, 0xff, 0xff, 0xff, '-' - 128,
		   timer.mins, ':' - 128, timer.secs, '-' - 128);
	  sdata (buff, (int)strlen (buff), &client);
	}

      else
	{
	  sprintf (buff, "%c%c%c%cnUnknown packet received\n",
		   0xff, 0xff, 0xff, 0xff);
	  sdata (buff, (int)strlen (buff), &client);
	}
    }

  return 0;
}
