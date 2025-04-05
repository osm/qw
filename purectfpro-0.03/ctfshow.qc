// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterstrφm 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************


void(float tp, string key, float val) SetVar = {		// *check* move to infovar
	local string tmp;
	tmp = ftos(val);
	if (tp == 0) {
		localcmd("serverinfo ");
		localcmd(key);
		localcmd(" \"\"\n");
		localcmd("localinfo ");
		localcmd(key);
		localcmd(" ");
		localcmd(tmp);
		localcmd("\n");
	} else if (tp == 1) {
		localcmd("localinfo ");
		localcmd(key);
		localcmd(" \"\"\n");
		localcmd("serverinfo ");
		localcmd(key);
		localcmd(" ");
		localcmd(tmp);
		localcmd("\n");
	} else if (tp == 2) {
		cvar_set(key, tmp);
	}
}; 

float(float current, float add, float minval, float maxval, float infotype, string key) CycleInfovar = {
	current = current + add;
	if (current > maxval) current = minval;
	if (current < minval) current = maxval;
	SetVar(infotype, key, current);
	return current;
};

void() ShowdownTimeup =   {
	if (!AccessShowdown() || !AccessNoMatch())
		return; 
	TIMELIMIT = CycleInfovar(TIMELIMIT/60,   5, 0, 35, CVARINFO, "timelimit")*60;
	bprintnumoff("Timelimit ", TIMELIMIT/60);
};
void() ShowdownTimedown = { 
	if (!AccessShowdown() || !AccessNoMatch())
		return; 
	TIMELIMIT = CycleInfovar(TIMELIMIT/60,  -5, 0, 35, CVARINFO, "timelimit")*60; 
	bprintnumoff("Timelimit ", TIMELIMIT/60);
};

void() ShowdownFragsup = {
	if (!AccessShowdown() || !AccessNoMatch())
		return; 
	FRAGLIMIT = CycleInfovar(FRAGLIMIT,   50, 0, 250, CVARINFO, "fraglimit");
	bprintnumoff("Fraglimit ", FRAGLIMIT);
};
void() ShowdownFragsdown = {
	if (!AccessShowdown() || !AccessNoMatch())
		return; 
	FRAGLIMIT = CycleInfovar(FRAGLIMIT,  -50, 0, 250, CVARINFO, "fraglimit");
	bprintnumoff("Fraglimit ", FRAGLIMIT);
};

void() ShowdownTP = {		
	if (!AccessShowdown() || !AccessNoMatch())
		return; 

	local float oldtp, newtp;
	local string tmp;
	if (FLAG_CTF) {
		oldtp = TEAMPLAY;
		newtp = oldtp - (oldtp & 15);
		if (oldtp & 1) {			//TEAM_HEALTH_PROTECT) 
			newtp = newtp | 4;		//TEAM_FRAG_PENALTY | TEAM_ATTACKER_DAMAGE
			bprint(PRINT_HIGH, "TP4: Mirror damage.\n");	
		} else if (oldtp & 4) {			//TEAM_ATTACKER_DAMAGE
			newtp = newtp | 8; 		//TEAM_FRAG_PENALTY
			bprint(PRINT_HIGH, "TP2: Frag penalty.\n");
		} else {
			newtp = newtp | 1 | 2;		// TEAM_HEALTH_PROTECT | TEAM_ARMOR_PROTECT;
			bprint(PRINT_HIGH, "TP3: Hurtself. (standard ctf)\n");
		}
		TEAMPLAY = newtp;
	} else {
		oldtp = realteamplay;
		newtp = oldtp - (oldtp & 15);
		if ((oldtp  & 15) == 0) {		 
			newtp = newtp + 1;	
			bprint(PRINT_HIGH, "TP1: Nohurt.\n");	
			TEAMPLAY = 3;
		} else if ((oldtp  & 15) == 1) {	
			newtp = newtp + 2; 	
			bprint(PRINT_HIGH, "TP2: Frag penalty.\n");
			TEAMPLAY = 8;
		} else if ((oldtp  & 15) == 2) {	
			newtp = newtp + 3; 	
			bprint(PRINT_HIGH, "TP3: Hurtself.\n");
			TEAMPLAY = 1;
		} else if ((oldtp  & 15) == 3) {	
			newtp = newtp + 4; 	
			bprint(PRINT_HIGH, "TP4: Mirrordamage.\n");
			TEAMPLAY = 4;
		} else {
			bprint(PRINT_HIGH, "TP OFF\n");
			TEAMPLAY = 0;
		}
		realteamplay = newtp;
	}
	SetVar(CVARINFO, "teamplay", newtp);
};

void() ShowdownDM = {
	if (!AccessShowdown() || !AccessNoMatch())
		return; 
	DEATHMATCH = CycleInfovar(DEATHMATCH,   1, 1, 3, CVARINFO, "deathmatch");
	bprintnumoff("Deathmatch ", DEATHMATCH);
};

void() ShowdownPowerup = {
	if (!AccessShowdown() || !AccessNoMatch())
		return; 
	VAR_DISABLEPOWERUPS = CycleInfovar(VAR_DISABLEPOWERUPS, 1, 0, 7, LOCALINFO, "disablepowerups");
	bprint(PRINT_HIGH, "Powerups enabled:");
	if (!(VAR_DISABLEPOWERUPS & BIT_NOQUAD))  bprint(PRINT_HIGH, " Quad"); 
	if (!(VAR_DISABLEPOWERUPS & BIT_NORING))  bprint(PRINT_HIGH, " Ring"); 
	if (!(VAR_DISABLEPOWERUPS & BIT_NOPENTA)) bprint(PRINT_HIGH, " Penta"); 
	if (VAR_DISABLEPOWERUPS == 7)             bprint(PRINT_HIGH, " NONE!"); 
	bprint(PRINT_HIGH, "\n");
	FixPowerups();
	UpdateVariables();
};

void() ShowdownDropRing = {
	if (!AccessShowdown() || !AccessNoMatch())
		return; 
	FLAG_DROPRING = CycleInfovar(FLAG_DROPRING, 1, 0, 1, LOCALINFO, "dr");
	bprintonoff("Dropring ", FLAG_DROPRING);
};

void() ShowdownDropQuad = {
	if (!AccessShowdown() || !AccessNoMatch())
		return; 
	FLAG_DROPQUAD = CycleInfovar(FLAG_DROPQUAD, 1, 0, 1, LOCALINFO, "dq");
	bprintonoff("Dropquad ", FLAG_DROPQUAD);
};
void() ShowdownTossRune = {
	if (!AccessShowdown() || !AccessNoMatch())
		return; 
	FLAG_TOSSRUNE = CycleInfovar(FLAG_TOSSRUNE, 1, 0, 1, LOCALINFO, "tr");
	bprintonoff("Tossrune ", FLAG_TOSSRUNE);
};

void() ShowDownTossflag = {
	if (!AccessShowdown() || !AccessNoMatch())
		return; 
	FLAG_TOSSFLAG = CycleInfovar(FLAG_TOSSFLAG, 1, 0, 1, LOCALINFO, "tf");
	bprintonoff("Tossflag ", FLAG_TOSSFLAG);
};

void() ShowDownAnka = {
	if (!AccessShowdown() || !AccessNoMatch())
		return; 
	DUMMY_ANKAMAPS = CycleInfovar(DUMMY_ANKAMAPS, 1, 0, 1, LOCALINFO, "ankamaps");
	bprintonoff("Anka Maps ", DUMMY_ANKAMAPS);
	SetMapRestart();
};

float() CheckModeChange = {
	// return 1 of not allowed

	if (!AccessNoMatch())
		return 1;
	if (FLAG_ALLOWMODECHANGE & 2) {
		if (!AccessAdmin())
			return 1;
		else
			return 0;
	}
	if (FLAG_ALLOWMODECHANGE & 1) {
		if (!AccessAdmin())
			return 1;
		else if ((self.admin & AD_VOTED) || (self.admin & AD_TINY)) {
			sprint(self, PRINT_HIGH, "you have to be a standard admin to do this.\n");
			return 1;
		} else 
			return 0;
	}
	return (!AccessSuper());
};

void() ShowDownTW = {
	if (CheckModeChange())
		return;
	if (DUMMY_MODE & MODE_TW ) 
		DUMMY_MODE = DUMMY_MODE - (DUMMY_MODE & MODE_TW);
	else 
		DUMMY_MODE = DUMMY_MODE | MODE_TW;
	SetVar(SERVERINFO, "mode", DUMMY_MODE);
	bprintonoff("Thunderwalker ", DUMMY_MODE & MODE_TW);
	SetMapRestart();
};

void() ShowDownCTF = {
	if (CheckModeChange())
		return;
	local float x;
	if (DUMMY_CTF) {
		DUMMY_CTF = 0;
		realteamplay = 3;
		bprint(PRINT_HIGH, "Server mode: Deathmatch\n");
	} else 	{
		DUMMY_CTF = 1;
		realteamplay = 419;
		bprint(PRINT_HIGH, "Server mode: CTF\n");
	}
	SetVar(CVARINFO, "teamplay", realteamplay);
	SetMapRestart();
};

void() ShowDownCompetition = {
	if (CheckModeChange())
		return;
	if ((DUMMY_MODE & MODE_SHOWDOWN)) {
		bprint(PRINT_HIGH, "Competition Mode: OFF\n");
		DUMMY_MODE = DUMMY_MODE - (DUMMY_MODE & (MODE_COMP | MODE_SHOWDOWN));
	} else if ((DUMMY_MODE & MODE_COMP)) {
		bprint(PRINT_HIGH, "Competition Mode: Showdown\n");
		DUMMY_MODE = DUMMY_MODE | (MODE_COMP | MODE_SHOWDOWN);
	} else {
		bprint(PRINT_HIGH, "Competition Mode: ON\n");
		DUMMY_MODE = DUMMY_MODE | (MODE_COMP);
		DUMMY_MODE = DUMMY_MODE - (DUMMY_MODE & (MODE_SHOWDOWN));
	}
	SetVar(SERVERINFO, "mode", DUMMY_MODE);
	SetMapRestart();
};

void() ShowDownArena = {
	if (CheckModeChange())
		return;
	if ((DUMMY_MODE & MODE_ARENA)) {
		bprint(PRINT_HIGH, "Arena Mode: OFF\n");
		DUMMY_MODE = DUMMY_MODE - (DUMMY_MODE & MODE_ARENA);
	} else {
		bprint(PRINT_HIGH, "Arena Mode: ON\n");
		DUMMY_MODE = DUMMY_MODE | MODE_ARENA;
	}
	SetVar(SERVERINFO, "mode", DUMMY_MODE);
	SetMapRestart();
};

void() ShowDownSpectalk = {
	if (!AccessShowdown())
		return; 
	FLAG_AUTOSPECTALK = CycleInfovar(FLAG_AUTOSPECTALK, 1, 0, 1, LOCALINFO, "autospectalk");
	bprintonoff("Automatic spectalk for matches ", FLAG_AUTOSPECTALK);
	localcmd("sv_spectalk 1\n");
};

void() ShowDownMaxspecs = {
	if (!AccessShowdown())
		return; 
	local float x;
	x = localinfo("default_maxspecs", 8);
	MAXSPECS = CycleInfovar(MAXSPECS, 1, 0, x, CVARINFO, "maxspectators");
	bprintnumoff("Spectators ", MAXSPECS);
};

void() ShowdownMaxspeed = {
	if (!AccessShowdown())
		return; 
	if (SV_MAXSPEED == 320)
		SV_MAXSPEED = 360;
	else if (SV_MAXSPEED == 360)
		SV_MAXSPEED = 375;
	else if (SV_MAXSPEED == 375)
		SV_MAXSPEED = 400;
	else
		SV_MAXSPEED = 320;
	bprintnum("SV_Maxspeed ", SV_MAXSPEED);
	SetVar(CVARINFO, "sv_maxspeed", SV_MAXSPEED);
};


void() ShowdownDischarge = {
	if (!AccessShowdown() || !AccessNoMatch())
		return; 
	SET_DISCHARGE = CycleInfovar(SET_DISCHARGE, 1, 0, 2, LOCALINFO, "discharge");
	if (SET_DISCHARGE == 0)      bprint(PRINT_HIGH, "Discharges on. (Only in water.)\n");
	else if (SET_DISCHARGE == 1) bprint(PRINT_HIGH, "Discharges off.\n");
	else if (SET_DISCHARGE == 2) bprint(PRINT_HIGH, "Discharges on. (Above water too.)\n");
};
void() ShowdownRunes = {
	if (!AccessShowdown() || !AccessNoMatch())
		return; 
	if (!FLAG_HOOK) {
		bprint(PRINT_HIGH, "Runes not precached. To use you must enable CTF or set EXTRAS 8.\n");
		return;
	}
	SET_RUNES = CycleInfovar(SET_RUNES, 1, 0, 2, LOCALINFO, "runes");
	if (SET_RUNES == 0)      bprint(PRINT_HIGH, "Runes on. (Improved haste from 4.21)\n");
	else if (SET_RUNES == 1) bprint(PRINT_HIGH, "Runes off.\n");
	else if (SET_RUNES == 2) bprint(PRINT_HIGH, "Runes on. (v4.2 haste)\n");
	RespawnAllRunes();
};

void() ShowdownGrapple = {
	if (!AccessShowdown() || !AccessNoMatch())
		return; 
	local entity e;
	if (!FLAG_HOOK) {
		bprint(PRINT_HIGH, "Grapple not precached. To use you must enable CTF or set EXTRAS 4.\n");
		return;
	}
	SET_HOOK = CycleInfovar(SET_HOOK, 1, 0, 3, LOCALINFO, "hook");
	if (SET_HOOK == 0)	bprint(PRINT_HIGH, "Grapple on.\n");
	else if (SET_HOOK == 1) bprint(PRINT_HIGH, "Grapple off.\n");
	else if (SET_HOOK == 2) bprint(PRINT_HIGH, "Grapple on. (with multigrapple bug as v4.2)\n");
	else if (SET_HOOK == 3) bprint(PRINT_HIGH, "Grapple on. (as v4.21)\n");
	e = PLAYER_CHAIN;
	while (e) {
		if (SET_HOOK == IS_OFF)
			e.items = e.items - (e.items & IT_GRAPPLE);
		else
			e.items = e.items | IT_GRAPPLE;
		e = e.clientchain;
	}	
};

void() ShowDownLockAutoDemo = {
	if (!AccessShowdown() || !AccessNoMatch())
		return; 
	FLAG_LOCKAUTODEMO = CycleInfovar(FLAG_LOCKAUTODEMO , 1, 0, 1, LOCALINFO, "lockautodemo");
	bprintonoff("Autodemo lock: ", FLAG_LOCKAUTODEMO);
};

void() ShowDownLockAutoShot = {
	if (!AccessShowdown() || !AccessNoMatch())
		return; 
	FLAG_LOCKAUTOSHOT = CycleInfovar(FLAG_LOCKAUTOSHOT , 1, 0, 1, LOCALINFO, "lockautoshot");
	bprintonoff("Autoshot lock: ", FLAG_LOCKAUTOSHOT);
};


// *check* implementera
void() ShowdownFairStart = {
	if (!AccessShowdown() || !AccessNoMatch())
		return; 
	sprint(self, PRINT_HIGH, "Not implemented yet.\n");
};

void() nosuchmap = {
	sprint(self.owner, PRINT_HIGH, "No Such Map\n");
	remove(self);
};
void(entity pl, string st) DoChangeMap = {
	local string mname;
	local entity e;
	bprint(PRINT_HIGH, pl.netname);
	bprint(PRINT_HIGH, " changed the map to ");
	bprint(PRINT_HIGH, st);
	bprint(PRINT_HIGH, " - \"");
	mname = FindMap(st);
	bprint(PRINT_HIGH, mname);		
	bprint(PRINT_HIGH, "\"\n");
	bprint(PRINT_HIGH, "\n");
	localcmd("map \"");
	localcmd(st);
	localcmd("\"\n");
	e = spawn();
	e.think = nosuchmap;
	e.nextthink = time + 1;
	e.owner = self;
};
void() CheckMapChange = {
	local string st, mname;
	local entity e;

	st = infokey(self, "map");
	if (st != "") {
		unsetinfo(self, "map");
		if ((!AccessShowdown() && !IsTinyAdmin(self)))
			return; 
		if (!AccessNoMatch()) {
			sprint(self, PRINT_HIGH, "Use ΖΟÒΓΕΒÒΕΑΛ to end a match.\n");
			return;
		}
		if (time < 15) {
			sprint(self, PRINT_HIGH, "You can't change map yet.\n");
			return;
		}
		DoChangeMap(self, st);
	}
};


void() MapInfo = {
	if (!AccessShowdown())
		return;
	sprint(self, PRINT_HIGH, "Just type the mapname to change map.\n");
	sprint(self, PRINT_HIGH, "Or use: setinfo map <name>\n");
};

void() ShowMaps = {
	sprint(self, PRINT_HIGH, "Sorry, this function is not implemented.\n");
};

// *check* -->
void(float flag, string def, string var, string default) saveinfo = {
	local string tp;
	if ((infokey(world, def) != "") && !(stof(infokey(world, "resetdefaults")))) 
		return;
	localcmd("localinfo ");
	localcmd(def);
	localcmd(" ");
	tp = infokey(world, var);
	if (tp == "") tp = default;
	localcmd(tp);
	localcmd("\n");
};

void() SaveDefaults = {

	saveinfo(1, "default_timelimit", "timelimit", "20");
	saveinfo(1, "default_fraglimit", "fraglimit", "0");
	saveinfo(1, "default_teamplay", "teamplay", "419");
	saveinfo(1, "default_deathmatch", "deathmatch", "3");
	saveinfo(1, "default_maxspeed", "sv_maxspeed", "320");
	saveinfo(1, "default_maxspecs", "maxspectators", "4");
	saveinfo(1, "default_spectalk", "sv_spectalk", "1");

	saveinfo(0, "default_disablepowerups", "disablepowerups", "0");
	saveinfo(0, "default_dq", "dq", "1");
	saveinfo(0, "default_dr", "dr", "1");
	saveinfo(0, "default_tr", "tr", "1");
	saveinfo(0, "default_tf", "tf", "1");
	saveinfo(0, "default_discharge", "discharge", "0");
	saveinfo(0, "default_hook", "hook", "0");
	saveinfo(0, "default_runes", "runes", "0");
	saveinfo(0, "default_ankamaps", "ankamaps", "0");
	saveinfo(1, "default_fpd", "fpd", "0");

	localcmd("localinfo resetdefaults \"\"\n");
};

void(float flag, string var, string val, string def) restoreinfo = {
	local string tp;
	tp = infokey(world, var);
	if (tp == "") tp = def;
	if (flag)
		localcmd("serverinfo ");
	else
		localcmd("localinfo ");
	localcmd(val);
	localcmd(" ");
	localcmd(tp);
	localcmd("\n");
};


void() SetShowdownDefault = {
	restoreinfo(1, "default_timelimit", "timelimit", "20");
	restoreinfo(1, "default_fraglimit", "fraglimit", "0");
	restoreinfo(1, "default_teamplay", "teamplay", "419");
	restoreinfo(1, "default_deathmatch", "deathmatch", "3");
	restoreinfo(1, "default_maxspeed", "sv_maxspeed", "320");
	restoreinfo(1, "default_maxspecs", "maxspectators", "4");
	restoreinfo(1, "default_spectalk", "sv_spectalk", "1");
	restoreinfo(0, "default_disablepowerups", "disablepowerups", "0");
	restoreinfo(0, "default_dq", "dq", "1");
	restoreinfo(0, "default_dr", "dr", "1");
	restoreinfo(0, "default_tr", "tr", "1");
	restoreinfo(0, "default_tf", "tf", "1");
	restoreinfo(0, "default_discharge", "discharge", "0");
	restoreinfo(0, "default_hook", "hook", "0");
	restoreinfo(0, "default_runes", "runes", "0");
	restoreinfo(0, "default_ankamaps", "ankamaps", "0");
	restoreinfo(1, "default_fpd", "fpd", "0");
	bprint(PRINT_HIGH, "Settings set to default.\n");
};

void() ShowdownDefault = {
	if (!AccessShowdown() || !AccessNoMatch())
		return; 
	SetShowdownDefault();
};

void() AllSettings = {
	if (FLAG_CTF)
		SetVar(CVARINFO, "teamplay", 419);
	else
		SetVar(CVARINFO, "teamplay", 3);
	SetVar(CVARINFO, "fraglimit", 0);
	SetVar(CVARINFO, "timelimit", 20);
	SetVar(CVARINFO, "sv_maxspeed", 320);
	SetVar(LOCALINFO, "disablepowerups", 0);
	SetVar(LOCALINFO, "dq", 1);
	SetVar(LOCALINFO, "dr", 1);
	SetVar(LOCALINFO, "tr", 1);
	SetVar(LOCALINFO, "tf", 0);
	SetVar(LOCALINFO, "discharge", 0);
	SetVar(LOCALINFO, "hook", 0);
	SetVar(LOCALINFO, "runes", 0);
	SetVar(LOCALINFO, "ankamaps", 0);
};

void() SetStandard = {
	if (!AccessShowdown() || !AccessNoMatch()) 
		return;
	AllSettings();
	SetVar(CVARINFO, "sv_maxspeed", 375);
	bprint(PRINT_HIGH, "Settings set to standard Pure CTF.\n");
};

void() Set3wave = {
	if (!AccessShowdown() || !AccessNoMatch()) 
		return;
	AllSettings();
	SetVar(LOCALINFO, "dq", 0);
	SetVar(LOCALINFO, "dr", 0);
	SetVar(LOCALINFO, "tr", 0);
	SetVar(LOCALINFO, "discharge", 2);
	bprint(PRINT_HIGH, "Settings set to Threewave default.\n");
};

void() SetTW = {
	if (!AccessShowdown() || !AccessNoMatch()) 
		return;
	AllSettings();
	SetVar(LOCALINFO, "discharge", 2);
	bprint(PRINT_HIGH, "Settings set to Thunderwalker default.\n");
};

void() Set2on2 = {
	if (!AccessShowdown() || !AccessNoMatch()) 
		return;
	AllSettings();
	SetVar(CVARINFO, "timelimit", 15);
	SetVar(CVARINFO, "sv_maxspeed", 375);
	SetVar(CVARINFO, "deathmatch", 3);
	bprint(PRINT_HIGH, "Settings set to 2on2 default.\n");
};

void() SetOncle = {
	if (!AccessShowdown() || !AccessNoMatch()) 
		return;
	AllSettings();
	SetVar(CVARINFO, "deathmatch", 1);
	SetVar(CVARINFO, "sv_maxspeed", 360);
	bprint(PRINT_HIGH, "Settings set to Oncle Default.\n");
};

void() SetCTFSM = {
	if (!AccessShowdown() || !AccessNoMatch()) 
		return;
	AllSettings();
	bprint(PRINT_HIGH, "Settings set to CTF SM Default.\n");
};

void() CtfshowOptions = {
	sprint(self, PRINT_HIGH, "---- Showdown Match Options -------\n");
	sprint(self, PRINT_HIGH, "τινευπ     : Τινεμινιτ +µ\n");
	sprint(self, PRINT_HIGH, "τινεδοχξ   : Τινεμινιτ -µ\n");
	sprint(self, PRINT_HIGH, "ζςαησυπ    : Ζςαημινιτ +±°\n");
	sprint(self, PRINT_HIGH, "ζςαησδοχξ  : Ζςαημινιτ -±°\n");
	sprint(self, PRINT_HIGH, "δν         : Δεατθνατγθ νοδε\n");
	sprint(self, PRINT_HIGH, "τπ         : Τεανπμαω νοδε\n");
	sprint(self, PRINT_HIGH, "ποχεςυπ    : Τοηημε Ποχεςυπσ\n");
	sprint(self, PRINT_HIGH, "δςοπρυαδ   : Τοηημε Δςοπρυαδ\n");
	sprint(self, PRINT_HIGH, "δςοπςιξη   : Τοηημε Δςοπςιξη\n");
//	sprint(self, PRINT_HIGH, "ζαιςσταςτ  : Τοηημε ζαιςσταςτ\n");
	sprint(self, PRINT_HIGH, "-----------------------------------\n");
};

void() CtfshowCtfopt = {
	sprint(self, PRINT_HIGH, "---- Showdown CTF Options ---------\n");
	sprint(self, PRINT_HIGH, "δισγθαςηε  : Τοηημε Δισγθαςηεσ\n");
	sprint(self, PRINT_HIGH, "ηςαππμε    : Τοηημε Ηςαππμε\n");
	sprint(self, PRINT_HIGH, "ςυξεσ      : Τοηημε Òυξεσ\n");
	sprint(self, PRINT_HIGH, "δςοπςυξε   : Τοηημε Δςοπςυξε\n");
	sprint(self, PRINT_HIGH, "δςοπζμαη   : Τοηημε Δςοπζμαη\n");
	sprint(self, PRINT_HIGH, "ναψσπεεδ   : Τοηημε Ναψσπεεδ\n");
	sprint(self, PRINT_HIGH, "αξλα       : Τοηημε Αξλα Ναπσ\n");
	sprint(self, PRINT_HIGH, "σπεγταμλ   : Σπεγτατος ταμλιξη\n");
	sprint(self, PRINT_HIGH, "ναψσπεγσ   : Ναψσπεγτατοςσ\n");
	sprint(self, PRINT_HIGH, "-----------------------------------\n");
};


void(float proxyflag, string proxytext) ProxyGeneric = {
	local float x;
	local string tp;

	x = stof(infokey(world, "fpd"));
	if (x & proxyflag) {
		if ((infokey(world, "*version") == "2.21"))
		bprint(PRINT_HIGH, "FAQ/QIZMO ");
		bprint(PRINT_HIGH, proxytext);
		if (proxyflag == 16)	bprint(PRINT_HIGH, " disabled.(fpd=");
		else			bprint(PRINT_HIGH, " enabled.(fpd=");
		x = x - (x & proxyflag);
	} else {
		bprint(PRINT_HIGH, "FAQ/QIZMO ");
		bprint(PRINT_HIGH, proxytext);
		if (proxyflag == 16)	bprint(PRINT_HIGH, " enabled.(fpd=");
		else			bprint(PRINT_HIGH, " disabled.(fpd=");
		x = x | proxyflag;
	}
	tp = ftos(x);
	localcmd("serverinfo fpd ");
	localcmd(tp);
	localcmd("\n");
	bprint(PRINT_HIGH, tp);
	bprint(PRINT_HIGH, ")\n");
};

void() PROXYloc = { ProxyGeneric(1, "locations"); };
void() PROXYtimer = { ProxyGeneric(2, "powerup timer"); };
void() PROXYsound = { ProxyGeneric(4, "message sounds"); };
void() PROXYlag = { ProxyGeneric(8, "proxylag"); };
void() PROXYrlag = { ProxyGeneric(16, "report lag"); };
void() PROXYnoe = { ProxyGeneric(32, "%e report"); };
void() PROXYnov = { ProxyGeneric(64, "spec voice"); };

void() PROXYall = { ProxyGeneric(127, "proxy"); };


void() PROXYhelp = {
	local float x, a, b, c, d, e, f, g;
	x = stof(infokey(world, "fpd"));

	a = x & 1; 
	b = x & 2; 
	c = x & 4; 
	d = x & 8; 
	e = x & 16; 
	f = x & 32; 
	g = x & 64; 

	sprint(self, PRINT_HIGH, "---- FAQ/QIZMO commands -----------\n");
	sprint(self, PRINT_HIGH, "πςοψωμογ   : %μ μογατιοξσ\n");
	sprint(self, PRINT_HIGH, "πςοψωτινες : Ποχεςυπ τινες\n");
	sprint(self, PRINT_HIGH, "πςοψωσουξδ : Τςιηηες σουξδσ\n");
	sprint(self, PRINT_HIGH, "πςοψωμαη   : Πςοψω μαη\n");
	sprint(self, PRINT_HIGH, "πςοψωςμαη  : Òεποςτ μαηγθαξηεσ\n");
	sprint(self, PRINT_HIGH, "πςοψωξοε   : Δισαβμε %ε\n");
	sprint(self, PRINT_HIGH, "πςοψωξοφ   : Ξο σπεγ φοιγε\n");
	sprint(self, PRINT_HIGH, "πςοψωαμμ   : Αμμ πςοψω ζυξγτιοξσ ζυξγτιοξσ\n");
	sprint(self, PRINT_HIGH, "---- Proxy Settings ---------------\n");

	PrintOnOff  ( "Μογατιοξσ  :", !a);
	PrintOnOff  (" Τινες      :", !b);

	sprintbreak();
	PrintOnOff  ( "Σουξδσ     :", !c);
	PrintOnOff  (" Πςοψω μαη  :", !d);
	sprintbreak();
	PrintOnOff  ( "μαη ςεποςτσ:",  e);
	PrintOnOff  (" %ε ςεποςτσ :", !f);
	sprintbreak();
	PrintOnOff  ( "Σπεγ φοιγε :", !g);
	sprintbreak();

	sprint(self, PRINT_HIGH, "-----------------------------------\n");
};

void() CtfshowHelp = {
	sprint(self, PRINT_HIGH, "---- CTF Showdown commands --------\n");
	sprint(self, PRINT_HIGH, "οπτιοξσ    : Νατγθ οπτιοξσ\n");
	sprint(self, PRINT_HIGH, "γτζοπτ     : ΓΤΖ οπτιοξσ\n");
	sprint(self, PRINT_HIGH, "πςοψωθεμπ  : Πςοψω οπτιοξσ\n");
	sprint(self, PRINT_HIGH, "δεζαυμτ    : Σετ το δεζαυμτ\n");
	sprint(self, PRINT_HIGH, "θεμπσετ    : Πςεσετ σεττιξησ\n");
	sprint(self, PRINT_HIGH, "---- Other commands: --------------\n");
	sprint(self, PRINT_HIGH, "Change map :  σετιξζο ναπ <ναπξανε>\n");
	sprint(self, PRINT_HIGH, "Become admin: σετιξζο αδνιξ <πασσ>\n");
};

void() HelpSet = {
	// *impulse*
	sprint(self, PRINT_HIGH, "---- Pure CTF preset settings -----\n");
	sprint(self, PRINT_HIGH, "σταξδαςδ   : Σταξδαςδ\n");
	sprint(self, PRINT_HIGH, "³χαφε      : Τθςεεχαφε\n");
	sprint(self, PRINT_HIGH, "²οξ²       : ²οξ²\n");
	sprint(self, PRINT_HIGH, "---- Tournament Settings ----------\n");
	sprint(self, PRINT_HIGH, "οξγμε      : Οξγμε\n");
	sprint(self, PRINT_HIGH, "γτζσν      : ΓΤΖ ΣΝ\n");
	sprint(self, PRINT_HIGH, "-----------------------------------\n");
};

void() ShowdownImpulses = {

	if (!AccessShowdown()) {
		return;

	} else if (self.impulse == 112) {
		CtfshowOptions();
	} else if (self.impulse == 113) {
		CtfshowCtfopt();
	} else if (self.impulse == 111) {
		// *check* fixa snyggare
		CtfshowHelp();
		sprint(self, PRINT_HIGH, "-----------------------------------\n");
	} else if (self.impulse == 139) {
		ShowDownSpectalk();
	} else if (self.impulse == 136) {
		ShowDownMaxspecs();
	} else if (self.impulse == 109) {
		PROXYhelp();
	} else if (self.impulse == 101) {
		PROXYloc();
	} else if (self.impulse == 102) {
		PROXYtimer();
	} else if (self.impulse == 103) {
		PROXYsound();
	} else if (self.impulse == 104) {
		PROXYlag();
	} else if (self.impulse == 105) {
		PROXYall();
	} else if (self.impulse == 106) {
		PROXYrlag();
	} else if (self.impulse == 107) {
		PROXYnov();
	} else if (self.impulse == 108) {
		PROXYnoe();
	} else if (self.impulse == 114) {
		HelpSet();
	} else if (self.impulse == 121) {
		ShowdownTimeup();
	} else if (self.impulse == 122) {
		ShowdownTimedown();

	} else if (!AccessNoMatch()) {
		return;
	} else if (self.impulse == 123) {
		ShowdownFragsup();
	} else if (self.impulse == 124) {
		ShowdownFragsdown();
	} else if (self.impulse == 125) {
		ShowdownDM();
	} else if (self.impulse == 126) {
		ShowdownTP();
	} else if (self.impulse == 127) {
		ShowdownPowerup();
	} else if (self.impulse == 128) {
		ShowdownDropQuad();
	} else if (self.impulse == 129) {
		ShowdownDropRing();
	} else if (self.impulse == 130) {
		ShowdownFairStart();
	} else if (self.impulse == 137) {
		ShowdownDischarge();
	} else if (self.impulse == 131) {
		ShowdownGrapple();
	} else if (self.impulse == 132) {
		ShowdownRunes();
	} else if (self.impulse == 133) {
		ShowdownTossRune();
	} else if (self.impulse == 138) {
		ShowDownTossflag();
	} else if (self.impulse == 134) {
		ShowdownMaxspeed();
	} else if (self.impulse == 135) {
		ShowDownAnka();
	
	// Settings
	} else if (self.impulse == 151) {
		ShowdownDefault();
	} else 	if (self.impulse == 152) {
		SetStandard();
	} else if (self.impulse == 153) {
		Set3wave();
	} else if (self.impulse == 154) {
		Set2on2();
	} else if (self.impulse == 155) {
		SetOncle();
	} else if (self.impulse == 156) {
		SetCTFSM();
	//
	}
};

