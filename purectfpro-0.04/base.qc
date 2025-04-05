//
// ==============================
// ThunderWalker Base Zones Mojo
// ==============================
//


// Done some optimizations here...


float TW_ZONE_RADIUS;
float BASETIME;



void() SetBaseZoneRadius = {
	if (world.model == "maps/ctf1.bsp")
		TW_ZONE_RADIUS = 450;
	else if (world.model == "maps/ctf2.bsp")
		TW_ZONE_RADIUS = 150;
	else if (world.model == "maps/ctf5.bsp")
		TW_ZONE_RADIUS = 450;
	else if	(world.model == "maps/ctf6.bsp")	
		TW_ZONE_RADIUS = 650;
	else if (world.model == "maps/ctf8.bsp")
		TW_ZONE_RADIUS = 450;
	else if (world.model == "maps/ctf2m1.bsp")
		TW_ZONE_RADIUS = 450;
	else if (world.model == "maps/ctf2m3.bsp")	
		TW_ZONE_RADIUS = 700;
	else if (world.model == "maps/ctf2m7.bsp")
		TW_ZONE_RADIUS = 300;
	else if (world.model == "maps/twctf1.bsp")
			TW_ZONE_RADIUS = 380;
	else if (world.model == "maps/twctf2.bsp")
		TW_ZONE_RADIUS = 450;
	else if (world.model == "maps/twctf3.bsp")
		TW_ZONE_RADIUS = 525;
	else if (world.model == "maps/twctf4.bsp")
		TW_ZONE_RADIUS = 270;
	else if (world.model == "maps/twctf7.bsp")
		TW_ZONE_RADIUS = 450;
	else if (world.model == "maps/twctf8.bsp")
		TW_ZONE_RADIUS = 250;
	else 
		TW_ZONE_RADIUS = 500;
};


void() basedefend = {
	local entity flag, flag2;
//	local entity marc, marc2;


	flag = find(world, classname, "item_flag_team1");
	flag2 = find(world, classname, "item_flag_team2");

/* obsolete - old TW hack

	marc = findradius(flag.oldorigin, TW_ZONE_RADIUS);
	marc2 = findradius(flag2.oldorigin, TW_ZONE_RADIUS);

	while(marc != world) {
		if (marc == self) {
			if (marc.steam == flag.steam) {
				if (self.health < 100)
					self.ouchtime = 1;
			}
			if (marc.steam != flag.steam && !(marc.player_flag & PF_GOTFLAG))
			self.ouchtime = 2;
		}
		self.basetime = time + 4;
		marc = marc.chain;
	}
	while(marc2 != world) {
		if (marc2 == self) {
			if (FLAG_DEBUG) sprint(self, PRINT_HIGH, "x");
			if (marc2.steam == flag2.steam) {
				if (self.health < 100)
					self.ouchtime = 1;
			}
			if (marc2.steam != flag2.steam && !(marc2.player_flag & PF_GOTFLAG))
				self.ouchtime = 2;
		}
		self.basetime = time + 4;
		marc2 = marc2.chain;
	}
*/

	self.twflags = self.twflags - (self.twflags & (TW_OUCHTIME));
	if (vlen(self.origin - flag.oldorigin) < TW_ZONE_RADIUS) {
		if (self.steam == flag.steam) {
			if (self.health < 100)				
				self.twflags = self.twflags | (TW_OUCHHEAL);
		} else if (!self.player_flag & PF_GOTFLAG) {
			self.twflags = self.twflags | (TW_OUCHDAMAGE);
		}
	}

	if (vlen(self.origin - flag2.oldorigin) < TW_ZONE_RADIUS) {
		if (self.steam == flag2.steam) {
			if (self.health < 100)				
				self.twflags = self.twflags | (TW_OUCHHEAL);
		} else if (!self.player_flag & PF_GOTFLAG) {
			self.twflags = self.twflags | (TW_OUCHDAMAGE);
		}
	}
	self.basetime = time + 4;

};§

	// ThunderWalker: Part of the base mojo

void() DoBaseMojo = {

	if (FLAG_STANDBY) 
		return;

	if (self.lisa < time) {
		if (self.twflags & TW_OUCHHEAL) {
			if (self.health < 100) {
				self.health = self.health + 1;
				self.lisa = time + 0.66;
			}
		} else if (self.twflags & TW_OUCHDAMAGE) {
			if (!(self.runes & ITEM_RUNE6_FLAG)) {
				self.health = self.health - 1;
				if ((self.basetime - (random()*2)) < time)
					PainSound();
				if (self.health < 1)
					PlayerDie();
				if (self.runes & ITEM_RUNE1_FLAG)		// *resbasebug* from tw50
					self.lisa = time + 2;
				else
					self.lisa = time + 1;
			}
		}
	}
	if (self.basetime < time)
		basedefend();
};

// <-- check

