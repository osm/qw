// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterström 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************

void(entity pl, float newspeed) SetSpeed = {
        if (!IsClient(pl))
                return;
	if (pl.maxspeed != newspeed)
		pl.maxspeed = newspeed;
};
void(entity pl, float newgravity) SetGravity = {
        if (!IsClient(pl))
                return;
	if (pl.gravity != newgravity) {
		pl.gravity = newgravity;
		if (!newgravity)
			pl.oldorigin = pl.origin;

	}
};


void(entity pl) FreezeGravity = {
	if (pl.gravity) {
		if (!pl.setgrav) {		// *optimize* setgrav til bit
			pl.setgrav = time + 0.5;
		} else if (time > pl.setgrav) {
			SetGravity(pl, 0);
			pl.setgrav = 0;
		}
	}
};
void(entity pl) UnfreezeGravity = {
	pl.setgrav = 0;
	SetPlayerSpeed(pl);
};


void(entity pl) SetPlayerSpeed = {
	local float spd;
	if (FREEZEFLAGS & FREEZE_MOVEMENT) {
		SetSpeed(pl, 0);
	} else {
		spd = SV_MAXSPEED;
		if (pl.runes & ITEM_RUNE3_FLAG)
			if (SET_RUNES == IS_PURE)
				spd = spd * HASTESPEED;
		if (FLAG_RLJUMPCTF && self.player_flag & PF_GOTFLAG)
			spd = 0;
		SetSpeed(pl, spd);
	}
	if (FREEZEFLAGS & FREEZE_GRAVITY)
		SetGravity(pl, 0);
	else
		SetGravity(pl, 1);
};

void() UpdateMaxSpeeds = {
	TraversePlayers(SetPlayerSpeed);
};

void(float what) Freeze = {
	if ((what & FREEZE_WORLD) && !(FREEZEFLAGS & FREEZE_WORLD)) {
		FREEZETIME = time;
		FreezeItems();
	}
	FREEZEFLAGS = FREEZEFLAGS | what;
	UpdateMaxSpeeds();
};

void(float what) UnFreeze = {
	if ((what & FREEZE_WORLD) && (FREEZEFLAGS & FREEZE_WORLD)) {
		UnFreezeItems();
	}
	FREEZEFLAGS = FREEZEFLAGS - (FREEZEFLAGS & what);
	UpdateMaxSpeeds();
};

void() DoPause = {

// *check* kolla att det inte händer när det inte ska hända. spara gamla freeze också. Frys Endtime?

/*    *check*
//	if (RESTART || EndCountDown)
//		return;

	if (!FREEZE) {
		if (FLAG_STANDBY)
			FreezePlayers();
		else
			FreezeAll();
		bprint(PRINT_HIGH, "Game paused");
		FREEZE = 1;
	} else {
		if (FLAG_STANDBY)
			UnFreezePlayers();
		else
			UnFreezeAll();
		bprint(PRINT_HIGH, "Game restarted");
		FREEZE = 0;
	}
	if (!FLAG_STANDBY) {
		bprint(PRINT_HIGH, " at ");
		PrintTime2All();
	}
	bprint(PRINT_HIGH, "! ");
	if (!FREEZE) {
		bprint(PRINT_HIGH, "(paused ");
		PrintTime2All();
		bprint(PRINT_HIGH, ")");
	}
	bprint(PRINT_HIGH, "\n");
*/
};


void() ToggleFreeze = {
/* *check* kolla mot olika freezar
	if (RESTART || EndCountDown)
		return;

	if (!FREEZE) {
		if (!IsAdmin(self)) {
			if (FindFirstAdmin())
				sprint(self, PRINT_HIGH, "Ask the admin to pause the game\n");
			else if (PAUSES_BYVOTE)
				StartVote(" wants to pause the game. ", 4);
			else
				sprint(self, PRINT_HIGH, "Pauses disabled.\n");
		} else 	if (PAUSES_DISABLE && !IsSuperAdmin(self))
			sprint(self, PRINT_HIGH, "Pauses disabled.\n");
		else
			DoPause();
	} else {
		if (IsAdmin(self))
			DoPause();
		else if (FindFirstAdmin())
			sprint(self, PRINT_HIGH, "Ask the admin to unpause.\n");
		else
			StartVote(" wants to unpause the game. ", 4);
	}
*/
};

float() FreezeThink = {
	if (FREEZEFLAGS & FREEZE_WORLD) {
		self.lastupdate = time - FREEZETIME;
		return 1;
	} else {
		return 0;
	}
};

void() FreezeItems = {
	local entity e;
	e = nextent(world);
	while(e) {
		e.freezevelocity = e.velocity;
		e.velocity = '0 0 0';
		if ((e.movetype == MOVETYPE_TOSS) || (e.movetype == MOVETYPE_BOUNCE) || (e.movetype == MOVETYPE_BOUNCEMISSILE)) {
			e.oldmovetype = e.movetype;
			e.movetype = MOVETYPE_NONE;
		} else {
			e.oldmovetype = MOVETYPE_NONE;
		}
		e.lastupdate = 0;
		e = nextent(e);
	}
};

void() UnFreezeItems = {
	local entity e;
	local float frozetime;
	local string tp;
	frozetime = time - FREEZETIME;
	e = nextent(world);
	while(e) {
		// Revive and correctly delay all important thinks
		if ((e.think == SUB_regen) || (e.think == GrenadeExplode) || (e.think == RuneRespawn) || (e.think == SUB_Remove)) {
			if (e.nextthink > time) {
				e.nextthink = e.nextthink + frozetime;
			} else {
				e.nextthink = time + e.lastupdate;
			}
		}
		if ((e.think == SUB_CalcMoveDone))	{
			if (e.nextthink > e.ltime) {
				e.nextthink = e.nextthink + frozetime;
			} else {
				e.nextthink = e.ltime + e.lastupdate;
			}
		}
		// Unfreeze movement
		e.velocity = e.freezevelocity;
		e.freezevelocity = '0 0 0';
		if (e.oldmovetype)
			e.movetype = e.oldmovetype;
		e.oldmovetype = MOVETYPE_NONE;
		e = nextent(e);
	}
	// Fix powerups remaining time ***
	e = find(world, classname, "player");
	while(e) {
		if (e.radsuit_finished) e.radsuit_finished = e.radsuit_finished + frozetime;
		if (e.invincible_finished) e.invincible_finished = e.invincible_finished + frozetime;
		if (e.invisible_finished) e.invisible_finished = e.invisible_finished + frozetime;
		if (e.super_damage_finished) e.super_damage_finished = e.super_damage_finished + frozetime;
		e.air_finished = e.air_finished + frozetime;
		e.pain_finished = e.pain_finished + frozetime;
		e = find(e, classname, "player");
	}
	if (!FLAG_STANDBY) {			// *check* under countdown då?
		RED_PICKUP = RED_PICKUP + frozetime;
		BLUE_PICKUP = BLUE_PICKUP + frozetime;

		e = find(world, classname, "item_flag_team1");
		e.super_time = e.super_time + frozetime;
		e = find(world, classname, "item_flag_team2");
		e.super_time = e.super_time + frozetime;


		AddFrozetime(frozetime);
	}
};

