

// check -->



// *check* defends?


string(float Team) GetShortTeamColor;

// ==========================
// === CtfRank Primitives ===
// ==========================

// *inline*
void() CheckDeveloper = {
//whats this spose to do besides be annoying!??
/*	if (cvar("developer"))
		return;
	bprint(PRINT_HIGH, "\n****************************\n");
	bprint(PRINT_HIGH, "The server's config must set \n");
	bprint(PRINT_HIGH, "\"developer 1\" to use logging\n");
	bprint(PRINT_HIGH, "****************************\n");
	cvar_set("developer", "1");
*/

};

// Log Ctfrank message.
void (entity who, string what, string what2) CtfrankPrint = {
	if (!FLAG_CTFRANK) return;
	localcmd("echo \"LOG:	");
	localcmd(what);
	localcmd("	");
	if (what2 != "") {
		localcmd(what2);
		localcmd("	");
	}
	if (who)
		localcmd(who.netname);
	localcmd("\"\n");
};


void (entity who, string what) CtfrankLog = {
	CtfrankPrint(who, what, string_null);
};

void(string what, entity targ, entity attacker) CtfrankKill = {
	CheckDeveloper();
	if (!FLAG_CTFRANK) return;

	// note embedded tabs in the next string
	dprint("LOG:	DEATH	");
	dprint(targ.netname);
	dprint("/");
	dprint(ftos(targ.frags));
	dprint("	");
	if (attacker) {
		dprint(attacker.netname);
		dprint("/");
		dprint(ftos(attacker.frags));
		dprint("	");
	}
	dprint(what);
	dprint("\n");
};

// ===============================
// === Logging different kills ===
// ===============================

void(entity targ, entity attacker, string what) LogPlayerKill = {
	CtfrankKill(what, targ, attacker);
	GSScore(attacker, targ, "Kill", what, 1);
	attacker.log1 = attacker.log1 + 1;
	targ.log1 = targ.log1 + 4096;
};

void(entity targ, entity attacker, string what) LogPlayerTeamKill = {
	CtfrankKill(what, targ, attacker);
	GSScore(attacker, targ, "TeamKill", what, -1);		//*check*
	attacker.log2 = attacker.log2 + 64; 	// teamkill
	targ.log1 = targ.log1 + 4096;	// death
};


void (entity targ, string what) LogPlayerSuicide = {
	CtfrankKill(what, targ, world);
	GSScore(world, targ, "Suicide", what, -1);
	targ.log1 = targ.log1 + 4096;	// Death
	targ.log2 = targ.log2 + 1;	// Suicide
};

void(entity pl) LogTime = {
	local string tp;
	tp = ftos(time - pl.join_time);
	CtfrankPrint(pl, "TIME", tp); 
};

void(entity pl) LogDisconnect = {
	LogTime(pl);
	CtfrankLog(pl, "DISCONNECT");                         
	GSPlayerLeft(pl); 
};


// ===============
void(entity pl, string desc, float sc) AddScore = {
	if (sc) {
		pl.frags = pl.frags + sc;
		GSScore(world, pl, desc, "", sc);	
	}
};
// ====================
// === Score Events ===
// ====================
void(entity pl, float sc) LogPickup = {
	CtfrankLog(pl, "FLAG-PICKUP");
	AddScore(pl, "flagpickup", sc);
	pl.log3 = pl.log3 + 262144;	// Pickup
};
void(entity pl) LogFlagdrop = {
	CtfrankLog(pl, "FLAG-DROP");
	AddScore(pl, "ctf-flagdrop", 0);		//*check*
	pl.log2 = pl.log2 + 262144;	// Drop
};
void(entity pl, float sc) LogCapture = {
	CtfrankLog(pl, "FLAG-CAPTURE");
	AddScore(pl, "ctf-capture", sc);
	pl.log2 = pl.log2 + 4096;	// Capture
};
void(entity pl, float sc) LogCaptureBonus = {
	AddScore(pl, "ctf-capbonus", sc);
};
void(entity pl, float sc) LogReturnAssist = {
	AddScore(pl, "ctf-assist", sc);
	pl.log3 = pl.log3 + 1;	// Assist
};
void(entity pl, float sc) LogFragAssist = {
	AddScore(pl, "ctf-assist", sc);
	pl.log3 = pl.log3 + 1;	// Assist
};
void(entity pl, float sc) LogEscort = {
	AddScore(pl, "ctf-escort", sc);
	pl.log3 = pl.log3 + 64;	// Escort 
};
void(entity pl, float sc) LogRecovery = {
	CtfrankLog(pl, "FLAG-RECOVERY");	
	AddScore(pl, "ctf-flagrecovery", sc);
	pl.log3 = pl.log3 + 4096;	// Return
};

void(entity pl, float sc) LogCarrierfrag = {
	AddScore(pl, "ctf-carrierkill", sc);
	pl.log4 = pl.log4 + 1;	// 
};

void(entity pl, float sc) LogDefendCarrier = {
	AddScore(pl, "ctf-defendcarrier", sc);
	pl.log4 = pl.log4 + 4096;	// 
};
void(entity pl, float sc) LogDefendFlag = {
	AddScore(pl, "ctf-defendflag", sc);
	pl.log4 = pl.log4 + 64;	// 
};



// =============
// === Stats ===
// =============
entity() FragChain = {
	local entity e, f, g, fc;
	fc = world;	
	e = PLAYER_CHAIN;
	while (e) {
		f = spawn();
		f. owner = e;
		f.clientchain = fc;
		fc = f;
		e = e.clientchain;
	}
	e = fc;
	while (e) {
		f = e.clientchain;
		while (f) {
			if (f.owner.frags > e.owner.frags) {
				g = f.owner;
				f.owner = e.owner;
				e.owner = g;
			}
			f = f.clientchain;		
		}
		e = e.clientchain;
	}
	return fc;
};

void(entity pl) DMStats = {
	local float x;
	local entity e, f, g;
	sprint(pl, PRINT_HIGH, "Frag");
	sprint(pl, PRINT_HIGH, "–ÈÓÁ");
	sprint(pl, PRINT_HIGH, "Kill");
	sprint(pl, PRINT_HIGH, "ƒÂÙË");
	sprint(pl, PRINT_HIGH, "RATIO");
	sprint(pl, PRINT_HIGH, "Œ·ÌÂ\n");
	sprint(pl, PRINT_HIGH, "-------------------------\n");
	f = FragChain();
	while(f) {
		e = f.owner;
		sPrintRight(pl, e.frags, 3, " ");
		x = AveragePing(e);
		sPrintRight(pl, x, 4, " ");
		sPrintRight(pl, ( e.log1 & 4095) , 4, " ");	// kills
		sPrintRight(pl, ( (e.log1 / 4096) & 4095) , 4, " ");	//deaths
		x = ( e.log1 & 4095) + ( (e.log1 / 4096) & 4095);	// kills + deaths
		if (x) x = rint(100 * ( e.log1 & 4095) / x);
		sPrintRight(pl, x, 4, " ");	
		sprint(pl, PRINT_HIGH, "% ");
		sprint(pl, PRINT_HIGH, e.netname);
		sprint(pl, PRINT_HIGH, "\n");
		g = f;
		f = f.clientchain;
		remove(g);
	}
	sprint(pl, PRINT_HIGH, "-------------------------\n");
	if (FLAG_CTF)
		sprint(pl, PRINT_HIGH, "\"√‘∆”‘¡‘”\" for more stats.\n");
};

void(entity pl) CTFStats = {
	local string tp;
	local entity e, f, g;
	local float x;
	sprint(pl, PRINT_HIGH, "FRAG");
	sprint(pl, PRINT_HIGH, "–…Œ«");
	sprint(pl, PRINT_HIGH, "CAP");
	sprint(pl, PRINT_HIGH, "ƒÚ");
	sprint(pl, PRINT_HIGH, "Ass");
	sprint(pl, PRINT_HIGH, "“ÂÙ");
	sprint(pl, PRINT_HIGH, "Def");
	sprint(pl, PRINT_HIGH, "Œ·ÌÂ\n");
	sprint(pl, PRINT_HIGH, "---------------------------\n");
	f = FragChain();
	while(f) {
		e = f.owner;
		sPrintRight(pl, e.frags, 3, " ");
		x = AveragePing(e);
		sPrintRight(pl, x, 4, " ");
		sPrintRight(pl, ( (e.log2 / 4096) & 63), 3, " ");	// Caps
		sPrintRight(pl, ( (e.log2 / 262144) & 63), 3, " ");	// Drops
		sPrintRight(pl, ( e.log3 & 63), 3, " "); // Assists
		sPrintRight(pl, ( (e.log3 / 4096) & 63), 3, " "); // Returns
		sPrintRight(pl, (( (e.log4 / 64) & 63) + ( (e.log4 / 4096) & 63)), 3, " "); // def flag+def carrier
		sprint(pl, PRINT_HIGH, " ");
		sprint(pl, PRINT_HIGH, e.netname);
		sprint(pl, PRINT_HIGH, "\n");	
		g = f;
		f = f.clientchain;
		remove(g);
	}
	sprint(pl, PRINT_HIGH, "---------------------------\n");
	sprint(pl, PRINT_HIGH, "\"ƒÕ”‘¡‘”\" for more stats.\n");
};

void(entity pl) DMStats2all = {
	local float x;
	local entity e, f, g;
	bprint(PRINT_HIGH, "Frag");
	bprint(PRINT_HIGH, "–ÈÓÁ");
	bprint(PRINT_HIGH, "Kill");
	bprint(PRINT_HIGH, "ƒÂÙË");
	bprint(PRINT_HIGH, "RATIO");
	bprint(PRINT_HIGH, "Œ·ÌÂ\n");
	bprint(PRINT_HIGH, "-------------------------\n");
	f = FragChain();
	while(f) {
		e = f.owner;
		bPrintRight(e.frags, 3, " ");
		x = AveragePing(e);
		bPrintRight(x, 4, " ");
		bPrintRight(( e.log1 & 4095) , 4, " ");	// kills
		bPrintRight(( (e.log1 / 4096) & 4095) , 4, " ");	//deaths
		x = ( e.log1 & 4095) + ( (e.log1 / 4096) & 4095);	// kills + deaths
		if (x) x = rint(100 * ( e.log1 & 4095) / x);
		bPrintRight(x, 4, " ");	
		bprint(PRINT_HIGH, "% ");
		bprint(PRINT_HIGH, e.netname);
		bprint(PRINT_HIGH, "\n");
		g = f;
		f = f.clientchain;
		remove(g);
	}
	bprint(PRINT_HIGH, "-------------------------\n");
	if (FLAG_CTF)
		bprint(PRINT_HIGH, "\"√‘∆”‘¡‘”\" for more stats.\n");
};

void(entity pl) CTFStats2all = {
	local string tp;
	local entity e, f, g;
	local float x;
	bprint(PRINT_HIGH, "FRAG");
	bprint(PRINT_HIGH, "–…Œ«");
	bprint(PRINT_HIGH, "CAP");
	bprint(PRINT_HIGH, "ƒÚ");
	bprint(PRINT_HIGH, "Ass");
	bprint(PRINT_HIGH, "“ÂÙ");
	bprint(PRINT_HIGH, "Def");
	bprint(PRINT_HIGH, "Œ·ÌÂ\n");
	bprint(PRINT_HIGH, "---------------------------\n");
	f = FragChain();
	while(f) {
		e = f.owner;
		bPrintRight(e.frags, 3, " ");
		x = AveragePing(e);
		bPrintRight(x, 4, " ");
		bPrintRight(( (e.log2 / 4096) & 63), 3, " ");	// Caps
		bPrintRight(( (e.log2 / 262144) & 63), 3, " ");	// Drops
		bPrintRight(( e.log3 & 63), 3, " "); // Assists
		bPrintRight(( (e.log3 / 4096) & 63), 3, " "); // Returns
		bPrintRight((( (e.log4 / 64) & 63) + ( (e.log4 / 4096) & 63)), 3, " "); // def flag+def carrier
		bprint(PRINT_HIGH, " ");
		bprint(PRINT_HIGH, e.netname);
		bprint(PRINT_HIGH, "\n");	
		g = f;
		f = f.clientchain;
		remove(g);
	}
	bprint(PRINT_HIGH, "---------------------------\n");
	bprint(PRINT_HIGH, "\"ƒÕ”‘¡‘”\" for more stats.\n");
};


void() ModeStats = {
	if (FLAG_CTF)
		CTFStats();
	else
		DMStats();
};

// ================
// === GSLOGMOD ===
// ================

// ***primitives***

void(string header) GSStartline = {
	CheckDeveloper();
	localcmd("echo \"		");
	localcmd(header);
	localcmd("	");
};

void(string name, string val) GSMessage = {
	GSStartline(name);
	localcmd(val);
	localcmd("\"\n");
};

void() GSPrintTime = {
	local string tp;
	tp = ftos(floor(time));
	localcmd(tp);
};

void(entity pl) GSPrintName = {
	if (pl)
		localcmd(pl.netname);
	localcmd("	");
};

void(entity pl) GSPrintTeam = {
	local string tp;
	if (TEAMPLAY & TEAM_LOCK_COLORS) {
		tp = GetShortTeamColor(pl.steam);
		localcmd(tp);
	} else if (TEAMPLAY) {
		tp = infokey(self, "team");
		localcmd(tp);
	}
	localcmd("	");
};

// ===================
// === Logmessages ===
// ===================


// 2 - 7 
void() GSLogStart = {
	if (FLAG_GSLOG) {
		GSMessage("StdLog" ,"v1.2");
		GSMessage("PatchName",  "CTF Pure");
		GSMessage("LogDate",  "");		// *check* Need external prog
		GSMessage("LogTime",  "");		// *check* Need external prog
		local string tp;
		tp=infokey(world, "deathmatch");
		GSMessage("LogDeathFlags",  tp);
		local string tp;
		tp = FindMap(mapname);
		GSMessage("Map",  tp);
	}		
};

// 8. Player Names 
void(entity pl) GSPlayer = {
	local string tp;
	if (FLAG_GSLOG) {
		GSStartline("Player");
		GSPrintName(pl);
		GSPrintTeam(pl);	
		GSPrintTime();	
		localcmd("\"\n");
	} 
	CtfrankLog(self, "CONNECT");
};

// 9. Scores and Frags 
void(entity logkiller, entity logtarget, string scoretype, string logweapon, float logscore) GSScore = {

	// *check*

	local string tp;

	if (FLAG_GSLOG) {
		GSPrintName(logkiller);
		GSPrintName(logtarget);

		localcmd(scoretype);
		localcmd("	");
		localcmd(logweapon);
		localcmd("	");

		tp = ftos(logscore);
		localcmd(tp);
		localcmd("	");

		GSPrintTime();	
		localcmd("	");

		tp = infokey(logkiller, "ping");
		localcmd(tp);
		localcmd("\"\n");
	}
};


// 10. Player disconnected / left the game 
void(entity pl) GSPlayerLeft = {
	local string tp;
	if (FLAG_GSLOG) {
		localcmd("		");

		localcmd("PlayerLeft");
		localcmd("	");
		localcmd(pl.netname);
		localcmd("		");

		GSPrintTime();	
		localcmd("\"\n");
	} 
};

// 11. Start Counting Frags 
void() GSGameStart = {
	local string tp;
	if (FLAG_GSLOG){
		localcmd("		");
		localcmd("GameStart");
		localcmd("			");
		GSPrintTime();	
		localcmd("\"\n");
	}
};

// 12. Stop Counting Frags 
void() GSGameEnd = {
	local string tp;
	if (FLAG_GSLOG) {
		localcmd("		");
		localcmd("GameEnd");
		localcmd("			");
		GSPrintTime();
		localcmd("\"\n");
	}
};




// 13. Player Connecting 
void(entity pl) GSPlayerConnect = {
	if (FLAG_GSLOG) {
		GSStartline("PlayerConnect");	
		GSPrintName(pl);
		GSPrintTeam(pl);

		GSPrintTime();
		localcmd("\"\n");
	}
	CtfrankLog(self, "CONNECT");
};

// 14. Player Changes Team 
void(entity pl) GSPlayerTeamChange = {
	// *check* assign och killmeswap?
	if (FLAG_GSLOG) {
		GSStartline("PlayerTeamChange");	
		GSPrintName(pl);
		GSPrintTeam(pl);

		GSPrintTime();
		localcmd("\"\n");
	}
	if ((self.steam == TEAM_COLOR1))	
		CtfrankLog(self, "RED");   
	else                            
		CtfrankLog(self, "BLUE");
};

// 15. Player Changes Name 
void(entity pl) GSPlayerRename = {
	// *check*

	GSStartline("PlayerRename");

	localcmd("");
	localcmd("	");			// Need quite a hack to find the older name

	GSPrintName(pl);

	GSPrintTime();
	localcmd("\"\n");
};




// *check*
