float EntityDebug;		// *check* remove later...

entity SpawnChain;		// obsolete
float SpawnChainFlag;


void() InitSpawnChain = {
	SpawnChainFlag = 1;
	SpawnChain = world;
};

void(entity pl) AddToSpawnChain = {
	pl.clientchain = SpawnChain;
	SpawnChain = pl;	
};

void() RemoveSpawnChain = {
	local entity e;
	while (SpawnChain) {
		e = SpawnChain;
		SpawnChain = SpawnChain.clientchain;
		remove(e);
	}
};



entity (string entclass, string evalue) FindByModel =
{
	local entity p;
	p = find (world, classname, entclass);
	if (EntityDebug) {
		bprint(PRINT_HIGH , "Looking for:");
		bprint(PRINT_HIGH , evalue);
		bprint(PRINT_HIGH , "\n");
	}

	while(p != world) {
		if (EntityDebug) {
			bprint(PRINT_HIGH , "Checking: ");
			bprint(PRINT_HIGH , p.classname);
			bprint(PRINT_HIGH , " - ");
			bprint(PRINT_HIGH , p.model);
			bprint(PRINT_HIGH , " - ");
			bprint(PRINT_HIGH , p.target);
			bprint(PRINT_HIGH , "\n");
		}

		if ( p.model == evalue ) {
			if (EntityDebug) {
				bprint(PRINT_HIGH , "Found:");
				bprint(PRINT_HIGH , p.classname);
				bprint(PRINT_HIGH , " ");
				bprint(PRINT_HIGH , p.model);
				bprint(PRINT_HIGH , "\n");
			}
			return p;  
		}
		p = find(p, classname, entclass);
	}
	if (EntityDebug) {
		local string st;
		bprint(PRINT_HIGH , "\nNot Found:");
		bprint(PRINT_HIGH , entclass);
		bprint(PRINT_HIGH , " - ");
		st = evalue;
		bprint(PRINT_HIGH , st);
		bprint(PRINT_HIGH , "\n");
	}	
};

void() RemoveByModelThink = {
	local entity e;
	e = FindByModel(self.netname, self.model);
	if (e) remove(e);
	remove(self);
};

void(string clname, string evalue) RemoveByModel = {
	local entity e;
	
	e = spawn();
	e.netname = clname;
	e.model = evalue;
	e.nextthink = time + 1;
	e.think = RemoveByModelThink;
}; 


entity (string entclass, string evalue) FindByTarget =
{
	local entity p;
	p = find (world, classname, entclass);
	if (EntityDebug) {
		bprint(PRINT_HIGH , "Looking for:");
		bprint(PRINT_HIGH , evalue);
		bprint(PRINT_HIGH , "\n");
	}

	while(p != world) {
		if (EntityDebug) {
			bprint(PRINT_HIGH , "Checking: ");
			bprint(PRINT_HIGH , p.classname);
			bprint(PRINT_HIGH , " - ");
			bprint(PRINT_HIGH , p.target);
			bprint(PRINT_HIGH , "\n");
		}

		if ( p.target == evalue ) {
			if (EntityDebug) {
				bprint(PRINT_HIGH , "Found:");
				bprint(PRINT_HIGH , p.classname);
				bprint(PRINT_HIGH , " ");
				bprint(PRINT_HIGH , p.target);
				bprint(PRINT_HIGH , "\n");
			}
			return p;  
		}
		p = find(p, classname, entclass);
	}

	if (EntityDebug) {

		local string st;
		bprint(PRINT_HIGH , "\nNot Found:");
		bprint(PRINT_HIGH , entclass);
		bprint(PRINT_HIGH , " - ");
		st = evalue;
		bprint(PRINT_HIGH , st);
		bprint(PRINT_HIGH , "\n");
	}
};

void() RemoveByTargetThink = {
	// *optimize* *check*

	local entity e;
	e = FindByTarget(self.netname, self.target);
	if (e) remove(e);
	remove(self);
};

void(string clname, string evalue) RemoveByTarget = {
	local entity e;
	
	e = spawn();
	e.netname = clname;
	e.target = evalue;
	e.nextthink = time + 1;
	e.think = RemoveByTargetThink;
}; 



entity (string entclass, string evalue) FindByTargetname =
{
	local entity p;
	p = find (world, classname, entclass);
	if (EntityDebug) {
		bprint(PRINT_HIGH , "Looking for:");
		bprint(PRINT_HIGH , evalue);
		bprint(PRINT_HIGH , "\n");
	}

	while(p != world) {
		if (EntityDebug) {
			bprint(PRINT_HIGH , "Checking: ");
			bprint(PRINT_HIGH , p.classname);
			bprint(PRINT_HIGH , " - ");
			bprint(PRINT_HIGH , p.targetname);
			bprint(PRINT_HIGH , "\n");
		}

		if ( p.targetname == evalue ) {
			if (EntityDebug) {
				bprint(PRINT_HIGH , "Found:");
				bprint(PRINT_HIGH , p.classname);
				bprint(PRINT_HIGH , " ");
				bprint(PRINT_HIGH , p.targetname);
				bprint(PRINT_HIGH , "\n");
			}
			return p;  
		}
		p = find(p, classname, entclass);
	}
	if (EntityDebug) {
		local string st;
		bprint(PRINT_HIGH , "\nNot Found:");
		bprint(PRINT_HIGH , entclass);
		bprint(PRINT_HIGH , " - ");
		st = evalue;
		bprint(PRINT_HIGH , st);
		bprint(PRINT_HIGH , "\n");
	}
};




entity (string entclass, vector vvalue) FindByOrigin =
{
	local entity p;
	local float px,py,pz,vx,vy,vz;
	local string st;

	px = rint(vvalue_x);		
	py = rint(vvalue_y);		
	pz = rint(vvalue_z);		
	
	if (EntityDebug) {
		bprint(PRINT_HIGH , "Looking for:");
		st = ftos(px);
		bprint(PRINT_HIGH , " x:");
		bprint(PRINT_HIGH , st);
		st = ftos(py);
		bprint(PRINT_HIGH , " y:");
		bprint(PRINT_HIGH , st);
		st = ftos(pz);
		bprint(PRINT_HIGH , " z:");
		bprint(PRINT_HIGH , st);
		bprint(PRINT_HIGH , "\n");
	}
	p = find (world, classname, entclass);

	while(p != world) {
		px = rint(p.origin_x);		
		py = rint(p.origin_y);		
		pz = rint(p.origin_z);		
		if (EntityDebug) {
			bprint(PRINT_HIGH , "Found: ");
			bprint(PRINT_HIGH , p.classname);
			st=ftos(px);
			bprint(PRINT_HIGH , " x:");
			bprint(PRINT_HIGH , st);
			st=ftos(py);
			bprint(PRINT_HIGH , " y:");
			bprint(PRINT_HIGH , st);
			st=ftos(pz);
			bprint(PRINT_HIGH , " z:");
			bprint(PRINT_HIGH , st);
			bprint(PRINT_HIGH , "\n");
		}
		if ((px == vvalue_x) && (py == vvalue_y) && (pz == vvalue_z)) {
			if (EntityDebug) {
				bprint(PRINT_HIGH , "Removed:");
				bprint(PRINT_HIGH , p.classname);
				bprint(PRINT_HIGH , " ");
				local string st;
				st = vtos(p.origin);
				bprint(PRINT_HIGH , st);
				bprint(PRINT_HIGH , "\n");
			}
			return p;  
		}
		p = find(p, classname, entclass);
	}
	if (EntityDebug) {
		local string st;
		bprint(PRINT_HIGH , "\nNot Found:");
		bprint(PRINT_HIGH , entclass);
		bprint(PRINT_HIGH , " - ");
		st = vtos(vvalue);
		bprint(PRINT_HIGH , st);
		bprint(PRINT_HIGH , "\n");
	}
};

void() RemoveByOriginThink = {
	local entity e;
	e = FindByOrigin(self.netname, self.origin);
	if (e) remove(e);
	remove(self);
};

void(string clname, vector org) RemoveByOrigin = {
	local entity e;
	
	e = spawn();
	e.netname = clname;
	e.origin = org;
	e.nextthink = time + 1;
	e.think = RemoveByOriginThink;
}; 


void() dummy = {
	return;
};


void (vector org, float fteam, float angl) SpawnTeamStart = 
{

	local entity st;
	st = spawn();
	st.origin = org;
	setorigin(st, org);
	st.angles_x = 0;
	st.angles_y = angl;
	st.solid = SOLID_NOT;
	st.movetype = MOVETYPE_NONE;
	setmodel(st, string_null);
	if (fteam == TEAM_COLOR1) 
		st.classname = "info_player_team1";
	else
		st.classname = "info_player_team2";

	st.newflag = NEWFLAG;			// DEBUG
};






void(string clname, vector org, float spflags, float angl) SpawnItemComplete = {
	local entity oldself;
	oldself = self;
	self = spawn();

	self.classname = clname;	
	setorigin(self, org);
	self.spawnflags = spflags;
	self.angles_x = 0;
	self.angles_y = angl;

	if (clname == "weapon_supershotgun") 
		weapon_supershotgun();
	else if (clname == "weapon_nailgun") 
		weapon_nailgun();
	else if (clname == "weapon_supernailgun") 
		weapon_supernailgun();
	else if (clname == "weapon_grenadelauncher") 
		weapon_grenadelauncher();
	else if (clname == "weapon_rocketlauncher") 
		weapon_rocketlauncher();
	else if (clname == "weapon_lightning") 
		weapon_lightning();
	else if (clname == "item_flag_team1_temp")
		item_flag_team1();
	else if (clname == "item_flag_team2_temp")
		item_flag_team2();
	else if (clname == "item_health")
		item_health();
	else if (clname == "item_shells")
		item_shells();
	else if (clname == "item_spikes")
		item_spikes();
	else if (clname == "item_rockets")
		item_rockets();
	else if (clname == "item_cells")
		item_cells();
	else if (clname == "item_armor1")
		item_armor1();
	else if (clname == "item_armor2")
		item_armor2();
	else if (clname == "item_armorInv")
		item_armorInv();
	else if (clname == "item_artifact_invulnerability")
		item_artifact_invulnerability();
	else if (clname == "item_artifact_envirosuit")
		item_artifact_envirosuit();
	else if (clname == "item_artifact_invisibility")
		item_artifact_invisibility();
	else if (clname == "item_artifact_super_damage")
		item_artifact_super_damage();
	else {
		bprint(PRINT_HIGH, "BUG: no spawn function for ");
		bprint(PRINT_HIGH, clname);
		bprint(PRINT_HIGH, " !!\n");
		objerror();
	}
	AddToSpawnChain(self);

	if (SPAWNDELAY)
		self.nextthink = SPAWNDELAY + time;
	self.newflag = NEWFLAG;				// debug
	self = oldself;

};

void(string clname, vector org) SpawnItem = {
	SpawnItemComplete(clname, org, 0, 0);
};

/*
 *  Spawning Weapons
 */
void(vector org) spawn_supershotgun = {
	SpawnItem("weapon_supershotgun", org);
};
void(vector org) spawn_nailgun = {
	SpawnItem("weapon_nailgun", org);
};
void(vector org) spawn_supernailgun = {
	SpawnItem("weapon_supernailgun", org);
};
void(vector org) spawn_grenadelauncher = {
	SpawnItem("weapon_grenadelauncher", org);
};
void(vector org) spawn_rocketlauncher = {
	SpawnItem("weapon_rocketlauncher", org);
};
void(vector org) spawn_lightning = {
	SpawnItem("weapon_lightning", org);
};
/*
 *  Spawning Items
 */ 
void(vector org, float spflags) spawn_health = {	
	SpawnItemComplete("item_health", org, spflags, 0); 
};
void(vector org , float spflag) spawn_shells = {
	SpawnItemComplete("item_shells", org, spflag, 0); 
};
void(vector org , float spflag) spawn_nails = {
	SpawnItemComplete("item_spikes", org, spflag, 0); 
};
void(vector org , float spflag) spawn_rockets = {
	SpawnItemComplete("item_rockets", org, spflag, 0); 
};
void(vector org , float spflag) spawn_cells = {
	SpawnItemComplete("item_cells", org, spflag, 0); 
};
void(vector org , float atype) spawn_armor = {
// 0 = green 1 = yellow 2 = red
	if (atype == 0) 
		SpawnItem("item_armor1", org);
	else if (atype == 1) 
		SpawnItem("item_armor2", org);
	else if (atype == 2) 
		SpawnItem("item_armorInv", org);
};
void(vector org) spawn_pentagram = {
	SpawnItem("item_artifact_invulnerability", org);
};
void(vector org) spawn_envirosuit = {
	SpawnItem("item_artifact_envirosuit", org);
};
void(vector org) spawn_invisibility = {
	SpawnItem("item_artifact_invisibility", org);
};
void(vector org) spawn_quad = {
	SpawnItem("item_artifact_super_damage", org);
};

void (vector org, float fteam, float angl) SpawnFlag = {
	if (fteam == TEAM_COLOR1)
		SpawnItemComplete("item_flag_team1_temp", org, 0 ,angl);
	else if (fteam == TEAM_COLOR2)
		SpawnItemComplete("item_flag_team2_temp", org, 0 ,angl);
};




void(vector org, float angl, string targ) spawn_teleport_destination =
{
	local entity et;
	et = spawn();
	et.classname = "info_teleport_destination";
	et.targetname = targ;	
	et.mangle_x = 0;
	et.mangle_y = angl;
	et.angles = '0 0 0';
	et.model = "";
	et.origin = org + '0 0 27';
	et.newflag = NEWFLAG;
	AddToSpawnChain(et);
};

void(vector org, float angl) spawn_dmstart = {
	local entity et;
	et = spawn();
	et.classname = "info_player_start";
	et.origin = org;
	et.mangle_x = 0;
	et.mangle_y = angl;
	et.newflag = NEWFLAG;
	AddToSpawnChain(et);
};


void() teleport_touch;
void() teleport_use;

void(string targ, string mod) spawn_trigger_teleport = 
{
	local entity oself;
	local vector o;
	oself = self;
	self = spawn();

	self.classname = "trigger_teleport";
	self.target = targ;
	self.model = mod;

	trigger_teleport();
	AddToSpawnChain(self);
	self = oself;
};


void(string mod) spawn_func_wall = {
	local entity oself;
	oself = self;
	self = spawn();
	self.classname = "func_wall";
	self.model = mod;
	AddToSpawnChain(self);
	func_wall();
	self = oself;
};

void() FireTargetThink = {
	activator = self;
	other = self;
	self.use();
	remove(self);
};

void(string tname) FireTarget = {
	local entity e;
	e = self;
	self = spawn();
	self.classname = "trigger_once";
	self.target = tname;
	trigger_once();
	self.think = FireTargetThink;
	self.nextthink = time + 0.5;
	self = e;
};

void(vector x, vector y) SpawnBlock = {
	local entity e;
	e = spawn();
	e.solid = SOLID_BBOX;
	e.movetype = MOVETYPE_NONE;
	setorigin(e, x);
	setsize(e, '0 0 0', y);
};

// <-- check
