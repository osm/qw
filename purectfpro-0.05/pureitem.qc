// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterström 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************

// =================
//     CONSTANTS
// =================

// =================
//     VARIABLES
// =================
float RUNEREGENTIME;			// Time for next rune reg.
float RUNEARMORTIME;			// Time for next rune reg.

// =================
//       RUNES
// =================

// PCP *HrZ*
void () RuneSetOwner =
{
	self.owner = self;
	self.nextthink = time + 120; /* if no one touches it in two minutes, respawn it somewhere else, so inaccessible ones will come 'back' */
        self.think = RuneRespawn;
};
// PCP //

void (float flag) Do_TossRune = 
{
	local entity    item;

	item = spawn();
 	item.classname = "item_rune";
        
	item.runes = flag;
// PCP *HrZ* - Origin should be from self *exactly*
//	setorigin(item, self.origin + '0 0 76');
	setorigin(item, self.origin);
// PCP //
	item.velocity = aim(self, 1000);
// PCP *HrZ* - Runes now get tossed a little differently, added this to make it feel little bit more
// like the old style.
//	item.velocity = item.velocity * 300;
	item.velocity = v_forward*300 + v_up*200;
// PCP //
         
        item.flags = FL_ITEM;
        item.solid = SOLID_TRIGGER;
// PCP *HrZ* - Change movetype from toss to bounce (like grenades)
//	item.movetype = MOVETYPE_TOSS;
	item.movetype = MOVETYPE_BOUNCE;
// PCP //
	if (flag & ITEM_RUNE1_FLAG) {
		setmodel (item, "progs/end1.mdl");
		item.netname = "Resistance";
	} else if (flag & ITEM_RUNE2_FLAG) {
		setmodel (item, "progs/end2.mdl");
		item.netname = "Strength";
	} else if (flag & ITEM_RUNE3_FLAG) {
		setmodel (item, "progs/end3.mdl");
		item.netname = "Haste";
	} else if (flag & ITEM_RUNE4_FLAG) {
		setmodel (item, "progs/end4.mdl");
		item.netname = "Regeneration";
	}
         setsize (item, '-16 -16 0', '16 16 56');
         item.touch = RuneTouch;
// PCP *HrZ* - Since runes now get dropped from origin exactly, self will pick them up
// again right away unless we add a timer.         
//	item.nextthink = time + 120; /* if no one touches it in two minutes,
//					respawn it somewhere else, so inaccessible ones will come 'back' */
//	item.think = RuneRespawn;
//	The code above has been moved to function RuneSetOwner

	item.owner = self;
	item.nextthink = time + 0.5;
	item.think = RuneSetOwner;
// PCP //
};


float(float normal) CalcRespawn = {

	// *check* min is not used yet
	local float x, y;
	x = (TOTALPLAYERS / MAXCLIENTS); 
	y = (FULLRESPAWNFACTOR - RESPAWNFACTOR);
  	x = x * y;
	x = x + RESPAWNFACTOR;
	x = (normal / x);

	if (RANDOMRESPAWN) {
		y = ((RANDOMRESPAWN / 100 * ((random() * 2 ) - 1)) + 1);
		if (y > 2) y = 2;
		else if (y < 0.1) y = 0.1;
		x = x * y;
	}
	x = x + time;
	return x;
};

/*
=========
RuneRotHealthThink

Rot the health you got after dropping the Regeneration rune;
=========
*/
void() RuneRotHealthThink = {
	other = self.owner;

	if ((other.health <= 100) || 
	    (other.runes & ITEM_RUNE4_FLAG) ||
	    (other.items & IT_SUPERHEALTH))
	{
		remove(self);
		return;
	}

	other.health = other.health - 1;
	self.nextthink = time + 1;
};

/*
===============
Tossrune
self is player
===============
*/
void() TossRune = 
{
	local entity e;
	local float spd;

	if (!FLAG_TOSSRUNE || IsObserver(self))
		return;

	if (self.runes & ITEM_RUNE1_FLAG)
		Do_TossRune(ITEM_RUNE1_FLAG);
	if (self.runes & ITEM_RUNE2_FLAG)
	       	Do_TossRune(ITEM_RUNE2_FLAG);
        if (self.runes & ITEM_RUNE3_FLAG) 
                Do_TossRune(ITEM_RUNE3_FLAG);
        if (self.runes & ITEM_RUNE4_FLAG) {
		// Start Rot health after Reg
                Do_TossRune(ITEM_RUNE4_FLAG);
		e = spawn();
		e.nextthink = time + 5;
		e.think = RuneRotHealthThink;
		e.owner = self;
	}
	self.runes = self.runes - (self.runes & (ITEM_RUNE_MASK));
	SetPlayerSpeed(self);		// ***pure*** Reset normal speed after haste
};


// =================
//     TOSSFLAG
// =================

void(entity flg) TeamTossFlag =
{
	local entity item, f, oself;
	local entity p;

	p = flg.owner;

	bprint(PRINT_HIGH, p.netname);
	if ((p.steam == TEAM_COLOR1))
		bprint(PRINT_HIGH, " ôïóóåä the ÂÌÕÅ flag!\n"); // blue
	else
		bprint(PRINT_HIGH, " ôïóóåä the ÒÅÄ flag!\n"); // red

	LogFlagdrop(p);

	p.effects = p.effects - (p.effects & (EF_FLAG1 | EF_FLAG2));

	flg.origin = p.origin + '0 0 76';
	flg.cnt = FLAG_TOSSED;

	flg.velocity = aim(p, 1000);
	flg.velocity = flg.velocity * 300;


	flg.flags = FL_ITEM;
	flg.solid = SOLID_TRIGGER;
	flg.movetype = MOVETYPE_TOSS;
	setmodel(flg, flg.mdl);
	setsize(flg, '-16 -16 0', '16 16 74');
	// return it after so long
	flg.super_time = time + 2; // 2 sec until the carrier can pick it up again
};

void() TossFlag =
{
	local string kn;
	local entity e;

	if (!FLAG_TOSSFLAG) {
		sprint(self, PRINT_HIGH, "Flag tossing not enabled!\n");
		return;
	}


	if ((self.steam == TEAM_COLOR1)) 
		kn = "item_flag_team2";
	else
		kn = "item_flag_team1";
	e = find(world, classname, kn);
	if (e != world)
		TeamTossFlag(e);
};



// =================
//   POWERUP DROPS
// =================



void() q_touch =
{
local entity    stemp;
local float     best;
local string 	s;
	local float oldtime;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	self.mdl = self.model;

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd(other, "bf\n");
	self.solid = SOLID_NOT;
	other.items = other.items | IT_QUAD;
	self.model = string_null;
		if (DEATHMATCH == 4)
		{
			other.armortype = 0;
			other.armorvalue = 0 * 0.01;
			other.ammo_cells = 0;
		}



// do the apropriate action
	other.super_time = 1;

	oldtime = other.super_damage_finished;

	other.super_damage_finished = self.cnt;

	s=ftos(rint(other.super_damage_finished - time));

	bprint (PRINT_LOW, other.netname);
	if (DEATHMATCH == 4)
		bprint (PRINT_LOW, " recovered an OctaPower with ");
	else 
		bprint (PRINT_LOW, " recovered a Quad with ");
	bprint (PRINT_LOW, s);
	bprint (PRINT_LOW, " seconds remaining!\n");

	if (oldtime > other.super_damage_finished)
		other.super_damage_finished = oldtime;



	activator = other;
	SUB_UseTargets();                               // fire all targets / killtargets
};


void(float timeleft) DropQuad =
{
	local entity    item;

	item = spawn();
// PCP *HrZ* - Origin exactly.
//	item.origin = self.origin - '0 0 24';
	item.origin = self.origin;
// PCP //	
	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);
	
	item.flags = FL_ITEM;
	item.items = IT_QUAD;
	item.netname = "Quad Damage";
	item.solid = SOLID_TRIGGER;
// PCP *HrZ* - Bounce instead of toss.
//	item.movetype = MOVETYPE_TOSS;
	item.movetype = MOVETYPE_BOUNCE;
// PCP //
	item.noise = "items/damage.wav";
	setmodel (item, "progs/quaddama.mdl");
	setsize (item, '-16 -16 -24', '16 16 32');
	item.cnt = time + timeleft;
	item.touch = q_touch;
	item.nextthink = time + timeleft;    // remove it with the time left on it
	item.think = SUB_Remove;
};


void() r_touch;

void() r_touch =
{
local entity    stemp;
local float     best;
local string 	s;
local float oldtime;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	self.mdl = self.model;

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd(other, "bf\n");
	self.solid = SOLID_NOT;
	other.items = other.items | IT_INVISIBILITY;
	self.model = string_null;

// do the apropriate action
	other.invisible_time = 1;
	other.invisible_finished = self.cnt;

	oldtime = other.invisible_finished;

	s=ftos(rint(other.invisible_finished - time));
	bprint (PRINT_LOW, other.netname);
	bprint (PRINT_LOW, " recovered a Ring with ");
	bprint (PRINT_LOW, s);
	bprint (PRINT_LOW, " seconds remaining!\n");

	if (oldtime > other.invisible_finished)
		other.invisible_finished = oldtime;

      	activator = other;
	SUB_UseTargets();                               // fire all targets / killtargets
};


void(float timeleft) DropRing =
{
	local entity    item;

	item = spawn();
	item.origin = self.origin - '0 0 24';
	
	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);
	
	item.flags = FL_ITEM;
	item.items = IT_INVISIBILITY;
	item.netname = "Ring of Shadows";
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	item.noise = "items/inv1.wav";
	setmodel (item, "progs/invisibl.mdl");
	setsize (item, '-16 -16 -24', '16 16 32');
	item.cnt = time + timeleft;
	item.touch = r_touch;
	item.nextthink = time + timeleft;    // remove after 30 seconds
	item.think = SUB_Remove;
};


void() CheckDropItem =
{
	local	string	s;	
	if ((stof(infokey(world,"dq"))) != 0)
	{
		if (self.super_damage_finished > 0)
		{
			DropQuad (self.super_damage_finished - time);
			bprint (PRINT_LOW, self.netname);
			if (DEATHMATCH == 4)
				bprint (PRINT_LOW, " lost an OctaPower with ");
			else
				bprint (PRINT_LOW, " lost a quad with ");
			s = ftos(rint(self.super_damage_finished - time));
			bprint (PRINT_LOW, s);
			bprint (PRINT_LOW, " seconds remaining\n");
		}
	}

	if ((stof(infokey(world,"dr"))) != 0)
	{
		if (self.invisible_finished > 0)
		{
			bprint (PRINT_LOW, self.netname);
			bprint (PRINT_LOW, " lost a ring with ");
			s = ftos(rint(self.invisible_finished - time));
			bprint (PRINT_LOW, s);
			bprint (PRINT_LOW, " seconds remaining\n");
			DropRing (self.invisible_finished - time);
		}
	}
};


// =================
//  POWERUP DISABLE
// =================


void() SetPowerupSolid = {
	if (((self.classname == "item_artifact_super_damage") && (VAR_DISABLEPOWERUPS & BIT_NOQUAD)) ||
	    ((self.classname == "item_artifact_invulnerability") && (VAR_DISABLEPOWERUPS & BIT_NOPENTA)) ||
	    ((self.classname == "item_artifact_invisibility") && (VAR_DISABLEPOWERUPS & BIT_NORING))) {
		self.solid = SOLID_NOT;
		if (self.model != string_null) {
			self.mdl = self.model;
			self.model = string_null;
		}
	} else {
		self.solid = SOLID_TRIGGER;
		self.model = self.mdl;
	}
};

void() FixPowerups = {
	local entity oldself;

	oldself = self;	

	self = find(world, classname, "item_artifact_invulnerability");
	while(self) {
		SetPowerupSolid();
		self = find(self, classname, "item_artifact_invulnerability");
	}
	self = find(world, classname, "item_artifact_super_damage");
	while(self) {
		SetPowerupSolid();
		self = find(self, classname, "item_artifact_super_damage");
	}
	self = find(world, classname, "item_artifact_invisibility");
	while(self) {
		SetPowerupSolid();
		self = find(self, classname, "item_artifact_invisibility");
	}
	self = oldself;
};


void(entity own, entity item, float vel) TossItem = {
	item.owner = own;
	makevectors(own.v_angle);
	setorigin(item, own.origin + '0 0 16');
	item.velocity = aim(own, 1000);
	item.velocity = item.velocity * vel;
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_BOUNCE;
};

// *check*
