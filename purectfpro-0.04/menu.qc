// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterstrφm 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************


/*
1: Main Menu
2: Players Settings
3: Game Settings (4)
4: CTF Settings  (5)
5: DM Settings   (3)
6: Presets (7)
7: tourney presets (6)
8: Server Settings
*/


void() ToggleMenu = {
	if (self.state)
		self.state = 0;
	else if (IsAdmin(self))
		self.state = 1;
	else
		self.state = 2;
};


void() PlayerMenu1 = {
	local string st1, st2, st3, st4, st5, st6, st7, st8;
	if (self.pure & SETINFO_AUTOSHOT) 
		st1 = "Player settings:\n\n1. Αυτο Σθοτ     ON  \n";
	else	st1 = "Player settings:\n\n1. Αυτο Σθοτ     OFF \n";
	if (self.pure & SETINFO_AUTODEMO_PROXY)
		st2 = "2. Αυτο Δενο    Proxy\n";
	else if (self.pure & SETINFO_AUTODEMO_QW)
		st2 = "2. Αυτο Δενο     QW  \n";
	else if (self.pure & SETINFO_AUTODEMO_ALWAYS)
		st2 = "2. Αυτο Δενο   Always\n";
	else	
		st2 = "2. Αυτο Δενο     OFF \n";
	if (self.pure & SETINFO_CPRINT) 
		st3 = "3. Γεξτεςπςιξτ   OFF \n";
	else	st3 = "3. Γεξτεςπςιξτ   ON  \n";
		if ((self.pure & SETINFO_TRACKING) == SETINFO_TRACKING_OFF)
			st4 = "4. ΣπεγτατοςΓαν  OFF \n\n7. Νοςε Σεττιξησ     \n8. Εψιτ τθισ νεξυ    \n\n Το ναλε τθεσε γθαξηεσ πεςναξεξτ αδδ\nsetinfo pure ";
	else if ((self.pure & SETINFO_TRACKING) == SETINFO_TRACKING_CHASE)
		st4 = "4. ΣπεγτατοςΓαν Chase\n\n7. Νοςε Σεττιξησ     \n8. Εψιτ τθισ νεξυ    \n\n Το ναλε τθεσε γθαξηεσ πεςναξεξτ αδδ\nsetinfo pure ";
	else
		st4 = "4. ΣπεγτατοςΓαν Fixed\n\n7. Νοςε Σεττιξησ     \n8. Εψιτ τθισ νεξυ    \n\n Το ναλε τθεσε γθαξηεσ πεςναξεξτ αδδ\nsetinfo pure ";
	st6 = "";
	st7 = ftos(self.pure);
	st8 = " το ωους γοξζιη\n\n";
	centerprint7(self, st1, st2, st3, st4, st5, st7, st8);
};

void() ModeWizard1 = {
	local string st1, st2,st3, st4, st5,st6,st7;
	st1 = "Γονπετιτιοξ Νοδε Wizards\n--------------------------\n1. Πυςε ΓΤΖ Νατγθ         \n";
	st2 = "2. ³Χαφε ΓΤΖ Νατγθ        \n";
	st3 = "3. Τθυξδεςχαμλες Νατγθ    \n";
	st4 = "4. ΔΝ Γονπετιτιοξ         \n";
	st5 = "5. Γμαξ Αςεξα             \n";
	st6 = "6.                        \n";
	st7 = "--------------------------\n7. Σταξδαςδ νοδε Wizards  \n8. Ναιξ Νεξυ              \n--------------------------";
	centerprint7(self, st1, st2,st3,st4,st5,st6,st7);
};

void(float tp, float md, string desc) SetServer = {
	if (CheckModeChange())
		return;
	SetVar(CVARINFO, "teamplay", tp);
	SetVar(SERVERINFO, "mode", md);
	bprint(PRINT_HIGH, "\nChanged to: ");
	bprint(PRINT_HIGH, desc);
	bprint(PRINT_HIGH, "\n\n");
	ChangeMap(mapname);
};

void() ModeWizard1Impulses = {
	if (self.impulse == 1) { 
		SetStandard();
		SetServer(419,1, "Pure CTF Competition");
	} else if (self.impulse == 2) {
		Set3wave();
		SetServer(419,1, "3wave Competition");
	} else if (self.impulse == 3) {
		SetTW();
		SetServer(419,9, "Thunderwalker Competition");
	} else if (self.impulse == 4) {
		SetServer(3,1, "DM Competiton");
	} else if (self.impulse == 5) {
		SetServer(3,3, "Clan Arena");
	} else if (self.impulse == 6) {
		return;
	} else if (self.impulse == 7) {
		self.state = 10;
	} else if (self.impulse == 8) {
		self.state = 1;	
	}	
};

void() ModeWizard2 = {
	local string st1, st2,st3, st4, st5,st6,st7;
	st1 = "Πυβμιγ Νοδε Wizards\n--------------------------\n1. Σταξδαςδ Πυςε ΓΤΖ      \n";
	st2 = "2. Σταξδαςδ ³χαφε ΓΤΖ     \n";
	st3 = "3. Τθυξδεςχαμλες ΓΤΖ      \n";
	st4 = "4. ΖΖΑ ΔΝ                 \n";
	st5 = "5. Αςεξα                  \n";
	st6 = "6.                        \n";
	st7 = "--------------------------\n7. Σεςφες νοδεσ σετυπ     \n8. Ναιξ Νεξυ              \n--------------------------";
	centerprint7(self, st1, st2,st3,st4,st5,st6,st7);
};
void() ModeWizard2Impulses = {
	if (self.impulse == 1) {
		SetStandard();
		SetServer(419,0, "Standard Pure CTF");
	} else if (self.impulse == 2) {
		Set3wave();
		SetServer(419,0, "Standard 3Wave CTF");
	} else if (self.impulse == 3) {
		SetTW();
		SetServer(419,8, "Standard TW");
	} else if (self.impulse == 4) {
		SetServer(0,0, "FFA DM");
	} else if (self.impulse == 5) {
		SetServer(0,2, "Arena");
	} else if (self.impulse == 7) {
		self.state = 8;
	} else if (self.impulse == 8) {
		self.state = 1;		
	}
};



void() Menu = {

	local string st1, st2, st3, st4, st5, st6, st7, st8;

	local float tlim, x, y, z,a,b,c;


	if (self.state == 1) {

		st1 = "Ναιξ Νεξυ\n-------------------\n";
		
		st2 = "1. Πμαωες Σετυπ    \n";
		st3 = "2. Σεςφες νοδεσ    \n";
		st4 = "3. Ηανε Σετυπ      \n";
		st5 = "4. Πςεσετ σεττιξησ \n";
		st6 = "5.                 \n6.                 \n7.                 \n";

		st7 = "-------------------\n8. Εψιτ Νεξυ       \n-------------------\n";


		centerprint7(self, st1, st2, st3, st4, st5, st6, st7);

	} else if (self.state == 2) {
		PlayerMenu1();
	} else if (self.state == 3) {
		if (DEATHMATCH == 1) 	  st1 = "Ηανε Σεττιξησ (±/³)\n-------------------\n1. Δεατθνατγθ :  1 \n2. Τεανπμαω   : ";
		else if (DEATHMATCH == 2) st1 = "Ηανε Σεττιξησ (±/³)\n-------------------\n1. Δεατθνατγθ :  2 \n2. Τεανπμαω   : ";
		else if (DEATHMATCH == 3) st1 = "Ηανε Σεττιξησ (±/³)\n-------------------\n1. Δεατθνατγθ :  3 \n2. Τεανπμαω   : ";
		else if (DEATHMATCH == 4) st1 = "Ηανε Σεττιξησ (±/³)\n-------------------\n1. Δεατθνατγθ :  4 \n2. Τεανπμαω   : ";
		else if (DEATHMATCH == 5) st1 = "Ηανε Σεττιξησ (±/³)\n-------------------\n1. Δεατθνατγθ :  5 \n2. Τεανπμαω   : ";
		else if (DEATHMATCH == 6) st1 = "Ηανε Σεττιξησ (±/³)\n-------------------\n1. Δεατθνατγθ :  6 \n2. Τεανπμαω   : ";

		if (FLAG_CTF) {
			y = GetCTFTP(TEAMPLAY);
			if (y == 3) st5 = " 3 ";
			else if (y == 2) st5 = " 2 ";
			else if (y == 4) st5 = " 4 ";
			else st5 = " ? ";
		} else {
			x = realteamplay & 15;
			if (x == 0) st5 = "---";
			else if (x == 1) st5 = " 1 ";
			else if (x == 2) st5 = " 2 ";
			else if (x == 3) st5 = " 3 ";
			else if (x == 4) st5 = " 4 ";
			else if (x == 5) st5 = " 5 ";
		}

		tlim = TIMELIMIT / 60;

		if ((FRAGLIMIT >= 100) || (FRAGLIMIT == 0)) {
			if (tlim == 0)       st2 = "\n3. ΤΙΝΕΜΙΝΙΤ  : ---\n4. Ζςαημινιτ  :";
			else if (tlim <= 5)  st2 = "\n3. ΤΙΝΕΜΙΝΙΤ  :   5\n4. Ζςαημινιτ  :";
			else if (tlim <= 10) st2 = "\n3. ΤΙΝΕΜΙΝΙΤ  :  10\n4. Ζςαημινιτ  :";
			else if (tlim <= 15) st2 = "\n3. ΤΙΝΕΜΙΝΙΤ  :  15\n4. Ζςαημινιτ  :";
			else if (tlim <= 20) st2 = "\n3. ΤΙΝΕΜΙΝΙΤ  :  20\n4. Ζςαημινιτ  :";
			else if (tlim <= 25) st2 = "\n3. ΤΙΝΕΜΙΝΙΤ  :  25\n4. Ζςαημινιτ  :";
			else if (tlim <= 30) st2 = "\n3. ΤΙΝΕΜΙΝΙΤ  :  30\n4. Ζςαημινιτ  :";
			else if (tlim <= 35) st2 = "\n3. ΤΙΝΕΜΙΝΙΤ  :  35\n4. Ζςαημινιτ  :";
			else if (tlim <= 40) st2 = "\n3. ΤΙΝΕΜΙΝΙΤ  :  40\n4. Ζςαημινιτ  :";
			else if (tlim <= 45) st2 = "\n3. ΤΙΝΕΜΙΝΙΤ  :  45\n4. Ζςαημινιτ  :";
			else if (tlim <= 50) st2 = "\n3. ΤΙΝΕΜΙΝΙΤ  :  50\n4. Ζςαημινιτ  :";
			else st2 = ">50\n3. Ζςαημινιτ:  ";
		} else {
			if (tlim == 0)       st2 = "\n3. ΤΙΝΕΜΙΝΙΤ  : ---\n4. Ζςαημινιτ  : ";
			else if (tlim <= 5)  st2 = "\n3. ΤΙΝΕΜΙΝΙΤ  :   5\n4. Ζςαημινιτ  : ";
			else if (tlim <= 10) st2 = "\n3. ΤΙΝΕΜΙΝΙΤ  :  10\n4. Ζςαημινιτ  : ";
			else if (tlim <= 15) st2 = "\n3. ΤΙΝΕΜΙΝΙΤ  :  15\n4. Ζςαημινιτ  : ";
			else if (tlim <= 20) st2 = "\n3. ΤΙΝΕΜΙΝΙΤ  :  20\n4. Ζςαημινιτ  : ";
			else if (tlim <= 25) st2 = "\n3. ΤΙΝΕΜΙΝΙΤ  :  25\n4. Ζςαημινιτ  : ";
			else if (tlim <= 30) st2 = "\n3. ΤΙΝΕΜΙΝΙΤ  :  30\n4. Ζςαημινιτ  : ";
			else if (tlim <= 35) st2 = "\n3. ΤΙΝΕΜΙΝΙΤ  :  35\n4. Ζςαημινιτ  : ";
			else if (tlim <= 40) st2 = "\n3. ΤΙΝΕΜΙΝΙΤ  :  40\n4. Ζςαημινιτ  : ";
			else if (tlim <= 45) st2 = "\n3. ΤΙΝΕΜΙΝΙΤ  :  45\n4. Ζςαημινιτ  : ";
			else if (tlim <= 50) st2 = "\n3. ΤΙΝΕΜΙΝΙΤ  :  50\n4. Ζςαημινιτ  : ";
			else st2 = ">50\n4. Ζςαημινιτ  : ";
		}

		if (FRAGLIMIT)
			st3 = getnum(FRAGLIMIT);
		else 
			st3 = " ---";


		if (VAR_DISABLEPOWERUPS == 0)      st4 = "\n5. Ποχεςυπσ   : ALL\n6. ΣΦ_Ναψσπεεδ: ";
		else if (VAR_DISABLEPOWERUPS == 1) st4 = "\n5. Ποχεςυπσ   : -RP\n6. ΣΦ_Ναψσπεεδ: ";
		else if (VAR_DISABLEPOWERUPS == 2) st4 = "\n5. Ποχεςυπσ   : Q-P\n6. ΣΦ_Ναψσπεεδ: ";
		else if (VAR_DISABLEPOWERUPS == 3) st4 = "\n5. Ποχεςυπσ   : --P\n6. ΣΦ_Ναψσπεεδ: ";
		else if (VAR_DISABLEPOWERUPS == 4) st4 = "\n5. Ποχεςυπσ   : QR-\n6. ΣΦ_Ναψσπεεδ: ";
		else if (VAR_DISABLEPOWERUPS == 5) st4 = "\n5. Ποχεςυπσ   : -R-\n6. ΣΦ_Ναψσπεεδ: ";
		else if (VAR_DISABLEPOWERUPS == 6) st4 = "\n5. Ποχεςυπσ   : Q--\n6. ΣΦ_Ναψσπεεδ: ";
		else if (VAR_DISABLEPOWERUPS == 7) st4 = "\n5. Ποχεςυπσ   : ---\n6. ΣΦ_Ναψσπεεδ: ";

		if (SV_MAXSPEED <= 320) st6 = "320";
		else if (SV_MAXSPEED <= 360) st6 = "360";
		else if (SV_MAXSPEED <= 375) st6 = "375";
		else  st6 = "400";

		st7 = "\n-------------------\n7. ΓΤΖ Οπτιοξσ     \n8. Ναιξ Νεξυ       \n-------------------";
	

		centerprint7(self, st1, st5, st2, st3, st4, st6, st7);

	} else if (self.state == 4) {
		if (FLAG_TOSSRUNE)
			st1 = "ΓΤΖ Οπτιοξσ (²/³)\n------------------\n1. Τοσσςυξε  : ON \n";
		else
			st1 = "ΓΤΖ Οπτιοξσ (²/³)\n------------------\n1. Τοσσςυξε  : OFF\n";
		if (FLAG_TOSSFLAG)
			st2 = "2. Τοσσζμαη  : ON \n";
		else
			st2 = "2. Τοσσζμαη  : OFF\n";
		if (SET_RUNES == IS_PURE)
			st3 = "3. Òυξεσ     : ON \n";
		else if (SET_RUNES == IS_OFF)
			st3 = "3. Òυξεσ     : OFF\n";
		else if (SET_RUNES == IS_OLD)
			st3 = "3. Òυξεσ     : OLD\n";
		if (SET_HOOK == IS_PURE)
			st4 = "4. Θοολ      : ON \n";
		else if (SET_HOOK == IS_OFF)
			st4 = "4. Θοολ      : OFF\n";
		else if (SET_HOOK == IS_OLD)
			st4 = "4. Θοολ      : OLD\n";
		else if (SET_HOOK == IS_OLDFIX)
			st4 = "4. Θοολ      : 421\n";
		if (DUMMY_ANKAMAPS)
			st5 = "5. Αξλα Ναπσ : ON \n";
		else
			st5 = "5. Αξλα Ναπσ : OFF\n";
		st6 = "6.                \n";


		st7 = "------------------\n7. Νοςε Οπτιοξσ   \n8. Ναιξ Νεξυ      \n------------------";

		centerprint7(self, st1, st2, st3, st4, st5, st6, st7);

	} else if (self.state == 5) {

	
		if (FLAG_AUTOSPECTALK)
			st1 = "Νοςε Οπτιοξσ (³/³)\n---------------------\n1. ΑυτοΣπεγταμλ : ON \n2. ΝΑΨΣΠΕΓΤΑΤΟÒΣ:";
		else
			st1 = "Νοςε Οπτιοξσ (³/³)\n---------------------\n1. ΑυτοΣπεγταμλ : OFF\n2. ΝΑΨΣΠΕΓΤΑΤΟÒΣ:";
		st2 = getnum(MAXSPECS);
		if (FLAG_DROPQUAD) st3 =" \n3. Δςοπρυαδ     : ON \n";
		else st3 =" \n3. Δςοπρυαδ     : OFF\n";
		if (FLAG_DROPRING) st4 ="4. Δςοπςιξη     : ON \n";
		else 	st4 = "4. Δςοπςιξη     : OFF\n";

		if (SET_DISCHARGE == IS_PURE)
			st5 = "5. Δισγθαςηε    : ON \n";
		else if (SET_DISCHARGE== IS_OFF)
			st5 = "5. Δισγθαςηε    : OFF\n";
		else if (SET_DISCHARGE== IS_OLD)
			st5 = "5. Δισγθαςηε    : OLD\n";

		st6 = "6.                   \n";

		st7 = "---------------------\n7. Ηανε Σεττιξησ     \n8. Ναιξ Νεξυ         \n---------------------";
		centerprint7(self, st1, st2, st3, st4, st5, st6, st7);
	} else if (self.state == 6) {

		st1 = "Πςεσετσ\n-------------------\n";
		
		st2 = "1. Σεςφες Δεζαυμτ  \n";
		st3 = "2. Σετ ασ δεζαυμτ  \n";
		st4 = "3. Πυςε Σταξδαςδ   \n";
		st5 = "4. ³χαφε Σταξδαςδ  \n";
		st6 = "5. ²οξ²            \n6.                 \n";

	
		st7 = "-------------------\n7. Τουςξεω πςεσετσ \n8. Ναιξ Νεξυ       \n-------------------";
		centerprint7(self, st1, st2, st3, st4,st5, st6,  st7);

	} else if (self.state == 7) {

		st1 = "Τουςξεω Πςεσετσ\n-------------------\n";
		st2 = "1. Οξγμε           \n";
		st3 = "2. ΓΤΖ ΣΝ          \n";
		st4 = "3.                 \n";
		st5 = "4.                 \n";
		st6 = "5.                 \n6.                 \n";

		st7 = "-------------------\n7. Σταξδαςδ πςεσετσ\n8. Ναιξ Νεξυ       \n-------------------";
		centerprint7(self, st1, st2, st3, st4,st5, st6,  st7);



	} else if (self.state == 8) {


		if (DUMMY_CTF) 		st1 = "Σεςφες Νοδεσ\n--------------------------\n1. Σεςφες Νοδε     :  CTF \n";
		else			st1 = "Σεςφες Νοδεσ\n--------------------------\n1. Σεςφες Νοδε     :  DM  \n";

		x = (DUMMY_MODE & MODE_COMP);
		a = (DUMMY_MODE & MODE_SHOWDOWN);
		y = (DUMMY_MODE & MODE_ARENA);
		z = (DUMMY_MODE & MODE_TW);


		if (y)			st2 = "2. Αςεξα Νοδε      :  ON  \n";
		else			st2 = "2. Αςεξα Νοδε      :  OFF \n";
	
		if (a)			st3 = "3. Γονπετιτιοξ Νοδε: SHOWD\n";
		else if (x)		st3 = "3. Γονπετιτιοξ Νοδε:  ON  \n";
		else 			st3 = "3. Γονπετιτιοξ Νοδε:  OFF \n";
		if (z)			st4 = "4. Τθυξδεςχαμλες   :  ON  \n";
		else 			st4 = "4. Τθυξδεςχαμλες   :  OFF \n";

					st5 = "5.                        \n";
					st6 = "6.                        \n";

		st7 = "--------------------------\n7. Νοδε Σετυπ Wizards     \n8. Ναιξ Νεξυ              \n--------------------------";
		centerprint7(self, st1, st2, st3, st4,st5, st6, st7);

	} else if (self.state == 9) {
		ModeWizard1();
	} else if (self.state == 10) {
		ModeWizard2();
	}

};

void() MenuImpulses = {

	if ((!self.state) || (self.impulse < 1) || (self.impulse > 8)) {
		return;

	} else if (self.state == 1) {
		if (self.impulse == 1)
			self.state = 2;
		else if (self.impulse == 2)
			self.state = 8;
		else if (self.impulse == 3)
			self.state = 3;
		else if (self.impulse == 4)
			self.state = 6;
		else if (self.impulse == 8)
			self.state = 0;
	} else 	if (self.state == 2) {
		if (self.impulse == 1) 
			SetAutoShot();
		else if (self.impulse == 2) 
			SetAutoDemo();
		else if (self.impulse == 3) 
			SwapCenterprint();
		else if (self.impulse == 4)
			CycleSpecTracking();
		else if (self.impulse == 7)
			self.state = 2;
		else if (self.impulse == 8)
			self.state = 1;

	} else 	if (self.state == 3) {
		if (self.impulse == 1)
			ShowdownDM();
		else if (self.impulse == 2)
			ShowdownTP();
		else if (self.impulse == 3)
			ShowdownTimeup();
		else if (self.impulse == 4)
			ShowdownFragsup();
		else if (self.impulse == 5)
			ShowdownPowerup();
		else if (self.impulse == 6)
			ShowdownMaxspeed();
		else if (self.impulse == 7)
			self.state = 4;
		else if (self.impulse == 8)
			self.state = 1;
	} else 	if (self.state == 4) {
		if (self.impulse == 1)
			ShowdownTossRune();
		else if (self.impulse == 2)
			ShowDownTossflag();
		else if (self.impulse == 3)
			ShowdownRunes();
		else if (self.impulse == 4)
			ShowdownGrapple();
		else if (self.impulse == 5)
			ShowDownAnka();
		else if (self.impulse == 7)
			self.state = 5;
		else if (self.impulse == 8)
			self.state = 1;
	} else 	if (self.state == 5) {
		if (self.impulse == 1)
			ShowDownSpectalk();
		else if (self.impulse == 2)
			ShowDownMaxspecs();
		else if (self.impulse == 3)
			ShowdownDropQuad();
		else if (self.impulse == 4)
			ShowdownDropRing();
		else if (self.impulse == 5)
			ShowdownDischarge ();
		else if (self.impulse == 7)
			self.state = 3;
		else if (self.impulse == 8)
			self.state = 1;
	} else if (self.state == 6) {
		if (self.impulse == 1)
			ShowdownDefault();
		else if (self.impulse == 2)
			bprint(PRINT_HIGH, "Not implemented\n"); //*check* fixa!
		else if (self.impulse == 3)
			SetStandard();
		else if (self.impulse == 4)
			Set3wave();
		else if (self.impulse == 5)
			Set2on2();
		else if (self.impulse == 7)
			self.state = 7;
		else if (self.impulse == 8)
			self.state = 1;
	} else if (self.state == 7) {
		if (self.impulse == 1)
			SetOncle();
		else if (self.impulse == 2)
			SetCTFSM();
		else if (self.impulse == 7)
			self.state = 6;
		else if (self.impulse == 8)
			self.state = 1;
	} else if (self.state == 8) {
		if (self.impulse == 1)
			ShowDownCTF();
		else if (self.impulse == 2)
			ShowDownArena();
		else if (self.impulse == 3)
			ShowDownCompetition();
		else if (self.impulse == 4)
			ShowDownTW();
		else if (self.impulse == 7)
			self.state = 9;
		else if (self.impulse == 8)
			self.state = 1;		
	} else if (self.state == 9) {
		ModeWizard1Impulses();
	} else if (self.state == 10) {
		ModeWizard2Impulses();
	}
	self.lastupdate = time - 1;
	self.impulse = 0;
};




// *check*
