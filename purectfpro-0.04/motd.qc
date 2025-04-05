// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" ZetterstrЖm 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************

void() setmotd = {
// Strings for Message of the Day 
// Change these strings to reflect your server. note: use \n for linebreak

// PCP dyna - MOTD
	motdbegin = "Welcome to\n\n";
	motd1 = infokey(world, "motd1");
	motd2 = infokey(world, "motd2");
	motd3 = infokey(world, "motd3");
	motd4 = infokey(world, "motd4");
	motd5 = infokey(world, "motd5");
	motdend = "\n\nType \"цоммандс\" to list all commands.\nType \"сеттингс\" to show all settings.\n";
// PCP //

// You probably don't have to change these strings.

	motdexit = "\n Choose an exit...\n";
	motdred  = "\n You are ред team\n";
	motdblue = "\n You are блуе team\n";
};
// *check*
