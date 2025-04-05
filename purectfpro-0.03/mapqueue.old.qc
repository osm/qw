

string(float q, float n) LocalinfoMap;


//
// Change map if the fraglimit or timelimit has expired.
//
void() NextLevel = {
	local entity o;

	// Check for legal votemaps (Some clunky coding needed because of QC's limitations)
	local string votemap;
	votemap = infokey(world, "votemap");
	if (votemap == "allstart")
		votemap = "allstart";
	else if (votemap == "twstart")
		votemap = "twstart";
	else if (votemap == "epstart")
		votemap = "epstart";
	else votemap = "allstart";		// You're supposed to have allstar now. :)
	
	// Don't change map rotation here, read the doc and change it in server.cfg instead.

	// episode one
	if (mapname == "e1m1") nextmap = "e1m2";
	else if (mapname == "e1m2") nextmap = "e1m3";
	else if (mapname == "e1m3") nextmap = "e1m4";
	else if (mapname == "e1m4") nextmap = "e1m5";
	else if (mapname == "e1m5") nextmap = "e1m6";
	else if (mapname == "e1m6") nextmap = "e1m7";	// e1m7 is in
	else if (mapname == "e1m7") nextmap = "e1m8";	// ...and so is e1m8.
	else if (mapname == "e1m8") nextmap = votemap;	

	// episode two
	else if (mapname == "e2m1") nextmap = "e2m2";
	else if (mapname == "e2m2") nextmap = "e2m3";
	else if (mapname == "e2m3") nextmap = "e2m4";
	else if (mapname == "e2m4") nextmap = "e2m5";
	else if (mapname == "e2m5") nextmap = "e2m6";
	else if (mapname == "e2m6") nextmap = "e2m7";
	else if (mapname == "e2m7") nextmap = votemap;	//***maps*** allstars etc compatibility

	// episode three
	else if (mapname == "e3m1") nextmap = votemap; 	//***maps*** allstars etc compatibility

	// episode four
	else if (mapname == "e4m1") nextmap = "e4m2";
	else if (mapname == "e4m2") nextmap = "e4m3";
	else if (mapname == "e4m3") nextmap = "e4m6";
	else if (mapname == "e4m6") nextmap = "e4m8";
	else if (mapname == "e4m8") nextmap = votemap; 	// Allstars etc votemap

	// the deathmatch arenas
	else if (mapname == "dm1") nextmap = "dm2";
	else if (mapname == "dm2") nextmap = "dm3";
	else if (mapname == "dm3") nextmap = "dm6";
	else if (mapname == "dm6") nextmap = votemap;

	// ctf episode one
	else if (mapname == "ctf1") nextmap = "ctf5";
	else if (mapname == "ctf5") nextmap = "ctf6";
	else if (mapname == "ctf6") nextmap = "ctf8";
	else if (mapname == "ctf8") nextmap = votemap;	//***maps*** allstars etc compatibility

	// ctf episode two
	else if (mapname == "ctf2m1") nextmap = "ctf2m3";
	else if (mapname == "ctf2m3") nextmap = "ctf2m7";
	else if (mapname == "ctf2m7") nextmap = "ctf2m8";
	else if (mapname == "ctf2m8") nextmap = votemap; //***maps*** allstars etc compatibility


//***maps*** --> Map queue from allstars

	// TWCTF episode one
	else if (mapname == "twctf1") nextmap = "twctf2";
	else if (mapname == "twctf2") nextmap = "twctf3";
	else if (mapname == "twctf3") nextmap = "twctf4";
	else if (mapname == "twctf4") nextmap = "twctf6";
// ThunderWalker: Had to take out twctf5 due to flakiness
//	else if (mapname == "twctf5") nextmap = "twctf6";	// Hrm?
	else if (mapname == "twctf6") nextmap = "twctf7";
	else if (mapname == "twctf7") nextmap = "twctf8";
	else if (mapname == "twctf8") nextmap = "twctf9";
	else if (mapname == "twctf9") nextmap = votemap;

	else if (mapname == "xeno1") nextmap = "xeno2";
	else if (mapname == "xeno2") nextmap = "xeno3";
	else if (mapname == "xeno3") nextmap = "xeno4";
	else if (mapname == "xeno4") nextmap = "xeno5";		// Allstar v1.10
	else if (mapname == "xeno5") nextmap = "expctf1";
	else if (mapname == "expctf1") nextmap = "xeno6";
	else if (mapname == "xeno6") nextmap = "xeno7";
	else if (mapname == "xeno7") nextmap = "expctf2";
	else if (mapname == "expctf2") nextmap = "xeno8";
 	else if (mapname == "xeno8") nextmap = "allstart";	

	else if (mapname == "twctf2m1") nextmap = "twctf2m2";
	else if (mapname == "twctf2m2") nextmap = "twctf2m3";
	else if (mapname == "twctf2m3") nextmap = "twctf2m4";
	else if (mapname == "twctf2m4") nextmap = "twctf2m5";
	else if (mapname == "twctf2m5") nextmap = "twctf2m6";
	else if (mapname == "twctf2m6") nextmap = "twctf2m7";
	else if (mapname == "twctf2m7") nextmap = "twctf2m8";
	else if (mapname == "twctf2m8") nextmap = "twctf2m9";
	else if (mapname == "twctf2m9") nextmap = "twctf2ma";
	else if (mapname == "twctf2ma") nextmap = "twctf2mb";
	else if (mapname == "twctf2mb") nextmap = "twctf2mc";
	else if (mapname == "twctf2mc") nextmap = "allstart";
	
	else if (mapname == "ctf1bsp0") nextmap = "ctf1bsp1";
	else if (mapname == "ctf1bsp1") nextmap = "ctf1bsp2";
	else if (mapname == "ctf1bsp2") nextmap = "ctf1bsp3";
	else if (mapname == "ctf1bsp3") nextmap = "ctf1bsp4";
	else if (mapname == "ctf1bsp4") nextmap = "ctf1bsp5";
	else if (mapname == "ctf1bsp5") nextmap = "ctf1bsp6";
	else if (mapname == "ctf1bsp6") nextmap = "ctf1bsp7";
	else if (mapname == "ctf1bsp7") nextmap = "ctf1bsp8";
	else if (mapname == "ctf1bsp8") nextmap = "ctf1bsp9";
	else if (mapname == "ctf1bsp9") nextmap = "ctf1bspx";
	else if (mapname == "ctf1bspx") nextmap = "allstart";

	// Loc CTF, just rotate them.
	else if (mapname == "ctf3m1") nextmap = "ctf3m2";
	else if (mapname == "ctf3m2") nextmap = "ctf3m3";
	else if (mapname == "ctf3m3") nextmap = "ctf3m4";
	else if (mapname == "ctf3m4") nextmap = "ctf3m5";
	else if (mapname == "ctf3m5") nextmap = "ctf3m6";
	else if (mapname == "ctf3m6") nextmap = "ctf3m7";
	else if (mapname == "ctf3m7") nextmap = "ctf3m8";
	else if (mapname == "ctf3m8") nextmap = "ctf3m9";
	else if (mapname == "ctf3m9") nextmap = "ctf3m1";		

	// Don't change map rotation here, read the doc and change it in server.cfg instead.


//***maps*** <--

	// Ok, goto intermission next gametic.
	o = spawn();
	o.map = nextmap;
	o.think = execute_changelevel;
	o.nextthink = time + 0.1;
};


float NEXTMAPFLAG;

void() GotoNextMap =
{
	local string newmap, mapqname;						
	local float rcount, rpick;
	local float samelvl;
	local float bigmaps;
	local string oldmap;
	local float x,y,z;

	if (NEXTMAPFLAG)
		return;		// Only once please.
	NEXTMAPFLAG = 1;

	samelvl = cvar("samelevel");		

	if (nextmap == "ctf9")			// *check* ??				
		nextmap = "ctf2m1";


	if ((samelvl == 1) || FLAG_COMPETITION) {			// Repeat map *check* --> mode 3?
		ChangeMap(mapname);
	} else if (samelvl == 2) {		// Localinfo Mapqueue
		newmap = infokey(world, mapname);
		if (newmap == "")
			newmap = infokey(world, "defaultmap");
		if (newmap == "") {
			bprint(PRINT_HIGH, "\n*********************************\n");
			bprint(PRINT_HIGH, "Note: Server is out of the queue.\n");
			bprint(PRINT_HIGH, "*********************************\n\n");
			newmap = mapname;
		}
		ChangeMap(newmap);
	} else if (samelvl == 3) {		// Random Maps
		rcount = (stof (infokey(world, "maps")));
		newmap = mapname;
		while (mapname == newmap) {
			rpick = floor(random() * rcount); 
			newmap = LocalinfoMap(0, rpick);
		}
		if (newmap == "") {
			newmap = mapname;
			bprint(PRINT_HIGH, "\n********************************\n");
			bprint(PRINT_HIGH, "Note: Server mapqueue is broken.\n");
			bprint(PRINT_HIGH, "********************************\n\n");
		}
		ChangeMap(newmap);
	} else if (samelvl == 4) {		// Dynamic Maprotation
		if (FLAG_DEBUG)
			TOTALPLAYERS = localinfo("t", 0);
		if ((TOTALPLAYERS > localinfo("max3",0)) && localinfo("max3",0)) {
			y = 4;
			mapqname = "mapq4";
		} else if ((TOTALPLAYERS > localinfo("max2",0)) && localinfo("max2",0)) {
			y = 3;
			mapqname = "mapq3";
		} else if ((TOTALPLAYERS > localinfo("max1",0)) && localinfo("max1",0)) {
			y = 2;
			mapqname = "mapq2";
		} else 	{
			y = 1;
			mapqname = "mapq1";
		}
		if (FLAG_DEBUG) bprintnum("Using mapqueue: ", y);
		x = 0;
		if (!LASTQUEUE) {
			z = 50;
			while(!x && z) {
				z = z - 1;
				if (mapname == LocalinfoMap(y, z))
					x = z + 1;
			}
		}
		if (!x)	x = localinfo(mapqname, 0);

		if (FLAG_DEBUG) bprintnum("Getting map: ", x);

		newmap = LocalinfoMap(y, x);
		if (newmap == string_null) {
			newmap = LocalinfoMap(y, 0);
			x = 0;
		}
		x = x + 1;
		SetVar(LOCALINFO, mapqname, x);
		if (newmap == string_null) {
			newmap = mapname;
			bprint(PRINT_HIGH, "\n********************************\n");
			bprint(PRINT_HIGH, "Note: Server mapqueue is broken.\n");
			bprint(PRINT_HIGH, "********************************\n\n");
		}

		ChangeMap(newmap);		// standard ctf mapqueue
	} else 
		ChangeMap(nextmap);		// standard ctf mapqueue
};

//
// Don't ya just luuuuuve QC? :)
//
string(float q, float n) LocalinfoMap = {
	if (q == 0) { 		// Random mapqueue
		if (n ==  0) return infokey(world, "map01");
		else if (n ==  1) return infokey(world, "map02");
		else if (n ==  2) return infokey(world, "map03");
		else if (n ==  3) return infokey(world, "map04");
		else if (n ==  4) return infokey(world, "map05");
		else if (n ==  5) return infokey(world, "map06");
		else if (n ==  6) return infokey(world, "map07");
		else if (n ==  7) return infokey(world, "map08");
		else if (n ==  8) return infokey(world, "map09");
		else if (n ==  9) return infokey(world, "map10");
		else if (n == 10) return infokey(world, "map11");
		else if (n == 11) return infokey(world, "map12");
		else if (n == 12) return infokey(world, "map13");
		else if (n == 13) return infokey(world, "map14");
		else if (n == 14) return infokey(world, "map15");
		else if (n == 15) return infokey(world, "map16");
		else if (n == 16) return infokey(world, "map17");
		else if (n == 17) return infokey(world, "map18");
		else if (n == 18) return infokey(world, "map19");
		else if (n == 19) return infokey(world, "map20");
		else if (n == 20) return infokey(world, "map21");
		else if (n == 21) return infokey(world, "map22");
		else if (n == 22) return infokey(world, "map23");
		else if (n == 23) return infokey(world, "map24");
		else if (n == 24) return infokey(world, "map25");
		else if (n == 25) return infokey(world, "map26");
		else if (n == 26) return infokey(world, "map27");
		else if (n == 27) return infokey(world, "map28");
		else if (n == 28) return infokey(world, "map29");
		else if (n == 29) return infokey(world, "map30");
		else if (n == 30) return infokey(world, "map31");
		else if (n == 31) return infokey(world, "map32");
		else if (n == 32) return infokey(world, "map33");
		else if (n == 33) return infokey(world, "map34");
		else if (n == 34) return infokey(world, "map35");
		else if (n == 35) return infokey(world, "map36");
		else if (n == 36) return infokey(world, "map37");
		else if (n == 37) return infokey(world, "map38");
		else if (n == 38) return infokey(world, "map39");
		else if (n == 39) return infokey(world, "map40");
		else if (n == 40) return infokey(world, "map41");
		else if (n == 41) return infokey(world, "map42");
		else if (n == 42) return infokey(world, "map43");
		else if (n == 43) return infokey(world, "map44");
		else if (n == 44) return infokey(world, "map45");
		else if (n == 45) return infokey(world, "map46");
		else if (n == 46) return infokey(world, "map47");
		else if (n == 47) return infokey(world, "map48");
		else if (n == 48) return infokey(world, "map49");
		else if (n == 49) return infokey(world, "map50");
	} else if (q == 1) {
		if (n ==  0) return infokey(world, "m1map01");
		else if (n ==  1) return infokey(world, "m1map02");
		else if (n ==  2) return infokey(world, "m1map03");
		else if (n ==  3) return infokey(world, "m1map04");
		else if (n ==  4) return infokey(world, "m1map05");
		else if (n ==  5) return infokey(world, "m1map06");
		else if (n ==  6) return infokey(world, "m1map07");
		else if (n ==  7) return infokey(world, "m1map08");
		else if (n ==  8) return infokey(world, "m1map09");
		else if (n ==  9) return infokey(world, "m1map10");
		else if (n == 10) return infokey(world, "m1map11");
		else if (n == 11) return infokey(world, "m1map12");
		else if (n == 12) return infokey(world, "m1map13");
		else if (n == 13) return infokey(world, "m1map14");
		else if (n == 14) return infokey(world, "m1map15");
		else if (n == 15) return infokey(world, "m1map16");
		else if (n == 16) return infokey(world, "m1map17");
		else if (n == 17) return infokey(world, "m1map18");
		else if (n == 18) return infokey(world, "m1map19");
		else if (n == 19) return infokey(world, "m1map20");
		else if (n == 20) return infokey(world, "m1map21");
		else if (n == 21) return infokey(world, "m1map22");
		else if (n == 22) return infokey(world, "m1map23");
		else if (n == 23) return infokey(world, "m1map24");
		else if (n == 24) return infokey(world, "m1map25");
		else if (n == 25) return infokey(world, "m1map26");
		else if (n == 26) return infokey(world, "m1map27");
		else if (n == 27) return infokey(world, "m1map28");
		else if (n == 28) return infokey(world, "m1map29");
		else if (n == 29) return infokey(world, "m1map30");
		else if (n == 30) return infokey(world, "m1map31");
		else if (n == 31) return infokey(world, "m1map32");
		else if (n == 32) return infokey(world, "m1map33");
		else if (n == 33) return infokey(world, "m1map34");
		else if (n == 34) return infokey(world, "m1map35");
		else if (n == 35) return infokey(world, "m1map36");
		else if (n == 36) return infokey(world, "m1map37");
		else if (n == 37) return infokey(world, "m1map38");
		else if (n == 38) return infokey(world, "m1map39");
		else if (n == 39) return infokey(world, "m1map40");
		else if (n == 40) return infokey(world, "m1map41");
		else if (n == 41) return infokey(world, "m1map42");
		else if (n == 42) return infokey(world, "m1map43");
		else if (n == 43) return infokey(world, "m1map44");
		else if (n == 44) return infokey(world, "m1map45");
		else if (n == 45) return infokey(world, "m1map46");
		else if (n == 46) return infokey(world, "m1map47");
		else if (n == 47) return infokey(world, "m1map48");
		else if (n == 48) return infokey(world, "m1map49");
		else if (n == 49) return infokey(world, "m1map50");
	} else if (q == 2) {
		if (n ==  0) return infokey(world, "m2map01");
		else if (n ==  1) return infokey(world, "m2map02");
		else if (n ==  2) return infokey(world, "m2map03");
		else if (n ==  3) return infokey(world, "m2map04");
		else if (n ==  4) return infokey(world, "m2map05");
		else if (n ==  5) return infokey(world, "m2map06");
		else if (n ==  6) return infokey(world, "m2map07");
		else if (n ==  7) return infokey(world, "m2map08");
		else if (n ==  8) return infokey(world, "m2map09");
		else if (n ==  9) return infokey(world, "m2map10");
		else if (n == 10) return infokey(world, "m2map11");
		else if (n == 11) return infokey(world, "m2map12");
		else if (n == 12) return infokey(world, "m2map13");
		else if (n == 13) return infokey(world, "m2map14");
		else if (n == 14) return infokey(world, "m2map15");
		else if (n == 15) return infokey(world, "m2map16");
		else if (n == 16) return infokey(world, "m2map17");
		else if (n == 17) return infokey(world, "m2map18");
		else if (n == 18) return infokey(world, "m2map19");
		else if (n == 19) return infokey(world, "m2map20");
		else if (n == 20) return infokey(world, "m2map21");
		else if (n == 21) return infokey(world, "m2map22");
		else if (n == 22) return infokey(world, "m2map23");
		else if (n == 23) return infokey(world, "m2map24");
		else if (n == 24) return infokey(world, "m2map25");
		else if (n == 25) return infokey(world, "m2map26");
		else if (n == 26) return infokey(world, "m2map27");
		else if (n == 27) return infokey(world, "m2map28");
		else if (n == 28) return infokey(world, "m2map29");
		else if (n == 29) return infokey(world, "m2map30");
		else if (n == 30) return infokey(world, "m2map31");
		else if (n == 31) return infokey(world, "m2map32");
		else if (n == 32) return infokey(world, "m2map33");
		else if (n == 33) return infokey(world, "m2map34");
		else if (n == 34) return infokey(world, "m2map35");
		else if (n == 35) return infokey(world, "m2map36");
		else if (n == 36) return infokey(world, "m2map37");
		else if (n == 37) return infokey(world, "m2map38");
		else if (n == 38) return infokey(world, "m2map39");
		else if (n == 39) return infokey(world, "m2map40");
		else if (n == 40) return infokey(world, "m2map41");
		else if (n == 41) return infokey(world, "m2map42");
		else if (n == 42) return infokey(world, "m2map43");
		else if (n == 43) return infokey(world, "m2map44");
		else if (n == 44) return infokey(world, "m2map45");
		else if (n == 45) return infokey(world, "m2map46");
		else if (n == 46) return infokey(world, "m2map47");
		else if (n == 47) return infokey(world, "m2map48");
		else if (n == 48) return infokey(world, "m2map49");
		else if (n == 49) return infokey(world, "m2map50");
	} else if (q == 3) {
		if (n ==  0) return infokey(world, "m3map01");
		else if (n ==  1) return infokey(world, "m3map02");
		else if (n ==  2) return infokey(world, "m3map03");
		else if (n ==  3) return infokey(world, "m3map04");
		else if (n ==  4) return infokey(world, "m3map05");
		else if (n ==  5) return infokey(world, "m3map06");
		else if (n ==  6) return infokey(world, "m3map07");
		else if (n ==  7) return infokey(world, "m3map08");
		else if (n ==  8) return infokey(world, "m3map09");
		else if (n ==  9) return infokey(world, "m3map10");
		else if (n == 10) return infokey(world, "m3map11");
		else if (n == 11) return infokey(world, "m3map12");
		else if (n == 12) return infokey(world, "m3map13");
		else if (n == 13) return infokey(world, "m3map14");
		else if (n == 14) return infokey(world, "m3map15");
		else if (n == 15) return infokey(world, "m3map16");
		else if (n == 16) return infokey(world, "m3map17");
		else if (n == 17) return infokey(world, "m3map18");
		else if (n == 18) return infokey(world, "m3map19");
		else if (n == 19) return infokey(world, "m3map20");
		else if (n == 20) return infokey(world, "m3map21");
		else if (n == 21) return infokey(world, "m3map22");
		else if (n == 22) return infokey(world, "m3map23");
		else if (n == 23) return infokey(world, "m3map24");
		else if (n == 24) return infokey(world, "m3map25");
		else if (n == 25) return infokey(world, "m3map26");
		else if (n == 26) return infokey(world, "m3map27");
		else if (n == 27) return infokey(world, "m3map28");
		else if (n == 28) return infokey(world, "m3map29");
		else if (n == 29) return infokey(world, "m3map30");
		else if (n == 30) return infokey(world, "m3map31");
		else if (n == 31) return infokey(world, "m3map32");
		else if (n == 32) return infokey(world, "m3map33");
		else if (n == 33) return infokey(world, "m3map34");
		else if (n == 34) return infokey(world, "m3map35");
		else if (n == 35) return infokey(world, "m3map36");
		else if (n == 36) return infokey(world, "m3map37");
		else if (n == 37) return infokey(world, "m3map38");
		else if (n == 38) return infokey(world, "m3map39");
		else if (n == 39) return infokey(world, "m3map40");
		else if (n == 40) return infokey(world, "m3map41");
		else if (n == 41) return infokey(world, "m3map42");
		else if (n == 42) return infokey(world, "m3map43");
		else if (n == 43) return infokey(world, "m3map44");
		else if (n == 44) return infokey(world, "m3map45");
		else if (n == 45) return infokey(world, "m3map46");
		else if (n == 46) return infokey(world, "m3map47");
		else if (n == 47) return infokey(world, "m3map48");
		else if (n == 48) return infokey(world, "m3map49");
		else if (n == 49) return infokey(world, "m3map50");
	} else if (q == 4) {
		if (n ==  0) return infokey(world, "m4map01");
		else if (n ==  1) return infokey(world, "m4map02");
		else if (n ==  2) return infokey(world, "m4map03");
		else if (n ==  3) return infokey(world, "m4map04");
		else if (n ==  4) return infokey(world, "m4map05");
		else if (n ==  5) return infokey(world, "m4map06");
		else if (n ==  6) return infokey(world, "m4map07");
		else if (n ==  7) return infokey(world, "m4map08");
		else if (n ==  8) return infokey(world, "m4map09");
		else if (n ==  9) return infokey(world, "m4map10");
		else if (n == 10) return infokey(world, "m4map11");
		else if (n == 11) return infokey(world, "m4map12");
		else if (n == 12) return infokey(world, "m4map13");
		else if (n == 13) return infokey(world, "m4map14");
		else if (n == 14) return infokey(world, "m4map15");
		else if (n == 15) return infokey(world, "m4map16");
		else if (n == 16) return infokey(world, "m4map17");
		else if (n == 17) return infokey(world, "m4map18");
		else if (n == 18) return infokey(world, "m4map19");
		else if (n == 19) return infokey(world, "m4map20");
		else if (n == 20) return infokey(world, "m4map21");
		else if (n == 21) return infokey(world, "m4map22");
		else if (n == 22) return infokey(world, "m4map23");
		else if (n == 23) return infokey(world, "m4map24");
		else if (n == 24) return infokey(world, "m4map25");
		else if (n == 25) return infokey(world, "m4map26");
		else if (n == 26) return infokey(world, "m4map27");
		else if (n == 27) return infokey(world, "m4map28");
		else if (n == 28) return infokey(world, "m4map29");
		else if (n == 29) return infokey(world, "m4map30");
		else if (n == 30) return infokey(world, "m4map31");
		else if (n == 31) return infokey(world, "m4map32");
		else if (n == 32) return infokey(world, "m4map33");
		else if (n == 33) return infokey(world, "m4map34");
		else if (n == 34) return infokey(world, "m4map35");
		else if (n == 35) return infokey(world, "m4map36");
		else if (n == 36) return infokey(world, "m4map37");
		else if (n == 37) return infokey(world, "m4map38");
		else if (n == 38) return infokey(world, "m4map39");
		else if (n == 39) return infokey(world, "m4map40");
		else if (n == 40) return infokey(world, "m4map41");
		else if (n == 41) return infokey(world, "m4map42");
		else if (n == 42) return infokey(world, "m4map43");
		else if (n == 43) return infokey(world, "m4map44");
		else if (n == 44) return infokey(world, "m4map45");
		else if (n == 45) return infokey(world, "m4map46");
		else if (n == 46) return infokey(world, "m4map47");
		else if (n == 47) return infokey(world, "m4map48");
		else if (n == 48) return infokey(world, "m4map49");
		else if (n == 49) return infokey(world, "m4map50");
	}
};

// ***maps*** <--
