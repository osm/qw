/*
*/


void () player_hook1; // prototype from player.qc
void () player_hook3; // prototype from player.qc

void () player_harpoon1; // prototype from player.qc
void () player_harpoon3; // prototype from player.qc

void (entity targ, entity inflictor, entity attacker, float damage) T_Damage;
void () player_run;
void(entity bomb, entity attacker, float rad, entity ignore) T_RadiusDamage;
void(vector org, float damage) SpawnBlood;

entity	whereigo;


// called by worldspawn
void() W_Precache =
{
        precache_sound ("hknight/hit.wav");  // flamethrower
	precache_sound ("weapons/r_exp3.wav");	// new rocket explosion
	precache_sound ("weapons/rocket1i.wav");	// spike gun
	precache_sound ("weapons/sgun1.wav");
	precache_sound ("weapons/guncock.wav");	// player shotgun
	precache_sound ("weapons/ric1.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric2.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric3.wav");	// ricochet (used in c code)
	precache_sound ("weapons/spike2.wav");	// super spikes
	precache_sound ("weapons/tink1.wav");	// spikes tink (used in c code)
	precache_sound ("weapons/grenade.wav");	// grenade launcher
	precache_sound ("weapons/bounce.wav");		// grenade bounce
	precache_sound ("weapons/shotgn2.wav");	// super shotgun

	// ZOID:
	// normally the weapon models are precached in the individual item
	// creation routines.  But since we've added impulse 21 we can drop
	// weapons at any time.  Must precache all weapon models.
	precache_model ("progs/g_shot.mdl");
	precache_model ("progs/g_nail.mdl");
	precache_model ("progs/g_nail2.mdl");
	precache_model ("progs/g_rock.mdl");
	precache_model ("progs/g_rock2.mdl");
	precache_model ("progs/g_light.mdl");

// tw50 -->
	if (FLAG_AIRFIST) {
		precache_sound ("weapons/agfire.wav");	// Air gun fire
		precache_sound ("weapons/agfail.wav");	// Air gun failed fire
		precache_sound ("weapons/agwater.wav");	// Air gun under water shot
	}
};

float() crandom =
{
	return 2*(random() - 0.5);
};


/*
================
W_FireAxe
================
*/
void() W_FireAxe =
{
	local	vector	source;
	local	vector	org;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*64, FALSE, self);
	if (trace_fraction == 1.0)
		return;
	
	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = 1;
		SpawnBlood (org, 20);
		if (DEATHMATCH > 3)
			T_Damage (trace_ent, self, self, 75);
		else
			T_Damage (trace_ent, self, self, 20);
	}
	else
	{	// hit wall
        sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);

		WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
		WriteByte (MSG_MULTICAST, TE_GUNSHOT);
		WriteByte (MSG_MULTICAST, 3);
		WriteCoord (MSG_MULTICAST, org_x);
		WriteCoord (MSG_MULTICAST, org_y);
		WriteCoord (MSG_MULTICAST, org_z);
		multicast (org, MULTICAST_PVS);
	}
};


//============================================================================


vector() wall_velocity =
{
	local vector	vel;
	
	vel = normalize (self.velocity);
	vel = normalize(vel + v_up*(random()- 0.5) + v_right*(random()- 0.5));
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;
	
	return vel;
};


/*
================
SpawnMeatSpray
================
*/
void(vector org, vector vel) SpawnMeatSpray =
{
	local	entity missile;
	local	vector	org;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;

	makevectors (self.angles);

	missile.velocity = vel;
	missile.velocity_z = missile.velocity_z + 250 + 50*random();

	missile.avelocity = '3000 1000 2000';
	
// set missile duration
	missile.nextthink = time + 1;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/zom_gib.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, org);
};

/*
================
SpawnBlood
================
*/
void(vector org, float damage) SpawnBlood =
{
	WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
	WriteByte (MSG_MULTICAST, TE_BLOOD);
	WriteByte (MSG_MULTICAST, 1);
	WriteCoord (MSG_MULTICAST, org_x);
	WriteCoord (MSG_MULTICAST, org_y);
	WriteCoord (MSG_MULTICAST, org_z);
	multicast (org, MULTICAST_PVS);
};

/*
================
spawn_touchblood
================
*/
void(float damage) spawn_touchblood =
{
	local vector	vel;

	vel = wall_velocity () * 0.2;
	SpawnBlood (self.origin + vel*0.01, damage);
};


/*
==============================================================================

MULTI-DAMAGE

Collects multiple small damages into a single damage

==============================================================================
*/

entity	multi_ent;
float	multi_damage;

vector	blood_org;
float	blood_count;

vector	puff_org;
float	puff_count;

void() ClearMultiDamage =
{
	multi_ent = world;
	multi_damage = 0;
	blood_count = 0;
	puff_count = 0;
};

void() ApplyMultiDamage =
{
	if (!multi_ent)
		return;
	T_Damage (multi_ent, self, self, multi_damage);
};

void(entity hit, float damage) AddMultiDamage =
{
	if (!hit)
		return;
	
	if (hit != multi_ent)
	{
		ApplyMultiDamage ();
		multi_damage = damage;
		multi_ent = hit;
	}
	else
		multi_damage = multi_damage + damage;
};

void() Multi_Finish =
{
	if (puff_count)
	{
		WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
		WriteByte (MSG_MULTICAST, TE_GUNSHOT);
		WriteByte (MSG_MULTICAST, puff_count);
		WriteCoord (MSG_MULTICAST, puff_org_x);
		WriteCoord (MSG_MULTICAST, puff_org_y);
		WriteCoord (MSG_MULTICAST, puff_org_z);
		multicast (puff_org, MULTICAST_PVS);
	}

	if (blood_count)
	{
		WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
		WriteByte (MSG_MULTICAST, TE_BLOOD);
		WriteByte (MSG_MULTICAST, blood_count);
		WriteCoord (MSG_MULTICAST, blood_org_x);
		WriteCoord (MSG_MULTICAST, blood_org_y);
		WriteCoord (MSG_MULTICAST, blood_org_z);
		multicast (puff_org, MULTICAST_PVS);
	}
};

/*
==============================================================================

BULLETS

==============================================================================
*/

/*
================
TraceAttack
================
*/
void(float damage, vector dir) TraceAttack =
{
	local	vector	vel, org;
	
	vel = normalize(dir + v_up*crandom() + v_right*crandom());
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	org = trace_endpos - dir*4;

	if (trace_ent.takedamage)
	{
		blood_count = blood_count + 1;
		blood_org = org;
		AddMultiDamage (trace_ent, damage);
	}
	else
	{
 		puff_count = puff_count + 1;
	}
};

/*
================
FireBullets

Used by shotgun, super shotgun, and enemy soldier firing
Go to the trouble of combining multiple pellets into a single damage call.
================
*/
void(float shotcount, vector dir, vector spread) FireBullets =
{
	local	vector direction;
	local	vector	src;
	
	makevectors(self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;

	ClearMultiDamage ();
 
 	traceline (src, src + dir*2048, FALSE, self);
 	puff_org = trace_endpos - dir*4;
 
	while (shotcount > 0)
	{
 		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;

		traceline (src, src + direction*2048, FALSE, self);
		if (trace_fraction != 1.0)
			TraceAttack (4, direction);

		shotcount = shotcount - 1;
	}
	ApplyMultiDamage ();
	Multi_Finish ();
};

/*
================
W_FireShotgun
================
*/
void() W_FireShotgun =
{
	local vector dir;

	if (FLAG_TW)
		sound (self, CHAN_WEAPON, "tw/tw_shot.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);	

	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);
	if (!FLAG_STANDBY && (DEATHMATCH != 4))
		self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	dir = aim (self, 100000);
	FireBullets (6, dir, '0.04 0.04 0');
};


/*
================
W_FireSuperShotgun
================
*/
void() W_FireSuperShotgun =
{
	local vector dir;

	if (self.currentammo == 1)
	{
		W_FireShotgun ();
		return;
	}
	if (FLAG_TW)
		sound (self ,CHAN_WEAPON, "tw/tw_shot2.wav", 1, ATTN_NORM);
	else
		sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);	

	msg_entity = self;
	WriteByte (MSG_ONE, SVC_BIGKICK);
	if (!FLAG_STANDBY && (DEATHMATCH != 4))
		self.currentammo = self.ammo_shells = self.ammo_shells - 2;
	dir = aim (self, 100000);
	FireBullets (14, dir, '0.14 0.08 0');
};

// tw50 -->
/*
==========================
ThunderWalker Sniper Code
an adaption of id's shotgun
code
==========================
*/
void(vector dir) FireSniper =
{

	local	vector	src;
	local	float	snipdamg;

	makevectors(self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;

	ClearMultiDamage ();

 	traceline (src, src + dir*2048, FALSE, self);
 	puff_org = trace_endpos - dir*4;

	snipdamg = 244 + random()*17;

		traceline (src, src + dir*2048, FALSE, self);
		if (trace_fraction != 1.0)
			TraceAttack (snipdamg, dir);

	ApplyMultiDamage ();
	Multi_Finish ();
};

void() W_FireSniper =
{
	local vector dir;

	sound (self, CHAN_WEAPON, "tw/tfsniper.wav", 1, ATTN_NORM);

	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);
	if (!FLAG_STANDBY && (DEATHMATCH != 4))
		self.currentammo = self.sniper_ammo = self.sniper_ammo - 1;
	dir = aim (self, 100000);
	FireSniper (dir);
};



// tw50 <--
/*
==============================================================================

ROCKETS

==============================================================================
*/

void() T_MissileTouch =
{
	local float	damg;

	if (other == self.owner)
		return;		// don't explode on owner

	if (self.cnt)
		return;

	self.cnt = 1;
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	if (FLAG_TW) damg = 80 + random()*16;
	else damg = 100 + random()*20;
	
	if (other.health)
	{
		T_Damage (other, self, self.owner, damg );
	}

	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage (self, self.owner, 120, other);

//	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
	WriteByte (MSG_MULTICAST, TE_EXPLOSION);
	WriteCoord (MSG_MULTICAST, self.origin_x);
	WriteCoord (MSG_MULTICAST, self.origin_y);
	WriteCoord (MSG_MULTICAST, self.origin_z);
	multicast (self.origin, MULTICAST_PHS);

	remove(self);
};



/*
================
W_FireRocket
================
*/
void() W_FireRocket =
{
	if (!FLAG_STANDBY  && (DEATHMATCH != 4))
		self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;

	if (FLAG_TW)	sound (self, CHAN_WEAPON, "tw/twrkt.wav", 1, ATTN_NORM);
	else	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);

	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.classname = "missile";
	newmis.cnt = 0;
		
// set newmis speed	

	makevectors (self.v_angle);
	newmis.velocity = aim(self, 1000);
	newmis.velocity = newmis.velocity * 1000;
	newmis.angles = vectoangles(newmis.velocity);
	
	newmis.touch = T_MissileTouch;
	
// set newmis duration
	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;

	setmodel (newmis, "progs/missile.mdl");
	setsize (newmis, '0 0 0', '0 0 0');		
	setorigin (newmis, self.origin + v_forward*8 + '0 0 16');
};

/*
===============================================================================

LIGHTNING

===============================================================================
*/

void(entity from, float damage) LightningHit =
{
	WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
	WriteByte (MSG_MULTICAST, TE_LIGHTNINGBLOOD);
	WriteCoord (MSG_MULTICAST, trace_endpos_x);
	WriteCoord (MSG_MULTICAST, trace_endpos_y);
	WriteCoord (MSG_MULTICAST, trace_endpos_z);
	multicast (trace_endpos, MULTICAST_PVS);

	T_Damage (trace_ent, from, from, damage);
};

/*
=================
LightningDamage
=================
*/
void(vector p1, vector p2, entity from, float damage) LightningDamage =
{
	local entity		e1, e2;
	local vector		f;
	
	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;

	e1 = e2 = world;

	traceline (p1, p2, FALSE, self);
	if (trace_ent.takedamage)
	{
		LightningHit (from, damage);
		if (self.classname == "player")
		{
			if (other.classname == "player")
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
		}
	}
	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
	if (trace_ent != e1 && trace_ent.takedamage)
	{
		LightningHit (from, damage);
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage)
	{
		LightningHit (from, damage);
	}
};


void() W_FireLightning =
{
	local	vector		org;
	local	float		cells;

	if (self.ammo_cells < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

// explode if under water
	if (self.waterlevel > 1)
	{
		if (DEATHMATCH > 3) {
			if (random() <= 0.5) {
				self.deathtype = "selfwater";
				T_Damage (self, self, self.owner, 4000 );
			} else {
				cells = self.ammo_cells;
				self.ammo_cells = 0;
				W_SetCurrentAmmo ();
				T_RadiusDamage (self, self, 35*cells, world);
				return;
			}
		} else {
			cells = self.ammo_cells;
			if (!FLAG_STANDBY)
				self.ammo_cells = 0;
			W_SetCurrentAmmo ();
			T_RadiusDamage (self, self, 35*cells, world);
			return;
		}
	}

	if (self.t_width < time)
	{
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = time + 0.6;
	}
	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);

	if (!FLAG_STANDBY && (DEATHMATCH != 4))
		self.currentammo = self.ammo_cells = self.ammo_cells - 1;

	org = self.origin + '0 0 16';
	
	traceline (org, org + v_forward*600, TRUE, self);

	WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
	WriteByte (MSG_MULTICAST, TE_LIGHTNING2);
	WriteEntity (MSG_MULTICAST, self);
	WriteCoord (MSG_MULTICAST, org_x);
	WriteCoord (MSG_MULTICAST, org_y);
	WriteCoord (MSG_MULTICAST, org_z);
	WriteCoord (MSG_MULTICAST, trace_endpos_x);
	WriteCoord (MSG_MULTICAST, trace_endpos_y);
	WriteCoord (MSG_MULTICAST, trace_endpos_z);
	multicast (org, MULTICAST_PHS);


//***Pure*** --> WaterZot LG 
// Code Snippet from CTF+ by Ronald E. Mercer (the_DM {GUN}) rmercer1@mindspring.com
// http://loc.gamesnet.net/ctfplus/

        if (trace_inwater && FLAG_CTFPLUSLG)
        {
                org = self.origin;
                self.origin = trace_endpos;

                T_ShootWaterRadiusDamage(self, self, 3, 400, self);
                self.origin = org;
        } else
                LightningDamage (self.origin, trace_endpos + v_forward*4, self, 30);
//***Pure*** <-- WaterZot LG from ctf+


};


//=============================================================================


void() GrenadeExplode =
{
	if (FreezeThink())
		return;
	if (FLAG_TW) {
		// ThunderWalker:  Needed to do damage for direct hits with people who have protection rune
		if (other.runes & ITEM_RUNE6_FLAG)
			T_Damage (other, self, self.owner, 95);
		T_RadiusDamage (self, self.owner, 95, world);
	} else {
		T_RadiusDamage (self, self.owner, 120, world);
	}

	WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
	WriteByte (MSG_MULTICAST, TE_EXPLOSION);
	WriteCoord (MSG_MULTICAST, self.origin_x);
	WriteCoord (MSG_MULTICAST, self.origin_y);
	WriteCoord (MSG_MULTICAST, self.origin_z);
	multicast (self.origin, MULTICAST_PHS);

	remove (self);
};

void() GrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner

	if (self.cnt)
		return;

	if (other.takedamage == DAMAGE_AIM)
	{
		self.cnt = 1;
		GrenadeExplode();
		return;
	}
	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);	// bounce sound
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

/*
================
W_FireGrenade
================
*/
void() W_FireGrenade =
{	
	if (!FLAG_STANDBY  && (DEATHMATCH != 4))
		self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	if (FLAG_TW)
		sound (self, CHAN_WEAPON, "tw/twgrenad.wav", 1, ATTN_NORM);
	else	
		sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);

	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;
	newmis.classname = "grenade";
	newmis.cnt = 0;
		
// set newmis speed	

	makevectors (self.v_angle);

	if (self.v_angle_x)
		newmis.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	else
	{
		newmis.velocity = aim(self, 10000);
		newmis.velocity = newmis.velocity * 600;
		newmis.velocity_z = 200;
	}

	newmis.avelocity = '300 300 300';

	newmis.angles = vectoangles(newmis.velocity);
	
	newmis.touch = GrenadeTouch;
	
	// set newmis duration
	if (DEATHMATCH == 4) {
		newmis.nextthink = time + 2.5;		
		self.attack_finished = time + 1.1;
		T_Damage (self, self, self.owner, 10 );
	} else
		newmis.nextthink = time + 2.5;


	newmis.think = GrenadeExplode;

	if (FLAG_TW && (TEAMPLAY & TW_FLOUNDERVISION_FLAG))
		setmodel (newmis, "progs/fish.mdl");
	else
		setmodel (newmis, "progs/grenade.mdl");

	setsize (newmis, '0 0 0', '0 0 0');		
	setorigin (newmis, self.origin);
};


// tw50 -->

void() flare_touch;
void() flare_bright;
void() flare_dim;


/*
=========================================================================
Flares Code Begins Here.
=========================================================================
*/

/*
================================
launch_flare

rework of id's launch_spike code
================================
*/
void(vector org, vector dir) launch_flare =
{
	if (self.flares == 0) {
		PrintStatusbar(self, "You are out of flares!!!",1);
		return;
	}
	if (FLAG_TW && (self.runes & ITEM_RUNE8_FLAG))
	        DecloakTarget(self);

	if (!FLAG_STANDBY && (DEATHMATCH != 4))
		self.flares = self.flares - 1;

	if (self.flares == 2)
		sprint (self, PRINT_HIGH, "2 flares left!\n");
	if (self.flares == 1)
		sprint (self, PRINT_HIGH, "1 flare left!\n");
	if (self.flares == 0)
		sprint (self, PRINT_HIGH, "Out of flares!\n");

	msg_entity = self;
//	WriteByte (MSG_ONE, SVC_SMALLKICK);

	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.classname = "flare";

// set newmis speed

	makevectors (self.v_angle);
	newmis.velocity = aim(self, 1000);
	newmis.velocity = newmis.velocity * 1750;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.touch = flare_touch;
	newmis.think = flare_bright;
	newmis.nextthink = time + 3;

// set newmis duration
//	newmis.nextthink = time + 5;
//	newmis.think = SUB_Remove;

        setmodel (newmis, "progs/flare.mdl");
	setsize (newmis, '0 0 0', '0 0 0');
	setorigin (newmis, self.origin + '0 0 16');

        newmis.effects = EF_DIMLIGHT;

};

/*
============================
flare_touch

rework of id's spike_touch()
============================
*/
void() flare_touch =
{
local float rand;
	if (other == self.owner)
		return;

        if (other.classname == "door" || other.classname == "plat")
                {
                remove(self);
                return;
                }

	if (other.solid == SOLID_TRIGGER)
		return; // trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

// has the flare hit something that bleeds?
	if (other.takedamage)
	{
                // If so, spawn some blood
		spawn_touchblood (9);
                // also do one point of damage
		T_Damage (other, self, self.owner, 1);

/*
Don't remove the flare unless it is still flying. Otherwise, monsters or
other players can come up and 'pull' your flare out of the wall
*/
	      if (self.velocity != '0 0 0')
			remove(self);
	}
	else
	{
        // Write information to the network
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

//Stop the flare, but do not remove it.
	self.movetype = MOVETYPE_NONE;
// Fix it so that flare only partially embeds itself (thanks, Luke)
        self.origin = self.origin - self.velocity * 0.005;
     	self.velocity = '0 0 0';
	self.touch = SUB_Null;
};


/*
==============================
flare_bright()

This function makes the flare
emit brighter light
==============================
*/

void() flare_bright =
{
	local vector    vel;
// Make the flare get BRIGHT by setting .effects bit
        self.effects = EF_BRIGHTLIGHT;
// Give it 10 seconds at maximum intensity
        self.nextthink = time + 10;
// After 10 seconds, call flare_dim
	self.think = flare_dim;
// Play a sound for flare ignition
	sound (self, CHAN_WEAPON, "tw/flareup.wav", 1, ATTN_NORM);

// Set up some red and yellow sparks
	vel = '0 0 150';
//	particle (self.origin+vel*0.01,vel,111,150);
//       vel = '0 0 120';
//	particle (self.origin+vel*0.01,vel,73,200);



/*
==============================
flare_dim()

This function makes the flare
go dim again
==============================
*/
};

void() flare_dim =
{
// Make the flare get dim by setting .effects bit
        self.effects = EF_DIMLIGHT;
// Give it 15 seconds before burnout
	self.nextthink = time + 5;
// After 15 seconds remove the flare from the game
	self.think = SUB_Remove;
};





/*
===================================================================
End of Flare Code  -    Steve Bond 8/1/96 adapted for TW by Marc Rittierodt 4/97
===================================================================
*/
/*
========================
ThundeWalker Laser Code
adaption of id rocket
code
========================
*/
void() LaserTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner

	if (self.cnt)
		return;

	self.cnt = 1;
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	if (other.health)
		T_Damage (other, self, self.owner, 58 );

remove(self);

};

void() W_FireLaser =
{
	if (!FLAG_STANDBY && (DEATHMATCH != 4))
		self.currentammo = self.ammo_cells = self.ammo_cells - 1;

	sound (self, CHAN_WEAPON, "tw/twlaz04.wav", 1, ATTN_NORM);

	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.classname = "laser";
	newmis.cnt = 0;
	
	makevectors (self.v_angle);
	newmis.velocity = aim(self, 1000);
	newmis.velocity = newmis.velocity * 1900;
	newmis.angles = vectoangles(newmis.velocity);
	
	newmis.touch = LaserTouch;
	newmis.nextthink = time + 3;
	newmis.think = SUB_Remove;

	if ((self.steam == TEAM_COLOR2))
		setmodel (newmis, "progs/twbolt-b.mdl");
	else
		setmodel (newmis, "progs/twbolt1.mdl");

	setsize (newmis, '0 0 0', '0 0 0');
	setorigin (newmis, self.origin + v_forward*8 + '0 0 16');

};



// tw50 <--

//=============================================================================

void() spike_touch;
void() superspike_touch;


/*
===============
launch_spike

Used for both the player and the ogre
===============
*/
void(vector org, vector dir) launch_spike =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.cnt = 0;

	newmis.angles = vectoangles(dir);
	
	newmis.touch = spike_touch;
	newmis.classname = "spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 6;
	setmodel (newmis, "progs/spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	setorigin (newmis, org);

	newmis.velocity = dir * 1000;
};

void() W_FireSuperSpikes =
{
	local vector	dir;
	local entity	old;
	
	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	if (!FLAG_STANDBY && (DEATHMATCH != 4)) {
		if (FLAG_TW)
			self.currentammo = self.ammo_nails = self.ammo_nails - 1;
		else
			self.currentammo = self.ammo_nails = self.ammo_nails - 2;
	}
	dir = aim (self, 1000);
	launch_spike (self.origin + '0 0 16', dir);
	newmis.touch = superspike_touch;
	newmis.classname = "spike";
	setmodel (newmis, "progs/s_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);
};

void(float ox) W_FireSpikes =
{
	local vector	dir;
	local entity	old;
	
	makevectors (self.v_angle);
	
	if (self.ammo_nails >= 2 && self.weapon == IT_SUPER_NAILGUN)
	{
		W_FireSuperSpikes ();
		return;
	}

	if (self.ammo_nails < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	if (!FLAG_STANDBY && (DEATHMATCH != 4))
		self.currentammo = self.ammo_nails = self.ammo_nails - 1;
	dir = aim (self, 1000);
	launch_spike (self.origin + '0 0 16' + v_right*ox, dir);

	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);
};




void() spike_touch =
{
local float rand;
	if (other == self.owner)
		return;

	if (self.cnt)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	self.cnt = 1;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (9);
		T_Damage (other, self, self.owner, 9);
	}
	else
	{
		WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
  		if (self.classname == "wizspike")
			WriteByte (MSG_MULTICAST, TE_WIZSPIKE);
  		else if (self.classname == "knightspike")
			WriteByte (MSG_MULTICAST, TE_KNIGHTSPIKE);
  		else
			WriteByte (MSG_MULTICAST, TE_SPIKE);
		WriteCoord (MSG_MULTICAST, self.origin_x);
		WriteCoord (MSG_MULTICAST, self.origin_y);
		WriteCoord (MSG_MULTICAST, self.origin_z);
		multicast (self.origin, MULTICAST_PHS);
	}

	remove(self);

};

void() superspike_touch =
{
local float rand;
	if (other == self.owner)
		return;

	if (self.cnt)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	self.cnt = 1;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (18);
		T_Damage (other, self, self.owner, 18);
	}
	else
	{
		WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
		WriteByte (MSG_MULTICAST, TE_SUPERSPIKE);
		WriteCoord (MSG_MULTICAST, self.origin_x);
		WriteCoord (MSG_MULTICAST, self.origin_y);
		WriteCoord (MSG_MULTICAST, self.origin_z);
		multicast (self.origin, MULTICAST_PHS);
	}

	remove(self);

};


/*
===============================================================================

PLAYER WEAPON USE

===============================================================================
*/

void() W_SetCurrentAmmo =
{
	player_run ();		// get out of any weapon firing states

	self.items = self.items - ( self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS) );
	
	if (self.weapon == IT_AXE)
	{
		self.currentammo = 0;
		self.weaponmodel = "progs/v_axe.mdl";
		self.weaponframe = 0;
	}
        else if (self.weapon == IT_GRAPPLE)
	{
		self.currentammo = 0;
		if (FLAG_HOOK) {
			if (FLAG_TW)
				self.weaponmodel = "progs/twharpgn.mdl";
			else
				self.weaponmodel = "progs/v_star.mdl";
		} else
			self.weaponmodel = "progs/v_axe.mdl";
		self.weaponframe = 0;
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		if (FLAG_TW)
			self.weaponmodel = "progs/twvshota.mdl";
		else
			self.weaponmodel = "progs/v_shot.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		if (FLAG_TW)
			self.weaponmodel = "progs/twvshot2.mdl";
		else
			self.weaponmodel = "progs/v_shot2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		if (FLAG_TW) {
			self.currentammo = self.ammo_cells;
			self.weaponmodel = "progs/twlaserh.mdl";
			self.items = self.items | IT_CELLS;
		} else {
			self.currentammo = self.ammo_nails;
			self.weaponmodel = "progs/v_nail.mdl";
			self.items = self.items | IT_NAILS;
		}
		self.weaponframe = 0;
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
		self.weaponmodel = "progs/v_nail2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "progs/v_rock.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "progs/v_rock2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		if (FLAG_TW) {
			self.currentammo = self.sniper_ammo;
			self.weaponmodel = "progs/v_sniper.mdl";
		} else {
			self.currentammo = self.ammo_cells;
			self.weaponmodel = "progs/v_light.mdl";
			self.items = self.items | IT_CELLS;
		}
		self.weaponframe = 0;
	}
// tw50 -->
	else if ((self.weapon == IT_AIRGUN) && FLAG_AIRFIST) {
		self.currentammo = 0;
		self.weaponmodel = "progs/v_airgun.mdl";
		self.weaponframe = 0;
	}
// tw50 <--
	else
	{
		self.currentammo = 0;
		self.weaponmodel = "";
		self.weaponframe = 0;
	}

//***multiweapon*** -->
	if (FLAG_MULTIWEAPON)
	        set_player_weapon ();
//***multiweapon*** <--

	if (self.pure & SETINFO_SBAR_WEAPON)		// *Pure* statusbar
		PrintStatusbar(self, "", 1);

};

float() W_BestWeapon =
{
	local	float	it;
	
	it = self.items;

	if (!FLAG_TW && self.waterlevel <= 1 && self.ammo_cells >= 1 && (it & IT_LIGHTNING) )
		return IT_LIGHTNING;
	else if(self.ammo_nails >= 2 && (it & IT_SUPER_NAILGUN) )
		return IT_SUPER_NAILGUN;
	else if(self.ammo_shells >= 2 && (it & IT_SUPER_SHOTGUN) )
		return IT_SUPER_SHOTGUN;
	else if(!FLAG_TW && self.ammo_nails >= 1 && (it & IT_NAILGUN) )
		return IT_NAILGUN;
	else if(FLAG_TW && self.ammo_cells >= 1 && (it & IT_NAILGUN) )
		return IT_NAILGUN;
	else if(self.ammo_shells >= 1 && (it & IT_SHOTGUN) )
		return IT_SHOTGUN;
// tw50-->
	else if (FLAG_AIRFIST && AIRG_SHOWINWEAPONLIST == TRUE && (it & IT_AIRGUN))
			return IT_AIRGUN;
// tw50 <--
	return IT_AXE;
};

// **pure** -->
float() W_BestExWeapon = {
	local	float	it;
	it = self.items;

	if (self.ammo_rockets >= 1 && (it & IT_ROCKET_LAUNCHER) )
		return IT_ROCKET_LAUNCHER;
	else if(self.ammo_rockets >= 1 && (it & IT_GRENADE_LAUNCHER) )
		return IT_GRENADE_LAUNCHER;
	else
		return W_BestWeapon();	
};
// **pure** <--


float() W_CheckNoAmmo =
{
	if (self.currentammo > 0)
		return TRUE;

	if (self.weapon == IT_AXE)
		return TRUE;

// tw50 -->
	if (FLAG_AIRFIST && (self.weapon == IT_AIRGUN))
		return TRUE;
// tw50

	if (self.weapon == IT_GRAPPLE)
		return TRUE;
	
	self.weapon = W_BestWeapon ();

	W_SetCurrentAmmo ();
	
// drop the weapon down
	return FALSE;
};

/*
============
W_Attack

An attack impulse can be triggered now
============
*/
void()	player_axe1;
void()	player_axeb1;
void()	player_axec1;
void()	player_axed1;
void()	player_shot1;
void()	player_nail1;
void()	player_light1;
void()	player_rocket1;
void()  player_snipe1;

void() W_Attack =
{
	local	float	r;

	if (!W_CheckNoAmmo ())
		return;
// ***pure***
	if (self.weapon == IT_GRAPPLE) {
		if (FREEZEFLAGS & FREEZE_HOOK)
			return;
	} else {
		if (FREEZEFLAGS & FREEZE_WEAPONS_BUT_HOOK)
			return;
	}
// ***pure***

	// ThunderWalker:  Like in Star Trek, you cannot fire while cloaked
	if (FLAG_TW && (self.runes & ITEM_RUNE8_FLAG))
		DecloakTarget(self);


	makevectors	(self.v_angle);			// calculate forward angle for velocity
// pure - obsolete	self.show_hostile = time + 1;	// wake monsters up

	if (self.weapon == IT_GRAPPLE) {

		if ((self.player_flag & PF_GOTFLAG) && FLAG_RLJUMPCTF)	// ***rljumpctf*** --> Remove hook if the player have the flag.
			return;		
/* debug
		if (FLAG_TW)
			if (self.grapples > 6 && self.grappletime > time)
				PrintStatusbar(self, "Warning! Grapple is Overheating!!!",1);
*/
		if (self.hook_out) {
			if (FLAG_TW)
				player_harpoon3 ();		// tw50
			else
				player_hook3 ();
		} else {
			if (FLAG_TW)
				player_harpoon1 ();		// tw50
			else
				player_hook1 ();
		}
		self.attack_finished = time + 0.1;
/* *obsolete* dummy TW grapplecheck
		if (FLAG_TW) {
			if (self.grappletime < time) {
				self.grappletime = time + 2;
				self.grapples = 0;
			}
			self.grapples = self.grapples + 1;
		}
*/
	}

	if (self.weapon == IT_AXE)
	{
                sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
		r = random();
		if (r < 0.25)
			player_axe1 ();
		else if (r<0.5)
			player_axeb1 ();
		else if (r<0.75)
			player_axec1 ();
		else
			player_axed1 ();
		// RUNE: rune of hell magic
		if (self.runes & ITEM_RUNE3_FLAG) {
			self.attack_finished = time + 0.3;
			HasteSound();
		} else
			self.attack_finished = time + 0.5;
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		player_shot1 ();
		W_FireShotgun ();
		// RUNE: rune of hell magic
		if (self.runes & ITEM_RUNE3_FLAG) {
			if (FLAG_TW)
				self.attack_finished = time + (0.2 / HASTERATE);
			else
				self.attack_finished = time + (0.6 / HASTERATE);
			HasteSound();
		} else {
			if (FLAG_TW)
				self.attack_finished = time + 0.3;
			else
				self.attack_finished = time + 0.5;
		}
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		player_shot1 ();
		W_FireSuperShotgun ();
		// RUNE: rune of hell magic
		if (self.runes & ITEM_RUNE3_FLAG) {
			if (FLAG_TW)
				self.attack_finished = time + (0.5 / HASTERATE);
			else
				self.attack_finished = time + (0.8 / HASTERATE);
			HasteSound();
		} else {
			if (FLAG_TW)
				self.attack_finished = time + 0.45;
			else
				self.attack_finished = time + 0.7;
		}
	}
	else if (self.weapon == IT_NAILGUN)
	{
		if (FLAG_TW) {
		        player_shot1();
	                W_FireLaser();
        	        if (self.runes & ITEM_RUNE3_FLAG)
                        {
                	        self.attack_finished = time + 0.2;
                       		HasteSound();
                        } else
                		self.attack_finished = time + 0.35;
		} else {
			player_nail1 ();
		}
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		player_nail1 ();
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		player_rocket1();
		W_FireGrenade();
		// RUNE: rune of hell magic
 		if (self.runes & ITEM_RUNE3_FLAG) {
 			self.attack_finished = time + (0.6 / HASTERATE) ;
 			HasteSound();
 		} else
			self.attack_finished = time + 0.6;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		player_rocket1();
		W_FireRocket();
		// RUNE: rune of hell magic
 		if (self.runes & ITEM_RUNE3_FLAG) {
 			self.attack_finished = time + (0.8 / HASTERATE) ;
 			HasteSound();
 		} else
			self.attack_finished = time + 0.8;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		if (FLAG_TW) {
		        player_snipe1();
			W_FireSniper();
			if ((self.runes & ITEM_RUNE3_FLAG) && self.sniper_ammo != 0) {
				self.attack_finished = time + 3.25;
				HasteSound();
			} else if (self.sniper_ammo != 0) {
				self.attack_finished = time + 6.5;
			} else
				self.attack_finished = time + 0.8;
			// *check* snipeprint
			if (self.sniper_ammo == 4)
				PrintStatusbar(self, "Reloading - 4 Shots remaining!",1);
			else if (self.sniper_ammo == 3)
				PrintStatusbar(self, "Reloading - 3 Shots remaining!",1);
			else if (self.sniper_ammo == 2)
				PrintStatusbar(self, "Reloading - 2 Shots remaining!",1);
			else if (self.sniper_ammo == 1)
				PrintStatusbar(self, "Reloading - Last shot!",1);
			else if (self.sniper_ammo == 0)
				PrintStatusbar(self, "Out of ammo!",1);
		} else {
			self.attack_finished = time + 0.1;
			sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
			player_light1();
		}
	} else if (FLAG_AIRFIST && (self.weapon == IT_AIRGUN)) {
		launch_horn();
	}

};

/*
============
W_ChangeWeapon

============
*/
void() W_ChangeWeapon = {

	// Lock TW Sniper
	if ((time < self.attack_finished) && FLAG_TW && (self.weapon == IT_LIGHTNING))
		return;


	local	float	it, am, fl;

	it = self.items;
	am = 0;
	
	if (self.impulse == 1 && self.weapon) {
		if (self.weapon == IT_AXE) {
			fl = IT_GRAPPLE;

			if (self.hook_out)
				Reset_Grapple(self.hook);
		} else if (self.weapon != IT_AXE)
			fl = IT_AXE;
	} else if (self.impulse == 22) {
		// Ok, hook feeling is important, so I'll include ALL possible functions here.
		if (FLAG_TW) {	// *check* fix correctly later
			// === tw 5.0 === (same as 3wave 4.21?)
			fl = IT_GRAPPLE;
			if (self.weapon != IT_GRAPPLE) {
				sprint (self, PRINT_HIGH , "Grappling Hook Selected\n");
				if (self.hook_out)
					sound (self, CHAN_WEAPON, "weapons/bounce2.wav", 1, ATTN_NORM);	
	
				self.hook_out = FALSE;
				self.on_hook = FALSE;
			}
		} else if (SET_HOOK == IS_PURE) {
			// ==== Standard Pure ====
			// Remove the hook if it's out. (Like switching by 2x impulse 1)
			fl = IT_GRAPPLE;
			if (self.weapon != IT_GRAPPLE) {
				sprint (self, PRINT_LOW , "Grappling Hook Selected\n");
				if (self.hook_out)	
					Reset_Grapple(self.hook);	
				//sound (self, CHAN_WEAPON, "weapons/bounce2.wav", 1, ATTN_NORM);	
				self.hook_out = FALSE;
				self.on_hook = FALSE;
			}
		} else if (SET_HOOK == IS_OLD) {
			// === 3wave 4.2 ===
			fl = IT_GRAPPLE;
			sprint (self, PRINT_HIGH , "Grappling Hook Selected\n");
			if (self.hook_out)
				sound (self, CHAN_WEAPON, "weapons/bounce2.wav", 1, ATTN_NORM);		

			self.hook_out = FALSE;
			self.on_hook = FALSE;
		} else { 
			// === 3wave 4.21 === 
			fl = IT_GRAPPLE;
			if (self.weapon != IT_GRAPPLE) {
				sprint (self, PRINT_HIGH , "Grappling Hook Selected\n");
				if (self.hook_out)
					sound (self, CHAN_WEAPON, "weapons/bounce2.wav", 1, ATTN_NORM);	
				self.hook_out = FALSE;
				self.on_hook = FALSE;
			}
		}
	} else if (self.impulse == 31) {
		fl = IT_AXE;
	} else if (self.impulse == 2 || self.impulse == 32) {
		fl = IT_SHOTGUN;
		if (self.ammo_shells < 1)
			am = 1;
	} else if (self.impulse == 3 || self.impulse == 33) {
		fl = IT_SUPER_SHOTGUN;
		if (self.ammo_shells < 2)
			am = 1;
	} else if (self.impulse == 4 || self.impulse == 34) {
		fl = IT_NAILGUN;
		if (FLAG_TW) {
			if (self.ammo_cells < 1)
				am = 1;
		} else {
			if (self.ammo_nails < 1)
				am = 1;
		}
	} else if (self.impulse == 5) {
		fl = IT_SUPER_NAILGUN;
		if (FLAG_TW) {
			if (self.ammo_nails < 1)
				am = 1;
		} else {
			if (self.ammo_nails < 2)
				am = 1;
		}
	} else if (self.impulse == 35) {
		fl = IT_SUPER_NAILGUN;
		if (self.ammo_nails < 2)
			am = 1;
	} else if (self.impulse == 6 || self.impulse == 36) {
		fl = IT_GRENADE_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	} else if (self.impulse == 7 || self.impulse == 37) {
		fl = IT_ROCKET_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	} else if (self.impulse == 8 || self.impulse == 38) {
		fl = IT_LIGHTNING;
		if (FLAG_TW) {
			if (self.sniper_ammo < 1)
				am = 1;
		} else {
			if (self.ammo_cells < 1)
				am = 1;
		}
	}
// tw50 -->
	if (FLAG_AIRFIST) {
		if (self.impulse == AIRG_IMPULSEVALUE) {
			fl = IT_AIRGUN;
		}

		// if already have the weapon or if you don't have the weapon, try the
		// double tap impulse.
		if((self.weapon == fl || !(self.items & fl) || am == 1) && AIRG_DOUBLETAPIMPULSE == self.impulse) {
			fl = IT_AIRGUN;
			am = 0;
		}
	}
// tw50 <--

	self.impulse = 0;
	
	if (!(self.items & fl)) {	
		// don't have the weapon or the ammo
		sprint (self, PRINT_HIGH, "no weapon.\n");
		return;
	}
	
	if (am)	{
		// don't have the ammo
		sprint (self, PRINT_HIGH, "not enough ammo.\n");
		return;
	}

//
// set weapon, set ammo
//

        self.previous_weapon = self.weapon;
	self.weapon = fl;
	W_SetCurrentAmmo ();

};

/*
============
CheatCommand
============
*/
void() CheatCommand =
{
//	if (deathmatch || coop)
		return;

	self.ammo_rockets = 100;
	self.ammo_nails = 200;
	self.ammo_shells = 100;
	self.items = self.items | 
		IT_AXE |
		IT_SHOTGUN |
		IT_SUPER_SHOTGUN |
		IT_NAILGUN |
		IT_SUPER_NAILGUN |
		IT_GRENADE_LAUNCHER |
		IT_ROCKET_LAUNCHER |
		IT_KEY1 | IT_KEY2;

	self.ammo_cells = 200;
	self.items = self.items | IT_LIGHTNING;

	self.weapon = IT_ROCKET_LAUNCHER;

	if (FLAG_TW) {
		self.ammo_cells = 60;
		self.items = self.items | IT_AIRGUN;
	}
	self.impulse = 0;
	W_SetCurrentAmmo ();
};

/*
============
CycleWeaponCommand

Go to the next weapon with ammo
============
*/
void() CycleWeaponCommand =
{
	// Lock TW Sniper
	if ((time < self.attack_finished) && FLAG_TW && (self.weapon == IT_LIGHTNING))
		return;


	local	float	it, am;

	it = self.items;
	self.impulse = 0;
	
//McBain: save current weapon
	self.previous_weapon = self.weapon;

	while (1)
	{
		am = 0;

		if (self.weapon == IT_LIGHTNING) {
			self.weapon = IT_GRAPPLE;
		} else if (self.weapon == IT_GRAPPLE) {
			self.weapon = IT_AXE;
		} else if (self.weapon == IT_AXE) {
			self.weapon = IT_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		} else if (self.weapon == IT_SHOTGUN) {
		    	if (FLAG_AIRFIST && (AIRG_SHOWINWEAPONLIST == TRUE)) {	// tw50
				self.weapon = IT_AIRGUN;
			} else {
				self.weapon = IT_SUPER_SHOTGUN;
				if (self.ammo_shells < 2)
					am = 1;
			}
	  	} else if( FLAG_AIRFIST && (self.weapon == IT_AIRGUN)) {	// tw50
			self.weapon = IT_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		} else if (self.weapon == IT_SUPER_SHOTGUN) {
			self.weapon = IT_NAILGUN;
			if (FLAG_TW) {
				if (self.ammo_cells < 1)
					am = 1;
 			} else {
				if (self.ammo_nails < 1)
					am = 1;
			}
		} else if (self.weapon == IT_NAILGUN) {
			self.weapon = IT_SUPER_NAILGUN;
			if (FLAG_TW) {
				if (self.ammo_nails < 1)
					am = 1;
 			} else {
				if (self.ammo_nails < 2)
					am = 1;
			}
		} else if (self.weapon == IT_SUPER_NAILGUN) {
			self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		} else if (self.weapon == IT_GRENADE_LAUNCHER) {
			self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		} else if (self.weapon == IT_ROCKET_LAUNCHER) {
			self.weapon = IT_LIGHTNING;
			if (FLAG_TW) {
				if (self.sniper_ammo < 1)
					am = 1;
 			} else {
				if (self.ammo_cells < 1)
					am = 1;
			}
		}
	
		if ( (it & self.weapon) && am == 0)
		{
			W_SetCurrentAmmo ();
			return;
		}
	}

};

/*
============
CycleWeaponReverseCommand

Go to the prev weapon with ammo
============
*/
void() CycleWeaponReverseCommand =
{
	// Lock TW Sniper
	if ((time < self.attack_finished) && FLAG_TW && (self.weapon == IT_LIGHTNING))
		return;

	local	float	it, am;
	
	it = self.items;
	self.impulse = 0;

//McBain: save current weapon
	self.previous_weapon = self.weapon;

	while (1)
	{
		am = 0;

		if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			self.weapon = IT_SUPER_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			self.weapon = IT_NAILGUN;
			if (FLAG_TW) {
				if (self.ammo_cells < 1)
					am = 1;
 			} else {
				if (self.ammo_nails < 1)
					am = 1;
			}
		}
		else if (self.weapon == IT_NAILGUN)
		{
			self.weapon = IT_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}		
		else if (self.weapon == IT_SUPER_SHOTGUN) {
// tw50 -->
	    	if (FLAG_AIRFIST && (AIRG_SHOWINWEAPONLIST == TRUE)) {
				self.weapon = IT_AIRGUN;
			} else {
				self.weapon = IT_SHOTGUN;
				if (self.ammo_shells < 1)
					am = 1;
			}

		} else if (FLAG_AIRFIST && (self.weapon == IT_AIRGUN)) {
			self.weapon = IT_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
// tw50 <--
		}
		else if (self.weapon == IT_SHOTGUN) {
			self.weapon = IT_AXE;
		} else if (self.weapon == IT_AXE) {
			self.weapon = IT_GRAPPLE;
		} else if (self.weapon == IT_GRAPPLE) {
			self.weapon = IT_LIGHTNING;
			if (FLAG_TW) {
				if (self.sniper_ammo < 1)
					am = 1;
 			} else {
				if (self.ammo_cells < 1)
					am = 1;
			}
		}
	
		if ( (it & self.weapon) && am == 0)
		{
			W_SetCurrentAmmo ();
			return;
		}
	}

};


/*
============
ServerflagsCommand

Just for development
============
*/
void() ServerflagsCommand =
{
	serverflags = serverflags * 2 + 1;
// ZOID:  Bug fix
	serverflags = (serverflags & 15);
};

//ZOID:  Uhm, where am I?
void() PrintLocation =
{
	local string p;

	p = vtos(self.origin);

	sprint(self, PRINT_HIGH, "You are at ");
	sprint(self, PRINT_HIGH, p);
	sprint(self, PRINT_HIGH, "\n");
};


void() SpectatorThink;


//McBain: Here's the beef...
/*
============
PreviousWeaponCommand
============
*/
void() PreviousWeaponCommand =
{
	// Lock TW Sniper
	if ((time < self.attack_finished) && FLAG_TW && (self.weapon == IT_LIGHTNING))
		return;

	local	float	fl, am;
	
	self.impulse = 0;
	am = 0;

	if (!(self.items & self.previous_weapon))
	{	// don't have the weapon or the ammo
		sprint (self, PRINT_HIGH, "no weapon.\n");
		return;
	}
	
	fl = self.weapon;
	self.weapon = self.previous_weapon;
	self.previous_weapon = fl;

	// this might not be the best method, but I'll be able to play sooner
	if (self.weapon == IT_SHOTGUN || self.weapon == IT_SUPER_SHOTGUN) {
		if (self.ammo_shells < 1)
			am = 1;
	}

	else if (self.weapon == IT_NAILGUN) {
		if (FLAG_TW) {
			if (self.ammo_cells < 1)
				am = 1; 
		} else {
			if (self.ammo_nails < 1)
				am = 1;
		}
	} else if (self.weapon == IT_SUPER_NAILGUN) {
		if (self.ammo_nails < 1)
			am = 1;
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER || self.weapon == IT_ROCKET_LAUNCHER) {
		if (self.ammo_rockets < 1)
			am = 1;
	}
	else if (self.weapon == IT_LIGHTNING) {
		if (FLAG_TW) {
			if (self.sniper_ammo < 1)
				am = 1; 
		} else {
			if (self.ammo_cells < 1)
				am = 1;
		}
	}
	// ignore AXE -- no ammo needed

	if (am)
		self.weapon = W_BestWeapon ();

	W_SetCurrentAmmo ();
};

/*
============
W_WeaponFrame

Called every frame so impulse events can be handled as well as possible
============
*/
void() W_WeaponFrame =
{
	if (time < self.attack_finished)
		return;

// tw50 -->
	if (FLAG_TW) {
		if ((self.weapon == IT_LIGHTNING) && (time > self.attack_finished) && (time < self.attack_finished +1))
			//*check* snipeprint
			PrintStatusbar(self, "Sniper Rifle is Ready!",1);
		// ThunderWalker: Handles whether you should be visible or not with cloaking rune
		if (self.runes & ITEM_RUNE8_FLAG) {
			CheckCloak();
		}

		// ThunderWalker: Teleport mojo
		if (self.twflags & TW_TRANSTIME)
		{
			if (self.player_flag & PF_GOTFLAG)
			{
				PrintStatusbar(self, "Nice Try, Bucko",1);
				self.twflags = self.twflags - (self.twflags & (TW_TRANSTIME));
			} else {
				whereigo = SelectTeleSpot();
				spawn_tfog(self.origin);
				spawn_tfog(whereigo.origin);
				spawn_tdeath(whereigo.origin, self);
				self.origin = whereigo.origin;
				self.twflags = self.twflags - (self.twflags & (TW_TRANSTIME));
				self.twflags = self.twflags | (TW_ACME);
			}
		}
	}
// tw50 <--


// check for attack
	if (self.button0)
	{
		SuperDamageSound ();
		W_Attack ();
	}
};

/*
========
Resistancesound

Plays sound if needed
========
*/
void(entity who) ResistanceSound =
{
// RUNE play resistance sound if player has Earth Magic
	if (who.runes & ITEM_RUNE1_FLAG) {
		if (who.invincible_sound < time) {
			who.invincible_sound = time + 1;
			sound(who, CHAN_BODY, "rune/rune1.wav", 1, ATTN_NORM);
		}
	}
};
/*
========
SuperDamageSound

Plays sound if needed
========
*/
void() SuperDamageSound =
{

	if (FLAG_TW && (self.weapon == IT_NAILGUN))
		return;


// RUNE play super damage sound if player has Black Magic, too
	if ((self.runes & ITEM_RUNE2_FLAG) && 
		(self.super_damage_finished > time)) {
		if (self.super_sound < time) {
			self.super_sound = time + 1;
			sound (self, CHAN_BODY, "rune/rune22.wav", 1, ATTN_NORM);
		}
	}

	if (self.super_damage_finished > time) {
		if (self.super_sound < time) {
			self.super_sound = time + 1;
			sound (self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
		}
	}

	if (self.runes & ITEM_RUNE2_FLAG) {
		if (self.super_sound < time) {
			self.super_sound = time + 1;
			sound (self, CHAN_BODY, "rune/rune2.wav", 1, ATTN_NORM);
		}
	}
};

float regeneration_sound;
float haste_sound;

//
// Plays regeneration sound if needed
//
void() RegenerationSound = {
	if (self.runes & ITEM_RUNE4_FLAG || (FLAG_TW && (self.runes & ITEM_RUNE5_FLAG))) {
		if (regeneration_sound < time) {
			regeneration_sound = time + 1;
			sound(self, CHAN_BODY, "rune/rune4.wav", 1, ATTN_NORM);
		}
	}
};

// 
// Plays haste sound if needed.
//
void() HasteSound = {
	if (self.runes & ITEM_RUNE3_FLAG) {
		if (haste_sound < time) {
			haste_sound = time + 1;
			sound(self, CHAN_BODY, "rune/rune3.wav", 1, ATTN_NORM);
		}
	}
};

// *check*
