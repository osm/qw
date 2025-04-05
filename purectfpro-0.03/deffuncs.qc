// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterström 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************

// =================
//     FUNCTIONS
// =================
void(entity pl) StartStuffing;
void() TeamCaptureResetUpdate;
void() respawn;
entity() SelectRuneSpawnPoint;
void (float flag) Do_DropRune;		// tw50
void() RespawnAllRunes;
void() TeamCaptureRegenFlags;
void() ResetPingBans;
float(entity pl) IsAdmin;
void() AdminHelpCommands;
void() EndMatch;
void() StartAdminVote;
void() AdminVoted;
void() SuperAdmin;
void() PrintAdmin;
void() CheckMapChange;
void() CheckAdmin;
void() TeamCapturePlayerUpdate;
void() TeamCheckLock;
float() SwapCenterprint;
float(entity pl) UnsetObserver;
float(entity pl) SetObserver;
float(entity pl) IsObserver;
void() TeamFlagStatusReport;
entity(float disp) identify_player;
void() CompetitionHelpCommands;
void() RestoreMaxClients;
void(entity pl,string key, float val) setinfo;
void(entity pl, string key) unsetinfo;
void() PrintNewPlayerSettings;
void(entity pl) ShowScores;
void(string votetext, void() VoteFunction) StartVote;
void() VoteYes;
void() VoteNo;
void() StopVote;
void() Ready;
void() NotReady;
void() CompShowStatus;
float forceready;
void() CtfshowHelp;
void() SayReady;
void(entity pl) SetPlayerSpeed;
void() MultiWeapon_PreCache;
void() SpectatorCommands;
void() SuperCheck;
void(entity pl) AdminBan;
void() CheckBan;
void() CheckModel;
string(float Team) GetTeamColor;
void(float mask) RemoveAdmins;
void() CheckMapChange;
void() UnFreezeItems;
void() FreezeItems;
void() SetTeamParameters;
void(entity inflictor, entity attacker, float damage, entity ignore) T_RadiusDamage;
void() rittierodt;
void (entity rhook) Reset_Grapple;
void() RuneTouch;
void() RuneRespawn;
void() PainSound;
void() PlayerDie;
void() basedefend;		//tw50 -->
void() hayden;
void() whatrune;
void() menolike;		
entity() SelectTeleSpot;	//tw50 <--
void() Menu;
void() MenuImpulses;
void() CycleSpecTracking;
float(entity pl) IsSuperAdmin;
entity() FindFirstAdmin;
void() SUB_regen;
void() SUB_CalcMoveDone;
void() GrenadeExplode;
void() RuneRespawn;
void(float what) Freeze;
void(float what) UnFreeze;
void() StartMatch;
void(float tm, void() fun, string countdowntext) StartCountDown;
	// weapons.qc
void() W_ChangeWeapon;
void() PrintLocation;
void() CheatCommand;
void() CycleWeaponCommand;
void() ServerflagsCommand;
void() CycleWeaponReverseCommand;
void() PreviousWeaponCommand;
float() W_BestWeapon;
void() W_SetCurrentAmmo;
float() W_BestExWeapon;
void(vector org, vector dir) launch_flare;
void() SuperDamageSound;
void() HasteSound;
void() healthtoss;
entity(entity spot) TelefragSelectSpawnPoint;
void() TossBackpack;
void() TossWeapon;
void() RestartSameMap;
	// infovar.qc
void() CheckTeamplay;
	// teamplay.qc
float(entity targ, entity attacker) TeamFragPenalty;
void(entity targ, entity attacker) TeamDeathPenalty;
	// client.qc
void(entity pl) SetFreshItems;
	// arena.qc
entity() ArenaSpawn;
	// purectf.qc;
void(string tp, float x) bprintnum;
	// match.qc
void(entity pl) PrintCountDown;
	// arena.qc
float(entity pl) IsArenaPlayer;
void(entity pl) RemoveFromArenaPlayers;
void(entity pl) PutinQue;
void() ArenaThink;
float() ArenaHasPlayers;
	// spawn.qc
void(string clname, vector org, float spflags, float angl) SpawnItemComplete;
void (vector org, float fteam, float angl) SpawnFlag;
	// purectf.qc
float(string tp) IsArenamap;
float (string tp) IsCTFMap;
	// admin.qc
void(entity pl, string reason) KickClient;
	// teamplay.qc
void() CheckTopColor;
	// setinfo.qc
void (entity pl) SetPureFlags;
	// purectf.qc
void() UpdateClientChain;
	// Spectate.qc
void() SpectatorThink;
void(string trackthis, float finditem, float findflag) FindTrack;
	// status.qc
void(entity who, string s, float update) PrintStatusbar;
	// teamplay.qc
float() W_BestWeapon;
void() W_SetCurrentAmmo;
void() bound_other_ammo;
void(float o, float n) Deathmatch_Weapon;
void() BackpackTouch;
void() TeamCaptureResetUpdate;
	// teamplay.qc
float(entity attacker, entity targ, entity inflictor) SameTeam;
	// pingban.qc
void() CalcTeamPing;
	// status.qc
void(entity pl, string s1) TeamUpdateStatusbar;
	// admin.qc
entity(entity pl, float getme) PrintPlayerTeamList; 
entity(entity pl, float getme) PrintClientTeamList;
	// showdown.qc
void() ShowDownArena;
void() ShowDownCompetition;
void() ShowDownCTF;
void() ShowDownTW;
	// vote.qc
void() VoteBreak;
	// log.qc
void() GSLogStart;
void(entity pl) GSPlayer;
void(entity pl) GSPlayerConnect;
void(entity pl) GSPlayerLeft;
void() GSGameStart;
void() GSGameEnd;
void(entity logkiller, entity logtarget, string scoretype, string logweapon, float logscore) GSScore;
void(entity pl) LogTime;
void(entity p) LogFlagdrop;
void(entity pl) LogFlagdrop;
	// spawn.qc
void(string clname, vector org) SpawnItem;
void(vector org, float angl) spawn_dmstart;
void(vector org, float angl, string targ) spawn_teleport_destination;
entity(vector wallorg, float wallangle) SpawnVerticalWall;
	// mapqueue.qc
void() NextLevel;
void() GotoNextMap;
float() GameOver;
	// menu.qc
void() ToggleMenu;
	// commands.qc
void() ClientImpulses;
void() SpectatorImpulses;
void() DebugImpulses;
	// ctfshow.qc
float() CheckModeChange;
void(float tp, string key, float val) SetVar;
void() ShowDownCompetition;
void() SetShowdownDefault;
	// pingban.qc
float(entity pl) AveragePing;
	// printing.qc
void(float x) PrintTime2All;
void(entity pl, float x) PrintTime;
void(float x, float digits, string ch) bPrintRight;
void(entity pl, float x, float digits, string ch) sPrintRight;
	// items.qc
void() DropRune;
	// spectate.qc
string(entity pl) GetInventoryString;
	// admin.qc
void() RemoveAdminflags;
	// bot.qc
void() BotThink;
void() Spawn20Bots;
void() SpawnBot;
	// setinfo.qc
float(entity pl) HaveDemoProxy;
float (entity pl) ProxyType;
	// ctfshow.qc
void() ShowDownLockAutoShot;
void() ShowDownLockAutoDemo;
	// purectf.qc
void(string tp) soundall;
	// protos from client.qc
void () W_WeaponFrame;
void() W_SetCurrentAmmo;
void() player_pain;
void() player_stand1;
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;
void() StartMatch;
	// TW: base.qc
void() SetBaseZoneRadius;
void() DoBaseMojo;
	// TW: boom.qc
void() StartBoom;
void(float actiondelay, float bit2set) TWDelayedAction;
void() RemoveDelayedActions;
	// TW: twrunes.qc
void() CheckCloak;
void(entity targ) DecloakTarget;
	// subs.qc
void(vector tdest, float tspeed, void() func) SUB_CalcMove;
void(entity ent, vector tdest, float tspeed, void() func) SUB_CalcMoveEnt;
void(vector destangle, float tspeed, void() func) SUB_CalcAngleMove;
void()  SUB_CalcMoveDone;
void() SUB_CalcAngleMoveDone;
void() SUB_Null;
void() SUB_UseTargets;
void() SUB_Remove;
	// combat.qc
void(entity targ, entity inflictor, entity attacker, float damage) T_Damage;
float (entity e, float healamount, float ignore) T_Heal; // health function
float(entity targ, entity inflictor) CanDamage;
	// pingban.qc
void() CheckPing;
	// from infovar.qc
void() SaveDefaults;
void() ShowdownDefault;
void() COUNTDOWN_FUNC = {};
	// setinfo.qc
float(entity pl) CheckStuffflag;
	// commands.qc
void() DoStuffing;
	// timer.qc
void(entity pl) PrintTimeLeft;
void() SetTimeStrings;
void() StartTimer;
void() CheckTimers;
	// mapnames.qc
string(string shortname) FindMap;
	// nocheats.qc
void() JamWawTimer;
