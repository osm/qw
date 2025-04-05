/*
====================================
ThunderWalker Extra Rune Activities + some other stuff
====================================
*/

//
// Pure optimizations:
// Removed .drop and .onedrop. Drop was used as a local var which is kind of a vaste.
// Onedrop was incorporated in twflags
//


// ThunderWalker:  Changed name of routine, cause Zoid used same name in 4.0
/*
===========
What Rune
===========
*/

void() whatrune =
{
if (self.runes & ITEM_RUNE1_FLAG)
	centerprint (self, "Åáòôè Íáçéã\nResistance\n\nHalf Damage from all sources!");
else if (self.runes & ITEM_RUNE2_FLAG)
	centerprint (self, "Âìáãë Íáçéã\nStrength\n\nYou give Double Damage!");
else if (self.runes & ITEM_RUNE3_FLAG)
	centerprint (self, "Èåìì Íáçéã\nHaste\n\nDoubles Rate of Firing!");
else if (self.runes & ITEM_RUNE4_FLAG)
	centerprint (self, "Åìäåò Íáçéã\nRegeneration\n\nRegens health to 200!\nHealth does not rot away!");
else if (self.runes & ITEM_RUNE5_FLAG)
	centerprint (self, "Ìéöéîç Áòíïò\n\nArmor rebuilds to 250!");
else if (self.runes & ITEM_RUNE6_FLAG)
	centerprint (self, "Ðòïôåãôéïî\n\nImmunity to Slime\nResistance to Lava\nImmunity to Drowning\nImmunity to Splash Damage");
else if (self.runes & ITEM_RUNE7_FLAG)
	centerprint (self, "Öáíðéòå\n\n75% damage done to enemy returned as health!");

else centerprint (self, "You do not have a rune");
	return;
};


/*
====================================================
TW Destroy Rune Code
(destroy rune, 'cause rune toss sucks for gameplay.)
====================================================
*/
void() menolike =
{

/* Ok, a field instead of a local var is a vaste of resources really...

	if (self.runes & ITEM_RUNE4_FLAG)
		self.drop = 4;
	else if (self.runes & ITEM_RUNE7_FLAG)
		self.drop = 7;
*obsolete* */

	if (!(self.runes & ITEM_RUNE_MASK))
		return;



	if (!(self.twflags & TW_ONEDROP))
	{
		local entity item;

		item = spawn();

		item.runes = self.runes;

		item.owner = self;
		item.nextthink = time + 0.1;
		item.think = RuneRespawn;

		self.twflags = self.twflags | (TW_ONEDROP);	// optimize
		sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
		stuffcmd(self, "bf\n");

/* obsolete*

		if ((self.drop == 4) || (self.drop == 7) && (self.health > 100))
			self.health = 100;
		self.drop = 0;
*/

		if ((self.runes & ITEM_RUNE4_FLAG) || (self.runes & ITEM_RUNE7_FLAG) && (self.health > 100))
			self.health = 100;

		self.runes = self.runes - (self.runes & (ITEM_RUNE_MASK));
		
		centerprint (self, "You have destroyed your Rune\nAll powers have left you");
	}

	else {
		centerprint (self, "ACME Destruct-o-Rune:\nOne use only!");
	}
};

/*
============
SelectSpawnPoint

Returns the entity to spawn at

renamed cause only used for teleportation
in TW
============
*/
entity() SelectTeleSpot =
{
	local   entity spot, newspot, thing;
	local   float   numspots, totalspots;
	local   float   rnum, pcount;
	local   float   rs;
	local entity spots;

	numspots = 0;
	totalspots = 0;

// testinfo_player_start is only found in regioned levels
	spot = find (world, classname, "testplayerstart");
	if (spot)
		return spot;
		
// choose a info_player_deathmatch point

// ok, find all spots that don't have players nearby

	spots = world;
	spot = find (world, classname, "info_player_deathmatch");       
	while (spot)
	{
		totalspots = totalspots + 1;

		thing=findradius(spot.origin, 84);
		pcount=0;               
		while (thing)
		{
			if (thing.classname == "player")
				pcount=pcount + 1;                      
			thing=thing.chain;      
		}
		if (pcount == 0) {
			spot.goalentity = spots;
			spots = spot;
			numspots = numspots + 1;
		}

		// Get the next spot in the chain
		spot = find (spot, classname, "info_player_deathmatch");                
	}
	totalspots=totalspots - 1;
	if (!numspots) {
		// ack, they are all full, just pick one at random
//		bprint (PRINT_HIGH, "Ackk! All spots are full. Selecting random spawn spot\n");
		totalspots = rint((random() * totalspots));
		spot = find (world, classname, "info_player_deathmatch");       
		while (totalspots > 0) {
			totalspots = totalspots - 1;
			spot = find (spot, classname, "info_player_deathmatch");
		}
		return spot;
	}
		
// We now have the number of spots available on the map in numspots

	// Generate a random number between 1 and numspots

	numspots = numspots - 1;
	
	numspots = rint((random() * numspots ) );

	spot = spots;
	while (numspots > 0) {
		spot = spot.goalentity;
		numspots = numspots - 1;
	}
	return spot;

};

//
// Cloaking and stuff all moved here to make this stuff easier to check.
//

//
// Pure optimization:
// Since only one player can have the cloak rune at one time, you can set
// the cloak variables as Global Vars instead of fields, saving 4 fields.
// (Did the same with armor and reg :)
//

// 
// Cloak if it's time for that.
//
void() CheckCloak = {
	if (time > bippy)
	{
		if (time < gene) // flash first 2 sec
			stuffcmd(self, "bf\n");

		if (!CLOAKED)
			sound (self, CHAN_ITEM, "tw/twcloak.wav", 1, ATTN_NORM);
		CLOAKED = 1;

		// Set eyes
		if (self.modelindex != modelindex_eyes) {
			self.frame = 0;
			self.modelindex = modelindex_eyes;
		}
	}
};

//
// Decloak a target that get hit.
//
void(entity targ) DecloakTarget = {

	if (CLOAKED)
		sound (targ, CHAN_ITEM, "tw/twcloak2.wav", 1, ATTN_NORM);
	CLOAKED = 0;
	bippy = time + 4.5;
	gene = bippy + 2;

	// *obsolete* , this is done by checkpowerups setmodel (targ, "progs/player.mdl");
};


// <-- check
