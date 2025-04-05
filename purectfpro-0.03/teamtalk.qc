// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" ZetterstrЖm 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************

// =================
//     CONSTANTS
// =================

// =================
//     VARIABLES
// =================

entity NEAREST;
float NCOUNT;
float NLEN;

// =================
//      FIELDS  
// =================

.float lastmess;		// *check*

// =================
//     FUNCTIONS
// =================

// ===== Playeroption to enable/disable team audio =====
void(entity pl) SwapAudio = {
	if (pl.pure & SETINFO_NOTEAMSOUNDS) {
		pl.pure = pl.pure - (pl.pure & (SETINFO_NOTEAMSOUNDS));
		sprint(self, PRINT_HIGH, "Teamaudio on.\n");
	} else {
		pl.pure = pl.pure | (SETINFO_NOTEAMSOUNDS);
		sprint(self, PRINT_HIGH, "Teamaudio off.\n");
	}
	SetPureFlags(self);
	PrintNewPlayerSettings();
};

float(entity pl) AllowAudio = {
	return (!(pl.pure & SETINFO_NOTEAMSOUNDS));
};


void(entity pl, string snd) TeamSound = {
	local entity e;
	e = PLAYER_CHAIN;
	while (e) {
		if (SameTeam(pl, e, world) && AllowAudio(self)) {
			stuffcmd(e, "play team/");
			stuffcmd(e, snd);
			stuffcmd(e, "\n");
		}
		e = e.clientchain;
	}
};


void() PrintPowerups = {
	if (self.items & IT_QUAD) {
		stuffcmd(self, " [QUAD");
		if (self.items & IT_INVISIBILITY) 
			stuffcmd(self, "|RING");
		if (self.items & IT_INVULNERABILITY) 
			stuffcmd(self, "|666");
		stuffcmd(self, "]");
	} else if (self.items & IT_INVISIBILITY) {
		stuffcmd(self, " [RING");
		if (self.items & IT_INVULNERABILITY) 
			stuffcmd(self, "|666");
		stuffcmd(self, "]");
	} else if (self.items & IT_INVULNERABILITY) 
		stuffcmd(self, " [666]");
		
};


void(string cln) LookForClass = {
	local entity e;
	local float a, c;
	c = 0;
	e = find(world, classname, cln);
	while (e) {
		c = c + 1;
		a = vlen(self.origin - e.origin);
		if (a < NLEN) {	
			NEAREST = e;
			NCOUNT = c;	
			NLEN = a;
		}
		e = find(e, classname, cln);
	}
};


void() PrintLoc = {
	local string tp;
	local entity e;

	NEAREST = world;
	NCOUNT = 1;
	NLEN = 100000000;

	LookForClass("item_flag_team1");
	LookForClass("item_flag_team2");
	LookForClass("item_artifact_invulnerability");
	LookForClass("item_artifact_invisibility");
	LookForClass("item_artifact_super_damage");
	LookForClass("item_armor2");
	LookForClass("item_armorInv");

	e = NEAREST;
	
	if (e.classname == "item_flag_team1")
		tp = "Red Base";
	else if (e.classname == "item_flag_team2")
		tp = "Blue Base";
	else if (e.classname == "item_artifact_invulnerability")
		tp = "Penta";
	else if (e.classname == "item_artifact_invisibility")
		tp = "Ring";
	else if (e.classname == "item_artifact_super_damage")
		tp = "Quad";
	else if (e.classname == "item_armor2")
		tp = "150A";
	else if (e.classname == "item_armorInv")
		tp = "200A";
	else tp = "Someplace";
	
	stuffcmd(self, tp);
	if (NCOUNT > 1) {
		stuffcmd(self, " ");
		tp = ftos(NCOUNT);
		stuffcmd(self, tp);
	}
};



void() CheckSound = {
	if (time < self.lastmess)
		return;
	if (FLAG_NOCUSTOMAUDIO)
		return;

	//return;		// *check* Disabled until furter notice :)

	if ( "" != infokey(self, "s")) {
		TeamSound(self, infokey(self, "s"));		
		unsetinfo(self, "s");
		self.lastmess = time + 2;
	}
	if ( "" != infokey(self, "m")) {
		stuffcmd(self, "say_team ");
		stuffcmd(self, infokey(self, "m"));
		stuffcmd(self, " ");
		PrintLoc();
		PrintPowerups();
		stuffcmd(self, "\n");
		unsetinfo(self, "m");
		self.lastmess = time + 2;
	}
};

void() ReportStatus = {
	local string tp;
	local float it;	

	if (FLAG_NOREPORT)
		return;

	stuffcmd(self, "say_team ");
	if (self.armortype) {
		if (self.armortype == 0.8)
			stuffcmd(self, "RA:");
		if (self.armortype == 0.6)
			stuffcmd(self, "YA:");
		if (self.armortype == 0.3)
			stuffcmd(self, "GA:");
		tp=ftos(self.armorvalue);
		stuffcmd(self, tp);
	}
	stuffcmd(self, " H:");
	tp=ftos(self.health);
	stuffcmd(self, tp);


	it = self.items;

	if (self.ammo_rockets >= 1 && (it & IT_ROCKET_LAUNCHER) ) {
		stuffcmd(self, " RL:");
		tp = ftos(self.ammo_rockets);
		stuffcmd(self, tp);
	} else if (self.ammo_cells >= 1 && (it & IT_LIGHTNING) ) {
		stuffcmd(self, " LG:");
		tp = ftos(self.ammo_cells);
		stuffcmd(self, tp);
	} else if(self.ammo_rockets >= 1 && (it & IT_GRENADE_LAUNCHER) ){
		stuffcmd(self, " GL:");
		tp = ftos(self.ammo_rockets);
		stuffcmd(self, tp);
	} else if(self.ammo_nails >= 2 && (it & IT_SUPER_NAILGUN) ){
		stuffcmd(self, " SNG:");
		tp = ftos(self.ammo_nails);
		stuffcmd(self, tp);
	} else if(self.ammo_shells >= 2 && (it & IT_SUPER_SHOTGUN) ){
		stuffcmd(self, " SSG:");
		tp = ftos(self.ammo_shells);
		stuffcmd(self, tp);
	} else if(self.ammo_nails >= 1 && (it & IT_NAILGUN) ){
		stuffcmd(self, " NG:");
		tp = ftos(self.ammo_nails);
		stuffcmd(self, tp);
	} else if(self.ammo_shells >= 1 && (it & IT_SHOTGUN)  ) {
		stuffcmd(self, " SG:");
		tp = ftos(self.ammo_shells);
		stuffcmd(self, tp);
	} else {
		stuffcmd(self, " AXE");
	}
	tp = GetInventoryString(self);
	stuffcmd(self, tp);		


	stuffcmd(self, "\n");

};

void() TeamTalkImpulses = {
	if (self.impulse == 130) {
		stuffcmd(self, "say_team Enemy Quad at "); 
		PrintLoc();
		stuffcmd(self, "!\n"); 
	} else 	if (self.impulse == 131) {
		stuffcmd(self, "say_team Enemy Penta at "); 
		PrintLoc();
		stuffcmd(self, "!\n"); 
	} else 	if (self.impulse == 132) {
		stuffcmd(self, "say_team Enemy incoming at "); 
		PrintLoc();
		stuffcmd(self, "!\n"); 
	} else 	if (self.impulse == 133) {
		stuffcmd(self, "say_team I have the flag at "); 
		PrintLoc();
		stuffcmd(self, "!\n"); 
	} else 	if (self.impulse == 134) {
		stuffcmd(self, "say_team Rune at "); 
		PrintLoc();
		stuffcmd(self, "!\n"); 
	} else 	if (self.impulse == 135) {
		stuffcmd(self, "say_team Holding "); 
		PrintLoc();
		PrintPowerups();
		stuffcmd(self, "!\n"); 
	} else 	if (self.impulse == 136) {
		stuffcmd(self, "say_team Taking "); 
		PrintLoc();
		stuffcmd(self, "!\n"); 
	} else 	if (self.impulse == 137) {
		stuffcmd(self, "say_team Attacking via "); 
		PrintLoc();
		PrintPowerups();
		stuffcmd(self, "!\n"); 
	} else 	if (self.impulse == 138) {
		stuffcmd(self, "say_team Waiting at "); 
		PrintLoc();
		PrintPowerups();
		stuffcmd(self, "!\n"); 
	} else 	if (self.impulse == 139) {
		stuffcmd(self, "say_team Enemy carrier at "); 
		PrintLoc();
		stuffcmd(self, "!\n"); 
	}

};


//
// Plays a sound to all players in the same team.
//
void(entity pl, string snd) PureTeamSound = {
	local entity e;
	if (pl.lastmess > time)
		return;
	pl.lastmess = time + AUDIOLIMIT;
	e = PLAYER_CHAIN;
	while (e) {
		if (SameTeam(pl, e, world) && AllowAudio(self)) {
			stuffcmd(e, "play ");
			stuffcmd(e, snd);
			stuffcmd(e, "\n");
		}
		e = e.clientchain;
	}
};


//
// Pure TeamAudio - plays a lot of custom sounds in sound/pureteam
//
void() AudioImpulses = {
	if (FLAG_DEBUG) sprintnum(self, "Playing teamsound:", self.impulse);

	if (self.lastmess > time) {
		return;
	} else 	if (FLAG_NOPUREAUDIO) {
		return;
	} else if (self.impulse == 101) {
		PureTeamSound(self, "pureteam/ok");
	} else if (self.impulse == 102) {
		PureTeamSound(self, "pureteam/yes");
	} else if (self.impulse == 103) {
		PureTeamSound(self, "pureteam/no");


	} else if (self.impulse == 104) {
		PureTeamSound(self, "pureteam/attack");
	} else if (self.impulse == 105) {
		PureTeamSound(self, "pureteam/waiting");
	} else if (self.impulse == 106) {
		PureTeamSound(self, "pureteam/gotnme");
	} else if (self.impulse == 107) {
		PureTeamSound(self, "pureteam/bleed");
	} else if (self.impulse == 108) {
		PureTeamSound(self, "pureteam/baselost");
	} else if (self.impulse == 110) {
		PureTeamSound(self, "pureteam/bclear");
	} else if (self.impulse == 109) {
		PureTeamSound(self, "pureteam/baseweak");
	} else if (self.impulse == 111) {
		PureTeamSound(self, "pureteam/bstatus");
	} else if (self.impulse == 112) {
		PureTeamSound(self, "pureteam/incoming");
	} else if (self.impulse == 113) {
		PureTeamSound(self, "pureteam/penta");
	} else if (self.impulse == 114) {
		PureTeamSound(self, "pureteam/quad");
	} else if (self.impulse == 115) {
		PureTeamSound(self, "pureteam/carrier");
	} else if (self.impulse == 116) {
		PureTeamSound(self, "pureteam/escort");
	} else if (self.impulse == 117) {
		PureTeamSound(self, "pureteam/coming");
	} else if (self.impulse == 118) {
		PureTeamSound(self, "pureteam/wantsome");
	} else if (self.impulse == 119) {
		PureTeamSound(self, "pureteam/gotstuff");
	} else if (self.impulse == 120) {
		PureTeamSound(self, "pureteam/custom1");
	} else if (self.impulse == 121) {
		PureTeamSound(self, "pureteam/custom2");
	} else if (self.impulse == 122) {
		PureTeamSound(self, "pureteam/custom3");
	} else if (self.impulse == 123) {
		PureTeamSound(self, "pureteam/custom4");
	} else if (self.impulse == 124) {
		PureTeamSound(self, "pureteam/custom5");
	}
};



// 
// Expert CTF Teamaudio
// Taken from Expert CTF http://www.planetquake.com/expert/ 
//

float TEAM_SHORT_RANGE_RADIO_RADIUS =		400;


	// Global sounds (to team) Ж161-164ч
	// 	"Is base secure?" - query for base status
	// 	"Base is clear" - base clear for carrier
	// 	"Base under attack" - base not clear for carrier
	// 	"Our base is overrun" - indicates teammates should return to secure the base

	// Local sounds (to anyone near) Ж165-168ч
	// 	Gather for attack
	// 	Attack now
	// 	Incoming
	// 	Cover me *

/*
==================================
SendTeamAudio

Function to play specified Team Audio
==================================
*/
void(entity sender, float audnum) SendTeamAudio =
{
	local string audiofile, audiostring;
	local float localsound;
	local entity audioto;

	if (audnum >= 161 && audnum <= 164) {
		// Global sounds (to team) Ж161-164ч
		if (sender.lastmess < time) {
			sender.lastmess = time + AUDIOLIMIT;
			localsound = 0;
		} else {
			// repeated sound too quickly
			return;
		}
		if (audnum == 161) {
			audiostring = "IS BASE CLEAR?";
			audiofile = "speech/tgstatus.wav";
		} else if (audnum == 162) {
			audiostring = "BASE CLEAR";
			audiofile = "speech/tgclear.wav";
		} else if (audnum == 163) {
			audiofile = "speech/tgattack.wav";
			audiostring = "BASE NOT CLEAR";
		} else if (audnum == 164) {
			audiostring = "BASE OVERRUN";
			audiofile = "speech/tgdown.wav";
		}

		// play the sound
		audioto = find(world, classname, "player");

		while (audioto != world) 
		{	
			if (SameTeam(audioto, sender, world)) {
				stuffcmd(audioto, "play ");
				stuffcmd(audioto, audiofile);
				stuffcmd(audioto, "\n");
				// "TEAM RADIO FROM"
				sprint(audioto, PRINT_HIGH, "теам радио фром: ");
				sprint(audioto, PRINT_HIGH, sender.netname);
				sprint(audioto, PRINT_HIGH, "\n");
				sprint(audioto, PRINT_HIGH, audiostring);
				sprint(audioto, PRINT_HIGH, "\n");
			}
			audioto = find(audioto, classname, "player");
		}
	} else if (audnum >= 165 && audnum <= 168) {
		// Local sounds (to anyone near) Ж165-168ч
		if (sender.lastmess < time) {
			sender.lastmess = time + AUDIOLIMIT;
			localsound = 1;
		} else {
			// repeated sound too quickly
			return;
		} 
		if (audnum == 165) {
			audiofile = "speech/tlgath_a.wav";
			audiostring = "GATHER FOR ATTACK";
		} else if (audnum == 166) {
			audiofile = "speech/tlattk_a.wav";
			audiostring = "ATTACK NOW!!";
		} else if (audnum == 167) {
			audiofile = "speech/tlincm_a.wav";
			audiostring = "INCOMING!!";
		} else if (audnum == 168) {
			audiofile = "speech/tlcovr_b.wav";
			audiostring = "COVER ME!";
		}

		// play the sound
		local string localradio;

		localradio = infokey(world, "localradiooff");
		
		// If localradiooff is not set, local messages are canned to teammates in the area.  Otherwise,
		// local messages are shouted like normal sound effects, hearable by everyone in the area.

		if (localradio == "" || localradio == "0") {
			// find teammates within short range radio radius
			audioto = findradius(sender.origin, TEAM_SHORT_RANGE_RADIO_RADIUS);
			while (audioto) 
			{
				if ((audioto.classname == "player") && 
					SameTeam(audioto, sender, world)) {
					// "SHORT RANGE RADIO FROM"
					sprint(audioto, PRINT_HIGH, "схорт ранге радио фром: ");
					sprint(audioto, PRINT_HIGH, sender.netname);
					sprint(audioto, PRINT_HIGH, "\n");
					sprint(audioto, PRINT_HIGH, audiostring);
					sprint(audioto, PRINT_HIGH, "\n");
					stuffcmd(audioto, "play ");
					stuffcmd(audioto, audiofile);
					stuffcmd(audioto, "\n");
				}
				audioto = audioto.chain;
			}
		} else {
			sound (sender, CHAN_VOICE, audiofile, 1, ATTN_NORM);
		}
	}

};
//
// <-- Expert Teamaudio
//


void() ExpertSounds = {
	SendTeamAudio(self, self.impulse);
};




// <-- check
