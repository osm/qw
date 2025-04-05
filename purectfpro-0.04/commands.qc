// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterstrφm 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************

// check -->

void () DeclineSpec;
void () AcceptSpec;
void () JoinGame;
void() ToggleFreeze;
void() PrintModels;
void() MoreClientImpulses;


void() PrintCommands = {
	sprint(self, PRINT_HIGH, "-----------------------------------\n");
	tagline();
	sprint(self, PRINT_HIGH, "---- Impulses and Commands --------\n");
/* *check* obsolete?
	sprint(self, PRINT_HIGH, " 20 tossweapon : Throw weapon\n");
	sprint(self, PRINT_HIGH, " 21 tossammo   : Throw ammo\n");
*/
	if (FLAG_TOSSRUNE)
		sprint(self, PRINT_HIGH, "τοσσςυξε   : Τθςοχ ςυξε\n");
	if (FLAG_TOSSFLAG)
		sprint(self, PRINT_HIGH, "τοσσζμαη   : Τθςοχ ζμαη\n");
	if (!FLAG_DISABLEIMPULSES) {
		sprint(self, PRINT_HIGH, "ινπ µ°     : Βεστ ξοξεψπ® χεαποξ®\n");
		sprint(self, PRINT_HIGH, "ινπ µ±     : Βεστ εψπ® χεαποξ®\n");
	}
	sprint(self, PRINT_HIGH, "σεττιξησ   : Σθοχ Σεςφες Σεττιξησ\n");
	sprint(self, PRINT_HIGH, "νοδεμσ     : σθοχ πμαωες νοδεμσ\n");
	sprint(self, PRINT_HIGH, "σγοςεσ     : σθοχ σγοςεσ\n");
	sprint(self, PRINT_HIGH, "γπςιξτ     : τοηημε γεξτεςπςιξτ\n");
	if (!FLAG_COMPETITION) {
		sprint(self, PRINT_HIGH, "ναπρυευε   : σθοχ ναπρυευε\n");
	}
	if (FLAG_COMPETITION) {
		sprint(self, PRINT_HIGH, "αυτοσθοτ   : αυτο σγςεεξσθοτ\n");
		sprint(self, PRINT_HIGH, "αυτοδενο   : αυτο δενοσ\n");
	}

	if (FLAG_VOTEEXIT)
		sprint(self, PRINT_HIGH, "φοτεεψιτ   : Φοτε το εψιτ τθε ναπ\n");
	if (FLAG_ADMINVOTE)
		sprint(self, PRINT_HIGH, "αδνιξ      : Αδνιξφοτε\n");
	sprint(self, PRINT_HIGH, "συπες      : Βεγονε συπες αδνιξ\n");
	sprint(self, PRINT_HIGH, "στατσ      : ηανεστατσ\n");
	sprint(self, PRINT_HIGH, "πιξη       : πιξη & ςατε\n");
	sprint(self, PRINT_HIGH, "συπες      : Βεγονε συπες αδνιξ\n");

	if (FLAG_COMPETITION) {
		CompetitionHelpCommands();
	}
	sprint(self, PRINT_HIGH, "---- Help texts -------------------\n");
	// *impulse*
	sprint(self, PRINT_HIGH, "γονναξδσ   : σθοχ τθισ θεμπ\n");
	if (IsAdmin(self) || FLAG_SHOWDOWN) {
		sprint(self, PRINT_HIGH, "σθοχθεμπ   : ΓΤΖ Σθοχδοχξ θεμπ\n");
		sprint(self, PRINT_HIGH, "θεμπσετ    : Πςεσετ σεττιξησ\n");
	}
	sprint(self, PRINT_HIGH, "στατθεμπ   : Στατυσβας γονναξδσ\n");

	if (IsAdmin(self)) {
		AdminHelpCommands();
	}

	if (self.classname == "spectator")
		SpectatorCommands();

	sprint(self, PRINT_HIGH, "-----------------------------------\n");
};

void() StatHelp = {
	sprint(self, PRINT_HIGH, "--- Statusbar Commands -------------\n");
	sprint(self, PRINT_HIGH, " ινπ ·°    : Στατυσβας ΟΖΖ\n");
	sprint(self, PRINT_HIGH, " ινπ ·°-Έ± : Σατ στατυσβας ποσ\n");
	sprint(self, PRINT_HIGH, "στατθυδ    : Στατυσβας γονναξδσ\n");
	sprint(self, PRINT_HIGH, "σταταυτοιδ : Στατυσβας γονναξδσ\n");
	sprint(self, PRINT_HIGH, "στατχεαποξ : Στατυσβας γονναξδσ\n");
	sprint(self, PRINT_HIGH, "σταττινε   : Στατυσβας γονναξδσ\n");
	sprint(self, PRINT_HIGH, "στατσγοςε  : Στατυσβας γονναξδσ\n");
	sprint(self, PRINT_HIGH, "στατςυξε   : Στατυσβας γονναξδσ\n");
	sprint(self, PRINT_HIGH, "-----------------------------------\n");
};


void() Stuff_Maps1 = {
	stuffcmd(self, "alias pre_mp \"impulse 97;wait\"\n");
	stuffcmd(self, "alias end \"pre_mp;impulse 102\"\n");
	// E1
	stuffcmd(self, "alias e1m1 \"pre_mp;impulse 103\"\n");
	stuffcmd(self, "alias e1m2 \"pre_mp;impulse 104\"\n");
	stuffcmd(self, "alias e1m3 \"pre_mp;impulse 105\"\n");
	stuffcmd(self, "alias e1m4 \"pre_mp;impulse 106\"\n");
	stuffcmd(self, "alias e1m5 \"pre_mp;impulse 107\"\n");
	stuffcmd(self, "alias e1m6 \"pre_mp;impulse 108\"\n");
	stuffcmd(self, "alias e1m7 \"pre_mp;impulse 109\"\n");
	stuffcmd(self, "alias e1m8 \"pre_mp;impulse 110\"\n");
	// E2
	stuffcmd(self, "alias e2m1 \"pre_mp;impulse 111\"\n");
	stuffcmd(self, "alias e2m2 \"pre_mp;impulse 112\"\n");
	stuffcmd(self, "alias e2m3 \"pre_mp;impulse 113\"\n");
	stuffcmd(self, "alias e2m4 \"pre_mp;impulse 114\"\n");
	stuffcmd(self, "alias e2m5 \"pre_mp;impulse 115\"\n");
	stuffcmd(self, "alias e2m6 \"pre_mp;impulse 116\"\n");
	stuffcmd(self, "alias e2m7 \"pre_mp;impulse 117\"\n");
	// E3
	stuffcmd(self, "alias e3m1 \"pre_mp;impulse 118\"\n");
	stuffcmd(self, "alias e3m2 \"pre_mp;impulse 119\"\n");
	stuffcmd(self, "alias e3m3 \"pre_mp;impulse 120\"\n");
	stuffcmd(self, "alias e3m4 \"pre_mp;impulse 121\"\n");
	stuffcmd(self, "alias e3m5 \"pre_mp;impulse 122\"\n");
	stuffcmd(self, "alias e3m6 \"pre_mp;impulse 123\"\n");
	stuffcmd(self, "alias e3m7 \"pre_mp;impulse 124\"\n");
	// E4
	stuffcmd(self, "alias e4m1 \"pre_mp;impulse 125\"\n");
	stuffcmd(self, "alias e4m2 \"pre_mp;impulse 126\"\n");
	stuffcmd(self, "alias e4m3 \"pre_mp;impulse 127\"\n");
	stuffcmd(self, "alias e4m4 \"pre_mp;impulse 128\"\n");
	stuffcmd(self, "alias e4m5 \"pre_mp;impulse 129\"\n");
	stuffcmd(self, "alias e4m6 \"pre_mp;impulse 130\"\n");
	stuffcmd(self, "alias e4m7 \"pre_mp;impulse 131\"\n");
	stuffcmd(self, "alias e4m8 \"pre_mp;impulse 132\"\n");
	// DM
	stuffcmd(self, "alias dm1 \"pre_mp;impulse 133\"\n");
	stuffcmd(self, "alias dm2 \"pre_mp;impulse 134\"\n");
	stuffcmd(self, "alias dm3 \"pre_mp;impulse 135\"\n");
	stuffcmd(self, "alias dm4 \"pre_mp;impulse 136\"\n");
	stuffcmd(self, "alias dm5 \"pre_mp;impulse 137\"\n");
	stuffcmd(self, "alias dm6 \"pre_mp;impulse 138\"\n");
	stuffcmd(self, "alias dm7 \"pre_mp;impulse 139\"\n");
	// CTF
	stuffcmd(self, "alias ctf1 \"pre_mp;impulse 140\"\n");
	stuffcmd(self, "alias ctf2 \"pre_mp;impulse 141\"\n");
	stuffcmd(self, "alias ctf3 \"pre_mp;impulse 142\"\n");
	stuffcmd(self, "alias ctf4 \"pre_mp;impulse 143\"\n");
	stuffcmd(self, "alias ctf5 \"pre_mp;impulse 144\"\n");
	stuffcmd(self, "alias ctf6 \"pre_mp;impulse 145\"\n");
	stuffcmd(self, "alias ctf7 \"pre_mp;impulse 146\"\n");
	stuffcmd(self, "alias ctf8 \"pre_mp;impulse 147\"\n");

};

void() Stuff_Maps2 = {
	// CTF2
	stuffcmd(self, "alias ctfstart \"pre_mp;impulse 208\"\n");
	stuffcmd(self, "alias ctf2m1 \"pre_mp;impulse 148\"\n");
	stuffcmd(self, "alias ctf2m2 \"pre_mp;impulse 149\"\n");
	stuffcmd(self, "alias ctf2m3 \"pre_mp;impulse 150\"\n");
	stuffcmd(self, "alias ctf2m4 \"pre_mp;impulse 151\"\n");
	stuffcmd(self, "alias ctf2m5 \"pre_mp;impulse 152\"\n");
	stuffcmd(self, "alias ctf2m6 \"pre_mp;impulse 153\"\n");
	stuffcmd(self, "alias ctf2m7 \"pre_mp;impulse 154\"\n");
	stuffcmd(self, "alias ctf2m8 \"pre_mp;impulse 155\"\n");
	// CTF3
	stuffcmd(self, "alias ctf3m1 \"pre_mp;impulse 156\"\n");
	stuffcmd(self, "alias ctf3m2 \"pre_mp;impulse 157\"\n");
	stuffcmd(self, "alias ctf3m3 \"pre_mp;impulse 158\"\n");
	stuffcmd(self, "alias ctf3m4 \"pre_mp;impulse 159\"\n");
	stuffcmd(self, "alias ctf3m5 \"pre_mp;impulse 160\"\n");
	stuffcmd(self, "alias ctf3m6 \"pre_mp;impulse 161\"\n");
	stuffcmd(self, "alias ctf3m7 \"pre_mp;impulse 162\"\n");
	stuffcmd(self, "alias ctf3m8 \"pre_mp;impulse 163\"\n");
	stuffcmd(self, "alias ctf3m9 \"pre_mp;impulse 164\"\n");
	// twctf1
	stuffcmd(self, "alias twstart \"pre_mp;impulse 165\"\n");
	stuffcmd(self, "alias twctf1 \"pre_mp;impulse 166\"\n");
	stuffcmd(self, "alias twctf2 \"pre_mp;impulse 167\"\n");
	stuffcmd(self, "alias twctf3 \"pre_mp;impulse 168\"\n");
	stuffcmd(self, "alias twctf4 \"pre_mp;impulse 169\"\n");
	stuffcmd(self, "alias twctf5 \"pre_mp;impulse 170\"\n");
	stuffcmd(self, "alias twctf6 \"pre_mp;impulse 171\"\n");
	stuffcmd(self, "alias twctf7 \"pre_mp;impulse 172\"\n");
	stuffcmd(self, "alias twctf8 \"pre_mp;impulse 173\"\n");
	stuffcmd(self, "alias twctf9 \"pre_mp;impulse 174\"\n");
	// twctf2
	stuffcmd(self, "alias twctf2m1 \"pre_mp;impulse 175\"\n");
	stuffcmd(self, "alias twctf2m2 \"pre_mp;impulse 176\"\n");
	stuffcmd(self, "alias twctf2m3 \"pre_mp;impulse 177\"\n");
	stuffcmd(self, "alias twctf2m4 \"pre_mp;impulse 178\"\n");
	stuffcmd(self, "alias twctf2m5 \"pre_mp;impulse 179\"\n");
	stuffcmd(self, "alias twctf2m6 \"pre_mp;impulse 180\"\n");
	stuffcmd(self, "alias twctf2m7 \"pre_mp;impulse 181\"\n");
	stuffcmd(self, "alias twctf2m8 \"pre_mp;impulse 182\"\n");
	stuffcmd(self, "alias twctf2m9 \"pre_mp;impulse 183\"\n");
	stuffcmd(self, "alias twctf2ma \"pre_mp;impulse 184\"\n");
	stuffcmd(self, "alias twctf2mb \"pre_mp;impulse 185\"\n");
	stuffcmd(self, "alias twctf2mc \"pre_mp;impulse 186\"\n");
	// CTFEP
	stuffcmd(self, "alias pstart \"pre_mp;impulse 187\"\n");
	stuffcmd(self, "alias ctf1bsp0 \"pre_mp;impulse 188\"\n");
	stuffcmd(self, "alias ctf1bsp1 \"pre_mp;impulse 189\"\n");
	stuffcmd(self, "alias ctf1bsp2 \"pre_mp;impulse 190\"\n");
	stuffcmd(self, "alias ctf1bsp3 \"pre_mp;impulse 191\"\n");
	stuffcmd(self, "alias ctf1bsp4 \"pre_mp;impulse 192\"\n");
	stuffcmd(self, "alias ctf1bsp5 \"pre_mp;impulse 193\"\n");
	stuffcmd(self, "alias ctf1bsp6 \"pre_mp;impulse 194\"\n");
	stuffcmd(self, "alias ctf1bsp7 \"pre_mp;impulse 195\"\n");
	stuffcmd(self, "alias ctf1bsp8 \"pre_mp;impulse 196\"\n");
	stuffcmd(self, "alias ctf1bsp9 \"pre_mp;impulse 197\"\n");
	stuffcmd(self, "alias ctf1bspx \"pre_mp;impulse 198\"\n");
	// Xeno / Allstar
	stuffcmd(self, "alias allstart \"pre_mp;impulse 199\"\n");
	stuffcmd(self, "alias xeno1 \"pre_mp;impulse 200\"\n");
	stuffcmd(self, "alias xeno2 \"pre_mp;impulse 201\"\n");
	stuffcmd(self, "alias xeno3 \"pre_mp;impulse 202\"\n");
	stuffcmd(self, "alias xeno4 \"pre_mp;impulse 203\"\n");
	stuffcmd(self, "alias xeno5 \"pre_mp;impulse 204\"\n");
	stuffcmd(self, "alias xeno6 \"pre_mp;impulse 205\"\n");
	stuffcmd(self, "alias xeno7 \"pre_mp;impulse 206\"\n");
	stuffcmd(self, "alias xeno8 \"pre_mp;impulse 207\"\n");
	// PCP *HrZ* - At the constant nagging by yokozuna, i've added his mapnames :P
	// Pro Versions
	stuffcmd(self, "alias e1m1pro \"pre_mp;impulse 210\"\n");
	stuffcmd(self, "alias e1m2pro \"pre_mp;impulse 211\"\n");
	stuffcmd(self, "alias e1m3pro \"pre_mp;impulse 212\"\n");
	stuffcmd(self, "alias e1m4pro \"pre_mp;impulse 213\"\n");
	stuffcmd(self, "alias e1m5pro \"pre_mp;impulse 214\"\n");
	stuffcmd(self, "alias e1m6pro \"pre_mp;impulse 215\"\n");
	stuffcmd(self, "alias e1m7pro \"pre_mp;impulse 216\"\n");
	stuffcmd(self, "alias e1m8pro \"pre_mp;impulse 217\"\n");
	stuffcmd(self, "alias e2m1pro \"pre_mp;impulse 218\"\n");
	stuffcmd(self, "alias e2m2pro \"pre_mp;impulse 219\"\n");
	stuffcmd(self, "alias e2m3pro \"pre_mp;impulse 220\"\n");
	stuffcmd(self, "alias e2m4pro \"pre_mp;impulse 221\"\n");
	stuffcmd(self, "alias e2m5pro \"pre_mp;impulse 222\"\n");
	stuffcmd(self, "alias e2m6pro \"pre_mp;impulse 223\"\n");
	stuffcmd(self, "alias e2m7pro \"pre_mp;impulse 224\"\n");
	stuffcmd(self, "alias e3m1pro \"pre_mp;impulse 225\"\n");
	stuffcmd(self, "alias e3m2pro \"pre_mp;impulse 226\"\n");
	stuffcmd(self, "alias e3m3pro \"pre_mp;impulse 227\"\n");
	stuffcmd(self, "alias e3m4pro \"pre_mp;impulse 228\"\n");
	stuffcmd(self, "alias e3m5pro \"pre_mp;impulse 229\"\n");
	stuffcmd(self, "alias e3m6pro \"pre_mp;impulse 230\"\n");
	stuffcmd(self, "alias e3m7pro \"pre_mp;impulse 231\"\n");
	stuffcmd(self, "alias e4m1pro \"pre_mp;impulse 232\"\n");
	stuffcmd(self, "alias e4m2pro \"pre_mp;impulse 233\"\n");
	stuffcmd(self, "alias e4m3pro \"pre_mp;impulse 234\"\n");
	stuffcmd(self, "alias e4m4pro \"pre_mp;impulse 235\"\n");
	stuffcmd(self, "alias e4m5pro \"pre_mp;impulse 236\"\n");
	stuffcmd(self, "alias e4m6pro \"pre_mp;impulse 237\"\n");
	stuffcmd(self, "alias e4m7pro \"pre_mp;impulse 238\"\n");
	stuffcmd(self, "alias e4m8pro \"pre_mp;impulse 239\"\n");
	// PCP dyna - More maps
	stuffcmd(self, "alias capit \"pre_mp;impulse 240\"\n");
	stuffcmd(self, "alias expctf1 \"pre_mp;impulse 241\"\n");
	stuffcmd(self, "alias expctf2 \"pre_mp;impulse 242\"\n");
	// PCP //

	//*check* add arenamaps, death32, expert ctf?

};


void() MapImpulses = {
	if (self.impulse == 102) DoChangeMap(self, "end");
	else if (self.impulse == 208) DoChangeMap(self, "ctfstart");
	else if (self.impulse == 187) DoChangeMap(self, "epstart");
	else if (self.impulse == 165) DoChangeMap(self, "twstart");
	else if (self.impulse == 199) DoChangeMap(self, "allstart");
	else if (self.impulse == 103) DoChangeMap(self, "e1m1");
	else if (self.impulse == 104) DoChangeMap(self, "e1m2");
	else if (self.impulse == 105) DoChangeMap(self, "e1m3");
	else if (self.impulse == 106) DoChangeMap(self, "e1m4");
	else if (self.impulse == 107) DoChangeMap(self, "e1m5");
	else if (self.impulse == 108) DoChangeMap(self, "e1m6");
	else if (self.impulse == 109) DoChangeMap(self, "e1m7");
	else if (self.impulse == 110) DoChangeMap(self, "e1m8");
	else if (self.impulse == 111) DoChangeMap(self, "e2m1");
	else if (self.impulse == 112) DoChangeMap(self, "e2m2");
	else if (self.impulse == 113) DoChangeMap(self, "e2m3");
	else if (self.impulse == 114) DoChangeMap(self, "e2m4");
	else if (self.impulse == 115) DoChangeMap(self, "e2m5");
	else if (self.impulse == 116) DoChangeMap(self, "e2m6");
	else if (self.impulse == 117) DoChangeMap(self, "e2m7");
	else if (self.impulse == 118) DoChangeMap(self, "e3m1");
	else if (self.impulse == 119) DoChangeMap(self, "e3m2");
	else if (self.impulse == 120) DoChangeMap(self, "e3m3");
	else if (self.impulse == 121) DoChangeMap(self, "e3m4");
	else if (self.impulse == 122) DoChangeMap(self, "e3m5");
	else if (self.impulse == 123) DoChangeMap(self, "e3m6");
	else if (self.impulse == 124) DoChangeMap(self, "e3m7");
	else if (self.impulse == 125) DoChangeMap(self, "e4m1");
	else if (self.impulse == 126) DoChangeMap(self, "e4m2");
	else if (self.impulse == 127) DoChangeMap(self, "e4m3");
	else if (self.impulse == 128) DoChangeMap(self, "e4m4");
	else if (self.impulse == 129) DoChangeMap(self, "e4m5");
	else if (self.impulse == 130) DoChangeMap(self, "e4m6");
	else if (self.impulse == 131) DoChangeMap(self, "e4m7");
	else if (self.impulse == 132) DoChangeMap(self, "e4m8");
	else if (self.impulse == 133) DoChangeMap(self, "dm1");
	else if (self.impulse == 134) DoChangeMap(self, "dm2");
	else if (self.impulse == 135) DoChangeMap(self, "dm3");
	else if (self.impulse == 136) DoChangeMap(self, "dm4");
	else if (self.impulse == 137) DoChangeMap(self, "dm5");
	else if (self.impulse == 138) DoChangeMap(self, "dm6");
	else if (self.impulse == 139) DoChangeMap(self, "dm7");
	else if (self.impulse == 140) DoChangeMap(self, "ctf1");
	else if (self.impulse == 141) DoChangeMap(self, "ctf2");
	else if (self.impulse == 142) DoChangeMap(self, "ctf3");
	else if (self.impulse == 143) DoChangeMap(self, "ctf4");
	else if (self.impulse == 144) DoChangeMap(self, "ctf5");
	else if (self.impulse == 145) DoChangeMap(self, "ctf6");
	else if (self.impulse == 146) DoChangeMap(self, "ctf7");
	else if (self.impulse == 147) DoChangeMap(self, "ctf8");
	else if (self.impulse == 148) DoChangeMap(self, "ctf2m1");
	else if (self.impulse == 149) DoChangeMap(self, "ctf2m2");
	else if (self.impulse == 150) DoChangeMap(self, "ctf2m3");
	else if (self.impulse == 151) DoChangeMap(self, "ctf2m4");
	else if (self.impulse == 152) DoChangeMap(self, "ctf2m5");
	else if (self.impulse == 153) DoChangeMap(self, "ctf2m6");
	else if (self.impulse == 154) DoChangeMap(self, "ctf2m7");
	else if (self.impulse == 155) DoChangeMap(self, "ctf2m8");
	else if (self.impulse == 156) DoChangeMap(self, "ctf3m1");
	else if (self.impulse == 157) DoChangeMap(self, "ctf3m2");
	else if (self.impulse == 158) DoChangeMap(self, "ctf3m3");
	else if (self.impulse == 159) DoChangeMap(self, "ctf3m4");
	else if (self.impulse == 160) DoChangeMap(self, "ctf3m5");
	else if (self.impulse == 161) DoChangeMap(self, "ctf3m6");
	else if (self.impulse == 162) DoChangeMap(self, "ctf3m7");
	else if (self.impulse == 163) DoChangeMap(self, "ctf3m8");
	else if (self.impulse == 164) DoChangeMap(self, "ctf3m9");
	else if (self.impulse == 166) DoChangeMap(self, "twctf1");
	else if (self.impulse == 167) DoChangeMap(self, "twctf2");
	else if (self.impulse == 168) DoChangeMap(self, "twctf3");
	else if (self.impulse == 169) DoChangeMap(self, "twctf4");
	else if (self.impulse == 170) DoChangeMap(self, "twctf5");
	else if (self.impulse == 171) DoChangeMap(self, "twctf6");
	else if (self.impulse == 172) DoChangeMap(self, "twctf7");
	else if (self.impulse == 173) DoChangeMap(self, "twctf8");
	else if (self.impulse == 174) DoChangeMap(self, "twctf9");
	else if (self.impulse == 175) DoChangeMap(self, "twctf2m1");
	else if (self.impulse == 176) DoChangeMap(self, "twctf2m2");
	else if (self.impulse == 177) DoChangeMap(self, "twctf2m3");
	else if (self.impulse == 178) DoChangeMap(self, "twctf2m4");
	else if (self.impulse == 179) DoChangeMap(self, "twctf2m5");
	else if (self.impulse == 180) DoChangeMap(self, "twctf2m6");
	else if (self.impulse == 181) DoChangeMap(self, "twctf2m7");
	else if (self.impulse == 182) DoChangeMap(self, "twctf2m8");
	else if (self.impulse == 183) DoChangeMap(self, "twctf2m9");
	else if (self.impulse == 184) DoChangeMap(self, "twctf2ma");
	else if (self.impulse == 185) DoChangeMap(self, "twctf2mb");
	else if (self.impulse == 186) DoChangeMap(self, "twctf2mc");
	else if (self.impulse == 188) DoChangeMap(self, "ctf1bsp0");
	else if (self.impulse == 189) DoChangeMap(self, "ctf1bsp1");
	else if (self.impulse == 190) DoChangeMap(self, "ctf1bsp2");
	else if (self.impulse == 191) DoChangeMap(self, "ctf1bsp3");
	else if (self.impulse == 192) DoChangeMap(self, "ctf1bsp4");
	else if (self.impulse == 193) DoChangeMap(self, "ctf1bsp5");
	else if (self.impulse == 194) DoChangeMap(self, "ctf1bsp6");
	else if (self.impulse == 195) DoChangeMap(self, "ctf1bsp7");
	else if (self.impulse == 196) DoChangeMap(self, "ctf1bsp8");
	else if (self.impulse == 197) DoChangeMap(self, "ctf1bsp9");
	else if (self.impulse == 198) DoChangeMap(self, "ctf1bspx");
	else if (self.impulse == 200) DoChangeMap(self, "xeno1");
	else if (self.impulse == 201) DoChangeMap(self, "xeno2");
	else if (self.impulse == 202) DoChangeMap(self, "xeno3");
	else if (self.impulse == 203) DoChangeMap(self, "xeno4");
	else if (self.impulse == 204) DoChangeMap(self, "xeno5");
	else if (self.impulse == 205) DoChangeMap(self, "xeno6");
	else if (self.impulse == 206) DoChangeMap(self, "xeno7");
	else if (self.impulse == 207) DoChangeMap(self, "xeno8");
	// PCP *HrZ* - At the constant nagging by yokozuna, i've added his mapnames :P
	// Pro Versions
	else if (self.impulse == 210) DoChangeMap(self, "e1m1pro");
	else if (self.impulse == 211) DoChangeMap(self, "e1m2pro");
	else if (self.impulse == 212) DoChangeMap(self, "e1m3pro");
	else if (self.impulse == 213) DoChangeMap(self, "e1m4pro");
	else if (self.impulse == 214) DoChangeMap(self, "e1m5pro");
	else if (self.impulse == 215) DoChangeMap(self, "e1m6pro");
	else if (self.impulse == 216) DoChangeMap(self, "e1m7pro");
	else if (self.impulse == 217) DoChangeMap(self, "e1m8pro");
	else if (self.impulse == 218) DoChangeMap(self, "e2m1pro");
	else if (self.impulse == 219) DoChangeMap(self, "e2m2pro");
	else if (self.impulse == 220) DoChangeMap(self, "e2m3pro");
	else if (self.impulse == 221) DoChangeMap(self, "e2m4pro");
	else if (self.impulse == 222) DoChangeMap(self, "e2m5pro");
	else if (self.impulse == 223) DoChangeMap(self, "e2m6pro");
	else if (self.impulse == 224) DoChangeMap(self, "e2m7pro");
	else if (self.impulse == 225) DoChangeMap(self, "e3m1pro");
	else if (self.impulse == 226) DoChangeMap(self, "e3m2pro");
	else if (self.impulse == 227) DoChangeMap(self, "e3m3pro");
	else if (self.impulse == 228) DoChangeMap(self, "e3m4pro");
	else if (self.impulse == 229) DoChangeMap(self, "e3m5pro");
	else if (self.impulse == 230) DoChangeMap(self, "e3m6pro");
	else if (self.impulse == 231) DoChangeMap(self, "e3m7pro");
	else if (self.impulse == 232) DoChangeMap(self, "e4m1pro");
	else if (self.impulse == 233) DoChangeMap(self, "e4m2pro");
	else if (self.impulse == 234) DoChangeMap(self, "e4m3pro");
	else if (self.impulse == 235) DoChangeMap(self, "e4m4pro");
	else if (self.impulse == 236) DoChangeMap(self, "e4m5pro");
	else if (self.impulse == 237) DoChangeMap(self, "e4m6pro");
	else if (self.impulse == 238) DoChangeMap(self, "e4m7pro");
	else if (self.impulse == 239) DoChangeMap(self, "e4m8pro");
	// PCP dyna - More maps
	else if (self.impulse == 240) DoChangeMap(self, "capit");
	else if (self.impulse == 241) DoChangeMap(self, "expctf1");
	else if (self.impulse == 242) DoChangeMap(self, "expctf2");
	// PCP //
};



void() YesCommand = {
	if (time > self.delay){
		self.input_type = 0;
		if (self.scmd_flag){unsetinfo(self, "scmd");self.scmd_flag = 0;}
	}
	if (self.input_type)
		DoAdminCommand();
	else if (self.classname != "spectator")
		VoteYes();

};


void() NoCommand = {
	if (self.input_type) {
		self.input_type = 0;
		sprint(self, PRINT_HIGH, "Command aborted\n");
		if (self.scmd_flag){unsetinfo(self, "scmd");self.scmd_flag = 0;}

	} else if (self.classname != "spectator") {
		VoteNo();
	}
};


void(float sbit, string infostring) StatbarChange = {
	if (self.pure & sbit) {
		self.pure = self.pure - (self.pure & (sbit));
		sprint(self, PRINT_HIGH, "Statusbar ");
		sprint(self, PRINT_HIGH, infostring);
		sprint(self, PRINT_HIGH, " OFF\n");
	} else {
		self.pure = self.pure | (sbit);
		sprint(self, PRINT_HIGH, "Statusbar ");
		sprint(self, PRINT_HIGH, infostring);
		sprint(self, PRINT_HIGH, " ON");
		if (sbit == SETINFO_SBAR_WEAPON)
			sprint(self, PRINT_HIGH, " Note, this could cause lag for hpbs!");
		sprint(self, PRINT_HIGH, "\n");
	}
	PrintStatusbar(self, string_null, 1);
	SetPureFlags(self);
	PrintNewPlayerSettings();
};

void() StatWeapon = { StatbarChange(SETINFO_SBAR_WEAPON, "weaponinfo"); };
void() StatScore = { StatbarChange(SETINFO_SBAR_SCORES, "teamscores"); };
void() StatTime = { StatbarChange(SETINFO_SBAR_TIME, "time"); };
void() StatRune = { StatbarChange(SETINFO_SBAR_RUNE, "runestatus"); };
void() StatHUD = { StatbarChange(SETINFO_SBAR_HUD, "twoline mode"); };
void() StatAutoID = { StatbarChange(SETINFO_SBAR_AUTOID, "autoid"); };

void() SpawnWallAtPlayer;
void() RemoveLast;			// *check* flytta tii puredefs

//
// Confirm an admincommand.
//
void(string actiontype) ConfirmAction = {
	local entity e;
	e = GetClientFromTeamList(self.impulse);
	PrintClientTeamList(self, 0);
	if (e) {
		sprint(self, PRINT_HIGH, "Are you sure You want to");
		sprint(self, PRINT_HIGH, actiontype);
		sprint(self, PRINT_HIGH, e.netname);
		sprint(self, PRINT_HIGH, " (yes/no)?\n");
		self.oldenemy = e;				// *check* anvδnds inte denna?
		self.delay = time + 10;
		self.input_type = self.input_type | 256;
	} else {
		self.input_type = 0;
		if (self.scmd_flag){unsetinfo(self, "scmd");self.scmd_flag = 0;}
		if (FLAG_DEBUG) sprint(self, PRINT_HIGH, "blipp");
	}
};


//
// Triggered for "double impulse" and impulses that requires a argument.
//
void() CheckInput = {

	if (!self.input_type) {
		return;

	} else if (time > self.delay) {
		self.input_type = 0;
		if (self.scmd_flag){unsetinfo(self, "scmd");self.scmd_flag = 0;}
		sprint(self, PRINT_HIGH, "Command timeout\n");
	// Confirmation
	} else if (self.input_type & 256) {
		if (self.impulse == 55)
			YesCommand();
		if (self.impulse == 56)
			NoCommand();
	// Admin impulses
	} else if (self.input_type == INPUT_TYPE_SCMD) {
		ConfirmAction(" send command to ");
	} else if (self.input_type == INPUT_TYPE_SWAP) {
		ConfirmAction(" swap ");
	} else if (self.input_type == INPUT_TYPE_KICK) {
		ConfirmAction(" kick ");
	} else if (self.input_type == INPUT_TYPE_BAN) {
		ConfirmAction(" ban ");
	} else if (self.input_type == INPUT_TYPE_IPBAN) {
		ConfirmAction(" ipban ");
	} else if (self.input_type == INPUT_TYPE_GIVEADMIN) {
		ConfirmAction(" give admin to ");
	} else if (self.input_type == INPUT_TYPE_PUTIN) {
		ConfirmAction(" put into the game ");
	} else if (self.input_type == INPUT_TYPE_PUTOUT) {
		ConfirmAction(" remove from the game ");

	// Double impulses.
	} else if (self.input_type == INPUT_IMPULSE_ADMIN) {
		self.input_type = 0;
		AdminImpulses();
	} else if (self.input_type == INPUT_IMPULSE_MODES) {
		self.input_type = 0;
		ModeImpulses();
	} else if (self.input_type == INPUT_IMPULSE_CLIENT) {
		self.input_type = 0;
		MoreClientImpulses();
	} else if (self.input_type == INPUT_IMPULSE_SHOW) {
		self.input_type = 0;
		ShowdownImpulses();
	} else if (self.input_type == INPUT_IMPULSE_DEBUG) {
		self.input_type = 0;
		DebugImpulses();
	} else if (self.input_type == INPUT_IMPULSE_PUREAUDIO) {
		self.input_type = 0;
		AudioImpulses();
	} else if (self.input_type == INPUT_IMPULSE_MAP) {
		self.input_type = 0;
		MapImpulses();
	} else {
		self.input_type = 0;
	}
};

void() MoreClientImpulses = {
	if (self.impulse == 109) {
		PrintCommands();
	} else if (self.impulse == 110) {
		PrintModels();
	} else if (self.impulse == 111) {
		ShowScores(self);
	} else if (self.impulse == 112) {
		StartAdminVote();
	} else if (self.impulse == 113) {
		StartVoteExit();
	} else if (self.impulse == 114) {
		SuperAdmin();
	} else if (self.impulse == 116) {
		PrintLocation();
	} else if (self.impulse == 120) {
		CycleSpecTracking();
	} else if (self.impulse == 121) {
		SetAutoShot();
	} else if (self.impulse == 122) {
		SetAutoDemo();
	} else if (self.impulse == 123) {
		StopVote();
	} else if (self.impulse == 124) {
		PrintMapqueue();
	} else if (self.impulse == 125) {
		SayReady();
	} else if (self.impulse == 108) {
		SwapCenterprint();
	} else if (self.impulse == 115) {
		ToggleFreeze();
	} else if (self.impulse == 117) {
		ToggleMenu();
	} else if (self.impulse == 101) {
		StatWeapon();
	} else if (self.impulse == 102) {
		StatScore();
	} else if (self.impulse == 103) {
		StatTime();
	} else if (self.impulse == 104) {
		StatRune();
	} else if (self.impulse == 105) {
		StatHUD();
	} else if (self.impulse == 106) {
		StatAutoID();
	} else if (self.impulse == 107) {
		StatHelp();
	} else if (self.impulse == 127) {
		DMStats();
	} else if (self.impulse == 126) {
		CTFStats();
	} else if (self.impulse == 128) {
		ModeStats();
	} else if (self.impulse == 129) {
		ShowPings(self,1);
	} else if (self.impulse == 130) {
		SwapAudio(self);
	} else if (self.impulse == 131) {
		PrintAbout(self);
	} else if (self.impulse == 132) {
		MapInfo();
	} else if (self.impulse == 133) {
		ShowMaps();
	} else if (self.impulse == 134) {
		JoinGame();
	} else if (self.impulse == 135) {
		AcceptSpec();
	} else if (self.impulse == 136) {
		DeclineSpec();
	} else if (self.impulse == 137) {
		ShowPings(self,0);
	} else if (self.impulse == 138) {
		sprint(self,PRINT_HIGH,"Pure CTF v2.12\n");
	}
};

//
// These impulses can be trigger by any client at any time.
//
void() ClientImpulses = {

	if (!self.impulse) {
		return;
	} else if (self.input_type) {
		CheckInput();
	} else if (self.state && (self.impulse >= 1 && self.impulse <= 8)) {
		MenuImpulses();

	// --- Standard CTF ---
	} else if (self.impulse == 70) {
		SwapStatusBar();
	} else if (self.impulse >= 71 && self.impulse <= 81) {
		SetStatusBar();
	} else if (self.impulse == 25) {
		PrintSettings();
	} else if (self.impulse == 23) {
		TeamFlagStatusReport();
	} else if (self.impulse == 141) {
		identify_player();
	} else if (self.impulse == 99) {
		PrintLocation();

	// --- Pure CTF ---
	} else if (self.impulse == 55) {
		YesCommand();
	} else if (self.impulse == 56) {
		NoCommand();
	} else if (self.impulse == 59) {
		SwapObserver();
	} else if (self.impulse == 54) {
		ReportStatus();

	// --- Expert Teamaudio ---
	} else if ((161 <= self.impulse) && (self.impulse <= 168)) {
		ExpertSounds();
	// --- Prefix Impulses ---
	} else if (self.impulse == 91) {
		self.input_type = INPUT_IMPULSE_CLIENT;
		self.delay = time + 5;
	} else if (self.impulse == 92) {
		self.input_type = INPUT_IMPULSE_ADMIN;
		self.delay = time + 5;
	} else if (self.impulse == 93) {
		bprint(PRINT_HIGH, "modes\n");
		self.input_type = INPUT_IMPULSE_MODES;
		self.delay = time + 5;
	} else if (self.impulse == 94) {
		self.input_type = INPUT_IMPULSE_SHOW;
		self.delay = time + 5;
	} else if (self.impulse == 95) {
		self.input_type = INPUT_IMPULSE_DEBUG;
		self.delay = time + 5;
	} else if (self.impulse == 96) {
		self.input_type = INPUT_IMPULSE_PUREAUDIO;
		self.delay = time + 5;
	} else if (self.impulse == 97) {
		self.input_type = INPUT_IMPULSE_MAP;
		self.delay = time + 5;
// PCP dyna - UserID
//	} else if (self.impulse == 210) {
//		sneek_ShowAllUsers(self);
// PCP //
	}
	self.impulse = 0;
};

/*
=================
SpectatorImpulses

These impulses can be trigger by any spectator, observer or cam.
=================
*/
void() SpectatorImpulses = {
	local entity ent;

	if (!self.impulse) {
		return;
	} else if (self.input_type) {
		CheckInput();
	} else if (self.state && (self.impulse >= 1 && self.impulse <= 8)) {
		MenuImpulses();

	// *check* Tracking och annat hδr....

	} else if ((self.impulse == 1) || (self.impulse == 231)) {
		FindTrack("item_flag_team1", IT_KEY2, 0);

	} else if ((self.impulse == 2) || (self.impulse == 232)) {
		FindTrack("item_flag_team2", IT_KEY1, 0);

	} else if ((self.impulse == 3) || (self.impulse == 233)) {
		FindTrack("item_artifact_super_damage", IT_QUAD, 0);

	} else if ((self.impulse == 4) || (self.impulse == 234)) {
		FindTrack("item_artifact_invulnerability", IT_INVULNERABILITY, 0);

	} else if ((self.impulse == 5) || (self.impulse == 235)) {
		FindTrack("item_artifact_invisibility", IT_INVISIBILITY, 0);

	} else if ((self.impulse == 6) || (self.impulse == 236)) {
		FindTrack("item_rune", 0 , ITEM_RUNE_MASK);

	} else if ((self.impulse == 7) || (self.impulse == 237)) {
		FindTrack("weapon_rocketlauncher", 0, 0);
	} else if (self.impulse == 238) {
		FindTrack("item_armorInv", IT_ARMOR3, 0);

	} else if ((self.impulse == 8) || (self.impulse == 239)) {
		self.goalentity = world; 	//stop tracking
	// <--
	// --- No hit yet, check client impulses ----
// PCP dyna - UserID
//	} else if ( self.impulse == 210 ) {
//		sneek_CheckImpulses(); // dubbel, maargoed
// PCP //
	} else {
		ClientImpulses();
	}
	self.impulse = 0;
};

// ===== These impulses can be triggered by any "active" player ======
void() PlayerImpulses = {

	if (!self.impulse) {
		return;
	} else if (self.input_type) {
		CheckInput();
	// --- Weapons & menu ---
	} else if ((self.impulse >= 1 && self.impulse <= 8)) {
		if (self.state) MenuImpulses();
		else W_ChangeWeapon();

	// --- Standard Quake ---

	} else if (self.impulse == 22 || (self.impulse >= 31 && self.impulse <= 40)) {
  		W_ChangeWeapon ();
	} else if (self.impulse == 9) {			// *obsolete* ?
  		CheatCommand ();
	} else if (self.impulse == 10) {
  		CycleWeaponCommand ();
	} else if (self.impulse == 11) {		// *obsolete* ?
  		ServerflagsCommand ();
 	} else if (self.impulse == 12) {
		CycleWeaponReverseCommand ();

	// --- Standard CTF ---

	} else if (self.impulse == 69) {
		PreviousWeaponCommand ();
	} else if (self.impulse == 20) {
		if (TEAMPLAY & TEAM_DROP_ITEMS)
	                TossBackpack ();
	} else if (self.impulse == 21) {
		if (TEAMPLAY & TEAM_DROP_ITEMS)
			TossWeapon ();

	// --- Pure CTF ---

	} else if (self.impulse == 50) {
		if (!FLAG_DISABLEIMPULSES && !((time < self.attack_finished) && FLAG_TW && (self.weapon == IT_LIGHTNING))) {
			self.weapon = W_BestWeapon ();
			W_SetCurrentAmmo ();
		}
	} else if (self.impulse == 51) {
		if (!FLAG_DISABLEIMPULSES && !((time < self.attack_finished) && FLAG_TW && (self.weapon == IT_LIGHTNING))) {
			self.weapon = W_BestExWeapon ();
			W_SetCurrentAmmo ();
		}
	} else if (self.impulse == 24) {
		TossRune();
	} else	if (self.impulse == 26) {
		TossFlag();
	} else	if (self.impulse == 57) {
		Ready();
	} else 	if (self.impulse == 58) {
		NotReady();

	// --- Thunderwalker --- tw50 --> *optimize*

	} else if (self.impulse == AIRG_IMPULSEVALUE) {
		W_ChangeWeapon ();

	// ThunderWalker: flare launching
	} else if (FLAG_TW && (self.impulse == 160 && time > self.flaretime && !(gamestart))) {
		launch_flare ();
		self.flaretime = time + 0.8;
	// thunderWalker: boom
	} else if (FLAG_TW && (self.impulse == 170)) {
		StartBoom();

	// ThunderWalker: What rune do I have?
	} else if (FLAG_TW && (self.impulse == 180)) {
		whatrune();

	// ThunderWalker: destroy rune
	} else if (FLAG_TW && (self.impulse == 181)) {
		TossRune();			// was menolike();

	// ThunderWalker: Health pack toss
	} else if (FLAG_TW && (self.impulse == 192 && (self.packs))) {
		healthtoss();

	// ThunderWalker: Teleporter.  Idea by Ozzzy
	} else if (FLAG_TW && ((self.impulse == 200) && !(self.twflags & TW_TRANSTIME))) {
		if (!gamestart) {
			if (self.player_flag & PF_GOTFLAG) {
				centerprint(self, "Can't teleport with flag!");
        	                sound (self, CHAN_AUTO, "doors/basetry.wav", 1, ATTN_NORM);
			} else if (self.twflags & TW_ACME) {
 	                       sound (self, CHAN_AUTO, "doors/basetry.wav", 1, ATTN_NORM);
        	                centerprint(self, "One teleport per life!");
			} else {
        			sound (self, CHAN_AUTO, "tw/twtele.wav", 1, ATTN_NORM);
	       		 	self.attack_finished = time + 3;
				TWDelayedAction(2.85, TW_TRANSTIME);
     	       			// self.transtime = time + 2.85;
			}
            	}
	// tw50 <--

	// --- No hit yet, check client impulses ----

	} else {
		ClientImpulses();
	}
	self.impulse = 0;
};

/*
=================
DebugImpulses

These can only be used in debugmode.
=================
*/
void() DebugImpulses = {
	if (!FLAG_DEBUG) {
		sprint(self, PRINT_HIGH, "You can only do this in debug mode.\n");
		return;
	}

	local float x;
	local string tp;
	NEWFLAG = 1;
	NOSPAWN = 1;
	SPAWNDELAY = 2;

	if (0) {
		return;

	} else if (self.impulse == 106) {
		cyclered();
	} else if (self.impulse == 107) {
		cycleblue();
	} else if (self.impulse == 101) {
		SetObserver(self);
	} else if (self.impulse == 110) {
		dumpstarts();
	} else if (self.impulse == 113) {		// *check*
		RemoveLast();
	} else if (self.impulse == 102) {
		UnsetObserver(self);
	} else if (self.impulse == 103) {
		FORCEBLUEWIN = 1;
	} else if (self.impulse == 104) {
		FORCEREDWIN = 1;
	} else if (self.impulse == 105) {
		self.player_flag = self.player_flag | (PF_KILLMERESTART);
/* debug
	} else if (self.impulse == 112) {
		if (ERASETHIS) {
			bprint(PRINT_HIGH, "Erased ");
			bprint(PRINT_HIGH, ERASETHIS.classname);
			bprint(PRINT_HIGH, "\n");
			remove(ERASETHIS);
		}
*/

	} else if (self.impulse == 131) {
		SpawnFlag(self.origin, TEAM_COLOR1 , self.v_angle_y);
		bprint(PRINT_HIGH, "Spawned Red flag\n");
	} else if (self.impulse == 132) {
		SpawnFlag(self.origin, TEAM_COLOR2 , self.v_angle_y);
		bprint(PRINT_HIGH, "Spawned Blue flag\n");
	} else if (self.impulse == 133) {
		SpawnTeamStart(self.origin, TEAM_COLOR1 , self.v_angle_y);
		bprint(PRINT_HIGH, "Spawned Red spot\n");
	} else if (self.impulse == 134) {
		SpawnTeamStart(self.origin, TEAM_COLOR2 , self.v_angle_y);
		bprint(PRINT_HIGH, "Spawned Blue spot\n");
	} else if (self.impulse == 136) {
		SpawnItem("weapon_supershotgun", self.origin);
		bprint(PRINT_HIGH, "Spawned SSG\n");
	} else if (self.impulse == 135) {
		SpawnItem("weapon_supernailgun", self.origin);
		bprint(PRINT_HIGH, "Spawned SNG\n");
	} else if (self.impulse == 137) {
		SpawnItem("weapon_rocketlauncher", self.origin);
		bprint(PRINT_HIGH, "Spawned RL\n");
	} else if (self.impulse == 138) {
		SpawnItem("weapon_grenadelauncher", self.origin);
		bprint(PRINT_HIGH,"Spawned GL\n");
	} else if (self.impulse == 139) {
		SpawnItem("weapon_lightning", self.origin);
		bprint(PRINT_HIGH, "Spawned LG\n");
	} else if (self.impulse == 140) {
		SpawnItem("item_armor2", self.origin);
		bprint(PRINT_HIGH, "Spawned 150a\n");
	} else if (self.impulse == 130) {
		SpawnItem("item_armorInv", self.origin);
		bprint(PRINT_HIGH, "Spawned 200a\n");
	} else if (self.impulse == 121) {
		SpawnItem("item_shells", self.origin);
		bprint(PRINT_HIGH, "Spawned Shells\n");
	} else if (self.impulse == 122) {
		SpawnItem("item_spikes", self.origin);
		bprint(PRINT_HIGH, "Spawned Nails\n");
	} else if (self.impulse == 123) {
		SpawnItem("item_rockets", self.origin);
		bprint(PRINT_HIGH, "Spawned Rockets\n");
	} else if (self.impulse == 124) {
		SpawnItem("item_cells", self.origin);
		bprint(PRINT_HIGH, "Spawned Cells\n");
	} else if (self.impulse == 125) {
		SpawnItem("item_artifact_super_damage", self.origin);
		bprint(PRINT_HIGH, "Spawned Quad\n");

	} else if (self.impulse == 127) {
		SpawnItemComplete("item_health", self.origin, 0, 0);
		bprint(PRINT_HIGH, "Spawned 25H\n");
	} else if (self.impulse == 126) {
		SpawnItemComplete("item_health", self.origin, 2, 0);
		bprint(PRINT_HIGH, "Spawned 100H\n");



	} else if (self.impulse == 120) {
		SpawnWallAtPlayer();
	} else if (self.impulse == 111) {
		if (LAST_TELEPORTER) {
			LAST_TELEPORTER.newflag = 1;
			bprint(PRINT_HIGH, "Added teleportdest: ");
			bprint(PRINT_HIGH, LAST_TELEPORTER.targetname);
			bprint(PRINT_HIGH, "\n");
		}
	} else if (self.impulse == 129) {
		spawn_teleport_destination(self.origin, self.v_angle_y, "purearena");
		bprint(PRINT_HIGH, "Spawned arena start\n");
	} else if (self.impulse == 128) {
		spawn_dmstart(self.origin, self.v_angle_y);
		bprint(PRINT_HIGH, "Spawned DM start\n");
	} else if (self.impulse == 126) {
		return; // *check*
		SpawnItem("item_armor2", self.origin);
		bprint(PRINT_HIGH, "Spawned 150a\n");
	} else if (self.impulse == 127) {
		return; // *check*
		SpawnItem("item_armor2", self.origin);
		bprint(PRINT_HIGH, "Spawned 150a\n");
	} else if (self.impulse == 141) {
		SpawnBot();
	} else if (self.impulse == 142) {
		Spawn20Bots();
	}
};

// ======================
//    SHOWDOWN COMMANDS
// ======================

void() Stuff_Client = {
	// *check*

	stuffcmd(self, "alias settings \"impulse 25\"\n");
	stuffcmd(self, "alias yes \"impulse 55\"\n");
	stuffcmd(self, "alias no \"impulse 56\"\n");
	stuffcmd(self, "alias observer \"impulse 59\"\n");


	stuffcmd(self, "alias pre_cl \"impulse 91;wait\"\n");

	// Double impulses
	stuffcmd(self, "alias commands \"pre_cl;impulse 109\"\n");
	stuffcmd(self, "alias models \"pre_cl;impulse 110\"\n");
	stuffcmd(self, "alias scores \"pre_cl;impulse 111\"\n");
	stuffcmd(self, "alias admin \"pre_cl;impulse 112\"\n");
	stuffcmd(self, "alias voteexit \"pre_cl;impulse 113\"\n");
	stuffcmd(self, "alias super \"pre_cl;impulse 114\"\n");
	stuffcmd(self, "alias autoshot \"pre_cl;impulse 121\"\n");
	stuffcmd(self, "alias autodemo \"pre_cl;impulse 122\"\n");
	stuffcmd(self, "alias stopvote \"pre_cl;impulse 123\"\n");
	stuffcmd(self, "alias mapqueue \"pre_cl;impulse 124\"\n");
	stuffcmd(self, "alias sayready \"pre_cl;impulse 125\"\n");
	stuffcmd(self, "alias cprint \"pre_cl;impulse 108\"\n");
	stuffcmd(self, "alias menu \"pre_cl;impulse 117\"\n");
	stuffcmd(self, "alias cam \"pre_cl;impulse 120\"\n");


	stuffcmd(self, "alias statweapon \"pre_cl;impulse 101\"\n");
	stuffcmd(self, "alias statscore \"pre_cl;impulse 102\"\n");
	stuffcmd(self, "alias stathud \"pre_cl;impulse 105\"\n");
	stuffcmd(self, "alias stattime \"pre_cl;impulse 103\"\n");
	stuffcmd(self, "alias statrune \"pre_cl;impulse 104\"\n");
	stuffcmd(self, "alias statautoid \"pre_cl;impulse 106\"\n");
	stuffcmd(self, "alias stathelp \"pre_cl;impulse 107\"\n");

	stuffcmd(self, "alias dmstats \"pre_cl;impulse 127\"\n");
	stuffcmd(self, "alias ctfstats \"pre_cl;impulse 126\"\n");
	stuffcmd(self, "alias stats \"pre_cl;impulse 128\"\n");

	stuffcmd(self, "alias players \"pre_cl;impulse 137\"\n");
	stuffcmd(self, "alias ping \"pre_cl;impulse 129\"\n");
	stuffcmd(self, "alias teamaudio \"pre_cl;impulse 130\"\n");
	stuffcmd(self, "alias about \"pre_cl;impulse 131\"\n");
	stuffcmd(self, "alias map \"pre_cl;impulse 132\"\n");
	stuffcmd(self, "alias maps \"pre_cl;impulse 133\"\n");
	stuffcmd(self, "alias joingame \"pre_cl;impulse 134\"\n");
	stuffcmd(self, "alias accept \"pre_cl;impulse 135\"\n");
	stuffcmd(self, "alias reject \"pre_cl;impulse 136\"\n");
	stuffcmd(self, "alias decline \"pre_cl;impulse 136\"\n");
	stuffcmd(self, "alias ver \"pre_cl;impulse 138\"\n");
};

void() Stuff_Player = {
	stuffcmd(self, "alias tossrune \"impulse 24\"\n");
	stuffcmd(self, "alias tossflag \"impulse 26\"\n");
	stuffcmd(self, "alias ready \"impulse 57\"\n");
	stuffcmd(self, "alias break \"impulse 58\"\n");
	stuffcmd(self, "alias notready \"impulse 58\"\n");
	stuffcmd(self, "alias report \"impulse 54\"\n");

	stuffcmd(self, "cl_sidespeed 1500\n");
	stuffcmd(self, "cl_backspeed 1500\n");
	stuffcmd(self, "cl_forwardspeed 1500\n");
	stuffcmd(self, "cl_upspeed 1500\n");
};


void() Stuff_ShowDown1 = {

	stuffcmd(self, "alias pre_sd \"impulse 94;wait\"\n");

	stuffcmd(self, "alias timeup \"pre_sd;impulse 121\"\n");
	stuffcmd(self, "alias timedown \"pre_sd;impulse 122 \"\n");
	stuffcmd(self, "alias fragsup \"pre_sd;impulse 123 \"\n");
	stuffcmd(self, "alias fragsdown \"pre_sd;impulse 124 \"\n");
	stuffcmd(self, "alias dm \"pre_sd;impulse 125 \"\n");
	stuffcmd(self, "alias tp \"pre_sd;impulse 126 \"\n");
	stuffcmd(self, "alias powerup \"pre_sd;impulse 127 \"\n");
	stuffcmd(self, "alias powerups \"pre_sd;impulse 127 \"\n");				// for typos
	stuffcmd(self, "alias dropquad \"pre_sd;impulse 128 \"\n");
	stuffcmd(self, "alias dropring \"pre_sd;impulse 129 \"\n");
	stuffcmd(self, "alias fairstart \"pre_sd;impulse 130 \"\n");
	stuffcmd(self, "alias discharge \"pre_sd;impulse 137 \"\n");
	stuffcmd(self, "alias grapple \"pre_sd;impulse 131 \"\n");
	stuffcmd(self, "alias hook \"pre_sd;impulse 131 \"\n");
	stuffcmd(self, "alias runes \"pre_sd;impulse 132 \"\n");
	stuffcmd(self, "alias droprune \"pre_sd;impulse 133 \"\n");
	stuffcmd(self, "alias dropflag \"pre_sd;impulse 138 \"\n");
	stuffcmd(self, "alias maxspeed \"pre_sd;impulse 134 \"\n");
	stuffcmd(self, "alias anka \"pre_sd;impulse 135 \"\n");
	stuffcmd(self, "alias spectalk \"pre_sd;impulse 139 \"\n");
	stuffcmd(self, "alias maxspecs \"pre_sd;impulse 136 \"\n");
	stuffcmd(self, "alias watervis \"pre_sd;impulse 140\"\n");

};

void() Stuff_ShowDown2 = {

	stuffcmd(self, "alias faqhelp \"pre_sd;impulse 109 \"\n");
	stuffcmd(self, "alias faqloc \"pre_sd;impulse 101 \"\n");
	stuffcmd(self, "alias faqtimer \"pre_sd;impulse 102 \"\n");
	stuffcmd(self, "alias faqsound \"pre_sd;impulse 103 \"\n");
	stuffcmd(self, "alias faqlag \"pre_sd;impulse 104 \"\n");
	stuffcmd(self, "alias faqall \"pre_sd;impulse 105 \"\n");

	stuffcmd(self, "alias proxyhelp \"pre_sd;impulse 109 \"\n");
	stuffcmd(self, "alias proxyloc \"pre_sd;impulse 101 \"\n");
	stuffcmd(self, "alias proxytimer \"pre_sd;impulse 102 \"\n");
	stuffcmd(self, "alias proxysound \"pre_sd;impulse 103 \"\n");
	stuffcmd(self, "alias proxylag \"pre_sd;impulse 104 \"\n");
	stuffcmd(self, "alias proxyrlag \"pre_sd;impulse 106 \"\n");
	stuffcmd(self, "alias proxynoe \"pre_sd;impulse 108 \"\n");
	stuffcmd(self, "alias proxynov \"pre_sd;impulse 107 \"\n");
	stuffcmd(self, "alias proxyall \"pre_sd;impulse 105 \"\n");


	stuffcmd(self, "alias showhelp \"pre_sd;impulse 111 \"\n");
	stuffcmd(self, "alias default \"pre_sd;impulse 151 \"\n");
	stuffcmd(self, "alias options \"pre_sd;impulse 112 \"\n");
	stuffcmd(self, "alias ctfopt \"pre_sd;impulse 113 \"\n");
	stuffcmd(self, "alias helpset \"pre_sd;impulse 114 \"\n");

	// *impulse*
	stuffcmd(self, "alias standard \"pre_sd;impulse 152\"\n");
	stuffcmd(self, "alias 3wave \"pre_sd;impulse 153\"\n");
	stuffcmd(self, "alias 2on2 \"pre_sd;impulse 154\"\n");
	stuffcmd(self, "alias oncle \"pre_sd;impulse 155\"\n");
	stuffcmd(self, "alias ctfsm \"pre_sd;impulse 156\"\n");

};

void() Stuff_Admin = {

	// Number imput
	stuffcmd(self, "alias 1 \"impulse 1\"\n");
	stuffcmd(self, "alias 2 \"impulse 2\"\n");
	stuffcmd(self, "alias 3 \"impulse 3\"\n");
	stuffcmd(self, "alias 4 \"impulse 4\"\n");
	stuffcmd(self, "alias 5 \"impulse 5\"\n");
	stuffcmd(self, "alias 6 \"impulse 6\"\n");
	stuffcmd(self, "alias 7 \"impulse 7\"\n");
	stuffcmd(self, "alias 8 \"impulse 8\"\n");
	stuffcmd(self, "alias 9 \"impulse 9\"\n");
	stuffcmd(self, "alias 10 \"impulse 10\"\n");
	stuffcmd(self, "alias 11 \"impulse 11\"\n");
	stuffcmd(self, "alias 12 \"impulse 12\"\n");
	stuffcmd(self, "alias 13 \"impulse 13\"\n");
	stuffcmd(self, "alias 14 \"impulse 14\"\n");
	stuffcmd(self, "alias 15 \"impulse 15\"\n");
	stuffcmd(self, "alias 16 \"impulse 16\"\n");
	stuffcmd(self, "alias 17 \"impulse 17\"\n");
	stuffcmd(self, "alias 18 \"impulse 18\"\n");
	stuffcmd(self, "alias 19 \"impulse 19\"\n");
	// *check* 20-32

	// --- Admin impulses ---
	stuffcmd(self, "alias pre_ad \"impulse 92;wait\"\n");

	stuffcmd(self, "alias kos \"pre_ad;impulse 102\"\n");
	stuffcmd(self, "alias nextmap \"pre_ad;impulse 103\"\n");
	stuffcmd(self, "alias swap \"pre_ad;impulse 104\"\n");
	stuffcmd(self, "alias swapall \"pre_ad;impulse 108\"\n");
	stuffcmd(self, "alias kick \"pre_ad;impulse 109\"\n");
	stuffcmd(self, "alias allready \"pre_ad;impulse 110\"\n");
	stuffcmd(self, "alias start \"pre_ad;impulse 110\"\n");
	stuffcmd(self, "alias ban \"pre_ad;impulse 111\"\n");
	stuffcmd(self, "alias ipban \"pre_ad;impulse 101\"\n");
	stuffcmd(self, "alias restart \"pre_ad;impulse 112\"\n");
	stuffcmd(self, "alias map_restart \"pre_ad;impulse 112\"\n");
	stuffcmd(self, "alias nospecs \"pre_ad;impulse 107\"\n");
	stuffcmd(self, "alias noadmin \"pre_ad;impulse 105\"\n");
	stuffcmd(self, "alias adminhelp \"pre_ad;impulse 106\"\n");
// PCP dyna - Enhanced ingame and spectator admin start/break
	stuffcmd(self, "alias break \"pre_ad;impulse 58\"\n");
// PCP //
	stuffcmd(self, "alias forcebreak \"pre_ad;impulse 113\"\n");
	stuffcmd(self, "alias giveadmin \"pre_ad;impulse 114\"\n");
	stuffcmd(self, "alias modehelp \"pre_ad;impulse 115\"\n");
	stuffcmd(self, "alias freeze \"pre_ad;impulse 116\"\n");

	stuffcmd(self, "alias lock \"pre_ad;impulse 117\"\n");
	stuffcmd(self, "alias unlock \"pre_ad;impulse 118\"\n");
	stuffcmd(self, "alias lockautoshot \"pre_ad;impulse 120\"\n");
	stuffcmd(self, "alias lockautodemo \"pre_ad;impulse 119\"\n");
	stuffcmd(self, "alias kicklast \"pre_ad;impulse 121\"\n");

	stuffcmd(self, "alias putin \"pre_ad;impulse 122\"\n");
	stuffcmd(self, "alias putout \"pre_ad;impulse 123\"\n");

	// --- Modes impulses ---
	stuffcmd(self, "alias pre_mo \"impulse 93;wait\"\n");

	stuffcmd(self, "alias ctfmode \"pre_mo;impulse 103\"\n");
	stuffcmd(self, "alias dmmode \"pre_mo;impulse 103\"\n");
	stuffcmd(self, "alias compmode \"pre_mo;impulse 101\"\n");
//	stuffcmd(self, "alias twmode \"pre_mo;impulse 104\"\n");
	stuffcmd(self, "alias arenamode \"pre_mo;impulse 102\"\n");
	// **backward comp**
	stuffcmd(self, "alias mode0 \"pre_mo;impulse 105\"\n");
	stuffcmd(self, "alias mode1 \"pre_mo;impulse 105\"\n");
	stuffcmd(self, "alias mode4 \"pre_mo;impulse 105\"\n");

};



/*
============
SpectatorStuff

Stuff Spectator Aliases.
============
*/
void() Stuff_Spectator = {
        Stuff_Client();
	return;
};

void() Stuff_Debug = {
	stuffcmd(self, "alias pre_db \"impulse 95;wait\"\n");

	stuffcmd(self, "alias eraseentity \"pre_db;impulse 112\"\n");
	stuffcmd(self, "alias eraselast \"pre_db;impulse 113\"\n");
	stuffcmd(self, "alias dumpall \"pre_db;impulse 110\"\n");
	stuffcmd(self, "alias setobserver \"pre_db;impulse 101\"\n");
	stuffcmd(self, "alias unsetobserver \"pre_db;impulse 102\"\n");
	stuffcmd(self, "alias forcebluewin \"pre_db;impulse 103\"\n");
	stuffcmd(self, "alias forceredwin \"pre_db;impulse 104\"\n");
	stuffcmd(self, "alias killme \"pre_db;impulse 105\"\n");
	stuffcmd(self, "alias cyclered \"pre_db;impulse 106\"\n");
	stuffcmd(self, "alias cycleblue \"pre_db;impulse 107\"\n");

	stuffcmd(self, "alias spawnredflag \"pre_db;impulse 131\"\n");
	stuffcmd(self, "alias spawnblueflag \"pre_db;impulse 132\"\n");
	stuffcmd(self, "alias spawnredspot \"pre_db;impulse 133\"\n");
	stuffcmd(self, "alias spawnbluespot \"pre_db;impulse 134\"\n");
	stuffcmd(self, "alias spawnsng \"pre_db;impulse 135\"\n");
	stuffcmd(self, "alias spawnssg \"pre_db;impulse 136\"\n");
	stuffcmd(self, "alias spawnrl \"pre_db;impulse 137\"\n");
	stuffcmd(self, "alias spawngl \"pre_db;impulse 138\"\n");
	stuffcmd(self, "alias spawnlg \"pre_db;impulse 139\"\n");
	stuffcmd(self, "alias spawn150a \"pre_db;impulse 140\"\n");
	stuffcmd(self, "alias spawn200a \"pre_db;impulse 130\"\n");
	stuffcmd(self, "alias spawnshells \"pre_db;impulse 121\"\n");
	stuffcmd(self, "alias spawnnails \"pre_db;impulse 122\"\n");
	stuffcmd(self, "alias spawncells \"pre_db;impulse 124\"\n");
	stuffcmd(self, "alias spawnquad \"pre_db;impulse 125\"\n");
	stuffcmd(self, "alias spawnwall \"pre_db;impulse 120\"\n");
	stuffcmd(self, "alias lasttele \"pre_db;impulse 111\"\n");
	stuffcmd(self, "alias spawn100h \"pre_db;impulse 126\"\n");
	stuffcmd(self, "alias spawn25h \"pre_db;impulse 127\"\n");
	stuffcmd(self, "alias spawndmstart \"pre_db;impulse 128\"\n");
	stuffcmd(self, "alias spawnarenastart \"pre_db;impulse 129\"\n");

	stuffcmd(self, "alias spawnbot \"pre_db;impulse 141\"\n");
	stuffcmd(self, "alias spawn20bots \"pre_db;impulse 142\"\n");
};

void() Stuff_Audio = {
	stuffcmd(self, "alias pre_ta \"impulse 96;wait\"\n");

	stuffcmd(self, "alias snd_ok \"pre_ta;impulse 101\"\n");
	stuffcmd(self, "alias snd_yes \"pre_ta;impulse 102\"\n");
	stuffcmd(self, "alias snd_no \"pre_ta;impulse 103\"\n");

	stuffcmd(self, "alias snd_attack \"pre_ta;impulse 104'\"\n");
	stuffcmd(self, "alias snd_waiting \"pre_ta;impulse 105\"\n");
	stuffcmd(self, "alias snd_gotenemy \"pre_ta;impulse 106\"\n");
	stuffcmd(self, "alias snd_bleed \"pre_ta;impulse 107\"\n");
	stuffcmd(self, "alias snd_baselost \"pre_ta;impulse 108\"\n");
	stuffcmd(self, "alias snd_baseweak \"pre_ta;impulse 109\"\n");
	stuffcmd(self, "alias snd_baseclear \"pre_ta;impulse 110\"\n");
	stuffcmd(self, "alias snd_basestatus \"pre_ta;impulse 111\"\n");
	stuffcmd(self, "alias snd_incoming \"pre_ta;impulse 112\"\n");
	stuffcmd(self, "alias snd_penta \"pre_ta;impulse 113\"\n");
	stuffcmd(self, "alias snd_quad \"pre_ta;impulse 114\"\n");
	stuffcmd(self, "alias snd_carrier \"pre_ta;impulse 115\"\n");
	stuffcmd(self, "alias snd_escort \"pre_ta;impulse 116\"\n");
	stuffcmd(self, "alias snd_coming \"pre_ta;impulse 117\"\n");
	stuffcmd(self, "alias snd_wantsome \"pre_ta;impulse 118\"\n");
	stuffcmd(self, "alias snd_gotstuff \"pre_ta;impulse 119\"\n");
	stuffcmd(self, "alias snd_custom1 \"pre_ta;impulse 120\"\n");
	stuffcmd(self, "alias snd_custom2 \"pre_ta;impulse 121\"\n");
	stuffcmd(self, "alias snd_custom3 \"pre_ta;impulse 122\"\n");
	stuffcmd(self, "alias snd_custom4 \"pre_ta;impulse 123\"\n");
	stuffcmd(self, "alias snd_custom5 \"pre_ta;impulse 124\"\n");
};


void() SpecBind = {
	stuffcmd(self, "bind 1 \"impulse 231\"\n");
	stuffcmd(self, "bind 2 \"impulse 232\"\n");
	stuffcmd(self, "bind 3 \"impulse 233\"\n");
	stuffcmd(self, "bind 4 \"impulse 234\"\n");
	stuffcmd(self, "bind 5 \"impulse 235\"\n");
	stuffcmd(self, "bind 6 \"impulse 236\"\n");
	stuffcmd(self, "bind 7 \"impulse 237\"\n");
	stuffcmd(self, "bind 8 \"impulse 238\"\n");
	stuffcmd(self, "bind 9 \"impulse 239\"\n");
	stuffcmd(self, "bind 0 \"impulse 240\"\n");
};

void(entity pl) StuffAutoTeam = {
	if (!(pl.admin & STUFF_AUTO))
		return;
/*	if (pl.steam == TEAM_COLOR1) {
		stuffcmd(pl, "autored\nwait\n");
		if (FLAG_DEBUG) bprint(PRINT_HIGH, "Autored\n");
	}
	if (pl.steam == TEAM_COLOR2) {
		stuffcmd(pl, "autoblue\nwait\n");
		if (FLAG_DEBUG) bprint(PRINT_HIGH, "Autoblue\n");
	}*/
};

void() Stuff_Auto = {
//unimplemented code...
/*	stuffcmd(self, "autopure\nwait\n");
	if (FLAG_DEBUG) bprint(PRINT_HIGH, "Autopure\n");
	StuffAutoTeam(self);
*/
};

void() DoStuffing = {

	local float flag;

	flag = 0;
	if (!(self.admin & STUFF_PLAYER)) {
		self.admin = self.admin | STUFF_PLAYER;
		if (FLAG_DEBUG) { PrintTime(self, time); sprint(self, PRINT_HIGH, " Stuffing player\n"); }	// *debug*
		Stuff_Player();
		flag = 1;
	} else if (!(self.admin & STUFF_CLIENT)) {
		self.admin = self.admin | STUFF_CLIENT;
		if (FLAG_DEBUG) { PrintTime(self, time); sprint(self, PRINT_HIGH, " Stuffing client\n"); }	// *debug*
		Stuff_Client();
		flag = 1;
	} else if (!(self.admin & STUFF_ADMIN) && IsAdmin(self)) {
		self.admin = self.admin | STUFF_ADMIN;
		if (FLAG_DEBUG) { PrintTime(self, time); sprint(self, PRINT_HIGH, " Stuffing admin\n"); }	// *debug*
		Stuff_Admin();
		flag = 1;
	} else if (!(self.admin & STUFF_SHOWDOWN1) && (IsAdmin(self) || FLAG_SHOWDOWN)) {
		self.admin = self.admin | STUFF_SHOWDOWN1;
		if (FLAG_DEBUG) { PrintTime(self, time); sprint(self, PRINT_HIGH, " Stuffing show1\n"); }	// *debug*
		Stuff_ShowDown1();
		flag = 1;
	} else if (!(self.admin & STUFF_SHOWDOWN2) && (IsAdmin(self) || FLAG_SHOWDOWN)) {
		self.admin = self.admin | STUFF_SHOWDOWN2;
		if (FLAG_DEBUG) { PrintTime(self, time); sprint(self, PRINT_HIGH, " Stuffing show2\n"); }	// *debug*
		Stuff_ShowDown2();
		flag = 1;
	} else if (!(self.admin & STUFF_MAPS1)) {//&& (IsAdmin(self) || FLAG_SHOWDOWN)) {
		self.admin = self.admin | STUFF_MAPS1;
		if (FLAG_DEBUG) { PrintTime(self, time); sprint(self, PRINT_HIGH, " Stuffing maps1\n"); }	// *debug*
		Stuff_Maps1();
		flag = 1;
	} else if (!(self.admin & STUFF_MAPS2) && (IsAdmin(self) || FLAG_SHOWDOWN)) {
		self.admin = self.admin | STUFF_MAPS2;
		if (FLAG_DEBUG) { PrintTime(self, time); sprint(self, PRINT_HIGH, " Stuffing maps2\n"); }	// *debug*
		Stuff_Maps2();
		flag = 1;
	} else if (!(self.admin & STUFF_SPECTATOR) && ((self.classname == "spectator") || (self.classname == "observer"))) {
		self.admin = self.admin | STUFF_SPECTATOR;
		Stuff_Spectator();
		if (FLAG_DEBUG) { PrintTime(self, time); sprint(self, PRINT_HIGH, " Stuffing spec\n"); }	// *debug*
		flag = 1;
	} else if (!(self.admin & STUFF_DEBUG) && FLAG_DEBUG) {
		self.admin = self.admin | STUFF_DEBUG;
		Stuff_Debug();
		if (FLAG_DEBUG) { PrintTime(self, time); sprint(self, PRINT_HIGH, " Stuffing debug\n"); }	// *debug*
		flag = 1;
	} else if (!(self.admin & STUFF_AUDIO)) {	// *check* om audio δr avslaget?
		self.admin = self.admin | STUFF_AUDIO;
		Stuff_Audio();
		if (FLAG_DEBUG) { PrintTime(self, time); sprint(self, PRINT_HIGH, " Stuffing audio\n"); }	// *debug*
		flag = 1;
	} else if (!(self.admin & STUFF_AUTO)) {
		self.admin = self.admin | STUFF_AUTO;
		Stuff_Auto();
		if (FLAG_DEBUG) { PrintTime(self, time); sprint(self, PRINT_HIGH, " Stuffing auto\n"); }	// *debug*
		flag = 1;
	}

	if (flag)
		SwapStuffFlag(self);
	else
		StopStuffing(self);
};

void(entity pl) StartStuffing = {
	local entity oself;
	oself = self;
	self = pl;
	DoStuffing();
	self = oself;
};
