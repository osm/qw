// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterström 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************



void(entity player,entity tele) ObserverTeleporter =
{
  local entity targ;
  local vector v1,v2;
  
  v1 = ((tele.absmax + tele.absmin) * 0.5) - player.origin; normalize(v1);
  v2 = player.velocity; normalize(v2);
  if (v1 * v2 <= 0.1) return;
  
  targ = find (world, targetname, tele.target);
  if (!targ) {
    dprint("ObserverTeleportThroughTeleporter: couldn't find teleporter target\n");
    return;
  }
  makevectors (targ.mangle);
  setorigin (player, targ.origin);
  player.angles = targ.mangle;
  player.fixangle = TRUE; // turn this way immediately
  player.teleport_time = time + 0.7;
  player.velocity = v_forward * 300;
  // player.flags = player.flags - player.flags & FL_ONGROUND;
};


void(entity player,entity door) ObserverDoor =
{
  local entity d,d_master;
  local vector dmin,dmax;
    local float is_x,is_y,is_z,set;
    local vector dir,or;
  
  d_master = d = door.owner;
  if (d_master) {
    dmin = d_master.absmin;
    dmax = d_master.absmax;
  } else { 
    dmin = dmax = '0 0 0'; 
  }
  if (dmin != dmax) {
    // regular doors
    if (d_master.state != STATE_BOTTOM) return;
    do {
      // dprint (vtos(d.absmin)); dprint (" "); dprint (vtos(d.absmax)); dprint ("\n");
      if (d.absmin_x < dmin_x) { dmin_x = d.absmin_x; }
      if (d.absmax_x > dmax_x) { dmax_x = d.absmax_x; }
      if (d.absmin_y < dmin_y) { dmin_y = d.absmin_y; }
      if (d.absmax_y > dmax_y) { dmax_y = d.absmax_y; }
      if (d.absmin_z < dmin_z) { dmin_z = d.absmin_z; }
      if (d.absmax_z > dmax_z) { dmax_z = d.absmax_z; }
      d = d.enemy; // next linked door;
    } while ((d != d_master) && (d != world));
  }
  else {
    // secret doors
    // we ignore these currently
    return;
  }
  
    set = is_x = is_y = is_z = FALSE;
    or = player.origin;
    if (dmin_x + 15 < player.absmin_x && player.absmax_x < dmax_x - 15) is_x = TRUE;
    if (dmin_y + 15 < player.absmin_y && player.absmax_y < dmax_y - 15) is_y = TRUE;
    if (dmin_z + 15 < player.absmin_z && player.absmax_z < dmax_z - 15) is_z = TRUE;
    // dprint("doors:  "); dprint (vtos(dmin)); dprint (" "); dprint (vtos(dmax)); dprint ("\n");
    // dprint("player: "); dprint (vtos(player.absmin)); dprint (" "); dprint (vtos(player.absmax)); dprint ("\n");
    if (is_x && is_y) {
      // dprint("door is in xy plane\n");
      if      (or_z < dmin_z) { dir = '0 0  1'; or_z = dmax_z + 25; }
      else if (or_z > dmax_z) { dir = '0 0 -1'; or_z = dmin_z - 25; }
      set = TRUE;
    }
    else if (is_x && is_z) {
      // dprint("door is in xz plane\n");
      if      (or_y < dmin_y) { dir = '0  1 0'; or_y = dmax_y + 25; }
      else if (or_y > dmax_y) { dir = '0 -1 0'; or_y = dmin_y - 25; }
      set = TRUE;
    }
    else if (is_y && is_z) {
      // dprint("door is in yz plane\n");
      if      (or_x < dmin_x) { dir = ' 1 0 0'; or_x = dmax_x + 25; }
      else if (or_x > dmax_x) { dir = '-1 0 0'; or_x = dmin_x - 25; }
      set = TRUE;
    }
      if (set) { 
		local vector v;
		v =  normalize(player.velocity);
		if (dir * v < 0.5) return;
		player.origin = or;
		setorigin (player, player.origin);
      }
};


float(entity pl) IsObserver = {
	return (pl.classname == "observer");
};

void(entity pl) SetObserverColor = {
	if (!pl.oldcolors)
		pl.oldcolors = stof(infokey(pl, "topcolor"));
	stuffcmd(pl, "color 0");
};

float(entity pl) SetObserver = {
	DropRune();
	TeamCaptureDropFlagOfPlayer(self);

	pl.classname = "observer";

	pl.health           = 999;
	pl.takedamage       = DAMAGE_NO;
	pl.solid            = SOLID_NOT;
	pl.movetype         = MOVETYPE_FLY;
	pl.deadflag         = DEAD_NO;
	setmodel (pl, string_null);

	pl.weaponmodel      = "";
	pl.weaponframe      = 0;
	pl.weapon           = 0;

	SetObserverColor(pl);
	bprint(PRINT_HIGH, self.netname);
	bprint(PRINT_HIGH, " has become an observer.\n");

	if (FLAG_STANDBY)
		CheckReady();
};

float(entity pl) SetKilledObserver = {
	pl.classname = "observer";
	SetObserverColor(pl);
	pl.goalentity = world;
};



float(entity pl) UnsetObserver = {
	local string tp;
	local float x,y;

	pl.player_flag = pl.player_flag | PF_STUFFCOLOR;
	pl.classname = "player";
	pl.player_flag = pl.player_flag | (PF_KILLMERESTART);
	bprint(PRINT_HIGH, self.netname);
	bprint(PRINT_HIGH, " is no longer an observer.\n");
};


void() SwapObserver = {
	if (!AccessAdmin()) {
		return;
	} else if (self.classname == "spectator") {
		sprint(self, PRINT_HIGH, "Spectators can't do this.\n");
	} else if (self.classname == "observer") {
		UnsetObserver(self);
	} else {
		SetObserver(self);
	}
}; 


void() ObserverFly = {

	makevectors(self.v_angle);

	self.velocity = normalize(v_forward) * 1000;

};


void() ObserverThink = {
	local entity e;
	local float cont;

	self.weaponmodel = "";
	self.weaponframe = 0;

	if (self.goalentity) {			// Track
		SpectatorThink();
	} else {
		SpectatorImpulses();
		if (IsObserver(self) && self.button0)
			ObserverFly();
		e = findradius(self.origin,75);
		while (e != world) {
			if (e.classname == "door") {
				ObserverDoor(self, e);
				e = world;
			}
    			if (e.classname == "trigger_teleport") {
				ObserverTeleporter(self,e);
				e = world;
			}	
			e = e.chain;
			if (!e) e = world;
		}
		SetGravity(self, 1);
	}
	self.impulse = 0;
};


// *check*
