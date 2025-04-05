// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterström 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************

// =================
//     CONSTANTS
// =================

	// teamplay.qc 
float TEAM_DEFAULT_PENALTY =    1;      // Default frag penalty
float TEAM_STRICT_COOP =	0;	// Strict Coop
	// Teamplay bitfield entries
float TEAM_HEALTH_PROTECT = 1;      // No health damage from friendly fire
float TEAM_ARMOR_PROTECT = 2;      // No armor damage from friendly fire
float TEAM_ATTACKER_DAMAGE = 4;      // Attacker takes damage from hitting teammates
float TEAM_FRAG_PENALTY = 8;      // One frag penalty for killing teammate
float TEAM_DEATH_PENALTY = 16;     // Die when you kill a teammate.
float TEAM_LOCK_COLORS = 32;     // Allow only team colors
float TEAM_STATIC_TEAMS = 64;     // Don't allow players to switch teams
float TEAM_DROP_ITEMS = 128;	// Allow players to drop packs and 
float TEAM_CAPTURE_FLAG = 256;	// Play capture the flag
// float TEAM_DISABLE_GRAPPLE = 2048; // team selection

	// freeze.qc - Different freeze functions.
float FREEZE_WORLD = 1;
float FREEZE_MOVEMENT = 2;
float FREEZE_GRAVITY = 4;
float FREEZE_WEAPONS_BUT_HOOK = 8;
float FREEZE_HOOK = 16;
float FREEZE_WEAPONS = 24;
float FREEZE_PLAYERS = 26;
float FREEZE_ALL = 31;

  	// ctfshow.qc 	*check* flytta detta och funktioner till infovar.qc
float LOCALINFO = 0;
float SERVERINFO = 1;
float CVARINFO = 2;

	// (player).admin
float AD_ADMIN = 1;
float AD_SUPER = 2;
float AD_VOTED = 4;
float AD_TINY = 8;
float AD_MASK = 15;
float AD_CAPTAIN = 16;
	// Flags for stuffing
float STUFF_PLAYER = 64;
float STUFF_SPECTATOR = 128;
float STUFF_CLIENT = 256;
float STUFF_ADMIN = 512;
float STUFF_SHOWDOWN1 = 1024;
float STUFF_SHOWDOWN2 = 2048;
float STUFF_SPEC = 4096;
float STUFF_MAPS1 = 8192;
float STUFF_MAPS2 = 16384;
float STUFF_DEBUG = 32768;
float STUFF_AUDIO = 65536;
float STUFF_AUTO = 131072;
	// infovar.qc
float MODE_COMP = 1;
float MODE_SHOWDOWN = 2;



	// commands.qc
float INPUT_TYPE_SWAP = 1;
float INPUT_TYPE_KICK = 2;
float INPUT_TYPE_BAN = 3;
float INPUT_TYPE_IPBAN = 4;
float INPUT_TYPE_GIVEADMIN = 5;

float INPUT_IMPULSE_CLIENT = 10;
float INPUT_IMPULSE_ADMIN = 11;
float INPUT_IMPULSE_MODES = 12;
float INPUT_IMPULSE_SHOW = 13;
float INPUT_IMPULSE_DEBUG = 14;
float INPUT_IMPULSE_CAM = 15;
float INPUT_IMPULSE_PUREAUDIO = 16;
float INPUT_IMPULSE_MAP = 17;


float PRACTICE_ITEMS = 1;
 

	//  player.pure

float SETINFO_TRACKING = 768;		// 256&512
float SETINFO_TRACKING_CHASE = 0;
float SETINFO_TRACKING_STATIC = 256;
float SETINFO_TRACKING_EYECAM = 512;	
float SETINFO_TRACKING_OFF = 768;
//
float SETINFO_SBAR_HUD = 1024;
float SETINFO_SBAR_AUTOID = 2048;
float SETINFO_SBAR_WEAPON = 4096;
float SETINFO_SBAR_TIME = 8192;
float SETINFO_SBAR_RUNE = 16384;
float SETINFO_SBAR_SCORES = 32768;
//
float SETINFO_NOTEAMSOUNDS = 65536;
//
float SETINFO_STUFF = 393216;
float SETINFO_STUFF0 = 0;
float SETINFO_STUFF1 = 131072;
float SETINFO_STUFF2 = 262144;
float SETINFO_STUFF3 = 393216;


	// Known proxys.
float PROXY_FAQ = 1;
float PROXY_QIZMO = 2;
float PROXY_CHEAPO = 3;



	// Bits for .clientflags
float CLIENT_PLAYER = 1;		// Connected as player
float CLIENT_SPECTATOR = 2;		// Connected as Spectator
float CLIENT_OBSERVER = 4;		// Connected as Observer
float CLIENT_BOT = 8;			// Fake Client used for testing.


	// Values for differenr settings like hook, runes, discharges.
float IS_PURE = 0;
float IS_OFF = 1;
float IS_OLD = 2;
float IS_OLDFIX = 3;
	// Values for "anticheats"
float CHEAT_BOTCHECK = 1;		// *opt* inline
float CHEAT_BOTKICK = 2;
float CHEAT_BOTMETHOD = 4;
float CHEAT_PLAYERMODELKICK = 16;
float CHEAT_EYESMODELKICK = 32;
float CHEAT_ANTITIMER = 128;
