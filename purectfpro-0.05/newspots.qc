// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterström 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************


void() cyclespot = {
	local entity spot;

	spot = TeamCaptureSpawn();

	self.origin = spot.origin + '0 0 1';
	self.angles = spot.angles;
	self.fixangle = TRUE;		// turn this way immediately
};


void() cyclered = {
	local string tp;
	self.steam = TEAM_COLOR1;
	stuffcmd(self, "color 4\n");
	cyclespot();

	bprint(PRINT_HIGH, "Red Start spot: ");
	tp = ftos(lastred);
	bprint(PRINT_HIGH, tp);
	bprint(PRINT_HIGH, "\n");

};

void() cycleblue = {
	local string tp;
	self.steam = TEAM_COLOR2;
	stuffcmd(self, "color 13\n");
	cyclespot();

	bprint(PRINT_HIGH, "Blue Start spot: ");
	tp = ftos(lastblue);
	bprint(PRINT_HIGH, tp);
	bprint(PRINT_HIGH, "\n");

};

void(entity e) bprintfixedangle = {
	local float x;
	local string tp;
	x = e.angles_y;
	x = rint(x / 90) * 90;
	tp = ftos(x);
	bprint(PRINT_HIGH, tp);
};

void() dumpstarts = {
	local entity e;
	local string tp;
	local float x;

	bprint(PRINT_HIGH, "\n-------------------------------------\n\n");

	bprint(PRINT_HIGH, "	} else if (mapname == \"");
	bprint(PRINT_HIGH, mapname);
	bprint(PRINT_HIGH, "\") {\n");


	e = nextent(world);

	while(e) {
		if (e.newflag) {
			if (e.classname == "info_player_team1") {
				bprint(PRINT_HIGH, "		SpawnTeamStart(");
				tp = vtos(e.origin);
				bprint(PRINT_HIGH, tp);
				bprint(PRINT_HIGH, ", TEAM_COLOR1 , ");
				bprintfixedangle(e);
				bprint(PRINT_HIGH, ");\n");
			} else if (e.classname == "info_player_team2") {
				bprint(PRINT_HIGH, "		SpawnTeamStart(");
				tp = vtos(e.origin);
				bprint(PRINT_HIGH, tp);
				bprint(PRINT_HIGH, ", TEAM_COLOR2 , ");
				bprintfixedangle(e);
				bprint(PRINT_HIGH, ");\n");
			} else if (e.classname == "item_flag_team1") {
				bprint(PRINT_HIGH, "		SpawnFlag(");
				tp = vtos(e.origin);
				bprint(PRINT_HIGH, tp);
				bprint(PRINT_HIGH, ", TEAM_COLOR1 , ");
				bprintfixedangle(e);
				bprint(PRINT_HIGH, ");\n");
			} else if (e.classname == "item_flag_team2") {
				bprint(PRINT_HIGH, "		SpawnFlag(");
				tp = vtos(e.origin);
				bprint(PRINT_HIGH, tp);
				bprint(PRINT_HIGH, ", TEAM_COLOR2 , ");
				bprintfixedangle(e);
				bprint(PRINT_HIGH, ");\n");
			} else if (e.classname == "pure_wall") {
				bprint(PRINT_HIGH, "		SpawnVerticalWall(");
				tp = vtos(e.origin);
				bprint(PRINT_HIGH, tp);
				bprint(PRINT_HIGH, ", ");
				bprintfixedangle(e);
				bprint(PRINT_HIGH, ");\n");
			} else if (e.classname == "info_teleport_destination") {
				bprint(PRINT_HIGH, "		spawn_teleport_destination(");
				tp = vtos(e.origin);
				bprint(PRINT_HIGH, tp);
				bprint(PRINT_HIGH, ", ");
				e.angles_y = e.mangle_y;
				bprintfixedangle(e);
				bprint(PRINT_HIGH, ", \"");
				bprint(PRINT_HIGH, e.targetname);
				bprint(PRINT_HIGH, "\");\n");
			} else if (e.classname == "info_player_start") {
				bprint(PRINT_HIGH, "		spawn_dmstart(");
				tp = vtos(e.origin);
				bprint(PRINT_HIGH, tp);
				bprint(PRINT_HIGH, ", ");
				bprintfixedangle(e);
				bprint(PRINT_HIGH, ");\n");
			} else {
				bprint(PRINT_HIGH, "		SpawnItem(\"");
				bprint(PRINT_HIGH, e.classname);
				bprint(PRINT_HIGH, "\", ");
				tp = vtos(e.origin);
				bprint(PRINT_HIGH, tp);
				bprint(PRINT_HIGH, ");\n");
			}


		}
		e = nextent(e);
	}

	bprint(PRINT_HIGH, "\n-------------------------------------\n\n");


};



void() ExtraTeamSpots = {

	return;

};




// *check*
