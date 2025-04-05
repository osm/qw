/****************************************************************************
 * ThreeWave Capture The Flag
 ****************************************************************************
 * Based on John Spikles Complete Enhanced Teamplay
 ****************************************************************************
 * Version 4.0 rewrite Mar 21, 1997
 ****************************************************************************/

// =================
//     CONSTANTS
// =================

float TEAM_CAPTURE_CARRIER_DANGER_PROTECT_TIMEOUT = 4;
float TEAM_CAPTURE_CARRIER_FLAG_SINCE_TIMEOUT = 2;
float TEAM_CAPTURE_FRAG_CARRIER_ASSIST_TIMEOUT = 6;
float TEAM_CAPTURE_RETURN_FLAG_ASSIST_TIMEOUT = 4;
float TEAM_CAPTURE_UPDATE_TIME = 120;

// flag status used in cnt field of flag
float FLAG_AT_BASE = 0;
float FLAG_CARRIED = 1;
float FLAG_DROPPED = 2;
float FLAG_RETURN = 3; 		// ***Hangfix*** (flag is scheduled for return)


// =================
//     VARIABLES
// =================

// Globals
float TEAM_CAPTURE_CAPTURE_BONUS; 	// what you get for capture
float TEAM_CAPTURE_TEAM_BONUS; 		// what your team gets for capture
float TEAM_CAPTURE_RECOVERY_BONUS; 	// what you get for recovery
float TEAM_CAPTURE_FLAG_BONUS; 		// what you get for picking up enemy flag
float TEAM_CAPTURE_FRAG_CARRIER_BONUS; 	// what you get for fragging enemy flag carrier
float TEAM_CAPTURE_FLAG_RETURN_TIME; 	// seconds until auto return

// bonuses
float TEAM_CAPTURE_CARRIER_DANGER_PROTECT_BONUS; 	// bonus for fraggin someone who has recently hurt your flag carrier
float TEAM_CAPTURE_CARRIER_PROTECT_BONUS; 		// bonus for fraggin someone while either you or your target are near your flag carrier
float TEAM_CAPTURE_FLAG_DEFENSE_BONUS; 			// bonus for fraggin someone while either you or your target are near your flag
float TEAM_CAPTURE_RETURN_FLAG_ASSIST_BONUS; 		// awarded for returning a flag that causes a capture to happen almost immediately
float TEAM_CAPTURE_FRAG_CARRIER_ASSIST_BONUS; 		// award for fragging a flag carrier if a capture happens almost immediately

// radii
float TEAM_CAPTURE_TARGET_PROTECT_RADIUS; 		// the radius around an object being defended where a target will be worth extra frag s
float TEAM_CAPTURE_ATTACKER_PROTECT_RADIUS; 		// the radius around an object being defended where an attacker will get extra frag s when making kills

// =================
//     FUNCTIONS
// =================

void() SetTeamParameters = {
	TEAM_CAPTURE_CAPTURE_BONUS = 15; 
	TEAM_CAPTURE_TEAM_BONUS = 10; 
	TEAM_CAPTURE_RECOVERY_BONUS = 1; 
	TEAM_CAPTURE_FLAG_BONUS = 0; 
	TEAM_CAPTURE_FRAG_CARRIER_BONUS = 2; 
	TEAM_CAPTURE_FLAG_RETURN_TIME = 40; 
	// bonuses
	TEAM_CAPTURE_CARRIER_DANGER_PROTECT_BONUS = 2; 
	TEAM_CAPTURE_CARRIER_PROTECT_BONUS = 1; 
	TEAM_CAPTURE_FLAG_DEFENSE_BONUS = 1; 
	TEAM_CAPTURE_RETURN_FLAG_ASSIST_BONUS = 1; 
	TEAM_CAPTURE_FRAG_CARRIER_ASSIST_BONUS = 2; 
	// radii
	TEAM_CAPTURE_TARGET_PROTECT_RADIUS = 400;
	TEAM_CAPTURE_ATTACKER_PROTECT_RADIUS = 400; 
	//
	VOTEEXIT_TIME_LIMIT = 60;
};

// Return a name for the color of a team
string(float Team) GetTeamColor =
{
	// Optmimized: changed order since team is mostly 13 or 4
	if (Team == 4) return("Red");
	else if (Team == 13) return("Blue");
	else if(Team == 0) return("Grey");
	else if(Team == 1) return("Brown");
	else if(Team == 2) return("Steel blue");
	else if(Team == 3) return("Green");
	else if(Team == 5) return("Olive");
	else if(Team == 6) return("Orange");
	else if(Team == 7) return("Peech");
	else if(Team == 8) return("Purple");
	else if(Team == 9) return("Majenta");
	else if(Team == 10) return("Tan");
	else if(Team == 11) return("Aqua");
	else if(Team == 12) return("Yellow");
	else if(Team == 14) return("Bright Orange");
	else if(Team == 15) return("Bright Red");
	return "Unknown";
};

// Return a name for the color of a team
string(float Team) GetShortTeamColor = {
	// Optimized changed order since team is mostly 13 or 4
	Team = Team & 15; // color loops
	if(Team == 4) return("red");
	else if(Team == 13) return("blue");
	else if(Team == 0) return("grey");
	else if(Team == 1) return("brwn");
	else if(Team == 2) return("sblu");
	else if(Team == 3) return("grn");
	else if(Team == 5) return("olve");
	else if(Team == 6) return("orng");
	else if(Team == 7) return("pch");
	else if(Team == 8) return("purp");
	else if(Team == 9) return("majn");
	else if(Team == 10) return("tan");
	else if(Team == 11) return("aqua");
	else if(Team == 12) return("ylw");
	else if(Team == 14) return("bojn");
	else if(Team == 15) return("bred");
	return "Unknown";
};



// *XXX* EXPERT CTF
// Just a quickie to return the ASCII-ized team names for CTF
string(float Team) GetCTFTeam = {
	if (Team == TEAM_COLOR1) return "“≈ƒ";
	if (Team == TEAM_COLOR2) return "¬Ã’≈";
	return "";
};


/*
================
TeamPrintSettings

Print out current teamplay options
================
*/

void() TeamPrintSettings =
{
	// *check* Need to be rewritten

	local string s;
	
	sprint(self, PRINT_HIGH, "The following Teamplay options are set:\n");
	
	if(TEAMPLAY < 0)
	{
		sprint(self,  PRINT_HIGH, "Frag penalty manually set to ");
		s = ftos(TEAMPLAY);
		sprint(self,  PRINT_HIGH, s);
		sprint(self,  PRINT_HIGH, "\n");
		return;
	}
	
	if(!TEAMPLAY) 
	{
		sprint(self,  PRINT_HIGH, "None\n");
		return;
	}
	
	if(1 == TEAMPLAY)
	{
		sprint(self, PRINT_HIGH, "ID's original TEAMPLAY 1\n");
		return;
	}
	
	if(TEAMPLAY & TEAM_HEALTH_PROTECT)
		sprint(self, PRINT_HIGH, "Health-Protect ");
	
	if(TEAMPLAY & TEAM_ARMOR_PROTECT)
		sprint(self, PRINT_HIGH, "Armor-Protect ");
		
	if(TEAMPLAY & TEAM_ATTACKER_DAMAGE)
		sprint(self, PRINT_HIGH, "Mirror-Damage ");
		
	if(TEAMPLAY & TEAM_FRAG_PENALTY)
		sprint(self, PRINT_HIGH, "Frag-Penalty ");
		
	if(TEAMPLAY & TEAM_DEATH_PENALTY)
		sprint(self, PRINT_HIGH, "Death-Penalty ");
		
	if(TEAMPLAY & TEAM_LOCK_COLORS)
		sprint(self, PRINT_HIGH, "Lock-Colors ");
		
	if(TEAMPLAY & TEAM_STATIC_TEAMS)
		sprint(self, PRINT_HIGH, "Static-Teams ");
		
	if(TEAMPLAY & TEAM_DROP_ITEMS)
		sprint(self, PRINT_HIGH, "Drop-Items (Backpack Impulse 20, Weapon Impulse 21) ");
		
	if(TEAMPLAY & TEAM_CAPTURE_FLAG)
		sprint(self, PRINT_HIGH, "Capture-The-Flag ");

	sprint(self, PRINT_HIGH, "\n");
};


float(entity attacker, entity targ, entity inflictor) SameTeam = {
	local string attackerteam, targteam;
	local string tp;

	if (TEAMPLAY & TEAM_LOCK_COLORS) {
		return (attacker.steam == targ.steam);
	} else {
		// teamcheck from qw 
		attackerteam = infokey(attacker, "team");
		targteam = infokey(targ, "team");
		return ((targteam == attackerteam) && (attacker.classname == "player") 
			&& (attackerteam != "") && (inflictor.classname != "door"));
	}
};

/*
================
TeamArmorDam

Return TRUE if the target's armor can take damage from this attacker.
================
*/

float(entity targ, entity inflictor, entity attacker, float damage) TeamArmorDam =
{
        if (TEAMPLAY < 0 || gamestart)
                return TRUE;
        if (TEAMPLAY & TEAM_ARMOR_PROTECT)
		if (SameTeam(attacker, targ, inflictor) && ((attacker != targ) || FLAG_TP1)) {
			return FALSE;	// Protected
        }
        return TRUE;
};

/*
================
TeamHealthDam

Return TRUE if the target can take health damage from this attacker.
================
*/

float(entity targ, entity inflictor, entity attacker, float damage) TeamHealthDam =
{
        if( TEAMPLAY < 0 || gamestart)
                return TRUE;
    
	if (SameTeam(attacker, targ, inflictor) && ((attacker != targ) || FLAG_TP1))
        {
                // Attacker and target are on the same team.
                if ( TEAMPLAY & TEAM_ATTACKER_DAMAGE)
			// Mirrordamage
                        T_Damage(attacker, inflictor, attacker, damage);
                if ( TEAMPLAY & TEAM_HEALTH_PROTECT)
                        return FALSE;
        }
        return TRUE;
};


/*
================
TeamFragPenalty

If attacker should be penalized for killing targ, penalize attacker
and return TRUE.
================
*/

float(entity targ, entity attacker) TeamFragPenalty = {

        if( TEAMPLAY < 0 ) {
                attacker.frags = attacker.frags + TEAMPLAY;
		return TRUE;
	}
	if (targ != attacker && SameTeam(attacker, targ, world)) {
		attacker.frags = attacker.frags - TEAM_DEFAULT_PENALTY;
		return TRUE;
	}
	return FALSE;	// No Penalty
};

/*
=================
TeamDeathPenalty

If attacker should be killed for killing targ, kill attacker and
add a frag to offset the one attacker will lose for killing himself.
*/

void(entity targ, entity attacker) TeamDeathPenalty =
{
        //Don't kill anyone if TEAMPLAY is negative.
        if ( TEAMPLAY < 0 )
                return;

        if ( (TEAMPLAY & TEAM_DEATH_PENALTY) &&
			(attacker != targ) && SameTeam(attacker, targ, world))
        {
                //We should kill the attacker.
                T_Damage(attacker,attacker,attacker,99999);
                //Add a frag to offset the self-kill penalty.
                attacker.frags = attacker.frags + 1;
        }
};

/*
==================
TeamColorIsLegal

Return TRUE if the indicated color is legal
==================
*/
float(float color) TeamColorIsLegal =
{
        // All colors are legal if TEAMPLAY is negative.
        if( TEAMPLAY < 0 )
                return TRUE;

        // All colors are legal if TEAM_LOCK_COLORS is off.
        if( !(TEAMPLAY & TEAM_LOCK_COLORS) )
                return TRUE;
        if(color == TEAM_COLOR1)
                return TRUE;
        if(color == TEAM_COLOR2)
                return TRUE;
	return FALSE;
};

float(float tcolor, float bcolor) CrossDressCheck = {
	if((TEAMPLAY < 0) || !(TEAMPLAY & TEAM_LOCK_COLORS))
		return FALSE;
	// All colors are legal if TEAM_LOCK_COLORS is off.
	return ((tcolor + bcolor) == (TEAM_COLOR1 + TEAM_COLOR2));
};

/*
==================
TeamAssign

Check if the team self is on is legal, and put self in a legal team if not.
==================
*/
void() TeamAssign =
{
	local float newcolor;
	local entity p;
	local string n; 
	local entity e;

	if (!(TEAMPLAY & TEAM_LOCK_COLORS))
		return;

	if (self.steam >= 0) {
		if(TeamColorIsLegal(self.steam)) {
			ScoresRecoverFrags();
			StuffAutoTeam(self);
			return;
		}
	}

	// Assign the player to a team.
	// Sum the players on all the teams.

	// Find the team with the least players.
	if (TeamColorIsLegal(self.lastteam) && (time < SCRAMBLE) && (self.lastteam >= 0)) { // *check* to infovars
		newcolor = self.lastteam;
		if (FLAG_DEBUG) {	// *debug*
			local string tp;
			sprint(self, PRINT_HIGH, "You've been set to team ");
			tp =ftos(self.lastteam);
			sprint(self, PRINT_HIGH, tp);
			sprint(self, PRINT_HIGH, "\n"); 
		}
	} else {
		if (TEAM1 < TEAM2 || ((TEAM1 == TEAM2) && (random() < 0.5)))
			newcolor = TEAM_COLOR1;
		else
			newcolor = TEAM_COLOR2;
	}

	// Put the player on a the new team.
	if (!FLAG_STANDBY) {
		sprint(self, PRINT_HIGH, "You have been assigned to ");
		n = GetTeamColor(newcolor);
		sprint(self, PRINT_HIGH, n);
		sprint(self, PRINT_HIGH, " team.\n");
	}

	StuffAutoTeam(self);

	self.steam = newcolor;
	self.lastteam = newcolor;
	ScoresRecoverFrags();

	GSPlayerTeamChange(self);

	self.player_flag = self.player_flag | (PF_STUFFCOLOR);
	CheckTopColor();
	UpdateClientChain();
};


void() CheckTopColor = {
	local string s;
	local float n;
	if (IsObserver(self)) {
		n = stof(infokey(self, "topcolor"));
		if (n != 0) {
			self.oldcolors = n;
			setinfo(self, "topcolor", 0);
		}
		setinfo(self, "topcolor", 0);
		setinfostring(self, "team", "spec");
	} else if (stof(infokey(world, "shirtlock")) == 2) {
		setinfo(self, "topcolor", self.steam);
	} else if (self.oldcolors) {
		n = self.oldcolors;
		if (CrossDressCheck(n, self.steam) || (n > 13))
			n = self.steam;
		setinfo(self, "topcolor", n);
		self.oldcolors = 0;
	} else {
		s = infokey(self, "topcolor");
		n = stof(s);
		if (CrossDressCheck(n, self.steam) || (n > 13)) 
			setinfo(self, "topcolor", self.steam);
	}
};


void() TeamCheckSkinandTeam = {
	local string s;
	s = GetShortTeamColor(self.steam);
	setinfostring(self, "team", s);


	if (FLAG_CTF)  {
		if (FLAG_CUSTOMSKINS) {
			if ((self.steam == TEAM_COLOR1))
				s = infokey(world, "redskin");
			else
				s = infokey(world, "blueskin");
		} else if (random() < 2) {			// debug *check* fix so both skins are used?
			if ((self.steam == TEAM_COLOR1))
				s = "ctfr1";
			else
				s = "ctfb1";
		} else {
			if ((self.steam == TEAM_COLOR1))
				s = "ctfr2";
			else
				s = "ctfb2";
		}
		setinfostring(self, "skin", s);
	
	}
};


/*
===============
TeamCheckLock

Check for team changing and perform whatever actions are neccessary.
===============
*/
void() TeamCheckLock = {
// *pure* optimized Teamchecklock quite a bit
        local   float   n;
        local   string  s, t;
	local	float	pteam;
	local string tp;

        if ( TEAMPLAY < 0 )
                return;
	if (!(TEAMPLAY & TEAM_LOCK_COLORS))
		return;

	if (gamestart) {
		setinfo(self, "bottomcolor", 0);
		self.steam = -1;
	} else if (self.player_flag & PF_STUFFCOLOR) {
		self.player_flag = self.player_flag - (self.player_flag & (PF_STUFFCOLOR));
		setinfo(self, "bottomcolor", self.steam);
		TeamCheckSkinandTeam();
	} else if (IsObserver(self)) {
		setinfo(self, "bottomcolor", 0);
	} else if (TEAMPLAY & TEAM_LOCK_COLORS) {
		if ((self.join_time + 10) < time)
			TeamCheckSkinandTeam();
		s = infokey(self, "bottomcolor");
		pteam = stof(s);
		

		if (self.steam < 0)
			TeamAssign();
		else if (s == "") 
			KickClient(self, "Your setinfo is messed up!");
		else if (pteam != self.steam) {
			// Player has changed colors
			if (CountDown) {
				setinfo(self, "bottomcolor", self.steam);
			} else if (FLAG_STANDBY) {
				if (TeamColorIsLegal(pteam)) {
					setinfo(self, "bottomcolor", pteam);
					self.steam = pteam;
					StuffAutoTeam(self);
				} else {
					self.steam = -1;
					TeamAssign();
				}
			} else if ((self.join_time + 10) > time) {
				return;
			} else if ((TEAMPLAY & TEAM_STATIC_TEAMS) && (self.steam >= 0)) {
				// If teams are static and we've been on some team already,
				// put us back on the team we were on.
				if (TeamColorIsLegal(self.steam)) {
					if (self.suicide_count > 3) 
						KickClient(self, "Kicked because of bad color sense");
					// case base respawn
					self.killed = 99;
					T_Damage(self,self,self,999999);  // Kill the player
					self.killed = 2;
					// trying to change teams counts as a suicide
					self.suicide_count = self.suicide_count + 1;
					logfrag(self, self); // he pays for it
					// *check* logging?
					sprint(self, PRINT_HIGH, "You cannot change teams.\n");
					setinfo(self, "bottomcolor", self.steam);
					return;
				} else {
					// If we're on an illegal team, force a change.
					self.steam = -1;
					self.frags = 0;
					TeamAssign();
				}
			} else {
				ScoreAddDisconnect(self);
				self.killed = 99;
				T_Damage(self,self,self,10000);  // Kill the player
				self.killed = 0;
				self.steam = pteam;
				GSPlayerTeamChange(self);	// gslog
				self.frags = 0;
				TeamAssign();
				UpdateClientChain();
			}
		}
	}
	CheckTopColor();
};

/*
=======================
TossBackPack

Original idea by Vhold
Rewritten by John Spickes

Toss out a backpack containing some ammo from your current weapon,
and any weapons you don't have.
=======================
*/
void() TossBackpack =
{
	local entity 	item;
	local float x;


	if ((FLAG_STANDBY || IsObserver(self) || FREEZEFLAGS))		// *pure*
		return;

        // If we don't have any ammo, return (except AXE/GRAPPLE) 
        if(self.currentammo <= 0)
        {
                if (self.weapon != IT_AXE &&  self.weapon != IT_GRAPPLE)
		return;
        }

	item = spawn();

	// See if you have the Shotgun or Super Shotgun on
        if ((self.weapon == IT_SHOTGUN) || (self.weapon == IT_SUPER_SHOTGUN) ||
	    (!(self.items & IT_SHOTGUN) && !(self.items & IT_SUPER_SHOTGUN))) {
		if( self.ammo_shells >= 20 ) 
			item.ammo_shells = 20;
		else
			item.ammo_shells = self.ammo_shells;
		self.ammo_shells = self.ammo_shells - item.ammo_shells;
	}		
	
	
	// Check for nails
	if ((self.weapon == IT_SUPER_NAILGUN) || 
	    (self.weapon == IT_NAILGUN) ||
	    (!(self.items & IT_NAILGUN) && (!(self.items & IT_SUPER_NAILGUN)))) {
		if (self.ammo_nails >= 20 )
			item.ammo_nails = 20;
		else
			item.ammo_nails = self.ammo_nails;
		self.ammo_nails = self.ammo_nails - item.ammo_nails;
	}	


	// See if we are using a grenade or rocket launcher
        if ( (self.weapon == IT_GRENADE_LAUNCHER) || 
             (self.weapon == IT_ROCKET_LAUNCHER) ||
	     ( !(self.items & IT_GRENADE_LAUNCHER) && !(self.items & IT_ROCKET_LAUNCHER))) {
		if( self.ammo_rockets >= 10 )
			item.ammo_rockets = 10;
		else
			item.ammo_rockets = self.ammo_rockets;
		self.ammo_rockets = self.ammo_rockets - item.ammo_rockets;
	}

	// See if we're using the lightning gun or TW laser
	if ( (self.weapon == IT_LIGHTNING) ||
             (!(self.items & IT_LIGHTNING))) { 
		if( self.ammo_cells >= 20 ) 
			item.ammo_cells = 20;
		else
			item.ammo_cells = self.ammo_cells;
		self.ammo_cells = self.ammo_cells - item.ammo_cells;
	}

	if (!item.ammo_shells && !item.ammo_nails && !item.ammo_rockets && !item.ammo_cells) {
		// we didn't put anything in
		remove(item);
		return;
	}

	TossItem(self, item, 500);

	setmodel (item, "progs/backpack.mdl");


	setsize(item, '-16 -16 0', '16 16 56');
	item.touch = BackpackTouch;
	item.nextthink = time + 120;	// remove after 2 minutes
	item.think = SUB_Remove;
	W_SetCurrentAmmo();
};

void() Team_weapon_touch =
{
	local	float	hadammo, best, new, old;
	local entity stemp;

	if (!(other.flags & FL_CLIENT))
		return;
	// Don't let the owner pick up his own weapon for a second.
	if ( (other == self.owner) && ( (self.nextthink - time) > 119 ) )
		return;

	// if the player was using his best weapon, change up to the new one if better		
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;

	if (self.classname == "weapon_nailgun")
	{
		hadammo = other.ammo_nails;			
		new = IT_NAILGUN;
	}
	else if (self.classname == "weapon_supernailgun")
	{
		hadammo = other.ammo_rockets;			
		new = IT_SUPER_NAILGUN;
	}
	else if (self.classname == "weapon_supershotgun")
	{
		hadammo = other.ammo_rockets;			
		new = IT_SUPER_SHOTGUN;
	}
	else if (self.classname == "weapon_rocketlauncher")
	{
		hadammo = other.ammo_rockets;			
		new = IT_ROCKET_LAUNCHER;
	}
	else if (self.classname == "weapon_grenadelauncher")
	{
		hadammo = other.ammo_rockets;			
		new = IT_GRENADE_LAUNCHER;
	}
	else if (self.classname == "weapon_lightning")
	{
		hadammo = other.ammo_rockets;			
		new = IT_LIGHTNING;
	}
	else
		objerror ("Team_weapon_touch: unknown classname");

	sprint (other, PRINT_LOW, "You got the ");
	sprint (other, PRINT_LOW, self.netname);
	sprint (other, PRINT_LOW, "\n");
// weapon touch sound
	sound (other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
	stuffcmd(other, "bf\n");

	bound_other_ammo ();

// change to the weapon
	old = other.items;
	other.items = other.items | new;
	
	remove(self);
	self = other;

	if (!DEATHMATCH)
		self.weapon = new;
	else
		Deathmatch_Weapon (old, new);

	W_SetCurrentAmmo();

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};
        

void() TossWeapon = {
	local entity item;
	// Check for illegal tosses
	if ((FLAG_STANDBY || IsObserver(self) || FREEZEFLAGS))
		return;
	if (DEATHMATCH != 1)
		return;  // only in deathmatch 1
	if ((self.weapon == IT_AXE) || (self.weapon == IT_SHOTGUN) || (self.weapon == IT_GRAPPLE) )
		return;
		
	item = spawn();


	TossItem(self, item, 500);
	
	if (self.weapon == IT_SUPER_SHOTGUN)
	{
		setmodel (item, "progs/g_shot.mdl");
		item.weapon = IT_SUPER_SHOTGUN;
		item.netname = "Double-barrelled Shotgun";
		item.classname = "weapon_supershotgun";
		self.items = self.items - IT_SUPER_SHOTGUN;
	}

	if( self.weapon == IT_NAILGUN )
	{
		item.netname = "nailgun";
		setmodel (item, "progs/g_nail.mdl");
		item.weapon = IT_NAILGUN;
		item.classname = "weapon_nailgun";
		self.items = self.items - IT_NAILGUN;
	}
		
	if( self.weapon == IT_SUPER_NAILGUN)
	{
		setmodel (item, "progs/g_nail2.mdl");
		item.weapon = IT_SUPER_NAILGUN;
		item.netname = "Super Nailgun";
		item.classname = "weapon_supernailgun";
		self.items = self.items - IT_SUPER_NAILGUN;
	}
	
	if( self.weapon == IT_GRENADE_LAUNCHER)
	{
		setmodel (item, "progs/g_rock.mdl");
		item.weapon = 3;
		item.netname = "Grenade Launcher";
		item.classname = "weapon_grenadelauncher";
		self.items = self.items - IT_GRENADE_LAUNCHER;
	}
	
	if( self.weapon == IT_ROCKET_LAUNCHER )
	{
		setmodel (item, "progs/g_rock2.mdl");
		item.weapon = 3;
		item.netname = "Rocket Launcher";
		item.classname = "weapon_rocketlauncher";
		self.items = self.items - IT_ROCKET_LAUNCHER;
	}
	
	if( self.weapon == IT_LIGHTNING )
	{
		setmodel (item, "progs/g_light.mdl");
		item.netname = "Thunderbolt";
		item.weapon = 3;
		item.classname = "weapon_lightning";
		self.items = self.items - IT_LIGHTNING;
	}
	setsize(item, '-16 -16 0', '16 16 56');
	item.touch = Team_weapon_touch;
	item.think = SUB_Remove;
	item.nextthink = time + 120;
	
	self.weapon = W_BestWeapon();
	W_SetCurrentAmmo();
};

// *check* -->

void(entity flg) RegenFlag =
{
	flg.movetype = MOVETYPE_TOSS;
	flg.solid = SOLID_TRIGGER;
	setmodel(flg, flg.mdl);

// ***hangfix*** --> Can't return it right away - makes the server freeze on rare occations
	//	setorigin(flg, flg.oldorigin);		
	//	flg.cnt = FLAG_AT_BASE;
	flg.cnt = FLAG_RETURN; // ***hangfix*** (it's returning)
	flg.nextthink = time + 0.2;
// ***hangfix*** <-- 

	flg.angles = flg.mangle;
	flg.owner = world;
	flg.velocity = '0 0 0';
	sound (flg, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);	// play respawn sound

// ***floatflagbug**** --> Stops the flag from "floating around" after being dropped on an elevator
	if (!FLAG_FLOATFLAGBUG)
		flg.groundentity = world;		
// ***floatflagbug**** <--

};

void(entity flg) TeamCaptureReturnFlag =
{
	local entity p;

	RegenFlag(flg);

	p = find(world, classname, "player");
	while (p != world) {
		if (!SameTeam(p, flg, world))
			PrintStatusbar(p, "Enemy flag has been returned to base!",1);
		else if (SameTeam(p, flg, world))
			PrintStatusbar(p, "Your flag has been returned to base!",1);
		p = find(p, classname, "player");
	}
};

void () TeamCaptureRegenFlags =
{
	local entity f;

	f = find(world, classname, "item_flag_team1");
	if (f != world)
		RegenFlag(f);
	f = find(world, classname, "item_flag_team2");
	if (f != world)
		RegenFlag(f);
};

void(entity flg) TeamDropFlag =
{
	local entity item, f, oself;
	local entity p;			// tw50

	p = flg.owner;
	if (p.classname != "player")		// tw50
		return;

	bprint(PRINT_HIGH, p.netname);
	if ((p.steam == TEAM_COLOR1))
		bprint(PRINT_HIGH, " ÏÔÛÙ the ¬Ã’≈ flag!\n"); // blue
	else
		bprint(PRINT_HIGH, " ÏÔÛÙ the “≈ƒ flag!\n"); // red


	LogFlagdrop(p);		//GSLog

	p.effects = p.effects - (p.effects & (EF_FLAG1 | EF_FLAG2));

	flg.origin = p.origin - '0 0 24';
	flg.cnt = FLAG_DROPPED;
	flg.velocity_z = 300;
	flg.velocity_x = 0;
	flg.velocity_y = 0;
	flg.flags = FL_ITEM;
	flg.solid = SOLID_TRIGGER;
	flg.movetype = MOVETYPE_TOSS;
	setmodel(flg, flg.mdl);
	setsize(flg, '-16 -16 0', '16 16 74');
	// return it after so long
	flg.super_time = time + TEAM_CAPTURE_FLAG_RETURN_TIME;
};

void(entity player) TeamCaptureDropFlagOfPlayer =
{
	local string kn;
	local entity e;

	if (!(player.player_flag & PF_GOTFLAG))
		return;

	if (player.classname != "player")
		return;

	if ((player.steam == TEAM_COLOR1)) 
		kn = "item_flag_team2";
	else
		kn = "item_flag_team1";
	player.player_flag = player.player_flag - (player.player_flag & (PF_GOTFLAG));	// tw50
	e = find(world, classname, kn);
	if (e != world) {
		if (player.player_flag & PF_KILLME)
			RegenFlag(e);
		else
			TeamDropFlag(e);
	}
// ***rljumpctf*** --> Reset speed.
	SetPlayerSpeed(player);
// ***rljumpctf*** <--
};

// possum: 3 loops in one.  Hopefully this will help prevent an
// occasional server lockup when a player picks up and then captures the
// flag in rapid succession

void() LoopThroughPlayersAfterCapture =
{
	local entity p;

	// count up teamscr
	lastteamscrtime = time + TEAMSCRTIME;
	teamscr1 = teamscr2 = 0;

	// Ok, let's do the player loop, hand out the bonuses, add up
	// the scores, and inform the players about the capture

	p = find(world, classname, "player");
	while (p != world) {

		// Ok, let's do the player loop, hand out the bonuses
		self = p;
		if (!FLAG_DISABLE_CAPTURE_BASE_SPAWN)
			self.killed = 0;
		if (SameTeam(self, other, world) && self != other)
			LogCaptureBonus(self, TEAM_CAPTURE_TEAM_BONUS);
		if (!SameTeam(self, other, world)) {
			// *XXX* EXPERT CTF
			// reset the last_hurt_carrier variable in all enemy
			// players, so that you don't get bonuses for defending
			// the flag carrier if the flag carrier has already
			// completed a capture
			self.last_hurt_carrier = -5;
		} else if (SameTeam(self, other, world)) {
			// done to all players on the capturing team
			// *XXX* EXPERT CTF
			// award extra points for capture assists
			if (self.last_returned_flag + TEAM_CAPTURE_RETURN_FLAG_ASSIST_TIMEOUT > time) {
				bprint(PRINT_HIGH, self.netname);
				bprint(PRINT_HIGH, " gets an assist for returning his flag!\n");
				LogReturnAssist(self, TEAM_CAPTURE_RETURN_FLAG_ASSIST_BONUS);
			}
			if (self.last_fragged_carrier + TEAM_CAPTURE_FRAG_CARRIER_ASSIST_TIMEOUT > time) {
				bprint(PRINT_HIGH, self.netname);
				bprint(PRINT_HIGH, " gets an assist for fragging the flag carrier!\n");
				LogFragAssist(self, TEAM_CAPTURE_FRAG_CARRIER_ASSIST_BONUS);
			}
		}
		self.player_flag = self.player_flag - (self.player_flag & (PF_GOTFLAG));
	
		// count up teamscr
		if ((p.steam == TEAM_COLOR1))
			teamscr1 = teamscr1 + p.frags;
		else if ((p.steam == TEAM_COLOR1))
			teamscr2 = teamscr2 + p.frags;

		// inform players about capture
		if (((p.steam == TEAM_COLOR1) && (other.steam == TEAM_COLOR2)) ||
			((p.steam == TEAM_COLOR2) && (other.steam == TEAM_COLOR1)))
			PrintStatusbar(p, "Your flag was captured!",1);
		else if (SameTeam(p, other, world))
			PrintStatusbar(p, "Your team captured the flag!",1);

		// remove any flags
		p.effects = p.effects - (p.effects & (EF_FLAG1 | EF_FLAG2));

		p = find(p, classname, "player");
	}
};

void() TeamCaptureFlagTouch =
{
	local entity p, oself, e, escort;	// tw50
	local float timmy;			// tw50

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

// ***hangfix*** --> Can't touch it while its returning home
	if (self.cnt == FLAG_RETURN)		
		return;		
// ***hangfix*** <--

// ***purectf*** --> ...or when you have tossed it.
	if ((self.cnt == FLAG_TOSSED) && (other == self.owner))		
		return;		
// ***purectf***

	if (SameTeam(self, other, world)) {
		if (self.cnt == FLAG_AT_BASE) {
			if (other.player_flag & PF_GOTFLAG) {
				bprint(PRINT_HIGH, other.netname);
				if ((other.steam == TEAM_COLOR1))
					bprint(PRINT_HIGH, " „·ÙıÚÂ‰ the ¬Ã’≈ flag!\n"); // blue
				else
					bprint(PRINT_HIGH, " „·ÙıÚÂ‰ the “≈ƒ flag!\n"); // red

				last_flag_capture = time;
				last_capture_team = other.steam;
	
				bprint(PRINT_HIGH, "The capture took ");
				if (self.classname == "item_flag_team1")
					PrintTime2All(time - BLUE_PICKUP);
				else
					PrintTime2All(time - RED_PICKUP);
				bprint(PRINT_HIGH, "\n");

				ScoreAddCapture(other);
				other.items = other.items - (other.items & (IT_KEY1 | IT_KEY2));

				// other gets another 10 frag bonus
				LogCapture(other, TEAM_CAPTURE_CAPTURE_BONUS);	//gslog

				last_flag_capture = time;
				last_capture_team = other.steam;
				sound (other, CHAN_VOICE, SOUND_CAPTURE, 1, ATTN_NONE); // ThunderWalker: SPOOOONNN!!!

				// possum: 3 loops in one
				LoopThroughPlayersAfterCapture();

				TeamCaptureResetUpdate();		// TW50
				// respawn flags
				TeamCaptureRegenFlags();
				SetPlayerSpeed(other);
				return;
			}
			return; // its at home base already
		}	

		// hey, its not home.  return it by teleporting it back
		bprint(PRINT_HIGH, other.netname);
		if (other.steam == TEAM_COLOR1)
			bprint(PRINT_HIGH, " ÚÂÙıÚÓÂ‰ the “≈ƒ flag!\n"); // red
		else
			bprint(PRINT_HIGH, " ÚÂÙıÚÓÂ‰ the ¬Ã’≈ flag!\n"); // red
		LogRecovery(other, TEAM_CAPTURE_RECOVERY_BONUS);	//gslog

		// *XXX* EXPERT CTF set time when player last returned his flag
		other.last_returned_flag = time;
		sound (other, CHAN_ITEM, self.noise1, 1, ATTN_NORM);
		TeamCaptureReturnFlag(self);
		return;
	}

// ***SINGLECAP*** --> No meaning to capture when alone on the server.

	if (!FLAG_SINGLECAP && !FLAG_COMPETITION) {
        	if ((TEAM1 == 0) || (TEAM2 == 0)) {
			PrintStatusbar(other, "You must have an opponent to play!",0);
			return;
		}
	}
// ***SINGLECAP*** <--


	// hey, its not our flag, pick it up


	bprint(PRINT_HIGH, other.netname);
	if (other.steam == TEAM_COLOR1)
		bprint(PRINT_HIGH, " ÁÔÙ the ¬Ã’≈ flag!\n"); // blue	//*check*
	else
		bprint(PRINT_HIGH, " ÁÔÙ the “≈ƒ flag!\n"); // red	//*ceck*

	LogPickup(other, TEAM_CAPTURE_FLAG_BONUS);
	PrintStatusbar(other, "Ÿœ’ «œ‘ ‘»≈ ∆Ã¡«! - “≈‘’“Œ ‘œ ¬¡”≈!", 1);
	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);

	other.player_flag = other.player_flag | (PF_GOTFLAG);
	other.items = other.items | self.items;

// ***rljumpctf*** --> Freeze player.
	SetPlayerSpeed(other);
// ***rljumpctf*** <--

// ***pure*** --> record capture time
	if (self.cnt == FLAG_AT_BASE) {
		if (self.classname == "item_flag_team1")
			RED_PICKUP = time;
		else
			BLUE_PICKUP = time;
	}
// ***pure***

	// *XXX* EXPERT CTF set the time at which the carrier picked up the flag
	other.flag_since = time;

	// pick up the flag
	self.cnt = FLAG_CARRIED;
	self.solid = SOLID_NOT;
	self.owner = other;
	if (self.steam == TEAM_COLOR1)
		self.owner.effects = self.owner.effects | EF_FLAG1;
	else // must be other team
		self.owner.effects = self.owner.effects | EF_FLAG2;
	setmodel(self, "");

	p = find(world, classname, "player");
	while (p != world) {
		if (p != other) {
			if (p.steam != other.steam)
				PrintStatusbar(p, "Your flag has been taken!",1);
			else if (p.steam == other.steam)
				PrintStatusbar(p, "Your team has the enemy flag!",1);
		}
		p = find(p, classname, "player");
	}
};

// *check* needs to be severely optimized
void() TeamCaptureFlagThink =
{
	local entity e;
	local vector v;
	local float f;
	local string s;

	self.nextthink = time + 0.1;


	if (FREEZEFLAGS & FREEZE_WORLD) 		// ***pure*** world is frozen (1.51)
		return;

	if (self.cnt == FLAG_AT_BASE) {
		return; // just sitting around waiting to be picked up

	} else if (self.cnt == FLAG_DROPPED) {
		if (time > self.super_time )
			TeamCaptureReturnFlag(self);

// ***hangfix*** -->				Delayed return
	} else if (self.cnt == FLAG_RETURN) {	
		setorigin(self, self.oldorigin);
		self.cnt = FLAG_AT_BASE;
// ***hangfix*** <--

// ***pure***
	} else if (self.cnt == FLAG_TOSSED) {	
		if (time > self.super_time) {
			self.super_time = time + 5;	// better pick it up fast
			self.cnt = FLAG_DROPPED;
		}
// ***pure***
	} else if (self.cnt != FLAG_CARRIED) {
		objerror("Flag in invalid state\n");
	}
};

entity() TeamCaptureSpawn =
{
	
	if (!FLAG_CTF)
		return world;

	if (self.steam == TEAM_COLOR1) {
		team1_lastspawn = find(team1_lastspawn, classname, "info_player_team1");
		lastred = lastred + 1;
		if (team1_lastspawn == world) {
			team1_lastspawn = find(team1_lastspawn, classname, "info_player_team1");
			lastred = 1;
		}
		return team1_lastspawn;
	} else if (self.steam == TEAM_COLOR2) {
		team2_lastspawn = find(team2_lastspawn, classname, "info_player_team2");
		lastblue = lastblue + 1;
		if (team2_lastspawn == world) {
			team2_lastspawn = find(team2_lastspawn, classname, "info_player_team2");
			lastblue = 1;
		}
		return team2_lastspawn;
	}
	return world;
};

/*
	From byron@caseware.com Wed Oct 16 18:57:44 1996
	Date: Wed, 16 Oct 1996 21:22:37 -0400
	From: Byron Long <byron@caseware.com>
	To: zoid@mindlink.net
	Subject: Team Status Command (source code included) :-)

	A co-worker of mine wondered if it was possible to add a function to
	your capture the flag code that would give a status report on an
	impulse. I think he may have mailed you, but I wrote a quick version
	myself, which your welcome to use if you like the feature (it offsets
	some of the problems with the chat capabilities in Quake so it seems
	like a worthwhile feature). Feel free to change it
	as necessary.
*/


void(string flagname, entity flg) FlagStat = {



	if (flg != world && flg.cnt == FLAG_CARRIED) {
		if (self == flg.owner) {
			sprint(self, PRINT_HIGH, "You have "); 
			sprint(self, PRINT_HIGH, flagname);
			sprint(self, PRINT_HIGH, " flag.\n");
		} else {
			sprint(self, PRINT_HIGH, flg.owner.netname);
			sprint(self, PRINT_HIGH, " has ");
			sprint(self, PRINT_HIGH, flagname);
			sprint(self, PRINT_HIGH, " flag.\n");
		}
	} else {
		sprint(self, PRINT_HIGH, flagname);
		sprint(self, PRINT_HIGH, " flag is ");
		if (flg == world)
			sprint(self, PRINT_HIGH, "missing! ");
		if (flg.cnt == FLAG_AT_BASE)
			sprint(self, PRINT_HIGH, "at base. ");
		else if (flg.cnt == FLAG_DROPPED)
			sprint(self, PRINT_HIGH, "lying about. ");
		else if (flg.cnt == FLAG_RETURN)
			sprint(self, PRINT_HIGH, "returning to base. ");
		else if (flg.cnt == FLAG_TOSSED)
			sprint(self, PRINT_HIGH, "just tossed. ");
		else
			sprint(self, PRINT_HIGH, "corrupt. ");
	}
};

// *Capture The Flag - Status report by Wonko
void() TeamFlagStatusReport =
{
	local entity flag1, flag2, p;

	if (FLAG_STANDBY) {
		CompShowStatus();
		return;
	}
	if (FLAG_CTF) {
		// Find the flags at home base
		flag1 = find (world,classname, "item_flag_team1");
		flag2 = find (world,classname, "item_flag_team2");	

		if (self.classname == "spectator") {
			FlagStat("The “≈ƒ", flag1);
			FlagStat("The ¬Ã’≈", flag2);
		} else {
			// If on team 2 switch meanings of flags
			if (self.steam != TEAM_COLOR1) {
				p = flag1;
				flag1 = flag2;
				flag2 = p;
			}
			FlagStat("Your", flag1);
			FlagStat("The enemy", flag2);	
		}
	}
	if (TIMELIMIT) {
		PrintTimeLeft(self);
		sprint(self, PRINT_HIGH, " left");
	}
	sprint(self, PRINT_HIGH, "\n");
};

/////////////////////////////////////////////////////////////////////////

$cd id1/models/flag
$base base
$skin skin

void() place_flag = {
	self.mdl = self.model;		// so it can be restored on respawn
	self.flags = FL_ITEM;		// make extra wide
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;	
	self.velocity = '0 0 0';
	self.origin_z = self.origin_z + 6;
	self.think = TeamCaptureFlagThink;
	self.touch = TeamCaptureFlagTouch;
	self.nextthink = time + 0.1;
	self.cnt = FLAG_AT_BASE;
	self.mangle = self.angles;
	self.effects = self.effects | EF_DIMLIGHT;
	if (!droptofloor()) {
		dprint ("Flag fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
		return;
	}
	self.oldorigin = self.origin; // save for flag return
};

// ZOID Capture the flag

void() spawn_item_flag =
{
	if (!DEATHMATCH || !FLAG_CTF) {
		remove(self);
		return;
	}

	setmodel (self, "progs/flag.mdl");
	self.noise = SOUND_GETFLAG;
	self.noise1 = SOUND_FLAGNOICE; 
	setsize(self, '-16 -16 0', '16 16 74');
	self.nextthink = time + 0.2;	// items start after other solids
	self.think = place_flag;
	self.newflag = NEWFLAG;		// debug
};

void() item_flag_team1 = {
	self.steam = TEAM_COLOR1;
	self.items = IT_KEY2;
	self.skin = 0;
	if (FLAG_GL_FLAGS)
		self.effects = self.effects | EF_RED;
	spawn_item_flag();
};

void() item_flag_team2 =
{
	self.steam = TEAM_COLOR2;
	self.items = IT_KEY1;
	self.skin = 1;
	if (FLAG_GL_FLAGS)
		self.effects = self.effects | EF_BLUE;
	spawn_item_flag();
};


// Team base starting locations
void() info_player_team1 =
{
};

void() info_player_team2 =
{
	//if (ARENA_INHIBIT) {remove(self);return;}
};

/*QUAKED func_ctf_wall (0 .5 .8) ?
This is just a solid wall if not inhibitted
Only appears in CTF teamplay
*/
void() func_ctf_wall =
{
	if (FLAG_CTF) {
		self.angles = '0 0 0';
		self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
		self.solid = SOLID_BSP;
		setmodel (self, self.model);
	} else
		remove(self);
};

// *check*
