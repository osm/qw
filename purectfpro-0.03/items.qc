void() W_SetCurrentAmmo;
/* ALL LIGHTS SHOULD BE 0 1 0 IN  ALL OTHER ITEMS SHOULD
BE .8 .3 .4 IN  */


void() SUB_regen =
{
	if (FreezeThink())	// *pure* Pause function (v1.51)
		return;
	self.lastupdate = 0;
	self.think = SUB_Null;

	SetPowerupSolid();		//***pure*** Enable Powerup disabling
	self.model = self.mdl;		// restore original model
	sound (self, CHAN_VOICE, SOUND_ITEM_REGEN, 1, ATTN_NORM);	// play respawn sound
	setorigin (self, self.origin);

};



/*QUAKED noclass (0 0 0) (-8 -8 -8) (8 8 8)
prints a warning message when spawned
*/
void() noclass =
{
	dprint ("noclass spawned at");
	dprint (vtos(self.origin));
	dprint ("\n");
	remove (self);
};




/*
============
PlaceItem

plants the object on the floor
============
*/
void() PlaceItem =
{
	self.mdl = self.model;		// so it can be restored on respawn
	self.flags = FL_ITEM;		// make extra wide

// ***pure***
	SetPowerupSolid();
// ***pure***


	self.movetype = MOVETYPE_TOSS;	
	self.velocity = '0 0 0';
	self.origin_z = self.origin_z + 6;
	if (!droptofloor())
	{
		dprint ("Bonus item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
		return;
	}
};

/*
============
StartItem

Sets the clipping size and plants the object on the floor
============
*/
void() StartItem =
{
	// *check* more random starttime
	self.nextthink = time +  0.2;	// items start after other solids
	self.think = PlaceItem;
};

/*
=========================================================================

HEALTH BOX

=========================================================================
*/
//
// T_Heal: add health to an entity, limiting health to max_health
// "ignore" will ignore max_health limit
//
float (entity e, float healvalue, float ignore) T_Heal =
{
	if (e.health <= 0)
		return 0;
	if ((!ignore) && (e.health >= other.max_health))
		return 0;
	healvalue = ceil(healvalue);

	e.health = e.health + healvalue;
	if ((!ignore) && (e.health >= other.max_health))
		e.health = other.max_health;
	if (FLAG_TW) {
		if (e.health > 300)
			e.health = 300;
	} else {
		if (e.health > 250)
			e.health = 250;
	}
	return 1;
};

/*QUAKED item_health (.3 .3 1) (0 0 0) (32 32 32) rotten megahealth
Health box. Normally gives 25 points.
Rotten box heals 5-10 points,
megahealth will add 100 health, then 
rot you down to your maximum health limit, 
one point per second.
*/

float	H_ROTTEN = 1;
float	H_MEGA = 2;
void() health_touch;
void() item_megahealth_rot;

void() item_health =
{	
	if (FLAG_NOITEMS){
		remove(self);
		return;
	}

	self.touch = health_touch;

	self.AIRG_Flags = AIRG_EXCLUDEENTITY;

	if (self.spawnflags & H_ROTTEN)
	{
		if (!NOSPAWN) precache_model("maps/b_bh10.bsp");
		if (!NOSPAWN) precache_sound("items/r_item1.wav");
		setmodel(self, "maps/b_bh10.bsp");
		self.noise = "items/r_item1.wav";
	}
	else
	if (self.spawnflags & H_MEGA)
	{
		if (!NOSPAWN) precache_model("maps/b_bh100.bsp");
		if (!NOSPAWN) precache_sound("items/r_item2.wav");
		setmodel(self, "maps/b_bh100.bsp");
		self.noise = "items/r_item2.wav";
	}
	else
	{
		if (!NOSPAWN) precache_model("maps/b_bh25.bsp");
		if (!NOSPAWN) precache_sound("items/health1.wav");
		setmodel(self, "maps/b_bh25.bsp");
		self.noise = "items/health1.wav";
	}
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};


void() health_touch =
{
	local	float amount;
	local	string	s;
	local float hamount, htype;
	
	if (DEATHMATCH == 4)
		if (other.invincible_time > 0)
			return;


	if (other.classname != "player")
		return;


	if (self.spawnflags & H_MEGA) { // Megahealth?  Ignore max_health...
		if (other.health >= 250)
			return;
		if (!T_Heal(other, 100, 1))
			return;
		sprint(other, PRINT_LOW, "You receive 100 health\n");
	} else if (self.spawnflags & H_ROTTEN) {
		if (!T_Heal(other, 15, 0))
			return;
		sprint(other, PRINT_LOW, "You receive 15 health\n");
	} else {
		if (!T_Heal(other, 25, 0))
			return;
		sprint(other, PRINT_LOW, "You receive 25 health\n");
	}

	
// health touch sound
	sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);

	stuffcmd(other, "bf\n");
	
	self.model = string_null;
	self.solid = SOLID_NOT;

	// Megahealth = rot down the player's super health
	if (self.spawnflags & H_MEGA)
	{
		other.items = other.items | IT_SUPERHEALTH;
		if (DEATHMATCH != 4) {
			self.nextthink = time + 5;
			self.think = item_megahealth_rot;
		}
		self.owner = other;
	}
	else
	{
		if (DEATHMATCH != 2)		// DEATHMATCH 2 is the silly old rules
		{
			self.nextthink = CalcRespawn(HEALTHRESPAWN);
			self.think = SUB_regen;
		}
	}
	
	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};	

void() item_megahealth_rot =
{
	if (FreezeThink())
		return;
	other = self.owner;
	
//ZOID: player doesn't rot if they have Elder Magic rune
	if (other.health > other.max_health && 
		!(other.runes & ITEM_RUNE4_FLAG)) {
		if (FLAG_TW && (other.health < 201 && (other.runes & ITEM_RUNE7_FLAG)))
			return;
		other.health = other.health - 1;
		self.nextthink = time + 1;
		return;
	}

// it is possible for a player to die and respawn between rots, so don't
// just blindly subtract the flag off
	other.items = other.items - (other.items & IT_SUPERHEALTH);
	
	if (DEATHMATCH == 1 || DEATHMATCH == 3)	// DEATHMATCH 2 is silly old rules
	{
		self.nextthink = CalcRespawn(HEALTHRESPAWN);
		self.think = SUB_regen;
	}
};

/*
===============================================================================

ARMOR

===============================================================================
*/

void() armor_touch;

void() armor_touch =
{
	local	float	type, value, bit;
	
	if (other.health <= 0)
		return;
	if (other.classname != "player")
		return;

	if (DEATHMATCH == 4)
		if (other.invincible_time > 0)
			return;


	if (self.classname == "item_armor1")
	{
		type = 0.3;
		value = 100;
		bit = IT_ARMOR1;
	}
	if (self.classname == "item_armor2")
	{
		type = 0.6;
		value = 150;
		bit = IT_ARMOR2;
	}
	if (self.classname == "item_armorInv")
	{
		type = 0.8;
		value = 200;
		bit = IT_ARMOR3;
	}

	if (FLAG_TW && (other.runes & ITEM_RUNE5_FLAG)) {	// tw50
		type = 0.8;
		bit = IT_ARMOR3;
	}

	if (other.armortype*other.armorvalue >= type*value)
		return;

	if(FLAG_TW && (other.justin > time)) {		// tw50
		other.justin = 0;
		self.attack_finished = time;
	}

		
	other.armortype = type;
	other.armorvalue = value;
	other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + bit;

	self.solid = SOLID_NOT;
	self.model = string_null;
	if (DEATHMATCH == 1 || DEATHMATCH == 3)
		self.nextthink = CalcRespawn(ARMORRESPAWN);
	self.think = SUB_regen;

	sprint(other, PRINT_LOW, "You got armor\n");
// armor touch sound
	sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM);
	stuffcmd(other, "bf\n");
	
	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


/*QUAKED item_armor1 (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() item_armor1 =
{
	if (FLAG_NOITEMS){
		remove(self);
		return;
	}
	self.AIRG_Flags = AIRG_EXCLUDEENTITY;		// tw50
	self.touch = armor_touch;
	if (!NOSPAWN) precache_model ("progs/armor.mdl");
	setmodel (self, "progs/armor.mdl");
	self.skin = 0;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED item_armor2 (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() item_armor2 =
{
	if (FLAG_NOITEMS){
		remove(self);
		return;
	}
	self.AIRG_Flags = AIRG_EXCLUDEENTITY;		// tw50
	self.touch = armor_touch;
	if (!NOSPAWN) precache_model ("progs/armor.mdl");
	setmodel (self, "progs/armor.mdl");
	self.skin = 1;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED item_armorInv (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() item_armorInv =
{
	if (FLAG_NOITEMS){
		remove(self);
		return;
	}
	self.AIRG_Flags = AIRG_EXCLUDEENTITY;		// tw50
	self.touch = armor_touch;
	if (!NOSPAWN) precache_model ("progs/armor.mdl");
	setmodel (self, "progs/armor.mdl");
	self.skin = 2;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*
===============================================================================

WEAPONS

===============================================================================
*/

void() bound_other_ammo =
{
	if (other.ammo_shells > 100)
		other.ammo_shells = 100;
	
	if (FLAG_TW) {			// tw50
		if (other.ammo_nails > 150)
			other.ammo_nails = 150;
		if (other.ammo_rockets > 80)
			other.ammo_rockets = 80;
		if (other.ammo_cells > 60)
			other.ammo_cells = 60;
	} else {
		if (other.ammo_nails > 200)
			other.ammo_nails = 200;
		if (other.ammo_rockets > 100)
			other.ammo_rockets = 100;		
		if (other.ammo_cells > 100)
			other.ammo_cells = 100;		
	}
};


float(float w) RankForWeapon =
{
// tw50 -->
	if (FLAG_TW) {
		if (w == IT_ROCKET_LAUNCHER)
			return 1;
		if (AIRG_SHOWINWEAPONLIST == TRUE && w == IT_AIRGUN )
			return AIRG_WEAPONRANK;
		if (w == IT_NAILGUN)
			return 2;
		if (w == IT_SUPER_NAILGUN)
			return 3;
		if (w == IT_GRENADE_LAUNCHER)
			return 4;
		if (w == IT_SUPER_SHOTGUN)
			return 5;		
		if (w == IT_LIGHTNING)
			return 6;
		return 7;
	} else {
// tw50 <--
		if (w == IT_LIGHTNING)
			return 1;
		if (w == IT_ROCKET_LAUNCHER)
			return 2;
		if (w == IT_SUPER_NAILGUN)
			return 3;
		if (w == IT_GRENADE_LAUNCHER)
			return 4;
		if (w == IT_SUPER_SHOTGUN)
			return 5;
		if (w == IT_NAILGUN)
			return 6;
		return 7;
	}
};

float (float w) WeaponCode =
{
	if (w == IT_SUPER_SHOTGUN)
		return 3;
	if (w == IT_NAILGUN)
		return 4;
	if (w == IT_SUPER_NAILGUN)
		return 5;
	if (w == IT_GRENADE_LAUNCHER)
		return 6;
	if (w == IT_ROCKET_LAUNCHER)
		return 7;
	if (w == IT_LIGHTNING)
		return 8;
	return 1;
};

/*
=============
Deathmatch_Weapon

Deathmatch weapon change rules for picking up a weapon

=============
*/
void(float old, float new) Deathmatch_Weapon =
{
	local float or, nr;

	if (self.weapon == IT_GRAPPLE && self.button0)
		return; // never change if we pulled ourselves to it

// change self.weapon if desired
	or = RankForWeapon (self.weapon);
	nr = RankForWeapon (new);
	if ( nr < or )
		self.weapon = new;
};

/*
=============
weapon_touch
=============
*/
float() W_BestWeapon;

void() weapon_touch =
{
	local	float	hadammo, best, new, old;
	local	entity	stemp;
	local	float	leave;
//McBain: added prevweapon local variable
	local	float	prevweapon;

	// For client weapon_switch
	local   float   w_switch;

	if (!(other.flags & FL_CLIENT))
		return;

// ***comp*** --> Allow no pickups if not regular player
	if (!(other.classname == "player"))
		return;
// ***comp*** <-- 

	if (FLAG_TW) {
		if(other.justin > time) {
			other.justin = 0;
			self.attack_finished = time;
		}
		if ((stof(infokey(other,"w_switch"))) <= 0)
			w_switch = 7;
		else
			w_switch = stof(infokey(other,"w_switch"));
	} else {
		if ((stof(infokey(other,"w_switch"))) == 0)
			w_switch = 8;
		else
			w_switch = stof(infokey(other,"w_switch"));
	}
// if the player was using his best weapon, change up to the new one if better		
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;

	if (DEATHMATCH == 2 || DEATHMATCH == 3 || DEATHMATCH == 5)
		leave = 1;
	else
		leave = 0;
	
	if (self.classname == "weapon_nailgun")
	{
		if (leave && (other.items & IT_NAILGUN) )
			return;
		hadammo = other.ammo_nails;			
		new = IT_NAILGUN;
// *TEAMPLAY*
		if (FLAG_TW)
			other.ammo_cells = other.ammo_cells + 20;
		else
			other.ammo_nails = other.ammo_nails + 30;
	}
	else if (self.classname == "weapon_supernailgun")
	{
		if (leave && (other.items & IT_SUPER_NAILGUN) )
			return;
		hadammo = other.ammo_rockets;			
		new = IT_SUPER_NAILGUN;
// *TEAMPLAY*
		other.ammo_nails = other.ammo_nails + 30;
	}
	else if (self.classname == "weapon_supershotgun")
	{
		if (leave && (other.items & IT_SUPER_SHOTGUN) )
			return;
		hadammo = other.ammo_rockets;			
		new = IT_SUPER_SHOTGUN;
// *TEAMPLAY*
		other.ammo_shells = other.ammo_shells + 5;
	}
	else if (self.classname == "weapon_rocketlauncher")
	{
		if (leave && (other.items & IT_ROCKET_LAUNCHER) )
			return;
		hadammo = other.ammo_rockets;			
		new = IT_ROCKET_LAUNCHER;
// *TEAMPLAY*
		other.ammo_rockets = other.ammo_rockets + 5;
	}
	else if (self.classname == "weapon_grenadelauncher")
	{
		if (leave && (other.items & IT_GRENADE_LAUNCHER) )
			return;
		hadammo = other.ammo_rockets;			
		new = IT_GRENADE_LAUNCHER;
// *TEAMPLAY*
		other.ammo_rockets = other.ammo_rockets + 5;
	}
// tw50 -->
	else if (self.classname == "weapon_airgun")
	  {
		if (leave && (other.items & IT_AIRGUN) )
			return;
		new = IT_AIRGUN;
	}
// tw50 <--

	else if (self.classname == "weapon_lightning")
	{
		if (leave && (other.items & IT_LIGHTNING) )
			return;
		hadammo = other.ammo_rockets;			
		new = IT_LIGHTNING;
		if (FLAG_TW) 
			other.sniper_ammo = other.sniper_ammo;
		else
			other.ammo_cells = other.ammo_cells + 15;
	}
	else
		objerror ("weapon_touch: unknown classname");

	sprint (other, PRINT_LOW, "You got the ");
	sprint (other, PRINT_LOW, self.netname);
	sprint (other, PRINT_LOW, "\n");
// weapon touch sound
	if (FLAG_TW)
		sound (other, CHAN_ITEM, "tw/twgtwp1.wav", 1, ATTN_NORM);
	else
		sound (other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
	stuffcmd(other, "bf\n");

	bound_other_ammo ();

// change to the weapon
	old = other.items;
	other.items = other.items | new;
	
	stemp = self;
	self = other;

	prevweapon = self.weapon;

	if ( WeaponCode(new) <= w_switch ) {
		if (self.flags & FL_INWATER) {
			if (new != IT_LIGHTNING)
				Deathmatch_Weapon (old, new);
		}
		else
			Deathmatch_Weapon (old, new);
	}

	if (self.weapon != prevweapon)
		  self.previous_weapon = prevweapon;

	W_SetCurrentAmmo();

	self = stemp;

	if (leave)
		return;

// remove it in single player, or setup for respawning in DEATHMATCH
	self.model = string_null;
	self.solid = SOLID_NOT;


	if (DEATHMATCH == 1 || DEATHMATCH == 3)
		self.nextthink = CalcRespawn(WEAPONSRESPAWN);
	self.think = SUB_regen;

//***pure***
	self.lastupdate = self.nextthink;
//***pure***

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


/*QUAKED weapon_supershotgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_supershotgun =
{
	if (FLAG_NOITEMS || (DEATHMATCH >= 4)){
		remove(self);
		return;
	}
	if (FLAG_TW) {
		if (!NOSPAWN) precache_model ("progs/twg_shot.mdl");
		setmodel (self, "progs/twg_shot.mdl");
	} else {
		if (!NOSPAWN) precache_model ("progs/g_shot.mdl");
		setmodel (self, "progs/g_shot.mdl");
	}
	self.AIRG_Flags = AIRG_EXCLUDEENTITY;
	self.weapon = IT_SUPER_SHOTGUN;
	self.netname = "Double-barrelled Shotgun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_nailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_nailgun =
{
	if (FLAG_NOITEMS || (DEATHMATCH >= 4)){
		remove(self);
		return;
	}
	self.AIRG_Flags = AIRG_EXCLUDEENTITY;
	if (FLAG_TW) {
		if (!NOSPAWN) precache_model ("progs/twlaser.mdl");
		setmodel (self, "progs/twlaser.mdl");
		self.netname = "Laser Blaster";
	} else {
		if (!NOSPAWN) precache_model ("progs/g_nail.mdl");
		setmodel (self, "progs/g_nail.mdl");
		self.netname = "nailgun";
	}
	self.weapon = IT_NAILGUN;
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_supernailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_supernailgun =
{
	if (FLAG_NOITEMS || (DEATHMATCH >= 4)){
		remove(self);
		return;
	}
	self.AIRG_Flags = AIRG_EXCLUDEENTITY;
	if (!NOSPAWN) precache_model ("progs/g_nail2.mdl");
	setmodel (self, "progs/g_nail2.mdl");
	self.weapon = IT_SUPER_NAILGUN;
	self.netname = "Super Nailgun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_grenadelauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_grenadelauncher =
{
	if (FLAG_NOITEMS || (DEATHMATCH >= 4)){
		remove(self);
		return;
	}
	self.AIRG_Flags = AIRG_EXCLUDEENTITY;
	if (!NOSPAWN) precache_model ("progs/g_rock.mdl");
	setmodel (self, "progs/g_rock.mdl");
	self.weapon = 3;
	self.netname = "Grenade Launcher";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_rocketlauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_rocketlauncher =
{
	if (FLAG_NOITEMS || (DEATHMATCH >= 4)){
		remove(self);
		return;
	}
	self.AIRG_Flags = AIRG_EXCLUDEENTITY;
	if (!NOSPAWN) precache_model ("progs/g_rock2.mdl");
	setmodel (self, "progs/g_rock2.mdl");
	self.weapon = 3;
	self.netname = "Rocket Launcher";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};


/*QUAKED weapon_lightning (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_lightning =
{
	if (FLAG_NOITEMS || (DEATHMATCH >= 4)){
		remove(self);
		return;
	}

	self.AIRG_Flags = AIRG_EXCLUDEENTITY;
	if (FLAG_TW) {
		if (!NOSPAWN) precache_model ("progs/g_snipe1.mdl");
		setmodel (self, "progs/g_snipe1.mdl");
		self.netname = "Sniper Rifle";
	} else {
		if (!NOSPAWN) precache_model ("progs/g_light.mdl");
		setmodel (self, "progs/g_light.mdl");
		self.netname = "Thunderbolt";
	}
	self.weapon = 3;
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

// tw50 -->
void() weapon_airgun =
{
	if (FLAG_NOITEMS || (DEATHMATCH >= 4)){
		remove(self);
		return;
	}
	if (!NOSPAWN) precache_model ("progs/g_light.mdl");
	setmodel (self, "progs/g_light.mdl");
	self.weapon = 3;
	self.netname = "Airgun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};
// tw50 <--

/*
===============================================================================

AMMO

===============================================================================
*/

void() ammo_touch =
{
local entity	stemp;
local float		best;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	if (FLAG_TW) {
		if (other.justin > time) {
			other.justin = 0;
			self.attack_finished = time;
		}
	}
/*	// debug
	if (FLAG_DEBUG) {
		sprint(other, PRINT_HIGH, "pos :");
		local string vt;
		vt = vtos(self.origin);
		sprint(other, PRINT_HIGH, vt);
		sprint(other, PRINT_HIGH, "\n");
	}
*/

// if the player was using his best weapon, change up to the new one if better		
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;


// shotgun
	if (self.weapon == 1)
	{
		if (other.ammo_shells >= 100)
			return;
		other.ammo_shells = other.ammo_shells + self.aflag;
	}

// spikes
	if (self.weapon == 2)
	{
		if (other.ammo_nails >= 200)
			return;
		if (FLAG_TW && (other.ammo_nails >= 150))
			return;
		other.ammo_nails = other.ammo_nails + self.aflag;
	}

//	rockets
	if (self.weapon == 3)
	{
		if (other.ammo_rockets >= 100)
			return;
		if (FLAG_TW && (other.ammo_rockets >= 80))
			return;
		other.ammo_rockets = other.ammo_rockets + self.aflag;
	}

//	cells
	if (self.weapon == 4)
	{
		if (other.ammo_cells >= 100)
			return;
		if (FLAG_TW && (other.ammo_cells >= 60))
			return;
		other.ammo_cells = other.ammo_cells + self.aflag;
	}

	bound_other_ammo ();
	
	sprint (other, PRINT_LOW, "You got the ");
	sprint (other, PRINT_LOW, self.netname);
	sprint (other, PRINT_LOW, "\n");
// ammo touch sound
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd(other, "bf\n");

// change to a better weapon if appropriate

	if ( other.weapon == best )
	{
		stemp = self;
		self = other;
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo ();
		self = stemp;
	}

// if changed current ammo, update it
	WithSelf(other, W_SetCurrentAmmo);

// remove it in single player, or setup for respawning in DEATHMATCH
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (DEATHMATCH == 1 || DEATHMATCH == 3)
		self.nextthink = CalcRespawn(AMMORESPAWN);
	if (!FLAG_CTF && ((DEATHMATCH == 3) || (DEATHMATCH == 5)))	//*check*
		self.nextthink = CalcRespawn(AMMORESPAWN / 2);
	self.think = SUB_regen;

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};




float WEAPON_BIG2 = 1;

/*QUAKED item_shells (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_shells =
{
	if (FLAG_NOITEMS || (DEATHMATCH == 4)){
		remove(self);
		return;
	}
	self.touch = ammo_touch;
	self.AIRG_Flags = AIRG_EXCLUDEENTITY;


	if (self.spawnflags & WEAPON_BIG2)
	{
		if (!NOSPAWN) precache_model ("maps/b_shell1.bsp");
		setmodel (self, "maps/b_shell1.bsp");
		self.aflag = 40;
	}
	else
	{
		if (!NOSPAWN) precache_model ("maps/b_shell0.bsp");
		setmodel (self, "maps/b_shell0.bsp");
		self.aflag = 20;
	}
	self.weapon = 1;
	self.netname = "shells";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

/*QUAKED item_spikes (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_spikes =
{
	if (FLAG_NOITEMS || (DEATHMATCH == 4)){
		remove(self);
		return;
	}
	self.touch = ammo_touch;
	self.AIRG_Flags = AIRG_EXCLUDEENTITY;

	if (self.spawnflags & WEAPON_BIG2)
	{
		if (!NOSPAWN) precache_model ("maps/b_nail1.bsp");
		setmodel (self, "maps/b_nail1.bsp");
		self.aflag = 50;
	}
	else
	{
		if (!NOSPAWN) precache_model ("maps/b_nail0.bsp");
		setmodel (self, "maps/b_nail0.bsp");
		self.aflag = 25;
	}
	self.weapon = 2;
	self.netname = "nails";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

/*QUAKED item_rockets (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_rockets =
{
	if (FLAG_NOITEMS || (DEATHMATCH == 4)){
		remove(self);
		return;
	}
	self.touch = ammo_touch;
	self.AIRG_Flags = AIRG_EXCLUDEENTITY;

	if (self.spawnflags & WEAPON_BIG2)
	{
		if (!NOSPAWN) precache_model ("maps/b_rock1.bsp");
		setmodel (self, "maps/b_rock1.bsp");
		self.aflag = 10;
	}
	else
	{
		if (!NOSPAWN) precache_model ("maps/b_rock0.bsp");
		setmodel (self, "maps/b_rock0.bsp");
		self.aflag = 5;
	}
	self.weapon = 3;
	self.netname = "rockets";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};


/*QUAKED item_cells (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_cells =
{
	if (FLAG_NOITEMS || (DEATHMATCH == 4)){
		remove(self);
		return;
	}
	self.touch = ammo_touch;
	self.AIRG_Flags = AIRG_EXCLUDEENTITY;

	if (self.spawnflags & WEAPON_BIG2)
	{
		if (!NOSPAWN) precache_model ("maps/b_batt1.bsp");
		setmodel (self, "maps/b_batt1.bsp");
		if (FLAG_TW)
			self.aflag = 10;
		else
			self.aflag = 12;
	}
	else
	{
		if (!NOSPAWN) precache_model ("maps/b_batt0.bsp");
		setmodel (self, "maps/b_batt0.bsp");
		self.aflag = 6;
	}
	self.weapon = 4;
	self.netname = "cells";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};


/*QUAKED item_weapon (0 .5 .8) (0 0 0) (32 32 32) shotgun rocket spikes big
DO NOT USE THIS!!!! IT WILL BE REMOVED!
*/

float WEAPON_SHOTGUN = 1;
float WEAPON_ROCKET = 2;
float WEAPON_SPIKES = 4;
float WEAPON_BIG = 8;
void() item_weapon =
{
	// *check* vad הr detta?
	if (FLAG_NOITEMS){
		remove(self);
		return;
	}

	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_SHOTGUN)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			if (!NOSPAWN) precache_model ("maps/b_shell1.bsp");
			setmodel (self, "maps/b_shell1.bsp");
			self.aflag = 40;
		}
		else
		{
			if (!NOSPAWN) precache_model ("maps/b_shell0.bsp");
			setmodel (self, "maps/b_shell0.bsp");
			self.aflag = 20;
		}
		self.weapon = 1;
		self.netname = "shells";
	}

	if (self.spawnflags & WEAPON_SPIKES)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			if (!NOSPAWN) precache_model ("maps/b_nail1.bsp");
			setmodel (self, "maps/b_nail1.bsp");
			self.aflag = 40;
		}
		else
		{
			if (!NOSPAWN) precache_model ("maps/b_nail0.bsp");
			setmodel (self, "maps/b_nail0.bsp");
			self.aflag = 20;
		}
		self.weapon = 2;
		self.netname = "spikes";
	}

	if (self.spawnflags & WEAPON_ROCKET)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			if (!NOSPAWN) precache_model ("maps/b_rock1.bsp");
			setmodel (self, "maps/b_rock1.bsp");
			self.aflag = 10;
		}
		else
		{
			if (!NOSPAWN) precache_model ("maps/b_rock0.bsp");
			setmodel (self, "maps/b_rock0.bsp");
			self.aflag = 5;
		}
		self.weapon = 3;
		self.netname = "rockets";
	}
	
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};


/*
===============================================================================

KEYS

===============================================================================
*/

void() key_touch =
{
local entity	stemp;
local float		best;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;
	if (other.items & self.items)
		return;

	sprint (other, PRINT_LOW, "You got the ");
	sprint (other, PRINT_LOW, self.netname);
	sprint (other,PRINT_LOW, "\n");

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd(other, "bf\n");
	other.items = other.items | self.items;

	self.solid = SOLID_NOT;
	self.model = string_null;

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


void() key_setsounds =
{
	if (world.worldtype == 0)
	{
		if (!NOSPAWN) precache_sound ("misc/medkey.wav");
		self.noise = "misc/medkey.wav";
	}
	if (world.worldtype == 1)
	{
		if (!NOSPAWN) precache_sound ("misc/runekey.wav");
		self.noise = "misc/runekey.wav";
	}
	if (world.worldtype == 2)
	{
		if (!NOSPAWN) precache_sound2 ("misc/basekey.wav");
		self.noise = "misc/basekey.wav";
	}
};

/*QUAKED item_key1 (0 .5 .8) (-16 -16 -24) (16 16 32)
SILVER key
In order for keys to work
you MUST set your maps
worldtype to one of the
following:
0: medieval
1: metal
2: base
*/

void() item_key1 =
{
	if (FLAG_NOITEMS){
		remove(self);
		return;
	}
	if (world.worldtype == 0)
	{
		if (!NOSPAWN) precache_model ("progs/w_s_key.mdl");
		setmodel (self, "progs/w_s_key.mdl");
		self.netname = "silver key";
	}
	else if (world.worldtype == 1)
	{
		if (!NOSPAWN) precache_model ("progs/m_s_key.mdl");
		setmodel (self, "progs/m_s_key.mdl");
		self.netname = "silver runekey";
	}
	else if (world.worldtype == 2)
	{
		if (!NOSPAWN) precache_model2 ("progs/b_s_key.mdl");
		setmodel (self, "progs/b_s_key.mdl");
		self.netname = "silver keycard";
	}
	key_setsounds();
	self.touch = key_touch;
	self.items = IT_KEY1;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*QUAKED item_key2 (0 .5 .8) (-16 -16 -24) (16 16 32)
GOLD key
In order for keys to work
you MUST set your maps
worldtype to one of the
following:
0: medieval
1: metal
2: base
*/

void() item_key2 =
{
	if (FLAG_NOITEMS){
		remove(self);
		return;
	}
	if (world.worldtype == 0)
	{
		if (!NOSPAWN) precache_model ("progs/w_g_key.mdl");
		setmodel (self, "progs/w_g_key.mdl");
		self.netname = "gold key";
	}
	if (world.worldtype == 1)
	{
		if (!NOSPAWN) precache_model ("progs/m_g_key.mdl");
		setmodel (self, "progs/m_g_key.mdl");
		self.netname = "gold runekey";
	}
	if (world.worldtype == 2)
	{
		if (!NOSPAWN) precache_model2 ("progs/b_g_key.mdl");
		setmodel (self, "progs/b_g_key.mdl");
		self.netname = "gold keycard";
	}
	key_setsounds();
	self.touch = key_touch;
	self.items = IT_KEY2;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};



/*
===============================================================================

END OF LEVEL RUNES

===============================================================================
*/

void() sigil_touch =
{
local entity	stemp;
local float		best;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	centerprint (other, "You got the rune!");

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd(other, "bf\n");
	self.solid = SOLID_NOT;
	self.model = string_null;
	serverflags = serverflags | (self.spawnflags & 15);
	self.classname = "";		// so rune doors won't find it
	
	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


/*QUAKED item_sigil (0 .5 .8) (-16 -16 -24) (16 16 32) E1 E2 E3 E4
End of level sigil, pick up to end episode and return to jrstart.
*/

void() item_sigil =
{
	if (FLAG_NOITEMS){
		remove(self);
		return;
	}

	if (!self.spawnflags)
		objerror ("no spawnflags");

// ***pure*** --> fix for ctf 
	if (TEAMPLAY & TEAM_CAPTURE_FLAG)
		return;
// ***pure***

	if (!NOSPAWN) precache_sound ("misc/runekey.wav");
	self.noise = "misc/runekey.wav";

	if (self.spawnflags & 1)
	{
		if (!NOSPAWN) precache_model ("progs/end1.mdl");
		setmodel (self, "progs/end1.mdl");
	}
	if (self.spawnflags & 2)
	{
		if (!NOSPAWN) precache_model2 ("progs/end2.mdl");
		setmodel (self, "progs/end2.mdl");
	}
	if (self.spawnflags & 4)
	{
		if (!NOSPAWN) precache_model2 ("progs/end3.mdl");
		setmodel (self, "progs/end3.mdl");
	}
	if (self.spawnflags & 8)
	{
		if (!NOSPAWN) precache_model2 ("progs/end4.mdl");
		setmodel (self, "progs/end4.mdl");
	}
	
	self.touch = sigil_touch;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*
===============================================================================

POWERUPS

===============================================================================
*/

void() powerup_touch;


void() powerup_touch =
{
local entity	stemp;
local float		best;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	if (FLAG_TW) {
		if(other.justin > time) {
			other.justin = 0;
			self.attack_finished = time;
		}
	}

	sprint (other, PRINT_LOW, "You got the ");
	sprint (other,PRINT_LOW,  self.netname);
	sprint (other,PRINT_LOW, "\n");

	self.mdl = self.model;

//***pure*** --> v1.51 Custom Powerup respawntimes	

	if (self.classname == "item_artifact_invulnerability") 
		self.nextthink = CalcRespawn(VAR_PENTARESPAWN);			
	else if (self.classname == "item_artifact_invisibility")
		self.nextthink = CalcRespawn(VAR_RINGRESPAWN);
	else if (self.classname == "item_artifact_super_damage")
		self.nextthink = CalcRespawn(VAR_QUADRESPAWN);
	else
		self.nextthink = CalcRespawn(60);		// *check*
//***pure*** <--
	self.think = SUB_regen;

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);

	stuffcmd(other, "bf\n");
	self.solid = SOLID_NOT;
	other.items = other.items | self.items;
	self.model = string_null;

// do the apropriate action
	if (self.classname == "item_artifact_envirosuit")
	{
		other.rad_time = 1;
		other.radsuit_finished = time + 30;
	}
	
	if (self.classname == "item_artifact_invulnerability")
	{
		other.invincible_time = 1;
		other.invincible_finished = time + 30;
	}
	
	if (self.classname == "item_artifact_invisibility")
	{
		other.invisible_time = 1;
		if (FLAG_TW)
			other.invisible_finished = time + 45;		// tw50
		else
			other.invisible_finished = time + 30;
	}

	if (self.classname == "item_artifact_super_damage")
	{
		if (DEATHMATCH == 4)
		{
			other.armortype = 0;
			other.armorvalue = 0 * 0.01;
			other.ammo_cells = 0;
		}

		other.super_time = 1;
		other.super_damage_finished = time + 30;
	}	

	JamWawTimer();


	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets

};



/*QUAKED item_artifact_invulnerability (0 .5 .8) (-16 -16 -24) (16 16 32)
Player is invulnerable for 30 seconds
*/
void() item_artifact_invulnerability =
{
	if (FLAG_NOITEMS){
		remove(self);
		return;
	}

	self.touch = powerup_touch;
	self.AIRG_Flags = AIRG_EXCLUDEENTITY;

/* *check* moved to worldspawn
	if (!NOSPAWN) precache_model ("progs/invulner.mdl");
	if (!NOSPAWN) precache_sound ("items/protect.wav");
	if (!NOSPAWN) precache_sound ("items/protect2.wav");
	if (!NOSPAWN) precache_sound ("items/protect3.wav");
	if (!NOSPAWN) precache_model ("progs/invulner.mdl");
*/
	self.noise = "items/protect.wav";
	setmodel (self, "progs/invulner.mdl");
	self.netname = "Pentagram of Protection";
	self.items = IT_INVULNERABILITY;
	// ***glglow*** --> 
	if (FLAG_GL_ITEMS)
		self.effects = self.effects | EF_RED | EF_DIMLIGHT;
	// ***glglow*** <--
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*QUAKED item_artifact_envirosuit (0 .5 .8) (-16 -16 -24) (16 16 32)
Player takes no damage from water or slime for 30 seconds
*/
void() item_artifact_envirosuit =
{
	if (FLAG_NOITEMS){
		remove(self);
		return;
	}

	self.touch = powerup_touch;
	self.AIRG_Flags = AIRG_EXCLUDEENTITY;

/* *check* moved to worldspawn
	if (!NOSPAWN) precache_model ("progs/suit.mdl");
	if (!NOSPAWN) precache_sound ("items/suit.wav");
	if (!NOSPAWN) precache_sound ("items/suit2.wav");
*/
	self.noise = "items/suit.wav";
	setmodel (self, "progs/suit.mdl");
	self.netname = "Biosuit";
	self.items = IT_SUIT;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};


/*QUAKED item_artifact_invisibility (0 .5 .8) (-16 -16 -24) (16 16 32)
Player is invisible for 30 seconds
*/
void() item_artifact_invisibility =
{
	if (FLAG_NOITEMS){
		remove(self);
		return;
	}

	self.touch = powerup_touch;
	self.AIRG_Flags = AIRG_EXCLUDEENTITY;

	if (!NOSPAWN) precache_model ("progs/invisibl.mdl");
	if (!NOSPAWN) precache_sound ("items/inv1.wav");
	if (!NOSPAWN) precache_sound ("items/inv2.wav");
	if (!NOSPAWN) precache_sound ("items/inv3.wav");
	self.noise = "items/inv1.wav";
	setmodel (self, "progs/invisibl.mdl");
	self.netname = "Ring of Shadows";
	self.items = IT_INVISIBILITY;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};


/*QUAKED item_artifact_super_damage (0 .5 .8) (-16 -16 -24) (16 16 32)
The next attack from the player will do 4x damage
*/
void() item_artifact_super_damage =
{

	if (FLAG_NOITEMS){
		remove(self);
		return;
	}

	self.touch = powerup_touch;
	self.AIRG_Flags = AIRG_EXCLUDEENTITY;

	if (!NOSPAWN) precache_model ("progs/quaddama.mdl");
	if (!NOSPAWN) precache_sound ("items/damage.wav");
	if (!NOSPAWN) precache_sound ("items/damage2.wav");
	if (!NOSPAWN) precache_sound ("items/damage3.wav");
	self.noise = "items/damage.wav";
	setmodel (self, "progs/quaddama.mdl");
	if (DEATHMATCH == 4)
		self.netname = "OctaPower";	
	else
		self.netname = "Quad Damage";
	self.items = IT_QUAD;
	// ***glglow*** --> 
	if (FLAG_GL_ITEMS)
		self.effects = self.effects | EF_BLUE | EF_DIMLIGHT;
	// ***glglow*** <--
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};



/*
===============================================================================

PLAYER BACKPACKS

===============================================================================
*/

void() BackpackTouch =
{
	local string	s;
	local	float	best, old, new;
	local		entity	stemp;
	local	float	acount;
	local   float   b_switch;
	
	if (DEATHMATCH == 4)
		if (other.invincible_time > 0)
			return;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;
	//don't let self pick it up for a sec
	if ((other == self.owner) && ( (self.nextthink - time) > 118 ) )
		return;
	if (FLAG_TW) {
		if(other.justin > time)
		{
			other.justin = 0;
			self.attack_finished = time;
		}
	}

	acount = 0;
	sprint (other, PRINT_LOW, "You get ");

	if (DEATHMATCH == 4)
	{       
		other.health = other.health + 10;
		sprint (other, PRINT_LOW, "10 additional health\n");
		if ((other.health > 250) && (other.health < 300))
			sound (other, CHAN_ITEM, "items/protect3.wav", 1, ATTN_NORM);
		else
			sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
		stuffcmd(other, "bf\n");
		remove(self);

		if (other.health >299)
		{               
			if (other.invincible_time != 1)
			{                       
				other.invincible_time = 1;
				other.invincible_finished = time + 30;
				other.items = other.items | IT_INVULNERABILITY;
				
				other.super_time = 1;
				other.super_damage_finished = time + 30;
				other.items = other.items | IT_QUAD;

				other.ammo_cells = 0;		
		
	
				sound (other, CHAN_VOICE, "boss1/sight1.wav", 1, ATTN_NORM);
				stuffcmd(other, "bf\n");               
				bprint (PRINT_HIGH, other.netname);
				bprint (PRINT_HIGH, " attains bonus powers!!!\n");
			}
		}
		self = other;
		return;
	}


	if (self.items)
		if ((other.items & self.items) == 0)
		{
			acount = 1;
			sprint (other, PRINT_LOW, "the ");
			sprint (other, PRINT_LOW, self.netname);
		}
		
// if the player was using his best weapon, change up to the new one if better		
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;

// change weapons
	other.ammo_shells = other.ammo_shells + self.ammo_shells;
	other.ammo_nails = other.ammo_nails + self.ammo_nails;
	other.ammo_rockets = other.ammo_rockets + self.ammo_rockets;
	other.ammo_cells = other.ammo_cells + self.ammo_cells;

	new = self.items;
	if (!new)
		new = other.weapon;
	old = other.items;
	other.items = other.items | new;
	
	bound_other_ammo ();

	if (self.ammo_shells)
	{
		if (acount)
			sprint(other, PRINT_LOW, ", ");
		acount = 1;
		s = ftos(self.ammo_shells);
		sprint (other, PRINT_LOW, s);
		sprint (other, PRINT_LOW, " shells");
	}
	if (self.ammo_nails)
	{
		if (acount)
			sprint(other, PRINT_LOW, ", ");
		acount = 1;
		s = ftos(self.ammo_nails);
		sprint (other, PRINT_LOW, s);
		sprint (other, PRINT_LOW, " nails");
	}
	if (self.ammo_rockets)
	{
		if (acount)
			sprint(other, PRINT_LOW, ", ");
		acount = 1;
		s = ftos(self.ammo_rockets);
		sprint (other, PRINT_LOW, s);
		sprint (other, PRINT_LOW, " rockets");
	}
	if (self.ammo_cells)
	{
		if (acount)
			sprint(other, PRINT_LOW, ", ");
		acount = 1;
		s = ftos(self.ammo_cells);
		sprint (other, PRINT_LOW, s);
		sprint (other,PRINT_LOW, " cells");
	}

	if ( (DEATHMATCH == 3 || DEATHMATCH == 5) & ( (WeaponCode(new)==6) || (WeaponCode(new)==7) ) & (other.ammo_rockets < 5) )
		other.ammo_rockets = 5;

	
	sprint (other, PRINT_LOW, "\n");
// backpack touch sound
	if (FLAG_TW) 
		sound (other, CHAN_ITEM, "tw/twboump.wav", 1, ATTN_NORM);
	else
		sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd(other, "bf\n");

// remove the backpack, change self to the player
	remove(self);
		self = other;

// change to the weapon
	if (!FLAG_TW) {
		if ( WeaponCode(new) <= b_switch ) {
			if (self.flags & FL_INWATER) {
				if (new != IT_LIGHTNING)
					Deathmatch_Weapon (old, new);
			} else
				Deathmatch_Weapon (old, new);
		}
	}
	
	W_SetCurrentAmmo ();
};

/*
===============
DropBackpack
===============
*/
void() DropBackpack =
{
	local entity	item;


	if (!(self.ammo_shells + self.ammo_nails + self.ammo_rockets + self.ammo_cells))
		return;	// nothing in it

	item = spawn();
	item.origin = self.origin - '0 0 24';
	
	item.items = 0; // none by default

//ZOID--axe doesn't go into backpack
	if (self.weapon != IT_AXE)
		item.items = self.weapon;

	if (item.items == IT_SHOTGUN)
		item.netname = "Shotgun";
	else if (item.items == IT_SUPER_SHOTGUN)
		item.netname = "Double-barrelled Shotgun";
	else if (item.items == IT_NAILGUN) {
		if (FLAG_TW)
			item.netname = "Laser Blaster";
		else
			item.netname = "Nailgun";
	} else if (item.items == IT_SUPER_NAILGUN)
		item.netname = "Super Nailgun";
	else if (item.items == IT_GRENADE_LAUNCHER)
		item.netname = "Grenade Launcher";
	else if (item.items == IT_ROCKET_LAUNCHER)
		item.netname = "Rocket Launcher";
	else if (item.items == IT_LIGHTNING) {
		if (FLAG_TW)
			item.netname = "Sniper Rifle";
		else
			item.netname = "Thunderbolt";
	} else
		item.netname = "";

	item.ammo_shells = self.ammo_shells;
	item.ammo_nails = self.ammo_nails;
	item.ammo_rockets = self.ammo_rockets;
	item.ammo_cells = self.ammo_cells;

	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);
	
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	if (FLAG_TW)
		setmodel (item, "progs/tw_back.mdl");
	else
		setmodel (item, "progs/backpack.mdl");
	setsize (item, '-16 -16 0', '16 16 56');
	item.touch = BackpackTouch;
	
	item.nextthink = time + 120;	// remove after 2 minutes
	item.think = SUB_Remove;
};

/*----------------------------------------------------------------------
  The Rune Game modes

  Rune 1 - Earth Magic
	  resistance
  Rune 2 - Black Magic
	  strength
  Rune 3 - Hell Magic
	  haste
  Rune 4 - Elder Magic
	  regeneration

ThunderWalker Runes:
Rune 5: Living Armor
Rune 6: Protection
Rune 7: Vampire
Rune 8: Cloaking

 ----------------------------------------------------------------------*/

float counter;

entity() SelectRuneSpawnPoint =
{
	local float x;
	local entity chainlink;

	if (FLAG_ARENA) {
		if (FLAG_COMPETITION) {
			runespawn = find(runespawn, classname, "player");
			if (!runespawn) 
				runespawn = find(runespawn, classname, "player");
			return runespawn;
		}
		runespawn = ArenaSpawn();
		return runespawn;
	}

	runespawn = find(runespawn, classname, "info_player_deathmatch");

	if (!runespawn) {
		runespawn = find(world, classname, "info_player_deathmatch");
		if (!runespawn) 
			objerror ("No spawns for runes.\n");
	}

	return runespawn;
};


void() RuneTouch =
{
	local string	s;
	local	float	best;
	local		entity	stemp;
	
// PCP HrZ - Don't pick up the rune if we just dropped it.
	if (other == self.owner)
		return;
// PCP //
	if (other.health <= 0)
		return;
	if (other.classname != "player")
		return;
	if (CountDown)
		return;

	if (FLAG_TW) {
		if ((other == self.owner) && ((self.nextthink - time) > 117))
			return;
		if(other.justin > time) {
			other.justin = 0;
			self.attack_finished = time;
		}		
	}

	if (other.runes & ITEM_RUNE_MASK) {
		// Tossrune
		if (FLAG_TOSSRUNE && !FLAG_TW) 
			PrintStatusbar(other, "You have a rune! Use \"tossrune\" to drop!",0);
		else
			PrintStatusbar(other, "You already have a rune.",0);
		return; // one per customer
	}
		
	other.runes = other.runes | self.runes;

	// notification of rune, no nofity in team mode
	if (self.runes & ITEM_RUNE1_FLAG) {
		if (TEAMPLAY == 0) {
			bprint(PRINT_LOW, other.netname);
			bprint(PRINT_LOW, " got the rune of Åבעפט Íבחיד!\n");
		}
		PrintStatusbar(other, "Åבעפט Íבחיד!    Òוףיףפבמדו",1);
	}
	if (self.runes & ITEM_RUNE2_FLAG) {
		if (TEAMPLAY == 0) {
			bprint(PRINT_LOW, other.netname);
			bprint(PRINT_LOW, " got the rune of Âלבדכ Íבחיד!\n");
		}
		PrintStatusbar(other, "Âלבדכ Íבחיד!    Óפעומחפט",1);
	}
	if (self.runes & ITEM_RUNE3_FLAG) {
		if (TEAMPLAY == 0) {
			bprint(PRINT_LOW, other.netname);
			bprint(PRINT_LOW, " got the rune of Èולל Íבחיד!\n");
		}
		PrintStatusbar(other, "Èולל Íבחיד!    Èבףפו",1);
//***runes*** --> Disable new haste if not Pure
		SetPlayerSpeed(other);
//***runes*** <--
	}
	if (self.runes & ITEM_RUNE4_FLAG) {
		if (TEAMPLAY == 0) {
			bprint(PRINT_LOW, other.netname);
			bprint(PRINT_LOW, " got the rune of Åלהוע Íבחיד!\n");
		}
		PrintStatusbar(other, "Åלהוע Íבחיד!    Òוחומועבפיןמ",1);
		RUNEREGENTIME = 0;		// Pure optimization
		RUNEARMORTIME = 0;		// Pure optimization
	}

// tw50 -->
	if (FLAG_TW) {
		if (self.runes & ITEM_RUNE5_FLAG) {
       			if (TEAMPLAY == 0) {
				bprint(PRINT_LOW, other.netname);
				bprint(PRINT_LOW, " got the rune of Ìיצימח Áעםןע\n");
		        }
			centerprint(other, " Ìיצימח Áעםןע ");
			RUNEARMORTIME = 0;		// Pure optimization
		}
		if (self.runes & ITEM_RUNE6_FLAG) {
			if (TEAMPLAY == 0) {
				bprint(PRINT_LOW, other.netname);
            			bprint(PRINT_LOW, " got the rune of Ðעןפודפיןמ\n");
			}
			centerprint(other, " Ðעןפודפיןמ");
		}
		if (self.runes & ITEM_RUNE7_FLAG) {
        		if (TEAMPLAY == 0) {
            			bprint(PRINT_LOW, other.netname);
            			bprint(PRINT_LOW, " got the rune of Öבםניעו\n");
        		}
        		centerprint(other, " Öבםניעו");
		}
		if (self.runes & ITEM_RUNE8_FLAG) {
			if (TEAMPLAY == 0) {
				bprint(PRINT_LOW, other.netname);
				bprint(PRINT_LOW, " got the rune of Ãלןבכימח\n");
			}
			centerprint(other, " Ãלןבכימח");
		}


		if (self.runes & ITEM_RUNE8_FLAG)
			sound (self, CHAN_BODY, "tw/twcloak.wav", 1, ATTN_NORM);
		else
			sound (other, CHAN_ITEM, "tw/twpower.wav", 1, ATTN_NORM);

// tw50 <--
	} else {	
		// backpack touch sound
		sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
		stuffcmd(other, "bf\n");	
	}
	remove(self);
};


void() RuneRespawn =
{
	local entity oself;

//***pure*** --> Pause function v1.51
	if (FreezeThink())
		return;
//***pure*** <--

	oself = self;

	// choose random starting points
	self = SelectRuneSpawnPoint();
	Do_DropRune(oself.runes);		// tw50
	remove(oself);
};

void (float flag) Do_DropRune = 			// tw50
{
	local entity	item;

	item = spawn();
	item.classname = "item_rune";

	item.origin = self.origin - '0 0 24';
	
	item.runes = flag;

	item.velocity_z = 400;
// Arena -->
	if (FLAG_ARENA) {
		item.velocity_x = 0;
		item.velocity_y = 0;
	} else {
		item.velocity_x = -500 + (random() * 1000);
		item.velocity_y = -500 + (random() * 1000);
	}
// Arena <--
	
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
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
	} else if (FLAG_TW) {
		if (flag & ITEM_RUNE5_FLAG)
			setmodel (item, "progs/rarmor1.mdl");
		else if (flag & ITEM_RUNE6_FLAG)
			setmodel (item, "progs/protect2.mdl");
		else if (flag & ITEM_RUNE7_FLAG)
			setmodel (item, "progs/vampire2.mdl");
		else if (flag & ITEM_RUNE8_FLAG)
			setmodel (item, "progs/cloak.mdl");
	}
	setsize (item, '-16 -16 0', '16 16 56');
	item.touch = RuneTouch;

	// if no one touches it in two minutes,
	// respawn it somewhere else, so inaccessible ones will come 'back' 
		
	item.nextthink = time + 120;

	item.think = RuneRespawn;
};

/*
===============
Droprune
self is player
===============
*/
void() DropRune =
{
	if (FLAG_ARENA)
		return;

// tw50 -->
	if (self.runes & ITEM_RUNE1_FLAG)
		Do_DropRune(ITEM_RUNE1_FLAG);
	if (self.runes & ITEM_RUNE2_FLAG)
		Do_DropRune(ITEM_RUNE2_FLAG);
	if (self.runes & ITEM_RUNE3_FLAG)
		Do_DropRune(ITEM_RUNE3_FLAG);
	if (self.runes & ITEM_RUNE4_FLAG)
		Do_DropRune(ITEM_RUNE4_FLAG);
	if (FLAG_TW) {
		if (self.runes & ITEM_RUNE5_FLAG)	
			Do_DropRune(ITEM_RUNE5_FLAG);
		if (self.runes & ITEM_RUNE6_FLAG)
			Do_DropRune(ITEM_RUNE6_FLAG);
		if (self.runes & ITEM_RUNE7_FLAG)
			Do_DropRune(ITEM_RUNE7_FLAG);
		if (self.runes & ITEM_RUNE8_FLAG)
			Do_DropRune(ITEM_RUNE8_FLAG);
	}
	self.runes = self.runes - (self.runes & (ITEM_RUNE_MASK));
// tw50 <--
};

/*
================
SpawnRunes
spawn all the runes
self is the entity that was created for us, we remove it
================
*/
void() SpawnRunes = {
	local entity e;
	local float i;

	remove(self);
	
	// Remove all runes from world.
	e = find(world, classname, "item_rune");
	while(e) {
		remove(e);
		e = find(world, classname, "item_rune");
	}
	e = PLAYER_CHAIN;
	while (e) {
		e.runes = e.runes - (e.runes & (ITEM_RUNE_MASK));
		e = e.clientchain;
	}


	// Check for Runes off
	if ((SET_RUNES == IS_OFF) || !FLAG_RUNES) 	
        	return;				

	// choose random starting points
	i = random() * 10;
	while (i > 0) {
		self = SelectRuneSpawnPoint();
		i = i - 1;
	}

	// Spawn all runes
	self = SelectRuneSpawnPoint();
	Do_DropRune(ITEM_RUNE1_FLAG);
	self = SelectRuneSpawnPoint();
	Do_DropRune(ITEM_RUNE2_FLAG);
	self = SelectRuneSpawnPoint();
	Do_DropRune(ITEM_RUNE3_FLAG);
	self = SelectRuneSpawnPoint();
	Do_DropRune(ITEM_RUNE4_FLAG);
	self = SelectRuneSpawnPoint();
	if (FLAG_TW) {
		Do_DropRune(ITEM_RUNE5_FLAG);
		self = SelectRuneSpawnPoint();
		Do_DropRune(ITEM_RUNE6_FLAG);
		self = SelectRuneSpawnPoint();
		Do_DropRune(ITEM_RUNE7_FLAG);
		self = SelectRuneSpawnPoint();
		Do_DropRune(ITEM_RUNE8_FLAG);
	}
};

void() RespawnAllRunes = {
	local entity e;
	e=spawn();
	e.nextthink = time + 1;
	e.think=SpawnRunes;
};


void() StartRuneSpawn =
{
	local entity rspawn;

	if (runespawned || gamestart)
		return;

	runespawned = 1;

	if (!NOSPAWN) precache_model ("progs/end1.mdl");
	if (!NOSPAWN) precache_model ("progs/end2.mdl");
	if (!NOSPAWN) precache_model ("progs/end3.mdl");
	if (!NOSPAWN) precache_model ("progs/end4.mdl");
	if (!NOSPAWN) precache_model ("progs/m_s_key.mdl");
	if (!NOSPAWN) precache_model ("progs/m_g_key.mdl");

	if (!NOSPAWN) precache_sound("rune/rune1.wav");
	if (!NOSPAWN) precache_sound("rune/rune2.wav");
	if (!NOSPAWN) precache_sound("rune/rune22.wav"); // special rune and quad combo
	if (!NOSPAWN) precache_sound("rune/rune3.wav");
	if (!NOSPAWN) precache_sound("rune/rune4.wav");

	// spawn the runes
	RespawnAllRunes();
};
// *check*
