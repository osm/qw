// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterström 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************

/*
 * All special Tracking Routines for the spectator done by Methabol.
 * Please feel free to use them for your own mod. It would be nice if you credit
 * me, and tell me about it too.
 *
 * I made these routines for my mod "Pure CTF", but they should work ok with any mod with 
 * small modifications. I've tried to make the spectator routines as transparent
 * as possible to other code. There are some issues however:
 *
 * - Make sure that the items .item is set correctly, or you can't track its owner. (The Runes
 *   in standard CTF is a good example of how to _not_ do this.
 * - self.netname must be set as it's used to write the "Tracking..." message
 *   Check TrackStatus() how i did with the items (eg flags in ctf) who don't do this.
 *
 */

float TRACKMARGIN = -0.20;		// Margin for specatortracking (0=none -1=full)

void() SpectatorUpdate;


string(entity pl) GetInventoryString;
void() SpectatorFirstConnect;


void() CycleSpecTracking = {

	local float x;
	x = self.pure & SETINFO_TRACKING;

	if (x == SETINFO_TRACKING_CHASE) {
		x = SETINFO_TRACKING_STATIC;
		sprint(self, PRINT_HIGH, "Tracking on (Fixed Camera)\n");
	} else if (x == SETINFO_TRACKING_STATIC) {
		x = SETINFO_TRACKING_EYECAM;
		sprint(self, PRINT_HIGH, "Tracking on (EyeCam)\n");
	} else if (x == SETINFO_TRACKING_EYECAM) {
		x = SETINFO_TRACKING_OFF;
		sprint(self, PRINT_HIGH, "Tracking off\n");
	} else  {
		x = SETINFO_TRACKING_CHASE;
		sprint(self, PRINT_HIGH, "Tracking on (Chasecam)\n");
	}
	self.pure = self.pure - (self.pure & (SETINFO_TRACKING));
	self.pure = self.pure | (x);
	SetPureFlags(self);
	PrintNewPlayerSettings();
};


/*
============
CountEnts

Count entities of a given class.
============
*/
float(string clname) CountEnts = {
	local entity e;
	local float counter;

	counter = 0;
	e = find (world, classname, clname);
	while (e) {
		counter = counter + 1;
		e = find (e, classname, clname);
	}
	return counter;
};

/*
============
Trackstatus

Shows who you're tracking.
============
*/
void() TrackStatus = {
	local string tmp, tmp2;
	local float maxent;
	local float flag;


	if ((self.pure & SETINFO_TRACKING) == SETINFO_TRACKING_OFF)
		return;

	if (self.goalentity == world) {
		sprint(self, PRINT_HIGH, "Tracking is off.\n");
		return;
	}
	tmp = self.goalentity.netname;
	maxent = CountEnts(self.goalentity.classname);
	
	if (self.goalentity.classname == "item_flag_team1") 
		tmp = "Red Flag";
	else if (self.goalentity.classname == "item_flag_team2")
		tmp = "Blue Flag";
	else if (self.items == IT_ARMOR3)
		tmp = "Red Armor";
	else if (self.goalentity.classname == "player")
		maxent = 0;

	sprint(self, PRINT_HIGH, "Now tracking: ");
	sprint(self, PRINT_HIGH, tmp);

	if (self.goalentity.classname ==  "player") {
		flag = 0;
		sprint(self, PRINT_HIGH, " ");
		if (self.goalentity.items & IT_QUAD) {
			sprint(self, PRINT_HIGH, "[QUAD");
			flag = 1;
		} if (self.goalentity.items & IT_INVULNERABILITY) {
			if (flag) sprint(self, PRINT_HIGH, "|");
			else  sprint(self, PRINT_HIGH, "[");
			sprint(self, PRINT_HIGH, "666"); 
			flag = 1;
		} if (self.goalentity.items & IT_INVISIBILITY) {
			if (flag) sprint(self, PRINT_HIGH, "|");
			else  sprint(self, PRINT_HIGH, "[");
			sprint(self, PRINT_HIGH, "RING"); 
			flag = 1;
		} if (self.goalentity.runes & ITEM_RUNE1_FLAG) {
			if (flag) sprint(self, PRINT_HIGH, "|");
			else  sprint(self, PRINT_HIGH, "[");
			sprint(self, PRINT_HIGH, "RES"); 
			flag = 1;
		} if (self.goalentity.runes & ITEM_RUNE2_FLAG) {
			if (flag) sprint(self, PRINT_HIGH, "|");
			else  sprint(self, PRINT_HIGH, "[");
			sprint(self, PRINT_HIGH, "STR"); 
			flag = 1;
		} if (self.goalentity.runes & ITEM_RUNE3_FLAG) {
			if (flag) sprint(self, PRINT_HIGH, "|");
			else  sprint(self, PRINT_HIGH, "[");
			sprint(self, PRINT_HIGH, "HASTE"); 
			flag = 1;
		} if (self.goalentity.runes & ITEM_RUNE4_FLAG) {
			if (flag) sprint(self, PRINT_HIGH, "|");
			else  sprint(self, PRINT_HIGH, "[");
			sprint(self, PRINT_HIGH, "REG"); 
			flag = 1;
		}
		// *check* fixa för TW
		if (flag) sprint(self, PRINT_HIGH, "]"); 
	} else if ((maxent > 1) && (self.goalentity.classname !=  "item_rune")) {
		sprint(self, PRINT_HIGH, " "); 
		tmp2 = ftos(self.goalnumber);
		sprint(self, PRINT_HIGH, tmp2);
		sprint(self, PRINT_HIGH, "/"); 
		tmp2 = ftos(maxent);
		sprint(self, PRINT_HIGH, tmp2);
	} 
	sprint(self, PRINT_HIGH, "\n");
};

/*
===========
AimToGoal

Aim the spectator towards the goal
===========
*/
void() AimToGoal = {
	local vector dir;
	dir = self.goalentity.origin - self.origin;
	dir = vectoangles(dir);
	dir_x = 0 - dir_x ;
	self.angles = dir;
//debug	self.view_ofs = '0 0 0';
	self.fixangle = TRUE;
};

/*
=============
MoveToGoal

Moves a spectator to his goalentity.
=============
*/
void() MoveToGoal = {
	local vector dir, dir2, dir3;

	dir='0 0 0';
	dir_x = (random() * 200) - 100;
	dir_y = (random() * 200) - 100;
	dir_z = 25;
	dir2 = (dir * 100) + self.goalentity.origin;

	traceline(self.goalentity.origin,  dir2  , TRUE , world );

		
	dir3 = ((trace_endpos - self.view_ofs - self.goalentity.origin ) * TRACKMARGIN ) + trace_endpos - self.view_ofs;

//	dir3_z = dir3_z - 5;


	setorigin(self , dir3);
	self.goallastorigin = '0 0 0';
};



/*
=============
ChaseCam

Used when a player tracks an item.
=============
*/
void() ChaseCam = {
	local vector dir, dir2, dir3;
	local string tp;
	makevectors(self.v_angle);
	dir = v_forward;
	dir = normalize(dir);
	dir2 = (dir * -600) + self.goalentity.origin;
	traceline(self.goalentity.origin,  dir2  , TRUE , world );
	dir3 = ((trace_endpos - self.view_ofs - self.goalentity.origin ) * TRACKMARGIN ) + trace_endpos - self.view_ofs;
	setorigin(self , dir3);
};

void() EyeCam = {
	ChaseCam();		// *check* FIX
	setorigin(self, self.goalentity.origin);
	self.angles = self.v_angle = self.goalentity.mangle;
	self.fixangle = 1;
};




.entity lasttracked;			// *check* optimize (reuse field)

/*
===========
StartTrack

Track this entity.
===========
*/
void(entity tmpent, float item, float SETINFOs) StartTrack = {
	self.goalentity = tmpent;
	self.lasttracked = tmpent;
	self.goallastorigin = '0 0 0';
	self.items = item;
	self.runes = SETINFOs;
	self.goalnotsolid = 0;
	TrackStatus();
	SpectatorUpdate();
};


/*
==========
StopTrack

Stop tracking.
==========
*/
void() StopTrack = {
	if (self.goalentity != world)
		sprint(self, PRINT_HIGH, "Tracking stopped.\n");
	self.goalentity = world;
	self.items = 0;
	self.goallastorigin = '0 0 0';
};

/*
==========
CheckGoalLOS

Checks if the spectator can see his goal, otherwise move to it;
==========
*/
void() CheckGoalLOS = {
	traceline(self.goalentity.origin , self.origin  , TRUE , self.goalentity );
	if ( trace_fraction != 1 ) 
		MoveToGoal();
};


/*
===========
Checktracking

Check if we need to move/aim to the goal or if it's been
picked up by someone. 
===========
*/
void() 	CheckTracking = {
 
	local entity tmpent;

	if (self.goalentity == world) {
		if (self.items)
			StopTrack();
		return;
	}


	if ((self.pure & SETINFO_TRACKING) == SETINFO_TRACKING_OFF) {
		StopTrack();
		return;
	}		

	if ((self.goalentity.classname != "player") || ((self.pure & SETINFO_TRACKING) == SETINFO_TRACKING_CHASE)) {
		ChaseCam();
	} else if ((self.pure & SETINFO_TRACKING) == SETINFO_TRACKING_STATIC) {		
		if (self.goallastorigin != self.goalentity.origin) {
			CheckGoalLOS();
			AimToGoal();
		}
	} else if ((self.pure & SETINFO_TRACKING) == SETINFO_TRACKING_STATIC) {
		EyeCam();
	}		
	

	if (self.goalnotsolid) 
		if (self.goalentity.solid == SOLID_NOT) {
			self.goallastorigin = self.goalentity.origin;	
			return;
		} else 
			self.goalnotsolid = 0;

	if (((self.goalentity.classname == "player") && !(self.goalentity.items & self.items) && !(self.goalentity.runes & self.runes)) || 
		(self.goalentity.solid == SOLID_NOT)) {

		// It's gone, or it's owner lost it.
		if (self.items || self.runes) {
			if (self.goalentity.classname == "player") {
				//If the owner is still living, just track him and stop the itemcheck.
				if (self.goalentity.deadflag == DEAD_NO) {
					self.items = 0;
					self.runes = 0;
					return;
				}
			}
			// Ok, see if we can find the item or who picked it up.	
			tmpent = findradius(self.goallastorigin, 150);
			while (tmpent) {
				if ((tmpent != self.goalentity) &&
					((tmpent.runes & self.runes) || (tmpent.items & self.items)) &&
					(tmpent.solid != SOLID_NOT)) {
						StartTrack(tmpent, self.items, self.runes);
						return;
					}
				tmpent = tmpent.chain;
			}
			// None found, so stop tracking.
			StopTrack();
		}
	}
	self.goallastorigin = self.goalentity.origin;	
};




/* 
==========
FindTrack
 
Find and start tracking of a item of a certain type. 
If multiple items, cycle them.
=========
*/
void(string trackthis, float finditem, float findflag) FindTrack = {
	
	local entity oldent, newent, tmpent;
	local float oldnumber;

	newent = world;
	oldent = self.goalentity;
	oldnumber = self.goalnumber;

	
	if ((self.pure & SETINFO_TRACKING) == SETINFO_TRACKING_OFF) {
		self.goalentity = world; 	//stop tracking
		return;
	}




	SpectatorUpdate();

/* debug?
	// Runes is special case.	
	if (trackthis == "item_rune")
*/

	// Are we tracking one of these already?
	if (oldent.classname == trackthis) {
		newent = find(oldent, classname , trackthis);
		self.goalnumber = self.goalnumber + 1;
	}
	
	// Are we tracking a player with this item?
	if (finditem) {
		if ((oldent.classname == "player") && (oldent.items & finditem)) {
			newent = find(oldent, classname, "player");
			while ((newent != world) && !(newent.items & finditem)) {		
				newent = find(newent, classname, "player");
			}
		}
	} else if (findflag) {
		if ((oldent.classname == "player") && (oldent.runes & findflag)) {
			newent = find(oldent, classname, "player");
			while ((newent != world) && !(newent.runes & findflag)) {		
				newent = find(newent, classname, "player");
			}
		}
	}


	// If new entity, set number to 1
	if (newent == world)
		self.goalnumber = 1;
	
	// Still not found it. If last goalentity was player with the same item type, check for item.
	if ((newent == world) && (oldent.classname == "player") && ((oldent.items & finditem) || (oldent.runes & findflag))) {
		newent = find(world, classname , trackthis);
	}

	// If it's a flag that's not solid, skip it.
	if (((newent.classname == "item_flag_team1") || (newent.classname == "item_flag_team2"))
		&& (newent.solid == SOLID_NOT))
		newent = world;

	// Still not found it, find a player with the item.
	if ((newent == world) && !(finditem & IT_ROCKET_LAUNCHER)) {
		newent = find(world, classname, "player");
		if (finditem) {
			while ((newent != world) && !(newent.items & finditem)) {		
				newent = find(newent, classname, "player");
			}
		} else if (findflag) {
			while ((newent != world) && !(newent.runes & findflag)) {		
				newent = find(newent, classname, "player");
			}
		}
	}

	// Still not found it, check one more time.
	if (newent == world) {
		newent = find(world, classname , trackthis);
	}

	if (newent == world) {
		// Item don't exist
		sprint(self, PRINT_HIGH, "No such item on this map\n");
		self.goalnumber = oldnumber;
	} else {
		// Item found! Now track it.
		StartTrack(newent, finditem, findflag);
		if (newent.solid == SOLID_NOT)
			self.goalnotsolid = 1;
	}
};

/*
===========
SpectatorConnect

called when a spectator connects to a server
============
*/
void() SpectatorConnect =
{

	self.join_time = time;			// GSLOG*
	bprint (PRINT_MEDIUM, self.netname);
	bprint (PRINT_MEDIUM, " entered as Spectator\n");

	self.goalentity = world; // used for impulse 1 below
	self.motd_endtime = time + 10;		
	self.classname = "spectator";

	if (parm10 < 0) 
		SpectatorFirstConnect();
	else
		self.admin = parm12;	
	self.goalentity = world;		// reset tracking
	CheckInfokey();				// Check setinfo
	UpdateClientChain();
	setinfostring(self, "skin", "ctfr1");
// PCP dyna - UserID
//	sneek_CheckUserID(self);
// PCP //
};

/*
===========
SpectatorDisconnect

called when a spectator disconnects from a server
============
*/
void() SpectatorDisconnect =
{
	bprint (PRINT_MEDIUM, self.netname);
	bprint (PRINT_MEDIUM, " left as Spectator\n");
// pure obsolete	self.statstate = 0;
	self.player_flag = self.player_flag | PF_GHOST;
	parm12 = self.admin;
	UpdateClientChain();
};


/*
==============
SpectatorCommands

Show a help text to the spectator
==============
*/

void() SpectatorCommands = {
	sprint(self, PRINT_HIGH, "---- Spectator Tracking -----------\n");
	sprint(self, PRINT_HIGH, "Õóå éíðõìóå ±-¸ ôï óåìåãô ôòáãëéîç:\n");
	sprint(self, PRINT_HIGH, "±-Âìõå Æìáç ³-Ñõáä µ-Òéîç  ·-ÒÌ\n");
	sprint(self, PRINT_HIGH, "²-Òåä Æìáç  ´-¶¶¶  ¶-Òõîåó ¸-ÏÆÆ\n");
	sprint(self, PRINT_HIGH, "---- Spectator Commands -----------\n");
	sprint(self, PRINT_HIGH, "ãáí      : ãèáîçå ôòáãë íïäå\n");	// *check* wrong column?
};

/*
===============
SpectatorFirstConnect

Called at the very first connect.
===============
*/
void() SpectatorFirstConnect = {
	local string s;

	sprint(self, PRINT_HIGH, "\nSpectator extensions by Methabol\n");	
	sprint(self, PRINT_HIGH, "type \"COMMANDS\" for all new commands.\n");


	self.admin = 0;
	parm12 = 0;

};

/*
================
SpectatorImpulseCommand

Called by SpectatorThink if the spectator entered an impulse
================
*/


string(entity pl) GetInventoryString = {
	local string tmp2;
		if (pl.items & IT_QUAD)
			if (pl.items & IT_INVISIBILITY)
				if (pl.items & IT_INVULNERABILITY) {
					if (pl.runes & ITEM_RUNE1_FLAG) tmp2 = " [QUAD|666|RING|ÒÅÓ]\n";
					else if (pl.runes & ITEM_RUNE2_FLAG) tmp2 = " [QUAD|666|RING|ÓÔÒ]\n";
					else if (pl.runes & ITEM_RUNE3_FLAG) tmp2 = " [QUAD|666|RING|ÈÁÓÔÅ]\n";
					else if (pl.runes & ITEM_RUNE4_FLAG) tmp2 = " [QUAD|666|RING|ÒÅÇ]\n";
					else tmp2 = " [QUAD|666|RING]\n";
				} else {
					if (pl.runes & ITEM_RUNE1_FLAG) tmp2 = " [QUAD|RING|ÒÅÓ]\n";
					else if (pl.runes & ITEM_RUNE2_FLAG) tmp2 = " [QUAD|RING|ÓÔÒ]\n";
					else if (pl.runes & ITEM_RUNE3_FLAG) tmp2 = " [QUAD|RING|ÈÁÓÔÅ]\n";
					else if (pl.runes & ITEM_RUNE4_FLAG) tmp2 = " [QUAD|RING|ÒÅÇ]\n";
					else tmp2 = " [QUAD|RING]\n";
				} 
			else if (pl.items & IT_INVULNERABILITY) {
					if (pl.runes & ITEM_RUNE1_FLAG) tmp2 = " [QUAD|666|ÒÅÓ]\n";
					else if (pl.runes & ITEM_RUNE2_FLAG) tmp2 = " [QUAD|666|ÓÔÒ]\n";
					else if (pl.runes & ITEM_RUNE3_FLAG) tmp2 = " [QUAD|666|ÈÁÓÔÅ]\n";
					else if (pl.runes & ITEM_RUNE4_FLAG) tmp2 = " [QUAD|666|ÒÅÇ]\n";
					else tmp2 = " [QUAD|666]\n";
				} else {
					if (pl.runes & ITEM_RUNE1_FLAG) tmp2 = " [QUAD|ÒÅÓ]\n";
					else if (pl.runes & ITEM_RUNE2_FLAG) tmp2 = " [QUAD|ÓÔÒ]\n";
					else if (pl.runes & ITEM_RUNE3_FLAG) tmp2 = " [QUAD|ÈÁÓÔÅ]\n";
					else if (pl.runes & ITEM_RUNE4_FLAG) tmp2 = " [QUAD|ÒÅÇ]\n";
					else tmp2 = " [QUAD]\n";
				}
		else if (pl.items & IT_INVISIBILITY)
			if (pl.items & IT_INVULNERABILITY) {
					if (pl.runes & ITEM_RUNE1_FLAG) tmp2 = " [666|RING|ÒÅÓ]\n";
					else if (pl.runes & ITEM_RUNE2_FLAG) tmp2 = " [666|RING|ÓÔÒ]\n";
					else if (pl.runes & ITEM_RUNE3_FLAG) tmp2 = " [666|RING|ÈÁÓÔÅ]\n";
					else if (pl.runes & ITEM_RUNE4_FLAG) tmp2 = " [666|RING|ÒÅÇ]\n";
					else tmp2 = " [666|RING]\n";
				} else {
					if (pl.runes & ITEM_RUNE1_FLAG) tmp2 = " [RING|ÒÅÓ]\n";
					else if (pl.runes & ITEM_RUNE2_FLAG) tmp2 = " [RING|ÓÔÒ]\n";
					else if (pl.runes & ITEM_RUNE3_FLAG) tmp2 = " [RING|ÈÁÓÔÅ]\n";
					else if (pl.runes & ITEM_RUNE4_FLAG) tmp2 = " [RING|ÒÅÇ]\n";
					else tmp2 = " [RING]\n";
				}
			else if (pl.items & IT_INVULNERABILITY)	{
					if (pl.runes & ITEM_RUNE1_FLAG) tmp2 = " [666|ÒÅÓ]\n";
					else if (pl.runes & ITEM_RUNE2_FLAG) tmp2 = " [666|ÓÔÒ]\n";
					else if (pl.runes & ITEM_RUNE3_FLAG) tmp2 = " [666|ÈÁÓÔÅ]\n";
					else if (pl.runes & ITEM_RUNE4_FLAG) tmp2 = " [666|ÒÅÇ]\n";
					else tmp2 = " [666]\n";
				} else {
					if (pl.runes & ITEM_RUNE1_FLAG) tmp2 = " [ÒÅÓ]\n";
					else if (pl.runes & ITEM_RUNE2_FLAG) tmp2 = " [ÓÔÒ]\n";
					else if (pl.runes & ITEM_RUNE3_FLAG) tmp2 = " [ÈÁÓÔÅ]\n";
					else if (pl.runes & ITEM_RUNE4_FLAG) tmp2 = " [ÒÅÇ]\n";
					else tmp2 = "\n";
				}

	return tmp2;
};


void() SpectatorUpdate = {

	local float maxent, torespawn;
	local string tmp, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, tmp8;
	local entity pl;
	local string tp;

	if (self.motd_endtime > time) {
		MOTD();
		return;
	} else if (self.state) { 
		Menu();
		return;
	} else if ((self.motd_endtime + 10) > time) {
// PCP dyna - Version
		centerprint(self, "ÐõòåÃÔÆ Ðòï Advanced Spectator tracking.\n\nTracking is OFF!\nPress ±-· to start tracking.\n Press ¸ to stop tracking.\n\nType \"ÃÏÍÍÁÎÄÓ\" to list all commands.\nType \"ÓÅÔÔÉÎÇÓ\" to show all settings.\nType \"ÃÐÒÉÎÔ\" to remove this text.\nType \"ÃÁÍ\" to change camera style.");
// PCP //
		return;
	}

	// *check* fixa nytt

	tp = self.enemy.netname;

	TeamUpdateStatusbar(self, tp);
	return;
	
	self.oldcolors = 0;

	tmp = self.goalentity.netname;
	maxent = CountEnts(self.goalentity.classname);
	
	if (self.goalentity.classname == "item_flag_team1") 
		tmp = "Red Flag";
	else if (self.goalentity.classname == "item_flag_team2")
		tmp = "Blue Flag";
	else if (self.items == IT_ARMOR3)
		tmp = "Red Armor";
	else if (self.goalentity.classname == "player")
		maxent = 0;

	if (self.goalentity.classname == "player") {
		pl = self.goalentity;
		tmp2 = GetInventoryString(pl);
		tmp3 = "A/H: ";
		tmp4 = getnum(pl.armorvalue);
		tmp5 = getnum(pl.health);
		if (pl.weapon == IT_AXE) { tmp6 = " - Axe"; tmp7 = ""; }
		else if (pl.weapon == IT_GRAPPLE) {tmp6 = " - Hook"; tmp7 = ""; } 
		else if (pl.weapon == IT_SHOTGUN) {tmp6 = " - SG: "; tmp7 = getnum(self.ammo_shells); } 
		else if (pl.weapon == IT_SUPER_SHOTGUN) {tmp6 = " - SSG: "; tmp7 = getnum(pl.ammo_shells); } 
		else if (pl.weapon == IT_NAILGUN) {tmp6 = " - NG: "; tmp7 = getnum(pl.ammo_nails); } 
		else if (pl.weapon == IT_SUPER_NAILGUN) {tmp6 = " - SNG: "; tmp7 = getnum(pl.ammo_nails); } 
		else if (pl.weapon == IT_GRENADE_LAUNCHER) {tmp6 = " - GL: "; tmp7 = getnum(pl.ammo_rockets); } 
		else if (pl.weapon == IT_ROCKET_LAUNCHER) {tmp6 = " - RL: "; tmp7 = getnum(pl.ammo_rockets); } 
		else if (pl.weapon == IT_LIGHTNING) {tmp6 = " - LG: "; tmp7 = getnum(pl.ammo_cells); } 
	} else {
		if (!maxent || (maxent == 1) || (self.goalentity.classname == "item_rune")) {
			tmp2 = "";
		} else if (maxent == 2) {
			if (self.goalnumber == 1) tmp2 = " [01/02]";
			else if (self.goalnumber == 2) tmp2 = " [01/02]";
		} else if (maxent == 3) {
			if (self.goalnumber == 1) tmp2 = " [01/03]";
			else if (self.goalnumber == 2) tmp2 = " [02/03]";
			else if (self.goalnumber == 3) tmp2 = " [03/03]";
		} else if (maxent == 4) {
			if (self.goalnumber == 1) tmp2 = " [01/04]";
			else if (self.goalnumber == 2) tmp2 = " [02/04]";
			else if (self.goalnumber == 3) tmp2 = " [03/04]";
			else if (self.goalnumber == 4) tmp2 = " [04/04]";
		} else if (maxent == 5) {
			if (self.goalnumber == 1) tmp2 = " [01/05]";
			else if (self.goalnumber == 2) tmp2 = " [02/05]";
			else if (self.goalnumber == 3) tmp2 = " [03/05]";
			else if (self.goalnumber == 4) tmp2 = " [04/05]";
			else if (self.goalnumber == 5) tmp2 = " [05/05]";
		}


		if (FREEZEFLAGS & FREEZE_WORLD)
			torespawn = ceil(self.goalentity.nextthink + FREEZETIME - time - time);
		else
			torespawn = ceil(self.goalentity.nextthink - time);			
			

		if (torespawn > 0.9) {
			tmp3 = "\n\nSeconds to respawn: ";
			tmp4 = ftos(torespawn);
		} else {
			tmp3 = "";
			tmp4 = "";
		}
		tmp5 = "";
		tmp6 = "";
		tmp7 = "";
	}		

	centerprint7(self, tmp, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7);

};



void() SpectatorPeriodic = {

	local string tp;

	if (self.lastupdate > time) 
		return;
	if (FLAG_STANDBY)
		self.lastupdate = time + 0.9;
	else
		self.lastupdate = time + 1.75;

	SpectatorUpdate();
	if (CheckStuffflag(self))
		DoStuffing();

	CheckMapChange();
	CheckAdmin();
	
	// rate check
	if ((self.join_time + 10) < time)
		CheckRate();
};


float FLAG_TRACKHACK = 1;	// *check*

.float trackbutton;	// *check* optimize

void() SpectatorButtons = {

	if (!FLAG_TRACKHACK)
		return;

	if (self.button0) {
		if (!(self.trackbutton & 1)) {
			if (self.trackbutton & 2) self.trackbutton = self.trackbutton - (self.trackbutton & (2));
			else self.trackbutton = self.trackbutton | (2);
			if (self.trackbutton & 2) {
				if (FLAG_DEBUG)
					sprint(self, PRINT_HIGH, "ON\n");
				} else {
				if (FLAG_DEBUG)
					sprint(self, PRINT_HIGH, "OFF\n");
				if (self.goalentity) {
					StopTrack();
				} else {
					FindTrack("item_artifact_super_damage", IT_QUAD, 0);
				}
			}			
		}
		self.trackbutton = self.trackbutton | (1);
	} else  {
		self.trackbutton = self.trackbutton - (self.trackbutton & (1));
	}

	if (!self.button0 && (self.trackbutton & 2)) {
		stuffcmd(self, "+attack;wait;-attack\n");
	}


	if (self.button2) {
		if (!(self.trackbutton & 4) && (self.goalentity != world)) {
			FindTrack(self.goalentity.classname, self.items, self.runes);
		}
		self.trackbutton = self.trackbutton | (4);
	} else {
		self.trackbutton = self.trackbutton - (self.trackbutton & (4));
	}
};

/*
================
SpectatorThink

Called every frame after physics are run
================
*/
void() SpectatorThink =
{
	// self.origin, etc contains spectator position, so you could
	// do some neat stuff here

	local entity ent;


	SpectatorPeriodic();
	if (self.impulse)
		SpectatorImpulses();

	CheckTracking();

	if ((self.join_time + 5) < time) {
		//QuakeTV Jitter fix? (this is a longshot, but it _will_ fix observer jittering.)
		SetGravity(self, 0);	

		// Fix Skin
		setinfostring(self, "skin", "ctfr1");
	}
};




// *check*
