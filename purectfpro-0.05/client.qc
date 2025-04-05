//ClientOb
float() GameOver = {		// *inline*
	return (gameover || pregameover);
};


// *inline* !
// dimlight=8 blue=64 red=128
float EF_ALL = 200;		// EF_DIMLIGHT | EF_RED | EF_BLUE;
float EF_ONLYRED = 136;		// EF_DIMLIGHT | EF_RED;
float EF_ONLYBLUE = 72;		// EF_DIMLIGHT | EF_BLUE;
float EF_REDANDBLUE = 192;	// EF_RED | EF_BLUE;

float EF_MASKBLUE = 191;
float EF_MASKRED =  127;
float EF_MASKREDBLUE = 63;
float EF_MASKALL =  55;


//
// Set player glow.
//
void () CheckDimLight = {
	if (FLAG_STANDBY) {
		// Glow when not ready
		if (self.classname == "notready")
			self.effects = (self.effects | EF_ONLYBLUE) & EF_MASKRED;
		else
			self.effects = self.effects & EF_MASKALL;
		return;
	}
	if (FLAG_GL_PLAYERS) {
		if (self.invincible_finished > time) {
			self.effects = (self.effects | EF_ONLYRED ) & EF_MASKBLUE;
		} else 	if (self.super_damage_finished > time) {
				self.effects = (self.effects | EF_ONLYBLUE ) & EF_MASKRED;
			} else if (self.player_flag & PF_GOTFLAG) {
				self.effects = (self.effects | EF_DIMLIGHT) & EF_MASKREDBLUE;
			} else {
				self.effects = self.effects & EF_MASKALL;
			}
	} else {
		if (self.player_flag & PF_GOTFLAG)
			self.effects = self.effects | EF_DIMLIGHT ;
		else if (self.invincible_finished > time)
			self.effects = self.effects | EF_DIMLIGHT ;
		else if (self.super_damage_finished > time) 						
			self.effects = self.effects | EF_DIMLIGHT ;
		else
			self.effects = self.effects & EF_MASKALL;
	}
};

/*
=============================================================================

				LEVEL CHANGING / INTERMISSION

=============================================================================
*/

string nextmap;

float	intermission_running;
float	intermission_exittime;

//
// QUAKED info_intermission (1 0.5 0.5) (-16 -16 -16) (16 16 16)
// This is the camera point for the intermission.
// Use mangle instead of angle, so you can set pitch or roll as well as yaw.  'pitch roll yaw'
//
void() info_intermission =
{	
};

//
// Save parameters between levels.
//
void() SetChangeParms = {
	if (gamestart)
		parm10 = -1;
	else 
		parm10 = self.steam;
	parm12 = self.admin;
	GetRank(self);
	parm1 = self.rank;
	parm2 = self.lastteam;

	parm3 = self.frags;
	parm4 = self.log1;
	parm5 = self.log2;
	parm6 = self.log3;
	parm7 = self.log4;
};

//
// Initialize parameters for new players.
//
void() SetNewParms = {
	parm10 = -1;
	parm12 = 0;
	parm1 = 45 + (random() * 10);
	parm2 = -1;

	parm3 = 0;	// frags;
	parm4 = 0;	// log1;
	parm5 = 0;	// log2;
	parm6 = 0;	// log3;
	parm7 = 0;	// log4;

};

//
// Restore parameters from last level.
//
void() DecodeLevelParms = {
	self.steam = -1;
	if (time < SCRAMBLE) {		//*check*
		self.lastteam = parm2;
		if (FLAG_DEBUG) {	// *debug*
			local string tp;
			sprint(self, PRINT_HIGH, "Restored from team ");
			tp =ftos(self.lastteam);
			sprint(self, PRINT_HIGH, tp);
			sprint(self, PRINT_HIGH, "\n"); 
		}
	} else {
		if (TeamColorIsLegal(parm10))
			self.steam = parm10;
		self.lastteam = self.steam;
	}
	self.admin = parm12;
	self.rank = parm1;

	if (FLAG_COMPETITION) {
		self.frags = parm3;
		self.log1 = parm4;
		self.log2 = parm5;
		self.log3 = parm6;
		self.log4 = parm7;
	} else {
		self.frags = 0;
		self.log1 = 0;
		self.log2 = 0;
		self.log3 = 0;
		self.log4 = 0;
	}
};


//
// Called from SetFreshItems.
//
void(float s, float n, float r, float c) SetAmmo = {
		self.ammo_shells = s;
		self.ammo_nails = n;
		self.ammo_rockets = r;
		self.ammo_cells = c;
};

//
// Called from SetFreshItems.
//
void(float i, float w, float h, float a, float v) SetItems = {
		self.items = i;
		self.health = h;
		self.armorvalue = a;
		self.armortype = v;
		self.weapon = w;
}; 

//
// Initialize items according to servermod.
//
void(entity pl) SetFreshItems = {
	local entity oself;
	UpdateVariables();

	oself = self;
	self = pl;

	self.last_returned_flag = -10;
	self.last_fragged_carrier = -10;
	self.flag_since = -10;
	self.last_hurt_carrier = -10;
	self.runes = self.runes - (self.runes & (ITEM_RUNE_MASK));
	self.runes = 0;	// tw50
	self.player_flag = self.player_flag - (self.player_flag & (PF_GOTFLAG));

	if (gamestart && !pregameover) {
		SetItems(IT_AXE, IT_AXE, 100, 0, 0);
		SetAmmo(0, 0, 0, 0);
	} else if (FLAG_STANDBY && !CountDown) {
		SetItems(255 | IT_AXE | IT_ARMOR3, IT_ROCKET_LAUNCHER, 250, 200, 0.80);
		SetAmmo(255, 255, 255, 255);
	} else if (DEATHMATCH == 4) {
		SetItems(255 | IT_AXE | IT_ARMOR3, IT_ROCKET_LAUNCHER, 250, 200, 0.80);	
		SetAmmo(255, 255, 255, 255);
		self.items = self.items | IT_INVULNERABILITY;
		self.invincible_time = 1;
		self.invincible_finished = time + 3;
	} else if (DEATHMATCH == 5) {
		SetItems(255 | IT_AXE | IT_ARMOR3, IT_ROCKET_LAUNCHER, 250, 200, 0.80);	
		SetAmmo(30,80,10,30);
		self.items = self.items | IT_INVULNERABILITY;
		self.invincible_time = 1;
		self.invincible_finished = time + 3;
	} else if (FLAG_CTF) {
		SetItems(IT_SHOTGUN | IT_AXE | IT_GRAPPLE | IT_ARMOR1, IT_SHOTGUN, 100, 50, 0.30);
		SetAmmo(40,0,0,0);
	} else {
		SetItems(IT_SHOTGUN | IT_AXE | IT_GRAPPLE, IT_SHOTGUN, 100, 0, 0);
		SetAmmo(40,0,0,0);
	}
	if ((SET_HOOK == IS_OFF) || !FLAG_HOOK) {
		self.items = self.items - (self.items & IT_GRAPPLE);
	}
	self = oself;
};


//
// Find an intermission to set playerview to.
//
entity() FindIntermission =
{
	local	entity spot;
	local	float cyc;

// look for info_intermission first
	spot = find (world, classname, "info_intermission");
	if (spot)
	{	// pick a random one
		cyc = random() * 4;
		while (cyc > 1)
		{
			spot = find (spot, classname, "info_intermission");
			if (!spot)
				spot = find (spot, classname, "info_intermission");
			cyc = cyc - 1;
		}
		return spot;
	}

// then look for the start position
	spot = find (world, classname, "info_player_start");
	if (spot)
		return spot;
	
	objerror ("FindIntermission: no spot");
};


// check -->


// --- GotoNextMap moved to mapqueue.qc ---


//
// When the player presses attack or jump, change to the next level
//
void() IntermissionThink = {
	if (time < intermission_exittime)
		return;

	if (!self.button0 && !self.button1 && !self.button2)
		return;
	
	GotoNextMap ();
};


/*
void() DoIntermission = {
	local entity pos;
	pos = self;
	WriteByte (MSG_ALL, SVC_INTERMISSION);
	WriteCoord (MSG_ALL, pos.origin_x);
	WriteCoord (MSG_ALL, pos.origin_y);
	WriteCoord (MSG_ALL, pos.origin_z);
	WriteAngle (MSG_ALL, pos.mangle_x);
	WriteAngle (MSG_ALL, pos.mangle_y);
	WriteAngle (MSG_ALL, pos.mangle_z);
	remove(self);
};
*/

//
// Ok, start intermission.
//
void() execute_changelevel =
{
	local entity	pos,e;
	intermission_running = 1;
	
	// enforce a wait time before allowing changelevel
	intermission_exittime = time + 8;
	pos = FindIntermission ();
	WriteByte (MSG_ALL, SVC_INTERMISSION);
	WriteCoord (MSG_ALL, pos.origin_x);
	WriteCoord (MSG_ALL, pos.origin_y);
	WriteCoord (MSG_ALL, pos.origin_z);
	WriteAngle (MSG_ALL, pos.mangle_x);
	WriteAngle (MSG_ALL, pos.mangle_y);
	WriteAngle (MSG_ALL, pos.mangle_z);

	// play intermission music
	WriteByte (MSG_ALL, SVC_CDTRACK);
	WriteByte (MSG_ALL, 3);

	other = find (world, classname, "player");
	while (other != world)
	{
		LogTime(other);		//GSLOG
		other.join_time = time;	//GSLOG

		other.takedamage = DAMAGE_NO;
		other.solid = SOLID_NOT;
		other.movetype = MOVETYPE_NONE;
		other.modelindex = 0;
		other = find (other, classname, "player");
	}	
};


// *obsolete* ??? (kanske "changelevel" också?)
void() changelevel_touch = 
{
	local entity	pos;

	if (other.classname != "player")
		return;

// if "noexit" is set, blow up the player trying to leave
	if (TEAMPLAY & TEAM_CAPTURE_FLAG)
		return;

	if ((cvar("samelevel") == 2) || ((cvar("samelevel") == 3) && !gamestart))
		return; // do nothing

	bprint (PRINT_HIGH, other.netname);
	bprint (PRINT_HIGH," exited the level\n");
	
	nextmap = self.map;

	SUB_UseTargets ();

	self.touch = SUB_Null;

// we can't move people right now, because touch functions are called
// in the middle of C movement code, so set a think time to do it
	self.think = execute_changelevel;
	self.nextthink = time + 0.1;
};

/*QUAKED trigger_changelevel (0.5 0.5 0.5) ? NO_INTERMISSION
When the player touches this, he gets sent to the map listed in the "map" variable.  Unless the NO_INTERMISSION flag is set, the view will go to the info_intermission spot and display stats.
*/
void() trigger_changelevel =
{
	if (gamestart) {
		if (self.map == "e1m1")
			self.message = "E1 Dimension of the Doomed";
		else if (self.map == "e2m1")
			self.message = "E2 The Realm of Black Magic";
		else if (self.map == "e3m1")
			self.message = "E3 The Netherworld";
		else if (self.map == "e4m1")
			self.message = "E4 The Elder World";
		else if (self.map == "end")
			self.message = "The Deathmatch Arenas";
		else
			self.message = "Unknown";
		self.classname = "trigger_voteexit";
		trigger_voteexit();
		return;
	}

	if (!self.map)
		objerror ("chagnelevel trigger doesn't have map");

	InitTrigger ();
	self.touch = changelevel_touch;
};


/*
=============================================================================

				PLAYER GAME EDGE FUNCTIONS

=============================================================================
*/

void() set_suicide_frame;

// called by ClientKill and DeadThink
void() respawn =
{
	// make a copy of the dead body for appearances sake
	CopyToBodyQue (self);
	// respawn		
	PutClientInServer ();
};


/*
============
ClientKill

Player entered the suicide command
============
*/
void() ClientKill =
{
	if (FLAG_DEBUG) {
		self.player_flag = self.player_flag | (PF_KILLMERESTART);
	} else if (gamestart) {
		sprint(self, PRINT_HIGH, "Life just started.\n");
	} else if (FREEZEFLAGS & (FREEZE_MOVEMENT | FREEZE_GRAVITY)) {
		return;	
	} else if (self.suicide_count > 20 && !FLAG_DEBUG) {
		sprint(self, PRINT_HIGH, "You have suicided too much already.\n");
	} else {
		bprint (PRINT_MEDIUM, self.netname);
		bprint (PRINT_MEDIUM, " suicides\n");
		DropRune();
		TeamCaptureDropFlagOfPlayer(self);
		set_suicide_frame ();
		self.modelindex = modelindex_player;
		logfrag (self, self);
		self.frags = self.frags - 2;	// extra penalty
		self.suicide_count = self.suicide_count + 1;
		respawn ();
	}
};

/*
============
SelectSpawnPoint

Returns the entity to spawn at
============
*/
entity() SelectSpawnPoint =
{
	local	entity spot, thing;
	local	float	pcount;

	// testinfo_player_start is only found in regioned levels
	spot = find (world, classname, "testplayerstart");
	if (spot)
		return spot;
		
	//CTF spawns
	if (!self.killed) {
		spot = TeamCaptureSpawn();
 		if (spot != world) 
 			return spot;
	} else if (gamestart && self.killed) {
		lastvotespawn = find(lastvotespawn, classname, "info_vote_destination");
		if (lastvotespawn == world)
			lastvotespawn = find(lastvotespawn, classname, "info_vote_destination");
		return lastvotespawn;
	}

	// choose a info_player_deathmatch point
	lastspawn = find(lastspawn, classname, "info_player_deathmatch");
	if (lastspawn == world)
		lastspawn = find (lastspawn, classname, "info_player_deathmatch");
	if (lastspawn != world)
		return lastspawn;
	
	spot = find (world, classname, "info_player_start");
	if (!spot)
		error ("PutClientInServer: no info_player_start on level");
	
	return spot;
};


void() PlayerDie;

/*
===========
PutClientInServer

called each time a player enters a new level
============
*/
void() PutClientInServer =
{
	local	entity spot;
	local	float x;


	serverflags = 0; // make sure
	
	// --- Set Correct player mode ---
	if (FLAG_STANDBY) {
		if (forceready || CountDown)				// *check*
			self.classname = "ready";
		else {
			if ((self.player_flag & PF_KILLME) != PF_KILLMESWAP)
				self.classname = "notready";
		}
	} else {
		if (IsObserver(self)) 
			self.classname = "observer";
		else 
			self.classname = "player";
	}
	self.takedamage = DAMAGE_AIM;


	// --- *pure* fix for respawing telefrags ---
	if (FLAG_DISABLE_NOSOLID_RESPAWN) 
		self.solid = SOLID_SLIDEBOX;
	else 
		self.solid = SOLID_NOT; 

	// --- Standard parameters ---
	self.health = 100;
	if (self.clientflags & CLIENT_BOT) self.movetype = MOVETYPE_TOSS;
	else self.movetype = MOVETYPE_WALK;

	self.max_health = 100;
	self.flags = FL_CLIENT;
	self.air_finished = 0; // changed in Pure
	self.dmg = 2;   		// initial water damage
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.effects = 0;
	self.invincible_time = 0;
	self.rune_notice_time = 0;
	self.last_hurt_carrier = -10;
	self.forcerespawn = 0;		// Timed force respawn.

	self.attack_finished = time;


	SetFreshItems(self);

	W_SetCurrentAmmo ();

	self.th_pain = player_pain;
	self.th_die = PlayerDie;
	self.deadflag = DEAD_NO;
	SetPlayerSpeed(self);		

	// --- Setup for player models ----
	setmodel (self, "progs/eyes.mdl");
	modelindex_eyes = self.modelindex;
	setmodel (self, "progs/player.mdl");
	modelindex_player = self.modelindex;
	if (FLAG_MULTIWEAPON)
	        set_player_modelindexes ();

	// --- Setup model ---
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.view_ofs = '0 0 22';
	self.velocity = '0 0 0';
	player_stand1 ();

	// --- Get start spot --- *check*
	spot = SelectSpawnPoint ();
	spot = TelefragSelectSpawnPoint(spot);
	if (IsObserver(self)) {
		SetObserver(self);
	} else {
		makevectors(spot.angles);
		spawn_tfog (spot.origin + v_forward*20);
		if (FLAG_DISABLE_RESPAWNKILLFIX)
			spawn_tdeath(spot.origin, self);
	}
	self.origin = spot.origin + '0 0 1';
	self.angles = spot.angles;
	self.fixangle = TRUE;		// turn this way immediately
	
	// ---  grapple stuff ---
	self.on_hook = FALSE;
	self.hook_out = FALSE;

	// Check for ready
	if (FLAG_STANDBY || (CountDown && FLAG_COMPETITION)) 
		CheckReady();

};


/*
=============================================================================

				QUAKED FUNCTIONS

=============================================================================
*/


/*QUAKED info_player_start (1 0 0) (-16 -16 -24) (16 16 24)
The normal starting point for a level.
*/
void() info_player_start =
{
};


/*QUAKED info_player_start2 (1 0 0) (-16 -16 -24) (16 16 24)
Only used on start map for the return point from an episode.
*/
void() info_player_start2 =
{
};

/*QUAKED info_player_deathmatch (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for deathmatch games
*/
void() info_player_deathmatch =
{
	if (DEATHMATCH && FLAG_RUNES)
		StartRuneSpawn();
};

/*QUAKED info_player_coop (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for coop games
*/
void() info_player_coop =
{
};

/*
===============================================================================

RULES

===============================================================================
*/

// NextLevel moved to mapqueue.qc


// ***purectf*** -->
void() EndMatch = {
	pregameover = 1;
	RestoreMaxClients();
	TeamEndScore();
	if (FLAG_COMPETITION)
		GSGameEnd();
	Freeze(FREEZE_PLAYERS);
	if (FLAG_AUTOSPECTALK)
		SetVar(CVARINFO, "sv_spectalk", 1);
	NextLevel ();
};
// ***purectf*** <--



//
// Check if a time or fraglimit has been hit.
//
void() CheckRules =
{
	local entity o;
	local float tmlim;

	if (gameover || pregameover)	// someone else quit the game already
		return;

	if (FREEZEFLAGS & FREEZE_WORLD)			// ***pure*** Paused (v1.51)
		return;		

	if (gamestart) {
		if ((vote_leader != world) && voteexit_time && (time > voteexit_time)) {
			// *check* slå ihop med admin changemap
			pregameover = 1;
			o = spawn();
			nextmap = vote_leader.map;
			o.map = nextmap;
			o.think = execute_changelevel;
			o.nextthink = time + 0.1;
			return;
		}
		return;
	}

	// *optimize*
	o = PLAYER_CHAIN;
	while(o) {
		if (FRAGLIMIT && (o.frags >= FRAGLIMIT))
			EndMatch();
		o = o.clientchain;
	}


// ***pure*** --> New Timelimitcheck

	if (CountDown) {
		if (time >= CountDown) {
			CountDown = 0;
			COUNTDOWN_FUNC();
			if (FLAG_RASOUNDS) 
				soundall("ra/fight.wav");
			TraversePlayers(RemoveCenterprint);
		}
	} else 	if (TIMELIMIT && !FLAG_STANDBY) {
		if (TIMELEFT <= 0)
			EndMatch();
	}

// ***pure*** <-- New Timelimitcheck
};


//============================================================================

void() PlayerDeathThink =
{
	local entity	old_self;
	local float		forward;

	if ((self.flags & FL_ONGROUND))
	{
		forward = vlen (self.velocity);
		forward = forward - 20;
		if (forward <= 0)
			self.velocity = '0 0 0';
		else	
			self.velocity = forward * normalize(self.velocity);
	}

	// wait for all buttons released

	if (!self.forcerespawn || (self.forcerespawn > time)) {
		if (self.deadflag == DEAD_DEAD) {
			if (self.button2 || self.button1 || self.button0)
				return;
			self.deadflag = DEAD_RESPAWNABLE;
			return;
		}
		// wait for any button down
		if (!self.button2 && !self.button1 && !self.button0)
			return;
	}
	self.button0 = 0;
	self.button1 = 0;
	self.button2 = 0;
	respawn();
};


void() PlayerJump =
{
	local vector start, end;

	if (self.flags & FL_WATERJUMP)
		return;
	
	if (self.waterlevel >= 2)
	{
// play swiming sound
		if (self.swim_flag < time)
		{
			self.swim_flag = time + 1;
			if (random() < 0.5)
                                sound (self, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM);
		}

		return;
	}

	if (!(self.flags & FL_ONGROUND))
		return;

	if ( !(self.flags & FL_JUMPRELEASED) )
		return;		// don't pogo stick

	self.flags = self.flags - (self.flags & FL_JUMPRELEASED);	
	self.button2 = 0;

// player jumping sound
	if (!IsObserver(self))	// ***pure***
		sound (self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM);
};


/*
===========
WaterMove

============
*/

void() WaterMove =
{
	//dprint (ftos(self.waterlevel));	debug
	if (self.movetype == MOVETYPE_NOCLIP)
		return;
	if (self.health < 0)
		return;


	if (!self.waterlevel) {
		if (self.flags & FL_INWATER) {	
			// play leave water sound
			sound (self, CHAN_BODY, "misc/outwater.wav", 1, ATTN_NORM);
			self.flags = self.flags - FL_INWATER;
			if (self.air_finished) {
				if (self.air_finished < time)
					sound (self, CHAN_VOICE, "player/gasp2.wav", 1, ATTN_NORM);
				else if (self.air_finished < time + 9)
					sound (self, CHAN_VOICE, "player/gasp1.wav", 1, ATTN_NORM);
				self.air_finished = 0;
			}
		}
		return;
	} else if (self.waterlevel != 3) {
		if (self.air_finished) {
			if (self.air_finished < time)
				sound (self, CHAN_VOICE, "player/gasp2.wav", 1, ATTN_NORM);
			else if (self.air_finished < time + 9)
				sound (self, CHAN_VOICE, "player/gasp1.wav", 1, ATTN_NORM);
			self.air_finished = 0;
		}
	} else {
		if (self.air_finished) {
			if ((self.air_finished < time) && (!(self.runes & ITEM_RUNE6_FLAG))) {
				if (self.pain_finished < time) {
					self.dmg = self.dmg + 2;
					if (self.dmg > 15)
						self.dmg = 10;
					T_Damage (self, world, world, self.dmg);
					self.pain_finished = time + 1;
				}
			}
		} else {
			self.air_finished = time + 12;
		}
	}


	if (self.watertype == CONTENT_LAVA)
	{	// do damage
		if (self.dmgtime < time)
		{
			if (self.radsuit_finished > time)
				self.dmgtime = time + 1;
			else
				self.dmgtime = time + 0.2;		
			T_Damage (self, world, world, 10*self.waterlevel);
		}
	}
	else if (self.watertype == CONTENT_SLIME)
	{	// do damage
		if (self.dmgtime < time && self.radsuit_finished < time)
		{
			self.dmgtime = time + 1;
			T_Damage (self, world, world, 4*self.waterlevel);
		}
	}
	if ( !(self.flags & FL_INWATER) )
	{	

// player enter water sound

		if (self.watertype == CONTENT_LAVA)
			sound (self, CHAN_BODY, "player/inlava.wav", 1, ATTN_NORM);
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_BODY, "player/inh2o.wav", 1, ATTN_NORM);
		if (self.watertype == CONTENT_SLIME)
			sound (self, CHAN_BODY, "player/slimbrn2.wav", 1, ATTN_NORM);

		self.flags = self.flags + FL_INWATER;
		self.dmgtime = 0;
	}	
};

void() CheckWaterJump =
{
	local vector start, end;

// check for a jump-out-of-water
	makevectors (self.angles);
	start = self.origin;
	start_z = start_z + 8; 
	v_forward_z = 0;
	normalize(v_forward);
	end = start + v_forward*24;
	traceline (start, end, TRUE, self);
	if (trace_fraction < 1)
	{	// solid at waist
		start_z = start_z + self.maxs_z - 8;
		end = start + v_forward*24;
		self.movedir = trace_plane_normal * -50;
		traceline (start, end, TRUE, self);
		if (trace_fraction == 1)
		{	// open at eye level
			self.flags = self.flags | FL_WATERJUMP;
			self.velocity_z = 225;
			self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
			self.teleport_time = time + 2;	// safety net
			return;
		}
	}

};


//
// Called every frame before physics are run.
//
void() PlayerPreThink =
{
	local	float	mspeed, aspeed, r, flag, maxv;
	local	float	flashes;
	local entity e;

	// Check for delayed kill.
	if (self.player_flag & PF_KILLME) {
		DropRune();
		TeamCaptureDropFlagOfPlayer(self);
		self.killed = 0;			// Respawn at base
		set_suicide_frame ();
		self.modelindex = 0; // modelindex_player;
		SetPlayerSpeed(self);
		if ((self.player_flag & PF_KILLME) == PF_KILLMESWAP) {
			if (FLAG_COMPETITION && !FLAG_STANDBY) {
				ScoreAddDisconnect(self);
				self.frags = 0;
			}
			if ((self.steam == TEAM_COLOR1))			
				self.steam = TEAM_COLOR2;
			else
				self.steam = TEAM_COLOR1;
			GSPlayerTeamChange(self);

			self.player_flag = self.player_flag | PF_STUFFCOLOR;
			self.lastteam = self.steam;
			StuffAutoTeam(self);
		}
		respawn ();
		self.player_flag = self.player_flag - (self.player_flag & (PF_KILLME));
		self.oldorigin = self.origin;
		return;
	}

	// Pure: Stuff that you don't need every frame. (Done about every 1-2 sec)
	PeriodicCheck();	

	// Check intermission buttons
	if (intermission_running > 0) {
		IntermissionThink ();
		return;			
	}

	// intermission or finale
	if (self.view_ofs == '0 0 0')
		return;		

	makevectors (self.v_angle);		// This IS still used. :)


	// Pure: Check for Pause.
	if (FREEZEFLAGS & FREEZE_GRAVITY) {
		self.velocity = '0 0 0';
		setorigin(self, self.oldorigin);
		return;
	}


	// If player is dead.
	if (self.deadflag >= DEAD_DEAD) {
		PlayerDeathThink ();
		return;
	}


	if (IsObserver(self) || (self.deadflag == DEAD_DYING))
		return;

	// Check for drowning, lava and slime.
	WaterMove ();

	// Pure: Respawntelefrag / standbytelefrag fix: Don't make player solid 
	//       until there is no one near, or you could get stuck.
	if (self.solid == SOLID_NOT) {	
		flag = 0;
		maxv = (vlen(VEC_HULL_MAX) * 1.2);	// player bounding box + 20% margin // *opt*
		e = findradius(self.origin, maxv); 
		while (e) {
			if (((e.classname == "player") || (e.classname == "ready") || (e.classname == "notready")) && (e != self)) { // *opt*
				e.solid = SOLID_NOT;		// *check* nonsolids?
				flag = 1; 
			}
			e = e.chain;
		}
		if (!flag)
			self.solid = SOLID_SLIDEBOX;	// Ok, lets go solid.
	}

	// Check for player jump.
	if (self.button2)
		PlayerJump ();
	else
		self.flags = self.flags | FL_JUMPRELEASED;


	// pure, tw50, rune --> (hack away...)
	if (RUNEREGENTIME < time) {
		if ((self.runes & ITEM_RUNE4_FLAG)) {
			if (self.health < REGMAX) {
				self.health = self.health + REGRATE;
				if (self.health > REGMAX)
					self.health = REGMAX;
				RegenerationSound();
			}
			if ((self.armorvalue < ARMORMAX) && self.armortype) {
				self.armorvalue = self.armorvalue + ARMORRATE;
				if (self.armorvalue > ARMORMAX)
					self.armorvalue = ARMORMAX;
				RegenerationSound();
				
			}
			RUNEREGENTIME = time + 0.5;
		}
	}


	// Change weapon if out of ammo. *optimize* this must be better handled by attack?
	if (self.currentammo == 0) {
		if(time > self.attack_finished && self.weapon != IT_AXE && self.weapon != IT_GRAPPLE) {
			self.weapon = W_BestWeapon ();
			W_SetCurrentAmmo ();
		}
	}

        // Do grapple stuff if I'm on a hook
        if (self.on_hook)
                Service_Grapple ();
};
	
/*
================
CheckPowerups

Check for turning off powerups
================
*/
void() CheckPowerups =
{
	if (self.health <= 0)
		return;

// invisibility
	if (self.invisible_finished)
	{
// sound and screen flash when items starts to run out
		if (self.invisible_sound < time)
		{
			sound (self, CHAN_AUTO, "items/inv3.wav", 0.5, ATTN_IDLE);
			self.invisible_sound = time + ((random() * 3) + 1);
		}

		if (self.invisible_finished < time + 3)
		{
			if (self.invisible_time == 1)
			{
				sprint (self, PRINT_HIGH, "Ring of Shadows magic is fading\n");
				stuffcmd(self, "bf\n");
				sound (self, CHAN_AUTO, "items/inv2.wav", 1, ATTN_NORM);
				self.invisible_time = time + 1;
			}
			
			if (self.invisible_time < time)
			{
				self.invisible_time = time + 1;
				stuffcmd(self, "bf\n");
			}
		}

		if (self.invisible_finished < time)
		{	// just stopped
			self.items = self.items - IT_INVISIBILITY;
			self.invisible_finished = 0;
			self.invisible_time = 0;
		}
		
		// use the eyes
		if (self.modelindex != modelindex_eyes) {
			self.frame = 0;
			self.modelindex = modelindex_eyes;
		}
	}
	else {
		// Check for Multiweapon
		if (FLAG_MULTIWEAPON) 
			set_player_weapon();
		else
			if (self.modelindex != modelindex_player) {
				self.modelindex = modelindex_player;	// don't use eyes
			}
	}

// invincibility
	if (self.invincible_finished)
	{
// sound and screen flash when items starts to run out
		if (self.invincible_finished < time + 3)
		{
			if (self.invincible_time == 1)
			{
				sprint (self, PRINT_HIGH, "Protection is almost burned out\n");
				stuffcmd(self, "bf\n");
				sound (self, CHAN_AUTO, "items/protect2.wav", 1, ATTN_NORM);
				self.invincible_time = time + 1;
			}
			
			if (self.invincible_time < time)
			{
				self.invincible_time = time + 1;
				stuffcmd(self, "bf\n");
			}
		}
		
		if (self.invincible_finished < time)
		{	// just stopped
			self.items = self.items - IT_INVULNERABILITY;
			self.invincible_time = 0;
			self.invincible_finished = 0;
		}
// ZOID, next line isn't needed, EF_DIMLIGHT is handled by
// client.qc:CheckDimLight
//		if (self.invincible_finished > time)
//			self.effects = self.effects | EF_DIMLIGHT;
//		else
//			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
	}

// super damage
	if (self.super_damage_finished)
	{

// sound and screen flash when items starts to run out

		if (self.super_damage_finished < time + 3)
		{
			if (self.super_time == 1)
			{
				if (DEATHMATCH == 4)
					sprint (self, PRINT_HIGH, "OctaPower is wearing off\n");
				else
					sprint (self, PRINT_HIGH, "Quad Damage is wearing off\n");
				stuffcmd(self, "bf\n");
				sound (self, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM);
				self.super_time = time + 1;
			}	  
			
			if (self.super_time < time)
			{
				self.super_time = time + 1;
				stuffcmd(self, "bf\n");
			}
		}

		if (self.super_damage_finished < time)
		{	// just stopped
			if (DEATHMATCH == 4)
			{
				self.ammo_cells = 255;
				self.armorvalue = 1;
				self.armortype = 0.8;
				self.health = 100;
			}
			self.items = self.items - IT_QUAD;
			self.super_damage_finished = 0;
			self.super_time = 0;
		}
// ZOID, next line isn't needed, EF_DIMLIGHT is handled by
// client.qc:CheckDimLight
//		if (self.super_damage_finished > time)
//			self.effects = self.effects | EF_DIMLIGHT;
//		else
//			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
	}	

// suit	
	if (self.radsuit_finished)
	{
		self.air_finished = time + 12;		// don't drown

// sound and screen flash when items starts to run out
		if (self.radsuit_finished < time + 3)
		{
			if (self.rad_time == 1)
			{
				sprint (self, PRINT_HIGH, "Air supply in Biosuit expiring\n");
				stuffcmd(self, "bf\n");
				sound (self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
				self.rad_time = time + 1;
			}
			
			if (self.rad_time < time)
			{
				self.rad_time = time + 1;
				stuffcmd(self, "bf\n");
			}
		}

		if (self.radsuit_finished < time)
		{	// just stopped
			self.items = self.items - IT_SUIT;
			self.rad_time = 0;
			self.radsuit_finished = 0;
		}
	}	

	// Check to see about DIMLIGHT effects
	CheckDimLight();
};


/*
================
PlayerPostThink

Called every frame after physics are run
================
*/
void() PlayerPostThink =
{
	local	float	mspeed, aspeed;
	local	float	r;

	SetPing();

//dprint ("post think\n");
	if (self.view_ofs == '0 0 0')
		return;		// intermission or finale


	if (IsObserver(self)) {
		ObserverThink();
		return;
	}


	if (self.deadflag || (FREEZEFLAGS & FREEZE_WORLD)) {
		ClientImpulses();
		return;
	}


	// check to see if player landed and play landing sound	
	if ((self.jump_flag < -300) && (self.flags & FL_ONGROUND) )
	{
		if (self.watertype == CONTENT_WATER) {
			sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
		} else if (self.jump_flag < -650) {
			T_Damage (self, world, world, 5); 
			sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
			self.deathtype = "falling";
		} else {
			sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);
		}
	}
	self.jump_flag = self.velocity_z;


	CheckSound();		// Check for teamsounds and messages (not used?)
	CheckBot();		// BotCheck *obsolete*

	CheckPowerups ();
	PlayerImpulses();
	W_WeaponFrame ();

};


//
//  Connect things that needs to be a bit delayed.
//

void() connectthink = {
	local entity e;
	e = self;
	self = self.owner;
	remove(e);	

	StartStuffing(self);
};

/*
===========
ClientConnect

called when a player connects to a server
============
*/
void() ClientConnect =
{
	local string tp;
	local entity e;
	UpdateVariables();
	DecodeLevelParms();

	// Delayed
	e = spawn();
	e.nextthink = time + 3;
	e.think = connectthink;
	e.owner = self;
	
	// Broadcast connect.
	bprint (PRINT_HIGH, self.netname);
	bprint (PRINT_HIGH, " entered the game");
// PCP dyna - UserID
//	sneek_CheckUserID(self);
// PCP //
	if (!FLAG_STANDBY) {
		bprint(PRINT_HIGH, " at ");
		PrintCurrentTime2All();
	}
	bprint (PRINT_HIGH, "\n");

	// Print serverinfo to player
/*	sprint(self, PRINT_HIGH, "Server: ");
	tp = infokey(world, "hostname");
	sprint(self, PRINT_HIGH, tp);
	sprint(self, PRINT_HIGH, "\n");
	tp = infokey(world, "admin");
	if (tp != "") {
		sprint(self, PRINT_HIGH, "Admin:  ");
		sprint(self, PRINT_HIGH, tp);
		sprint(self, PRINT_HIGH, "\n");
	}
	sprint(self, PRINT_HIGH, "\n");
// PCP dyna - Version
	sprint(self, PRINT_HIGH, "PureCTF Pro 0.05\n(Type áâïõô for more info.)\n");
// PCP //
	sprint(self, PRINT_HIGH, "Type ÃÏÍÍÁÎÄÓ for help.\n\n");
*/
	// Connect setup	
	CheckInfokey();				// Check Setinfo
	self.join_time = time;			// GSLOG
	self.motd_endtime = time + 5;
	if (FLAG_DEBUG)
		self.motd_endtime = time - 1;
	self.suicide_count = 0;
	self.killed = 0;
	self.runes = 0;				// *check*
	self.player_flag = 0;			// *check*
	// *check* *obsolete*	self.frags = 0;

	// Check if we need to set teams
 	if (parm10 < 0 || self.steam < 0) {
		GSPlayerConnect(self);			// GSLOG
	        if (TEAMPLAY & TEAM_LOCK_COLORS) { // force a stuff cmd in think
	 		self.steam = -1;
			TeamAssign();
			self.player_flag = self.player_flag | PF_STUFFCOLOR;
		}
		if (localinfo("shirtlock", 0))
			setinfo(self, "topcolor", self.steam);
	} else {
		GSPlayer(self);				// GSLOG
	}


	// Place in the global clientchain.
	self.classname = "player";
	UpdateClientChain();

	// a client connecting during an intermission can cause problems.
	if (intermission_running)
		GotoNextMap ();

	LAST_CONNECTED = self;
};


/*
===========
ClientDisconnect

called when a player disconnects from a server
============
*/
void() ClientDisconnect =
{

	local entity e;
	local string tp;
	local float x;

	// let everyone else know
	tp = ftos(self.frags);
	bprint (PRINT_HIGH, self.netname);
	bprint (PRINT_HIGH, " left the game with ");
	bprint (PRINT_HIGH, tp);
	bprint (PRINT_HIGH, " frags");
	if (!FLAG_STANDBY) {
		bprint(PRINT_HIGH, " at ");
		PrintCurrentTime2All();
	}
	bprint(PRINT_HIGH, "\n");

	// Recover his Teamscore
	ScoreAddDisconnect(self);

	LogDisconnect(self);

	sound (self, CHAN_BODY, SOUND_LEAVESERVER, 1, ATTN_NONE);

	DropRune();
	TeamCaptureDropFlagOfPlayer(self);
	set_suicide_frame ();

	self.player_flag = self.player_flag | PF_GHOST;
	self.steam = -1;
	self.frags = 0;
	UpdateClientChain();

	if (FLAG_STANDBY)
		CheckReady();


// ***competition***
	if (!FLAG_DEBUG) {
		if ((TEAMPLAY & TEAM_LOCK_COLORS) && ((TEAM1 == 0) || (TEAM2 == 0)) && FLAG_COMPETITION && !FLAG_STANDBY) {
			bprint(PRINT_HIGH, "One team missing, match stopped.\n");
			EndMatch();
		}
	}
	if (TOTALPLAYERS == 0) {
		EmptyServer();
	} 	

// ***competition***

/* *check* autopauses
	if (PAUSES_AUTO && !FLAG_STANDBY && FLAG_COMPETITION) {
		FreezeAll();
		bprint(PRINT_HIGH, "\n Çáíå ðáõóåä äõå ôï ðìáùåò äéóãïîîåãô!\n");
	}
*/

};

void(entity targ, string logmess, string deathmess) PrintSuicide = {
	bprint(PRINT_MEDIUM, targ.netname);
	bprint(PRINT_MEDIUM, deathmess);
	LogPlayerSuicide(targ, logmess);		//GSLog
};



//
// Called when a a player dies to print deathmessages and other stuff.

void(entity targ, entity attacker, entity inflictor) ClientObituary = {

	// *XXX* EXPERT CTF variable for 
	// flag/flag carrier defense bonus determination
	local	entity head;
	local float flag_radius;
	local float flag_carrier_radius;

        local   float rnum, temp;
	local	string deathstring, deathstring2, s;
	local	string what;				// GSlog

	rnum = random();

	if (targ.classname != "player")	
		return;				// players only please


	// *XXX* EXPERT CTF: 
	// When the flag carrier dies, reset the last_hurt_carrier field in
	// all players on the opposite team from the flag carrier.  The carrier
	// has been killed, so there is no longer a reason to award points for
	// killing off his assailants
	if (targ.player_flag & PF_GOTFLAG) {
		head = find(world, classname, "player");
		while (head != world) {	
			if (!SameTeam(head, targ, world))
			head.last_hurt_carrier = -10;
			head = find(head, classname, "player");
		}
	}

	// Discharges in dmm4+
	if (DEATHMATCH > 3) {
		if (targ.deathtype == "selfwater") {
			bprint (PRINT_MEDIUM, targ.netname);
			bprint (PRINT_MEDIUM," electrocutes himself.\n ");
			targ.frags = targ.frags - 1;
			LogPlayerSuicide(targ, "discharge");
			return;
		}
	}

	// Handle different telefrags

	// Standard telefrag
	if (attacker.classname == "teledeath") {
		bprint (PRINT_MEDIUM,targ.netname);
		bprint (PRINT_MEDIUM," was telefragged by ");
		bprint (PRINT_MEDIUM,attacker.owner.netname);
		bprint (PRINT_MEDIUM,"\n");

		if (SameTeam(attacker.owner, targ, world)) {
			attacker.owner.frags = attacker.owner.frags - 1;
                        LogPlayerTeamKill(targ, attacker.owner, "telefrag");//GSLog
		} else {
			attacker.owner.frags = attacker.owner.frags + 1;
			LogPlayerKill(targ, attacker.owner, "telefrag");//GSLog
		}
		return;
	}

	// You tried to telefrag a player with Pentagram
	if (attacker.classname == "teledeath2") {
		bprint (PRINT_MEDIUM,"Satan's power deflects ");
		bprint (PRINT_MEDIUM,targ.netname);
		bprint (PRINT_MEDIUM,"'s telefrag\n");

		targ.frags = targ.frags - 1;
		logfrag (targ, targ);
		LogPlayerSuicide(targ, "telefrag");	//GSLog	
		return;
	}

	// double 666 telefrag (can happen often in deathmatch 4)
	if (attacker.classname == "teledeath3")  {
		bprint (PRINT_MEDIUM,targ.netname);
		bprint (PRINT_MEDIUM," was telefragged by ");
		bprint (PRINT_MEDIUM,attacker.owner.netname);
		bprint (PRINT_MEDIUM, "'s Satan's power\n");
		targ.frags = targ.frags - 1;
		logfrag (targ, targ);
		return;
		// *check* add logging
	}
	
	// Ok, now comes the general "frag" tests
	if (attacker.classname == "player") {

		// First check for suicide
		if (targ == attacker) {
			logfrag (attacker, attacker);
			attacker.frags = attacker.frags - 1;
			bprint (PRINT_MEDIUM,targ.netname);

			// Did we die of a teamchange?
			if (self.killed == 99) {
				if (TEAMPLAY & TEAM_STATIC_TEAMS)
					bprint (PRINT_MEDIUM, " tried to change teams\n");
				else
					bprint (PRINT_MEDIUM, " changed teams\n");
				LogPlayerSuicide(targ, "teamchange");		//GSLog

			} else if (targ.weapon == IT_LIGHTNING && targ.waterlevel > 1) {
				bprint (PRINT_MEDIUM," discharges into the water.\n");
				LogPlayerSuicide(targ, "discharge");		//GSLog
			} else if (targ.weapon == IT_GRENADE_LAUNCHER) {
				bprint (PRINT_MEDIUM," tries to put the pin back in\n");
				LogPlayerSuicide(targ, "grenade");		//GSLog	
			} else if (rnum) {
				bprint (PRINT_MEDIUM," becomes bored with life\n");
				LogPlayerSuicide(targ, "rocket");			//GSLog
			} else {
				bprint (PRINT_MEDIUM," checks if his weapon is loaded\n");
				LogPlayerSuicide(targ, "rocket");			//GSLog
			}
			return;
		} else {
		// === Ok, someone else killed me. ===
			// *TEAMPLAY*
			// TeamFragPenalty returns true if the attacker gets a frag penalty for
			// killing this target.  It also deducts frags as needed.

			if (!TeamFragPenalty(targ, attacker)) {

 				// the attacker is award the normal one frag.. now we 
 				// determine if he gets any bonuses
				logfrag (attacker, targ);
   				attacker.frags = attacker.frags + 1;
   
				// Maybe we killed a carrier and get a bonus?
 				if ((targ.player_flag & PF_GOTFLAG) && (!SameTeam(targ, attacker, world))) {

					// Save this to get assists 
					attacker.last_fragged_carrier = time;
 
					// *XXX* EXPERT CTF: give player only the normal amount of frags
					// if the carrier has only had the flag for a few seconds, to
					// prevent ppl intentionally allowing enemies to grab the flag,
 					// then immediately fragging them
					//***logbug*** --> Print the bonus frags public, so a logparser may use them.
					if (FLAG_LOGBUG) {
						if (targ.flag_since + TEAM_CAPTURE_CARRIER_FLAG_SINCE_TIMEOUT > time) {
 							sprint(attacker, PRINT_MEDIUM, "Enemy flag carrier killed, no bonus\n");
 						} else {
 				//* obsolete*		attacker.frags = attacker.frags + TEAM_CAPTURE_FRAG_CARRIER_BONUS;
 							sprint(attacker, PRINT_MEDIUM, "Enemy flag carrier killed: ");
 							s = ftos(TEAM_CAPTURE_FRAG_CARRIER_BONUS);
 							sprint(attacker, PRINT_MEDIUM, s);
 							sprint(attacker, PRINT_MEDIUM, " bonus frags\n");
							LogCarrierfrag(attacker, TEAM_CAPTURE_FRAG_CARRIER_BONUS);
						}
 					} else if (targ.flag_since + TEAM_CAPTURE_CARRIER_FLAG_SINCE_TIMEOUT > time) {
						bprint(PRINT_MEDIUM, attacker.netname);
 						bprint(PRINT_MEDIUM, " killed the flag carrier, no bonus\n");
 					} else {
 			//* obsolete*		attacker.frags = attacker.frags + TEAM_CAPTURE_FRAG_CARRIER_BONUS;
						bprint(PRINT_MEDIUM, attacker.netname);
 						bprint(PRINT_MEDIUM, " killed the flag carrier, ");
 						s = ftos(TEAM_CAPTURE_FRAG_CARRIER_BONUS);
 						bprint(PRINT_MEDIUM, s);
 						bprint(PRINT_MEDIUM, " bonus frags\n");
						LogCarrierfrag(attacker, TEAM_CAPTURE_FRAG_CARRIER_BONUS);
					}
//***logbug <--
				} // end carrier kill
			
 				// *XXX* EXPERT CTF
 				// This code checks for all game-critical kills OTHER THAN fragging the enemy
 				// flag carrier, like killing players who are trying to kill your flag carrier
 				// or trying to grab your flag, and hands out bonus frags.
 	
 				// The two variables below track whether special bonus frags have already
 				// been awarded for the attacker or target being near the flag or flag carrier.  
 
 				flag_radius = 0;
 				flag_carrier_radius = 0;
 
 				// get a string for the attacker's team now, for later announcements
 				s = GetCTFTeam(attacker.steam);
 
 				if ((targ.last_hurt_carrier + TEAM_CAPTURE_CARRIER_DANGER_PROTECT_TIMEOUT > time) &&
 				    !(attacker.player_flag & PF_GOTFLAG) ) {
					// Cool, we get a carrierdefend bonus.
					flag_carrier_radius = 1;
					// NOTE: getting CARRIER_DANGER_PROTECT_BONUS precludes getting
					// other kinds of bonuses for defending the flag carrier, since
					// it's worth more points
					bprint(PRINT_MEDIUM, attacker.netname);
					bprint(PRINT_MEDIUM, " defends ");
					bprint(PRINT_MEDIUM, s);
					bprint(PRINT_MEDIUM, "'s flag carrier against an agressive enemy\n");
					LogDefendCarrier(attacker, TEAM_CAPTURE_CARRIER_DANGER_PROTECT_BONUS);
				}
 
 				// *XXX* EXPERT CTF
 				// Bonusus for defending the flag carrier or the flag itself.
 				// Extra frags are awarded if either the attacker or the target are
 				// 1. within 40 feet of a flag carrier on the same team as the attacker
 				// 2. within 40 feet of the attacker's flag
 				// These bonuses are cumulative with respect to defending both the
 				// flag and the flag carrier at the same time, but not cumulative with
 				// respect to both the target and attacker being near the object being defended
 
 				// find flags or flag carriers within a radius of the attacker
 
				head = findradius(attacker.origin, TEAM_CAPTURE_ATTACKER_PROTECT_RADIUS);
  				while (head) {
 					if (head.classname == "player") {
 						if ( (SameTeam(head,attacker, world)) &&
 						     (head.player_flag & PF_GOTFLAG) &&
 						     (head != attacker) && // self defense
 						     (!flag_carrier_radius) ) { 
							// attacker was near his own flag carrier
 							flag_carrier_radius = 1;
 							bprint(PRINT_MEDIUM, attacker.netname);
 							bprint(PRINT_MEDIUM, " defends ");
 							bprint(PRINT_MEDIUM, s);
 							bprint(PRINT_MEDIUM, "'s flag carrier\n");
							LogDefendCarrier(attacker, TEAM_CAPTURE_CARRIER_PROTECT_BONUS);
 						}
 					}
 					if ( (head.classname == "item_flag_team1") ||
 					     (head.classname == "item_flag_team2")) {
 						if (((attacker.steam == TEAM_COLOR1) &&
							(head.classname == "item_flag_team1")) ||
 							((attacker.steam == TEAM_COLOR2) &&
 							(head.classname == "item_flag_team2"))) { 
						// attacker was near his own flag
 							flag_radius = 1; 
							
 							bprint(PRINT_MEDIUM, attacker.netname);
 							bprint(PRINT_MEDIUM, " defends the ");
 							bprint(PRINT_MEDIUM, s);
 							bprint(PRINT_MEDIUM, " flag\n");
							LogDefendFlag(attacker, TEAM_CAPTURE_FLAG_DEFENSE_BONUS);
 						}
 					}
 					head = head.chain;
 				}
 
				// find flags or flag carriers within a radius from the target
				head = findradius(targ.origin, TEAM_CAPTURE_TARGET_PROTECT_RADIUS);
				while (head) {
					if (head.classname == "player") {
						if ( SameTeam(head, attacker, world) &&
						     (head.player_flag & PF_GOTFLAG) &&
						     (head != attacker) &&
						     (!flag_carrier_radius)) { // prevents redundant points awarded
							// target was near attacker's flag carrier
						//* obsolete*	attacker.frags = attacker.frags + 
						//		TEAM_CAPTURE_CARRIER_PROTECT_BONUS;
							flag_carrier_radius = 1;
							bprint(PRINT_MEDIUM, attacker.netname);
							bprint(PRINT_MEDIUM, " defends ");
							bprint(PRINT_MEDIUM, s);
							bprint(PRINT_MEDIUM, "'s flag carrier\n");
							LogDefendCarrier(attacker, TEAM_CAPTURE_CARRIER_PROTECT_BONUS);
 						}
 					}
					if (    ((attacker.steam == TEAM_COLOR1) &&
						 (head.classname == "item_flag_team1")) ||
						((attacker.steam == TEAM_COLOR2) &&
						 (head.classname == "item_flag_team2"))
						&& (!flag_radius)) { // prevents redundant points awarded
						// target was near attacker's flag
					//* obsolete*	attacker.frags = attacker.frags + 
					//		TEAM_CAPTURE_FLAG_DEFENSE_BONUS;
							flag_radius = 1;
						bprint(PRINT_MEDIUM, attacker.netname);
						bprint(PRINT_MEDIUM, " defends the ");
						bprint(PRINT_MEDIUM, s);
						bprint(PRINT_MEDIUM, " flag\n");
						LogDefendFlag(attacker, TEAM_CAPTURE_FLAG_DEFENSE_BONUS);
					}
					head = head.chain;
				} // end find carriers or flags near target
 			}
			// <-- The player got his frag and any bonuses
 			 
 		
			// Oups, killing teammates is not good.	
			TeamDeathPenalty(targ, attacker);


			// Now we're going to find the correct deathmessage for the
			// weapon we got killed with.
			rnum = attacker.weapon;	


			// Pure: if we got killed by a missile, perhaps we got the wrong mess.	
			if (!FLAG_DISABLEMISSILEFIX) {
				if (inflictor.classname == "missile")
					rnum = IT_ROCKET_LAUNCHER;
				else if (inflictor.classname == "grenade")
					rnum = IT_GRENADE_LAUNCHER;
			}


			// OK, lets get that deathmessage.
			// Note for you who like to make your own messages, they
			// Are moved to custom.qc
			// Pure optimize: Added elses, should improve things a bit.			

			if (rnum == IT_ROCKET_LAUNCHER) {
				if (attacker.items & IT_QUAD) { 
					deathstring = dmrl1c; deathstring2 = dmrl2c;
				} else if (targ.health < -40) {
					deathstring = dmrl1b; deathstring2 = dmrl2b;
				} else {
					deathstring = dmrl1a; deathstring2 = dmrl2a;
				}
				what = "rocket";//GSLog
			} else if (rnum == IT_GRENADE_LAUNCHER) {
				if (targ.health < -40) {
					deathstring = dmgl1b; deathstring2 = dmgl2b;
				} else {
					deathstring = dmgl1a; deathstring2 = dmgl2a;
				}
				what = "grenade";//GSLog
			} else  if (rnum == IT_LIGHTNING) {
				if (attacker.waterlevel > 1) {
					deathstring = dmlg1; deathstring2 = dmlg2b;
				} else {
					deathstring = dmlg1; deathstring2 = dmlg2a;
				}
				what = "lightning";//GSLog
			} if (rnum == IT_SUPER_NAILGUN) {
				deathstring = dmsng1; deathstring2 = dmsng2;
				what = "supernailgun";//GSLog
			} if (rnum == IT_SUPER_SHOTGUN) {
				deathstring = dmssg1; deathstring2 = dmssg2;
				what = "supershotgun";//GSLog
			} if (rnum == IT_NAILGUN) {
				deathstring = dmng1; deathstring2 = dmng2;
				what = "nailgun";//GSLog
       			} else  if (rnum == IT_SHOTGUN) {
				deathstring = dmsg1; deathstring2 = dmsg2;
				what = "shotgun";//GSLog
			} else if (rnum == IT_GRAPPLE) {
				temp = random();
				if (temp < 0.5) {
					deathstring = dmhook1a; deathstring2 = dmhook2a;
				} else {
					deathstring = dmhook1b; deathstring2 = dmhook2b;
				}
				what = "hook";	//GSLog
			} else if (rnum == IT_AXE) {
				deathstring = dmaxe1; deathstring2 = dmaxe2;
				what = "axe";	//GSLog
			}
			bprint (PRINT_MEDIUM,targ.netname);
			bprint (PRINT_MEDIUM,deathstring);
			bprint (PRINT_MEDIUM,attacker.netname);
			bprint (PRINT_MEDIUM,deathstring2);
                        LogPlayerKill(targ, attacker, what);		//GSLog
		}
		return;
		// <-- player fragging
	} else {
		// Aaaargh, the world is against me!

		logfrag (targ, targ);
		targ.frags = targ.frags - 1;		// killed self
		rnum = targ.watertype;
		if (rnum == -3) {
			if (random() < 0.5) PrintSuicide(targ, "drowned", " sleeps with the fishes\n");
			else PrintSuicide(targ, "drowned", " sucks it down\n");
		} else if (rnum == -4) {
			if (random() < 0.5) PrintSuicide(targ, "slimed", " gulped a load of slime\n");
			else PrintSuicide(targ, "slimed", " can't exist on slime alone\n");
		} else if (rnum == -5) {
			if (targ.health < -15)
				PrintSuicide(targ, "melted", " burst into flames\n");
			else if (random() < 0.5)
				PrintSuicide(targ, "melted", " turned into hot slag\n");
			else 
				PrintSuicide(targ, "melted", " visits the Volcano God\n");
		} else if (attacker.classname == "explo_box") {
			PrintSuicide(targ, "explosion", " blew up\n");
		} else if (attacker.solid == SOLID_BSP && attacker != world) {
			PrintSuicide(targ, "squished", " was squished\n");
		} else if (targ.deathtype == "falling")	{
			targ.deathtype = "";
			PrintSuicide(targ, "falling", " fell to his death\n");
		} else if (attacker.classname == "trap_shooter" || attacker.classname == "trap_spikeshooter") {
			PrintSuicide(targ, "spiked", " was spiked\n");
		} else if (attacker.classname == "fireball") {
			PrintSuicide(targ, "fireball", " ate a lavaball\n");
		} else if (attacker.classname == "trigger_changelevel") {
			PrintSuicide(targ, "noexit", " tried to leave\n");
		} else {
			PrintSuicide(targ, "died", " died\n");
		}
	}
};
// <-- check
