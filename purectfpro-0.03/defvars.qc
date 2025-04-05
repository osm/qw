// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterström 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************

// =================
//     VARIABLES
// =================
	// teamplay.qc
float AUDIOLIMIT;
	// client.qc
float pregameover;
	// infovar.qc
float FLAG_LOCKAUTODEMO;
float FLAG_LOCKAUTOSHOT;
	//
float OBSOLETEFLAG;				// Used by Checkinfokey
float modelindex_eyes, modelindex_player;	// Used to set playermodel.
entity ARENAPLAYER1;
entity ARENAPLAYER2;
	// freeze.qc
float FREEZEFLAGS;
float FREEZETIME;
	// ctfgame.qc
float VOTEEXIT_TIME_LIMIT;
	//
float FLAG_NOITEMS;
float NOSPAWN;					// inhibit prechaches
float CLANARENAWINS;
	// teamtalk.qc
float FLAG_NOEXPERTSOUNDS;
float FLAG_NOREPORT;
float FLAG_NOPUREAUDIO;
float FLAG_NOCUSTOMAUDIO;
	// purectf.qc
entity PLAYER_CHAIN;
entity CLIENT_CHAIN;
	// infovars.qc
float SCRAMBLE;
	// teamplay.qc
float nextteamupdtime;	// time until next team update
float last_flag_capture;	// time of last capture
float last_capture_team;	// last team that captured
float lastteamscrtime;		// last time we calculated it
float TEAMSCRTIME = 1;
	// pingban.qc
float REDPING;
float BLUEPING;
	//
float MAXCLIENTS;
	// teamplay.qc
float FLAG_CUSTOMSKINS;
	// infovar.qc
float FORCE_RESPAWN;
float PRACTICE;
	// match.qc
float COUNTDOWNTIME;
	// scores.qc
float FLAG_SHOWSTATS;
float FLAG_SHOWALLSTATS;
	// log.qc
float FLAG_GSLOG;
float FLAG_CTFRANK;
	// spawn.qc
float SPAWNDELAY;
float FLAG_ERASE;
entity ERASETHIS;
	// spawn.qc
entity LAST_TELEPORTER;
	// arena.qc
float ARENA_INHIBIT;
float ARENA_SPECFLAG;
	//
float FLAG_FUNSOUNDS;
	// mapqueue.qc
float LASTQUEUE;
	// twrunes.qc - Cloaking
float bippy;		// Time until cloaking
float gene;		// Time until stopping "flash"
float CLOAKED;		// 0=visible 1=cloaked
	// arena.qc - force wins used for debugging.
float FORCEBLUEWIN;
float FORCEREDWIN;
	// admin.qc
entity LAST_CONNECTED;	// Last connected player, used for kicklast.


//
// Server cvars.
//
float SV_MAXSPEED;
float SV_FRICTION;
float TIMELIMIT;
float DEATHMATCH;
float FRAGLIMIT;
float TEAMPLAY, realteamplay;
float MAXSPECS;

//
// Misc Server/localinfo settings.
//
float REVERTTOSTANDARD;
float RESTART;
float PLAYER_MAXRATE;			// "playermaxrate" Limit player rate.
float PLAYER_MINRATE;			// "playerminrate" Lower limit for player rate.
float SPEC_MAXRATE;			// "specmaxrate" Limit spectator rate.
	// "mode" Server modes
float FLAG_ANKAMAPS;
float FLAG_ARENA;
float FLAG_CTF;
float FLAG_TW;
float FLAG_AIRFIST;
float FLAG_SHOWDOWN;			// Showdown mode.
float FLAG_COMPETITION;			// Competition mode.
	//
float HOOKSPEED;
float HOOKPULL;
float HASTERATE;
float HASTESPEED;
float STRENGTH;
float RESISTANCE;
float REGRATE;
float REGMAX;
float ARMORMAX;
float ARMORRATE;
float SET_HOOK;
float SET_RUNES;
float SET_DISCHARGE;
float FLAG_TOSSRUNE;
float FLAG_TOSSFLAG;
float FLAG_DROPQUAD;
float FLAG_DROPRING;
float FLAG_TIMER;
float FLAG_LOGBUG;
float FLAG_TELEDEBUG;
float FLAG_FLOATFLAGBUG;
float FLAG_DEBUG;			// Enables debug messages and impulses.
float FLAG_SINGLECAP;			// Enables "single" captures.
float FLAG_ALLOWMODECHANGE;		// Flag to allow mode changes by non super admins.
float FLAG_VOTEEXIT;			// Enables the "voteexit" command.
float FLAG_ADMINVOTE;			// Enables admin by voting.
float FLAG_RESTART;			// Flag for competition "restarts".
float FLAG_QUIETSTANDBY;
float FLAG_NOAUTOFRICTION;
float FLAG_DISABLEIMPULSES;
float FLAG_CTFPLUSLG;
float FLAG_RASOUNDS;			// Enable Rocket arena sounds when not in arena
float FLAG_HOOK;			// Enable Hook when not in CTF
float FLAG_RUNES;			// Enable Runes when not in CTF
float FLAG_DISABLEMISSILEFIX;		// Disable the "missile obituary bug" fix
float FLAG_MULTIWEAPON;			// Use visible weapons
float FLAG_DISABLE_NOSOLID_RESPAWN;	// Disable nonsolid when respawning.
float FLAG_DISABLE_RESPAWNKILLFIX;	// Disable respawn frags
float FLAG_DISABLE_CAPTURE_BASE_SPAWN;	// Disable spawn in bases after capture.
float FLAG_ISAUTOPAUSED;		// Pause because of diss
float FLAG_AUTOSPECTALK;			// Autoset spectalk
float FLAG_RLJUMPCTF;			// Flag for Rocketjump CTF
float FLAG_GRAPPLESKY;
float VAR_DISABLEPOWERUPS;
float BIT_NOQUAD = 1;
float BIT_NORING = 2;
float BIT_NOPENTA = 4;
float FLAG_GL_PLAYERS;
float FLAG_GL_ITEMS;
float FLAG_GL_FLAGS;
float PAUSES_DISABLE;
float PAUSES_AUTO;
float PAUSES_BYVOTE;
float VAR_PINGBAN;
float VAR_HPBBAN;
float STARTDELAY;
	

	// pureitem.qc
float RANDOMRESPAWN;
float RESPAWNFACTOR;
float FULLRESPAWNFACTOR;
float VAR_QUADRESPAWN;			// Time for quad respawns.
float VAR_PENTARESPAWN;			// Time for Penta respawns.
float VAR_RINGRESPAWN;			// Time for ring respawns.
float AMMORESPAWN;			// Ammo respawns.
float WEAPONSRESPAWN;			// Weapon respawns.
float HEALTHRESPAWN;			// health respawns.
float ARMORRESPAWN;			// armor respawns.



	// timer.qc
string TP_STRING;
string DMM_STRING;
string TL_STRING;