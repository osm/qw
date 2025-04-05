// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterström 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************

// check -->

string COUNTDOWN_TEXT;
float CountDown;

entity team1_lastspawn;		// from teamplay.qc
entity team2_lastspawn;

/* obsolete
float KILLME_NOT = 0;
float KILLME_RESTART = 1;	// Plain restart
float KILLME_SWAP = 2;		// Kill and swap
// obsolete float KILLME_COUNTDOWN = 3;	// Countdown has started
// obsolete float KILLME_OBSERVER = 4;	// respawn as observer
*/

float VAR_ANTICHEATS;

// ***freeze***

float TEAM1, TEAM2, TOTALPLAYERS; 	// players in each team
float FLAG_STANDBY;
float MODE;
float STATUS;
float lastvariablecheck;


float LastStatusUpdate;
float firstflag;


//
// Read a localinfo var, and set to "default" if the var is 0.
//
float(string key, float default) localinfo = {
	local float x;
	x = stof(infokey(world, key));
	if (x) return x;
	else return default;
};

//
// Automatically sets friction according to sv_maxspeed.
//
void() SetAutoFriction = {
	if ((SV_MAXSPEED < 321) && (SV_FRICTION != 6))
		cvar_set("sv_friction", "6");
	else if ((SV_MAXSPEED < 361) && (SV_FRICTION != 7))
		cvar_set("sv_friction", "7");
	else if ((SV_MAXSPEED < 376) && (SV_FRICTION != 8))
		cvar_set("sv_friction", "8");
	else cvar_set("sv_friction", "9");
};

//
// Convert DM tp to correct values
//
float(float tp) GetCTFTP = {
	local float x;
	x = tp & 15;
	if (x == 3) return 3;
	else if (x == 4) return 4;
	else if (x == 8) return 2;
	else return 0;
};

//
// Localinfo vars that will be updated every minute only.
//
float MINUTEVARS;
void() UpdateEveryMinute = {
	if (MINUTEVARS > time)
		return;
	local float x;
	MINUTEVARS = time + 60;

	// *** Rune strengths ***
	HASTERATE = localinfo("hasterate", 2);
	HASTESPEED = localinfo("hastespeed", 1.25);
	STRENGTH = localinfo("strength", 2);
	RESISTANCE = localinfo("resistance", 0.5);
	if (FLAG_TW) {
		REGRATE = localinfo("regrate", 3);
		ARMORRATE = localinfo("armorrate", 5);
		REGMAX = localinfo("regmax", 200);
		ARMORMAX = localinfo("armormax", 250);
	} else {
		REGRATE = localinfo("regrate", 5);
		ARMORRATE = localinfo("armorrate", REGRATE);
		REGMAX = localinfo("regmax", 150);
		ARMORMAX = localinfo("armormax", REGMAX);
	}

	// *** Speeds ***
	SV_MAXSPEED = cvar("sv_maxspeed");
	SV_FRICTION = cvar("sv_friction");
	FLAG_NOAUTOFRICTION = localinfo("noautofriction", 0);
	if (!FLAG_NOAUTOFRICTION)
		SetAutoFriction();

	// *** Pure CTF Features ***
	FLAG_TOSSRUNE = localinfo("tr", 0);
	FLAG_TOSSFLAG = localinfo("tf", 0);
	FLAG_DROPQUAD = localinfo("dq", 0);
	FLAG_DROPRING = localinfo("dr", 0);
	FLAG_GRAPPLESKY = localinfo("grapplesky", 0);

	// Misc and unsorted
	FLAG_SINGLECAP = localinfo("singlecap", 0);
	FLAG_DEBUG = localinfo("debug", 0);





	if (!FLAG_CTF && FLAG_COMPETITION)
		FORCE_RESPAWN = localinfo("forcerespawn", 5);
	else
		FORCE_RESPAWN = localinfo("forcerespawn", 0);
	FLAG_GSLOG = localinfo("logging", 0);
	FLAG_CTFRANK = !FLAG_GSLOG;
	COUNTDOWNTIME = localinfo("countdowntime", 15);
	x = localinfo("autostats",0);		// *check*
	FLAG_SHOWSTATS = !(x & 1 );
	FLAG_SHOWALLSTATS = (x & 2);
	x = localinfo("teamaudio", 0);
	FLAG_NOEXPERTSOUNDS = (x & 1);
	FLAG_NOREPORT = (x & 2);
	FLAG_NOPUREAUDIO = (x & 4);
	FLAG_NOCUSTOMAUDIO = (x & 8);
	FLAG_LOCKAUTODEMO = localinfo("lockautodemo", 0);
	FLAG_LOCKAUTOSHOT = localinfo("lockautoshot", 0);
	AUDIOLIMIT = localinfo("audiolimit", 1);
	FLAG_ALLOWMODECHANGE = localinfo("modechange", 0);
	VAR_PINGBAN = localinfo("pingban", 0);
	VAR_HPBBAN = localinfo("hpbban", 0);
	FLAG_QUIETSTANDBY = localinfo("quietstandby", 0);
	FLAG_CTFPLUSLG = localinfo("ctfpluslg", 0);
	FLAG_VOTEEXIT = localinfo("voteexit", 0);
	FLAG_ADMINVOTE = localinfo("adminvote", 0);
};

//
// Localinfo vars that will be updated every second.
//
void() UpdateEverySecond = {
	// *** Standard QW variables ***
	TIMELIMIT = 60 * cvar("timelimit");
	FRAGLIMIT = cvar("fraglimit");
	DEATHMATCH = cvar("deathmatch");
	MAXSPECS = localinfo("maxspectators", 0);
	CheckTeamplay();

	// Misc Vars
	HOOKSPEED = localinfo("hookspeed", 1);
	HOOKPULL = localinfo("hookpull", HOOKSPEED);
	PLAYER_MAXRATE = localinfo("playermaxrate", 0);
	PLAYER_MINRATE = localinfo("playerminrate", 2000);
	SPEC_MAXRATE = localinfo("specmaxrate", 10000);

	FLAG_AUTOSPECTALK = localinfo("autospectalk", 0);

	if (serverflags) serverflags = (serverflags * 2) & 15;	// hehe
	else serverflags = 1;

	ArenaThink();
	CLANARENAWINS = FRAGLIMIT;
	UpdateClientChain();
};

float DUMMY_ANKAMAPS;
float DUMMY_CTF;
float DUMMY_EXTRAS;
float DUMMY_MODE;
float NEXTCHECKMAPRESTART;

//
// Localinfo vars that will be updated on mapstart ONLY.
//
void() UpdateOnce = {
	local float tp;

	// Server modes
	DUMMY_MODE = MODE = localinfo("mode", 0);
	FLAG_COMPETITION = ((MODE & MODE_COMP) || (MODE & MODE_SHOWDOWN));
	FLAG_ARENA = (MODE & MODE_ARENA);
	FLAG_TW = (MODE & MODE_TW);
	FLAG_SHOWDOWN = (MODE & MODE_SHOWDOWN);
 	FLAG_RLJUMPCTF = (MODE & MODE_RLJUMPCTF);

	// Showdown implies comp mode.
	if (FLAG_SHOWDOWN && !(MODE & MODE_COMP)) {
		SetVar(SERVERINFO, "mode", (MODE | 1));
	}

	// Mode flags
	PRACTICE = localinfo("practice", 0);
	FLAG_NOITEMS = (FLAG_ARENA && !(PRACTICE & PRACTICE_ITEMS));
	DUMMY_ANKAMAPS = FLAG_ANKAMAPS = localinfo("ankamaps", 0);
	DUMMY_CTF = FLAG_CTF = (cvar("teamplay") & TEAM_CAPTURE_FLAG);
	FLAG_STANDBY = FLAG_COMPETITION;

	// *** Extras  ***
	DUMMY_EXTRAS = localinfo("extras", 0);
	FLAG_RASOUNDS = (FLAG_ARENA || (DUMMY_EXTRAS & 33));	// *check* gamedir?
	FLAG_MULTIWEAPON = DUMMY_EXTRAS & 2;
	FLAG_HOOK = (FLAG_CTF || (DUMMY_EXTRAS & 4));
	FLAG_RUNES = (FLAG_CTF || FLAG_TW || (DUMMY_EXTRAS & 8));
	FLAG_AIRFIST = (FLAG_TW || (DUMMY_EXTRAS & 16));
	FLAG_FUNSOUNDS = (DUMMY_EXTRAS & 32);

	// Fix Maprestart
	NEXTCHECKMAPRESTART = 0;

	// *** Compatibility and debugging ***
	tp = localinfo("puredisable", 0);
	FLAG_DISABLEMISSILEFIX = tp & 1;
	FLAG_DISABLE_NOSOLID_RESPAWN = tp & 2;
	FLAG_DISABLE_RESPAWNKILLFIX = tp & 4;
	FLAG_DISABLE_CAPTURE_BASE_SPAWN = tp & 8;

	FLAG_LOGBUG = localinfo("logbug", 0);
	FLAG_FLOATFLAGBUG = localinfo("floatflagbug", 0);
	FLAG_DISABLEIMPULSES = localinfo("disableimpulses", 0);
	FLAG_TIMER = !localinfo("notimer", 0);
	FLAG_TELEDEBUG = localinfo("teledebug", 0);

	// Misc Vars
	SET_RUNES = localinfo("runes", 0);
	SET_DISCHARGE = localinfo("discharge", 0);
	SET_HOOK = localinfo("hook", 0);
	tp = localinfo("glglow", 0);
	FLAG_GL_PLAYERS = tp & 1;
	FLAG_GL_ITEMS  = tp & 2;
	FLAG_GL_FLAGS  = tp & 4;
	VAR_ANTICHEATS = localinfo("anticheats", 0);
	SCRAMBLE = localinfo("scramble", 0);
	if (FLAG_COMPETITION) SCRAMBLE = 0;
	VAR_DISABLEPOWERUPS = localinfo("disablepowerups", 0);

	VOTE_MAPT = "    ";
};


float FLAG_TP1;

//
// Check and set correct teamplay.
//
void() CheckTeamplay = {
	// *check* optimize!
	local float x;
	TEAMPLAY = realteamplay = cvar("teamplay");
	if (!FLAG_CTF) {		// Dm hack *check* implement TP1
		x = TEAMPLAY & 31;
		TEAMPLAY = TEAMPLAY - (TEAMPLAY & (31));
		// *check* teamplay 1
		if (x == 1) {
			TEAMPLAY = TEAMPLAY | (3); 	// H&A protect
			FLAG_TP1 = 1;
		} else if (x == 2) {
			TEAMPLAY = TEAMPLAY | (8); 	// Mirrordamage + FragPen
			FLAG_TP1 = 0;
		} else if (x == 3) {
			TEAMPLAY = TEAMPLAY | (1); 	// H protect
			FLAG_TP1 = 0;
		} else if (x == 4) {
			TEAMPLAY = TEAMPLAY | (12); 	// Mirror Damage + FragPen
			FLAG_TP1 = 0;
		}
		if (FLAG_ARENA && FLAG_COMPETITION)
			TEAMPLAY = TEAMPLAY | (96);	// Lock Colors & Static Teams
	}
};

//
// Check if map needs to be restarted.
//
void() CheckMapRestart = {
	if (!NEXTCHECKMAPRESTART || (NEXTCHECKMAPRESTART > time))
		return;
	if (	(DUMMY_ANKAMAPS != FLAG_ANKAMAPS) ||
		(DUMMY_CTF != FLAG_CTF) ||
		(DUMMY_MODE != MODE)) {
		RestartSameMap();
	} else {
		NEXTCHECKMAPRESTART = 0;
	}
};

//
// Schedule mapcheck
//
void() SetMapRestart = {
	NEXTCHECKMAPRESTART = time + 3;
};

//
// General variables update. Will run every second and schedule the
// "every second" and "every minute" updates.
//
void() UpdateVariables = {
	local float tp, x;
	local string tmp;

	if (!firstflag) {
		firstflag = 1;
		UpdateOnce();
	}
	if (lastvariablecheck > time)
		return;
	lastvariablecheck = time + 1;

	UpdateEverySecond();
	UpdateEveryMinute();
	CheckMapRestart();

	// *** Still Unsorted *** *check*
	REVERTTOSTANDARD = localinfo("revert", 0);

	// check settings variables
	tp = localinfo("disablefreeze", 0);		// *check*
	PAUSES_DISABLE = tp & 1;
	PAUSES_AUTO = !(tp & 2);
	PAUSES_BYVOTE = !(tp & 4);
	if (localinfo("resetdefaults", 0))
		SaveDefaults();

	MAXCLIENTS = localinfo("maxclients", 1);

	// *more options?
	FLAG_CUSTOMSKINS = localinfo("customskins", 0);

	// *check*
	FLAG_ERASE = localinfo("debugerase",0);		//*check*




	// *** Powerup Respawntimes ***
	VAR_QUADRESPAWN = localinfo("quadrespawn", 60);
	VAR_RINGRESPAWN = localinfo("ringrespawn", 5*60);
	VAR_PENTARESPAWN = localinfo("pentarespawn", 5*60);

	AMMORESPAWN = localinfo("ammorespawn", 30);
	WEAPONSRESPAWN = localinfo("weaponsrespawn", 30);
	ARMORRESPAWN = localinfo("armorrespawn", 20);
	HEALTHRESPAWN = localinfo("healthrespawn", 20);


	RANDOMRESPAWN = localinfo("randomrespawn", 0);
	if (RANDOMRESPAWN < 1)
		RANDOMRESPAWN = RANDOMRESPAWN * 100;

	RESPAWNFACTOR = localinfo("respawnfactor", 1);
	FULLRESPAWNFACTOR = localinfo("fullrespawnfactor", RESPAWNFACTOR);



	// every minute
};


//
// Force an update now.
//
void() ForceUpdateVariables = {
	lastvariablecheck = time - 1;
	UpdateVariables();
};

//
// Return QW version *inline*
//
float() QWVersion = {
	return stof(infokey(world, "*version"));
};


// <-- check

