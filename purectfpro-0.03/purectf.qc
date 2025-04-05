// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterstrˆm 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************

// =================
//     CONSTANTS
// =================
float TEAM_COLOR1       =       4;
float TEAM_COLOR2       =       13;
float FLAG_TOSSED = 4;

// =================
//     VARIABLES
// =================
float nexttimercheck;			// Next Time to write countdowntimer
float GLOBAL_UPDATE;			// Time set for global update
float paused;				// obsolete?
float READY, NOTREADY;			// Number of players ready and not ready
float blink;				// Blink hack
float blinktime;			// Blink hack
float RED_PICKUP, BLUE_PICKUP; 		// Timing captures
	// <--
float lastred, lastblue;		// **debug ->> obsolete?
float teamscr1;				// team 1's teamscr score
float teamscr2;				// team 2's teamscr score
// PCP dyna - MOTD
string motdbegin, motd1, motd2, motd3, motd4, motd5, motdend, motdred, motdblue, motdexit;
// PCP //
// obsolete? entity SpawnChain;			

// =================
//      FIELDS  
// =================


// =================
//     FUNCTIONS
// =================
void() SpawnCTFMaps;


void(string newmap) ChangeMap = {
	local float x;
	local string mname;
	bprint(PRINT_HIGH, "Next map is: ");
	bprint(PRINT_HIGH, newmap);
	bprint(PRINT_HIGH, " - \"");
	mname = FindMap(newmap);
	bprint(PRINT_HIGH, mname);		
	bprint(PRINT_HIGH, "\" ");

	x = cvar("samelevel");
	if (FLAG_VOTEEXIT && (x != 1) && !FLAG_COMPETITION) {
		bprint(PRINT_HIGH, " Type ÷œ‘≈≈ÿ…‘ to skip this map.");
	}
	bprint(PRINT_HIGH, "\n");
	changelevel(newmap);
};


void() RestartSameMap = {
	// *check* gˆr en delay och check
	bprint(PRINT_HIGH, "\nDetected changes, restarting map\n");
	ChangeMap(mapname);
};


void() tagline = {
	sprint(self, PRINT_HIGH, " –’“≈ √‘∆ ˆ±Æππ‚ÂÙ·¥ ‚˘ ÕÂÙË·‚ÔÏ\n http://purectf.solgames.com/\n");
};


// PCP dyna - Version
void(entity pl) PrintAbout = {
	sprint(pl, PRINT_HIGH, "\n-------------------------------------\n");
	sprint(pl, PRINT_HIGH, "PureCTF Pro 0.03 build 20040614\n");
	sprint(pl, PRINT_HIGH, "by ‰˘Ó· & »Ú⁄\n");
	sprint(pl, PRINT_HIGH, "http://purectfpro.quakeworld.nl/\n");
	sprint(pl, PRINT_HIGH, "Based on Pure CTF by Methabol\n");
	sprint(pl, PRINT_HIGH, "-------------------------------------\n");
};
// PCP //

void(entity pl, void() func) WithSelf = {
        local entity e;
        e = self;
        self = pl;
        func();
        self = e;
};

/*
=========
PrintRight

Prints a num, right aligned, to self.
=========
*/
void(entity e, float x) PrintRight = {
	local string tmp;
	tmp = ftos(x);
	if (x < 10000) sprint(e, PRINT_HIGH, " ");
	if (x < 1000)  sprint(e, PRINT_HIGH, " ");
	if (x < 100)   sprint(e, PRINT_HIGH, " ");
	if (x < 10)    sprint(e, PRINT_HIGH, " ");
	if (x = 0)     sprint(e, PRINT_HIGH, "0");
	sprint(e, PRINT_HIGH, tmp);
};

float (entity pl) IsClassPlayer = {
        if (pl.classname == "player")
                return 1;
        if (pl.classname == "ready")
                return 1;
        if (pl.classname == "notready")
                return 1;
        if (pl.classname == "observer")
                return 1;
        return 0;

};      

float (entity pl) IsClient = {
        if (pl.classname == "player")
                return 1;
	if (pl.classname == "observer")
		return 1;
        if (pl.classname == "spectator")
                return 1;
        if (pl.classname == "ready")
                return 1;
        if (pl.classname == "notready")
                return 1;
        return 0;
};





void(entity pl) StuffRandomnum = {
	local float x;
	local string tp;
	x = floor(10 * random());
	tp = ftos(x);
	stuffcmd(pl, tp);
};

//
// Check if the player should start/stop recording and return 1 for proxy 
// recording and 2 for QW recording.
//
float (entity pl) CheckAutoDemo = {
	local float demoflag;	
	demoflag = pl.pure & SETINFO_AUTODEMO;
	if ((demoflag == 0) && !FLAG_LOCKAUTODEMO)
		return 0;
	if (!FLAG_COMPETITION && (demoflag != SETINFO_AUTODEMO_ALWAYS)) 
		return 0;
	// Check for type
	if (demoflag == SETINFO_AUTODEMO_PROXY)
		if (HaveDemoProxy(pl))
			return 1;
	if (demoflag == SETINFO_AUTODEMO_QW)
		if (QWVersion() >= 2.20)
			return 2;

	if (HaveDemoProxy(pl))
		return 1;
	if (QWVersion() >= 2.20)
		return 2;
	return 0;
};

//
// Starts an demo for a Client if the Client has turned it on ===s
//
void(entity pl) StartPlayerDemo = {
	local float typeflag;

	typeflag = CheckAutoDemo();
	// Start recording
	if (!typeflag) {
		return;
 	} else if (typeflag == 1) {
		if (FLAG_DEBUG) sprint(self, PRINT_HIGH, "Recording by Proxy\n");
		if (ProxyType(pl) == PROXY_FAQ)
				stuffcmd(pl, "say proxy: record ");
		if (ProxyType(pl) == PROXY_QIZMO)
				stuffcmd(pl, "say .record ");
	} else if (typeflag == 2) {
		if (FLAG_DEBUG) sprint(self, PRINT_HIGH, "Recording by QW\n");
		stuffcmd(pl, "record ");
	}

	stuffcmd(pl, "auto");
	StuffRandomnum(pl);
	StuffRandomnum(pl);
	StuffRandomnum(pl);
	StuffRandomnum(pl);
	stuffcmd(pl, "\n");
	
};
//
// Stops recording for the client.
//
void(entity pl) StopPlayerDemo = {
	local float typeflag;
	typeflag = CheckAutoDemo();
	// Stops recording
	if (!typeflag) {
		return;
	} else if (typeflag == 1) {
		if (ProxyType(pl) == PROXY_FAQ)
				stuffcmd(pl, "say proxy: record stop\n");
		if (ProxyType(pl) == PROXY_QIZMO)
				stuffcmd(pl, "say .record stop\n");
 	} else if (typeflag == 2) {
		stuffcmd(pl, "stop\n");
	}
};


// 
// Starts a demo at matchstart for the players who turned it on.
//
void() AutoDemo = {
	local entity e;
	local float no;
	local string tp;

	e = CLIENT_CHAIN;

	while (e) {
        	StartPlayerDemo(e);
		e = e.clientchain;
	}
};

//
// Stop demos for all players and take Autoshots;
//
void() StopDemos = {
	local entity e;
	local float no;
	local string tp;

	e = CLIENT_CHAIN;
	while (e) {
		StopPlayerDemo(e);
		// Autoshot
		if (!FLAG_STANDBY && FLAG_COMPETITION) {
			if ((e.pure & SETINFO_AUTOSHOT) || FLAG_LOCKAUTOSHOT)
				stuffcmd(e, "+showteamscores;wait;screenshot;wait;-showteamscores\n");
		}
		e = e.clientchain;
		if (FLAG_FUNSOUNDS)
			soundall("fun/gameover");
	
		// *check* funsound
	}
};

void() StopDemosThink = {
	local entity e;
	StopDemos();
	remove(self);
};




void() SetAutoShot = {
	if (self.pure & SETINFO_AUTOSHOT) {
		sprint(self, PRINT_HIGH, "Autoshot disabled\n");	
		self.pure = self.pure - SETINFO_AUTOSHOT;
	} else {
		sprint(self, PRINT_HIGH, "Autoshot enabled.\n");
		self.pure = self.pure | SETINFO_AUTOSHOT;
	}
	SetPureFlags(self);
	PrintNewPlayerSettings();
};

void() SetAutoDemo = {
	local string tp;
	local float x;
	x = (self.pure & SETINFO_AUTODEMO);
	
	if (x == SETINFO_AUTODEMO_PROXY) {
		sprint(self, PRINT_HIGH, "Autodemo with QW:s recording.");	
		if (QWVersion() < 2.20) {
			sprint(self, PRINT_HIGH, " Note, this version of QW doesn't support this.");
		}
		sprint(self, PRINT_HIGH, "\n");	
		x = SETINFO_AUTODEMO_QW;
	} else if (x == SETINFO_AUTODEMO_QW) {
		sprint(self, PRINT_HIGH, "Autodemo always on. (Even on public)\n");	
		x = SETINFO_AUTODEMO_ALWAYS;
	} else if (x == SETINFO_AUTODEMO_ALWAYS) {
		sprint(self, PRINT_HIGH, "Autodemo off\n");	
		x = 0;
	} else {
		sprint(self, PRINT_HIGH, "Autodemo with Proxy. ");
		if (!HaveDemoProxy(self))
			sprint(self, PRINT_HIGH, "(You don't have a demo proxy!)");
		sprint(self, PRINT_HIGH, "\n");
		x = SETINFO_AUTODEMO_PROXY;
	}

	self.pure = self.pure - (self.pure & (SETINFO_AUTODEMO));
	self.pure = self.pure | (x);

	SetPureFlags(self);
	PrintNewPlayerSettings();
};



void(string tp, float x) PrintOnOff = {
	sprint(self, PRINT_HIGH, tp);
	if (x) sprint(self, PRINT_HIGH, "ON ");
	else sprint(self, PRINT_HIGH, "OFF");
};

void(string tp, float x) PrintSetting = {
	sprint(self, PRINT_HIGH, tp);
	sPrintRight(self, x, 3, " "); 
};

void(string tp, float x) PrintSettingOff = {
	sprint(self, PRINT_HIGH, tp);

	if (x) sPrintRight(self, x, 3, " "); 
	else sprint(self, PRINT_HIGH, "---");
};	


void(string tp, float x) PrintPureopt = {
	sprint(self, PRINT_HIGH, tp);
	if (x == IS_PURE)
		sprint(self, PRINT_HIGH, "ON ");	
	else if (x == IS_OFF)
		sprint(self, PRINT_HIGH, "OFF");	
	else if (x == IS_OLD)
		sprint(self, PRINT_HIGH, "OLD");	

};



void() sprintbreak = {
	sprint(self, PRINT_HIGH, "\n");
};

void() PrintSettings = {
	local float a,b,c,d,e,f,g, h;
	local string tp1;

	a = cvar("sv_maxspeed");
	b = FLAG_ANKAMAPS;
	c = ceil(TIMELIMIT / 60);
	d = cvar("sv_friction");
	tp1 = infokey(world , "mode");
	f = cvar("maxspectators");
	g = cvar("sv_spectalk");

	h = stof(infokey(world, "fpd"));

	sprint(self, PRINT_HIGH, "-----------------------------------");

	sprintbreak();
	

	sprint(self, PRINT_HIGH, "”ÂÚˆÂÚÌÔ‰Â : ");
	sprint(self, PRINT_HIGH, tp1);


	sprintbreak();

	PrintOnOff  (  "‘ÔÛÛÚıÓÂ   :", FLAG_TOSSRUNE);
	PrintOnOff  ("  ‘ÔÛÛÊÏ·Á   :", FLAG_TOSSFLAG);

	sprintbreak();

	sprint(self, PRINT_HIGH, "–Ô˜ÂÚıÛ   :");
	if (VAR_DISABLEPOWERUPS & BIT_NOQUAD) sprint(self, PRINT_HIGH, "-");
	else sprint(self, PRINT_HIGH, "Q");
	if (VAR_DISABLEPOWERUPS & BIT_NOPENTA) sprint(self, PRINT_HIGH, "-");
	else sprint(self, PRINT_HIGH, "P");
	if (VAR_DISABLEPOWERUPS & BIT_NORING) sprint(self, PRINT_HIGH, "-");
	else sprint(self, PRINT_HIGH, "R");

	sprint(self, PRINT_HIGH, "  –ÚÔ¯˘      :");
	
	if (h & 1) sprint(self, PRINT_HIGH, "-"); else sprint(self, PRINT_HIGH, "L");
	if (h & 2) sprint(self, PRINT_HIGH, "-"); else sprint(self, PRINT_HIGH, "T");
	if (h & 4) sprint(self, PRINT_HIGH, "-"); else sprint(self, PRINT_HIGH, "S");
	if (h & 8) sprint(self, PRINT_HIGH, "-"); else sprint(self, PRINT_HIGH, "L");
	

	sprintbreak();
	PrintSettingOff(  "‘ÈÌÂÏÈÌÈÙ  :", c);
	PrintSettingOff("  ÊÚ·ÁÏÈÌÈÙ  :", FRAGLIMIT);

	sprintbreak();
	PrintSetting(  "ƒÂ·ÙËÌ·Ù„Ë :", DEATHMATCH);
	PrintOnOff  ("  ¡ÓÎ· Õ·Û  :", b);
	
	sprintbreak();
	PrintOnOff  (  "ƒÚÔÚÈÓÁ   :", FLAG_DROPRING);
	PrintOnOff  ("  ƒÚÔÒı·‰   :", FLAG_DROPQUAD);

	sprintbreak();
	PrintPureopt(  "ƒÈÛ„Ë·ÚÁÂÛ :", SET_DISCHARGE);
	PrintPureopt("  “ıÓÂÛ      :", SET_RUNES);

	sprintbreak();
	PrintPureopt(  "»ÔÔÎ       :", SET_HOOK);
	PrintSetting("  »ÔÔÎÛÂÂ‰  :", HOOKSPEED);

	sprintbreak();
	PrintSetting(  "Õ·¯ÛÂÂ‰   :", a);
	PrintSetting("  ∆ÚÈ„ÙÈÔÓ   :", d);
	
	sprintbreak();
	PrintSetting(  "Õ·¯ÛÂ„Û   :", f);
	PrintOnOff  ("  ”Â„Ù·ÏÎ   :", g);
		
	
	sprint(self, PRINT_HIGH, "\n-----------------------------------\n");
};

// ***update*** <--



/*
==========
MapqueueStatus

Prints the mapqueue into serverinfo
==========
*/
void() MapqueueStatus = {
	local float x, slev;
	local string map1, map2;


        if (FLAG_COMPETITION) {
		localcmd("serverinfo mapqueue \"\"\n");
		return;
	}
	
	slev = cvar("samelevel");
	if (slev == 0) {
		localcmd("serverinfo mapqueue \"Episode Vote\"\n");
	} else if (slev == 1) {
		localcmd("serverinfo mapqueue \"Samelevel\"\n");
	} else if (slev == 2) {
		x = 0;
		map1 = infokey(world, mapname);
		localcmd("serverinfo mapqueue \"");
		while ((map1 != mapname) && (map1 != "") && (x < 8)) {
			localcmd(map1);
			localcmd(" ");
			map1 = infokey(world, map1);
			x = x + 1;
		}
		localcmd(mapname);
		localcmd("\"\n");
		if (map1 == "") 
			localcmd("serverinfo mapqueue \"*BROKEN*\"\n");
	} else if (slev == 3) {
		localcmd("serverinfo mapqueue \"Random\"\n");
	}
};

void() PrintMapqueue = {
	local float x, slev;
	local string map1, map2;
	
	slev = cvar("samelevel");

	if (slev == 0) {
		sprint(self, PRINT_HIGH, "Mapqueue is Episode Vote\n");
	} else if (slev == 1) {
		sprint(self, PRINT_HIGH, "Mapqueue is SAMELEVEL\n");
	} else if (slev == 2) {
		x = 0;
		map1 = infokey(world, mapname);
		sprint(self, PRINT_HIGH, "Õ·ÒıÂıÂ: ");
		while ((map1 != mapname) && (map1 != "") && (x < 50)) {
			sprint(self, PRINT_HIGH, map1);
			sprint(self, PRINT_HIGH, " ");
			map1 = infokey(world, map1);
			x = x + 1;
		}
		sprint(self, PRINT_HIGH, mapname);
		sprint(self, PRINT_HIGH, "\n");
		if ((x == 50) || (map1 == "")) 
			sprint(self, PRINT_HIGH, "Mapqueue is BROKEN\n");
	} else if (slev == 3) {
		sprint(self, PRINT_HIGH, "Random Mapqueue\n");
	}
};




/*
==========
UpdateClientChain

Updates the Client and Player chains.
==========
*/
void() UpdateClientChain = {
	local entity e;
	local entity ch;
	local entity ch_start, pl_start;

	ch = spawn();
	ch_start = ch;
	e = find(world, classname, "spectator");
	while(e) {
		if (!(e.player_flag & PF_GHOST)) {
			ch.clientchain = e;
			ch = e;
		}
		e = find(e, classname, "spectator");
	}
	pl_start = ch;
	e = find(world, classname, "player");
	while(e) {
		if (!(e.player_flag & PF_GHOST)) {
			ch.clientchain = e;
			ch = e;
		}
		e = find(e, classname, "player");
	}
	e = find(world, classname, "ready");
	while(e) {
		if (!(e.player_flag & PF_GHOST)) {
			ch.clientchain = e;
			ch = e;
		}
		e = find(e, classname, "ready");
	}
	e = find(world, classname, "notready");
	while(e) {
		if (!(e.player_flag & PF_GHOST)) {
			ch.clientchain = e;
			ch = e;
		}
		e = find(e, classname, "notready");
	}
	e = find(world, classname, "observer");
	while(e) {
		if (!(e.player_flag & PF_GHOST)) {
			ch.clientchain = e;
			ch = e;
		}
		e = find(e, classname, "observer");
	}
	ch.clientchain = world;

	CLIENT_CHAIN = ch_start.clientchain;
	PLAYER_CHAIN = pl_start.clientchain;
	remove(ch_start);

	// Count players here.
	TEAM1 = 0;
	TEAM2 = 0;
	TOTALPLAYERS = 0;

	e = PLAYER_CHAIN;
	while(e) {
		if ((TEAMPLAY & TEAM_LOCK_COLORS) && (self.classname != "observer")) {
			if ((e.steam == TEAM_COLOR1))		
				TEAM1 = TEAM1 + 1;		
			else if ((e.steam == TEAM_COLOR2))	
				TEAM2 = TEAM2 + 1;
		}		
		TOTALPLAYERS = TOTALPLAYERS + 1;
		e = e.clientchain;
	}
};




void(void(entity x) fun) TraversePlayers = {
	local entity e;
	e = PLAYER_CHAIN;
	while(e) {
		fun(e);
		e = e.clientchain;
	}
};

void(void(entity x) fun) TraverseClients = {
	local entity e;
	e = PLAYER_CHAIN;
	while(e) {
		fun(e);
		e = e.clientchain;
	}
};

void() revertthink = {
	local float x;
	if (TOTALPLAYERS == 0) {
		bprint(PRINT_HIGH, "Reverting to standard mode.\n");
		x = localinfo("mode", 0);
		x = x - (x & (1));
		SetVar(SERVERINFO, "mode", x);
		SetShowdownDefault();
	}
	remove(self);
};




void() EmptyServer = {
	local entity e;
	local string tp;
	if (FLAG_DEBUG)
		bprint(PRINT_HIGH, "Server is empty, restoring settings..\n");
	if (FLAG_COMPETITION && REVERTTOSTANDARD) {
		e = spawn();
		e.think = revertthink;
		e.nextthink = time + (REVERTTOSTANDARD * 60);
	}
	
	tp = infokey(world, "default_maxspecs");
	if (stof(tp)) 
		cvar_set("maxspectators", tp);
};


// ***commands*** -->




void() makecounter;


// debug -->

void() cyclered;
void() cycleblue;
void() dumpstarts;
void (vector org, float fteam, float angl) SpawnTeamStart;
float NEWFLAG;

// debug <--



// ***commands*** <--


// ***statbar*** -->

void() SetStatusBar = {
	local float  temp;
	temp = (self.impulse - 70) & 15;

	self.pure = self.pure - (self.pure & 15) + temp;
	sprint(self, PRINT_HIGH, "Status bar set\n");

	SetPureFlags(self);
	PrintNewPlayerSettings();
};

void() SwapStatusBar = {
	self.pure = self.pure - (self.pure & 15);
	sprint(self, PRINT_HIGH, "Status bar off.\n");
	SetPureFlags(self);
	PrintNewPlayerSettings();
};
// ***statbar*** <--


void(float x) printnum = {
	local string tmp;
	if (x)
		tmp = ftos(x);
	else
		tmp = "0";
	bprint(PRINT_HIGH, tmp);
};



// ***timer*** -->
void(string tp) soundall = {
	local entity e;
	e = CLIENT_CHAIN;
	while (e) {
// obsolete		sound(e, CHAN_AUTO, tp , 1, ATTN_IDLE); 
		stuffcmd(e, "play ");
		stuffcmd(e, tp);
		stuffcmd(e, "\n");
		e = e.clientchain;		
	}
};

void(string tp, float channel) soundflags = {
	local entity e;
	e = find(world, classname, "item_flag_team1");
	if (e)	sound(e, channel, tp, 1, ATTN_NONE);
	e = find(world, classname, "item_flag_team2");
	if (e)	sound(e, channel, tp, 1, ATTN_NONE);
};


// *check* inline?
void(entity pl) RemoveCenterprint = {
	centerprint(pl, " ");
};

// ***timer*** <--


// ***comp*** -->



void() UpdateRandomSeed = {
	local float x;
	local string tp;

	x = stof(infokey(world, "randomseed"));
	if (!x) x = 50;
	while(x) {
		random();	
		x = x - 1;
	}
	x = ceil(random() * 50);
	tp = ftos(x);	
	localcmd("localinfo randomseed ");
	localcmd(tp);
	localcmd("\n");
};


void() UnstuffSpectator = {
	stuffcmd(self, "bind 1 \"impulse 1\"\n");
	stuffcmd(self, "bind 2 \"impulse 2\"\n");
	stuffcmd(self, "bind 3 \"impulse 3\"\n");
	stuffcmd(self, "bind 4 \"impulse 4\"\n");
	stuffcmd(self, "bind 5 \"impulse 5\"\n");
	stuffcmd(self, "bind 6 \"impulse 6\"\n");
	stuffcmd(self, "bind 7 \"impulse 7\"\n");
	stuffcmd(self, "bind 8 \"impulse 8\"\n");
	unsetinfo(self, "sb");
};






void() CheckRate = {
	local string tp;
	local float rate;
	rate = stof(infokey(self, "rate"));

	if (PLAYER_MAXRATE && (rate > PLAYER_MAXRATE))
		if (IsClassPlayer(self))
			setinfo(self, "rate", PLAYER_MAXRATE);
	if (PLAYER_MINRATE && (rate < PLAYER_MINRATE))
		if (IsClassPlayer(self))
			setinfo(self, "rate", PLAYER_MINRATE);
// PCP *HrZ* - Remove specrate for now.
/*
	if (SPEC_MAXRATE && (rate > SPEC_MAXRATE))
		if (self.classname == "spectator")
			setinfo(self, "rate", PLAYER_MINRATE);
*/	
// PCP //
};




void() PeriodicCheck = {
	local float rp;
	
	if ((self.lastupdate > time) && (GLOBAL_UPDATE == self.lastglobalupdate)) 
		return;

	self.lastglobalupdate = GLOBAL_UPDATE;

	if (time < 10) 	rp = random();
	else 		rp = 0.9;	
	if (FLAG_STANDBY || STARTDELAY)		self.lastupdate = time + rp;
	else 					self.lastupdate = time + rp + 0.75;

	TeamCheckLock();
	CheckPing();

	TeamCapturePlayerUpdate();

	CheckMapChange();
	CheckAdmin();
	CheckRate();
	if (CheckStuffflag(self))
		DoStuffing();
};



void() StartAfterDelay = {
	UnFreeze(FREEZE_ALL);
	bprint(PRINT_HIGH, "Game has started!\n");
	StartTimer();
};

void() PureInitMap = {

	ForceUpdateVariables();
	UpdateRandomSeed();
	SpawnCTFMaps();

	ResetPingBans();		// *obsolete* ?

	// Restore maxclients value if needed
	RestoreMaxClients();
	
	// Update Serverinfo
// PCP dyna - version
	localcmd("serverinfo pure \"0.03pro\"\n");
// PCP //
	MapqueueStatus();
	SaveDefaults();
	localcmd("localinfo superadmin 0\n");
	SetTeamParameters();

	// == Check if server is doing a "start of match" restart
	RESTART = stof(infokey(world, "restart"));
	localcmd("localinfo restart \"\"\n");
	if (RESTART) {
		Freeze(FREEZE_PLAYERS);
		forceready = 1;
	}

	// == Set startdelay if needed ==
	STARTDELAY = localinfo("startdelay", 15);	
	if (FLAG_COMPETITION || gamestart)
		STARTDELAY = 0;
	if (STARTDELAY) {
		Freeze(FREEZE_PLAYERS);
		StartCountDown(STARTDELAY, StartAfterDelay, "‘ËÂ Á·ÌÂ ˜ÈÏÏ ÛÙ·ÚÙ\n ·ÊÙÂÚ ÙËÂ „ÔıÓÙ‰Ô˜Ó\n\n");
	}


	// Set sv_gamedir automatically
	if (localinfo("auto_sv_gamedir",0)) {
		if (IsCTFMap())
			localcmd("sv_gamedir ctf\n");
		else if (IsArenamap())
			localcmd("sv_gamedir arena\n");
		else if (FLAG_CTF)
			localcmd("sv_gamedir ctf\n");
		else if (FLAG_ARENA)
			localcmd("sv_gamedir arena\n");
		else 	
		localcmd("sv_gamedir qw\n");
	}

	// DebugMode notice
	if (FLAG_DEBUG) {
		bprint(PRINT_HIGH, "\n***********************************\n");
		bprint(PRINT_HIGH, "SERVER IS RUNNING IN DEBUG MODE!   \n");
		bprint(PRINT_HIGH, "\"serverinfo debug 0\" to turn off.\n");
		bprint(PRINT_HIGH, "***********************************\n\n");
	}

	// Spawn Dummy bots
	if (stof(infokey(world, "bots"))) {
		Spawn20Bots();
	}

/* *check*
	tp = infokey(world, "mappak");
	if ((tp != "") && (tp != "none")) {
		bprint(PRINT_HIGH, "\n***********************************\n");
		bprint(PRINT_HIGH, "This server is running custom maps!   \n");
		bprint(PRINT_HIGH, "Get them at:\n");
		bprint(PRINT_HIGH, tp);
		bprint(PRINT_HIGH, "\n***********************************\n\n");
	}
*/

	GSLogStart();					// GSLOG

	LASTQUEUE = localinfo("lastqueue", 0);
	SetVar(LOCALINFO, "lastqueue", 0);

/* obsolete (debugging)
	local float a,b;

	a = 32768;
	b = 30;

	while (b) {
		bprintnum("..:", a);
		bprintnum("-1:", a - 1);
		a = a * 2;
		b = b - 1;
	}
*/
	
};


// <-- check
