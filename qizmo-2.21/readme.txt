Qizmo copyright 1998 Juha Kujala and Ilkka Rajala


What is it?

Qizmo is a QuakeWorld proxy, it works with network packets moving
between a QW client and a QW server. Qizmo is based on FAQ-Proxy 1.02
and is backward compatible. New major features: menu system, server
browser/pinger, voice channels, data compression, FPS boosting, and
lots of small stuff. Supported QW versions are: 2.0x, 2.1, 2.21, 2.29.

Shareware

Qizmo is shareware. Unregistered Qizmo has a timer that will
disconnect you after 15 minutes. When you register, you will
receive a registration code that disables the timer on any
Qizmo you connect to. The registration code can only be used
by one person at a time. If another person tries to use the
same reg. code at the same time, the first person will be
kicked off.

Registering

See REGISTER.txt for registering info.

Or if you want to register online now, you can register Qizmo at
<http://qizmo.sci.fi>. Just follow the "register" link.


DISCLAIMER

QIZMO IS SUPPLIED AS IS.  THE AUTHORS DISCLAIM ALL WARRANTIES,
EXPRESSED OR IMPLIED, INCLUDING, WITHOUT LIMITATION, THE WARRANTIES
OF MERCHANTABILITY AND OF FITNESS FOR ANY PURPOSE. THE AUTHORS ASSUME
NO LIABILITY FOR DAMAGES, DIRECT OR CONSEQUENTIAL, WHICH MAY RESULT
FROM THE USE OF QIZMO.



Installation

Just extract the package somewhere, quake dir works just fine if
you are lazy. :)


Running

1. Start qizmo:
   qizmo -a your_admin_password_here -b quake_directory
   That is the simplest form (see commandline options).
   Later on you can drop the admin password since it is
   saved in password.cfg.

2. Start qwcl (if you wish to use qizmo's sound system add -nosound
   on the qwcl commandline).

3. Type "connect localhost" in qwcl console.

4. You should now see the qizmo menu.
   Type "proxy:menu bindstd" in qwcl console.
   You can now move around the menus with the arrow keys.

5. Go to the acess rights menu and input the admin password
   to unlock all features.


Command line options

-a admin_password
Sets admin password. You only need to use this once, all
password are saved in password.cfg. If you have a password.cfg
from a previous version of the FAQ Proxy it will error with
invalid password.cfg. Delete the old version then re-setup the
password.


-b quake_dir
Tells qizmo where to find Quake files. Needed for sound stuff.
Defaults to current dir.

-c client_interface
If the host system has multiple ip's (e.g. dialup adapter
and network card) you can restrict client connections to only
one interface with this option.

-d default_rights_flags
The access rights clients have before entering a password.
You only need to set this once, it is saved in password.cfg.
Possible flags are: acromsptvx, see access rights menu for
more info.

-e demo_dir
Tells qizmo where to record demos. Defaults to quake_dir/qw
(see -b).

-h or -?
Displays list of commandline options.

-i priority_level
Sets qizmo priority level, 1-31. Higher number = more cpu time for
qizmo. In windows version only.

-l log_file_name
Creates a log file of qizmo console.

-m max_clients
Maximum number of clients allowed in the qizmo at the same time.
Default = 32.

-n name
Sets qizmo name (defaults to hostname), for "say name: blah"
commands, also visible in menu bars.

-p qizmo_port
Default = 27500.

-q
Quiet mode. Does not print anything on the console.
Helps keep glqwcl in the right window.

-r master_server_list
Reports qizmo to given master servers.

-s server_interface
Same as -c but for server connections.

-v
Verbose mode. Prints more stuff on the console.

-x TCP_port
If you wish to allow TCP connections to your qizmo set this.
Does not affect outward TCP connections.

-w
Use standard Windows wave audio instead of DirectSound.
May work better on some system.


Using menu

Qizmo comes with an easy to use menu system. All you need to do is
bind menu commands to your keys. There is an easy way to do this, by
just typing in the console "say proxy:menu bindstd". This will bind
menu keys to your arrowkeys, enter, backspace, insert, home, pageup,
pagedown, end, delete and pause. If you are not happy with this, you
can bind menu commands anywhere you want. Qizmo comes with example
"menu.cfg", where all menu commands are bound to same keys as in
"say proxy:menu bindstd". You just have to edit that, and then
"exec menu.cfg".

Now that you have your menu keys bound (I'm assuming here, that you
used proxy:menu bindstd to bind the menu commands to default keys),
you can move around the menu. If you don't see the menu, press "pause"
which is used to switch menu on/off. After you see the menu, use
arrowkeys to move around.  With "enter" you can go to deeper level in
menusystem, or choose action. "Delete" is used to delete some items,
like passwords or server sources, etc. "Backspace" moves back one
level in menu. Home, end, pageup and pagedown behave like they
normally do..

Some of the menus have additional Sub-menus.  These can be accessed by
using the left and right arrow keys if you have bound them to standard
key mappings.


Server browser

The server browser works pretty much like gamespy except that it is
10 times faster and 10 times more accurate. :) The problem with gamespy
is that it fetches serverinfos while pinging, which causes randomly inflated
pings. Qizmo on the other hand first pings the servers with small ping
packets and after that fetches all serverinfos. You can ping about 100
servers per second on a modem and 200 with isdn, without causing more than
10ms error in the pings. Try pinging 10 servers simultaneosly in gamespy
(on a modem/isdn link) and even servers running on the same machine might
report as much as 200ms ping difference. Remember the old saying: good
pings come in small packets. :)

  Control:

    Fast connect:
      Will ask you for a server address, and connect you there without
      having to mess with the server browser..

    Disconnect:
      Disconnect from server.

    Reconnect:
      Reconnect to last/current server.

    Mode:
      Toggle between spectator and player mode.

    TCP connect:
      Creates a TCP connection between two Qizmos. Some firewalls filter all
      UDP making playing Quake impossible. This feature was put in to solve
      that problem. You need to start qizmo with -x port_num to allow TCP
      connections in:
      qwcl <---> qizmo1 <---> firewall <---> qizmo2 <---> server
                 ^ tcpconnect qizmo2:port    ^ -x port on the commandline


  List:

    The serverlist. [delete] removes selected server from the list.
    [select] displays info for selected server:
                       
        Control:
          Obvious.

        Players:
          Obvious.

        Rules:
          Obvious.

        Sources:
          Here you can see/modify what source lists the selected
          server belongs to.


  Sort:

    Serverlist sort mode.


  Ping:

    Start pinging:
      Starts pinging current server list.

    Stop pinging:
      Stops pinging.

    Update sources:
      Refreshes server list from selected sources.

    Stop update:
      Stops serverlist refresh.


  Source:
    Sources list. [select] = toggle selected source in/out.
    [delete] = delete selected.

    Add source:
      You can add file (favorite list) or master sources with this.


  Setup:

    Ping timeout:
      Time, in milliseconds, to wait for a ping reply from a server.
      Servers that fail this will show a ping of 999 and will not
      be queried for serverinfo.

    Number of pings:
      Number of times to ping each server.
      The shown ping will be the average of all pings.

    Pings per second:
      Number of pings to send out per second.
      Good values are: 100 for modem, 200 for isdn, more for faster.
      (WARNING: some crappy modem/isdn drivers may choke at as low
       as 30 pings per sec.)

    Serverinfo timeout:
      Time, in milliseconds, to wait for a serverinfo reply.

    Serverinfo retries:
      Number of times to retry a failed serverinfo request.

    Simultaneous refreshes:
      Number of simultaneous serverinfo refreshes.
      Good values are: 10 for modem, 20 for isdn, ...

    Source update timeout:
      Time, in milliseconds, to wait for master server reply.

    Source update retries:
      Number of times to retry failed server list request.

    Keep dead servers:
      Time to keep nonresponsive servers in the serverlist.
      
    Keep serverinfos:
      Time to keep player/rule infos for a server.


Demo recording


The biggest advantage in recording games with proxy versus recording
with QWCL used to be that with QWCL you had to start recording the
demo before you were connected, which caused lots of extra trouble
when recording clan games etc. Now with QW2.2, QWCL can also start
recording games whenever you want, so that advantage is gone, but
there is still something you might find useful if you record with
Qizmo. You can change recording mode from "continuous", where all
levels are recorded in one big demo file, to "split levels", where
every level is recorded in separate file. Also, you don't have to do
the recording on the same machine you are playing on.


Lag settings

Qizmo makes it possible to increase your lag to compete fairly
against someone with higher ping. There has been lots of talk about
how LPB's can use this to "cheat" by "masking" that low ping. This
happens because most people don't know how to use this feature properly,
so I'm gonna teach you now.

Constant lag: Using only this increases your ping, but still gives you
constant ping, no matter how much data the server is sending to you,
so this is _not_ enough itself to simulate modem connection. You
should only use this to fine tune your ping, after other changes.

Bandwidth: This is important. To simulate 28800 modem connection, you
should set this to 28800. This tells Qizmo to increase lag more for
big packets, just like when using modem.
 
Packet loss: This will drop given percentage of packets randomly, but
isn't necessary to simulate slow connections.

So, to simulate 28800 modem connection, first you have to set your
"bandwidth" to 28800, then fine tune your ping with "constant lag",
and after that (this is very important!), set your rate (not Qizmo
command. You can change it from quake console with command 'rate') to
whatever you would use with connection you want to simulate! In this
case it would probably be 2500.

We understand of course that this system might not work perfectly.
You could easily make your ping high, and still have a better
connection than a modem player with same ping.  This could be done by
using only "Constant lag", and still keeping your high rate within
quake. This is why we have made some easy ways to control or disable
lag features in Qizmo from the server. If you say "f_lagreport" in
server, every player using Qizmo is forced to say their lag settings
on the server. You can also set server variables so that every player
who changes their lag settings is forced to report them, or you can
disable use of lag features on a server completely.  For more info
about this, see "Disabling Qizmo features" below.


Power-up timer

Power-up timer tells you when quad/pentagram/ring will respawn
next. You will get a centerprinted timer for each quad/pentagram/ring,
depending on which timers you have started of course.

"Autoreport" will report picked up powerups to your team mates so
that their timers will start if they didn't hear the pickup sound
themselves.

You can change timer layout with "start line", "line width",
"items/line" and "position" menu options.

For all you who are crying out "cheat!" now: the timer was put in to
level the playing field in team games and enhance team communication
(LAN clans can time the powerups easily with a dedicated timer person)
ie. make the game more fun for everyone, it is not meant as a cheating
tool or to be used in FFA games or duels (see "disabling qizmo features"
below).


Client list

List of people connected to the Qizmo.

Max Observers: Maximum number of clients allowed to observe through
your eyes.

Kick: kick someone observing you (or kick from the proxy (needs admin
rights))

Follow: Connect to the same server, or start observing the same player, as
someone else is currently viewing.

Observe: start observing

Server: brings up server menu for the selected server.


Voice channels

This is one of the coolest things Qizmo has to offer : Realtime voice
communication between Qizmo users. There is one limitation though.
All players who wish to talk to each other have to play through the
same Qizmo somewhere.  In addition to this you have to have Qizmo
running on your computer playing Quake sounds for you and recording
sounds from your microphone. So your setup should look like this:
client - Qizmo1 - Qizmo2 - server.

Qizmo1 is the proxy running on your own computer, and Qizmo2 is the
proxy where all the people you want to talk with are
connected. Firstly you have to tell Qizmo1 to start playing and
recording etc. See "Sound system" below for help on how to do that.

After you have sound working, tell Qizmo1 to connect to Qizmo2 (if you
are already connected, that's fine too). After that, make sure you see
Qizmo2 menu! This is important. You can move between Qizmo1 and Qizmo2
menus with "previous proxy" and "next proxy" in main menu. After you
are sure you are actually are in Qizmo2 menu, goto "Voice channels"
menu and then move to "join" using the left and right keys.  You
should either join a channel already in the list, or create new a
channel by hitting "new channel". Remember, everyone you want to talk
with has to be on the same channel as you AND in the same Qizmo
(Qizmo2 in this case). After this move to "bind" and select the
channel you are in. Qizmo will ask you which key you wish to bind the
talk functions to for that channel. Choose whatever key you want, and
after that you should be able to talk on that channel by keeping that
key pressed, and talking into your microphone.  If you forgot to run
qwcl with -nosound it will error with 'Sound capturing not
initialized'.

You can be on a maximum of 8 channels at any one time.

There is a special channel called "near" that always sends your
messages to people that are playing on the same server as you and
are visible from your current location.

Feedback will send your voice back to you (good for testing), and
autodrop rate drops your rate when you are talking to give voice
packets some extra bandwitdth.


Sound system

Sound system is available in windows versions only. Linux version has
some experimental sound code (sound playing might work), and full
Linux support is coming.

First of all, if you want to use any of these sound features, you
can't have any other application using your soundcard. So if you have
Quake running on the same computer, you have to use -nosound option
(qwcl -nosound) to start up quake. Secondly, if you want to use voice
stuff, you need to have a full duplex sound card (SB 16 or better
should do the job (with latest drivers)).

Play game sounds:
  Starts playing game sounds. If you don't start Qizmo from quake
  directory, you have to use Qizmo commandline option -b to define
  your Quake directory.

Play voice channels:
  Enables playing of voice channels. See description of voice
  channels above.

Sound capturing:
  Enables sound capturing.

Use DirectSound:
  Try with OFF setting if having problems.

Compatibility mode:
  More Quake like sounds. This mode is slower, and sound capturing
  doesn't (seem to) work with it.

Autodrop c2s rate:
  Drops client-to-server rate when talking on a voice channel.

Settings:

  Enhanced stereo:
    Plays stereo slightly differently (more 3D effect) than Quake
    normally does.

  Sound mix-ahead:
    Sound buffering. If the sound crackles (low fps) set this higher.

  Voice buffering:
    Determines how long you want to buffer voice messages before
    starting to play them (set higher if crackles = pl/slow link).

  Game snd volume:
    0% = silent, 100% = quake volume level, higher = more amplification
    and cutoff distortion.

  Voice volume:
    Voice output volume.
 
  Voice input gain:
    Voice input volume. Change this if _your_ voice is too quiet/loud
    in relation to other players.

  FX attenuation:
    How much you want to lower game sounds volume when playing voice
    channel messages.
  

Data compression

If you are playing through two Qizmos, you can compress all data
between them. Data compression ratio is about 60% in server-to-client
messages, and about 40% in client-to-server messages. For example, if
you have modem, you can have one Qizmo on your own computer, and from
there connect to some Qizmo which is running on other side of your
modem line (maybe on one of your ISP computers), and compress data
between them, and your modem line has to deal with 50% less data than
usual. This doesn't decrease ping too much, but it will allow you to
use higher rate, and your modem doesn't choke as easily as before in
battles.

If you want to use compression, you have to start compressing at the
Qizmo which is going to compress your data. So if you have setup like
this: client -> Qizmo1 -> Qizmo2 -> server, and you want to compress
server-to-client data, you have to put server-to-client compression on
at Qizmo2. If you want to compress client-to-server data, you have to
put compression on at Qizmo1. You can move between Qizmos from the
menu (previous proxy/next proxy).


Access rights

If you have access to a feature, that feature is shown in red,
and those you don't have access to, are shown in white.
 
Input password:
  Will ask you for a password.

Edit auth. data:
  Here you can password-protect some features. For example, recording
  a demo on your hard drive is probably something you don't want a
  stranger to do.

  You need admin rights to edit authorization data.

  There are two authorization ways, passwords and addresses (ip:port).

  You can use wildcards in IP authorization keys to match whole subnets.
  The most specific entry is always taken when multiple entries match.

  The password.cfg in the windows package auto-admins anyone coming
  from localhost:27001 (QWCL always binds to port 27001).


Teamplay help

Soundtrigger:
  Soundtrigger is a special character that triggers sound playing
  in say_team messages. For example, if you set soundtrigger to !
  your teammates can do 'say_team !player/death1.wav' and you will
  hear a death scream. You can put your own sounds to id1/sound
  directory.

View say_team %-codes:
  You can use the following codes to report your status to your
  teammates (only in say_team messages):

  %A : Armour type.
  %a : Armour.
  %b : Best Weapon and Ammo.
  %e : Number of enemies in your vicinity.
  %h : Current Health.
  %l : Nearest location from .loc file (or 'someplace' if none found).
  %n : Will only send the message to teammates in your vicinity.
  %o : Number of teammates in vicinity.
  %p : Powerups you have (quad, pent, ring, flag)
  %w : Weapon in Hand and Ammo you have.
  %x : Name of object you are looking at.
  %y : Location of object you are looking at.
  %g : Soon appearing powerups (15 sec) or 'quad' if none or timers off
  %i : Name and location of item you last picked up.
  %j : Name and location of item you last pointed to (%x at %y).
  %k : Name and location of item you last picked up or pointed to.
  %m : %k if less than 5 secs ago, nearest item otherwise
  %d : Where you last died.
  %r : Last reported location (%l).
  %S : Skin.
  %C : Color.
  %L,%O,%E : Like %l,%o,%e, but remembers the situation 5 secs after death.
  %q : Powerups of last seen enemy.

Team skin:
  Everyone who is in your team will have the skin you put here.
  Useful when playing mixed team games. (disabled in TF)

Enemy skin:
  Same as team skin but for enemies. (disabled in TF)

Message flash:
  Talking teammates give a small flash, like firing a weapon.

Drop missed %x's:
  Don't report 'nothing' if %x doesn't hit a target.

Loc:
  Display nearest mark:
    Displays nearest mark.

  Delete nearest mark:
    Deletes nearest mark.

  Mark current location:
    Marks current location.

  Mark with previous name:
    Marks current location with the name of the previous mark.

  %r/%b -> enemy/own|red/blue
    Toggles whether %r and %b in location name will be replaced
    with red/blue or enemy/own.

  Autoload locs:
    Toggles automatic .loc loading on levelchange.

  Include automarks:
    Toggles inclusion of automatic marks (weapons, armors,
    powerups, megahealths).

  Flush current marks:
    Clears all marks from memory. (.loc file isn't affected)

  Reload marks from .loc:
    Loads marks from <mapname>.loc

  Marking allows you to place a beacon on a spot where you are standing. You
  can then, using one of the report commands %l, tell your teammates which
  beacon you are currently closest to. This is useful in Team Games to allow
  increased teamwork and also better level coverage. The beacon is stored in
  a .loc file located in the directory where the proxy is located. The naming
  convention of it is related to the actual map name of the current map you
  are on:
  
  i.e DM6 would be DM6.LOC
  E1M4 would be E1M4.LOC
  PUNISH.BSP an external map would be PUNISH.LOC

Point:
  Items that can be pointed to (%x). (red = yes, white = no)

Pick:
  Items that will be reported by %i, %k or %m. (red = yes, white = no)


Observer mode

For best results, connect through a qizmo running on the same
machine as qwcl.

Smoothing value:
  Higher number gives smoother action but more lag.

Setangle threshold:
  This is too hard to explain. :) You don't usually need to change
  this.

Angle correction speed:
  If the view seems jump try lowering this.

Yaw offset:
  Yaw offset in degress.

Pitch offset:
  Pitch offset in degress.

Max centerprint lines:
  Cuts too long centerprints (if observee is using higher vid_mode).
  (QWCL will crash if you give it longer centerprints than fit on
   the screen.)

Set/Reset cl-variables.
  If you are observing this will set cl_ variables for observing.
  If you are not observer this will set cl_ variables for playing.

Stop observing:
  Guess what?


Misc stuff
  FPS/bandwidth settings

  Everyone knows that fps matters as much as ping in net games.
  Qizmo can boost your fps a lot by removing some "useless" effects
  or replacing them with others that are not that slow.

  Explosions: [normal|tarbaby|teleport|blood|off]
    The biggest fps hog with explosions is the dynamic lighting,
    even 'tarbaby' (no light effect) mode will give you +10 fps
    whenever an explosion happens. (Using 'teleport' or 'blood'
    mode will actually take more bandwidth, so use them only on
    a local proxy.)

  Powerup glow: [on|off]
    This will disable the dynamic lighting glow from your _own_
    powerups. May help as much as 20 fps.

  Muzzleflashes: [on|own off|all off]
    Removes the dynamic light effect caused by weapon fire.

  Gib filter: [on|off]
    If you have ever played DM6 DMM3 with >10 players you will
    appreciate this feature. :) Removes all gibs and dead bodies.
    Also saves bandwidth.

  Rockets: [normal|grenade]
    If in 'grenade' mode, will display rockets with the grenade
    model, which does not have a dynamic light effect.

  Userinfo filter: [on|off]
    Usually when someone changes their userinfo, the new settings
    are broadcast to every player on the server. This filter
    drops all 'noaim' (some people change noaim all the time
    for different weapons) or 'rate' (Qizmo spams these when
    'autodrop rate' is on) setinfos.

  Nail filter: [off|1/2|2/3|3/4]
    Filters off given amount of nails to save bandwidth. Nails
    don't usually compress very well, so you should be able to
    use higher rate with this filter.

  Damage filter: [on|off]
    Removes red flashes when getting hit. (GL users can achieve
    the same effect by setting gl_polyblend 0.) Also saves some
    bandwidth.

  Weapon impulses
 
  Are you using one of those 'alias best_weapon "impulse 2;wait;
  impulse 3;wait;imp...etcetcetc..;wait;impulse 8"' things? Qizmo
  can do that for you without going through all weapons to figure
  out which is the best weapon you have ammo for. Just go to weapon
  select impulses menu, and choose one of the 4 possible setups,
  and Qizmo will ask you for "number and list". For example, you
  can say "10 2345678", and next time you use impulse 20, Qizmo
  will choose the last weapon from that list you have ammo for. So
  it would be same as that long impulse2;wait;imp...etc list, but
  faster and more reliable..
  (This is only usable in mods that use the standard weapons.)


  Video mode (320x200|320x240|400x300)

  For bigger serverlists and stuff.
  (QWCL limits centerprints to 40 characters in width and 1024
  characters in total length, so support for higher video modes
  is currently impossible.)


  Config manager

  You can save all your settings here. The config is saved in
  cfg/player_name.cfg, and is automatically loaded when you connect.
  In the extra menu you can add custom config commands. The commands
  are regular proxy: commands. For example, if you add 'join x', you
  will automatically join voice channel x whenever you connect. There
  is also a special command called 'stuff', which can be used to make
  qwcl execute any console command. For example to enable c2s compression
  automatically, you would add 'stuff say proxy:packc2s 1' in the
  server side proxy.

  HUD clock:

  Places a time display on the HUD. You can move it around from
  the powerup timer menu.

  Player list

  Info about players playing on the same server as you.


  Admin setup

  Quake dir:
    You must set this if using voice stuff.

  Hostname:
    Name of the Qizmo as seen by a server browser.

  Qizmo name:
    The short name of the Qizmo. For use with say name: commands.
    Also visible in all the menus.

  Public:
    Toggle whether this Qizmo is public (listed on the public
    Qizmos master) or not.

  Qizmo priority level: (only in windows version)
    The default is 13, which is the only setting that QWSV priority
    control works with when in 'auto' mode under 95/98. Under NT you
    should set this to 16 or higher to avoid lag.

  QWSV priority control: (only in windows version)
    When you connect to localhost, Qizmo searches for QWSV, and if
    found starts controlling its priority level (to get rid of the
    usual packet loss). Qizmo gives QWSV time only after it has been
    sent a packet, so this might work a little better than the
    original QWSV priority control program.

  QWSV time slice: (only in windows version)
    The amount of processor time QWSV is given after it is sent
    a packet. 'auto' mode works only if Qizmo's priority level
    is 13.

  Save config:
    Saves current admin config.
  

Console commands

These are the console commands for Qizmo for those who don't want to use
the menu. Commands are given like this:

say proxy:[command] [arguments]

That command will be executed by the first Qizmo to receive it. If you
are connected through more than one Qizmo, and you want to give commands
to some later Qizmo in the chain, you have to do this:

say [Qizmo name]:[command] [arguments]

You can set the name with -n command line option, and you can see the
name from top right corner of the menu. Qizmo uses your computer name
as the default name.

As you can see, there isn't much explanations for those commands.
Everything can be controlled from the menu anyway. There are helps
available for some of those commands with "help" command. Just type:

say proxy:help [command]

connect
clients
c2spps
who
weaponimpulse
help
record
report
reconnect
disconnect
dropextra
talk
time
tcpconnect
voffset
follow
feedback
fps
observe
observers
kick
lag
menu
mmode
mark
mixahead
smooth
soundtrigger
initcapture
password
packc2s
packs2c
playsounds
part
join


Disabling Qizmo features

There are some features in Qizmo that some people consider cheating,
so we made a way to disable these features from the server. There is
a server variable, which can be used to do that. The variable is called
fpd and is set by typing at the console:

serverinfo fpd X

or if you have rcon for a server and do not have access directly to
the console :

rcon rcon_password serverinfo fpd X

Where X is a number created by a bitmask field. Bits are:

1 = Disable %-reporting
2 = Disable use of powerup timer
4 = Disable use of soundtrigger
8 = Disable use of lag features
16 = Make Qizmo report any changes in lag settins
32 = Silent %e enemy vicinity reporting (reporter doesn't see the message)
64 = Spectators can't talk to players and vice versa (voice)
128 = Silent %x and %y

For example, if you want to disable powerup timer, you would type at
server console: serverinfo fpd 2. Or if you want to disable powerup timer
and lag features, you would use: serverinfo fpd 10, because bits for timer
and for lag features combined (2+8) is 10..

On Team Fortress servers, %e and %x use bottomcolor to determine
team and %x won't report own players at all. Also skin forcing is
disabled. So detecting spies is impossible.


Contacting
 

Any questions/bugreports/problems can be mailed to <r151925@cc.tut.fi>.

Qizmo registrations are handled by a company called ShareIt <www.shareit.com>
Actually ShareIt is just collecting payments and user info from people who
register, and sending it to us. So if you have problems with that part of the
registration process you should first read <www.shareit.com/information.html>,
where you can find some of your questions answered, and if that doesn't
help, you can mail <register@shareit.com>. For other questions concerning the
registration process, mail <r151925@cc.tut.fi>.
 


Authors

Juha Kujala <jmkujala@cc.jyu.fi>
Ilkka Rajala <r151925@cc.tut.fi>



QUAKE© and QUAKEWORLD© are registered trademarks of Id Software, Inc.
QUAKE©, the stylized Q in QUAKE©, and the images depicted in QUAKE©
are the copyrighted, property of Id Software, Inc.
 
