// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterström 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************
//  Mapconversions for Arena and CTF Arena
// *****************************************************************

void() ArenaMaps = {
	if (0) { return;
	} else if (mapname == "e2m1") {
		SpawnTeamStart('1205.0 -10.8 136.0', TEAM_COLOR1 , 0);
		SpawnTeamStart('1195.4 154.5 136.0', TEAM_COLOR1 , 0);
		SpawnTeamStart('1208.1 -132.1 136.0', TEAM_COLOR1 , 0);
		SpawnTeamStart('1988.1 162.6 136.0', TEAM_COLOR2 , 0);
		SpawnTeamStart('1985.4 290.3 136.0', TEAM_COLOR2 , 0);
		SpawnTeamStart('1994.1 -26.0 136.0', TEAM_COLOR2 , 0);
		SpawnVerticalWall('1999.3 623.0 168.0', 90);
		SpawnVerticalWall('1114.3   6.8  24.0', 0);
		SpawnVerticalWall('1215.8 583.1 168.0', 90);
		SpawnVerticalWall('1070.5 295.8  40.0', 0);
	} else if (mapname == "ctf2m1") {
		SpawnVerticalWall('-432.5 -1345.1  56.0', 0);
		SpawnVerticalWall('760.0 -1326.1 -200.0', 0);
		SpawnVerticalWall(' 37.5 -585.5 -560.0', 90);
		spawn_teleport_destination('-361.9 -1329.3  51.0', 0, "purearena");
		spawn_teleport_destination('-120.0 -1984.0  51.0', 90, "rc2");
		spawn_teleport_destination('192.0 -1104.0 -205.0', 270, "rc1");
		SpawnTeamStart(' 96.9 -1391.3  24.0', TEAM_COLOR2 , 0);
		SpawnItem("item_flag_team1_temp", '359.6 -1705.6   0.0');
		SpawnItem("item_flag_team2_temp", '-83.5 -1497.4   0.0');
		SpawnTeamStart('-105.1 -1559.4  24.0', TEAM_COLOR2 , 0);
		spawn_teleport_destination('615.3 -1321.4 -205.0', 0, "purearena");
		spawn_dmstart('341.5 -1412.0  24.0', 0);
		spawn_teleport_destination('-111.3 -1568.5  51.0', 0, "purearena");
		spawn_teleport_destination('381.1 -1575.4 -77.0', 0, "purearena");
		spawn_dmstart('203.0 -1260.5 -232.0', 0);
		spawn_dmstart('353.9 -1724.1  24.0', 0);
		spawn_dmstart('-111.3 -1686.6  24.0', 0);
		SpawnTeamStart('193.0 -1751.9  24.0', TEAM_COLOR1 , -180);
		SpawnTeamStart('360.8 -1311.9 -232.0', TEAM_COLOR1 , 180);
		SpawnTeamStart('-86.4 -1316.6 -232.0', TEAM_COLOR2 , 0);
		SpawnTeamStart('-118.6 -1687.9 -232.0', TEAM_COLOR2 , 0);
		SpawnTeamStart('399.3 -1596.9 -104.0', TEAM_COLOR1 , 180);
		SpawnTeamStart('382.1 -1595.9  24.0', TEAM_COLOR1 , 180);
		ARENA_INHIBIT = 1;
		ARENA_SPECFLAG = 1;
	} else if (mapname == "e4m3") {
		SpawnVerticalWall('317.8 1047.9 184.0', 0);
		SpawnVerticalWall('753.1 342.4  56.0', 90);
		SpawnVerticalWall('1244.5 1063.9 184.0', 0);
		SpawnTeamStart('719.4 1088.3 152.0', TEAM_COLOR1 , -90);
		SpawnItem("item_flag_team1_temp", '770.5 1101.1 128.0');
		SpawnItem("item_flag_team2_temp", '773.1 521.0 200.0');
		SpawnTeamStart('688.3 640.4  24.0', TEAM_COLOR2 , 90);
		SpawnTeamStart('702.6 622.9 224.0', TEAM_COLOR2 , 90);
		SpawnTeamStart('888.6 1082.8 152.0', TEAM_COLOR1 , -90);
		SpawnTeamStart('1009.6 1076.4 152.0', TEAM_COLOR1 , -90);
		SpawnTeamStart('537.3 1090.6 152.0', TEAM_COLOR1 , -90);
		SpawnTeamStart('821.4 620.9 224.0', TEAM_COLOR2 , 90);
		SpawnTeamStart('818.4 641.3  24.0', TEAM_COLOR2 , 90);
		spawn_teleport_destination('733.0 549.0 251.0', 90, "purearena");
		spawn_teleport_destination('761.9 540.3  51.0', 90, "purearena");
		spawn_teleport_destination('578.6 1064.4 179.0', -90, "purearena");
		spawn_teleport_destination('959.6 1118.1 179.0', -90, "purearena");
		spawn_dmstart('858.5 1074.1 152.0', 0);
		spawn_dmstart('685.5 1082.9 152.0', 0);
		spawn_dmstart('1229.6 1064.4 152.0', 0);
		spawn_dmstart('776.5 528.0  24.0', 0);
		ARENA_INHIBIT = 1;
		ARENA_SPECFLAG = 1;
	}
};

void() ArenaEpisodeSpawn = {
	if (0) {
		return;
	} else if (mapname == "arenazap") {
		SpawnTeamStart('348.9  77.8  24.0', TEAM_COLOR1 , -180);
		SpawnTeamStart('352.5 -204.1  24.0', TEAM_COLOR1 , -180);
		SpawnTeamStart('-352.8 -213.4  24.0', TEAM_COLOR2 , 0);
		SpawnTeamStart('-344.1  65.9  24.0', TEAM_COLOR2 , 0);
		SpawnFlag('353.8 -71.9  24.0', TEAM_COLOR1 , 0);
		SpawnFlag('-350.8 -75.4  24.0', TEAM_COLOR2 , 0);
	} else if (mapname == "arenax") {
		SpawnTeamStart('274.3 -343.9 -76.0', TEAM_COLOR1 , 90);
		SpawnTeamStart('495.6 -176.6 -76.0', TEAM_COLOR1 , 90);
		SpawnTeamStart('-187.9 365.3 -76.0', TEAM_COLOR2 , 0);
		SpawnTeamStart('-341.3 168.9 -76.0', TEAM_COLOR2 , 0);
		SpawnFlag('398.3 -253.8 -100.0', TEAM_COLOR1 , 90);
		SpawnFlag('-260.8 278.3 -100.0', TEAM_COLOR2 , 0);
	} else if (mapname == "arenarg2") {
		SpawnTeamStart(' 88.1 -451.1 -104.0', TEAM_COLOR1 , 90);
		SpawnTeamStart('-105.1 -431.3 -104.0', TEAM_COLOR1 , 90);
		SpawnTeamStart('119.1 519.6 -168.0', TEAM_COLOR2 , -90);
		SpawnTeamStart('-137.0 494.5 -168.0', TEAM_COLOR2 , -90);
		SpawnFlag('0.0 -544.3 -165.4', TEAM_COLOR1 , 90);
		SpawnFlag('-1.8 588.0 -162.0', TEAM_COLOR2 , -90);

	} else if (mapname == "xarena3") {
		SpawnTeamStart('596.0 308.4 184.0', TEAM_COLOR1 , -180);
		SpawnTeamStart('423.8 379.6 -168.0', TEAM_COLOR1 , -90);
		SpawnTeamStart('106.8 -676.5 -168.0', TEAM_COLOR2 , 90);
		SpawnTeamStart('-291.5 -84.4 -168.0', TEAM_COLOR2 , 90);
		SpawnFlag('471.9 473.4 160.0', TEAM_COLOR1 , -180);
		SpawnFlag('-212.1 -336.8 -192.0', TEAM_COLOR2 , 90);

	} else if (mapname == "arenrg3a") {
		SpawnTeamStart('-265.3 -316.1  -8.0', TEAM_COLOR1 , 90);
		SpawnTeamStart(' 84.3 -327.4  -8.0', TEAM_COLOR1 , 90);
		SpawnTeamStart('149.4 312.0 120.0', TEAM_COLOR2 , -90);
		SpawnTeamStart('412.1 126.5 120.0', TEAM_COLOR2 , -90);
		SpawnFlag('-78.1 -335.1 -32.0', TEAM_COLOR1 , 90);
		SpawnFlag('377.8 301.0  96.0', TEAM_COLOR2 , -90);

	} else if (mapname == "football") {
		SpawnTeamStart('596.3 -208.0 -476.0', TEAM_COLOR1 , 90);
		SpawnTeamStart('295.6 -198.5 -476.0', TEAM_COLOR1 , 90);
		SpawnTeamStart('275.1 461.5 -476.0', TEAM_COLOR2 , -90);
		SpawnTeamStart('557.9 468.4 -476.0', TEAM_COLOR2 , -90);
		SpawnFlag('415.8 -234.3 -349.0', TEAM_COLOR1 , 90);
		SpawnFlag('394.8 543.6 -349.0', TEAM_COLOR2 , -90);

	}
};
