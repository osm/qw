// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterström 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************


string MINUTES_LEFT;
string SECONDS_LEFT;

float TIMELEFT;
float CURRENTTIME;

float STARTTIME;

float nextprinttimer;
float nextchecktimers;




void() StartTimer = {
	STARTTIME = time;
	nextprinttimer = 0;
	nextchecktimers = 0;
	CheckTimers();
};

void(float frozetime) AddFrozetime = {
	STARTTIME = STARTTIME + frozetime;
};


//
// Start a countdown of tm seconds and then run "fun" when it's done.
//
void(float tm, void() fun, string countdowntext) StartCountDown = {
	CountDown = floor(time + tm);
	COUNTDOWN_FUNC = fun;
	COUNTDOWN_TEXT = countdowntext;
	nextprinttimer = 0;
	nextchecktimers = 0;
	CheckTimers();
};

// 
// Prints time left to a player. *inline*
// 
void(entity pl) PrintTimeLeft = {
	PrintTime(pl, TIMELEFT);
};

//
// Print Current time to a player. *inline*
//
void(entity pl) PrintCurrentTime = {
	PrintTime(pl, CURRENTTIME);
};

//
// Print Current time to all clients
//
void() PrintCurrentTime2All = {
	PrintTime2All(CURRENTTIME);
};




//
// Update the serverinfo key "status"
//
void() SetServerinfoTime = {
	local string tmp;

	if (FLAG_STANDBY) {
		if (infokey(world, "status") != "Standby")
			localcmd("serverinfo status Standby\n");
	} else if (CountDown) {
		if (infokey(world, "status") != "Countdown")
			localcmd("serverinfo status Countdown\n");
	} else if (TIMELEFT <= 0 || gameover || pregameover) {
		if (infokey(world, "status") != "Game Ended")
			localcmd("serverinfo status \"Game Ended\"\n");
	} else {
		localcmd("serverinfo status \"");
		localcmd(MINUTES_LEFT);
		localcmd(SECONDS_LEFT);
		localcmd(" left\"\n");
	}
};

//
// Sets some global string for time.
//
void() SetTimeStrings = {
	local float y,z;
	y = floor(TIMELEFT / 60);
	z = TIMELEFT - (y * 60);
	MINUTES_LEFT = getnum2(y);
	if (CountDown)
		SECONDS_LEFT = getnum2(z);
	else
		SECONDS_LEFT = getnumsec(z);
};


//
// Prints out the timer.
//
void() PrintTimer = {
	local float min, tl, mod;
	local string tmp;

	// *check* FLAG_TIMER
	
	if (!TIMELIMIT || TIMELEFT <= 0 || (FLAG_STANDBY && !CountDown))
		return;
	if ((TIMELEFT > nextprinttimer) && nextprinttimer)
		return;


	if (TIMELEFT >= 60) {
		min =  ceil(TIMELEFT / 60);
		tmp=ftos(min);
		bprint(PRINT_MEDIUM, tmp);
		if (min == 1)
			bprint(PRINT_MEDIUM, " minute left\n");
		else
			bprint(PRINT_MEDIUM, " minutes left\n");
	} else if (TIMELEFT >= 10) {
		tmp = ftos(TIMELEFT);
		bprint(PRINT_MEDIUM, tmp);
		bprint(PRINT_MEDIUM, " seconds left\n");
	} else {
		if (FLAG_RASOUNDS) {
			if (TIMELEFT == 1) soundall("ra/1.wav"); 
			if (TIMELEFT == 2) soundall("ra/2.wav"); 
			if (TIMELEFT == 3) soundall("ra/3.wav"); 
		}
		tmp=ftos(TIMELEFT);
		bprint(PRINT_MEDIUM, tmp);
		bprint(PRINT_MEDIUM, "\n");
	}

	if (TIMELEFT > 300) mod = 300;
	else if (TIMELEFT > 60) mod = 60;
	else if (TIMELEFT > 30) mod = 30;
	else if (TIMELEFT > 10) mod = 10;
	else if (TIMELEFT > 5) mod = 5;
	else if (TIMELEFT > 0) mod = 1;
	nextprinttimer = floor((TIMELEFT - 1) / mod) * mod;
};


//
// This function checks and updates all relevant timerinfo.
//
void() CheckTimers = {
	local entity e;

	if (time < nextchecktimers)
		return;
	nextchecktimers = ceil(time + 0.1);

	if (CountDown) {
		TIMELEFT = ceil(CountDown - time);
		CURRENTTIME = 0;
	} else if (FLAG_STANDBY) {
		TIMELEFT = TIMELIMIT;
		CURRENTTIME = 0;
	} else if (FREEZEFLAGS & FREEZE_WORLD) {
		CURRENTTIME = floor( FREEZETIME - STARTTIME);
		if (TIMELIMIT)
			TIMELEFT = ceil(TIMELIMIT + STARTTIME - FREEZETIME);
		else
			TIMELEFT = CURRENTTIME;
	} else {
		CURRENTTIME = floor( time - STARTTIME);
		if (TIMELIMIT)
			TIMELEFT = ceil(TIMELIMIT + STARTTIME - time);
		else
			TIMELEFT = CURRENTTIME;
	}

	SetTimeStrings();
	SetServerinfoTime();
	PrintTimer();


	DMM_STRING = getnum2(DEATHMATCH);
	TP_STRING = getnum2(realteamplay);
	TL_STRING = getnum2(TIMELIMIT / 60);

	if (CountDown) {
		e = CLIENT_CHAIN;
		while (e) {
			PrintCountDown(e);
			e = e.clientchain;
		}
	}

	// Updatera bprint

	// Visa Countdown

};
