// *****************************************************************
//  Pure CTF v1.99beta4 by Dan "Methabol" Zetterström 1998-08-??
//  Pure CTF Homepage: http://purectf.solgames.com/
//  Report bugs and ideas to: methabol@bt.nu
// *****************************************************************

// =================
//     FUNCTIONS
// =================

string(float x) getnum = {
	x = ceil(x);
	if (x < 33) {
		if (x == 0) return " 00";
		else if (x == 1) return " 01";
		else if (x == 2) return " 02";
		else if (x == 3) return " 03";
		else if (x == 4) return " 04";
		else if (x == 5) return " 05";
		else if (x == 6) return " 06";
		else if (x == 7) return " 07";
		else if (x == 8) return " 08";
		else if (x == 9) return " 09";
		else if (x == 10) return " 10";
		else if (x == 11) return " 11";
		else if (x == 12) return " 12";
		else if (x == 13) return " 13";
		else if (x == 14) return " 14";
		else if (x == 15) return " 15";
		else if (x == 16) return " 16";
		else if (x == 17) return " 17";
		else if (x == 18) return " 18";
		else if (x == 19) return " 19";
		else if (x == 20) return " 20";
		else if (x == 21) return " 21";
		else if (x == 22) return " 22";
		else if (x == 23) return " 23";
		else if (x == 24) return " 24";
		else if (x == 25) return " 25";
		else if (x == 26) return " 26";
		else if (x == 27) return " 27";
		else if (x == 28) return " 28";
		else if (x == 29) return " 29";
		else if (x == 30) return " 30";
		else if (x == 31) return " 31";
		else if (x == 32) return " 32";
	} 
	else if (x <= 40) return " 40";
	else if (x <= 50) return " 50";
	else if (x <= 60) return " 60";
	else if (x <= 70) return " 70";
	else if (x <= 80) return " 80";
	else if (x <= 90) return " 90";
	else if (x <= 100) return " 100";
	else if (x <= 110) return " 110";
	else if (x <= 120) return " 120";
	else if (x <= 130) return " 130";
	else if (x <= 140) return " 140";
	else if (x <= 150) return " 150";
	else if (x <= 160) return " 160";
	else if (x <= 170) return " 170";
	else if (x <= 180) return " 180";
	else if (x <= 190) return " 190";
	else if (x <= 200) return " 200";
	else if (x <= 210) return " 210";
	else if (x <= 220) return " 220";
	else if (x <= 230) return " 230";
	else if (x <= 240) return " 240";
	else if (x <= 250) return " 250";
	else if (x <= 260) return " 260";
	else if (x <= 270) return " 270";
	else if (x <= 280) return " 280";
	else if (x <= 290) return " 290";
	else if (x <= 300) return " 300";
	else if (x <= 400) return " 400";
	else if (x <= 500) return " 500";
	else if (x <= 600) return " 600";
	else if (x <= 700) return " 700";
	else if (x <= 800) return " 800";
	else if (x <= 900) return " 900";
	else return " 999";

};


string(float x) getnum2 = {
	x = ceil(x);
	if (x < 33) {
		if (x <= 0) return "00";
		else if (x == 1) return "01";
		else if (x == 2) return "02";
		else if (x == 3) return "03";
		else if (x == 4) return "04";
		else if (x == 5) return "05";
		else if (x == 6) return "06";
		else if (x == 7) return "07";
		else if (x == 8) return "08";
		else if (x == 9) return "09";
		else if (x == 10) return "10";
		else if (x == 11) return "11";
		else if (x == 12) return "12";
		else if (x == 13) return "13";
		else if (x == 14) return "14";
		else if (x == 15) return "15";
		else if (x == 16) return "16";
		else if (x == 17) return "17";
		else if (x == 18) return "18";
		else if (x == 19) return "19";
		else if (x == 20) return "20";
		else if (x == 21) return "21";
		else if (x == 22) return "22";
		else if (x == 23) return "23";
		else if (x == 24) return "24";
		else if (x == 25) return "25";
		else if (x == 26) return "26";
		else if (x == 27) return "27";
		else if (x == 28) return "28";
		else if (x == 29) return "29";
		else if (x == 30) return "30";
		else if (x == 31) return "31";
		else if (x == 32) return "32";
	} 
	else if (x <= 40) return "40";
	else if (x <= 50) return "50";
	else if (x <= 60) return "60";
	else if (x <= 70) return "70";
	else if (x <= 80) return "80";
	else if (x <= 90) return "90";
	else return "99";
};

string(float x) getnum3 = {
	x = ceil(x);
	if (x < 33) {
		if (x <= 0) return "  0";
		else if (x == 1) return "  1";
		else if (x == 2) return "  2";
		else if (x == 3) return "  3";
		else if (x == 4) return "  4";
		else if (x == 5) return "  5";
		else if (x == 6) return "  6";
		else if (x == 7) return "  7";
		else if (x == 8) return "  8";
		else if (x == 9) return "  9";
		else if (x == 10) return " 10";
		else if (x == 11) return " 11";
		else if (x == 12) return " 12";
		else if (x == 13) return " 13";
		else if (x == 14) return " 14";
		else if (x == 15) return " 15";
		else if (x == 16) return " 16";
		else if (x == 17) return " 17";
		else if (x == 18) return " 18";
		else if (x == 19) return " 19";
		else if (x == 20) return " 20";
		else if (x == 21) return " 21";
		else if (x == 22) return " 22";
		else if (x == 23) return " 23";
		else if (x == 24) return " 24";
		else if (x == 25) return " 25";
		else if (x == 26) return " 26";
		else if (x == 27) return " 27";
		else if (x == 28) return " 28";
		else if (x == 29) return " 29";
		else if (x == 30) return " 30";
		else if (x == 31) return " 31";
		else if (x == 32) return " 32";
	} 
	else if (x <= 40) return " 40";
	else if (x <= 50) return " 50";
	else if (x <= 60) return " 60";
	else if (x <= 70) return " 70";
	else if (x <= 80) return " 80";
	else if (x <= 90) return " 90";
	else if (x <= 100) return "100";
	else if (x <= 110) return "110";
	else if (x <= 120) return "120";
	else if (x <= 130) return "130";
	else if (x <= 140) return "140";
	else if (x <= 150) return "150";
	else if (x <= 160) return "160";
	else if (x <= 170) return "170";
	else if (x <= 180) return "180";
	else if (x <= 190) return "190";
	else if (x <= 200) return "200";
	else if (x <= 210) return "210";
	else if (x <= 220) return "220";
	else if (x <= 230) return "230";
	else if (x <= 240) return "240";
	else if (x <= 250) return "250";
	else if (x <= 260) return "260";
	else if (x <= 270) return "270";
	else if (x <= 280) return "280";
	else if (x <= 290) return "290";
	else if (x <= 300) return "300";
	else if (x <= 400) return "400";
	else if (x <= 500) return "500";
	else if (x <= 600) return "600";
	else if (x <= 700) return "700";
	else if (x <= 800) return "800";
	else if (x <= 900) return "900";
	else return " 999";
};

string(float x) getnum4 = {
	x = ceil(x);
	if (x < 33) {
		if (x == 0)       return "   0";
		else if (x == 1)  return "   1";
		else if (x == 2)  return "   2";
		else if (x == 3)  return "   3";
		else if (x == 4)  return "   4";
		else if (x == 5)  return "   5";
		else if (x == 6)  return "   6";
		else if (x == 7)  return "   7";
		else if (x == 8)  return "   8";
		else if (x == 9)  return "   9";
		else if (x == 10) return "  10";
		else if (x == 11) return "  11";
		else if (x == 12) return "  12";
		else if (x == 13) return "  13";
		else if (x == 14) return "  14";
		else if (x == 15) return "  15";
		else if (x == 16) return "  16";
		else if (x == 17) return "  17";
		else if (x == 18) return "  18";
		else if (x == 19) return "  19";
		else if (x == 20) return "  20";
		else if (x == 21) return "  21";
		else if (x == 22) return "  22";
		else if (x == 23) return "  23";
		else if (x == 24) return "  24";
		else if (x == 25) return "  25";
		else if (x == 26) return "  26";
		else if (x == 27) return "  27";
		else if (x == 28) return "  28";
		else if (x == 29) return "  29";
		else if (x == 30) return "  30";
		else if (x == 31) return "  31";
		else if (x == 32) return "  32";
	} 
	else if (x <= 40)  return "  40";
	else if (x <= 50)  return "  50";
	else if (x <= 60)  return "  60";
	else if (x <= 70)  return "  70";
	else if (x <= 80)  return "  80";
	else if (x <= 90)  return "  90";
	else if (x <= 100) return " 100";
	else if (x <= 110) return " 110";
	else if (x <= 120) return " 120";
	else if (x <= 130) return " 130";
	else if (x <= 140) return " 140";
	else if (x <= 150) return " 150";
	else if (x <= 160) return " 160";
	else if (x <= 170) return " 170";
	else if (x <= 180) return " 180";
	else if (x <= 190) return " 190";
	else if (x <= 200) return " 200";
	else if (x <= 210) return " 210";
	else if (x <= 220) return " 220";
	else if (x <= 230) return " 230";
	else if (x <= 240) return " 240";
	else if (x <= 250) return " 250";
	else if (x <= 260) return " 260";
	else if (x <= 270) return " 270";
	else if (x <= 280) return " 280";
	else if (x <= 290) return " 290";
	else if (x <= 300) return " 300";
	else if (x <= 400) return " 400";
	else if (x <= 500) return " 500";
	else if (x <= 600) return " 600";
	else if (x <= 700) return " 700";
	else if (x <= 800) return " 800";
	else if (x <= 900) return " 900";
	else return " 999";
};


string(float x) getnumsec = {
	x = ceil(x);

	if (x >= 60) {
		x = x - floor(x / 60);
		x = x * 60;
	}

	if (x < 30) {
		if (x <= 0) return ":00";
		else if (x == 1) return ":01";
		else if (x == 2) return ":02";
		else if (x == 3) return ":03";
		else if (x == 4) return ":04";
		else if (x == 5) return ":05";
		else if (x == 6) return ":06";
		else if (x == 7) return ":07";
		else if (x == 8) return ":08";
		else if (x == 9) return ":09";
		else if (x == 10) return ":10";
		else if (x == 11) return ":11";
		else if (x == 12) return ":12";
		else if (x == 13) return ":13";
		else if (x == 14) return ":14";
		else if (x == 15) return ":15";
		else if (x == 16) return ":16";
		else if (x == 17) return ":17";
		else if (x == 18) return ":18";
		else if (x == 19) return ":19";
		else if (x == 20) return ":20";
		else if (x == 21) return ":21";
		else if (x == 22) return ":22";
		else if (x == 23) return ":23";
		else if (x == 24) return ":24";
		else if (x == 25) return ":25";
		else if (x == 26) return ":26";
		else if (x == 27) return ":27";
		else if (x == 28) return ":28";
		else if (x == 29) return ":29";
	} else {
		if (x == 30) return ":30";
		else if (x == 31) return ":31";
		else if (x == 32) return ":32";
		else if (x == 33) return ":33";
		else if (x == 34) return ":34";
		else if (x == 35) return ":35";
		else if (x == 36) return ":36";
		else if (x == 37) return ":37";
		else if (x == 38) return ":38";
		else if (x == 39) return ":39";
		else if (x == 40) return ":40";
		else if (x == 41) return ":41";
		else if (x == 42) return ":42";
		else if (x == 43) return ":43";
		else if (x == 44) return ":44";
		else if (x == 45) return ":45";
		else if (x == 46) return ":46";
		else if (x == 47) return ":47";
		else if (x == 48) return ":48";
		else if (x == 49) return ":49";
		else if (x == 50) return ":50";
		else if (x == 51) return ":51";
		else if (x == 52) return ":52";
		else if (x == 53) return ":53";
		else if (x == 54) return ":54";
		else if (x == 55) return ":55";
		else if (x == 56) return ":56";
		else if (x == 57) return ":57";
		else if (x == 58) return ":58";
		else if (x == 59) return ":59";
	}
};


void(entity pl, string tp, float x) sprintnum = {
	local string tmp;
	tmp = ftos(x);
	sprint(pl, PRINT_HIGH, tp);
	sprint(pl, PRINT_HIGH, tmp);
	sprint(pl, PRINT_HIGH, "\n");
};

void(string tp, float x) bprintnum = {
	local string tmp;
	tmp = ftos(x);
	bprint(PRINT_HIGH, tp);
	bprint(PRINT_HIGH, tmp);
	bprint(PRINT_HIGH, "\n");
};

void(string tp, float x) bprintnumoff = {
	local string tmp;
	bprint(PRINT_HIGH, tp);
	if (x) {
		tmp = ftos(x);
		bprint(PRINT_HIGH, tmp);
	} else {
		bprint(PRINT_HIGH, "OFF");
	}
	bprint(PRINT_HIGH, "\n");
};

void(string tp, float x) bprintonoff = {
	bprint(PRINT_HIGH, tp);
	if (x)
		bprint(PRINT_HIGH, "ON\n");
	else
		bprint(PRINT_HIGH, "OFF\n");
};


void(string tp, float x) bprintpure = {
	bprint(PRINT_HIGH, tp);
	if (x == IS_PURE)
		bprint(PRINT_HIGH, "ON ");	
	else if (x == IS_OFF)
		bprint(PRINT_HIGH, "OFF");	
	else if (x == IS_OLD)
		bprint(PRINT_HIGH, "OLD");	
};


/*
==========
sPrintRight

Prints numbers formatted with a character to a player.
==========
*/

void(entity pl, float x, float digits, string ch) sPrintRight = {
	local string tmp;
	if ((digits > 6) && (x < 1000000)) sprint(pl, PRINT_HIGH, ch);
	if ((digits > 5) && (x < 100000)) sprint(pl, PRINT_HIGH, ch);
	if ((digits > 4) && (x < 10000)) sprint(pl, PRINT_HIGH, ch);
	if ((digits > 3) && (x < 1000)) sprint(pl, PRINT_HIGH, ch);
	if ((digits > 2) && (x < 100)) sprint(pl, PRINT_HIGH, ch);
	if (x >= 0)
		if ((digits > 1) && (x < 10)) sprint(pl, PRINT_HIGH, ch);
	
	tmp=ftos(x);
	if (x) 
		sprint(pl, PRINT_HIGH, tmp);
	else
		sprint(pl, PRINT_HIGH, "0");
};


void(float x, float digits, string ch) bPrintRight = {
	local string tmp;
	if ((digits > 6) && (x < 1000000)) bprint(PRINT_HIGH, ch);
	if ((digits > 5) && (x < 100000)) bprint(PRINT_HIGH, ch);
	if ((digits > 4) && (x < 10000)) bprint(PRINT_HIGH, ch);
	if ((digits > 3) && (x < 1000)) bprint(PRINT_HIGH, ch);
	if ((digits > 2) && (x < 100)) bprint(PRINT_HIGH, ch);
	if (x >= 0)
		if ((digits > 1) && (x < 10)) bprint(PRINT_HIGH, ch);
	
	tmp=ftos(x);
	if (x) 
		bprint(PRINT_HIGH, tmp);
	else
		bprint(PRINT_HIGH, "0");
};

//
// Prints a time formatted in mm:ss to a selected client.
//
void(entity pl, float x) PrintTime = {
	local float min, sec;
	local string tp;

	min = floor(x / 60);
	sec = floor(x - min * 60);
	
	sPrintRight(pl, min, 1, "0");
	sprint(pl, PRINT_HIGH, ":");
	sPrintRight(pl, sec, 2, "0");
};

//
// Prints a time formatted in mm:ss to all clients.
//
void(float x) PrintTime2All = {
	local float min, sec;
	local string tp;

	min = floor(x / 60);
	sec = floor(x - min * 60);
	
	bPrintRight(min, 1, "0");
	bprint(PRINT_HIGH, ":");
	bPrintRight(sec, 2, "0");
};


// *check* <--


