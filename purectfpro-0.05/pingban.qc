// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterstrˆm 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************


float lastkick;
float kickid1;
float kickwarning1;
float kickid2;
float kickwarning2;


void(entity pl) ShowPings = {
	local entity e;
	local float x;
	local string tp;
	e = PLAYER_CHAIN;
	sprint(pl, PRINT_HIGH, "PING AVRG RATE NAME\n");
	sprint(pl, PRINT_HIGH, "----------------------\n");
	while (e) {
		x = stof(infokey(e, "ping"));	
		if (x > 9999) x = 9999;
		sPrintRight(pl, x, 4, " ");
		x = AveragePing(e);
		if (x > 9999) x = 9999;
		sPrintRight(pl, x, 5, " ");
		x = stof(infokey(e, "rate"));
		if (x > 9999) x = 9999;
		sPrintRight(pl, x, 5, " ");
		sprint(pl, PRINT_HIGH, " ");
		sprint(pl, PRINT_HIGH, e.netname);
		sprint(pl, PRINT_HIGH, "\n");
		e = e.clientchain;
	}
	sprint(pl, PRINT_HIGH, "----------------------\n");
};


// *** Initial reset of values ***

void() ResetPingBans ={
	lastkick = 0;
	kickid1 = -1;
	kickwarning1 = 0;
	kickid2 = -1;
	kickwarning2 = 0;
};


void() cthink = {

	local string tp;

	bprint(PRINT_HIGH, "Time: ");

	tp = ftos(time);
	bprint(PRINT_HIGH, tp);
	bprint(PRINT_HIGH, "\n");

	self.nextthink = time + 0.05;
};


void() makecounter = {
	local entity e;

	e = spawn();
	
	e.think = cthink;
	e.nextthink = time + 0.1;

};

void() SetPing = {
	local float x;
	if (!FLAG_STANDBY && !CountDown  && !gameover) {
		x = stof(infokey(self, "ping"));
		if (x < 1000) {
			self.pingsum = self.pingsum + x;
			self.pingtimes = self.pingtimes + 1;
		}
	}
};

void() CheckPing = {
	
	local string tp;
	local float x;

	if (!(infokey(world, "*version") == "2.21"))
		return;

	if (!VAR_PINGBAN && !VAR_HPBBAN)
		return;

	if (time < (self.join_time + 10))		// Give ping time to stabilize
		return;


	x = stof(infokey(self, "ping"));

	if (!self.pingcheck) 
		self.pingcheck = 500;

	self.pingcheck = (self.pingcheck * 2 + x) / 3;	// Weighted average

	
	if (VAR_PINGBAN) {
		if (self.pingcheck < VAR_PINGBAN)
			BanClient(self, "Kicked because of too low ping.");
		else if (x < VAR_PINGBAN) {
			sprint(self, PRINT_HIGH, "◊¡“Œ…Œ«: your ping is lower than ");
			tp = ftos(VAR_PINGBAN);
			sprint(self, PRINT_HIGH, tp);
			sprint(self, PRINT_HIGH, "!\n");
		}
	} else if (VAR_HPBBAN) {
		if (self.pingcheck > VAR_HPBBAN)
			BanClient(self, "Kicked because of too high ping.");
		else if (x > VAR_HPBBAN) {
			sprint(self, PRINT_HIGH, "◊¡“Œ…Œ«: your ping is higher than ");
			tp = ftos(VAR_HPBBAN);
			sprint(self, PRINT_HIGH, tp);
			sprint(self, PRINT_HIGH, "!\n");
		}	
	}
};


float(entity pl) AveragePing = {
	if (pl.pingtimes)
		return rint(pl.pingsum / pl.pingtimes);
	else
		return 0;
};


// *** Kick User by ID ***

void (float id, float ping) pingkick = {
	local string tmp;

/* DEBUG
	bprint(PRINT_HIGH, "User ");
	tmps=ftos(id1);
	bprint(PRINT_HIGH, tmps);
	bprint(PRINT_HIGH, " have ping ");
	tmps=ftos(ping1);
	bprint(PRINT_HIGH, tmps);
	bprint(PRINT_HIGH, " wich is lower than ");
	tmps=ftos(pingban);
	bprint(PRINT_HIGH, tmps);
	bprint(PRINT_HIGH, "- Warning ");
	tmps=ftos(kickwarning1);
	bprint(PRINT_HIGH, tmps);
	bprint(PRINT_HIGH, "\n");
*/

	bprint(PRINT_HIGH , "*** Auto LPB Kick: User ");
	tmp = ftos(id);
	bprint(PRINT_HIGH , tmp);
	bprint(PRINT_HIGH , " ***\n*** Sorry, this server is HPB only. ***\n");
	localcmd("kick ");
	localcmd(tmp);
	localcmd("\n");
};

// Check clientpings given by external program.

void () CheckPingBan = {
	local float pingban;
	local float id1, ping1, id2, ping2; 	
	local float tmp1, tmp2;
	local string tmps;

	// check every 5 seconds
	if (time <= lastkick)
		return;
	lastkick = time + 5;

	if ((infokey(world, "*version") == "2.21"))
		return;

	pingban = stof(infokey(world,"pingban"));
	if (!pingban) 
		return;

//	bprint(PRINT_HIGH, "DEBUG: Checking pings\n");
	id1 = stof(infokey(world,"id1"));
	id2 = stof(infokey(world,"id2"));
	ping1 = stof(infokey(world,"ping1"));
	ping2 = stof(infokey(world,"ping2"));

	if (((kickid1 == id2) && id2) || ((kickid2 == id1) && id1)) {
		tmp1 = id1; id1 = id2; id2 = tmp1;
		tmp1 = ping1; ping1 = ping2; ping2 = tmp1;
	}
			
	if (id1 && (ping1 <= pingban)) {
		if (id1 == kickid1) {
			kickwarning1 = kickwarning1 + 1;
			if (kickwarning1 > 2)
				pingkick(id1 , pingban);
		} else { kickid1 = id1;	kickwarning1 = 1; }
	} else { kickid1 = -1;	kickwarning1 = 0; }	
		
	if (id2 && (ping2 <= pingban)) {
		if (id2 == kickid2) {
			kickwarning2 = kickwarning2 + 1;
			if (kickwarning2 > 2)
				pingkick(id2 , pingban);
		} else { kickid2 = id2;	kickwarning2 = 2; }
	} else { kickid2 = -1;	kickwarning2 = 0; }	
	
	localcmd("exec kick.cfg\n");
};

void() CalcTeamPing = {
	local float redping, blueping, rednum, bluenum;
	local entity e;	

	redping = 0; blueping = 0; rednum = 0; bluenum = 0;

	e = PLAYER_CHAIN;
	while(e) {
		if ((e.steam == TEAM_COLOR1)) {
			redping = redping + e.pingsum;
			rednum = rednum + e.pingtimes;
		} else if ((e.steam == TEAM_COLOR2)) {
			blueping = blueping + e.pingsum;
			bluenum = bluenum + e.pingtimes;
		}		
		e = e.clientchain;
	}

	if (rednum)	
		REDPING = floor(redping / rednum);
	else 		
		REDPING = 0;
	if (bluenum)	
		BLUEPING = floor(blueping / bluenum);
	else 		
		BLUEPING = 0;
};


// *check*

