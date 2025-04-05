// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterström 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************

// HUMONGOUS function alert. (Ummmm, no easier way for this? :)
// Mapnames snatched from the Gamespy mapdata.txt http://www.gamespy.com/

string(string shortname) FindMap = {


	// Shareware Quake
	// http://www.idsoftware.com/

	if (shortname == "start") return "Introduction";
	else if (shortname == "e1m1") return "Slipgate Complex";
	else if (shortname == "e1m2") return "Castle Of The Damned";
	else if (shortname == "e1m3") return "The Necropolis";
	else if (shortname == "e1m4") return "The Grisly Grotto";
	else if (shortname == "e1m5") return "Gloom Keep";
	else if (shortname == "e1m6") return "The Door To Chthon";
	else if (shortname == "e1m7") return "The House Of Chthon";
	else if (shortname == "e1m8") return "Ziggurat Vertigo";

	// Registered Quake
	// http://www.idsoftware.com/

	else if (shortname == "e2m1") return "The Installation";
	else if (shortname == "e2m2") return "The Ogre Citadel";
	else if (shortname == "e2m3") return "The Crypt Of Decay";
	else if (shortname == "e2m4") return "The Ebon Fortress";
	else if (shortname == "e2m5") return "The Wizard's Manse";
	else if (shortname == "e2m6") return "The Dismal Oubliette";
	else if (shortname == "e2m7") return "Underearth";
	else if (shortname == "e3m1") return "Termination Central";
	else if (shortname == "e3m2") return "The Vaults Of Zin";
	else if (shortname == "e3m3") return "The Tomb Of Terror";
	else if (shortname == "e3m4") return "Satan's Dark Delight";
	else if (shortname == "e3m5") return "Wind Tunnels";
	else if (shortname == "e3m6") return "Chambers Of Torment";
	else if (shortname == "e3m7") return "The Haunted Halls";
	else if (shortname == "e4m1") return "The Sewage System";
	else if (shortname == "e4m2") return "The Tower Of Despair";
	else if (shortname == "e4m3") return "The Elder God Shrine";
	else if (shortname == "e4m4") return "The Palace Of Hate";
	else if (shortname == "e4m5") return "Hell's Atrium";
	else if (shortname == "e4m6") return "The Pain Maze";
	else if (shortname == "e4m7") return "Azure Agony";
	else if (shortname == "e4m8") return "The Nameless City";
	else if (shortname == "end") return "Shub-Niggurath's Pit";
	else if (shortname == "dm1") return "Place Of Two Deaths";
	else if (shortname == "dm2") return "Claustrophobopolis";
	else if (shortname == "dm3") return "The Abandoned Base";
	else if (shortname == "dm4") return "The Bad Place";
	else if (shortname == "dm5") return "The Cistern";
	else if (shortname == "dm6") return "The Dark Zone";
	else if (shortname == "dm7") return "Aracnophobia";

	// Threewave CTF
	// http://threewave.planetquake.com/

	else if (shortname == "ctfstart") return "CTF Introduction";
	else if (shortname == "ctf1") return "McKinley Base";
	else if (shortname == "ctf2") return "The Kiln";
	else if (shortname == "ctf3") return "Dysphoria";
	else if (shortname == "ctf4") return "The Forgotten Mines";
	else if (shortname == "ctf5") return "Da Ancient War Grounds";
	else if (shortname == "ctf6") return "Vertigo";
	else if (shortname == "ctf7") return "Tale Of Two Cities";
	else if (shortname == "ctf8") return "The Strongbox";
	else if (shortname == "ctf2m1") return "McKinley Station";
	else if (shortname == "ctf2m2") return "The Warzone";
	else if (shortname == "ctf2m3") return "Spill the Blood";
	else if (shortname == "ctf2m4") return "The Ruins Of NeoMinonk";
	else if (shortname == "ctf2m5") return "Disciple War Grounds";
	else if (shortname == "ctf2m6") return "The Two Towers";
	else if (shortname == "ctf2m7") return "Gloom Castles";
	else if (shortname == "ctf2m8") return "Capturephobopolis";

	// ThunderWalker CTF
	// http://www.planetquake.com/thunderwalker/

	else if (shortname == "twstart") return "TWCTF Start";
	else if (shortname == "twctf1") return "The Cheat Complex";
	else if (shortname == "twctf2") return "WarZ";
	else if (shortname == "twctf3") return "The Crown of Ares";
	else if (shortname == "twctf4") return "Gadianton";
	else if (shortname == "twctf6") return "The UnderWorld";
	else if (shortname == "twctf7") return "Tony CTF III Xpanded";
	else if (shortname == "twctf8") return "Washout";
	else if (shortname == "twctf9") return "Critters";
	else if (shortname == "twctf2m1") return "Bi-Phase";
	else if (shortname == "twctf2m2") return "TombstonE";
	else if (shortname == "twctf2m3") return "Outpost";
	else if (shortname == "twctf2m4") return "Pandemonium";
	else if (shortname == "twctf2m5") return "The Final Ascent";
	else if (shortname == "twctf2m6") return "The Realm Of Cloy";
	else if (shortname == "twctf2m7") return "Test For Echo";
	else if (shortname == "twctf2m8") return "The Unknown Facility";
	else if (shortname == "twctf2m9") return "Twin Keeps";
	else if (shortname == "twctf2ma") return "King's Of Capture";
	else if (shortname == "twctf2mb") return "A P100's Revenge";
	else if (shortname == "twctf2mc") return "Fishface";

	// CTF Expansion Project
	// http://www.frag.com/ctf/

	else if (shortname == "ctf1bsp0") return "Capturellamaphobopolis";
	else if (shortname == "ctf1bsp1") return "Holy Warez";
	else if (shortname == "ctf1bsp2") return "The Tormented Fortress";
	else if (shortname == "ctf1bsp3") return "The Banzoia";
	else if (shortname == "ctf1bsp4") return "Barbie's Domain";
	else if (shortname == "ctf1bsp5") return "Capture Castles";
	else if (shortname == "ctf1bsp6") return "Tickle-Me Shambler";
	else if (shortname == "ctf1bsp7") return "Never Mined";
	else if (shortname == "ctf1bsp8") return "The Forgotten Outpost";
	else if (shortname == "ctf1bsp9") return "Towers: The Ascension";
	else if (shortname == "ctf1bspx") return "Salvage The Weak";

	// AllStar CTF
	// http://www.planetquake.com/academy/allstar/allstar.htm

	else if (shortname == "allstart") return "AllStar CTF";
	else if (shortname == "xeno1") return "MidEvil CTF";
	else if (shortname == "xeno2") return "Sadness Of Death";
	else if (shortname == "xeno3") return "Dusinane";
	else if (shortname == "xeno4") return "Armageddon 3 CTF";
	else if (shortname == "xeno5") return "Nicole's Vitrue";
	else if (shortname == "xeno6") return "Mayan Existance";
	else if (shortname == "xeno7") return "Remix";
	else if (shortname == "xeno8") return "Xeno Flag Academy";
	else if (shortname == "expctf1") return "Expert CTF";
	else if (shortname == "expctf2") return "Expert Base";

	// Leage of capture 
	// http://loc.gamesnet.net

	else if (shortname == "ctf3m1")  return "Remix";
	else if (shortname == "ctf3m2")  return "Red Alert";
	else if (shortname == "ctf3m3")  return "Stop the Flow";
	else if (shortname == "ctf3m4")  return "Nameless Mines";
	else if (shortname == "ctf3m5")  return "Egyptian Pig Factory";
	else if (shortname == "ctf3m6")  return "Terra Firma";
	else if (shortname == "ctf3m7")  return "The Dark Age";
	else if (shortname == "ctf3m8")  return "The Place of Two Bases";
	else if (shortname == "ctf3m9")  return "The CHEAT Complex 2: Barkfalls";

	// PCP HrZ - At the constant nagging by yokozuna, i've added his mapnames :P
	else if (shortname == "e2m1pro") return "The Prostallation";
	else if (shortname == "e4m3pro") return "The Quad God Shrine";
	// PCP dyna - More maps
	else if (shortname == "capit") return "Cap it!";
	// PCP //


	// *check* The ctf3 maps

	return mapname;		// AAAARGH, you've found ANOTHER stupid map????

};