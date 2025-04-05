// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterström 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************

float NONSOLIDWALL;

//*check* move to spawn.qc
entity(vector wallorg, float wallangle) SpawnVerticalWall = {
	local entity e, oldself;

	if (!NOSPAWN)
		precache_model ("progs/purewall.mdl");
	
	e = spawn();
	e.classname = "pure_wall";

	e.angles_x = 0;
	e.angles_y = wallangle;

/* debug
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setorigin (self, self.origin);	
	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);
*/

	if (NONSOLIDWALL || FLAG_DEBUG) {
		e.solid = SOLID_TRIGGER;
		e.movetype = MOVETYPE_NONE;
	} else {
		e.solid = SOLID_BBOX;
		e.movetype = MOVETYPE_NONE;
	}

	setorigin(e, wallorg);
	e.model = "progs/purewall.mdl";
	setmodel (e, e.model);

	if (wallangle == 0) {
		setsize (e, '-17 -141 -89', '25 176 475'); // 11 19
		if (FLAG_DEBUG)
			bprint(PRINT_HIGH, "Wallangle 0 set!\n");
	}
	else if (wallangle == 90) {
		setsize (e, '-141 -17 -89', '176 25 475');
		if (FLAG_DEBUG)
			bprint(PRINT_HIGH, "Wallangle 90 set!\n");
	}
	else bprint(PRINT_HIGH, "Same wallangle is not correct!\n");

	e.newflag = NEWFLAG;	
/*
	if (!(NONSOLIDWALL || FLAG_DEBUG)) {
		makestatic(e);
	}
*/
	return e;
};

entity LASTWALL;

void() RemoveLast = {

	remove(LASTWALL);
	bprint(PRINT_HIGH, "removed last wall\n");
};

void() SpawnWallAtPlayer = {
	local float x;
	local vector v;
	local string tp;
	x = self.angles_y;




	if ((-180 <= x) && (x <= -135)) x = 0;
	else if ((-135 <= x) && (x <= -45)) x = 90;
	else if ((-45 <= x) && (x <= 45)) x = 0;
	else if ((45 <= x) && (x <= 135)) x = 90;
	else if ((135 <= x) && (x <= 180)) x = 0;

	tp = ftos(x);
	bprint(PRINT_HIGH, "angle: ");
	bprint(PRINT_HIGH, tp);
	bprint(PRINT_HIGH, "\n");
	

	v = self.origin;
	v_z = v_z + 32;  

	NONSOLIDWALL = 1;
	LASTWALL = SpawnVerticalWall(v, x);
	bprint(PRINT_HIGH, "Spawned vertical wall\n");
	
};



void() ArenaStart = {
	UnFreeze(FREEZE_PLAYERS);
	bprint(PRINT_HIGH, "Round Started!\n");

};

void() ArenaPreStart = {
	local entity e;
	local float x;
	local string tp, s1, s2, s3;

	RedCaps = 0;
	BlueCaps = 0;

	if (CLANARENAWINS) {
		if ((RedWins >= CLANARENAWINS) || (BlueWins >= CLANARENAWINS)) {
			e = PLAYER_CHAIN;
			while(e) {
				e.classname = "notready";
				e.player_flag = e.player_flag | (PF_KILLMERESTART);
				UnsetObserver(e);
				e = e.clientchain;
			}
			FLAG_STANDBY = 1;
			return;
		}
	}
	StartCountDown(5, ArenaStart, "Next round will start\nafter the countdown\n\n"); // *check*

	e = PLAYER_CHAIN;
	while (e) {
		e.player_flag = e.player_flag | (PF_KILLMERESTART);
		UnsetObserver(e);
		e = e.clientchain;
	}
	if (FLAG_CTF)
		Freeze(FREEZE_PLAYERS);
	else
		Freeze(FREEZE_WEAPONS);
	RespawnAllRunes();
	TeamCaptureRegenFlags();
	GLOBAL_UPDATE = time;
};


void() ArenaReport = {

	local string s1,s2,s3;

	if (CLANARENAWINS) {
		if (RedWins >= CLANARENAWINS) {
			bprint(PRINT_HIGH, "ÒÅÄ team wins!\n");
			return;
		} else if (BlueWins >= CLANARENAWINS) {
			bprint(PRINT_HIGH, "ÂÌÕÅ team wins!\n");
			return;
		}
	}


	if (RedWins > BlueWins) {
		s1 = "ÒÅÄ leads";
		s2 = getnum(RedWins - BlueWins);
		s3 = getnum(CLANARENAWINS - RedWins);
	} else 	if (RedWins < BlueWins) {
		s1 = "ÂÌÕÅ leads";
		s2 = getnum(BlueWins - RedWins);
		s3 = getnum(CLANARENAWINS - BlueWins);
	} else {
		s1 = "The teams are tied ";
		s2 = getnum(RedWins);
		s3 = getnum(CLANARENAWINS - RedWins);
	}
	bprint(PRINT_HIGH, s1);
	bprint(PRINT_HIGH, " with ");
	bprint(PRINT_HIGH, s2);
	bprint(PRINT_HIGH, " wins");
	if (CLANARENAWINS) {
		bprint(PRINT_HIGH, " and needs ");
		bprint(PRINT_HIGH, s3);
		bprint(PRINT_HIGH, " more for victory.\n"); 
	} else {
		bprint(PRINT_HIGH, ".\n");
	}
};


entity LASTARENASPOT;

entity() ArenaSpawn = {
	local entity spot;
	if (FLAG_CTF) {
		spot = TeamCaptureSpawn();
		if (spot)
			return spot;
	}		
	spot = find(LASTARENASPOT, classname, "info_teleport_destination");
	if (!spot) 
		spot = find(world, classname, "info_teleport_destination");
	if (!spot)
		spot = SelectSpawnPoint();
	return spot;
};


entity ARENAQUE;

void(entity pl) PutinQue ={
	local entity e,f;
	e = spawn();
	e.owner = pl;
	e.oldenemy = world;
	if (!ARENAQUE) {
		ARENAQUE = e;
		return;
	} 
	f = ARENAQUE;
	while (f.oldenemy)
		f = f.oldenemy;
	f.oldenemy = e;
};

entity() GetfromQue = {
	local entity e, f;
	if (!ARENAQUE)
		return world;
	e = ARENAQUE;
	ARENAQUE = ARENAQUE.oldenemy;
	f = e.owner;
	remove(e);
	if (f.player_flag & PF_GHOST)
		return world;
	return f;
};

void() StartArena = {
	UnFreeze(FREEZE_PLAYERS);
	bprint(PRINT_HIGH, "Match started!\n");
	RespawnAllRunes();
	FLAG_STANDBY = FALSE;
};

float(entity pl) IsArenaPlayer = {
	if (pl == ARENAPLAYER1)
		return 1;
	else if (pl == ARENAPLAYER2)
		return 1;
	else 
		return 0;
};

void(entity pl) RemoveFromArenaPlayers = {
	if (pl == ARENAPLAYER1)
		ARENAPLAYER1 = world;
	if (pl == ARENAPLAYER2)
		ARENAPLAYER2 = world;
};

float() ArenaHasPlayers = {
	if (!ARENAPLAYER1 || !ARENAPLAYER2)
		return 0;
	else
		return 1;
};

void() ClanArenaThink = {
	local float r,b;
	local entity e;
	
	if (localinfo("pstart", 0)) {
		localcmd("localinfo pstart \"\"\n");
		localcmd("serverinfo pstart \"\"\n");
		ArenaPreStart();
	}


	// *check* Detta kan inte vara korrekt?
	if (((TEAM1 == 0) || (TEAM2 == 0)) && !(FORCEBLUEWIN || FORCEREDWIN))
  		return;

	e = PLAYER_CHAIN;
	while (e) {	
		if ((e.deadflag == DEAD_NO) && !IsObserver(e)) {
			if ((e.steam == TEAM_COLOR1))
				r = r + 1;
			else
				b = b + 1;
		}
		e = e.clientchain;
	}

	if (((r == 0) || (BlueCaps == 1) || FORCEBLUEWIN) && !FORCEREDWIN) {
		FORCEBLUEWIN = 0;
		bprint(PRINT_HIGH, "BLUE team wins this round\n");
		ArenaPreStart();
		e = PLAYER_CHAIN;
		while ((e != world) && (BlueCaps == 0)) {
			if (e.steam == TEAM_COLOR2)
				e.frags = e.frags + 10;
			e = e.clientchain;
		}
		BlueWins = BlueWins + 1;
		BlueCaps = 0;
		ArenaReport();

	} else if (((b == 0) || (RedCaps == 1) || FORCEREDWIN) && !FORCEBLUEWIN) {
		FORCEREDWIN = 0;
		bprint(PRINT_HIGH, "RED team wins this round\n");
		ArenaPreStart();
		e = PLAYER_CHAIN;
		while ((e != world) && (RedCaps == 0)) {
			if (e.steam == TEAM_COLOR1)
				e.frags = e.frags + 10;
			e = e.clientchain;
		}
		RedWins = RedWins + 1;
		RedCaps = 0;
		ArenaReport();
	}
};

void() ArenaThink = {
	if (!FLAG_ARENA)
		return;
	if (FLAG_COMPETITION) {
		ClanArenaThink();
		return;
	}
	if (ArenaHasPlayers())
		return;
	if (!ARENAPLAYER1) {
		ARENAPLAYER1 = GetfromQue();
		if (ARENAPLAYER1)
			ARENAPLAYER1.player_flag = ARENAPLAYER1.player_flag | (PF_KILLMERESTART);
	}
	if (!ARENAPLAYER2) {
		ARENAPLAYER2 = GetfromQue();
		if (ARENAPLAYER2)
			ARENAPLAYER2.player_flag = ARENAPLAYER2.player_flag | (PF_KILLMERESTART);
	}
	if (!ArenaHasPlayers()) 
		return;

	StartCountDown(15, StartArena, "Next Fight");
	Freeze(FREEZE_WEAPONS_BUT_HOOK);

	SetFreshItems(ARENAPLAYER1);
	SetFreshItems(ARENAPLAYER2);

};


// <-- check
