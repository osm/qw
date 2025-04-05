// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterström 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************
//
//  Multiweapon module by Wes Morrison (c)1997
//  Module from "Gatherers CTF"
// 
// *****************************************************************



float modelindex_pl_grap;
float modelindex_pl_shot1;
float modelindex_pl_shot2;
float modelindex_pl_nail1;
float modelindex_pl_nail2;
float modelindex_pl_rock1;
float modelindex_pl_rock2;
float modelindex_pl_light;
float modelindex_player;


void() set_player_weapon =
{
        if (self.invisible_finished >= time ) {
		self.frame = 0;
		self.modelindex = modelindex_eyes;
        } else  if (self.weapon == IT_AXE) {
                self.modelindex = modelindex_player;
        }
        else if (self.weapon == IT_GRAPPLE)
        {
                self.modelindex = modelindex_pl_grap;
        }
        else if (self.weapon == IT_SHOTGUN)
        {
                self.modelindex = modelindex_pl_shot1;
        }
        else if (self.weapon == IT_SUPER_SHOTGUN)
        {
                self.modelindex = modelindex_pl_shot2;
        }
        else if (self.weapon == IT_NAILGUN)
        {
                self.modelindex = modelindex_pl_nail1;
        }
        else if (self.weapon == IT_SUPER_NAILGUN)
        {
                self.modelindex = modelindex_pl_nail2;
        }
        else if (self.weapon == IT_GRENADE_LAUNCHER)
        {
                self.modelindex = modelindex_pl_rock1;
        }
        else if (self.weapon == IT_ROCKET_LAUNCHER)
        {
                self.modelindex = modelindex_pl_rock2;
        }
        else if (self.weapon == IT_LIGHTNING)
        {
                self.modelindex = modelindex_pl_light;
        }

        // For other weapons using custom models, add code here.
        // Otherwise, standard player model will be used for unsupported weapons.

        else
        {
                self.modelindex = modelindex_player;
        }
};

// called by worldspawn
void() MultiWeapon_PreCache =
{
	precache_model ("progs/player.mdl");
	precache_model ("progs/pl_grap.mdl");
	precache_model ("progs/pl_shot1.mdl");
	precache_model ("progs/pl_shot2.mdl");
	precache_model ("progs/pl_nail1.mdl");
	precache_model ("progs/pl_nail2.mdl");
	precache_model ("progs/pl_rock1.mdl");
	precache_model ("progs/pl_rock2.mdl");
	precache_model ("progs/pl_light.mdl");

	// If new player weapon models are created, precache them here
};

// called in PutClientInServer
void() set_player_modelindexes =
{
	setmodel (self, "progs/pl_grap.mdl");
	modelindex_pl_grap  = self.modelindex;

	setmodel (self, "progs/pl_shot1.mdl");
	modelindex_pl_shot1 = self.modelindex;

	setmodel (self, "progs/pl_shot2.mdl");
	modelindex_pl_shot2 = self.modelindex;

	setmodel (self, "progs/pl_nail1.mdl");
	modelindex_pl_nail1 = self.modelindex;

	setmodel (self, "progs/pl_nail2.mdl");
	modelindex_pl_nail2 = self.modelindex;

	setmodel (self, "progs/pl_rock1.mdl");
	modelindex_pl_rock1 = self.modelindex;

	setmodel (self, "progs/pl_rock2.mdl");
	modelindex_pl_rock2 = self.modelindex;

	// If new player weapon models are created, cache their modelindexes here

	setmodel (self, "progs/pl_light.mdl");
	modelindex_pl_light = self.modelindex;

	// Make sure this routine is called after modelindex_player has been set.
	self.modelindex = modelindex_player;

	// Call this once from here to set initial value of .modelindex_thisplayer,
	// called thereafter in W_SetCurrentAmmo, which is called whenever weapon changes
	// Note: any patches that alter the way weapons are selected (so they don't all
	// eventually end up in W_SetCurrentAmmo) may need to call this routine in other spots
	set_player_weapon ();
};
// *check*
