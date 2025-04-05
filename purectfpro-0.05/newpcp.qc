// *****************************************************************
//  Pure CTF Pro by dyna and hrz
//  blah blah
// *****************************************************************


// ----- List -----

void() DoList = {
	local entity e;

	if (CountDown) {
		sprint(self, PRINT_HIGH, "Countdown's started.\n");
	}
	else if (FLAG_STANDBY) {
		e = find(world, classname, "notready");
		bprint(PRINT_HIGH, "Players not ready:\n\n");
		while (e) {
			bprint(PRINT_HIGH, e.netname);
			bprint(PRINT_HIGH, "\n");
			e = find(e, classname, "notready");
		}
	}
	else { sprint(self, PRINT_HIGH, "Can't list during match.\n"); }

};


// ----- Whonot -----

void() DoWhonot = {
	local entity e;

	if (CountDown) {
		sprint(self, PRINT_HIGH, "Countdown's started.\n");
	}
	else if (FLAG_STANDBY) {
		e = find(world, classname, "notready");
		sprint(self, PRINT_HIGH, "Players not ready:\n\n");
		while (e) {
			sprint(self, PRINT_HIGH, e.netname);
			sprint(self, PRINT_HIGH, "\n");
			e = find(e, classname, "notready");
		}
	}
	else { sprint(self, PRINT_HIGH, "Can't list during game.\n"); }

};



// ------ Rpickup ------
// Buggy as hell.

void () DoRpickup = {
	local entity e;
	local float x,y,p;

	x = ReturnNumPlayers();
	y = x / 2;
	y = ceil(y);

	PutAllOnBlue();

	while (y > 0) {
		p = random() * x - 0.1;
		p = floor(p);
		while (PlayerIsRed(p)) {	//Renew p if player is already red.
			p = random() * x - 0.1;
			p = floor(p);
		}
		PutPlayerOnRed(p);
		y = y - 1;
	}
	bprint(PRINT_HIGH, "Random pickup game.\n");
};

float () ReturnNumPlayers = {
	local entity e;
	local float x;

	e = PLAYER_CHAIN;
	while (e) {
		x = x + 1;
		e = e.clientchain;
	}

	return x;
};

void (float p) PutPlayerOnRed = {
	local entity e;

	e = PLAYER_CHAIN;

	while (p > 0) {
		e = e.clientchain;
		p = p - 1;
	}
	stuffcmd(e, "color 4;team red\n");	
};

void () PutAllOnBlue = {
	local entity e;

	e = PLAYER_CHAIN;

	while (e) {
		stuffcmd(e, "color 13;team blue\n");
		e = e.clientchain;
	}
};

float (float p) PlayerIsRed = {
	local entity e;

	e = PLAYER_CHAIN;

	while (p > 0) {
		e = e.clientchain;
		p = p - 1;
	}

	if ((e.team == TEAM_COLOR1))
		return 1;
	else
		return 0;

};