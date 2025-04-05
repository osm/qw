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
.float runes;					// Runes.
// 
// v1.99beta3
//
.float clientflags;		// client.qc	// Type of client
.float log1;			// 2: a=Kills, b=Deaths
.float log2;			// 4: a=Suicides, b=Teamkills, c=Captures, d=Flagdrops
.float log3;			// 4: a=Assists, b=TW Escorts, c=Flag returns, d=Flag Pickups
.float log4;			// 4: a=Killed carrier, b=Defended flag, c=defended carre, *free*

