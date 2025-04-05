void() healthtouch=
{

local float john;
local float skippy;

if ((other == self.owner) && (self.nextthink - time) > 29.5)
	return;

john = 25 + (random()*5);
if (other.classname != "player")
	return;

if (other.health > 275)
	return;

skippy = other.health+john;
if (skippy > 275)
	other.health = 275;
else
	other.health = skippy;
sound (other, CHAN_ITEM, "tw/mmmbeer.wav", 1, ATTN_NORM);

remove(self);
};

void() healthtoss=
{
local entity new;

new=spawn();
new.owner = self;
new.origin = self.origin;
new.movetype=MOVETYPE_BOUNCE;
new.solid=SOLID_TRIGGER;
makevectors(self.v_angle);
new.velocity = aim(self, 1000);
new.velocity =  new.velocity * 500;
setmodel (new, "progs/twregpak.mdl");
setsize (new, '-16 -16 0', '16 16 56');
new.nextthink=time + 30;
new.think=SUB_Remove;
new.touch = healthtouch;

self.packs = self.packs - 1;
};
// *check*
