// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterstrˆm 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************

// =================
//     CONSTANTS
// =================

// =================
//     VARIABLES
// =================
	// Scores and disconnects -->
float RedCaps;
float RedWins;
float RedDisconnects;
float RedDisconnectscore;
float BlueCaps;
float BlueWins;
float BlueDisconnects;
float BlueDisconnectscore;
// =================
//      FIELDS  
// =================

// =================
//     FUNCTIONS
// =================

void() UpdateRank;


void() ClearScores = {
	RedCaps = 0;
	RedDisconnects = 0;
	RedDisconnectscore = 0;

	BlueCaps = 0;
	BlueDisconnects = 0;
	BlueDisconnectscore = 0;
};


void(entity pl) ShowScores = {
	local float RedScore;
	local float BlueScore;

	TeamCaptureResetUpdate();
	RedScore = RedDisconnectscore + teamscr1;
	BlueScore = BlueDisconnectscore + teamscr2 ;

	sprint(pl, PRINT_HIGH, "           RED  BLUE\n");
	sprint(pl, PRINT_HIGH, "---------- ---- ----\n");


	sprint(pl, PRINT_HIGH, "Frags      ");
	sPrintRight(pl, teamscr1, 4, " ");
	sPrintRight(pl, teamscr2, 5, " ");
	sprint(pl, PRINT_HIGH, "\n");

	sprint(pl, PRINT_HIGH, "Disconnects");
	sPrintRight(pl, RedDisconnectscore, 4, " ");
	sPrintRight(pl, BlueDisconnectscore, 5, " ");
	sprint(pl, PRINT_HIGH, "\n");


	if (FLAG_CTF) {
		sprint(pl, PRINT_HIGH, "Captures   ");
		sPrintRight(pl, RedCaps, 4, " ");
		sPrintRight(pl, BlueCaps, 5, " ");
		sprint(pl, PRINT_HIGH, "\n");
	}

	CalcTeamPing();

	sprint(pl, PRINT_HIGH, "Teamping   ");
	sPrintRight(pl, REDPING, 4, " ");
	sPrintRight(pl, BLUEPING, 5, " ");ß
	sprint(pl, PRINT_HIGH, "\n");

	sprint(pl, PRINT_HIGH, "---------- ---- ----\n");
	sprint(pl, PRINT_HIGH, "Total      ");
	sPrintRight(pl, RedDisconnectscore + teamscr1, 4, " ");
	sPrintRight(pl, BlueDisconnectscore + teamscr2, 5, " ");
	sprint(pl, PRINT_HIGH, "\n");
};

void(entity pl) ScoreAddCapture = {
	if ((pl.steam == TEAM_COLOR1)) {
		RedCaps = RedCaps + 1;
	} else { 
		BlueCaps = BlueCaps + 1;
	}
};

void(entity pl) ScoreAddDisconnect = {
	if (FLAG_DEBUG)
		bprint(PRINT_HIGH, "Saving score.\n");
	if (self.frags <= 0)
		return; 
	if ((self.steam == TEAM_COLOR1)) {
		RedDisconnects = RedDisconnects + 1;
		RedDisconnectscore = RedDisconnectscore + self.frags;
	} else {
		BlueDisconnects = BlueDisconnects + 1;
		BlueDisconnectscore = BlueDisconnectscore + self.frags;
	}
};


void() ScoresRecoverFrags = {
	local string tp;
	if (FLAG_COMPETITION && !FLAG_STANDBY) {
		if ((self.steam == TEAM_COLOR1) && RedDisconnectscore) {
			bprint(PRINT_HIGH, self.netname);
			bprint(PRINT_HIGH, " recovered ");
			tp = ftos(RedDisconnectscore);
			bprint(PRINT_HIGH, tp);
			bprint(PRINT_HIGH, " frags from the last disconnect.\n");
			self.frags = self.frags + RedDisconnectscore;
			RedDisconnectscore = 0;
		} else if ((self.steam == TEAM_COLOR2) && BlueDisconnectscore) {
			bprint(PRINT_HIGH, self.netname);
			bprint(PRINT_HIGH, " recovered ");
			tp = ftos(BlueDisconnectscore);
			bprint(PRINT_HIGH, tp);
			bprint(PRINT_HIGH, " frags from the last disconnect.\n");
			self.frags = self.frags + BlueDisconnectscore;
			BlueDisconnectscore = 0;
		} 
	}
};



void(entity pl) GetRank = {
	local float RedScore, BlueScore;
	local float x, Rank;
	
	RedScore = RedDisconnectscore + teamscr1;
	BlueScore = BlueDisconnectscore + teamscr2 ;

	x = time - pl.join_time;
	if (!x) x = 1;
	if ((pl.steam == TEAM_COLOR1)) 
		Rank = ((pl.frags / x) / RedScore) * TEAM1 * 100;
	else if ((pl.steam == TEAM_COLOR2)) 
		Rank = ((pl.frags / x) / BlueScore) * TEAM2 * 100;
	else 
		Rank = 100;
	if (Rank < 1) Rank = 1;
	pl.rank = rint(Rank);
};

void() UpdateRank = {

	local entity e,f ;
	local float NEXTTEAM;
	local float x;	
	
	TraversePlayers(GetRank);
	if (random() < 0.5)
		NEXTTEAM = TEAM_COLOR1;
	else
		NEXTTEAM = TEAM_COLOR2;

	x = 0;
	while(x < 50) {
		f = world;
		e = PLAYER_CHAIN;
		while(e) {
			if (e.rank > f.rank)
				f = e; 
			e = e.clientchain;
		}	
		if (f) {
			f.lastteam = NEXTTEAM;
			if (FLAG_DEBUG) {	// *debug*
				local string tp;
				sprint(f, PRINT_HIGH, "Next map, you'll belong to team ");
				tp =ftos(NEXTTEAM);
				sprint(f, PRINT_HIGH, tp);
				sprint(f, PRINT_HIGH, "\n"); 
			}
			NEXTTEAM = TEAM_COLOR1 + TEAM_COLOR2 - NEXTTEAM;
			f.rank = 0;
		} else return;
		x = x + 1;
	}

};

// PCP *HrZ* - MVD Recording 
void() StopMVD = {
	localcmd("stop\n");
};
// PCP //

void() TeamEndScore = {
	local string s;
	local entity e;

	if (gamestart)
		return;

	TeamCaptureResetUpdate();
	teamscr1 = teamscr1 + RedDisconnectscore;
	teamscr2 = teamscr2 + BlueDisconnectscore;

	e = CLIENT_CHAIN;
	while (e) {
		sprint(e, PRINT_HIGH, "\n");
		ShowScores(e);	
		sprint(e, PRINT_HIGH, "\n");
		if ((ProxyType(e) == PROXY_QIZMO) && FLAG_COMPETITION) 
			stuffcmd(e, "say proxy: time\n");
		e = e.clientchain;
	}
	if (FLAG_SHOWSTATS && time > 120) {
		if (FLAG_CTF)
			CTFStats2all();
		if (!FLAG_CTF || FLAG_SHOWALLSTATS)
			DMStats2all();
	}
	bprint(PRINT_HIGH, "\n");

	if (teamscr1 > teamscr2) {
		bprint(PRINT_HIGH, "“≈ƒ team won the level with ");
		s = ftos(teamscr1);
		bprint(PRINT_HIGH, s);
		bprint(PRINT_HIGH, " points!\n");
		bprint(PRINT_HIGH, "¬Ã’≈ team lost with ");
		s = ftos(teamscr2);
		bprint(PRINT_HIGH, s);
		bprint(PRINT_HIGH, " points.\n");
	} else if (teamscr1 < teamscr2) {
		bprint(PRINT_HIGH, "¬Ã’≈ team won the level with ");
		s = ftos(teamscr2);
		bprint(PRINT_HIGH, s);
		bprint(PRINT_HIGH, " points!\n");
		bprint(PRINT_HIGH, "“≈ƒ team lost with ");
		s = ftos(teamscr1);
		bprint(PRINT_HIGH, s);
		bprint(PRINT_HIGH, " points.\n");
	} else {
		bprint(PRINT_HIGH, "¬Ã’≈ and “≈ƒ team tied level with ");
		s = ftos(teamscr1);
		bprint(PRINT_HIGH, s);
		bprint(PRINT_HIGH, " points!\n");
	}

	UpdateRank();
// PCP *HrZ* - MVD Recording
	e = spawn();
	e.think = StopMVD;
	e.nextthink = time + 5;
// PCP //
};
