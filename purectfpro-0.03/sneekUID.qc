// User IDs
//
// Sneek 17-Dec-2003, op verzoek van Majic + Dy?na.
//
// Player's .cfg entry / console command;
//   setinfo userkey 666
//
// Server's .cfg entries / console commands;
//   localinfo n41lgunn3r majic
//   localinfo 666 sneek
//   localinfo m4st3rh0oker dyna
//
// Toevoegingen source:
//   ergens in PutClientInServer (client.qc) oid een sneek_CheckUserID(self);
//   ergens in ImpulseCommands (weapons.qc) een sneek_CheckImpulses();

// Extra attributen voor entities.
.string	user_id;
.string user_name;
.string user_level;

// Prototype functions.
float (entity player) isGuest;
float (entity player) isRegular;
void (entity player, string logMessage) logBastard;
string (entity player) sneek_getTrueName;


// ------------------------------------------------------------


void (entity player) sneek_CheckUserID = {
//
// sneek_CheckUserID checks if an entity "player" is registered in the server as a regular or if this player is a guest.
//
// nb. Zit een hacky manier in om 1 keer een impulse-alias te stuffen naar een speler zodat ie easy alle players kan listen
//

	local string userName;

	player.user_id = infokey(player,"userkey");
	userName = infokey(world, player.user_id );
	if( userName == "" ) {
		if( player.user_level == "" ) {
			sprint(player, PRINT_HIGH, "\n\nYou are not identified as a regular.\n");
			sprint(player, PRINT_HIGH, "Type: setinfo userkey <userkey>\n");
			sprint(player, PRINT_HIGH, "Acquire a userkey by contacting...\n");
			sprint(player, PRINT_HIGH, "majic@quakeworld.nl\n");

			sprint(player, PRINT_HIGH, "\nShow regulars with: userlist\n");
			stuffcmd (player, "alias userlist \"impulse 210\"\n");
		}
		
		player.user_name = "";
		player.user_level = "guest";
	}
	else {
		if( player.user_level == "" ) {
			sprint(player, PRINT_HIGH, "\n\nWelcome back, ");
			sprint(player, PRINT_HIGH, userName );
			sprint(player, PRINT_HIGH, ".\n");

			sprint(player, PRINT_HIGH, "\nShow regulars with: userlist\n");
			stuffcmd (player, "alias userlist \"impulse 210\"\n");
		}
		
		player.user_name = userName;
		player.user_level = "regular";
	}

};

void (entity player) sneek_ShowAllUsers = {
//
// sneek_ShowAllUsers will list all connected users (and their regular name or guest status) to entity "player".
//

// PCP dyna - Spectator
	if (isGuest(self)) {
		sprint(self, PRINT_HIGH, "Only regulars can view the userlist.\nContact the admin to acquire a personal userkey and instructions.\n" );
		return;
	}
// PCP
	local string userName;
	local entity p;
	
	sprint(player, PRINT_HIGH, "Players (and their Userkey/status)\n\n");
// PCP dyna - Userlist header
	sprint(player, PRINT_HIGH, "players\n");
	sprint(player, PRINT_HIGH, "-------\n");
// PCP //
// PCP dyna - changed loop
        p = PLAYER_CHAIN;
// PCP //
	while ( p ) {
		if( p.netname != "" ) {
			sprint(player, PRINT_HIGH, p.netname );
	
			if( isGuest(p) ) {
				sprint(player, PRINT_HIGH, " (guest)" );
			}
			
			if( isRegular(p) ) {
				sprint(player, PRINT_HIGH, " (" );
				
				// ---Onderstaande is raar ja. Moet omdat QuakeWorld begint te dissen. Heb geen zin om het weer te leren na 5 jaar! Misschien is het QWSV, geen id, geen zin om Windows build te maken van MDSV ofzo!
				p.user_id = infokey(p,"userkey");
				userName = infokey(world, p.user_id );
				sprint(player, PRINT_HIGH, userName );
				// ---Hou bovenstaande 3 regels code bij elkaar. Trek het uit elkaar OP EIGEN RISICO! :-)
				
				sprint(player, PRINT_HIGH, ")" );
			}
	
			sprint(player, PRINT_HIGH, "\n" );
		}		
// PCP dyna - changed loop
		p = p.clientchain;
// PCP //
        }

// PCP dyna - Userlist spectators
	sprint(player, PRINT_HIGH, "\nspectators\n");
	sprint(player, PRINT_HIGH, "----------\n");
	p = find(world, classname, "spectator");
	while ( p ) { 
		if( p.netname != "" ) {
			sprint(player, PRINT_HIGH, p.netname );

			if( isGuest(p) ) {
				sprint(player, PRINT_HIGH, " (guest)" );
			}
		
			if( isRegular(p) ) {
				sprint(player, PRINT_HIGH, " (" );
			
				// ---Onderstaande is raar ja. Moet omdat QuakeWorld begint te dissen. Heb geen zin om het weer te leren na 5 jaar! Misschien is het QWSV, geen id, geen zin om Windows build te maken van MDSV ofzo!
				p.user_id = infokey(p,"userkey");
				userName = infokey(world, p.user_id );
				sprint(player, PRINT_HIGH, userName );
				// ---Hou bovenstaande 3 regels code bij elkaar. Trek het uit elkaar OP EIGEN RISICO! :-)
			
				sprint(player, PRINT_HIGH, ")" );
			}
	
			sprint(player, PRINT_HIGH, "\n" );
		}
		p = find (p, classname, "spectator");
	}
// PCP //

};

void () sneek_CheckImpulses = {
//
// helper function
//

	if( self.impulse == 210 )
		sneek_ShowAllUsers(self);
		
};

string (entity player) sneek_getTrueName = {

	local string userName;

	player.user_id = infokey(player,"userkey");
	userName = infokey(world, player.user_id );
	
	return userName;

};

float (entity player) isGuest = {
//
// helper function
//

	if( player.user_level == "guest" ) {
		return 1;
	} else {
		return 0; 
	}
	
};

float (entity player) isRegular = {
//
// helper function
//

	if( player.user_level == "regular" ) {
		return 1;
	} else {
		return 0; 
	}
	
};

void (entity player, string logMessage) logBastard = {
//
// does a debug print to server console with logMessage and displays player's truename
//
	local string userName;

	dprint("LOG [BASTARD]: ");
	dprint(player.netname);
	dprint(" (");
	
	if( isGuest(player) )
		dprint("guest");
	else {
		// ---Onderstaande is raar ja. Moet omdat QuakeWorld begint te dissen. Heb geen zin om het weer te leren na 5 jaar! Misschien is het QWSV, geen id, geen zin om Windows build te maken van MDSV ofzo!
		player.user_id = infokey(player,"userkey");
		userName = infokey(world, player.user_id );
		dprint(userName );
		// ---Hou bovenstaande 3 regels code bij elkaar. Trek het uit elkaar OP EIGEN RISICO! :-)
	}
	
	dprint("): ");
	dprint( logMessage );
	dprint("\n");

};