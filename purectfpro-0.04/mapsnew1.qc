// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterström 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************
//  Custom mapconversions.
// *****************************************************************

void() Custom1Spawn = {
	if (mapname == "EXAMPLEMAP") {
		SpawnFlag('2512.0 -608.0   0.0', TEAM_COLOR1 , 0);
		SpawnFlag('-2144.0 -608.0   0.0', TEAM_COLOR2 , 0);
		SpawnTeamStart('-105.1 -1559.4  24.0', TEAM_COLOR1 , 0);
		SpawnTeamStart(' 96.9 -1391.3  24.0', TEAM_COLOR2 , 0);
	// Insert your own map conversions from here -->



	// <-- to here.
	}
};


void() Custom1Change = {
	return;
};
