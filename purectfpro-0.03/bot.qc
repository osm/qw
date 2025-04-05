// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterström 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************

// Ok, I'm NOT intending to add bots to Pure, at least not now.
// This module is just for server testing, so that I can spawn
// a couple of fake clients to test some functions. If you want
// a bot that plays CTF, check out the excellent ctfbot+ instead.


void() BotThink;
void() Spawn20Bots;
void() SpawnBot;

void() DoSpawnBot = {
	self.clientflags = self.clientflags | CLIENT_BOT;
// 	self.clientflags = self.clientflags | (CLIENT_BOT); 
	SetNewParms();
	ClientConnect();
	PutClientInServer();
	self.think = BotThink;
	self.nextthink = time + 0.1;
	
};

void() SpawnBot = {
	local entity oself;
	oself = self;
	self = spawn();
	self.think = DoSpawnBot; 
	self.nextthink = time + random() + 0.5;
	self = oself;
};

void() Spawn20Bots = {
	local float x;
	x = 20;
	while(x) {
		SpawnBot();
		x = x - 1;
	}
};

void() BotThink = {
	PlayerPreThink();
	PlayerPostThink();
};

// ==== Fake Clients =====


void(entity client, string s) REAL_STUFFCMD = {};



void(entity client, string s) STUFFCMD = {
	if (self.clientflags & CLIENT_BOT)
		return;
	REAL_STUFFCMD(client, s);
};

void(entity client, float level, string s) REAL_SPRINT = {};

void(entity client, float level, string s) SPRINT = {
	if (self.clientflags & CLIENT_BOT)
		return;
	return;
	REAL_SPRINT(client, level, s);
};


float BLOCKFAKE;

void() FakeSetup = {
	if (BLOCKFAKE) return;
	BLOCKFAKE = 1;			// Only once please
	REAL_SPRINT = sprint;
	sprint = SPRINT;
	REAL_STUFFCMD = stuffcmd;
	sprint = STUFFCMD;
	
};

// ==== No Fake Clients ====



