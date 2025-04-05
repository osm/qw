

// *check* -->


void() T_MissileTouch;
void() info_player_start;
void(entity targ, entity attacker, entity inflictor) ClientObituary;
void(entity who) ResistanceSound;
float(entity targ, entity inflictor, entity attacker, float damage) TeamArmorDam;
float(entity targ, entity inflictor, entity attacker, float damage) TeamHealthDam;


//============================================================================


/*
============
CanDamage

Returns true if the inflictor can directly damage the target.  Used for
explosions and melee attacks.
============
*/
float(entity targ, entity inflictor) CanDamage = {
// bmodels need special checking because their origin is 0,0,0
	if (targ.movetype == MOVETYPE_PUSH) {
		traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), TRUE, self);
		if (trace_fraction == 1)
			return TRUE;
		if (trace_ent == targ)
			return TRUE;
		return FALSE;
	}
	traceline(inflictor.origin, targ.origin, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	return FALSE;
};


/*
============
Killed
============
*/
void(entity targ, entity attacker, entity inflictor) Killed =
{
	local entity oself;

	oself = self;
	self = targ;
	
	if (self.health < -99)
		self.health = -99;		// don't let sbar look bad if a player

	if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE)
	{	// doors, triggers, etc

		self.th_die ();
		self = oself;
		return;
	}

	self.enemy = attacker;		// *obsolete* 

	ClientObituary(self, attacker, inflictor);	// *check* annat för arena
	
	self.takedamage = DAMAGE_NO;
	self.touch = SUB_Null;
	self.effects = 0;

	self.th_die ();

	if (IsClassPlayer(self)) {
		if (FORCE_RESPAWN) {
			self.forcerespawn = time + FORCE_RESPAWN;
		} 
	}
	self = oself;
};

/*
============
T_Damage

The damage is coming from inflictor, but get mad at attacker
This should be the only function that ever reduces health.
============
*/
void(entity targ, entity inflictor, entity attacker, float damage) T_Damage= {
	local	vector	dir;
	local	entity	oldself;
	local	float	save;
	local	float	take;

	if ((!targ.takedamage) || !targ)
		return;

	// Pure: Allow no damage, only momentum if standby.
	if (FLAG_STANDBY || FREEZEFLAGS) {
		if ( (inflictor != world) && (targ.movetype == MOVETYPE_WALK) ) {
			dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
			dir = normalize(dir);
			targ.velocity = targ.velocity + dir*damage*8;
		}
		return;
	}
	
	// used by buttons and triggers to set activator for target firing
	damage_attacker = attacker;

	if (attacker.super_damage_finished > time) {
		if (DEATHMATCH == 4) 
			damage = damage * 8;
		else
			damage = damage * 4;
	}
	if (attacker.runes & ITEM_RUNE2_FLAG)
		damage = damage * STRENGTH;	// ***Pure***


	// Check for Resistance
	if (targ.runes & ITEM_RUNE1_FLAG) {
		damage = damage * RESISTANCE;	// ***Pure***
		ResistanceSound(targ);
	}
 
	// *XXX* EXPERT CTF mark players who hurt the flag carrier, so they 
	// are worth more points for a while.
 	if ( (attacker.classname == "player") && // attacker must be a player
 	     (targ.player_flag & PF_GOTFLAG) && // target is a flag carrier
 	     !(SameTeam(attacker, targ, inflictor))) // target and attacker on diff teams
 		attacker.last_hurt_carrier = time;

	// Save some damage if you have armor.
	if (TeamArmorDam(targ, inflictor, attacker, damage))
		save = ceil(targ.armortype*damage);
	else
		save = 0;
	if (save >= targ.armorvalue) {
		save = targ.armorvalue;
		targ.armortype = 0;	// lost all armor
		targ.items = targ.items - (targ.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
	}
	targ.armorvalue = targ.armorvalue - save;
	take = ceil(damage-save);


	// add to the damage total for clients, which will be sent as a single
	// message at the end of the frame
	// FIXME: remove after combining shotgun blasts?
	if (targ.flags & FL_CLIENT)
	{
		targ.dmg_take = targ.dmg_take + take;
		targ.dmg_save = targ.dmg_save + save;
		targ.dmg_inflictor = inflictor;
	}

	// figure momentum add
	if ( (inflictor != world) && (targ.movetype == MOVETYPE_WALK) )	{
		dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
		dir = normalize(dir);
		targ.velocity = targ.velocity + dir*damage*8;
	}

	// check for godmode or invincibility
	if (self.killed != 99) { // god or 666 doesn't save your from team change
		if (targ.flags & FL_GODMODE)
			return;
		if (targ.invincible_finished >= time)
		{
			if (self.invincible_sound < time)
			{
				sound (targ, CHAN_ITEM, "items/protect3.wav", 1, ATTN_NORM);
				self.invincible_sound = time + 2;
			}
			return;
		}
	}


	// team play damage avoidance
	if (FLAG_TP1 && SameTeam(targ, attacker, inflictor))
		return;
		
	// *TEAMPLAY*
	// TeamHealthDam will return true if the attacker can damage the target's
	// health
        if (!TeamHealthDam(targ, inflictor, attacker, damage))
                return;
		
	// do the damage
	targ.health = targ.health - take;	

	if (targ.health <= 0)
	{
		Killed (targ, attacker, inflictor);
		return;
	}



	// react to the damage
	oldself = self;
	self = targ;

	if (self.th_pain)
		self.th_pain (attacker, take);

	self = oldself;
};

/*
============
T_RadiusDamage
============
*/
void(entity inflictor, entity attacker, float damage, entity ignore) T_RadiusDamage =
{
	local	float 	points;
	local	entity	head;
	local	vector	org;

//***discharge*** --> Set up dischargetest
	local	float	isdischarge;
	isdischarge = ((inflictor.weapon == IT_LIGHTNING) && (SET_DISCHARGE == IS_PURE));
//***discharge*** <-- 

	head = findradius(inflictor.origin, damage+40);
	
	while (head)
	{
		if (head != ignore)
		{
			if (head.takedamage)
			{

				org = head.origin + (head.mins + head.maxs)*0.5;
				points = 0.5*vlen (inflictor.origin - org);
				
				if (points < 0)
					points = 0;
				points = damage - points;

//***discharge*** --> Set up discharge disable
				if (head == attacker)
					points = points * 0.5;
				else if (inflictor.weapon == IT_LIGHTNING) {
					if (SET_DISCHARGE == IS_OFF)
						points = 0;
					else if ((SET_DISCHARGE == IS_PURE) && (!head.waterlevel))
						points = 0;
				}
//***discharge*** <--

				if (points > 0) {
					if (CanDamage (head, inflictor)) {
						T_Damage (head, inflictor, attacker, points);
					}
				}
			}
		}
		head = head.chain;
	}
};


/* Added for CTF+
 * When shooting lightning into water, while not in water,
 * players in water will take a small amount of damage.
 * ============
 * T_ShootWaterRadiusDamage
 * ============
 */
void(entity inflictor, entity attacker, float damage, float radius, entity ignore) T_ShootWaterRadiusDamage =
{
        local   float   points;
        local   entity  head;
        local   vector  org;

        head = findradius(inflictor.origin, radius);

        while (head)
        {
                if (head != ignore)
                {
                        if ((head.takedamage) && (head.waterlevel > 0))
                        {
                                if (CanDamage (head, inflictor))
                                        T_Damage (head, inflictor, attacker, damage);
                        }
                }
                head = head.chain;
        }
};
/* End */


/*
============
T_BeamDamage
============
*/
void(entity attacker, float damage) T_BeamDamage =
{
	local	float 	points;
	local	entity	head;
	
	head = findradius(attacker.origin, damage+40);
	
	while (head)
	{
		if (head.takedamage)
		{
			points = 0.5*vlen (attacker.origin - head.origin);
			if (points < 0)
				points = 0;
			points = damage - points;
			if (head == attacker)
				points = points * 0.5;
			if (points > 0)
			{
				if (CanDamage (head, attacker))
				{
					if (head.classname == "monster_shambler")						
						T_Damage (head, attacker, attacker, points*0.5);
					else
						T_Damage (head, attacker, attacker, points);
				}
			}
		}
		head = head.chain;
	}
};

// *check*
