// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterström 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************

// check -->
	// Items
string SOUND_ITEM_REGEN;
	// CTF
string SOUND_GETFLAG;
string SOUND_CAPTURE;
string SOUND_FLAGNOICE;
	// Client
string SOUND_LEAVESERVER;
	// Deaths
string SOUND_DEATH1;
string SOUND_DEATH2;
string SOUND_DEATH3;
string SOUND_DEATH4;
string SOUND_DEATH5;
string SOUND_DEATH6;
string SOUND_DEATH7;
string SOUND_DEATH8;
string SOUND_DEATH9;
string SOUND_DEATH10;
string SOUND_H2ODEATH;
float NUMBER_OF_DEATHS;


//
// Change this to anything you like...
// 
void() InitSounds = {
	SOUND_GETFLAG = "misc/flagtk.wav";		// flag taken
	SOUND_CAPTURE = "misc/flagcap.wav";		// flag capture

	SOUND_LEAVESERVER = "player/tornoff2.wav";	// Chicken out.

	SOUND_DEATH1 = "player/death1.wav";		// 5 deaths
	SOUND_DEATH2 = "player/death2.wav";
	SOUND_DEATH3 = "player/death3.wav";
	SOUND_DEATH4 = "player/death4.wav";
	SOUND_DEATH5 = "player/death5.wav";	
	NUMBER_OF_DEATHS = 5;			// Set this correctly or rectly or the server will probably crash!	}


	SOUND_FLAGNOICE = "doors/runetry.wav";				// Flag noice
	SOUND_H2ODEATH = "player/h2odeath.wav";				// Drown
	SOUND_ITEM_REGEN = "items/itembk2.wav";				// Item regeneration
};



//
// Death messages. A lot of people like to change these, just remember that
// you'll BREAK any client side logging. If you can live with that then go 
// ahead, make my day.
// 
string dmaxe1, dmaxe2;
string dmsg1, dmsg2;
string dmssg1, dmssg2;
string dmng1, dmng2;
string dmsng1, dmsng2;
string dmgl1a, dmgl2a, dmgl1b, dmgl2b;
string dmrl1a, dmrl2a, dmrl1b, dmrl2b, dmrl1c, dmrl2c;
string dmlg1, dmlg2a, dmlg2b;
string dmaf1, dmaf2;
string dmhook1a, dmhook2a, dmhook1b, dmhook2b;
string dmaf1a, dmaf2a, dmaf1b, dmaf2b;

//
// Setting all messages.
//
void() InitDeathMessages = {


	dmaxe1 = " was ax-murdered by ";
	dmaxe2 = "\n";
	dmhook1a = " was disemboweled by ";
	dmhook2a = "\n";
	dmhook1b = " was hooked by ";
	dmhook2b = "\n";
	dmsg1 = " chewed on ";
	dmsg2 = "'s boomstick\n";
	dmssg1 = " ate 2 loads of ";
	dmssg2 = "'s buckshot\n";
	dmng1 = " was nailed by ";
	dmng2 = "\n";
	dmsng1 = " was punctured by ";
	dmsng2 = "\n";
	dmgl1a = " eats ";
	dmgl2a = "'s pineapple\n";
	dmgl1b = " was gibbed by ";
	dmgl2b = "'s grenade\n";
	dmrl1a = " rides ";
	dmrl2a = "'s rocket\n";
	dmrl1b = " was gibbed by ";			// < -40 hp
	dmrl2b = "'s rocket\n" ;
	dmrl1c = " was destroyed by ";			// Quad
	dmrl2c = "'s Quad rocket\n";
	dmlg1 = " accepts ";
	dmlg2a = "'s shaft\n";
	dmlg2b = "'s discharge\n";			// Discharges

	// Same in TW and 3wave
	dmaf1a = " was blown by ";
	dmaf2a = "\n" ;
	dmaf1b = " was gibbed by ";				// < -40 HP
	dmaf2b = "'s wind!\n" ;
};

//
// Wrapper
//
void() InitCustomStuff = {
	InitSounds();
	InitDeathMessages();
};

// <-- check
