
//
// Pure: optimized to save the fields .boom and .times
//
//


vector(float dm) VelocityForDamage;
void(string gibname, float dm) ThrowHead;

//Thunderwalker boom code

void() makeboom=
{

        T_RadiusDamage (self, self.owner, 95, world);
        
        WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
        WriteByte (MSG_MULTICAST, TE_EXPLOSION);
        WriteCoord (MSG_MULTICAST, self.origin_x);
        WriteCoord (MSG_MULTICAST, self.origin_y);
        WriteCoord (MSG_MULTICAST, self.origin_z);
        multicast (self.origin, MULTICAST_PHS);
 
        remove (self);
};

// thunderWalker: just the id gib code snarked for our use

void(string gibname, float dm) boomer=
{
        local   entity new;
        
        new = spawn();
        new.origin = self.origin;
	new.owner = self;   
        setmodel (new, "progs/gib3.mdl");
        setsize (new, '0 0 0', '0 0 0');
        new.velocity = VelocityForDamage (dm);   
        new.movetype = MOVETYPE_BOUNCE;
        new.solid = SOLID_BBOX;
        new.avelocity_x = random()*600;
        new.avelocity_y = random()*600;
        new.avelocity_z = random()*600;
        new.think = makeboom;
        new.ltime = time;
        new.nextthink = time + 1 + random()*3;
        new.frame = 0;
        new.flags = 0; 
};

void() rittierodt = {
	ThrowHead("progs/h_player.mdl", self.health);
	boomer("progs/gib3.mdl", self.health);
	boomer("progs/gib3.mdl", self.health);
	boomer("progs/gib3.mdl", self.health);
	boomer("progs/gib3.mdl", self.health);
	boomer("progs/gib3.mdl", self.health);
	boomer("progs/gib3.mdl", self.health);
	self.deadflag = DEAD_DEAD;
};

void() hayden = {
	local float dam;
	dam = 85 + self.ammo_rockets;
	self.ammo_rockets = 0;

	T_RadiusDamage (self, self, dam, world);
	//sound (self, CHAN_BODY, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.twflags & TW_KILLING;
	
	
	
// *obsolete*	self.times = 5;
	self.twflags = self.twflags | (5);


	self.health = -50;
	PlayerDie();
	if (FLAG_DEBUG) 
		bprint(PRINT_HIGH, "HAYDEN!\n");
};

void() do_tw_action = {
	self.owner.twflags = self.owner.twflags | (self.twflags);
	remove (self);
};

//
// Clear any delayed actions
//
void() RemoveDelayedActions = {
	local entity e;
	e = find(world, classname, "twaction");
	while (e) {
		if (e.owner == self)
			remove(e);	
		e = find(e, classname, "twaction");
	}
};

//
// Do an action in a moment. (If the player lives)
//
void(float actiondelay, float bit2set) TWDelayedAction = {
	local entity e;
	e = spawn();
	e.classname = "twaction";
	e.owner	= self;
	e.think = do_tw_action;
	e.nextthink = time + actiondelay;
	e.twflags = bit2set;
};

//
// Check for TW Boom impulse.
//
void() StartBoom = {
 	if (!(self.twflags & TW_TIMES) && !(gamestart)) {
		if (self.invincible_finished > time) {
			sound (self, CHAN_AUTO, "doors/basetry.wav", 1, ATTN_NORM);
			centerprint(self, "Not while 666\nThat would be silly!");
		} else {
			sound (self, CHAN_BODY, "tw/suicide2.wav", 1, ATTN_NORM);

// fixed to reuse field				self.boom = time + 3;
			TWDelayedAction(3, TW_BOOMFLAG);
		}
	} else {
		sound (self, CHAN_AUTO, "doors/basetry.wav", 1, ATTN_NORM);
		centerprint (self, "You cannot Kamakazi...yet!");
	}
};


// <-- check
