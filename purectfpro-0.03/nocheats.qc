// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterström 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************


/* obsolete
void() checkbot1;
void() checkbot2;
*/

void() BotAction = {

	if (VAR_ANTICHEATS & CHEAT_BOTKICK) {
		BanClient(self, "Kicked for a bot-like behaviour."); 
	} else {
		bprint(PRINT_HIGH, "WARNING:");		
		bprint(PRINT_HIGH, self.netname);
		bprint(PRINT_HIGH, " has a bot-like behaviour\n");		
	}
};



void() CheckBot = {
	// Ok, the botchecks sucked. Maybe I could try to do some new another time.
	return;

/* obsolete

	if (!(VAR_ANTICHEATS & CHEAT_BOTCHECK))
		return;

	if (VAR_ANTICHEATS & CHEAT_BOTMETHOD)
		checkbot2();
	else
		checkbot1();
*/
};


float(float mod) CheckEmodel = {
	local float m1, m2;
	m1 = stof(infokey(world, "emodel1"));
	m2 = stof(infokey(world, "emodel2"));
	return ((6967 == mod) || (0 == mod) || (m1 == mod) || (m2 == mod));
};

float(float mod) CheckPmodel = {
	local float m1, m2, m3;
	m1 = stof(infokey(world, "pmodel1"));
	m2 = stof(infokey(world, "pmodel2"));
	return m3 = (	(33168 == mod) || 	// ID original model
			(63782 == mod) || 	// CTF model
			(49362 == mod) || 	// TW?
			(46552 == mod) ||	// TW "exploding head"
			(0 == mod) || 		// Check off (glqwcl 2.10)
			(m1 == mod) || 		// Custom 1
			(m2 == mod));		// Custom 2
};

void() CheckModel = {
	local float e, p;
	if (VAR_ANTICHEATS & CHEAT_PLAYERMODELKICK) {
		if (self.classname != "spectator") {
			p = stof(infokey(self, "pmodel"));
			if (!CheckPmodel(p))
				BanClient(self, "Kicked for using a cheat player model."); 
		}
	}
	if (VAR_ANTICHEATS & CHEAT_EYESMODELKICK) {
		if (self.classname != "spectator") {
			e = stof(infokey(self, "emodel"));
			if (!CheckEmodel(e))
				BanClient(self, "Kicked for using a cheat eyes model."); 
		}
	}
};


/*
=========
PrintModels

Checks and prints all players models
=========
*/
void() PrintModels = {
	local entity pl;
	local float fl;

	pl = CLIENT_CHAIN;

	sprint(self, PRINT_HIGH, "Eyes.mdl  Player.mdl NAME\n");
	sprint(self, PRINT_HIGH, "--------  ---------- ----\n");
	while(pl) {
		fl = stof(infokey(pl, "emodel"));
		sPrintRight(self, fl , 5, " ");

		if (CheckEmodel(fl)) 
			sprint(self, PRINT_HIGH, " OK! ");
		else  
			sprint(self, PRINT_HIGH, " ÂÁÄ ");

		fl = stof(infokey(pl, "pmodel"));
		sPrintRight(self, fl , 5, " ");

		if (CheckPmodel(fl)) 
			sprint(self, PRINT_HIGH, " OK!  ");
		else  
			sprint(self, PRINT_HIGH, " ÂÁÄ  ");

		
		sprint(self, PRINT_HIGH, pl.netname);
		sprint(self, PRINT_HIGH, "\n");

		pl = pl.clientchain;
	}
	sprint(self, PRINT_HIGH, "------    ------    ----\n");
};



void() AntiTimer = {

	local float x, y;
	local entity oself;
	local vector v;
	oself = self;


	if (!(VAR_ANTICHEATS & CHEAT_ANTITIMER))
		return;

	if (!NOSPAWN) {
		precache_model ("progs/quaddama.mdl");
		precache_model ("progs/invulner.mdl");
		precache_model ("progs/invisibl.mdl");
	}

	y = 3;
	while (y) {
		x = ceil(10 + random() * 10);
		while (x) {
			self = spawn();
			self.AIRG_Flags = AIRG_EXCLUDEENTITY;		
			v_x = 3900 + 50 * random() - 25;
			v_y = 3900 + 50 * random() - 25;
			v_z = 3900 + 50 * random() - 25;
			setorigin(self, v);				

			if ( y == 1) setmodel (self, "progs/quaddama.mdl");
			if ( y == 2) setmodel (self, "progs/invulner.mdl");
			if ( y == 3) setmodel (self, "progs/invisibl.mdl");
			self.netname = "Fake powerup";
			self.movetype = MOVETYPE_NONE;
			self.solid = SOLID_NOT; // SOLID_TRIGGER;
			self.think = SUB_Null;
			self.touch = SUB_Null;
			x = x - 1;
		}
		y =  y - 1;
	}
	self = oself;
};

void() stopsounds = {
	local entity e;
	remove(self);
	e = CLIENT_CHAIN;
	while (e) {
		stuffcmd(e, "stopsound\n");
		e = e.clientchain;
	}

};

void() JamWawTimer = {
	if (!(VAR_ANTICHEATS & CHEAT_ANTITIMER))
		return;
	if (self.classname != "item_artifact_super_damage")
		return;
	local entity e;
	e = spawn();
	e.nextthink = time + 3;
	e.think = stopsounds;
};


// *****************************************************************
//   Checkbot 1 
// *****************************************************************

/* obsolete*
void() checkbot1 = {
	local float tid;		// Player connect time
	local float tmpf1;

	tid = self.join_time;

	if (time > self.attack_finished && self.button0 && self.lastbutton == 0) {
                //katsotaan muutos edelliseen yawiin..
                tmpf1 = self.lastyaw - self.v_angle_y; 
		if (tmpf1) {

                        //seuraava iffi muuttaa muutoksen 0-180 asteen valille
			if (tmpf1 < 0) {
                                tmpf1 = tmpf1 * -1;
                                if (tmpf1 > 180)
                                        tmpf1 = 360 - tmpf1;
			} else {
				if (tmpf1 > 180)
					tmpf1 = 360 - tmpf1;
                        }
                        
                        // jos muuto on yli 80 astetta
			if (tmpf1 > 80) {
                                local vector tmpv;
                                makevectors(self.v_angle);
                                tmpv = normalize(v_forward);
                                traceline(self.origin, self.origin + tmpv * 2000, FALSE, self);
                                if (trace_ent.classname == "player")
                                {
                                        	local string tmps;
                                        	local float snitt;
						self.botcount1 = self.botcount1 + 1;

//						dprint(self.netname);
//                                        	dprint(" botcount: ");
//                                        	tmps = ftos(self.botcount1);
//                                        	dprint(tmps);
//                                        	dprint("\n");
					// Hack by Miyamoto----------------------------
						snitt= (self.botcount1/(tid/60));

//						bprint(PRINT_HIGH, "BOTLOG: ");
//						bprint(PRINT_HIGH, self.netname);
//						bprint(PRINT_HIGH, " counts/min: ");
//						bprint(PRINT_HIGH, ftos(snitt));
//						bprint(PRINT_HIGH, " time_on: ");
//						bprint(PRINT_HIGH, ftos(tid));
//						bprint(PRINT_HIGH, " botcounts: ");
//						bprint(PRINT_HIGH, ftos(self.botcount1));
//						bprint(PRINT_HIGH, "\n");
						if ((snitt > 0.4) & (tid > 10))
						{
							BotAction();
						}
					// END Miyamotos hack-----------------------------
                                }
                        }       
                }
        }
	self.lastyaw = self.v_angle_y;
	self.lastbutton = self.button0;
};


*/

// *****************************************************************
//   Checkbot 2
// *****************************************************************

/*
5.5

I made some changes, so this patch will kick normal players more 
rarely. Also, you should check out this cool anti (stooge)bot page:
http://home.sol.no/hkmoen/nostooge/

*/



/* 
25.3

It seems, that this page was mentioned at Blues news, so somebody might
actually get here. I have to warn you, that this isn't perfect and it 
might kick normal players in some (rare) conditions. Those little bugs
can be fixed, and if there is enough interest, I will do it. So if you 
have problems with this, and can't fix it yourself, mail me.
*/  



/*
I have made a little QuakeC patch, that detects (at least Stooge)Bots
unnatural movements, which means running to same direction with
constant speed, while firing to all directions. Here is function for 
it. You should call this at PlayerPostThink. I hope someone finds this
usefull.

v0.1
*/


/* obsolete*

float(float x) anglemod = {
	if (x < 0) return (x + 360);
	else return x;
};

void() checkbot2 =
{
	local float tmpf1, tmpf2, tmpf3;
	tmpf3 = vlen(self.velocity);
	tmpf3 = ceil(tmpf3);
	tmpf1 = vectoyaw(self.velocity);
	tmpf2 = self.v_angle_y;
	if ((tmpf3 == self.lastspeed) && (tmpf3 != 0) && (self.flags & 512) && (tmpf1 == self.lastyaw) && (self.button0))
	{		
		local float tmpf, tmpf4, tmpf5;
		tmpf4 = anglemod(tmpf1);
		tmpf5 = anglemod(tmpf2);
		tmpf = tmpf4 - tmpf5;		
		self.botcount1 = self.botcount1 + 1;
		if ((tmpf2 != self.lastangle) && ((tmpf < -4) || (tmpf > 4)))
		{
			self.botcount2 = self.botcount2 + 1; 
		}
	}
	if (self.botcount1 > 10)
	{
		if (self.botcount2 > 5)
		{
			BotAction();
		}
		self.botcount1 = 0;
		self.botcount2 = 0;
	} 
	self.lastspeed = tmpf3;
	self.lastyaw = tmpf1;
	self.lastangle = tmpf2;
};

*/

/*
I did some testing with this, but not too much, so feel free to correct
my mistakes. If you are going to use this code, it would be nice to
get some credit for it.

I also would like to thank Kekoa Proudfoot (author of StoogeBot), for info
of his bot behavior.

- Ilkka Rajala
- r151925@proffa.cc.tut.fi
- http://proffa.cc.tut.fi/~r151925/faqproxy/
*/




// *check*
