// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterström 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************


// =================
//     FUNCTIONS
// =================


/*
=========
FindFirstAdmin

Return the first of the admins.
=========
*/
entity() FindFirstAdmin = {
	local entity e;
	e = CLIENT_CHAIN;
	while (e) {
		if (e.admin & AD_ADMIN)
			return e;
		e = e.clientchain;
	}
	return e;
};



/*
=============
CheckAdmin

Checks to give out adminstatus or change map
=============
*/
void() CheckAdmin = {
	local entity e;
	local string tp;

	if (infokey(self, "admin") == "") 
		return;

	e = FindFirstAdmin();
	unsetinfo(self, "admin");

	if (self.admin & AD_ADMIN) {
		sprint(self, PRINT_HIGH, "You already have admin status.\n");
		return;
	}

	tp = infokey(world, "adminpass");
	if ((tp != "none") && (tp == infokey(self, "admin"))) {
		RemoveAdmins(AD_VOTED);
		bprint(PRINT_HIGH, self.netname);
		if (random() < 0.5)
			bprint(PRINT_HIGH, " invokes the holy word and is suddenly granted the power of admin.\n");
		else 
			bprint(PRINT_HIGH, " uses his secret powers and is rewarded with the power of admin.\n");
		sprint(self, PRINT_HIGH, "Type \"adminhelp\" to get commands.\n");
		self.admin = self.admin - (self.admin & (AD_MASK));
		self.admin = self.admin | (AD_ADMIN);
		StartStuffing(self);
		return;
	} 
	tp = infokey(world, "tinyadminpass");
	if ((tp != "none") && (tp == infokey(self, "admin"))) {
		bprint(PRINT_HIGH, self.netname);
		bprint(PRINT_HIGH, " has become an tiny admin.\n");
		sprint(self, PRINT_HIGH, "Type \"adminhelp\" to get commands.\n");
		self.admin = self.admin - (self.admin & (AD_MASK));
		self.admin = self.admin | (AD_ADMIN | AD_TINY);
		StartStuffing(self);
		return;	
	}

	sprint(self, PRINT_HIGH, "Wrong admin password!\n");
};



// =====================================
//  Accesslevels and scope for commands
// =====================================
float() AccessShowdown = {
	if ((self.admin & AD_ADMIN) && ! (self.admin & AD_TINY)) {
		return 1;
	} else if (!FLAG_SHOWDOWN) {
		sprint(self, PRINT_HIGH, "Showdown mode not enabled.\n");
		return 0;
	} else if (FindFirstAdmin()) {
		sprint(self, PRINT_HIGH, "Locked by the admin.\n");
		return 0;
	} else {
		return 1;
	}
};
float() AccessAdmin = {
	if (self.admin & AD_ADMIN) {
		return 1;
	} else {
		sprint(self, PRINT_HIGH, "You have to be admin to do this.\n");
		return 0;
	}
};
float() AccessSuper = {
	if (self.admin & AD_SUPER) {
		return 1;
	} else {
		sprint(self, PRINT_HIGH, "You have to be super admin to do this.\n");
		return 0;
	}
};
float() AccessMatchOnly = {
	if (FLAG_COMPETITION && FLAG_STANDBY) {
		sprint(self, PRINT_HIGH, "You can only do this during a match.\n");
		return 0;
	} else {
		return 1;
	}
};
float() AccessNoMatch = {
	if (FLAG_COMPETITION && !FLAG_STANDBY && !GameOver()) {
		sprint(self, PRINT_HIGH, "You can't do this during a match.\n");
		return 0;
	} else {
		return 1;
	}
};




void() PrintAdmin = {
	local entity e;
	local float flag;
	sprint(self, PRINT_HIGH, "Admins: ");
	flag = 0;
	e = CLIENT_CHAIN;
	while (e) {
		if (e.admin & AD_ADMIN) {
			sprint(self, PRINT_HIGH, e.netname);
			if (e.admin & AD_VOTED)
				sprint(self, PRINT_HIGH, "(v)");
			else if (e.admin & AD_SUPER)
				sprint(self, PRINT_HIGH, "(s)");
			else
				sprint(self, PRINT_HIGH, "");
			flag = 1;
		}
		e = e.clientchain;
	}
	if (!flag) {
		sprint(self, PRINT_HIGH, "-none-");
	}
	sprint(self, PRINT_HIGH, "\n");

};
void() superthink = {
	local entity e;
	e = self;
	self = e.owner;
	if (stof(infokey(world, "superadmin")) != e.admin) {
		if (time < e.delay) {
			e.nextthink = time + 0.1;
			return;
		}
		sprint(self, PRINT_HIGH, "Sorry, you need rcon to become an superadmin.\n");
		localcmd("localinfo superadmin \"\"\n");
		return;
	}
	RemoveAdmins(AD_ADMIN);
	if (random() < 0.5) {
		bprint(PRINT_HIGH, "\nTremble mortals, ");
		bprint(PRINT_HIGH, self.netname);
		bprint(PRINT_HIGH, " now is supreme Super Admin.\n");
	} else {
		bprint(PRINT_HIGH, "\nBy the darkest of black magic, ");
		bprint(PRINT_HIGH, self.netname);
		bprint(PRINT_HIGH, " now has the power of a Super Admin.\n");
	}
	sprint(self, PRINT_HIGH, "Type \"adminhelp\" to get commands.\n");
	self.admin = self.admin - (self.admin & (AD_MASK));
	self.admin = self.admin | (AD_ADMIN | AD_SUPER);
	StartStuffing(self);
	remove(e);
};

void() SuperCheck = {
	local entity e;
	local float x;
	local string tp;
	x = 0;
	e = find(world, classname, "supercheck");
	while(e) {
		if (e.admin >= x) 
			x = e.admin;
		e = find(e, classname, "supercheck");
	}
	x = x + 1;
	e = spawn();
	e.classname = "supercheck";
	e.think = superthink;
	e.nextthink = time + 0.1;
	e.delay = time + 2;
	e.owner = self;
	e.admin = x;

	localcmd("localinfo superadmin 0\n");
	stuffcmd(self, "rcon localinfo superadmin ");
	tp = ftos(x);
	stuffcmd(self, tp);
	stuffcmd(self, "\n");	
};

void() SuperAdmin = {
	sprint(self, PRINT_HIGH, "Applying for superadmin...\n");
	SuperCheck();
};

// *check* inline

float(entity pl) IsAdmin = { return (pl.admin & AD_ADMIN); };
float(entity pl) IsSuperAdmin = { return (pl.admin & AD_SUPER); };
float(entity pl) IsTinyAdmin = { return (pl.admin & AD_TINY); };


void(entity player) TeamCaptureDropFlagOfPlayer;
float() GameOver;

void(entity pl) AdminSwap = {
	local entity oself;
	local string n;	

	if (GameOver()) {
		sprint(self, PRINT_HIGH, "You can't swap players in intermission.\n");
		return;		
	}

	pl.player_flag = pl.player_flag | (PF_KILLMESWAP);

	bprint(PRINT_HIGH, pl.netname);
	bprint(PRINT_HIGH, " was swapped to ");
	if ((pl.steam == TEAM_COLOR1))
		n = GetTeamColor(TEAM_COLOR2);
	else
		n = GetTeamColor(TEAM_COLOR1);
	bprint(PRINT_HIGH, n);
	bprint(PRINT_HIGH, " team by the almighty ");
	bprint(PRINT_HIGH, self.netname);
	bprint(PRINT_HIGH, "\n");
};

void(entity pl, string reason) KickClient = {
	bprint(PRINT_HIGH, pl.netname);
	bprint(PRINT_HIGH, " no longer has the favor of the quake gods and was ");
	bprint(PRINT_HIGH, reason);
	bprint(PRINT_HIGH, "\n");
	unsetinfo(pl, "ad");
	unsetinfo(pl, "as");
	setinfo(pl, "spectator", 1);
	sprint(pl, PRINT_HIGH, "\n************************************\n");
	sprint(pl, PRINT_HIGH, "Ùïõ ÷åòå ëéãëåä æòïí ôèå óåòöåò:\n");
	sprint(pl, PRINT_HIGH, reason);
	if (FLAG_COMPETITION)
		sprint(pl, PRINT_HIGH, "There's a match in progress here!\n");
	sprint(pl, PRINT_HIGH, "\n************************************\n\n");
	stuffcmd(pl, "disconnect\n");
};

void(entity pl, string reason) BanClient = {
	unsetinfo(pl, "ad");
	unsetinfo(pl, "as");
	setinfo(pl, "mod", 1);
	KickClient(pl, reason);
};


void(entity pl) AdminKick = {
	if (pl.admin & AD_SUPER) {
		sprint(self, PRINT_HIGH, "You can't kick a super admin.\n");
		return;
	}
	KickClient(pl, "Kicked by the admin.");
};

void() AdminKickLast = {
	if (LAST_CONNECTED)
		AdminKick(LAST_CONNECTED);
};


void(entity pl) AdminBan = {
	if (pl.admin & AD_SUPER) {
		sprint(self, PRINT_HIGH,  "You can't ban a super admin.\n");
		return;
	}
	BanClient(pl, "Banned by the admin.");
};


void() KickOnSight = {
	local entity e;
	e = identify_player(0);
	if (IsClassPlayer(self.trigger_field) && (self.delay > time)) {
		AdminKick(self.trigger_field);
	} else if (e) {
		sprint(self, PRINT_HIGH, "Kick ");
		sprint(self, PRINT_HIGH, e.netname);
		sprint(self, PRINT_HIGH, "?\n");
		self.trigger_field = e;
		self.delay = time + 5;
	} else {
		sprint(self, PRINT_HIGH, "You must aim at someone\n");
		self.trigger_field = world;	
	}
};


void(entity pl) AdminIpban = {
	local string tp;
	if (pl.admin & AD_SUPER) {
		sprint(self, PRINT_HIGH,  "You can't ipban a super admin.\n");
		return;
	}

	BanClient(pl, "IP-Banned by the admin.");
	localcmd("addip ");
	tp = infokey(pl, "ip");
	localcmd(tp);
	localcmd("\n");
};



void() ForceReady = {
	local entity e;
	forceready = 1;

	if (!FLAG_COMPETITION)
		return;	

	e = PLAYER_CHAIN;

	while(e) {
		e.classname = "ready";
		e = e.clientchain;
	}
	CheckReady();
};

void() RestartMap = {
	local float x;
	local string tp;
	x = TOTALPLAYERS;
	if ((x < 2) && !FLAG_DEBUG) 
		sprint(self, PRINT_HIGH, "Too few to start\n");
	else if (!FLAG_COMPETITION)
		sprint(self, PRINT_HIGH, "You can only restart in Competition mode.\n");
	else {
		tp = ftos(x);
		localcmd("localinfo restart ");
		localcmd(tp);
		localcmd("\n");
		bprint(PRINT_HIGH, "\nRestarting map for gamestart\n\n");
		ChangeMap(mapname);
	}
};


void() SwapAll = {
	local entity e;

	if (GameOver()) {
		sprint(self, PRINT_HIGH, "You can't swap players in intermission.\n");
		return;		
	}
	bprint(PRINT_HIGH, "Swapping all players.\n");
	e = PLAYER_CHAIN;
	while(e) {
		if (e.lastteam == e.steam)
			e.player_flag = e.player_flag | (PF_KILLMESWAP);
		else if (e.lastteam < 0)
			e.player_flag = e.player_flag | (PF_KILLMESWAP);
		else
			e.player_flag = e.player_flag | (PF_KILLMERESTART);

		e = e.clientchain;
	}
};

void() NoSpecs = {
	local entity e;
	SetVar(CVARINFO, "maxspectators", 0);
	MAXSPECS = 0;
	bprint(PRINT_HIGH, "Locked to no spectators\n");
	e = CLIENT_CHAIN;
	while(e) {
		if (e.classname == "spectator")
			KickClient(e, "No spectators allowed here.");
		e = e.clientchain;
	}
};

void() AdminVoted = {
	local entity e, oself;
	oself = self;
	RemoveAdmins(AD_VOTED);

	self = VOTE_STARTER;
	bprint(PRINT_HIGH, self.netname);
	bprint(PRINT_HIGH, " has become admin.\n");
	sprint(self, PRINT_HIGH, "Type \"adminhelp\" to get commands.\n");
	self.admin = self.admin - (self.admin & (AD_MASK));
	self.admin = self.admin | (AD_ADMIN | AD_VOTED);
	StartStuffing(self);
	self = oself;
};


void(float mask) RemoveAdmins = {
	local entity e;
	e = CLIENT_CHAIN;
	while(e) {
		if (e.admin & mask) {
			if (!(e.admin & AD_SUPER)) {
				e.admin = e.admin - (e.admin & (AD_MASK));
				sprint(e, PRINT_HIGH, "Your admin privilegies has been removed\n");	
				bprint(PRINT_HIGH, e.netname);
				bprint(PRINT_HIGH, " is no longer admin\n");
			}
		}
		e = e.clientchain;
	}
};


void(entity pl) AdminGiveAdmin = {
	local float x;
	if (self.admin & AD_VOTED) {
		self.admin = self.admin - (self.admin & (AD_MASK));
		sprint(self, PRINT_HIGH, "You are no longer admin.\n");
	}
	x = self.admin;
	x = x - (x & (AD_SUPER));		// Can't give super away...
	pl.admin = pl.admin | (x);
	bprint(PRINT_HIGH, self.netname);
	bprint(PRINT_HIGH, " has given the holy powers of admin to ");
	bprint(PRINT_HIGH, pl.netname);
	bprint(PRINT_HIGH, "\n");  
	StartStuffing(pl);
};


void() AdminHelpCommands = {
	sprint(self, PRINT_HIGH, "áäíéîèåìð  : Óèï÷ áäíéî èåìð\n");
	sprint(self, PRINT_HIGH, "ðòïøùèåìð  : Ðòïøù ïðôéïîó\n");
	sprint(self, PRINT_HIGH, "íïäåèåìð  : Óåòöåòíïäå ãïííáîäó\n");
};

void() ServermodeHelp = {
	sprint(self, PRINT_HIGH, "---- Admin Help -------------------\n");
	sprint(self, PRINT_HIGH, "ãïíðíïäå : Ôïççìå ãïíðåôéôéïî\n");
	sprint(self, PRINT_HIGH, "ãôæíïäå  : Ôïççìå ÃÔÆ/ÄÍ\n");
	sprint(self, PRINT_HIGH, "-----------------------------------\n");
};

void() AdminHelp = {
	sprint(self, PRINT_HIGH, "---- Admin Help -------------------\n");
	AdminHelpCommands();
	sprint(self, PRINT_HIGH, "---- Admin Commands ---------------\n");
	sprint(self, PRINT_HIGH, "ëéãë       : Ëéãëó á ðìáùåò\n");
	sprint(self, PRINT_HIGH, "ëïó        : Ëéãë ïî óéçèô\n");
	sprint(self, PRINT_HIGH, "çéöåáäíéî  : Çéöåó áäíéîóôáôõó á÷áù®\n");
	if (!IsTinyAdmin(self)) {
		sprint(self, PRINT_HIGH, "ó÷áð       : Ó÷áðó á ðìáùåò\n");
		sprint(self, PRINT_HIGH, "ó÷áðáìì    : Ó÷áðó áìì óíáòôìù\n");
		sprint(self, PRINT_HIGH, "âáî        : Âáîó á ðìáùåò\n");
		sprint(self, PRINT_HIGH, "æïòãåóôáòô : Óôáòô á íáôãè\n");
		sprint(self, PRINT_HIGH, "òåóôáòô    : Òåóôáòô çáíå&íáð\n");
		sprint(self, PRINT_HIGH, "òðéãëõð    : Òáîäïí ðéãëõð çáíå\n");
		if (FLAG_COMPETITION) {
			sprint(self, PRINT_HIGH, "æïòãåâòåáë : Æïòãåó á íáôãè ôï åîä®\n");
		}
	}
	if (IsSuperAdmin(self)) {
		sprint(self, PRINT_HIGH, "éðâáî      : Âáî âù ÉÐ\n");
	}
	sprint(self, PRINT_HIGH, "îåøôíáð    : Çïôï îåøô íáð®\n");
	sprint(self, PRINT_HIGH, "îïóðåãó    : Òåíïöå Óðåãôáôïòó\n");
	sprint(self, PRINT_HIGH, "îïáäíéî    : Òåíïöå áäíéî óôáôõó\n");
	sprint(self, PRINT_HIGH, "-----------------------------------\n");
};

void() RemoveAdminflags = {
	self.admin = self.admin - (self.admin & (AD_MASK));
	sprint(self, PRINT_HIGH, "Your admin status has been removed.\n");
	bprint(PRINT_HIGH, self.netname);
	bprint(PRINT_HIGH, " is no longer admin.\n");

};

void() ForceBreak = {
	if (!AccessMatchOnly())
		return;	
	bprint(PRINT_HIGH, self.netname);
	bprint(PRINT_HIGH, " has forced the match to end.\n");
	EndMatch();
};

void(float inputtype, string inpstring) StartAdminInput = {
	sprint(self, PRINT_HIGH, "--- Which player to ");
	sprint(self, PRINT_HIGH, inpstring);
	sprint(self, PRINT_HIGH, "? ---\n");
	PrintClientTeamList(self,0);
	sprint(self, PRINT_HIGH, "-----------------------------\n");
	self.input_type = inputtype;
	self.delay = time + 10;
};



void() AdminImpulses = {
	// *impulse*
	
	if (!(self.admin & AD_ADMIN)) {
		sprint(self, PRINT_HIGH, "You must be admin to do this.\n");

	// === Commands for "Tiny Admin" and above. ===

// PCP dyna - Enhanced ingame and spectator admin start/break
	} else if (self.impulse == 58) {
		NotReady();
// PCP //
	} else if (self.impulse == 104) {
		if (FLAG_COMPETITION && !FLAG_STANDBY)
			return;
		StartAdminInput(INPUT_TYPE_SWAP, "swap");
	} else if (self.impulse == 109) {
		StartAdminInput(INPUT_TYPE_KICK, "kick");
	} else if (self.impulse == 105) {
		RemoveAdminflags();
	} else if (self.impulse == 106) {
		AdminHelp();
	} else if (self.impulse == 102) {
		KickOnSight();
	} else if (self.impulse == 103) {
		EndMatch();
	} else if (self.impulse == 114) {
		StartAdminInput(INPUT_TYPE_GIVEADMIN, "give admin to");

	// === Commands for "Vote Admin" and above. ===

	} else if (IsTinyAdmin(self)) {
		sprint(self, PRINT_HIGH, "Tiny Admins can't do this.\n");
		return;
	} else if (self.impulse == 108) {
		if (FLAG_COMPETITION && !FLAG_STANDBY)
			return;
		SwapAll();
	} else if (self.impulse == 111) {
		StartAdminInput(INPUT_TYPE_BAN, "ban");
	} else if (self.impulse == 110) {
		if (FLAG_COMPETITION && !FLAG_STANDBY)
			return;
		ForceReady();
	} else if (self.impulse == 112) {
		if (FLAG_COMPETITION && !FLAG_STANDBY)
			return;
		RestartMap();
	} else if (self.impulse == 107) {
		NoSpecs();
	} else if (self.impulse == 113) {
		ForceBreak();
	} else if (self.impulse == 116) {
		DoRpickup();
	} else if (self.impulse == 115) {
		ServermodeHelp();
	} else if (self.impulse == 117) {
		LockMaxClients();
	} else if (self.impulse == 118) {
		if (infokey(world, "saveplayers") == "")
			sprint(self, PRINT_HIGH, "Maxclients already set to max.\n");
		else
			RestoreMaxClients();
	} else if (self.impulse == 121) {
		AdminKickLast();
	// === Commands for "Super Admin". ===

	} else if (self.impulse == 101) {
		StartAdminInput(INPUT_TYPE_IPBAN, "ipban");
	}
};


void() ModeImpulses = {
	if (CheckModeChange()) {
		return;
	} else if (self.impulse == 101) {
		ShowDownCompetition();
	} else if (self.impulse == 103) {
		ShowDownCTF();
	} else if (self.impulse == 105) {
		ShowDownCompetition();
	}
};




float MAXPLAYERLIST;

entity(entity pl, float getme) PrintPlayerTeamList = {
	local entity f;
	local float x;
	local string tp;

	x = 1;
	f = PLAYER_CHAIN;
	while(f) {
		if ((f.steam == TEAM_COLOR1)) {
			if (getme) {
				if (getme == x)
					return f;
			} else {
				sPrintRight(pl, x, 2, " ");
				sprint(pl, PRINT_HIGH,  " [RED ] ");
				sprint(pl, PRINT_HIGH, f.netname);
				sprint(pl, PRINT_HIGH, "\n");
			}
			
			x = x + 1;
		}
		f = f.clientchain;
	}

	f = PLAYER_CHAIN;
	while(f) {
		if ((f.steam == TEAM_COLOR2)) {
			if (getme) {
				if (getme == x)
					return f;
			} else {
				sPrintRight(pl, x, 2, " ");
				sprint(pl, PRINT_HIGH,  " [BLUE] ");
				sprint(pl, PRINT_HIGH, f.netname);
				sprint(pl, PRINT_HIGH, "\n");
			}
			x = x + 1;
		}
		f = f.clientchain;
	}
	f = PLAYER_CHAIN;
	while(f) {
		if (!(f.steam == TEAM_COLOR1) && !(f.steam == TEAM_COLOR2)) {
			if (getme) {
				if (getme == x)
					return f;
			} else {
				sPrintRight(pl, x, 2, " ");
				sprint(pl, PRINT_HIGH,  " [----] ");
				sprint(pl, PRINT_HIGH, f.netname);
				sprint(pl, PRINT_HIGH, "\n");
			}
			x = x + 1;
		}
		f = f.clientchain;
	}
	MAXPLAYERLIST = x;
	return world;
};

entity(entity pl, float getme) PrintClientTeamList = {
	local entity e, f;
	local float x;
	local string tp;

	e = PrintPlayerTeamList(pl, getme);
	if (e) return e;

	x = MAXPLAYERLIST;

	f = CLIENT_CHAIN;
	while(f) {
		if (f.classname == "spectator") {
			if (getme) {
				if (getme == x)
					return f;
			} else {
				sPrintRight(pl, x, 2, " ");
				sprint(pl, PRINT_HIGH,  " [SPEC] ");
				sprint(pl, PRINT_HIGH, f.netname);
				sprint(pl, PRINT_HIGH, "\n");
			}
			x = x + 1;
		}
		f = f.clientchain;
	}
	return world;
};


entity(float number) GetPlayerFromTeamList = {
	local entity e;
	e = PrintPlayerTeamList(world, number);
	if (!e) {
		sprint(self, PRINT_HIGH, "No Such Player ");
		sPrintRight(self, number, 1, "");
		sprint(self, PRINT_HIGH, "\n");
	}
	return e;
};

entity(float number) GetClientFromTeamList = {
	local entity e;
	e = PrintClientTeamList(world, number);
	if (!e) {
		sprint(self, PRINT_HIGH, "No Such Client ");
		sPrintRight(self, number, 1, "");
		sprint(self, PRINT_HIGH, "\n");
	}
	return e;
};




void() DoAdminCommand = {
	local entity e;
	local float who;

	self.input_type = self.input_type & 255;
	
	e = self.oldenemy;

	if (self.input_type == INPUT_TYPE_SWAP) {
		if (e) AdminSwap(e);
	} else if (self.input_type == INPUT_TYPE_KICK) {
		if (e) AdminKick(e);
	} else if (self.input_type == INPUT_TYPE_BAN) {
		if (e) AdminBan(e);
	} else if (self.input_type == INPUT_TYPE_IPBAN) {
		if (e) AdminIpban(e);
	} else if (self.input_type == INPUT_TYPE_GIVEADMIN) {
		if (e) AdminGiveAdmin(e);
	} 	
	self.input_type = 0;
	self.impulse = 0;
};
// *check*
