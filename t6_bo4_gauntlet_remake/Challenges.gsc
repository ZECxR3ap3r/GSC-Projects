Open_Sesame() {
	level waittill("end_of_round");
	if(!flag( "OnPriDoorYar" ) && !flag( "OnPriDoorYar2" ) ) {
		if(!isdefined(level.allplayersdiedend)) {
			level.failedgauntletchallenge = 1;
			level notify("GauntletChallengeFailed");
			level.ReasonFailed = "Bus Depot was not opened!";
		}
	}
}

Speed_Demons() {
	level endon("GauntletChallengeOver");
	while(1) {
		zombies = getaiarray( level.zombie_team );
		for(i = 0;i < zombies.size;i++) {
			if(zombies[i].zombie_move_speed != "super_sprint") {
				zombies[i].zombie_move_speed = "super_sprint";
			}
		}
		wait 1;
	}
}

ResetSprint() {
	level waittill("start_of_round");
	self allowcrouch( 1 );
	self allowlean( 1 );
	self allowads( 1 );
	self allowsprint( 1 );
	self allowprone( 1 );
	self allowmelee( 1 );
}

Slowpoke() {
	level endon("GauntletChallengeOver");
	self endon("disconnect");
	self thread ResetSprint();
	while(1) {
		self allowcrouch( 1 );
		self allowlean( 1 );
		self allowads( 1 );
		self allowsprint( 0 );
		self allowprone( 1 );
		self allowmelee( 1 );
		wait .2;
	}
}

Shielded() {
	level waittill("end_of_round");
	foreach(player in level.players) {
		if(!player hasweapon("riotshield_zm")) {
			if(!isdefined(level.allplayersdiedend)) {
				level.failedgauntletchallenge = 1;
				level notify("GauntletChallengeFailed");
				level.ReasonFailed = "a Player didnt obtain the Shield!";
				break;
			}
		}
	}
}

Power_On() {
	level waittill("end_of_round");
	if(!flag( "power_on" ) ) {
		if(!isdefined(level.allplayersdiedend)) {
			level.failedgauntletchallenge = 1;
			level notify("GauntletChallengeFailed");
			level.ReasonFailed = "Power was not Turned on!";
		}
	}
}

Olympia_Only() {
	level endon("GauntletChallengeOver");
	self endon("disconnect");
	while(1) {
		if(self getcurrentweapon() != "rottweil72_zm" && self getcurrentweapon() != "rottweil72_upgraded_zm") {
			self setweaponammostock(self getcurrentweapon(), 0);
			self setweaponammoclip(self getcurrentweapon(), 0);
		}
		wait .05;
	}
}

GiveAmmoBack() {
	level waittill("GauntletChallengeOver");
	wait .1;
	foreach(player in level.players) {
		primaries = player getweaponslistprimaries();
		
		for(i = 0;i < primaries.size;i++) {
			self givemaxammo(primaries[i]);
			self setweaponammoclip(primaries[i], weaponclipsize(primaries[i]));
		}
	}
}

