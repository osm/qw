// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterström 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************

// v1.99beta3 : Removed 40 fields (!) 

// =================
//      FIELDS  
// =================
.float pure;			// setinfo.qc	// Pure player settings.
.float admin;			// admin.qc	// Admin flags
.entity clientchain;		// purectf.qc	// Clientchain optimization.
//

// *opt* -->
.float  on_hook;		// grapple.qc	// (1bit) TRUE if hook is anchored and client is being pulled
.float  hook_out;				// (1bit) TRUE if hook is in use
.float lastteam;				// Lastteam for smart swapping. (2 bits)
.float lastglobalupdate;			// Last time for global update.
.float newflag;					// Used for debugging
// *opt* <--
.float oldcolors;		// observer.qc	// Old colors when setting the "observer white"
.float rank;			// teamplay.qc	// Rank for scramble.
.float forcerespawn;		// client.qc	// Force respawntime.
.float setgrav;			// freeze.qc	// Grapple freeze (time)

.entity hook;					// pointer to client's hook
//.float menu;			// menu.qc	// Selected Menu
.float input_type;				// Input type for multiimpulse commands (0-?)

.vector freezevelocity;		// freeze.qc	// Velocity before freeze 
.float oldmovetype;				// Movetype before freeze
.float dmgtime;			// client.qc	// Used by watermove to set damage.
.float pingcheck;				// ?
.float pingsum;					// ?
.float pingtimes;				// ?
.float lastupdate;				// Last time for periodic update.
.vector goallastorigin;		// spectate.qc	// ?
.float goalnotsolid;				// ?
.float goalnumber;				// ?
.float votetime;		// vote.qc	// ?
.float packs;					// TW: ?
.float	basetime;		// base.qc	// TW: Flag for basedefend check
.float lisa;			// base.qc	// TW: Time since last basedefend. (time)
.float flaretime;		// weapons.qc	// TW: Holds delay between flares. 
.float justin;					// TW: Invincibility time.
.float flares;					// TW: Number of flares. (0-10?)
.float sniper_ammo;				// TW: Ammo for sniper (0-5?)
.float runes;					// Runes.
// 
// v1.99beta3
//
.float clientflags;		// client.qc	// Type of client
.float twflags;					// General TW options
.float log1;			// 2: a=Kills, b=Deaths
.float log2;			// 4: a=Suicides, b=Teamkills, c=Captures, d=Flagdrops
.float log3;			// 4: a=Assists, b=TW Escorts, c=Flag returns, d=Flag Pickups
.float log4;			// 4: a=Killed carrier, b=Defended flag, c=defended carre, *free*



// ================
//  Removed fields
// ================

//
// Removed in v1.99beta3
//
// .float pingchecktime;	// pingban.qc	// ?
// .float ammo_shells, ammo_nails, ammo_rockets, ammo_cells; // Why was these doubled?
// .float lastyaw;		// nocheat.qc	// Botcheck in nocheats.qc, not used any more
// .float botcount1;				// botcheck
// .float lastbutton;				// botcheck
// .float lastangle;				// botcheck
// .float lastspeed;				// botcheck
// .float botcount2;				// botcheck
// -1 .float gene;		//twrunes.qc	// TW Cloaking
// -1 .float floyd;				// TW Cloaking
// -1 .float bippy;				// TW Cloaking
// -1 .float jimmy;				// TW Cloaking
// -1 .float drop;		//twrunes.qc	// TW droprune
// -1 .float onedrop;				// TW droprune
// -1 .float killing;		// boom.qc	// TW:Boom kill
// -1 .float	basecount;	// unused?	// TW:unused?
// -1 .float 	ouchtime;			// TW: Flag for basedefend/no defend (2 bits)
// -1 .float boom;				// TW: boomtime
// -1 .float times;				// TW: boom limit
// -1 .float	acme;				// TW: Teleporter flag - changed to bit in twflags
// -1 .float	transtime;			// TW: Teleportation time.
// .float sniperdeath;				// TW: Sniped to death.
// .float grappling;				// TW: Dummy grapplecheck
// .float grapples;				// TW: Dummy grapplecheck
// .float grappletime;				// TW: Dummy grapplecheck
// .float escorting;		// teamplay.qc	// TW: ?
// .float reload;				// TW: Reload (not used any more?)
// .float log_kills;		// Kills
// .float log_deaths;		// Deaths
// .float log_suicides;		// Suicides 
// .float log_teamkills;		// Teamkills
// .float log_captures;		// Captures
// .float log_drops;		// Flagdrops
// .float log_assists;		// Assists
// .float log_escorts;		// TW Escorts
// .float log_returns;		// Flag returns
// .float log_pickups;		// Flag Pickups
// .float log_carrierkills;	// Killed carrier
// .float log_defendflag;		// Defended flag
// .float log_defendcarrier;	// Defended carrier
// .float killme;		// purectf.qc	// (2bits) Kill player next think.
// .float yessir; 		// tw50 ( 1bit)
//
// Removed prior to v1.99beta3
// 
// obsolete .float admincheck;			// ?
// obsolete .float lastmapcheck;		// ?
// .float laststattime;		// status.qc	// time of last status update, replaced with "all" update
// .float hit_z;		//weapons.qc	// ?
// .float healamount, healtype;	// items.qc	// Health stats
// .float modelindex_this_player;// multiweap.qc	// Multiweapon stuff
// .float modelindex_thisplayer;		// Multiweapon stuff
