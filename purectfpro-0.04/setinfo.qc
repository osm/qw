// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterstr�m 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************

//
// Setinfo primitives, use these to set your setinfo. All these check
// if it's a correct client and check if the correct setting is already
// set, which saves bandwith for all clients.
//

//
// Set the infokey for a client.
//
void(entity pl,string key, string str) setinfostring = {
	if (!IsClient(pl))
		return;
	if (infokey(pl, key) != str) {
		stuffcmd(pl, "setinfo ");
		stuffcmd(pl, key);
			stuffcmd(pl, " \"");
		stuffcmd(pl, str);
			stuffcmd(pl, "\"\n");
		if (FLAG_DEBUG) {		// debug
			sprint(pl, PRINT_HIGH, "Stuffing setinfo: ");
			sprint(pl, PRINT_HIGH, key);
			sprint(pl, PRINT_HIGH, ",");
			sprint(pl, PRINT_HIGH, str);
			sprint(pl, PRINT_HIGH, " ");
			PrintTime(pl, time);
			sprint(pl, PRINT_HIGH, "\n");
		}
	}
};

//
// Set a numeric value to a client setinfo.
//
void(entity pl,string key, float val) setinfo = {
	local string tp;
	tp = ftos(val);
	setinfostring(pl, key, tp);
};

//
// Clears a setinfo key.
//
void(entity pl, string key) unsetinfo = {
	setinfostring(pl, key, string_null);
};

// =================
//  Proxy Functions
// =================

//
// Returns what proxy (if known) the client is using.
//
float (entity pl) ProxyType = {
	if (infokey(pl, "FAQ-Proxy") != "")
		return PROXY_FAQ;
	if (infokey(pl, "Qizmo") != "")
		return PROXY_QIZMO;
	if (infokey(pl, "NITRO") != "")
		return PROXY_NITRO;
	if (infokey(pl, "NFProxy") != "")
		return PROXY_NF;
	if (infokey(pl, "Cheapo") != "")
		return PROXY_CHEAPO;
	return 0;
};
//
// Returns the proxy version.
//
string (entity pl) ProxyVersion = {
	if (infokey(pl, "FAQ-Proxy") != "")
		return infokey(pl, "FAQ-Proxy");
	if (infokey(pl, "Qizmo") != "")
		return infokey(pl, "Qizmo");
	else return string_null;
};

//
// Demo capable proxy? *inline*
//
float(entity pl) HaveDemoProxy = {
	if (ProxyType(pl) == PROXY_FAQ)
		return 1;
	if (ProxyType(pl) == PROXY_QIZMO)
		return 1;
	return 0;
};



//
// Turn of proxy powerups.
//
void(entity pl) TurnOffProxy = {
	//*check*
	if ((ProxyType(pl) == PROXY_FAQ) || (ProxyType(pl) == PROXY_QIZMO))
		stuffcmd(pl, "say proxy: powerups 0\n");
};

// ====


void() PrintNewPlayerSettings = {
	local string tp;
	local float x;
	sprint(self, PRINT_HIGH, "��� setinfo pure ");
	x = self.pure;
	x = x - (x & (SETINFO_STUFF));
	tp = ftos(x);
	sprint(self, PRINT_HIGH, tp);
	sprint(self, PRINT_HIGH, " �� ���� ������\n");
	sprint(self, PRINT_HIGH, "�� ���� ���� �������� ����������\n");
};


void() CheckBan = {
	if (infokey(self, "mod") == "1") {
		sprint(self, PRINT_HIGH, "\n********************************\nYou are banned from this server.\n********************************\n\n");
		stuffcmd(self, "disconnect\n");
	}
};




void(string ikey, float bit) Obsoletebitflag = {
	if (infokey(self, ikey) != "") {
		if (!OBSOLETEFLAG)
			sprint(self, PRINT_HIGH, "\n***********************************\n");
		OBSOLETEFLAG = 1;

		sprint(self, PRINT_HIGH, "����! setinfo ");
		sprint(self, PRINT_HIGH, ikey);
		sprint(self, PRINT_HIGH, " �� ��� ���� ��� ����!.\n");

		if (infokey(self, ikey) == "0") {
			self.pure = self.pure - (self.pure & bit);
		} else {
			self.pure = self.pure | bit;
		}

		unsetinfo(self, ikey);
	}
};


void (entity pl) SetPureFlags = {
	setinfo(pl, "pure", pl.pure);
};

void(entity pl) SwapStuffFlag = {
	local float x;
	x = (pl.pure & SETINFO_STUFF);
	if (x == SETINFO_STUFF1)
		x = SETINFO_STUFF2;
	else if (x == SETINFO_STUFF2)
		x = SETINFO_STUFF3;
	else
		x = SETINFO_STUFF1;
	pl.pure = pl.pure - (pl.pure & (SETINFO_STUFF));
	pl.pure = pl.pure | (x);
	SetPureFlags(pl);
};

void(entity pl) StopStuffing = {
	pl.pure = pl.pure - (pl.pure & (SETINFO_STUFF));
	SetPureFlags(pl);
};

float(entity pl) CheckStuffflag = {
	local float x;
	x = stof(infokey(pl, "pure"));
	return (pl.pure == x);
};




void() CheckInfokey = {
	local string tp;

	OBSOLETEFLAG = 0;

	CheckBan();			// Check for tempban
	CheckModel();			// Check for illegal model

	// Clear unneeded infokeys
	if (self.classname != "spectator")
		unsetinfo(self, "spectator");
/* obsolete since qw2.21
	unsetinfo(self, "emodel");
	unsetinfo(self, "pmodel");
*/

	tp = infokey(self, "pure");
	if (tp == "" )
		self.pure = 1;
	else
		self.pure = stof(tp);


	if (infokey(self, "statusbar") != "") {
		if (!OBSOLETEFLAG)
			sprint(self, PRINT_HIGH, "\n***********************************\n");
		sprint(self, PRINT_HIGH, "����! setinfo statusbar �� ��������.\n");
		self.pure = self.pure - (self.pure & 15);
		self.pure = self.pure + (stof(infokey(self, "statusbar")) & 15);
		OBSOLETEFLAG = 1;
		unsetinfo(self, "statusbar");
	}

	Obsoletebitflag("ad", SETINFO_AUTODEMO_PROXY);
	Obsoletebitflag("autodemo", SETINFO_AUTODEMO_PROXY);

	Obsoletebitflag("as", SETINFO_AUTOSHOT);
	Obsoletebitflag("autoshot", SETINFO_AUTOSHOT);


	if (OBSOLETEFLAG) {
		sprint(self, PRINT_HIGH, "\n");
		PrintNewPlayerSettings();
		sprint(self, PRINT_HIGH, "***********************************\n");
	}
};


// *check*
