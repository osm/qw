// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterström 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************

float(string tp) IsArenamap = {
	return ((tp == "arenax") ||	(tp == "terrain2") || (tp == "xarena3") || (tp == "arenazap") ||
		(tp == "arenarg2") || (tp == "arenrg3a") || (tp == "mayan1") || (tp == "2pyramid") ||
		(tp == "2towers") || (tp == "arenarg4") || (tp == "arenarg5") || (tp == "arenarg6") ||
		(tp == "arma4") || (tp == "crandome") || (tp == "egyptra") ||                                                                                                                                  
		(tp == "hill20") || (tp == "iarena2") || (tp == "pitarena") || (tp == "ra_funkf") ||                                                                                                                                 
		(tp == "rgarden") || (tp == "barena1") || (tp == "bbarena2") || (tp == "dm2arena") ||                                                                                                                                 
		(tp == "marena2") || (tp == "marena3") || (tp == "marena4") || (tp == "rarena3") ||                                                                                                                                  
		(tp == "soyarena") || (tp == "uarena1") || (tp == "23ar-a") || (tp == "arendm1a") ||                                                                                                                                
		(tp == "basarena") || (tp == "bunmoo3") || (tp == "bunski") || (tp == "chamber1") ||                                                                                                                                 
		(tp == "dom2_1ra") || (tp == "football") || (tp == "gear8") || (tp == "gnurena") ||                                                                                                                                  
		(tp == "id3") || (tp == "lowgrav") || (tp == "nilsrar3") || (tp == "pen2") ||                                                                                                                                     
		(tp == "ptucket") || (tp == "unholy") || (tp == "yard1"));
};

float (string tp) IsCTFMap = {
	return ((tp == "ctf1") || (tp == "ctf2") || (tp == "ctf3") || (tp == "ctf4") || 
		(tp == "ctf5") || (tp == "ctf6") || (tp == "ctf7") || (tp == "ctf8") || 
		(tp == "ctf2m1") || (tp == "ctf2m2") || (tp == "ctf2m3") || (tp == "ctf2m4") || 
		(tp == "ctf2m5") || (tp == "ctf2m6") || (tp == "ctf2m7") || (tp == "ctf2m8"));
	// *check* more maps
};


void() func_door;

void() Episode1Spawn =
{
	local entity e;

	if (mapname == "e1m1") {
		spawn_supernailgun('1360 792 -272');
		spawn_armor('1312 792 -272' , 1);
		spawn_supershotgun('1264 792 -272');
		spawn_nails('1360 748 -272' , 0);
		spawn_nails('1312 748 -272' , 0);
		spawn_nails('1264 748 -272' , 0);
		spawn_shells('1360 700 -272' , 0);
		spawn_shells('1312 700 -272' , 0);
		spawn_shells('1264 700 -272' , 0);
		spawn_health('528 384 0' , 0);
		spawn_health('480 384 0' , 0);
		spawn_health('432 384 0' , 0);
		spawn_supernailgun('528 432 0');
		spawn_armor('480 432 0' , 1);
		spawn_supershotgun('432 432 0');
		spawn_nails('528 480 0' , 0);
		spawn_nails('480 480 0' , 0);
		spawn_nails('432 480 0' , 0);
		spawn_shells('528 528 0' , 0);
		spawn_shells('480 528 0' , 0);
		spawn_shells('432 528 0' , 0);
		SpawnTeamStart('1312 920 -256', TEAM_COLOR2 , 90);
		SpawnTeamStart('1392 1000 -256', TEAM_COLOR2 , 90);
		SpawnTeamStart('1312 1000 -256', TEAM_COLOR2 , 90);
		SpawnTeamStart('1232 1000 -256', TEAM_COLOR2 , 90);
		SpawnTeamStart('1392 920 -256', TEAM_COLOR2 , 90);
		SpawnTeamStart('1312 920 -256', TEAM_COLOR2 , 90);
		SpawnTeamStart('1232 920 -256', TEAM_COLOR2 , 90);
		SpawnFlag('1312 640 -256' , TEAM_COLOR2 , 0);
		SpawnTeamStart('420 268 24' , TEAM_COLOR1 , 90);
		SpawnTeamStart('540 268 24' , TEAM_COLOR1 , 90);
		SpawnTeamStart('420 188 24' , TEAM_COLOR1 , 90);
		SpawnTeamStart('540 188 24' , TEAM_COLOR1 , 90);
		SpawnTeamStart('420 128 24' , TEAM_COLOR1 , 90);
		SpawnTeamStart('540 128 24' , TEAM_COLOR1 , 90);
		SpawnFlag('480 -52 40' , TEAM_COLOR1 , 0);
	} else if (mapname == "e1m2") {
		SpawnTeamStart('-525 -400 480', TEAM_COLOR2 , 0);
		SpawnTeamStart('-525 -600 480', TEAM_COLOR2 , 0);
		SpawnTeamStart('-525 -500 480', TEAM_COLOR2 , 0);
		SpawnTeamStart('-525 -400 480', TEAM_COLOR2 , 0);
		SpawnTeamStart('-425 -600 480', TEAM_COLOR2 , 0);
		SpawnTeamStart('-425 -500 480', TEAM_COLOR2 , 0);
		SpawnTeamStart('-425 -400 480', TEAM_COLOR2 , 0);
		SpawnFlag('-600 -500 500' , TEAM_COLOR2 , 0);
		SpawnTeamStart('1596 1340 200' , TEAM_COLOR1 , 270);
		SpawnTeamStart('1496 1340 200' , TEAM_COLOR1 , 270);
		SpawnTeamStart('1396 1340 200' , TEAM_COLOR1 , 270);
		SpawnTeamStart('1596 1240 200' , TEAM_COLOR1 , 270);
		SpawnTeamStart('1496 1240 204' , TEAM_COLOR1 , 270);
		SpawnTeamStart('1396 1240 200' , TEAM_COLOR1 , 270);
		SpawnFlag('1496 1668 308' , TEAM_COLOR1 , 90);
	} else if (mapname == "e1m3") {
		SpawnTeamStart('1466 477 -132', TEAM_COLOR2 , 0);
		SpawnTeamStart('1366 477 -132', TEAM_COLOR2 , 0);
		SpawnTeamStart('1266 477 -132', TEAM_COLOR2 , 0);
		SpawnTeamStart('1466 377 -132', TEAM_COLOR2 , 0);
		SpawnTeamStart('1366 377 -132', TEAM_COLOR2 , 0);
		SpawnTeamStart('1266 377 -132', TEAM_COLOR2 , 0);
		SpawnFlag('1360 434 -132' , TEAM_COLOR2 , 90);
		SpawnTeamStart('-634 -1660 104' , TEAM_COLOR1 , 270);
		SpawnTeamStart('-734 -1660 104' , TEAM_COLOR1 , 270);
		SpawnTeamStart('-834 -1660 104' , TEAM_COLOR1 , 270);
		SpawnTeamStart('-634 -1760 104' , TEAM_COLOR1 , 270);
		SpawnTeamStart('-734 -1760 104' , TEAM_COLOR1 , 270);
		SpawnTeamStart('-834 -1760 104' , TEAM_COLOR1 , 270);
		SpawnFlag('-950 -1865 92' , TEAM_COLOR1 , 0);
		spawn_armor('-288 -992 48' , 1);

	} else if (mapname == "e1m4") {
		spawn_shells('1240 768 1384', 0);
		spawn_health('1144 912 1384' , 0);
		spawn_health('1192 912 1384' , 0);
		spawn_health('1240 912 1384' , 0);
		spawn_supernailgun('1144 864 1384');
		spawn_armor('1192 864 1384' , 2);
		spawn_supershotgun('1240 864 1384');
		spawn_nails('1144 816 1384' , 0);
		spawn_nails('1192 816 1384' , 0);
		spawn_nails('1240 816 1384' , 0);
		spawn_rockets('1144 768 1384' , 1);
		spawn_shells('1192 768 1384' , 0);
		spawn_supernailgun('-168 2160 1220');
		spawn_armor('-120 2160 1220' , 1);
		spawn_supershotgun('-72 2160 1220');
		spawn_nails('-168 2112 1220' , 0);
		spawn_nails('-120 2112 1220' , 0);
		spawn_nails('-72 2112 1220' , 0);
		spawn_shells('-168 2064 1220' , 0);
		spawn_shells('-120 2064 1220' , 0);
		spawn_shells('-72 2064 1220' , 0);
		spawn_health('-488 2160 1220' , 0);
		SpawnTeamStart('1210 920 1407', TEAM_COLOR2 , 270);
		SpawnTeamStart('1160 920 1407', TEAM_COLOR2 , 270);
		SpawnTeamStart('1210 820 1407', TEAM_COLOR2 , 270);
		SpawnTeamStart('1160 820 1407', TEAM_COLOR2 , 270);
		SpawnTeamStart('1210 870 1407', TEAM_COLOR2 , 270);
		SpawnTeamStart('1160 870 1407', TEAM_COLOR2 , 270);
		SpawnTeamStart('1210 870 1407', TEAM_COLOR2 , 270);
		SpawnFlag('1288 912 1484' , TEAM_COLOR2 , 0);
		SpawnTeamStart('-184 2161 1242' , TEAM_COLOR1 , 270);
		SpawnTeamStart('-284 2161 1242' , TEAM_COLOR1 , 270);
		SpawnTeamStart('-184 2261 1242' , TEAM_COLOR1 , 270);
		SpawnTeamStart('-284 2261 1242' , TEAM_COLOR1 , 270);
		SpawnTeamStart('-184 2211 1242' , TEAM_COLOR1 , 270);
		SpawnTeamStart('-284 2211 1242' , TEAM_COLOR1 , 270);
		SpawnFlag('-416 2112 1220' , TEAM_COLOR1 , 0);
	} else if (mapname == "e1m5") {
		spawn_supershotgun('-264 2547 424');
		spawn_nails('704 1920 16' , 1);
		spawn_supernailgun('704 1872 16');
		spawn_supershotgun('881 1769 16');
		spawn_rockets('-662 236 171' , 1);
		SpawnTeamStart('189 2263 264', TEAM_COLOR2 , 0);
		SpawnTeamStart('-42 2214 264', TEAM_COLOR2 , 0);
		SpawnTeamStart('-127 2551 344', TEAM_COLOR2 , 0);
		SpawnTeamStart('141 2561 424', TEAM_COLOR2 , 0);
		SpawnTeamStart('339 2643 424', TEAM_COLOR2 , 0);
		SpawnTeamStart('339 2455 424', TEAM_COLOR2 , 0);
		SpawnFlag('313 2543 424' , TEAM_COLOR2 , 0);
		SpawnTeamStart('706 1681 20' , TEAM_COLOR1 , 0);
		SpawnTeamStart('704 1528 20' , TEAM_COLOR1 , 90);
		SpawnTeamStart('500 1811 16' , TEAM_COLOR1 , 0);
		SpawnTeamStart('533 1421 16' , TEAM_COLOR1 , 0);
		SpawnTeamStart('297 1834 16' , TEAM_COLOR1 , 0);
		SpawnTeamStart('121 1620 16' , TEAM_COLOR1 , 180);
		SpawnFlag('704 1616 20' , TEAM_COLOR1 , 0);
		spawn_health('-560 1732 -240' , 2);
		spawn_armor('-1536 2080 128' , 2);
	} else if (mapname == "e1m6") {
		SpawnTeamStart('-804 516 24', TEAM_COLOR2 , 0);
		SpawnTeamStart('-804 416 24', TEAM_COLOR2 , 0);
		SpawnTeamStart('-804 316 24', TEAM_COLOR2 , 0);
		SpawnTeamStart('-904 516 24', TEAM_COLOR2 , 0);
		SpawnTeamStart('-904 416 24', TEAM_COLOR2 , 0);
		SpawnTeamStart('-904 316 24', TEAM_COLOR2 , 0);
		SpawnFlag('-1004 416 44' , TEAM_COLOR2 , 0);
		SpawnTeamStart('500 396 24' , TEAM_COLOR1 , 90);
		SpawnTeamStart('500 296 24' , TEAM_COLOR1 , 90);
		SpawnTeamStart('500 196 24' , TEAM_COLOR1 , 90);
		SpawnTeamStart('600 396 24' , TEAM_COLOR1 , 90);
		SpawnTeamStart('600 296 24' , TEAM_COLOR1 , 90);
		SpawnTeamStart('600 196 24' , TEAM_COLOR1 , 90);
		SpawnFlag('1100 296 48' , TEAM_COLOR1 , 0);
	} else if (mapname == "e1m7") {
		SpawnTeamStart('-532 57 56', TEAM_COLOR2 , 0);
		SpawnTeamStart('-472 117 56', TEAM_COLOR2 , 0);
		SpawnTeamStart('-472 57 56', TEAM_COLOR2 , 0);
		SpawnTeamStart('-472 -3 56', TEAM_COLOR2 , 0);
// new
		SpawnTeamStart('930 400 216', TEAM_COLOR1, 180);
		SpawnTeamStart('930 225 216', TEAM_COLOR1, 180);
		SpawnTeamStart('930 100 216', TEAM_COLOR1, 180);
		SpawnTeamStart('930 -250 216', TEAM_COLOR1, 180);

		SpawnFlag('-532 57 32' , TEAM_COLOR2 , 0);
		SpawnFlag('839 62 148' , TEAM_COLOR1 , 0);
	} else if (mapname == "e1m8") {
		spawn_supernailgun('722 570 280');
		spawn_armor('672 570 280' , 1);
		spawn_supershotgun('622 570 280');
		spawn_nails('722 520 280' , 0);
		spawn_nails('672 520 280' , 0);
		spawn_nails('622 520 280' , 0);
		spawn_shells('722 470 280' , 0);
		spawn_shells('672 470 280' , 0);
		spawn_shells('622 470 280' , 0);
		spawn_health('722 420 280' , 0);
		spawn_health('672 420 280' , 0);
		spawn_health('622 420 280' , 0);
		SpawnTeamStart('772 300 280', TEAM_COLOR2 , 0);
		SpawnTeamStart('672 300 280', TEAM_COLOR2 , 0);
		SpawnTeamStart('572 300 280', TEAM_COLOR2 , 0);
		SpawnTeamStart('772 200 280', TEAM_COLOR2 , 0);
		SpawnTeamStart('672 200 280', TEAM_COLOR2 , 0);
		SpawnTeamStart('572 200 280', TEAM_COLOR2 , 0);
		SpawnFlag('672 132 300' , TEAM_COLOR2 , 0);
		spawn_supernailgun('642 -550 280');
		spawn_armor('592 -550 280' , 1);
		spawn_supershotgun('542 -550 280');
		spawn_nails('642 -500 280' , 0);
		spawn_nails('592 -500 280' , 0);
		spawn_nails('542 -500 280' , 0);
		spawn_shells('642 -450 280' , 0);
		spawn_shells('592 -450 280' , 0);
		spawn_shells('542 -450 280' , 0);
		spawn_health('642 -400 280' , 0);
		spawn_health('592 -400 280' , 0);
		spawn_health('542 -400 280' , 0);
		SpawnTeamStart('692 -320 280' , TEAM_COLOR1 , 270);
		SpawnTeamStart('592 -320 280' , TEAM_COLOR1 , 270);
		SpawnTeamStart('492 -320 280' , TEAM_COLOR1 , 270);
		SpawnTeamStart('692 -220 280' , TEAM_COLOR1 , 270);
		SpawnTeamStart('592 -220 280' , TEAM_COLOR1 , 270);
		SpawnTeamStart('492 -220 280' , TEAM_COLOR1 , 270);
		SpawnFlag('592 -150 300' , TEAM_COLOR1 , 180);
	}
};

void() Episode1Change =
{
	local entity e;

	if (mapname == "e1m1") {
		e = FindByModel("door" , "*21");
		e.spawnflags  = 34;
	} else if (mapname == "e1m2") {
		RemoveByModel("door", "*23");
		RemoveByModel("door", "*24");
		RemoveByModel("door", "*25");
		RemoveByModel("door", "*26");
		RemoveByModel("door", "*27");
		e = FindByModel("door" , "*48");
		e.spawnflags  = 33;
	} else if (mapname == "e1m3") {
		e = FindByOrigin("item_armor1" , '-288 -992 48');
		remove(e);
		e = FindByModel("door" , "*54");
		e.spawnflags  = 33;
		e = FindByTargetname("info_teleport_destination" , "t86");
		e.mangle_y = 270;
		setorigin(e , '1609 -9 107');
		e = FindByTarget("trigger_teleport" , "t172");
		e.target  = "t86";
	} else if (mapname == "e1m4") {
		RemoveByOrigin("item_shells" , '1240 768 1384');
	} else if (mapname == "e1m5") {
		e = FindByOrigin("item_armor1" , '-544 1736 -264');
		remove(e);
		e = FindByOrigin("item_armor2" , '-1536 2072 128');
		remove(e);
		e = FindByTarget("trigger_teleport" , "t46");
		remove(e);
		e = FindByTarget("trigger_teleport" , "t45");
		remove(e);
		e = FindByTargetname("info_teleport_destination" , "t45");
		remove(e);
		e = FindByTargetname("info_teleport_destination" , "t46");
		remove(e);
		e = FindByTarget("trigger_teleport" , "t45");
		remove(e);
		e = FindByTargetname("info_teleport_destination" , "t115");
		e.mangle_y = 270;
		setorigin(e , '-545 1825 371');

		local entity oself;
		e = FindByTarget("func_button", "t35");
		oself=self;
		self = e;
		e.use();
		self = oself;

	} else if (mapname == "e1m6") {
		return;
	} else if (mapname == "e1m7") {
		return;
	} else if (mapname == "e1m8") {
		return;
	}
};


void() Episode2Spawn =
{
	local entity e;
	if (mapname == "e2m1") {
		SpawnTeamStart('42 162 -40', TEAM_COLOR2 , 0);
		SpawnTeamStart('-62 162 -40', TEAM_COLOR2 , 0);
		SpawnTeamStart('-142 162 -40', TEAM_COLOR2 , 0);
		SpawnTeamStart('42 82 -40', TEAM_COLOR2 , 0);
		SpawnTeamStart('-62 82 -40', TEAM_COLOR2 , 0);
		SpawnTeamStart('-142 82 -40', TEAM_COLOR2 , 0);
		SpawnFlag('-300 -25 -30' , TEAM_COLOR2 , 270);
		SpawnTeamStart('1836 570 248' , TEAM_COLOR1 , 90);
		SpawnTeamStart('1736 570 248' , TEAM_COLOR1 , 90);
		SpawnTeamStart('1836 490 248' , TEAM_COLOR1 , 90);
		SpawnTeamStart('1736 490 248' , TEAM_COLOR1 , 90);
		SpawnTeamStart('1836 410 248' , TEAM_COLOR1 , 90);
		SpawnTeamStart('1736 410 248' , TEAM_COLOR1 , 90);
		SpawnFlag('1800 416 244' , TEAM_COLOR1 , 0);

	} else if (mapname == "e2m2") {
		SpawnTeamStart('1902 -76 200', TEAM_COLOR2 , 180);
		SpawnTeamStart('1902 -176 200', TEAM_COLOR2 , 180);
		SpawnTeamStart('1902 -276 200', TEAM_COLOR2 , 180);
		SpawnTeamStart('1982 -76 200', TEAM_COLOR2 , 180);
		SpawnTeamStart('1982 -176 200', TEAM_COLOR2 , 180);
		SpawnTeamStart('1982 -276 200', TEAM_COLOR2 , 180);
		SpawnFlag('2062 -176 240' , TEAM_COLOR2 , 0);
		SpawnTeamStart('-186 -1724 248' , TEAM_COLOR1 , 90);
		SpawnTeamStart('-266 -1724 248' , TEAM_COLOR1 , 90);
		SpawnTeamStart('-346 -1724 248' , TEAM_COLOR1 , 90);
		SpawnTeamStart('-176 -1872 264' , TEAM_COLOR1 , 90);
		SpawnTeamStart('-256 -1872 264' , TEAM_COLOR1 , 90);
		SpawnTeamStart('-336 -1872 264' , TEAM_COLOR1 , 90);
		SpawnFlag('-256 -1952 300' , TEAM_COLOR1 , 0);
		spawn_func_wall("*37");
		spawn_func_wall("*36");
		spawn_func_wall("*35");
		spawn_func_wall("*34");
		spawn_func_wall("*33");

	} else if (mapname == "e2m3") {
		SpawnTeamStart('-530 -402 88', TEAM_COLOR2 , 0);
		SpawnTeamStart('-530 -322 88', TEAM_COLOR2 , 0);
		SpawnTeamStart('-530 -242 88', TEAM_COLOR2 , 0);
		SpawnTeamStart('-610 -402 88', TEAM_COLOR2 , 0);
		SpawnTeamStart('-610 -322 88', TEAM_COLOR2 , 0);
		SpawnTeamStart('-610 -242 88', TEAM_COLOR2 , 0);
		SpawnFlag('-616 -322 108' , TEAM_COLOR2 , 0);
		SpawnTeamStart('40 1526 -168' , TEAM_COLOR1 , 90);
		SpawnTeamStart('40 1456 -168' , TEAM_COLOR1 , 90);
		SpawnTeamStart('40 1360 -168' , TEAM_COLOR1 , 90);
		SpawnTeamStart('-60 1526 -168' , TEAM_COLOR1 , 90);
		SpawnTeamStart('-60 1456 -168' , TEAM_COLOR1 , 90);
		SpawnTeamStart('-60 1360 -168' , TEAM_COLOR1 , 90);
		SpawnFlag('-80 1456 -162' , TEAM_COLOR1 , 0);


	} else if (mapname == "e2m4") {
		spawn_health('1640 1474 8' , 0);
		spawn_health('1687 1474 8' , 0);
		spawn_nails('-1150 1380 152' , 1);
		spawn_nails('-700 1904 256' , 1);
		spawn_supernailgun('-656 1922 256');
		spawn_supershotgun('1274 305 344');
		spawn_armor('-1351 2023 152' , 0);
		spawn_supershotgun('-1137 1724 232');
		SpawnTeamStart('1759 1211 56', TEAM_COLOR2 , 180);
		SpawnTeamStart('802 1220 224', TEAM_COLOR2 , 270);
		SpawnTeamStart('827 449 56', TEAM_COLOR2 , 90);
		SpawnTeamStart('994 310 280', TEAM_COLOR2 , 180);
		SpawnTeamStart('1346 377 344', TEAM_COLOR2 , 180);
		SpawnTeamStart('1346 249 344', TEAM_COLOR2 , 180);
		SpawnFlag('1345 304 344' , TEAM_COLOR2 , 0);
		SpawnTeamStart('-487 1718 552' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-914 1728 512' , TEAM_COLOR1 , 180);
		SpawnTeamStart('-1048 1876 232' , TEAM_COLOR1 , 180);
		SpawnTeamStart('-1048 1572 232' , TEAM_COLOR1 , 180);
		SpawnTeamStart('-1417 1381 152' , TEAM_COLOR1 , 90);
		SpawnTeamStart('-1263 1381 152' , TEAM_COLOR1 , 90);
		SpawnFlag('-1335 1351 152' , TEAM_COLOR1 , 0);
		spawn_pentagram('2192 1664 128');
		spawn_armor('1840 1176 32' , 1);
		spawn_nailgun('1776 1088 -192');

	} else if (mapname == "e2m5") {
		SpawnTeamStart('-1056 3044 -48', TEAM_COLOR2 , 0);
		SpawnTeamStart('-1056 2944 -48', TEAM_COLOR2 , 0);
		SpawnTeamStart('-1056 2844 -48', TEAM_COLOR2 , 0);
		SpawnTeamStart('-1200 3044 -96', TEAM_COLOR2 , 0);
		SpawnTeamStart('-1200 2944 -96', TEAM_COLOR2 , 0);
		SpawnTeamStart('-1200 2844 -96', TEAM_COLOR2 , 0);
		SpawnFlag('-1246 2944 -76' , TEAM_COLOR2 , 0);
		SpawnTeamStart('-956 -1146 -216' , TEAM_COLOR1 , 90);
		SpawnTeamStart('-856 -1146 -216' , TEAM_COLOR1 , 90);
		SpawnTeamStart('-756 -1146 -216' , TEAM_COLOR1 , 90);
		SpawnTeamStart('-956 -1246 -232' , TEAM_COLOR1 , 90);
		SpawnTeamStart('-856 -1246 -232' , TEAM_COLOR1 , 90);
		SpawnTeamStart('-756 -1246 -232' , TEAM_COLOR1 , 90);
		SpawnFlag('-856 -1296 -200' , TEAM_COLOR1 , 0);

	} else if (mapname == "e2m6") {
		spawn_armor('1516 193 -392' , 0);
		spawn_health('2575 140 -280' , 1);
		spawn_armor('1330 1120 -744' , 1);
		spawn_armor('2783 -324 -472' , 1);
		spawn_teleport_destination('608 -496 -440' , 90 , "Q-Man");
		spawn_trigger_teleport("Q-Man" , "*76");
		spawn_rocketlauncher('923 1635 -768');
		spawn_supershotgun('610 110 -488');
		spawn_lightning('609 493 -504');
		spawn_armor('1176 407 -488' , 2);
		SpawnTeamStart('120 1278 -616', TEAM_COLOR2 , 0);
		SpawnTeamStart('591 1292 -944', TEAM_COLOR2 , 0);
		SpawnTeamStart('868 1264 -968', TEAM_COLOR2 , 0);
		SpawnTeamStart('1184 1139 -1000', TEAM_COLOR2 , 0);
		SpawnTeamStart('1184 1367 -1000', TEAM_COLOR2 , 0);
		SpawnTeamStart('1184 1271 -1000', TEAM_COLOR2 , 0);
		SpawnFlag('1374 1270 -1000' , TEAM_COLOR2 , 0);
		SpawnTeamStart('2952 -8 -616' , TEAM_COLOR1 , 90);
		SpawnTeamStart('2804 75 -616' , TEAM_COLOR1 , 180);
		SpawnTeamStart('2602 62 -472' , TEAM_COLOR1 , 0);
		SpawnTeamStart('2919 0 -424' , TEAM_COLOR1 , 180);
		SpawnTeamStart('2799 239 -280' , TEAM_COLOR1 , 270);
		SpawnTeamStart('2606 150 -280' , TEAM_COLOR1 , 0);
		SpawnFlag('2589 235 -280' , TEAM_COLOR1 , 0);
		spawn_grenadelauncher('2482 240 -392');
		spawn_grenadelauncher('616 1488 -576');
		spawn_quad('1120 984 -1048');
		spawn_pentagram('-608 496 -984');

		// *check* Mighty hack alert!
		local entity oself;
		oself = self;
		self = spawn();
		self.targetname = "t60";
		self.angles = '0 -2 0';
		self.target = "t17";
		self.wait = 4;
		self.speed = 20;
		self.sounds = 3;
		self.classname = "func_door";
		self.model = "*67";
		func_door();

		self = spawn();
		self.target = "t60";
		self.classname = "trigger_multiple";
		self.sounds = 3;
		self.model = "*68";	
		trigger_multiple();


		self = oself;


	} else if (mapname == "e2m7") {
		spawn_armor('2105 926 -13' , 1);
		spawn_supernailgun('184 1440 -232');
		spawn_shells('2230 1080 -203' , 0);
		spawn_supershotgun('2242 1040 -203');
		SpawnTeamStart('2408 1037 -13', TEAM_COLOR2 , 180);
		SpawnTeamStart('2130 891 -13', TEAM_COLOR2 , 45);
		SpawnTeamStart('2344 906 -13', TEAM_COLOR2 , 135);
		SpawnTeamStart('2220 1235 -13', TEAM_COLOR2 , 270);
		SpawnTeamStart('2066 1037 -13', TEAM_COLOR2 , 0);
		SpawnFlag('2408 1037 -13' , TEAM_COLOR2 , 0);
		SpawnTeamStart('900 1818 -216' , TEAM_COLOR1 , 0);
		SpawnTeamStart('800 1818 -216' , TEAM_COLOR1 , 0);
		SpawnTeamStart('700 1818 -216' , TEAM_COLOR1 , 0);
		SpawnTeamStart('600 1818 -216' , TEAM_COLOR1 , 0);
		SpawnTeamStart('500 1818 -216' , TEAM_COLOR1 , 0);
		SpawnFlag('784 1816 -232' , TEAM_COLOR1 , 0);
		spawn_rocketlauncher('2128 1792 -352');
		spawn_lightning('1135 -800 -80');
	}
};

void() Episode2Change =
{
	local entity e;
	if (mapname == "e2m1") {
		return;
	} else if (mapname == "e2m2") {
		return;
	} else if (mapname == "e2m3") {
		return;

	} else if (mapname == "e2m4") {
		e = FindByOrigin("item_health" , '2136 1648 104');
		remove(e);
		e = FindByOrigin("item_cells" , '-624 1736 528');
		remove(e);
		e = FindByModel("func_button" , "*48");
		remove(e);
		e = FindByOrigin("weapon_nailgun" , '1840 1176 32');
		remove(e);
		e = FindByOrigin("item_armor2" , '1776 1088 -192');
		remove(e);
		e = FindByModel("trigger_counter" , "*28");
		remove(e);
		e = FindByModel("func_button" , "*26");
		remove(e);
		e = FindByModel("func_button" , "*25");
		remove(e);
		e = FindByModel("door" , "*22");
		remove(e);
		e = FindByModel("door" , "*20");
		remove(e);
		e = FindByModel("func_button" , "*19");
		remove(e);
		e = FindByModel("plat" , "*1");
		e.speed  = 350;
		e = FindByModel("door" , "*21");
		e.speed  = 550;
		e.spawnflags  = 0;
		e = FindByModel("func_button" , "*27");
		e.wait  = 4;
		e.target  = "t50";
		e = FindByOrigin("item_spikes" , '776 344 32');
		e.aflag  = 50;
		setmodel (e , "maps/b_nail1.bsp");
		e = FindByOrigin("item_spikes" , '760 1128 -128');
		e.aflag  = 50;
		setmodel (e , "maps/b_nail1.bsp");
	} else if (mapname == "e2m5") {
		return;
	} else if (mapname == "e2m6") {
		e = FindByOrigin("weapon_grenadelauncher", '2608 160 -304');
		if (e) remove (e);
		e = FindByOrigin("weapon_lightning" , '616 1488 -576');
		remove(e);
		e = FindByOrigin("item_artifact_invulnerability" , '1120 984 -1048');
		remove(e);
		e = FindByOrigin("item_artifact_invulnerability" , '-608 496 -984');
		e.target = "t87";
		e = FindByOrigin("item_sigil" , '-608 496 -984');
		remove(e);
		e = FindByModel("train" , "*1");
		e.speed  = 300;
		e = FindByOrigin("path_corner" , '32 1216 -1008');
		e.wait  = 2;
		e = FindByOrigin("path_corner" , '32 1216 -1368');
		e.wait  = 2;
		e = FindByOrigin("path_corner" , '512 1216 -1384');
		e.wait  = 1;
		e = FindByModel("train" , "*3");
		e.speed  = 300;
		e = FindByOrigin("path_corner" , '512 1216 -992');
		e.wait  = 1;
		e = FindByOrigin("path_corner" , '512 1216 -1192');
		e.wait  = 1;
		e = FindByOrigin("path_corner" , '512 1216 -1192');
		e.wait  = 1;
		e = FindByModel("door" , "*47");
		e.speed  = 20;
		e = FindByModel("train" , "*54");
		e.speed  = 25;
		e = FindByModel("train" , "*55");
		e.speed  = 25;
		e = FindByModel("door" , "*75");
		e.message  = "";
		e = FindByOrigin("item_health" , '1280 1144 -1024');
		e.spawnflags = 0;
		setmodel (e , "maps/b_bh25.bsp");
		e.noise  = "items/health1.wav";
		e = FindByModel("door" , "*88");
		e.wait  = 4;
	} else if (mapname == "e2m7") {
		e = FindByOrigin("weapon_lightning" , '2128 1792 -352');
		remove(e);
		e = FindByOrigin("weapon_rocketlauncher" , '184 1440 -232');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '192 1752 -208');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '192 1752 -208');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '192 1752 -208');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '192 1752 -208');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '192 1752 -208');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '192 1752 -208');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '192 1752 -208');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '192 1752 -208');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '192 1752 -208');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '192 1752 -208');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '192 1752 -208');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '192 1752 -208');
		remove(e);
	}
};


void() Episode3Spawn =
{
	local entity e;

	if (mapname == "e3m1") {
		spawn_cells('-290 185 -24' , 1);
		spawn_health('2175 -588 -48' , 0);
		spawn_armor('2175 -530 -48' , 1);
		spawn_health('2175 -472 -48' , 0);
		spawn_nails('2117 -588 -48' , 1);
		spawn_supershotgun('2117 -530 -48');
		spawn_nails('2117 -472 -48' , 1);
		spawn_shells('2233 -588 -48' , 1);
		spawn_supernailgun('2233 -530 -48');
		spawn_shells('2233 -472 -48' , 1);
		spawn_health('622 390 -192' , 0);
		spawn_armor('622 448 -192' , 1);
		spawn_health('622 506 -192' , 0);
		spawn_nails('564 390 -192' , 1);
		spawn_supershotgun('564 448 -192');
		spawn_nails('564 506 -192' , 1);
		spawn_shells('680 390 -192' , 1);
		spawn_supernailgun('680 448 -192');
		spawn_shells('680 506 -192' , 1);
		SpawnTeamStart('1738 208 -88', TEAM_COLOR2 , 180);
		SpawnTeamStart('1992 -6 -88', TEAM_COLOR2 , 135);
		SpawnTeamStart('2029 -252 -56', TEAM_COLOR2 , 90);
		SpawnTeamStart('2121 -873 -40', TEAM_COLOR2 , 225);
		SpawnTeamStart('2234 -593 -24', TEAM_COLOR2 , 135);
		SpawnTeamStart('2090 -434 -24', TEAM_COLOR2 , 315);
		SpawnFlag('2336 -528 -8' , TEAM_COLOR2 , 0);
		SpawnTeamStart('340 335 -136' , TEAM_COLOR1 , 180);
		SpawnTeamStart('340 528 -136' , TEAM_COLOR1 , 180);
		SpawnTeamStart('654 528 -168' , TEAM_COLOR1 , 180);
		SpawnTeamStart('654 335 -168' , TEAM_COLOR1 , 180);
		SpawnTeamStart('770 604 56' , TEAM_COLOR1 , 0);
		SpawnTeamStart('617 353 72' , TEAM_COLOR1 , 90);
		SpawnFlag('702 575 56' , TEAM_COLOR1 , 0);


	} else if (mapname == "e3m2") {
		spawn_rockets('56 -904 184' , 1);
		spawn_nails('20 -750 -232' , 1);
		spawn_grenadelauncher('-383 -243 232');
		spawn_supernailgun('192 -940 -232');
		spawn_supershotgun('321 208 -232');
		spawn_armor('337 736 24' , 1);
		spawn_rocketlauncher('1676 498 24');
		spawn_supernailgun('-384 384 8');
		SpawnTeamStart('363 80 -232', TEAM_COLOR2 , 0);
		SpawnTeamStart('338 334 -232', TEAM_COLOR2 , 235);
		SpawnTeamStart('196 80 -232', TEAM_COLOR2 , 90);
		SpawnTeamStart('50 119 -232', TEAM_COLOR2 , 45);
		SpawnTeamStart('194 220 -232', TEAM_COLOR2 , 90);
		SpawnTeamStart('1264 127 24' , TEAM_COLOR1 , 270);
		SpawnTeamStart('1074 96 24' , TEAM_COLOR1 , 90);
		SpawnTeamStart('886 -287 24' , TEAM_COLOR1 , 90);
		SpawnTeamStart('191 761 24' , TEAM_COLOR1 , 270);
		SpawnTeamStart('1074 -179 16' , TEAM_COLOR1 , 270);
		SpawnFlag('1075 -81 20' , TEAM_COLOR1 , 0);
		SpawnFlag('193 319 -232' , TEAM_COLOR2 , 0); // '193 319 -232'
		// *check* this is a hack...
		e = find(world, classname, "item_flag_team2_temp");
		e.nextthink = time + 1;
	} else if (mapname == "e3m3") {
		spawn_nails('576 -256 176' , 0);
		spawn_nails('48 -1168 72' , 0);
		spawn_invisibility('-92 -592 376');
		spawn_armor('-1215 0 200' , 1);
		spawn_invisibility('-689 -1376 24');
		spawn_invisibility('579 -753 24');
		SpawnTeamStart('1230 2 24', TEAM_COLOR2 , 90);
		SpawnTeamStart('1405 414 -104', TEAM_COLOR2 , 0);
		SpawnTeamStart('1227 166 -232', TEAM_COLOR2 , 90);
		SpawnTeamStart('1100 179 -232', TEAM_COLOR2 , 90);
		SpawnTeamStart('1100 -12 -232', TEAM_COLOR2 , 90);
		SpawnTeamStart('1314 -211 -232', TEAM_COLOR2 , 135);
		SpawnFlag('1090 -234 -232' , TEAM_COLOR2 , 0);
		SpawnTeamStart('-732 384 200' , TEAM_COLOR1 , 225);
		SpawnTeamStart('-932 384 200' , TEAM_COLOR1 , 315);
		SpawnTeamStart('-1307 0 200' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-357 0 200' , TEAM_COLOR1 , 180);
		SpawnTeamStart('-831 -5 200' , TEAM_COLOR1 , 90);
		SpawnTeamStart('-833 -388 200' , TEAM_COLOR1 , 90);
		SpawnFlag('-832 384 144' , TEAM_COLOR1 , 0);
		spawn_supernailgun('576 -256 176');


	} else if (mapname == "e3m4") {
		SpawnTeamStart('1887 -1171 24', TEAM_COLOR2 , 0);
		SpawnTeamStart('1887 -1231 24', TEAM_COLOR2 , 0);
		SpawnTeamStart('1887 -1291 24', TEAM_COLOR2 , 0);
		SpawnTeamStart('1947 -1171 24', TEAM_COLOR2 , 0);
		SpawnTeamStart('1947 -1231 24', TEAM_COLOR2 , 0);
		SpawnTeamStart('1947 -1291 24', TEAM_COLOR2 , 0);
		SpawnFlag('1887 -1231 0' , TEAM_COLOR2 , 0);
		spawn_invisibility('108.3 -2040.6 424.0');
		spawn_shells('101.7 -2046 200' , 1);
		spawn_nails('227.7 -2052.6 200' , 1);
		spawn_nails('356.2 -2055.4 200' , 1);
		spawn_supershotgun('365.8 -1926.3 200');
		spawn_supernailgun('237.9 -1922.9 200');
		spawn_armor('105.6 -1917.1 200' , 2);
		SpawnTeamStart('62.3 -1974.5 200' , TEAM_COLOR1 , 0);
		SpawnTeamStart('289.3 -1984 200' , TEAM_COLOR1 , 0);
		SpawnTeamStart('432 -2128 200' , TEAM_COLOR1 , 0);
		SpawnTeamStart('432.0 -1840 200' , TEAM_COLOR1 , 0);
		SpawnTeamStart('432.0 -1840 200' , TEAM_COLOR1 , 0);
		SpawnTeamStart('42.7 -1840 200' , TEAM_COLOR1 , 0);
		SpawnTeamStart('180.1 -1840 200' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-112 -1840 200' , TEAM_COLOR1 , 0);
		SpawnTeamStart('180.1 -2128 200' , TEAM_COLOR1 , 0);
		SpawnFlag('-112 -2128 200' , TEAM_COLOR1 , 0);


	} else if (mapname == "e3m5") {
		SpawnTeamStart('563 -1455 448', TEAM_COLOR2 , 0);
		SpawnTeamStart('563 -1397 448', TEAM_COLOR2 , 0);
		SpawnTeamStart('1108 -2907 600', TEAM_COLOR2 , 0);
		SpawnTeamStart('1108 -2967 600', TEAM_COLOR2 , 0);
		SpawnTeamStart('1108 -3027 600', TEAM_COLOR2 , 0);
		SpawnTeamStart('1168 -2907 600', TEAM_COLOR2 , 0);
		SpawnTeamStart('1168 -2967 600', TEAM_COLOR2 , 0);
		SpawnTeamStart('1168 -3027 600', TEAM_COLOR2 , 0);
		SpawnFlag('1108 -2967 576' , TEAM_COLOR2 , 0);
		SpawnTeamStart('227 -1828 472' , TEAM_COLOR1 , 0);
		SpawnTeamStart('227 -1888 472' , TEAM_COLOR1 , 0);
		SpawnTeamStart('287 -1768 472' , TEAM_COLOR1 , 0);
		SpawnTeamStart('287 -1828 472' , TEAM_COLOR1 , 0);
		SpawnTeamStart('287 -1888 472' , TEAM_COLOR1 , 0);
		SpawnTeamStart('347 -1768 472' , TEAM_COLOR1 , 0);
		SpawnTeamStart('347 -1828 472' , TEAM_COLOR1 , 0);
		SpawnTeamStart('347 -1888 472' , TEAM_COLOR1 , 0);
		SpawnFlag('228 -1587 736' , TEAM_COLOR1 , 0);
		spawn_health('643 -2354 -320' , 0);
		spawn_nails('505 -1455 448' , 1);
		spawn_supershotgun('505 -1397 448');
		spawn_nails('505 -1339 448' , 1);
		spawn_shells('621 -1455 448' , 1);
		spawn_supernailgun('621 -1397 448');
		spawn_armor('643 -2296 -316' , 1);
		spawn_health('643 -2238 -320' , 0);
		spawn_armor('1251 -2965 192' , 1);
		spawn_health('1251 -2907 192' , 0);
		spawn_nails('1193 -3023 192' , 1);
		spawn_supershotgun('1193 -2965 192');
		spawn_nails('1193 -2907 192' , 1);
		spawn_shells('1309 -3023 192' , 1);
		spawn_supernailgun('1309 -2965 192');
		spawn_shells('1309 -2907 192' , 1);
		spawn_nails('585 -2354 -320' , 1);
		spawn_supershotgun('585 -2296 -316');
		spawn_nails('585 -2238 -320' , 1);
		spawn_shells('701 -2354 -320' , 1);
		spawn_supernailgun('701 -2296 -320');
		spawn_shells('701 -2238 -320' , 1);


	} else if (mapname == "e3m6") {
		spawn_supershotgun('288 -1572 24');
		spawn_armor('287 -3046 168' , 2);
		spawn_supernailgun('288 -736 8');
		spawn_supernailgun('768 -120 8');
		spawn_rocketlauncher('-936 -824 152');
		SpawnTeamStart('877 -3050 24', TEAM_COLOR2 , 90);
		SpawnTeamStart('289 -3047 24', TEAM_COLOR2 , 0);
		SpawnTeamStart('-85 -3042 24', TEAM_COLOR2 , 0);
		SpawnTeamStart('288 -3392 152', TEAM_COLOR2 , 270);
		SpawnTeamStart('286 -3202 144', TEAM_COLOR2 , 270);
		SpawnTeamStart('288 -2655 152', TEAM_COLOR2 , 270);
		SpawnFlag('284 -3432 152' , TEAM_COLOR2 , 0);
		SpawnTeamStart('-1788 -350 88' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-652 -652 24 ' , TEAM_COLOR1 , 180);
		SpawnTeamStart('-1249 -713 24' , TEAM_COLOR1 , 90);
		SpawnTeamStart('-929 -713 24' , TEAM_COLOR1 , 90);
		SpawnTeamStart('-1093 -588 8' , TEAM_COLOR1 , 270);
		SpawnTeamStart('-1088 -288 32' , TEAM_COLOR1 , 270);
		SpawnFlag('-1086 -288 28' , TEAM_COLOR1 , 0);
	} else if (mapname == "e3m7") {
		spawn_supershotgun('-850 -496 -344');
		spawn_supershotgun('-1092 1327 -40');
		spawn_supershotgun('-722 1410 -40');
		spawn_health('-420 -310 -344' , 1);
		spawn_armor('-287 274 -180' , 2);
		SpawnTeamStart('-1112 1524 -40', TEAM_COLOR2 , 90);
		SpawnTeamStart('-1116 1334 -40', TEAM_COLOR2 , 90);
		SpawnTeamStart('-713 1185 -40', TEAM_COLOR2 , 270);
		SpawnTeamStart('-706 1415 -40', TEAM_COLOR2 , 270);
		SpawnTeamStart('-1012 1346 136', TEAM_COLOR2 , 235);
		SpawnTeamStart('-773 1411 136', TEAM_COLOR2 , 235);
		SpawnFlag('-920 1360 112' , TEAM_COLOR2 , 0);
		SpawnTeamStart('-797 -497 -344' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-1022 -497 -344' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-916 -824 -344' , TEAM_COLOR1 , 180);
		SpawnTeamStart('-846 -603 -504' , TEAM_COLOR1 , 270);
		SpawnTeamStart('-863 -280 -504' , TEAM_COLOR1 , 270);
		SpawnTeamStart('-967 -114 -504' , TEAM_COLOR1 , 0);
		SpawnFlag('-1129 -240 -504' , TEAM_COLOR1 , 0);
		spawn_supernailgun('-960 848 -64');
		spawn_health('-1400 1614 -120' , 1);
		spawn_health('-1400 1539 -120' , 1);
}

};

void() Episode3Change =
{
	local entity e;

	if (mapname == "e3m1") {
		e = FindByTarget("trigger_multiple" , "t48");
		remove(e);
		e = FindByTarget("trigger_multiple" , "t47");
		remove(e);
		e = FindByTarget("trigger_multiple" , "t46");
		remove(e);
		e = FindByTargetname("info_teleport_destination" , "t7");
		setorigin(e , '-216 288 -109');
		e.mangle_y = 5;
		e = FindByModel("door" , "*50");
		e.speed  = 150;
		e.wait  = 4;
	
	} else if (mapname == "e3m2") {
		e = FindByTarget("trigger_once" , "t38");
		remove(e);
		e = FindByModel("func_button" , "*39");
		remove(e);
		e = FindByModel("door" , "*38");
		remove(e);
		e = FindByOrigin("weapon_nailgun" , '-384 384 8');
		remove(e);
		e = FindByTargetname("info_teleport_destination" , "t5");
		remove(e);
		e = FindByTarget("trigger_teleport" , "t5");
		remove(e);
		e = FindByModel("door" , "*14");
		remove(e);
		e = FindByModel("door" , "*11");
		remove(e);
		e = FindByModel("door" , "*54");
		e.speed  = 200;
		e.wait  = 4;
		FireTarget("t34");
	} else if (mapname == "e3m3") {
		e = FindByModel("train" , "*59");
		remove(e);
		e = FindByOrigin("item_armor2" , '1584 520 -128');
		remove(e);
		e = FindByOrigin("weapon_rocketlauncher" , '1392 -176 -256');
		remove(e);
		e = FindByOrigin("weapon_nailgun" , '576 -256 176');
		remove(e);
		e = FindByModel("door" , "*40");
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '-504 -1008 216');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '-544 -1008 216');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '-504 -1168 216');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '-544 -1168 216');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '-552 -1328 216');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '-512 -1328 216');
		remove(e);
		e = FindByTarget("trigger_teleport" , "t28");
		remove(e);
		e = FindByModel("train" , "*21");
		remove(e);
	
	} else if (mapname == "e3m4") {
		e = FindByOrigin("item_artifact_invulnerability" , '-256 -1984 216');
		remove(e);
	} else if (mapname == "e3m5") {
		e = FindByOrigin("trap_spikeshooter" , '2176 -2624 196');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '2132 -2480 196');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '2092 -2788 196');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '1348 -3064 216');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '1324 -3064 216');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '1336 -2856 216');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '1340 -2840 216');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '1324 -2840 216');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '1336 -2832 216');
		remove(e);

	} else if (mapname == "e3m6") {
		e = FindByModel("door" , "*61");
		remove(e);
		e = FindByModel("door" , "*60");
		remove(e);
		e = FindByOrigin("item_sigil" , '284 -3432 152');
		remove(e);
		e = FindByOrigin("item_artifact_invisibility" , '-936 -824 152');
		remove(e);
		e = FindByModel("door" , "*25");
		remove(e);
		e = FindByModel("func_button" , "*24");
		remove(e);
		e = FindByModel("door" , "*12");
		e.wait  = 4;
		e = FindByModel("func_button" , "*13");
		e.wait  = 4;
		e = FindByOrigin("item_rockets" , '688 -1336 56');
		e.spawnflags  = 1;
		setmodel (e, "maps/b_rock1.bsp");
		e.aflag = 10;
		e = FindByOrigin("weapon_supershotgun", '768 -120 8');
		remove(e);
	} else if (mapname == "e3m7") {
		e = FindByOrigin("item_armorInv" , '-960 848 -64');
		remove(e);
		e = FindByOrigin("weapon_rocketlauncher" , '-920 1360 112');
		remove(e);
		e = FindByOrigin("item_artifact_invulnerability" , '-1032 1008 88');
		remove(e);
		e = FindByOrigin("item_armor2" , '-1384 1624 -120');
		remove(e);
		e = FindByOrigin("item_artifact_super_damage" , '-1384 1552 -96');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '-1408 956 -16');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '-1408 1020 -16');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '-1408 1084 -16');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '-1408 1148 -16');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '-1408 1212 -16');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '-1408 1276 -16');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '-1408 1340 -16');
		remove(e);
		e = FindByOrigin("trap_spikeshooter" , '-1408 892 -16');
		remove(e);
		e = FindByModel("door" , "*1");
		e.wait  = 4;
		e.spawnflags  = 4;
		e = FindByModel("door" , "*21");
		e.wait  = 4;
		e = FindByOrigin("item_health" , '-1400 1464 -120');
		e.spawnflags = 1;
		setmodel (e , "maps/b_bh10.bsp");
		e.noise  = "items/r_item1.wav";
		e = FindByOrigin("item_rockets" , '-192 -808 0');
		e.spawnflags  = 0;
}

};


void() Episode4Spawn = {
	local entity e;

	if (mapname == "e4m1") {
		spawn_nailgun('2392 -128 -40');
		spawn_shells('2072 -392 200' , 1);
		spawn_health('1985 -738 104' , 0);
		spawn_health('2113 -738 104' , 0);
		spawn_supernailgun('1507 768 296');
		spawn_supershotgun('1110 768 296');
		spawn_supernailgun('2150 -515 100');
		spawn_supershotgun('2000 -515 100');
		SpawnTeamStart('2317 357 104', TEAM_COLOR2 , 180);
		SpawnTeamStart('2071 -23 104', TEAM_COLOR2 , 90);
		SpawnTeamStart('2190 -430 200', TEAM_COLOR2 , 225);
		SpawnTeamStart('1950 -430 200', TEAM_COLOR2 , 315);
		SpawnTeamStart('2150 -515 100', TEAM_COLOR2 , 225);
		SpawnTeamStart('2000 -515 100', TEAM_COLOR2 , 315);
		SpawnFlag('2071 -767 104' , TEAM_COLOR2 , 0);
		SpawnTeamStart('1312 568 688' , TEAM_COLOR1 , 90);
		SpawnTeamStart('1312 552 296' , TEAM_COLOR1 , 270);
		SpawnTeamStart('1150 623 296' , TEAM_COLOR1 , 45);
		SpawnTeamStart('1470 623 296' , TEAM_COLOR1 , 135);
		SpawnTeamStart('1150 910 296' , TEAM_COLOR1 , 315);
		SpawnTeamStart('1470 910 296' , TEAM_COLOR1 , 225);
		SpawnFlag('1312 449 296' , TEAM_COLOR1 , 0);
		spawn_lightning('952 1048 112');
		spawn_armor('2168 1576 256' , 1);
		spawn_supernailgun('904 1480 424');


	} else if (mapname == "e4m2") {
		SpawnTeamStart('-188 -2407 536', TEAM_COLOR2 , 0);
		SpawnTeamStart('-188 -2467 536', TEAM_COLOR2 , 0);
		SpawnTeamStart('-188 -2527 536', TEAM_COLOR2 , 0);
		SpawnTeamStart('-128 -2407 536', TEAM_COLOR2 , 0);
		SpawnTeamStart('-128 -2467 536', TEAM_COLOR2 , 0);
		SpawnTeamStart('-128 -2527 536', TEAM_COLOR2 , 0);
		SpawnTeamStart('-68 -2407 536', TEAM_COLOR2 , 0);
		SpawnTeamStart('-68 -2467 536', TEAM_COLOR2 , 0);
		SpawnTeamStart('-68 -2527 536', TEAM_COLOR2 , 0);
		SpawnTeamStart('-52 -49 792' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-52 -109 792' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-52 -169 792' , TEAM_COLOR1 , 0);
		SpawnTeamStart('8 -49 792' , TEAM_COLOR1 , 0);
		SpawnTeamStart('8 -109 792' , TEAM_COLOR1 , 0);
		SpawnTeamStart('8 -169 792' , TEAM_COLOR1 , 0);
		SpawnTeamStart('68 -49 792' , TEAM_COLOR1 , 0);
		SpawnTeamStart('68 -109 792' , TEAM_COLOR1 , 0);
		SpawnTeamStart('68 -169 792' , TEAM_COLOR1 , 0);
		spawn_health('-122 -2450 512' , 0);
		SpawnFlag('8 -109 768' , TEAM_COLOR1 , 0);
		spawn_health('-3 33 768' , 0);
		spawn_armor('-122 -2392 512' , 1);
		spawn_health('-122 -2334 512' , 0);
		SpawnFlag('-128 -2467 512' , TEAM_COLOR2 , 0);
		spawn_health('-3 149 768' , 0);
		spawn_nails('-61 33 768' , 1);
		spawn_nails('-61 149 768' , 1);
		spawn_shells('55 33 768' , 1);
		spawn_nails('-180 -2450 512' , 1);
		spawn_supershotgun('-180 -2392 512');
		spawn_nails('-180 -2334 512' , 1);
		spawn_shells('-64 -2450 512' , 1);
		spawn_supernailgun('-64 -2392 512');
		spawn_shells('-64 -2334 512' , 1);

	} else if (mapname == "e4m3") {
		SpawnTeamStart('2240 -64 -104', TEAM_COLOR2 , 180);
		SpawnTeamStart('2244 110 -104', TEAM_COLOR2 , 180);
		SpawnTeamStart('2370 273 -104', TEAM_COLOR2 , 180);
		SpawnTeamStart('2599 269 -104', TEAM_COLOR2 , 180);
		SpawnTeamStart('2630 430 -104', TEAM_COLOR2 , 180);
		SpawnTeamStart('2447 439 -104', TEAM_COLOR2 , 180);
		SpawnFlag('2200 544 -60' , TEAM_COLOR2 , 0);
		SpawnTeamStart('1232 -1347 152' , TEAM_COLOR1 , 90);
		SpawnTeamStart('1232 -1447 152' , TEAM_COLOR1 , 90);
		SpawnTeamStart('1232 -1547 152' , TEAM_COLOR1 , 90);
		SpawnTeamStart('1132 -1347 152' , TEAM_COLOR1 , 90);
		SpawnTeamStart('1132 -1447 152' , TEAM_COLOR1 , 90);
		SpawnTeamStart('1132 -1547 152' , TEAM_COLOR1 , 90);
		SpawnFlag('1182 -1647 172' , TEAM_COLOR1 , 0);

	} else if (mapname == "e4m4") {
		spawn_health('1168 -1400 24' , 0);
		spawn_health('1120 -1400 24' , 0);
		spawn_health('1072 -1400 24' , 0);
		spawn_shells('1168 -1592 24' , 0);
		spawn_shells('1120 -1592 24' , 0);
		spawn_shells('1072 -1592 24' , 0);
		spawn_nails('784 -1400 24' , 0);
		spawn_nails('784 -1592 24' , 0);
		spawn_supershotgun('832 -1592 24');
		spawn_health('1120 624 40' , 0);
		spawn_shells('1072 672 240' , 0);
		spawn_shells('1024 672 40' , 0);
		spawn_nails('1072 624 40' , 0);
		spawn_nails('1024 624 40' , 0);
		spawn_nails('976 624 40' , 0);
		spawn_supernailgun('1168 1392 40');
		spawn_supershotgun('976 672 40');
		SpawnTeamStart('880 -1592 24', TEAM_COLOR2 , 180);
		SpawnTeamStart('880 -1592 24', TEAM_COLOR2 , 180);
		SpawnTeamStart('1120 -1448 24', TEAM_COLOR2 , 180);
		SpawnTeamStart('1120 -1544 24', TEAM_COLOR2 , 180);
		SpawnTeamStart('1120 -1496 24', TEAM_COLOR2 , 180);
		SpawnTeamStart('832 -1496 24' , TEAM_COLOR2 , 180);
		SpawnFlag('1170 -1490 24' , TEAM_COLOR2 , 0);
		SpawnTeamStart('1072 1344 40' , TEAM_COLOR1 , 90);
		SpawnTeamStart('1168 1200 40' , TEAM_COLOR1 , 90);
		SpawnTeamStart('1072 1200 40' , TEAM_COLOR1 , 90);
		SpawnTeamStart('976 1200 40' , TEAM_COLOR1 , 90);
		SpawnTeamStart('976 912 40' , TEAM_COLOR1 , 90);
		SpawnTeamStart('1120 912 40' , TEAM_COLOR1 , 90);
		SpawnFlag('1168 1056 40' , TEAM_COLOR1 , 0);

	} else if (mapname == "e4m5") {
		spawn_supershotgun('-2752 -1808 -264');
		spawn_supernailgun('-2752 -1904 -264');
		spawn_armor('-2752 -1856 -264' , 1);
		spawn_health('-2848 -1760 -264' , 0);
		spawn_health('-2896 -1760 -264' , 0);
		spawn_health('-2944 -1760 -264' , 0);
		spawn_shells('-2896 -1904 -264' , 0);
		spawn_shells('-2944 -1904 -264' , 0);
		spawn_nails('-2848 -1952 -264' , 0);
		spawn_nails('-2896 -1952 -264' , 0);
		spawn_nails('-2944 -1952 -264' , 0);
		spawn_health('1424 2272 120' , 0);
		spawn_health('1424 2320 120' , 0);
		spawn_health('1424 2224 120' , 0);
		spawn_nails('1120 2272 120' , 0);
		spawn_nails('1120 2320 120' , 0);
		spawn_nails('1120 2224 120' , 0);
		spawn_shells('1072 2272 120' , 0);
		spawn_shells('1072 2320 120' , 0);
		spawn_shells('1072 2224 120' , 0);
		spawn_armor('1072 2064 120' , 1);
		spawn_supernailgun('1168 2272 120');
		spawn_supershotgun('1376 2272 120');
		SpawnTeamStart('-2725 -1950 -264', TEAM_COLOR2 , 0);
		SpawnTeamStart('-2725 -1875 -264', TEAM_COLOR2 , 0);
		SpawnTeamStart('-2765 -1960 -264', TEAM_COLOR2 , 0);
		SpawnTeamStart('-2986 -1950 -264', TEAM_COLOR2 , 0);
		SpawnTeamStart('-2960 -1760 -264', TEAM_COLOR2 , 0);
		SpawnTeamStart('-2765 -1760 -264', TEAM_COLOR2 , 0);
		SpawnFlag('-2944 -1856 -264' , TEAM_COLOR2 , 0);
		SpawnTeamStart('1245 2300 120' , TEAM_COLOR1 , 270);
		SpawnTeamStart('1110 2370 120' , TEAM_COLOR1 , 270);
		SpawnTeamStart('1110 2230 120' , TEAM_COLOR1 , 270);
		SpawnTeamStart('1245 2230 120' , TEAM_COLOR1 , 270);
		SpawnTeamStart('1400 2230 120' , TEAM_COLOR1 , 270);
		SpawnTeamStart('1400 2335 120' , TEAM_COLOR1 , 270);
		SpawnFlag('1245 2370 120' , TEAM_COLOR1 , 90);

	} else if (mapname == "e4m6") {
		spawn_health('-818 -1225 -94' , 0);
		spawn_health('-768 -1225 -94' , 0);
		spawn_health('-718 -1225 -94' , 0);
		spawn_supernailgun('-818 -1275 -94');
		spawn_armor('-768 -1275 -94' , 1);
		spawn_supershotgun('-718 -1275 -94');
		spawn_nails('-818 -1325 -94' , 0);
		spawn_nails('-768 -1325 -94' , 0);
		spawn_nails('-718 -1325 -94' , 0);
		spawn_shells('-818 -1375 -94' , 0);
		spawn_shells('-768 -1375 -94' , 0);
		spawn_shells('-718 -1375 -94' , 0);
		spawn_health('150 1718 34' , 0);
		spawn_health('150 1668 34' , 0);
		spawn_health('150 1618 34' , 0);
		spawn_supernailgun('200 1718 34');
		spawn_supershotgun('200 1618 34');
		spawn_nails('250 1718 34' , 0);
		spawn_nails('250 1668 34' , 0);
		spawn_nails('250 1618 34' , 0);
		spawn_shells('300 1718 34' , 0);
		spawn_shells('300 1668 34' , 0);
		spawn_shells('300 1618 34' , 0);
		SpawnTeamStart('-918 -1623 -104', TEAM_COLOR2 , 90);
		SpawnTeamStart('-768 -1623 -104', TEAM_COLOR2 , 90);
		SpawnTeamStart('-618 -1623 -104', TEAM_COLOR2 , 90);
		SpawnTeamStart('-918 -1473 -104', TEAM_COLOR2 , 90);
		SpawnTeamStart('-768 -1473 -104', TEAM_COLOR2 , 90);
		SpawnTeamStart('-618 -1473 -104', TEAM_COLOR2 , 90);
		SpawnFlag('-768 -1876 -94' , TEAM_COLOR2 , 0);
		SpawnTeamStart('380 1768 24' , TEAM_COLOR1 , 180);
		SpawnTeamStart('530 1768 24' , TEAM_COLOR1 , 180);
		SpawnTeamStart('680 1768 24' , TEAM_COLOR1 , 180);
		SpawnTeamStart('380 1568 24' , TEAM_COLOR1 , 180);
		SpawnTeamStart('530 1568 24' , TEAM_COLOR1 , 180);
		SpawnTeamStart('680 1568 24' , TEAM_COLOR1 , 180);
		SpawnFlag('776 1912 34' , TEAM_COLOR1 , 0);

	} else if (mapname == "e4m7") {
		SpawnTeamStart('868 -1817 216', TEAM_COLOR2 , 0);
		SpawnTeamStart('868 -1877 216', TEAM_COLOR2 , 0);
		SpawnTeamStart('868 -1937 216', TEAM_COLOR2 , 0);
		SpawnTeamStart('928 -1817 216', TEAM_COLOR2 , 0);
		SpawnTeamStart('928 -1877 216', TEAM_COLOR2 , 0);
		SpawnTeamStart('928 -1937 216', TEAM_COLOR2 , 0);
		SpawnTeamStart('988 -1877 216', TEAM_COLOR2 , 0);
		SpawnTeamStart('-1092 -305 -112' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-1092 -365 -112' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-1032 -305 -112' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-1032 -365 -112' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-972 -305 -112' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-972 -365 -112' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-972 -425 -112' , TEAM_COLOR1 , 0);
		SpawnFlag('-1032 -365 -136' , TEAM_COLOR1 , 90);
		SpawnFlag('928 -1877 192' , TEAM_COLOR2 , 0);
		spawn_rocketlauncher('-655 -230 -136');
		spawn_supernailgun('560 -1520 192');
		spawn_rocketlauncher('208 -1872 192');
		spawn_armor('-1255 -190 -136' , 2);


	} else if (mapname == "e4m8") {
		spawn_armor('0 146 -104' , 1);
		spawn_health('1666 -1900 24' , 0);
		spawn_armor('2961 945 192' , 1);
		spawn_armor('1952 -576 152' , 1);
		SpawnTeamStart('1056 -1440 24', TEAM_COLOR2 , 315);
		SpawnTeamStart('1759 -1376 40', TEAM_COLOR2 , 225);
		SpawnTeamStart('1476 -1800 200', TEAM_COLOR2 , 90);
		SpawnTeamStart('1476 -1650 200', TEAM_COLOR2 , 270);
		SpawnTeamStart('1548 -1727 276', TEAM_COLOR2 , 180);
		SpawnTeamStart('1384 -1727 276', TEAM_COLOR2 , 0);
		SpawnFlag('1473 -1727 64' , TEAM_COLOR2 , 0);
		SpawnTeamStart('-250 700 220' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-250 400 220' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-250 150 220' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-526 150 220' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-526 400 220' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-526 700 220' , TEAM_COLOR1 , 0);
		SpawnFlag('-526 575 -104' , TEAM_COLOR1 , 0);
		spawn_rocketlauncher('1056 -1440 0');
		spawn_nailgun('1328 1232 112');
		spawn_grenadelauncher('2064 360 128');
		spawn_nailgun('1728 1696 112');
		spawn_supernailgun('2128 936 0');
		spawn_rocketlauncher('2192 560 0');
		spawn_lightning('2048 -1008 256');
		spawn_pentagram('608 352 -360');
		spawn_armor('1168 248 -584' , 1);
		spawn_grenadelauncher('608 416 -384');
		spawn_supernailgun('352 1184 0');
	}
};

void() Episode4Change = {
	local entity e;
	if (mapname == "e4m1") {
		e = FindByModel("func_button" , "*24");
		remove(e);
		e = FindByOrigin("item_spikes" , '1900 -608 176');
		e.aflag  = 50;
		setmodel (e , "maps/b_nail1.bsp");
	} else if (mapname == "e4m2") {
		return;
	} else if (mapname == "e4m3") {
		return;
	} else if (mapname == "e4m4") {
		e = FindByTarget("trigger_teleport" , "t204");
		e.target  = "t196";
	} else if (mapname == "e4m5") {
		e = FindByOrigin("item_key1" , '-1960 -920 -56');
		remove(e);
	} else if (mapname == "e4m6") {
		return;
	} else if (mapname == "e4m7") {
		e = FindByOrigin("weapon_supernailgun" , '656 -1520 192');
		remove(e);
		e = FindByOrigin("weapon_rocketlauncher" , '-1056 -296 -136');
		remove(e);
		e = FindByOrigin("item_sigil" , '1000 -1856 216');
		remove(e);
		e = FindByOrigin("item_health" , '560 -1520 192');
		remove(e);
		e = FindByOrigin("item_cells" , '208 -1872 192');
		remove(e);
		e = FindByOrigin("item_armorInv" , '-1056 -8 -136');
		remove(e);
	} else if (mapname == "e4m8") {
		e = FindByOrigin("item_artifact_invulnerability" , '1928 1184 28');
		remove(e);
		e = FindByOrigin("item_artifact_super_damage" , '608 352 -360');
		remove(e);
		e = FindByOrigin("item_armor1" , '1168 248 -584');
		remove(e);
		e = FindByTargetname("info_teleport_destination" , "t231");
		setorigin(e , '1952 -875 115');
		e = FindByTargetname("info_teleport_destination" , "t243");
		setorigin(e , '1760 -1376 287');
	}
};


void() DMEpisodeSpawn = {
	local entity e;

	if (mapname == "dm1") {
	spawn_health('1088 734 74' , 1);
		spawn_supernailgun('793 1013 24');
		spawn_grenadelauncher('636 572 24');
		spawn_supershotgun('-400 1112 -144');
		SpawnTeamStart('749 704 42', TEAM_COLOR2 , 0);
		SpawnTeamStart('952 704 74', TEAM_COLOR2 , 0);
		SpawnTeamStart('1088 1009 74', TEAM_COLOR2 , 270);
		SpawnTeamStart('1088 845 74', TEAM_COLOR2 , 270);
		SpawnFlag('1088 704 74' , TEAM_COLOR2 , 0);
		SpawnTeamStart('347 1157 -120' , TEAM_COLOR1 , 0);
		SpawnTeamStart('54 1157 -120' , TEAM_COLOR1 , 0);
		SpawnTeamStart('54 1290 -120' , TEAM_COLOR1 , 0);
		SpawnTeamStart('347 1290 -120' , TEAM_COLOR1 , 0);
		SpawnFlag('432 1456 -120' , TEAM_COLOR1 , 0);
		spawn_supernailgun('-560 1384 0');
		spawn_armor('-392 1416 0' , 0);

	} else if (mapname == "dm2") {
		spawn_supernailgun('2430 -2288 120');
		spawn_supernailgun('1313 -1316 136');
		spawn_supershotgun('2051 -1313 136');
		SpawnTeamStart('2184 -2480 200', TEAM_COLOR2 , 90);
		SpawnTeamStart('2316 -1985 120', TEAM_COLOR2 , 270);
		SpawnTeamStart('2430 -2288 120', TEAM_COLOR2 , 180);
		SpawnTeamStart('2704 -2049 128', TEAM_COLOR2 , 270);
		SpawnFlag('2433 -2120 112' , TEAM_COLOR2 , 0);
		SpawnTeamStart('1280 -1024 352' , TEAM_COLOR1 , 0);
		SpawnTeamStart('2071 -1110 344' , TEAM_COLOR1 , 135);
		SpawnTeamStart('1531 -1078 48' , TEAM_COLOR1 , 270);
		SpawnTeamStart('1844 -1078 48' , TEAM_COLOR1 , 270);
		SpawnFlag('1980 -1026 344' , TEAM_COLOR1 , 0);
		spawn_supernailgun('2480 -192 0');

		// Delay hack
		e = find(world, classname, "item_flag_team2_temp");
		e.nextthink = time + 3;


	} else if (mapname == "dm3") {
		SpawnTeamStart('1432 -908 88', TEAM_COLOR2 , 0);
		SpawnTeamStart('1277 -897 88', TEAM_COLOR2 , 0);
		SpawnTeamStart('1120 -892 88', TEAM_COLOR2 , 0);
		SpawnTeamStart('1660 -742 -24', TEAM_COLOR2 , 0);
		SpawnTeamStart('1540 -742 -24', TEAM_COLOR2 , 0);
		SpawnTeamStart('1418 -742 -24', TEAM_COLOR2 , 0);
		SpawnTeamStart('1290 -742 -24', TEAM_COLOR2 , 0);
		SpawnTeamStart('1166 -730 -24', TEAM_COLOR2 , 0);
		spawn_supershotgun('1530 -898 88');
		SpawnFlag('1836 -672 -24' , TEAM_COLOR2 , 0);
		SpawnTeamStart('-482 698 184' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-334 640 184' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-348 396 184' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-464 228 176' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-740 358 184' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-866 478 184' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-740 546 184' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-792 704 184' , TEAM_COLOR1 , 0);
		spawn_supernailgun('-458 332 120');
		SpawnFlag('-490 482 120' , TEAM_COLOR1 , 0);
		spawn_armor('-536 240 -16' , 1);
		spawn_grenadelauncher('-64 -704 -40');
		spawn_quad('256 -700 328');
		spawn_supernailgun('1216 240 -416');


	} else if (mapname == "dm4") {
		spawn_health('-197 52 -296' , 1);
		spawn_health('-237 52 -296' , 1);
		SpawnTeamStart('849 -591 24', TEAM_COLOR2 , 0);
		SpawnTeamStart('795 -490 -104', TEAM_COLOR2 , 270);
		SpawnTeamStart('996 -542 -104', TEAM_COLOR2 , 180);
		SpawnFlag('996 -542 -104' , TEAM_COLOR2 , 0);
		SpawnTeamStart('-40 -241 -296' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-197 59 -296' , TEAM_COLOR1 , 0);
		SpawnTeamStart('-64 512 -296' , TEAM_COLOR1 , 270);
		SpawnFlag('-58 524 -296' , TEAM_COLOR1 , 0);
		spawn_armor('1136 -592 0' , 0);
		spawn_armor('712 72 -320' , 1);

	} else if (mapname == "dm5") {
		spawn_health('745 -740 216' , 1);
		spawn_health('700 -740 216' , 1);
		SpawnTeamStart('248 -784 120', TEAM_COLOR2 , 0);
		SpawnTeamStart('607 -768 216', TEAM_COLOR2 , 0);
		SpawnTeamStart('897 -387 216', TEAM_COLOR2 , 180);
		SpawnTeamStart('1075 -769 216', TEAM_COLOR2 , 180);
		SpawnFlag('1075 -769 216' , TEAM_COLOR2 , 0);
		SpawnTeamStart('764 377 216' , TEAM_COLOR1 , 180);
		SpawnTeamStart('289 368 216' , TEAM_COLOR1 , 90);
		SpawnTeamStart('292 960 120' , TEAM_COLOR1 , 270);
		SpawnTeamStart('290 295 120' , TEAM_COLOR1 , 90);
		SpawnFlag('292 960 120' , TEAM_COLOR1 , 0);
		spawn_rockets('680 -120 -32' , 0);
		spawn_rocketlauncher('648 -72 -32');
		spawn_supernailgun('536 360 -32');
		spawn_lightning('832 -208 208');
		spawn_cells('904 -208 208' , 1);

	} else if (mapname == "dm6") {
		spawn_health('1630 -168 168' , 0);
		spawn_supernailgun('1680 -168 168');
		spawn_nails('1730 -168 168' , 0);
		spawn_nails('1780 -168 168' , 0);
		spawn_nails('1830 -168 168' , 0);
		spawn_health('1880 -418 168' , 0);
		spawn_supershotgun('1880 -368 168');
		spawn_shells('1880 -318 168' , 0);
		spawn_shells('1880 -268 168' , 0);
		spawn_shells('1880 -218 168' , 0);
		spawn_health('250 -1140 130' , 0);
		spawn_health('200 -1140 130' , 0);
		spawn_health('150 -1140 130' , 0);
		spawn_supernailgun('250 -1190 130');
		spawn_armor('200 -1190 130' , 1);
		spawn_supershotgun('150 -1190 130');
		spawn_nails('250 -1240 130' , 0);
		spawn_nails('200 -1240 130' , 0);
		spawn_nails('150 -1240 130' , 0);
		spawn_shells('250 -1290 130' , 0);
		spawn_shells('200 -1290 130' , 0);
		spawn_shells('150 -1290 130' , 0);
		SpawnTeamStart('1764 -900 168', TEAM_COLOR2 , 180);
		SpawnTeamStart('1764 -800 168', TEAM_COLOR2 , 180);
		SpawnTeamStart('1764 -700 168', TEAM_COLOR2 , 180);
		SpawnTeamStart('1764 -600 168', TEAM_COLOR2 , 180);
		SpawnTeamStart('1764 -500 168', TEAM_COLOR2 , 180);
		SpawnTeamStart('1764 -400 168', TEAM_COLOR2 , 180);
		SpawnFlag('1880 -168 168' , TEAM_COLOR2 , 90);
		SpawnTeamStart('250 -1090 112' , TEAM_COLOR1 , 90);
		SpawnTeamStart('250 -1190 112' , TEAM_COLOR1 , 90);
		SpawnTeamStart('250 -1290 112' , TEAM_COLOR1 , 90);
		SpawnTeamStart('150 -1090 112' , TEAM_COLOR1 , 90);
		SpawnTeamStart('150 -1190 112' , TEAM_COLOR1 , 90);
		SpawnTeamStart('150 -1290 112' , TEAM_COLOR1 , 90);
		SpawnFlag('200 -1304 130' , TEAM_COLOR1 , 0);


	} else if (mapname == "end") {
		spawn_lightning('-1310 1989 24');
		spawn_health('-350 -494 -536' , 2);
		spawn_envirosuit('23 -493 -536');
		spawn_grenadelauncher('-552 52 24');
		spawn_supernailgun('-543 -18 24');
		spawn_armor('-1271 2672 232' , 0);
		spawn_rockets('-890 2009 72' , 0);
		spawn_supershotgun('-770 2095 72');
		spawn_armor('-661 1983 72' , 1);
		spawn_quad('-799 1892 72');
		SpawnTeamStart('-321 -112 -155', TEAM_COLOR2 , 90);
		SpawnTeamStart('-413 -130 -90', TEAM_COLOR2 , 70);
		SpawnTeamStart('-441 -61 -90', TEAM_COLOR2 , 10);
		SpawnTeamStart('-448 39 -90', TEAM_COLOR2 , 10);
		SpawnTeamStart('-423 114 -90', TEAM_COLOR2 , 290);
		SpawnTeamStart('-304 112 -155', TEAM_COLOR2 , 260);
		SpawnFlag('-384 0 -240' , TEAM_COLOR2 , 0);
		SpawnTeamStart('-812 2687 120' , TEAM_COLOR1 , 30);
		SpawnTeamStart('-801 2753 120' , TEAM_COLOR1 , 10);
		SpawnTeamStart('-777 2837 120' , TEAM_COLOR1 , 350);
		SpawnTeamStart('-727 2853 120' , TEAM_COLOR1 , 310);
		SpawnTeamStart('-681 2848 120' , TEAM_COLOR1 , 270);
		SpawnTeamStart('-624 2803 120' , TEAM_COLOR1 , 270);
		SpawnFlag('-624 2692 120' , TEAM_COLOR1 , 0);

	}

};

void() DMEpisodeChange = {
	local entity e;

	if (mapname == "dm1") {
		e = FindByOrigin("weapon_nailgun" , '-560 1384 0');
		remove(e);
		e = FindByOrigin("weapon_nailgun" , '1088 704 48');
		remove(e);
		e = FindByOrigin("item_armor2" , '-392 1416 0');
		remove(e);
		e = FindByOrigin("item_armor1" , '-400 1112 -144');
		remove(e);
		e = FindByModel("func_button" , "*5");
		remove(e);
		e = FindByModel("door" , "*2");
		remove(e);
		e = FindByModel("door" , "*1");
		remove(e);
		e = FindByTargetname("info_teleport_destination" , "t1");
		setorigin(e , '178 1174 -93');
		e.mangle_y = 0;
	
	} else if (mapname == "dm2") {
		e = FindByTarget("trigger_teleport" , "t14");
		remove(e);
		e = FindByTargetname("info_teleport_destination" , "t14");
		remove(e);
		e = FindByOrigin("weapon_nailgun" , '2480 -192 0');
		remove(e);
		e = FindByTargetname("info_teleport_destination" , "t7");
		e.mangle_y = 90;
		setorigin(e , '1920 -740 527');
		e = FindByModel("door" , "*16");
		e.spawnflags  = 0;
		e.wait  = -1;
		setorigin (e, e.pos2);
		self.pos2 = e.pos1;
		self.pos1 = e.origin;
		e = FindByModel("func_button" , "*17");
		e.target  = "";
	} else if (mapname == "dm3") {
		e = FindByOrigin("item_artifact_invisibility" , '240 -32 56');
		remove(e);
		e = FindByOrigin("item_artifact_invulnerability" , '1008 800 -296');
		remove(e);
		e = FindByOrigin("item_artifact_super_damage" , '952 296 56');
		remove(e);
		e = FindByOrigin("weapon_supershotgun" , '1776 -656 -48');
		remove(e);
		e = FindByOrigin("weapon_nailgun" , '-64 -704 -40');
		remove(e);
		e = FindByOrigin("weapon_supernailgun" , '-512 448 96');
		remove(e);
		e = FindByOrigin("item_armorInv" , '256 -704 304');
		remove(e);
		e = FindByOrigin("weapon_grenadelauncher" , '1216 240 -416');
		remove(e);


	} else if (mapname == "dm4") {
		e = FindByOrigin("item_armor2" , '1136 -592 0');
		remove(e);
		e = FindByOrigin("item_armor1" , '712 72 -320');
		remove(e);
		e = FindByTargetname("info_teleport_destination" , "t5");
		e.mangle_y = 90;
		setorigin(e , '849 -591 51');

	} else if (mapname == "dm5") {
		e = FindByOrigin("item_artifact_invulnerability" , '648 8 -8');
		remove(e);
		e = FindByOrigin("item_cells" , '680 -120 -32');
		remove(e);
		e = FindByOrigin("weapon_lightning" , '648 -72 -32');
		remove(e);
		e = FindByOrigin("weapon_rocketlauncher" , '272 944 96');
		remove(e);
		e = FindByOrigin("weapon_nailgun" , '536 360 -32');
		remove(e);
		e = FindByOrigin("weapon_supernailgun" , '832 -208 208');
		remove(e);
		e = FindByOrigin("item_spikes" , '904 -208 208');
		remove(e);
		e = FindByTargetname("info_teleport_destination" , "t3");
		remove(e);
		e = FindByTarget("trigger_teleport" , "t3");
		remove(e);
		e = FindByTarget("trigger_teleport" , "t2");
		remove(e);
		e = FindByTargetname("info_teleport_destination" , "t2");
		remove(e);
		e = FindByOrigin("item_health" , '736 504 192');
		e.spawnflags = 0;
		setmodel (e , "maps/b_bh25.bsp");
		e.noise  = "items/health1.wav";
	} else if (mapname == "dm6") {
		return;

	} else if (mapname == "end") {
		e = find(world, classname, "trigger_hurt");
		remove(e);
		e = find(world, classname, "trigger_secret");
		remove(e);
		e = FindByTarget("trigger_teleport" , "t67");
		remove(e);
		e = FindByOrigin("item_artifact_super_damage" , '-624 2672 120');
		remove(e);
		e = FindByOrigin("weapon_lightning" , '-384 0 -240');
		remove(e);
		e = find(world, classname, "trigger_changelevel");
		e.map  = "ctfstart";
	}
};



void() AnkaMaps = {
	local entity e;
	NOSPAWN = 1;
	if (mapname == "e2m1") {
		SpawnItem("weapon_rocketlauncher", '260 -220 -104');
	} else if (mapname == "e2m2") {
		RemoveByOrigin("weapon_lightning", '200 -664 0');
		SpawnItem("weapon_rocketlauncher", '200 -664 0');
		RemoveByOrigin("weapon_grenadelauncher", '-360 1064 -8');
		SpawnItem("weapon_lightning", '-360 1064 -8');
	} else if (mapname == "e2m3") {
		RemoveByOrigin("weapon_rocketlauncher", '56 1144 128');	
		RemoveByOrigin("weapon_lightning", '1216 1784 -264');	
		SpawnItem("weapon_rocketlauncher", '1216 1784 -264');
		SpawnItem("weapon_lightning", '56 1144 128');
		SpawnItem("weapon_rocketlauncher", '1170 -450 280');
	} else if (mapname == "e2m5") {
		SpawnItem("weapon_rocketlauncher", '-150 2820 -224');
	}
};

void(float teamno, vector tpos1, vector tpos2, float newangle) ReplaceStartSpot = {
	local float color;
	local string class;
	if (teamno == 1) {
		class = "info_player_team1";
		color = TEAM_COLOR1;
	} else {
		class = "info_player_team2";
		color = TEAM_COLOR2;
	}
//	EntityDebug = 1;
	RemoveByOrigin(class, tpos1);
	if (!FindByOrigin(class, tpos2))
		SpawnTeamStart(tpos2, color, newangle);
};

void() CorrectMaps = {
	if (mapname == "e1m4") {
		RemoveByTarget("trigger_teleport", "t40");
		RemoveByTarget("trigger_teleport", "t40");
	} else if (mapname == "e1m7") {
		RemoveByTarget("trigger_teleport", "t15");
		RemoveByOrigin("info_player_team1", '839 62 164');
		RemoveByOrigin("info_player_team2", '-592 57 56');
		if (!FindByOrigin("info_player_team1", '930 400 216'))
			SpawnTeamStart('930 400 216', TEAM_COLOR1, 180);
		if (!FindByOrigin("info_player_team1", '930 225 216'))
			SpawnTeamStart('930 225 216', TEAM_COLOR1, 180);
		if (!FindByOrigin("info_player_team1", '930 100 216'))
			SpawnTeamStart('930 100 216', TEAM_COLOR1, 180);
		if (!FindByOrigin("info_player_team1", '930 -250 216'))
			SpawnTeamStart('930 -250 216', TEAM_COLOR1, 180);
	} else if (mapname == "e2m6") {
		RemoveByTarget("trigger_teleport", "t88");
	} else if (mapname == "e3m4") {
		RemoveByTarget("trigger_teleport", "t174");
	} else if (mapname == "e3m5") {
		RemoveByOrigin("info_player_team2", '563 -1397 448');
		RemoveByOrigin("info_player_team2", '563 -1455 448');
	} else if (mapname == "e3m6") {
		RemoveByTarget("trigger_teleport", "t169");
		RemoveByTarget("trigger_teleport", "t169");
	} else if (mapname == "e4m4") {
		return;
		RemoveByOrigin("info_player_team1", '832 -1496 24');
		if (!FindByOrigin("info_player_team2", '832 -1496 24'))
			SpawnTeamStart('832 -1496 24', TEAM_COLOR2, 0);
	} else if (mapname == "e4m5") {
		RemoveByTarget("trigger_teleport", "t178");
		RemoveByOrigin("info_player_team1", '1110 2370 120');
		if (!FindByOrigin("info_player_team1", '1110 2300 120'))
			SpawnTeamStart('1110 2300 120', TEAM_COLOR1, 0);
	} else if (mapname == "e4m8") {
		RemoveByTarget("trigger_teleport", "t273");
	} else if (mapname == "ctf2") {
		ReplaceStartSpot(2, '16 72 200', '16 72 216', 270);
		ReplaceStartSpot(2, '336 72 200', '336 72 216', 270);
		ReplaceStartSpot(2, '280 112 8', '280 112 24', 270);   // <-?
		ReplaceStartSpot(2, '328 -24 8', '328 -24 24', 270);
		ReplaceStartSpot(1, '336 -1184 8', '336 -1184 24', 90);
		ReplaceStartSpot(1, '208 -1304 -120', '208 -1304 -104', 90);
		ReplaceStartSpot(1, '152 -1208 -120', '152 -1208 -104', 90);
	} else if (mapname == "xeno6") {
		if (FLAG_DEBUG) bprint(PRINT_HIGH, "correcting xeno6\n");
		SpawnBlock('650 480 280', '500 25 100');
	} else if (mapname == "twctf2m7") {
		if (FLAG_DEBUG) bprint(PRINT_HIGH, "correcting twctf2m7\n");
		SpawnBlock('-630 -1600 315', '100 200 100');
		SpawnBlock('-630 1400 315', '100 200 100');
	}
};

void() ArenaEpisodeSpawn;


void() SpawnMaps = {
	local entity e;
	EntityDebug = 0;	// debug
	NOSPAWN = 1;		// debug

	NOSPAWN = 0;
	
	if (!find(world, classname, "item_flag_team1") && !find(world, classname, "item_flag_team2")) {
		e = find(world, classname, "item_flag_team1_temp");
		if (e) {e.classname = "item_flag_team1"; if (FLAG_DEBUG) bprint(PRINT_HIGH, "red flag found\n");}
		e = find(world, classname, "item_flag_team2_temp");
		if (e) {e.classname = "item_flag_team2"; if (FLAG_DEBUG) bprint(PRINT_HIGH, "red flag found\n");}
		Episode1Change();
		Episode2Change();
		Episode3Change();
		Episode4Change();
		DMEpisodeChange();
		Custom1Change();
		Custom2Change();
		if (FLAG_DEBUG)		// debug
			bprint(PRINT_HIGH, "Maps converted ok.\n");
		
	} else {
		if (FLAG_DEBUG)		// debug
			bprint(PRINT_HIGH, "Already converted maps detected.\n");
		RemoveSpawnChain();
	}

	CorrectMaps();
	if (FLAG_ANKAMAPS) {
		SpawnChainFlag = 0;	// *check* obsolete?
		AnkaMaps();
	}
};


void() ArenaMaps;

void() SpawnCTFMaps =
{	
	local entity e;

	if (FLAG_ARENA) {
		ArenaMaps();
		ArenaEpisodeSpawn();
	}
	if (FLAG_CTF) {
		EntityDebug = 0;
		if (!(stof(infokey(world, "nodynamicmaps")))) {
			InitSpawnChain();
			Episode1Spawn();
			Episode2Spawn();
			Episode3Spawn();
			Episode4Spawn();
			DMEpisodeSpawn();
			Custom1Spawn();
			Custom2Spawn();
			SpawnChainFlag = 0;

			e = spawn();
			e.think = SpawnMaps;
			e.nextthink = time  + 0.5; 		

			// Spawn CTF Conversion
		}

	
	
		ExtraTeamSpots();		// *check* obsolete?
	}
};


// *check*

