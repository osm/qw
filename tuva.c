/*
 * tuva.c
 *
 * Copyright Oscar Linderholm <slime@home.se> 2004.
 * See the included file LICENSE for details.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#ifdef LINUX
#include <errno.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#endif

#ifdef WIN32
#include <winsock2.h>
#include <ws2tcpip.h>

#define snprintf _snprintf
#endif

struct iphdr
{
    unsigned char	ihl:4;
    unsigned char	version:4;
    unsigned char	tos;
    unsigned short int	tot_len;
    unsigned short int	id;
    unsigned short int	frag_off;
    unsigned char	ttl;
    unsigned char	protocol;
    unsigned short int	check;
    unsigned long int	saddr;
    unsigned long int	daddr;
};

struct udphdr
{
    unsigned short int	sport;
    unsigned short int	dport;
    unsigned short int	len;
    unsigned short int	check;
};

struct rawhdr
{
    struct sockaddr_in addr;
    struct udphdr *udph;
    struct iphdr *iph;
    char   packet[47];
    int	   sock;
};

struct nethdr
{
    struct sockaddr_in addr;
    int	   sock;
};

int	       init_gateway (unsigned short int);
int	       init_normal  (int, unsigned short int, char *, unsigned short int, char *, unsigned short int, char *, unsigned short int);
void	       convert	    (char *, char *, unsigned short *);
void	       usage	    (char *);
unsigned short ip_checksum  (unsigned char *, int);

int
main (int argc, char **argv)
{
    unsigned short int lport = 0;
    unsigned short int sport = 0;
    unsigned short int dport = 0;
    unsigned short int gport = 0;
    char	       saddr[16];
    char	       daddr[16];
    char	       gaddr[16];
    int		       i;
    int		       use_gateway = 0;
    int		       act_gateway = 0;

    memset (saddr, '\0', sizeof (saddr));
    memset (daddr, '\0', sizeof (daddr));
    memset (gaddr, '\0', sizeof (gaddr));

    for (i = 0; i < argc; i++)
    {
	if (argv[i][0] == '-' && argv[i + 1] != NULL)
	{
	    if (argv[i][1] == 'l')
	    {
		lport = atoi (argv[i + 1]);
	    }

	    else if (argv[i][1] == 's')
	    {
		convert (argv[i + 1], saddr, &sport);

		if (sport == 0)
		{
		    sport = 27001;
		}
	    }

	    else if (argv[i][1] == 'd')
	    {
		convert (argv[i + 1], daddr, &dport);
	    }

	    else if (argv[i][1] == 'g')
	    {
		convert (argv[i + 1], gaddr, &gport);
		use_gateway = 1;
	    }

	    else if (argv[i][1] == 'a')
	    {
		lport = atoi (argv[i + 1]);
		act_gateway = 1;
	    }
	}
    }

    if (act_gateway)
    {
	if (lport != 0)
	{
	    if (init_gateway (lport) == -1)
	    {
		return -1;
	    }
	}

	else
	{
	    usage (argv[0]);
	}
    }

    else if (use_gateway)
    {
	if (lport != 0 && dport != 0 && gport != 0 && saddr != NULL && daddr != NULL && gaddr != NULL)
	{
	    if (init_normal (1, lport, saddr, sport, daddr, dport, gaddr, gport) == -1)
	    {
		return -1;
	    }
	}
	
	else
	{
	    usage (argv[0]);
	}
    }

    else 
    {
	if (lport != 0 && dport != 0 && saddr != NULL && daddr != NULL)
	{
	    if (init_normal (0, lport, saddr, sport, daddr, dport, NULL, 0) == -1)
	    {
		return -1;
	    }
	}

	else
	{
	    usage (argv[0]);
	}
    }

    return 0;
}

int
init_gateway (unsigned short int lport)
{
    struct	       sockaddr_in caddr;
    struct	       sockaddr_in saddr;
    struct	       rawhdr raw;
    char	       buff[512];
    int		       sock;
    int		       size;
    
#ifdef WIN32
    WSADATA data;
    int	    bs = 1;

    if (WSAStartup (MAKEWORD (2, 2), &data) != 0)
    {
	fprintf (stderr, "Fatal: WSAStartup\n");
	return -1;
    }
#endif

    if ((sock	  = (int)socket (AF_INET, SOCK_DGRAM, 0))	 == -1 ||
	(raw.sock = (int)socket (AF_INET, SOCK_RAW, IPPROTO_RAW)) == -1)
    {
	perror ("socket");
	return -1;
    }

#ifdef WIN32
    if (setsockopt (raw.sock, IPPROTO_IP, IP_HDRINCL, (char *)&bs, sizeof (bs)) != 0)
    {
	perror ("setsockopt");
	return -1;
    }
#endif
    
    saddr.sin_family	  = AF_INET;
    saddr.sin_addr.s_addr = INADDR_ANY;
    saddr.sin_port	  = htons (lport);
    size		  = sizeof (struct sockaddr_in);

    memset (buff, '\0', sizeof (buff));
    memset (&(saddr.sin_zero), '\0', sizeof (saddr.sin_zero));

    if (bind (sock, (struct sockaddr *)&saddr, sizeof (struct sockaddr)) == -1)
    {
	perror ("bind");
	return -1;
    }

    for (;;)
    {
	recvfrom (sock, buff, sizeof (buff) - 1, 0, (struct sockaddr *)&caddr, &size);

	if (buff[0] == 't' && buff[1] == 'u' && buff[2] == 'v' && buff[3] == 'a')
	{
	    unsigned short int spoofport;
	    unsigned short int dport;
	    char spoofaddr[16];
	    char daddr[16];
	    char temp[32];
	    int  i;
	    int  j;
	    
	    memset (daddr, '\0', sizeof (daddr));
	    memset (spoofaddr, '\0', sizeof (spoofaddr));

	    /* get address to spoof */
	    memset (temp, '\0', sizeof (temp));
	    
	    for (i = 5, j = 0; buff[i] != ' '; i++, j++)
		temp[j] = buff[i];

	    convert (temp, spoofaddr, &spoofport);

	    /* get address to server */
	    memset (temp, '\0', sizeof (temp));
	    
	    for (i++, j = 0; buff[i] != ' '; i++, j++)
		temp[j] = buff[i];

	    convert (temp, daddr, &dport);

	    /* get checksums etc */
	    memset (temp, '\0', sizeof (temp));
	    
	    snprintf (temp, sizeof (temp), "%c%c%c%c", 0xff, 0xff, 0xff, 0xff);
	    
	    for (i += 2, j = 4; buff[i] != '\"'; i++, j++)
		temp[j] = buff[i];

	    /* prepare packet */
	    raw.addr.sin_family	     = AF_INET;
	    raw.addr.sin_addr.s_addr = inet_addr (daddr);
	    raw.addr.sin_port	     = htons (dport);

	    memset (raw.packet, '\0', sizeof (raw.packet));
	    memset (&(raw.addr.sin_zero), '\0', sizeof (raw.addr.sin_zero));

	    raw.iph  = (struct iphdr *)raw.packet;
	    raw.udph = (struct udphdr *)(raw.packet + sizeof (struct iphdr));

	    raw.iph->version  = 4;
	    raw.iph->ihl      = 5;
	    raw.iph->tos      = 0;
	    raw.iph->tot_len  = htons (sizeof (raw.packet));
	    raw.iph->id	      = 0;
	    raw.iph->frag_off = 0;
	    raw.iph->ttl      = 255;
	    raw.iph->protocol = 17;
	    raw.iph->check    = htons (ip_checksum ((unsigned char *)raw.iph, sizeof (struct iphdr)));
	    raw.iph->saddr    = inet_addr (spoofaddr);
	    raw.iph->daddr    = inet_addr (daddr);

	    raw.udph->sport   = htons (spoofport);
	    raw.udph->dport   = htons (dport);
	    raw.udph->len     = htons (sizeof (raw.packet) - 20);
	    raw.udph->check   = 0;

	    snprintf ((raw.packet + 28), sizeof (raw.packet), "%s", temp);

	    printf ("source: %s:%d - spoof: %s:%d - destination: %s:%d\n",
		    inet_ntoa (caddr.sin_addr), ntohs (caddr.sin_port), 
		    spoofaddr, spoofport, daddr, dport);

	    sendto  (raw.sock, raw.packet, sizeof (raw.packet), 0, (struct sockaddr *)&raw.addr, size);
	}
    }
    
    return 0;
}

int
init_normal (int gateway, unsigned short int lport, char *saddr, unsigned short int sport, char *daddr, unsigned short int dport, char *gaddr, unsigned short int gport)
{
    struct nethdr src;
    struct nethdr dst;
    struct rawhdr raw;
    struct nethdr gw;
    fd_set set;
    int	   size;
    int    bytes;

#ifdef WIN32
    WSADATA data;
    int     bs = 1;

    if (WSAStartup (MAKEWORD (2, 2), &data) != 0)
    {
	fprintf (stderr, "Fatal: WSAStartup ()\n");
	return -1;
    }
#endif

    if ((src.sock = (int)socket (AF_INET, SOCK_DGRAM, 0)) == -1 ||
	(dst.sock = (int)socket (AF_INET, SOCK_DGRAM, 0)) == -1)
    {
	perror ("socket");
	return -1;
    }

    if (gateway == 0)
    {
	if ((raw.sock = (int)socket (AF_INET, SOCK_RAW, IPPROTO_RAW)) == -1)
	{
	    perror ("socket");
	    return -1;
	}

#ifdef WIN32
	if (setsockopt (raw.sock, IPPROTO_IP, IP_HDRINCL, (char *)&bs, sizeof (bs)) != 0)
	{
	    perror ("setsockopt");
	    return -1;
	}
#endif
    }

    else
    {
	if ((gw.sock = (int)socket (AF_INET, SOCK_DGRAM, 0)) == -1)
	{
	    perror ("socket");
	    return -1;
	}
    }

    src.addr.sin_family	     = AF_INET;
    src.addr.sin_addr.s_addr = INADDR_ANY;
    src.addr.sin_port	     = htons (lport);
    memset (&(src.addr.sin_zero), '\0', sizeof (src.addr.sin_zero));

    dst.addr.sin_family	     = AF_INET;
    dst.addr.sin_addr.s_addr = inet_addr (daddr);
    dst.addr.sin_port	     = htons (dport);
    memset (&(dst.addr.sin_zero), '\0', sizeof (dst.addr.sin_zero));

    if (gateway == 0)
    {
	raw.addr.sin_family	 = AF_INET;
	raw.addr.sin_addr.s_addr = inet_addr (daddr);
	raw.addr.sin_port	 = htons (dport);
	
	memset (raw.packet, '\0', sizeof (raw.packet));
	memset (&(raw.addr.sin_zero), '\0', sizeof (raw.addr.sin_zero));

	raw.iph  = (struct iphdr *)raw.packet;
	raw.udph = (struct udphdr *)(raw.packet + sizeof (struct iphdr));

	raw.iph->version  = 4;
	raw.iph->ihl	  = 5;
	raw.iph->tos	  = 0;
	raw.iph->tot_len  = htons (sizeof (raw.packet));
	raw.iph->id	  = 0;
	raw.iph->frag_off = 0;
	raw.iph->ttl	  = 255;
	raw.iph->protocol = 17;
	raw.iph->check	  = htons (ip_checksum ((unsigned char *)raw.iph, sizeof (struct iphdr)));
	raw.iph->saddr	  = inet_addr (saddr);
	raw.iph->daddr	  = inet_addr (daddr);

	raw.udph->sport	  = htons (sport);
	raw.udph->dport	  = htons (dport);
	raw.udph->len	  = htons (sizeof (raw.packet) - 20);
	raw.udph->check	  = 0;
    }

    else
    {
	gw.addr.sin_family	= AF_INET;
	gw.addr.sin_addr.s_addr	= inet_addr (gaddr);
	gw.addr.sin_port	= htons (gport);
	memset (&(gw.addr.sin_zero), '\0', sizeof (gw.addr.sin_zero));
    }

    size = sizeof (struct sockaddr_in);

    if (bind (src.sock, (struct sockaddr *)&src.addr, sizeof (struct sockaddr)) == -1)
    {
	perror ("bind");
	return -1;
    }

    for (;;)
    {
	FD_ZERO (&set);
	FD_SET ((unsigned)src.sock, &set);
	FD_SET ((unsigned)dst.sock, &set);

	select (dst.sock + 1, &set, NULL, NULL, NULL);

	if (FD_ISSET (src.sock, &set))
	{
	    char buff[8192];

	    memset (buff, '\0', sizeof (buff));

	    bytes = recvfrom (src.sock, buff, sizeof (buff) - 1, 0, (struct sockaddr *)&src.addr, &size);
	    bytes = sendto   (dst.sock, buff, bytes, 0, (struct sockaddr *)&dst.addr, size);
	}

	if (FD_ISSET (dst.sock, &set))
	{
	    char buff[8192];

	    memset (buff, '\0', sizeof (buff));

	    bytes = recvfrom (dst.sock, buff, sizeof (buff) - 1, 0, (struct sockaddr *)&dst.addr, &size);

	    if (buff[8] == 9 && strstr (buff + 9, "packet"))
	    {
		char data[64];
		char *ptr;
		int  i;

		memset (data, '\0', sizeof (data));

		buff[0x9] = (char)0xad;
		buff[0xa] = (char)0xf4;
		buff[0xb] = (char)0xf5;
		buff[0xc] = (char)0xf6;
		buff[0xd] = (char)0xe1;
		buff[0xe] = (char)0xad;

		snprintf (data, sizeof (data), "%c%c%c%c", 0xff, 0xff, 0xff, 0xff);
		
		if (gateway == 0)
		{
		    for (ptr = buff + 9; *ptr != '\"'; ptr++);
		    for (i = 4, ptr++; *ptr != '\"'; data[i++] = *ptr++);
		    
		    snprintf ((raw.packet + 28), sizeof (raw.packet), "%s", data);
		    sendto  (raw.sock, raw.packet, sizeof (raw.packet), 0, (struct sockaddr *)&raw.addr, size);
		}

		else
		{
		    snprintf (data, sizeof (data), "tuva %s:%d ", saddr, sport);
								     
		    for (i = strlen (data), ptr = buff + 16; *ptr != '\n'; data[i++] = *ptr++);
		    
		    sendto (gw.sock, data, strlen (data), 0, (struct sockaddr *)&gw.addr, size);
		}
	    }

	    bytes = sendto (src.sock, buff, bytes, 0, (struct sockaddr *)&src.addr, size);
	}
    }

    return 0;
}

void 
convert (char *src, char *ip, unsigned short *port)
{
    char temp[6];
    int  len;
    int  i;
    int  j;

    memset (temp, '\0', sizeof (temp));

    len = strlen (src);

    for (i = 0; (i < len) && (src[i] != ':'); i++)
	ip[i] = src[i];
    
    for (j = 0, i++; (i < len) && (src[i] != '\0'); i++, j++)
	temp[j] = src[i];
    
    *port = atoi (temp);
}

void
usage (char *progname)
{
    printf ("Usage: %s [OPTION]...\n\n"
	    "-l port        port to listen on\n"
	    "-s ip:port     ip and port number to spoof\n"
	    "-d ip:port     ip and port number to the server\n"
	    "-g ip:port     ip and port to your spoof gateway\n"
	    "-a port        port to listen on and act as a gateway\n\n"
	    , progname);

    exit (0);
}

unsigned short
ip_checksum (unsigned char *addr, int count)
{
    unsigned short sum = 0;

    while (count > 1)
    {
	sum  += *((unsigned short *) addr)++;
	count -= 2;
    }

    if (count > 0)
    {
	sum += *(unsigned char *) addr;
    }

    while (sum >> 16)
    {
	sum = (sum & 0xffff) + (sum >> 16);
    }

    return ~sum;
}
