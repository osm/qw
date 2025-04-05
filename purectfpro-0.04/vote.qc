// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterstrˆm 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************

//  check -->


float VOTE_YES = 1;
float VOTE_NO = 2;
float VOTE_START = 4;

float VOTED_YES;
float VOTED_NO;
float VOTED_NOTHING;

void() VOTE_FUNCTION = {};
string VOTE_TEXT;
entity VOTE_STARTER;
float VOTE_TIMEOUT;

float VOTEEXIT_FLAG;

void() ClearVote = {
	local entity e;
	e = PLAYER_CHAIN;
	while(e) {
		e.voted = e.voted - (e.voted & (VOTE_YES | VOTE_NO));
		e = e.clientchain;
	}
	VOTE_MAPT = "    ";
	VOTED_YES = 0;
	VOTED_NO = 0;
	VOTED_NOTHING = 0;
	VOTE_FUNCTION = SUB_Null;
	VOTE_TEXT = string_null;
	VOTE_STARTER = world;
	VOTE_TIMEOUT = 0;
};


void() CheckVotes = {
	local entity e;
// PCP dyna - UserID
//	local entity p;
// PCP //
	local float x;
	local string tp;
	VOTED_YES = 0;
	VOTED_NO = 0;
	VOTED_NOTHING = 0;
	e = PLAYER_CHAIN;
	while (e) {
// PCP dyna - UserID
//		if( isRegular(e) ) {
// PCP //
		if (e.voted & VOTE_YES)
			VOTED_YES = VOTED_YES + 1;
		else if (e.voted & VOTE_NO)
			VOTED_NO = VOTED_NO + 1;
		else
			VOTED_NOTHING = VOTED_NOTHING + 1;
// PCP dyna - UserID
//		}
// PCP //
		e = e.clientchain;
	}
	if (VOTED_YES > (VOTED_NO + VOTED_NOTHING)) {
// PCP dyna - UserID
	bprint(PRINT_HIGH, "Vote passed!\n");
//	p = PLAYER_CHAIN;
//	while (p) {
//		if( isRegular(p) ) {
//			sprint(p, PRINT_HIGH, "Vote passed!\n");	
//		}
//		p = p.clientchain;
//	}
// PCP //
		VOTE_FUNCTION();
		ClearVote();
	} else	if (VOTED_NO > (VOTED_YES + VOTED_NOTHING)) {
// PCP dyna - UserID
	bprint(PRINT_HIGH, " Vote Failed.\n");
//	p = PLAYER_CHAIN;
//	while (p) {
//		if( isRegular(p) ) {
//			sprint(p, PRINT_HIGH, " Vote Failed.\n");	
//		}
//		p = p.clientchain;
//	}
// PCP //
		ClearVote();
	} else {
		x = ceil((1+ VOTED_NO + VOTED_NOTHING - VOTED_YES) / 2);
		tp = ftos(x);
// PCP dyna - UserID
		bprint(PRINT_HIGH, " ");
		bprint(PRINT_HIGH, tp);
		bprint(PRINT_HIGH, " more vote");
		if (x > 1) bprint(PRINT_HIGH, "s");
		bprint(PRINT_HIGH, " are needed.\n");
//		p = PLAYER_CHAIN;
//		while (p) {
//			if( isRegular(p) ) {
//				sprint(p, PRINT_HIGH, " ");
//				sprint(p, PRINT_HIGH, tp);
//				sprint(p, PRINT_HIGH, " more vote");
//				if (x > 1)
//					sprint(p, PRINT_HIGH, "s are");
//				else
//					sprint(p, PRINT_HIGH, " is");
//				sprint(p, PRINT_HIGH, " needed.\n");
//			}
//			p = p.clientchain;
//		}
// PCP //
	}
};

void(string votetext, void() votefunction) StartVote = {
	local entity e;
// PCP dyna - UserID
//	if (isGuest(self)) {
//		sprint(self, PRINT_HIGH, "Only regulars are electable.\nContact the admin to acquire a personal UserID and instructions.\n" );
//		return;
//	}
// PCP //
	if (VOTE_TIMEOUT) {
		sprint(self, PRINT_HIGH,  "Vote already in progress.\n");
		return;
	}
//	if (self.voted & VOTE_START) {
//		sprint(self, PRINT_HIGH,  "You only get one vote per map\n");
//		return;
//	}
// stupid idea of 1 vote per map, maybe 3 votes per map?.

	VOTE_TEXT = votetext;
	VOTE_STARTER = self;
	VOTE_TIMEOUT = time + 30; //was 45
	VOTE_FUNCTION = votefunction;

// PCP dyna - UserID
	bprint(PRINT_HIGH, VOTE_STARTER.netname);
	bprint(PRINT_HIGH, " wants to ");
	bprint(PRINT_HIGH, VOTE_TEXT);
	if (VOTE_MAPT != "    ") {bprint (PRINT_HIGH,VOTE_MAPT);bprint (PRINT_HIGH,".");}
	bprint(PRINT_HIGH, " Type Ÿ≈” or Œœ to Vote. ");
//	e = PLAYER_CHAIN;
//	while (e) {
//		if( isRegular(e) ) {
//			sprint(e, PRINT_HIGH, VOTE_STARTER.netname);
//			sprint(e, PRINT_HIGH, " wants to ");
//			sprint(e, PRINT_HIGH, VOTE_TEXT);
//			sprint(e, PRINT_HIGH, " Type Ÿ≈” or Œœ to Vote.\n");
//			self.voted = VOTE_START | VOTE_YES;
//		}
//		e = e.clientchain;
//	}
// PCP //
	sprint(self, PRINT_HIGH, "Vote started. Stop it with 'ÛÙÔˆÔÙÂ'\n");
	self.voted = VOTE_START | VOTE_YES;
	CheckVotes();
};

void() StopVote = {
	if (self == VOTE_STARTER) {
		bprint(PRINT_HIGH, self.netname);
		bprint(PRINT_HIGH, " aborted the vote.\n");
		ClearVote();
	}
};

void() VoteYes = {
	if (self.voted & VOTE_YES)
		return;
	if (!VOTE_TIMEOUT)
		return;
	self.voted = (self.voted | VOTE_YES) - (self.voted & VOTE_NO);
	bprint(PRINT_HIGH, self.netname);
	bprint(PRINT_HIGH, " voted yes.");
	CheckVotes();
};
void() VoteNo = {
	if (self.voted & VOTE_NO)
		return;
	if (!VOTE_TIMEOUT)
		return;
	self.voted = (self.voted | VOTE_NO) - (self.voted & VOTE_YES);
	bprint(PRINT_HIGH, self.netname);
	bprint(PRINT_HIGH, " voted no.");
	CheckVotes();
};


void() VotedExitmap = {
	EndMatch();
};

void() StartVoteExit = {
	if (FLAG_COMPETITION) {
		sprint(self, PRINT_HIGH, "You can't voteexit in competition.\n");
	} else if (!FLAG_VOTEEXIT) {
		sprint(self, PRINT_HIGH, "Voteexit disabled.\n");
	} else if (VOTEEXIT_FLAG) {
		sprint(self, PRINT_HIGH, "Only one voteexit per map.\n");
	} else if (time < 10) {
		sprint(self, PRINT_HIGH, "You can't voteexit the first 10 seconds.\n");
	} else {
		VOTEEXIT_FLAG = 1;
		StartVote("exit this map.", VotedExitmap);
	}
};

void() VoteBreak = {
	// *check*
	if (VOTE_TIMEOUT)
		VoteYes();
	else {
		StartVote("break the game.", EndMatch);
	}
};

void() StartAdminVote = {
	if (self.admin & AD_ADMIN) {
		RemoveAdminflags();		// "admin" doubles as admin remover
	} else if (!FLAG_ADMINVOTE) {
		sprint(self, PRINT_HIGH, "Admin by vote disabled.\n");
	} else {
		StartVote("become an admin.", AdminVoted);
	}
};

void() StartVoteMap = {
	StartVote("change map to ", MapVoted);
};

// PCP dyna - VoteCenterprint
/*
float () VoteCenterprint = {
	local string s1,s2,s3,s4,s5,ss;
	if (!VOTE_TIMEOUT)
		return 0;
	if (self.voted & (VOTE_YES | VOTE_NO))
		return 0;
//	if (VOTE_MAPT != "    ") return 0;//dont show if voting for map
        if (FLAG_COMPETITION && !FLAG_STANDBY && !GameOver()) return 0;//dont show if in comp mode and game started
	s1 = VOTE_STARTER.netname;
	s2 = " wants to\n";
	s5 = string_null;
	if (VOTE_MAPT != "    ") {
	  s3 = VOTE_MAPT;
	  s5 = VOTE_TEXT;
        }else { 
          s3 = VOTE_TEXT;
        }
        
	s4 = "\n\nType Ÿ≈” or Œœ in the\nconsole to vote.\n";
	ss = "*****************************\n*****************************\n*****************************\n";
	centerprint7(self, ss, s1,s2,s5,s3,s4, ss);
	return 1;
};
*/
// PCP //

void()	CheckVoteTimeout = {
	if (VOTE_TIMEOUT > time)
		return;
	bprint(PRINT_HIGH, "Vote aborted. (timeout)\n");
	ClearVote();
};



//  <-- check
