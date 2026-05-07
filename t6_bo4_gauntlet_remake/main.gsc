#include codescripts/struct;
#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zombies/_zm_melee_weapon;
#include maps/mp/_zm_transit_bus;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/gametypes_zm/_globallogic;
#include maps/mp/gametypes_zm/_weapons;
#include maps/mp/zombies/_zm_powerups;
#include maps/mp/zombies/_zm_buildables;
#include maps/mp/zombies/_zm_equipment;
#include maps/mp/zombies/_zm_pers_upgrades_functions;
#include maps/mp/zombies/_zm_game_module;
#include maps/mp/zombies/_zm_score;
#include maps/mp/zombies/_zm_stats;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/zombies/_zm_weap_cymbal_monkey;
#include maps/mp/zombies/_zm_weapons;
#include maps/mp/gametypes_zm/_spawning;
#include maps/mp/zombies/_zm_spawner;
#include maps/mp/zombies/_zm;
#include maps/mp/zombies/_zm_perks;
#include maps/mp/zombies/_zm_zonemgr;
#include maps/mp/zombies/_zm_magicbox;
#include maps/mp/zombies/_zm_weap_claymore;
#include maps/mp/zombies/_zm_ai_avogadro;
#include maps/mp/zombies/_zm_audio;
#include maps/mp/zombies/_zm_power;
#include maps/mp/zombies/_zm_laststand;
#include maps/mp/zombies/_zm_devgui;
#include maps/mp/zombies/_zm_weap_jetgun;
#include maps/mp/zombies/_zm_weap_thundergun;
#include maps/mp/zombies/_zm_ai_dogs;
#include maps/mp/zombies/_zm_unitrigger; 
#include maps/mp/zombies/_zm_ai_screecher; 
#include maps/mp/zombies/_zm_ai_basic; 
#include maps/mp/zm_transit_bus; 
#include maps/mp/zombies/_zm_blockers; 
#include maps/mp/zombies/_zm_weap_jetgun; 
#include maps/mp/gametypes_zm/_rank;
#include maps/mp/gametypes_zm/_globallogic;
#include maps/mp/_utility;
#include maps/mp/gametypes_zm/_zm_gametype;
#include maps/mp/animscripts/zm_utility;

init() {
	precacheshader("hud_status_dead");
	precacheshader("hud_icon_sticky_grenade");
	precacheshader("specialty_doublepoints_zombies");
	precacheshader("emblem_bg_default");
	precacheshader("hud_grenadeicon");
	precacheshader("white");
	precacheshader("menu_mp_lobby_icon_customgamemode");
	precacheshader("hud_cymbal_monkey");
	precacheshader("hud_empgrenade");
	precacheshader("damage_feedback");
	precacheshader("gradient_center");
	precacheshader("zombies_rank_1");
	precacheshader("zombies_rank_2");
	precacheshader("zombies_rank_3");
	precacheshader("zombies_rank_3_ded");
	precacheshader("zombies_rank_4");
	precacheshader("zombies_rank_4_ded");
	precacheshader("zombies_rank_5");
	precacheshader("waypoint_revive");
	precacheshader("gradient_fadein");
	precacheshader("specialty_juggernaut_zombies_pro");
	precacheshader("specialty_quickrevive_zombies_pro");
	precacheshader("specialty_fastreload_zombies_pro");
	precacheshader("scorebar_zom_1");
	precacheshader("black");
	precacheshader("zombies_rank_5_ded");
	precacheshader("riotshield_zm_icon");
	precacheshader("gradient");
	precacheshader("specialty_instakill_zombies");
	precacheshader("menu_mp_lobby_frame_circle");
	precacheshader("line_horizontal");
	precacheshader("hud_icon_colt");
	
	level.zombie_vars["zombie_score_damage_normal"] = 0;
	level.zombie_vars["zombie_score_damage_light"] = 0;
	level.GauntletStrings = [];
	level.GauntletStrings["SoloDown"] = "Player went down";
	AddChallenge("", "", undefined, 1); // for a challenge on round 0 O_o
	switch(level.script) {
		case "zm_transit":
			AddChallenge("OPEN SESAME", "Open the Bus Depot before the Round Ends", ::Open_Sesame, 1, undefined);
			AddChallenge("SPEED DEMONS", "Survive the Sprinters", ::Speed_Demons, 1, undefined);
			AddChallenge("SLOWPOKE", "Sprinting is Disabled", ::Slowpoke, 0, undefined);
			AddChallenge("SHIELDED", "Possess the Shield at the End of the Round", ::Shielded, 1, ::PlayerDownedFail);
			AddChallenge("POWER TRIP", "Activate Power before the Round Ends", ::Power_On, 1, undefined);
			AddChallenge("POWER TRIP", "Use the Olympia Only", ::Olympia_Only, 0, ::GiveAmmoBack);
	}
	level.ui_better_orange = (0.898,0.643,0.169);
	level.ui_better_red = (0.678,0.012,0.031);
	level.CurrentFails = 0;
    level thread onPlayerConnect();
    level.CRoundNumber = create_simple_hud();
    level.GauntletHUDS = [];
    level.GauntletHUDS["Title"] = create_simple_hud();
    level.GauntletHUDS["Title"].color = level.ui_better_orange;
    level.GauntletHUDS["Title"].Codename = "Title";
    level.GauntletHUDS["Title"].lefty = 75;
    level.GauntletHUDS["Title"].Hidewheninmenu = 1;
    level.GauntletHUDS["Challenge"] = create_simple_hud();
    level.GauntletHUDS["Challenge"].color = (0.702,0.702,0.718);
    level.GauntletHUDS["Challenge"].Codename = "Desc";
    level.GauntletHUDS["Challenge"].lefty = 100;
    level.GauntletHUDS["Challenge"].Hidewheninmenu = 1;
    level.GauntletHUDS["Bar"] = create_simple_hud();
    level.GauntletHUDS["Bar"].color = level.ui_better_orange;
    level.GauntletHUDS["Bar"].Codename = "Bar";
    level.GauntletHUDS["Bar"].lefty = 95;
    level.GauntletHUDS["Bar"].Hidewheninmenu = 1;
    level.GauntletHUDS["FailedTitle"].Hidewheninmenu = 1;
    level.GauntletTimer = create_simple_hud();
    level.GauntletTimer.alignx = "right";
	level.GauntletTimer.aligny = "top";
	level.GauntletTimer.horzalign = "fullscreen";
	level.GauntletTimer.vertalign = "fullscreen";
	level.GauntletTimer.x = 620;
	level.GauntletTimer.y = 20;
	level.GauntletTimer.fontscale = 1.3;
	level.GauntletTimer.alpha = 1;
	level.GauntletTimer.color = level.ui_better_orange;
	level.GauntletTimer.Hidewheninmenu = 1;
	level.no_end_game_check = true;
	level._game_module_game_end_check = ::prevent_end_game;
	thread disable_pers_upgrades();
    level thread CustomRoundNumber();
    level thread GauntletHUDHandler();
    level thread GauntletChallengeHandler();
    level thread GauntletChallengeFailHandler();
    flag_wait( "start_zombie_round_logic" );
    level thread AllPlayersDownedHandler();
    level notify("end_round_think");
    wait 1;
    level.GauntletHUDS["Title"] thread GauntletHUDHandler(130, 1.7);  
    level.GauntletHUDS["Challenge"] thread GauntletHUDHandler(155, 1);  
    level.GauntletHUDS["Bar"] thread GauntletHUDHandler(150);  
    level thread round_think();
}

onPlayerConnect() {
    for(;;) {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned() {
    self endon("disconnect");
	level endon("game_ended");
	self.initialspawn = 0;
    for(;;) {
        self waittill("spawned_player");
        if(self.initialspawn == 0) {
        	self.initialspawn = 1;
        	wait 0.5;
        	self setclientuivisibilityflag("hud_visible", 0);
			flag_wait("initial_blackscreen_passed");
			self thread zone_hud();
			self thread HealthBar();
			self thread upgrade_visuals();
			self thread WeaponHud();
			self thread TrackAmmoStuff();
			self thread PlayerDownedWatcher();
			self thread disable_player_pers_upgrades();
			self thread upgrade_crosshair();
			self thread set_hitmarker();
			self setclientuivisibilityflag("hud_visible", 0);
        }
    }
}

disable_pers_upgrades() {
	level waittill("initial_disable_player_pers_upgrades");

	level.pers_upgrades_keys = [];
	level.pers_upgrades = [];
}

disable_player_pers_upgrades() {
	if (isDefined(self.pers_upgrades_awarded)) {
		upgrade = getFirstArrayKey(self.pers_upgrades_awarded);
		while (isDefined(upgrade)) {
			self.pers_upgrades_awarded[upgrade] = 0;
			upgrade = getNextArrayKey(self.pers_upgrades_awarded, upgrade);
		}
	}

	if (isDefined(level.pers_upgrades_keys)) {
		index = 0;
		while (index < level.pers_upgrades_keys.size) {
			str_name = level.pers_upgrades_keys[index];
			stat_index = 0;
			while (stat_index < level.pers_upgrades[str_name].stat_names.size) {
				self maps/mp/zombies/_zm_stats::zero_client_stat(level.pers_upgrades[str_name].stat_names[stat_index], 0);
				stat_index++;
			}
			index++;
		}
	}

	level notify("initial_disable_player_pers_upgrades");
}

prevent_end_game() {
	return false;
}

AllPlayersDownedHandler() {
	while(1) {
		count = 0;
		for(i = 0;i < level.players.size;i++) {
			if ( !level.players[ i ] maps/mp/zombies/_zm_laststand::player_is_in_laststand() && level.players[ i ].sessionstate != "spectator" )
				count += 1;
		}
		
		if ( count == 0 ) {
			level.ReasonFailed = "All Players Died!";
			level notify("GauntletChallengeFailed");
			level.allplayersdiedend = 1;
			level.failedgauntletchallenge = 1;
			level.zombie_total = 0;
			zombies = getaiarray( level.zombie_team );
			foreach(zomb in zombies)
				zomb dodamage(zomb.health + 666, zomb.origin );
			foreach(player in level.players)
				player.bleedout_time = 999999999;
			
			level waittill("FailedScreenOver");
			foreach(player in level.players) {
				level thread spectators_respawn();
				player maps/mp/zombies/_zm_laststand::auto_revive( player );
        		player [[level.spawnplayer]]();
        	 	thread maps\mp\zombies\_zm::refresh_player_navcard_hud();
			}
			level.allplayersdiedend = undefined;
		}
		wait 1;
	}
}

SaveCurrentStuff() {
	self.StartScore = self.score;
	self.StartOrigin = self.origin;
	self.StartAngles = self getplayerangles();
	self.StartStance = self getstance();
	self.StartPerks = self get_player_perk_list();
	self.StartEquipment = self get_player_equipment();
	self.StartWeaponWeapons = self getweaponslistprimaries();
	if(isdefined(self.StartWeaponWeapons[0])) {
		self.StartAmmoClipFirst = self GetWeaponAmmoClip(self.StartWeaponWeapons[0]);
		self.StartAmmoStockFirst1 = self GetWeaponAmmoStock(self.StartWeaponWeapons[0]);
	}
	if(isdefined(self.StartWeaponWeapons[1])) {
		self.StartAmmoClipSecond = self GetWeaponAmmoClip(self.StartWeaponWeapons[1]);
		self.StartAmmoStockSecond = self GetWeaponAmmoStock(self.StartWeaponWeapons[1]);
	}
	self.StartGrenade = self get_player_lethal_grenade();
	self.StartGrenadeAmmo = self GetWeaponAmmoStock(self get_player_lethal_grenade());
	self.StartSecondary = self get_player_tactical_grenade();
	self.StartSecondaryAmmo = self GetWeaponAmmoStock(self get_player_tactical_grenade());
}

get_player_perk_list() {
    a_perks = [];

    if ( isdefined( self.disabled_perks ) && isarray( self.disabled_perks ) ) {
        a_keys = getarraykeys( self.disabled_perks );

        for ( i = 0; i < a_keys.size; i++ ) {
            if ( self.disabled_perks[a_keys[i] ] )
                a_perks[a_perks.size] = a_keys[i];
        }
    }

    if ( isdefined( self.perks_active ) && isarray( self.perks_active ) )
        a_perks = arraycombine( self.perks_active, a_perks, 0, 0 );

    return a_perks;
}

GauntletChallengeHandler() {
	level endon("end_game");
	while(1) {
		level waittill("start_of_round");
		level.fallbacktime = int(gettime() / 1000);
		level notify("GauntletChallengeOver");
		if(isdefined(level.GauntletChallenges[level.round_number].FailCall) && level.players.size != 1)
			level thread [[ level.GauntletChallenges[level.round_number].FailCall ]]();
		
		if(level.GauntletChallenges[level.round_number].Side == 1) {
			level thread [[ level.GauntletChallenges[level.round_number].Function ]]();
			foreach(player in level.players) {
				if(!isdefined(level.allplayersdiedend) && !isdefined(level.failedgauntletchallenge))
					player SaveCurrentStuff();
			}
		}
		else {
			foreach(player in level.players) {
				player thread [[ level.GauntletChallenges[level.round_number].Function ]]();
				if(!isdefined(level.allplayersdiedend) && !isdefined(level.failedgauntletchallenge))
					player SaveCurrentStuff();
			}
		}
	}
}

PlayerDownedFail() {
	level endon("GauntletChallengeOver");
	while(1) {
		for(i = 0;i < level.players.size;i++) {
			if ( level.players[ i ].sessionstate == "spectator" ) {
				level.ReasonFailed = "^1" + level.players[ i ].name + " ^7Died!";
				level notify("GauntletChallengeFailed");
				level.allplayersdiedend = 1;
				level.failedgauntletchallenge = 1;
				level.zombie_total = 0;
				zombies = getaiarray( level.zombie_team );
				foreach(zomb in zombies)
					zomb dodamage(zomb.health + 666, zomb.origin );
				foreach(player in level.players)
					player.bleedout_time = 999999999;
			
				level waittill("FailedScreenOver");
				foreach(player in level.players) {
					level thread spectators_respawn();
					player maps/mp/zombies/_zm_laststand::auto_revive( player );
        			player [[level.spawnplayer]]();
        	 		thread maps\mp\zombies\_zm::refresh_player_navcard_hud();
				}
				level.allplayersdiedend = undefined;
				break;
			}
			wait .1;
		}
		wait 1;
	}
}

RestoreData() {
	wait .1;
	a_current_perks = self get_player_perk_list();
    foreach ( perk in a_current_perks ) {
    	self unsetperk(perk);
    	self notify( perk + "_stop" );
    }
	self.score = self.StartScore;
	self setorigin(self.StartOrigin);
	self setplayerangles(self.StartAngles);
	self setstance(self.StartStance);
	if(isdefined(self.StartPerks)) {
		foreach(perk in self.StartPerks)
			self give_perk(perk, 0);
	}
	self takeallweapons();
	self giveweapon( "knife_zm" );
	
	if(isdefined(self.StartEquipment))
		self equipment_buy(self.StartEquipment);
	
	if(isdefined(self.StartWeaponWeapons[0])) {
		self giveweapon(self.StartWeaponWeapons[0]);
		self SetWeaponAmmoClip(self.StartWeaponWeapons[0], self.StartAmmoClipFirst);
		self SetWeaponAmmoStock(self.StartWeaponWeapons[0], self.StartAmmoStockFirst1);
	}
	if(isdefined(self.StartWeaponWeapons[1])) {
		self giveweapon(self.StartWeaponWeapons[1]);
		self SetWeaponAmmoClip(self.StartWeaponWeapons[1], self.StartAmmoClipSecond);
		self SetWeaponAmmoStock(self.StartWeaponWeapons[1], self.StartAmmoStockSecond);
	}
	self set_player_lethal_grenade(self.StartGrenade);
	self giveweapon(self.StartGrenade);
	self SetWeaponAmmoClip(self.StartGrenade, self.StartGrenadeAmmo);
	
	self set_player_tactical_grenade(self.StartSecondary);
	self giveweapon(self.StartSecondary);
	self SetWeaponAmmoClip(self.StartSecondary, self.StartSecondaryAmmo);
}

GauntletChallengeFailHandler() {
	while(1) {
		level waittill("GauntletChallengeFailed");
		level.round_number = level.round_number - 1;
		level.zombie_total = 0;
	}
}

FailedScreen() {
	level.GauntletTimer.alpha = 0;
	foreach(player in level.players) {
		player freezecontrols(1);
		player EnableInvulnerability();
		player setclientuivisibilityflag("hud_visible", 0);
	}
	FailedTitle = create_simple_hud();
    FailedTitle.alignx = "center";
    FailedTitle.aligny = "middle";
    FailedTitle.horzalign = "fullscreen";
    FailedTitle.vertalign = "fullscreen";
    FailedTitle.x = 320;
    FailedTitle.y = 50;
    FailedTitle.alpha = 1;
    FailedTitle.color = (1,0,0);
    FailedTitle.fontscale = 2.3;
    FailedTitle settext("Round Failed");
    
    FailedLine = create_simple_hud();
    FailedLine.alignx = "center";
    FailedLine.aligny = "middle";
    FailedLine.horzalign = "fullscreen";
    FailedLine.vertalign = "fullscreen";
    FailedLine.x = 320;
    FailedLine.y = 63;
    FailedLine.alpha = 1;
    FailedLine.color = (1,0,0);
    FailedLine setshader("white", 130, 1);
    
    FailedReason = create_simple_hud();
    FailedReason.alignx = "center";
    FailedReason.aligny = "middle";
    FailedReason.horzalign = "fullscreen";
    FailedReason.vertalign = "fullscreen";
    FailedReason.x = 320;
    FailedReason.y = 110;
    FailedReason.alpha = 1;
    FailedReason.color = (1,1,1);
    FailedReason.fontscale = 1.4;
    FailedReason settext(level.ReasonFailed);
    wait 13;
    foreach(player in level.players)
    	player thread maps/mp/gametypes_zm/_hud::fadetoblackforxsec( 0, 2, 0.5, 0.5, "black" );
    level waittill("FailedScreenOver");
    FailedLine destroy();
    FailedTitle destroy();
    FailedReason destroy();
    foreach(player in level.players) {
		player freezecontrols(0);
		player DisableInvulnerability();
		player RestoreData();
	}
	level.GauntletTimer SetTimerUp(65);
	level.GauntletTimer.alpha = 1;
	level.failedgauntletchallenge = undefined;
}

CreateFailedHUDS() {
	if(!isdefined(level.failedattempthud)) {
		level.failedattempthud = [];
	}
	wait 1;
	level.CurrentFails++;
	if(!isdefined(level.failedattempthud[1])) {
		for(i = 0;i < 3;i++) {
			Hud = create_simple_hud();
			Hud.alignx = "center";
			Hud.aligny = "middle";
			Hud.horzalign = "fullscreen";
			Hud.vertalign = "fullscreen";
			Hud.alpha = 0;
			Hud.color = (1,1,1);
			Hud setshader("hud_status_dead", 20, 20);
			level.failedattempthud[level.failedattempthud.size] = Hud;
		}
	}
	level.failedattempthud[0].x = 295;
	level.failedattempthud[1].x = 320;
	level.failedattempthud[2].x = 345;
	level.failedattempthud[0].alignx = "center";
	level.failedattempthud[1].alignx = "center";
	level.failedattempthud[2].alignx = "center";
	level.failedattempthud[0].y = 85;
	level.failedattempthud[1].y = 85;
	level.failedattempthud[2].y = 85;
	
	if(level.CurrentFails == 1) {
		level.failedattempthud[0] fadeovertime(1);
		level.failedattempthud[0].alpha = 1; 
		level.failedattempthud[0].color = level.ui_better_red;
		wait 1;
	}
	
	if(level.CurrentFails == 2) {
		level.failedattempthud[1] fadeovertime(1);
		level.failedattempthud[1].alpha = 1; 
		level.failedattempthud[1].color = level.ui_better_red;
		wait 1;
	}
	
	if(level.CurrentFails == 3) {
		level.failedattempthud[2] fadeovertime(1);
		level.failedattempthud[2].alpha = 1; 
		level.failedattempthud[2].color = level.ui_better_red;
		wait 1;
		level notify("end_game");
	}
	
	level waittill("FailedScreenOver");
	level.failedattempthud[0].x = 570;
	level.failedattempthud[1].x = 595;
	level.failedattempthud[2].x = 620;
	level.failedattempthud[0].alignx = "right";
	level.failedattempthud[1].alignx = "right";
	level.failedattempthud[2].alignx = "right";
	level.failedattempthud[0].y = 50;
	level.failedattempthud[1].y = 50;
	level.failedattempthud[2].y = 50;
}

AddChallenge(Name, Info, Func, Global, FailCaller) {
	if(!isdefined(level.GauntletChallenges))
		level.GauntletChallenges = [];
	Challenge = spawnstruct();
	Challenge.Name = Name;
	Challenge.Descriptiom = Info;
	Challenge.Function = Func;
	Challenge.Side = Global;
	if(isdefined(FailCaller))
		Challenge.FailCall = FailCaller;
	
	level.GauntletChallenges[level.GauntletChallenges.size] = Challenge;
}

GauntletHUDHandler(y, fontscale) {
	self fadeovertime(2);
	self.alpha = 0;
	wait 3;
	self.alignx = "CENTER";
	self.aligny = "top";
	self.horzalign = "user_center";
	self.vertalign = "user_top";
	self.x = 0;
	self.y = y;
	if(isdefined(fontscale))
		self.fontscale = fontscale;
	if(isdefined(self.Codename)) {
		if(self.Codename == "Title")
			self settext(level.GauntletChallenges[level.round_number].Name);
		if(self.Codename == "Desc")
			self settext(level.GauntletChallenges[level.round_number].Descriptiom);
		if(self.Codename == "Bar") {
			if(int(level.GauntletChallenges[level.round_number].Descriptiom.size * 3) >= 150)
				self setshader("white", 150, 1);
			else
				self setshader("white", level.GauntletChallenges[level.round_number].Descriptiom.size * 5, 1);
		}
	}
	self fadeovertime(1);
	self.alpha = 1;
	wait 8;
	self fadeovertime(1);
	self.alpha = 0;
	wait 2;
	if(self.Codename == "Desc") {
		text = [];
		output = "";
		leerzeichen = strTok(level.GauntletChallenges[level.round_number].Descriptiom, " ");
		for(i = 0;i < leerzeichen.size;i++) {
			text[i] = leerzeichen[i];
			if(i == 5)
				text[i] = leerzeichen[i] + "\n";
			else if(i == 10)
				text[i] = leerzeichen[i] + "\n";
			else if(i == 15)
				text[i] = leerzeichen[i] + "\n";
			else if(i == 20)
				text[i] = leerzeichen[i] + "\n";
			else
				text[i] = leerzeichen[i] + " ";
		}
		for(i = 0;i < text.size;i++)
			output += text[i];
		
    	self settext(output);
	}
	if(self.Codename == "Bar") {
		if(int(level.GauntletChallenges[level.round_number].Descriptiom.size * 3) > 100)
			self setshader("white", 100, 1);
		else
			self setshader("white", level.GauntletChallenges[level.round_number].Descriptiom.size * 3, 1);
	}
	self.alignx = "left";
	self.aligny = "top";
	self.horzalign = "fullscreen";
	self.vertalign = "fullscreen";
	self.x = 20;
	self.y = self.lefty;
	self fadeovertime(1);
	self.alpha = 1;
}

CustomRoundNumber() {
	level.CRoundNumber.Hidewheninmenu = 1;
	level.CRoundNumber.alignx = "center";
	level.CRoundNumber.aligny = "top";
	level.CRoundNumber.horzalign = "center";
	level.CRoundNumber.vertalign = "user_top";
	flag_wait("initial_blackscreen_passed");
	level.CRoundNumber SetShader("hud_chalk_1", 32, 32);
	//level.CRoundNumber setvalue(level.round_number);
	level.CRoundNumber.fontscale = 3;
	level.CRoundNumber.x = 0;
	level.CRoundNumber.y = 90;
	level.CRoundNumber.alpha = 0;
	level.CRoundNumber.color = level.ui_better_orange;
	level.CRoundNumber fadeovertime(1);
	level.CRoundNumber.alpha = 1;
	level.GauntletTimer settimerup(0);
	level.fallbacktime = 0;
	wait 8;
	level.CRoundNumber fadeovertime(1);
	level.CRoundNumber.alpha = 0;
	wait 2;
	level.CRoundNumber.alignx = "left";
	level.CRoundNumber.aligny = "top";
	level.CRoundNumber.horzalign = "fullscreen";
	level.CRoundNumber.vertalign = "fullscreen";
	level.CRoundNumber.x = 20;
	level.CRoundNumber.y = 40;//15
	level.CRoundNumber fadeovertime(1);
	level.CRoundNumber.alpha = 1;
	wait 0.5;
	level.CRoundNumber fadeovertime(2);
	level.CRoundNumber.color = level.ui_better_red;
	level notify("start_spawning");
}

flashroundnumber()
{
	level.CRoundNumber fadeovertime(2);
	level.CRoundNumber.alpha = 0;
	level.CRoundNumber.color = level.ui_better_orange;
	wait 3;
	if(level.round_number < 6)
		level.CRoundNumber SetShader("hud_chalk_"+level.round_number, 32, 32);
	else
		level.CRoundNumber setvalue(level.round_number);
	level.CRoundNumber.alignx = "center";
	level.CRoundNumber.aligny = "top";
	level.CRoundNumber.horzalign = "center";
	level.CRoundNumber.vertalign = "user_top";
	level.CRoundNumber.x = 0;
	level.CRoundNumber.y = 90;
	level.CRoundNumber.fontscale = 3;
	level.CRoundNumber fadeovertime(1);
	level.CRoundNumber.alpha = 1;
	wait 8;
	level.CRoundNumber fadeovertime(1);
	level.CRoundNumber.alpha = 0;
	wait 2;
	level.CRoundNumber.alignx = "left";
	level.CRoundNumber.aligny = "top";
	level.CRoundNumber.horzalign = "fullscreen";
	level.CRoundNumber.vertalign = "fullscreen";
	level.CRoundNumber.x = 20;
	level.CRoundNumber.y = 40;//15
	level.CRoundNumber fadeovertime(1);
	level.CRoundNumber.alpha = 1;
	wait 0.5;
	level.CRoundNumber fadeovertime(2);
	level.CRoundNumber.color = level.ui_better_red;
	level notify("start_spawning");
}

zone_hud() {
	self endon("disconnect");
	self.HUD_Zones = newClientHudElem(self);
	self.HUD_Zones.alignx = "left";
	self.HUD_Zones.aligny = "top";
	self.HUD_Zones.horzalign = "fullscreen";
	self.HUD_Zones.vertalign = "fullscreen";
	self.HUD_Zones.x = 20;
	self.HUD_Zones.y = 20;
	self.HUD_Zones.fontscale = 1.2;
	self.HUD_Zones.alpha = 1;
	self.HUD_Zones.color = (0.722, 0.745, 0.753);
	flag_wait( "initial_blackscreen_passed" );
	last_zone = "";
	while(1) {
		CurrentZone = self get_current_zone();
		ZoneName = self get_zone_name(CurrentZone);
		if(last_zone != ZoneName) {
			last_zone = ZoneName;
			self.HUD_Zones fadeovertime(0.25);
			self.HUD_Zones.alpha = 0;
			wait 0.25;
			self.HUD_Zones settext(ZoneName);
			self.HUD_Zones fadeovertime(0.25);
			self.HUD_Zones.alpha = 1;
			wait 0.25;
			continue;
		}
		wait 0.05;
	}
}

round_think( restart ) {
	restart = 0;
	for ( ;; ) {
		maxreward = 50 * level.round_number;
		if ( maxreward > 500 )
			maxreward = 500;
		level.zombie_vars[ "rebuild_barrier_cap_per_round" ] = maxreward;
		level.pro_tips_start_time = getTime();
		level.zombie_last_run_time = getTime();
		level thread maps/mp/zombies/_zm_audio::change_zombie_music( "round_start" );
		maps/mp/zombies/_zm_powerups::powerup_round_start();
		players = get_players();
		array_thread( players, maps/mp/zombies/_zm_blockers::rebuild_barrier_reward_reset );
		if ( isDefined( level.headshots_only ) && !level.headshots_only && !restart )
			level thread award_grenades_for_survivors();
		level.round_start_time = getTime();
		while ( level.zombie_spawn_locations.size <= 0 )
			wait 0.1;
		wait 4;
		level thread [[ level.round_spawn_func ]]();
		level notify( "start_of_round" );
		players = getplayers();
		index = 0;
		while ( index < players.size ) {
			zonename = players[ index ] get_current_zone();
			if ( isDefined( zonename ) )
				players[ index ] recordzombiezone( "startingZone", zonename );
			index++;
		}
		if ( isDefined( level.round_start_custom_func ) )
			[[ level.round_start_custom_func ]]();
		
		[[ level.round_wait_func ]]();
		level.first_round = 0;
		level notify( "end_of_round" );
		
		if(isdefined(level.failedgauntletchallenge)) {
			foreach(player in level.players)
				player playlocalsound("zmb_laugh_richtofen");
		}
		else
			level thread maps/mp/zombies/_zm_audio::change_zombie_music( "round_end" );
		
		players = get_players();
		if (players.size != 1)
			level thread spectators_respawn();
		array_thread( players, maps/mp/zombies/_zm_pers_upgrades_system::round_end );
		timer = level.zombie_vars[ "zombie_spawn_delay" ];
		if ( timer > 0.08 )
			level.zombie_vars[ "zombie_spawn_delay" ] = timer * 0.95;
		else {
			if ( timer < 0.08 )
				level.zombie_vars[ "zombie_spawn_delay" ] = 0.08;
		}
		
		if ( level.gamedifficulty == 0 )
			level.zombie_move_speed = level.round_number * level.zombie_vars[ "zombie_move_speed_multiplier_easy" ];
		else
			level.zombie_move_speed = level.round_number * level.zombie_vars[ "zombie_move_speed_multiplier" ];
		wait 0.5;
		if(isdefined(level.failedgauntletchallenge)) {
			level thread FailedScreen();
			level thread CreateFailedHUDS();
			wait 15;
			level notify("FailedScreenOver");
		}
		level.round_number++;
		level thread flashroundnumber();
		level.GauntletHUDS["Title"] thread GauntletHUDHandler(130, 1.7);  
    	level.GauntletHUDS["Challenge"] thread GauntletHUDHandler(155, 1);  
    	level.GauntletHUDS["Bar"] thread GauntletHUDHandler(150);  
		level round_over();
		level notify( "between_round_over" );
		restart = 0;
		wait .05;
	}
}

get_zone_name(key) {
    // Caching and array lookup is way more efficient
    if (isdefined(level.zone_names))
        return level.zone_names[key];
	
    level.zone_names = [];

    switch(level.script) {
        case "zm_transit":
            level.zone_names["zone_pri"] = "Bus Depot";
            level.zone_names["zone_pri2"] = "Bus Depot Hallway";
            level.zone_names["zone_station_ext"] = "Outside Bus Depot";
            level.zone_names["zone_trans_2b"] = "Road After Bus Depot";
            level.zone_names["zone_trans_2"] = "Tunnel Entrance";
            level.zone_names["zone_amb_tunnel"] = "Tunnel";
            level.zone_names["zone_trans_3"] = "Tunnel Exit";
            level.zone_names["zone_roadside_west"] = "Outside Diner";
            level.zone_names["zone_gas"] = "Gas Station";
            level.zone_names["zone_roadside_east"] = "Outside Garage";
            level.zone_names["zone_trans_diner"] = "Road Outside Diner";
            level.zone_names["zone_trans_diner2"] = "Road Outside Garage";
            level.zone_names["zone_gar"] = "Garage";
            level.zone_names["zone_din"] = "Diner";
            level.zone_names["zone_diner_roof"] = "Diner Roof";
            level.zone_names["zone_trans_4"] = "Road After Diner";
            level.zone_names["zone_amb_forest"] = "Forest";
            level.zone_names["zone_trans_10"] = "Outside Church";
            level.zone_names["zone_town_church"] = "Upper South Town";
            level.zone_names["zone_trans_5"] = "Road Before Farm";
            level.zone_names["zone_far"] = "Outside Farm";
            level.zone_names["zone_far_ext"] = "Farm";
            level.zone_names["zone_brn"] = "Barn";
            level.zone_names["zone_farm_house"] = "Farmhouse";
            level.zone_names["zone_trans_6"] = "Road After Farm";
            level.zone_names["zone_amb_cornfield"] = "Cornfield";
            level.zone_names["zone_cornfield_prototype"] = "Nacht der Untoten";
            level.zone_names["zone_trans_7"] = "Upper Road Before Power";
            level.zone_names["zone_trans_pow_ext1"] = "Road Before Power";
            level.zone_names["zone_pow"] = "Outside Power Station";
            level.zone_names["zone_prr"] = "Power Station";
            level.zone_names["zone_pcr"] = "Power Control Room";
            level.zone_names["zone_pow_warehouse"] = "Warehouse";
            level.zone_names["zone_trans_8"] = "Road After Power";
            level.zone_names["zone_amb_power2town"] = "Cabin";
            level.zone_names["zone_trans_9"] = "Road Before Town";
            level.zone_names["zone_town_north"] = "North Town";
            level.zone_names["zone_tow"] = "Center Town";
            level.zone_names["zone_town_east"] = "East Town";
            level.zone_names["zone_town_west"] = "West Town";
            level.zone_names["zone_town_west2"] = "West Town 2";
            level.zone_names["zone_town_south"] = "South Town";
            level.zone_names["zone_bar"] = "Bar";
            level.zone_names["zone_town_barber"] = "Above Barbershop";
            level.zone_names["zone_ban"] = "Bank";
            level.zone_names["zone_ban_vault"] = "Bank Vault";
            level.zone_names["zone_tbu"] = "Laboratory";
            level.zone_names["zone_trans_11"] = "Road After Town";
            level.zone_names["zone_amb_bridge"] = "Bridge";
            level.zone_names["zone_trans_1"] = "Road Before Bus Depot";
            break;
        
        case "zm_nuked":
            level.zone_names["culdesac_yellow_zone"] = "Yellow House Cul-de-sac";
            level.zone_names["culdesac_green_zone"] = "Green House Cul-de-sac";
            level.zone_names["truck_zone"] = "Truck";
            level.zone_names["openhouse1_f1_zone"] = "Green House Downstairs";
            level.zone_names["openhouse1_f2_zone"] = "Green House Upstairs";
            level.zone_names["openhouse1_backyard_zone"] = "Green House Backyard";
            level.zone_names["openhouse2_f1_zone"] = "Yellow House Downstairs";
            level.zone_names["openhouse2_f2_zone"] = "Yellow House Upstairs";
            level.zone_names["openhouse2_backyard_zone"] = "Yellow House Backyard";
            level.zone_names["ammo_door_zone"] = "Yellow House Backyard Door";
            break;
        
        case "zm_highrise":
            level.zone_names["zone_green_start"] = "Green Highrise Level 3b";
            level.zone_names["zone_green_escape_pod"] = "Escape Pod";
            level.zone_names["zone_green_escape_pod_ground"] = "Escape Pod Shaft";
            level.zone_names["zone_green_level1"] = "Green Highrise Level 3a";
            level.zone_names["zone_green_level2a"] = "Green Highrise Level 2a";
            level.zone_names["zone_green_level2b"] = "Green Highrise Level 2b";
            level.zone_names["zone_green_level3a"] = "Green Highrise Restaurant";
            level.zone_names["zone_green_level3b"] = "Green Highrise Level 1a";
            level.zone_names["zone_green_level3c"] = "Green Highrise Level 1b";
            level.zone_names["zone_green_level3d"] = "Green Highrise Behind Restaurant";
            level.zone_names["zone_orange_level1"] = "Upper Orange Highrise Level 2";
            level.zone_names["zone_orange_level2"] = "Upper Orange Highrise Level 1";
            level.zone_names["zone_orange_elevator_shaft_top"] = "Elevator Shaft Level 3";
            level.zone_names["zone_orange_elevator_shaft_middle_1"] = "Elevator Shaft Level 2";
            level.zone_names["zone_orange_elevator_shaft_middle_2"] = "Elevator Shaft Level 1";
            level.zone_names["zone_orange_elevator_shaft_bottom"] = "Elevator Shaft Bottom";
            level.zone_names["zone_orange_level3a"] = "Lower Orange Highrise Level 1a";
            level.zone_names["zone_orange_level3b"] = "Lower Orange Highrise Level 1b";
            level.zone_names["zone_blue_level5"] = "Lower Blue Highrise Level 1";
            level.zone_names["zone_blue_level4a"] = "Lower Blue Highrise Level 2a";
            level.zone_names["zone_blue_level4b"] = "Lower Blue Highrise Level 2b";
            level.zone_names["zone_blue_level4c"] = "Lower Blue Highrise Level 2c";
            level.zone_names["zone_blue_level2a"] = "Upper Blue Highrise Level 1a";
            level.zone_names["zone_blue_level2b"] = "Upper Blue Highrise Level 1b";
            level.zone_names["zone_blue_level2c"] = "Upper Blue Highrise Level 1c";
            level.zone_names["zone_blue_level2d"] = "Upper Blue Highrise Level 1d";
            level.zone_names["zone_blue_level1a"] = "Upper Blue Highrise Level 2a";
            level.zone_names["zone_blue_level1b"] = "Upper Blue Highrise Level 2b";
            level.zone_names["zone_blue_level1c"] = "Upper Blue Highrise Level 2c";
            break;
        
        case "zm_prison":
            level.zone_names["zone_start"] = "D-Block";
            level.zone_names["zone_library"] = "Library";
            level.zone_names["zone_cellblock_west"] = "Cellblock 2nd Floor";
            level.zone_names["zone_cellblock_west_gondola"] = "Cellblock 3rd Floor";
            level.zone_names["zone_cellblock_west_gondola_dock"] = "Cellblock Gondola";
            level.zone_names["zone_cellblock_west_barber"] = "Michigan Avenue";
            level.zone_names["zone_cellblock_east"] = "Times Square";
            level.zone_names["zone_cafeteria"] = "Cafeteria";
            level.zone_names["zone_cafeteria_end"] = "Cafeteria End";
            level.zone_names["zone_infirmary"] = "Infirmary 1";
            level.zone_names["zone_infirmary_roof"] = "Infirmary 2";
            level.zone_names["zone_roof_infirmary"] = "Roof 1";
            level.zone_names["zone_roof"] = "Roof 2";
            level.zone_names["zone_cellblock_west_warden"] = "Sally Port";
            level.zone_names["zone_warden_office"] = "Warden's Office";
            level.zone_names["cellblock_shower"] = "Showers";
            level.zone_names["zone_citadel_shower"] = "Citadel To Showers";
            level.zone_names["zone_citadel"] = "Citadel";
            level.zone_names["zone_citadel_warden"] = "Citadel To Warden's Office";
            level.zone_names["zone_citadel_stairs"] = "Citadel Tunnels";
            level.zone_names["zone_citadel_basement"] = "Citadel Basement";
            level.zone_names["zone_citadel_basement_building"] = "China Alley";
            level.zone_names["zone_studio"] = "Building 64";
            level.zone_names["zone_dock"] = "Docks";
            level.zone_names["zone_dock_puzzle"] = "Docks Gates";
            level.zone_names["zone_dock_gondola"] = "Upper Docks";
            level.zone_names["zone_golden_gate_bridge"] = "Golden Gate Bridge";
            level.zone_names["zone_gondola_ride"] = "Gondola";
            break;
        
        case "zm_buried":
            level.zone_names["zone_start"] = "Processing";
            level.zone_names["zone_start_lower"] = "Lower Processing";
            level.zone_names["zone_tunnels_center"] = "Center Tunnels";
            level.zone_names["zone_tunnels_north"] = "Courthouse Tunnels 2";
            level.zone_names["zone_tunnels_north2"] = "Courthouse Tunnels 1";
            level.zone_names["zone_tunnels_south"] = "Saloon Tunnels 3";
            level.zone_names["zone_tunnels_south2"] = "Saloon Tunnels 2";
            level.zone_names["zone_tunnels_south3"] = "Saloon Tunnels 1";
            level.zone_names["zone_street_lightwest"] = "Outside General Store & Bank";
            level.zone_names["zone_street_lightwest_alley"] = "Outside General Store & Bank Alley";
            level.zone_names["zone_morgue_upstairs"] = "Morgue";
            level.zone_names["zone_underground_jail"] = "Jail Downstairs";
            level.zone_names["zone_underground_jail2"] = "Jail Upstairs";
            level.zone_names["zone_general_store"] = "General Store";
            level.zone_names["zone_stables"] = "Stables";
            level.zone_names["zone_street_darkwest"] = "Outside Gunsmith";
            level.zone_names["zone_street_darkwest_nook"] = "Outside Gunsmith Nook";
            level.zone_names["zone_gun_store"] = "Gunsmith";
            level.zone_names["zone_bank"] = "Bank";
            level.zone_names["zone_tunnel_gun2stables"] = "Stables To Gunsmith Tunnel 2";
            level.zone_names["zone_tunnel_gun2stables2"] = "Stables To Gunsmith Tunnel";
            level.zone_names["zone_street_darkeast"] = "Outside Saloon & Toy Store";
            level.zone_names["zone_street_darkeast_nook"] = "Outside Saloon & Toy Store Nook";
            level.zone_names["zone_underground_bar"] = "Saloon";
            level.zone_names["zone_tunnel_gun2saloon"] = "Saloon To Gunsmith Tunnel";
            level.zone_names["zone_toy_store"] = "Toy Store Downstairs";
            level.zone_names["zone_toy_store_floor2"] = "Toy Store Upstairs";
            level.zone_names["zone_toy_store_tunnel"] = "Toy Store Tunnel";
            level.zone_names["zone_candy_store"] = "Candy Store Downstairs";
            level.zone_names["zone_candy_store_floor2"] = "Candy Store Upstairs";
            level.zone_names["zone_street_lighteast"] = "Outside Courthouse & Candy Store";
            level.zone_names["zone_underground_courthouse"] = "Courthouse Downstairs";
            level.zone_names["zone_underground_courthouse2"] = "Courthouse Upstairs";
            level.zone_names["zone_street_fountain"] = "Fountain";
            level.zone_names["zone_church_graveyard"] = "Graveyard";
            level.zone_names["zone_church_main"] = "Church Downstairs";
            level.zone_names["zone_church_upstairs"] = "Church Upstairs";
            level.zone_names["zone_mansion_lawn"] = "Mansion Lawn";
            level.zone_names["zone_mansion"] = "Mansion";
            level.zone_names["zone_mansion_backyard"] = "Mansion Backyard";
            level.zone_names["zone_maze"] = "Maze";
            level.zone_names["zone_maze_staircase"] = "Maze Staircase";
            break;
        
        case "zm_tomb":
            level.zone_names["zone_start"] = "Lower Laboratory";
            level.zone_names["zone_start_a"] = "Upper Laboratory";
            level.zone_names["zone_start_b"] = "Generator 1";
            level.zone_names["zone_bunker_1a"] = "Generator 3 Bunker 1";
            level.zone_names["zone_fire_stairs"] = "Fire Tunnel";
            level.zone_names["zone_fire_stairs_1"] = "zone_fire_stairs_1";
            level.zone_names["zone_bunker_1"] = "Generator 3 Bunker 2";
            level.zone_names["zone_bunker_3a"] = "Generator 3";
            level.zone_names["zone_bunker_3b"] = "Generator 3 Bunker 3";
            level.zone_names["zone_bunker_2a"] = "Generator 2 Bunker 1";
            level.zone_names["zone_bunker_2"] = "Generator 2 Bunker 2";
            level.zone_names["zone_bunker_4a"] = "Generator 2";
            level.zone_names["zone_bunker_4b"] = "Generator 2 Bunker 3";
            level.zone_names["zone_bunker_4c"] = "Tank Station";
            level.zone_names["zone_bunker_4d"] = "Above Tank Station";
            level.zone_names["zone_bunker_tank_c"] = "Generator 2 Tank Route 1";
            level.zone_names["zone_bunker_tank_c1"] = "Generator 2 Tank Route 2";
            level.zone_names["zone_bunker_4e"] = "Generator 2 Tank Route 3";
            level.zone_names["zone_bunker_tank_d"] = "Generator 2 Tank Route 4";
            level.zone_names["zone_bunker_tank_d1"] = "Generator 2 Tank Route 5";
            level.zone_names["zone_bunker_4f"] = "zone_bunker_4f";
            level.zone_names["zone_bunker_5a"] = "Workshop Downstairs";
            level.zone_names["zone_bunker_5b"] = "Workshop Upstairs";
            level.zone_names["zone_nml_2a"] = "No Man's Land Walkway";
            level.zone_names["zone_nml_2"] = "No Man's Land Entrance";
            level.zone_names["zone_bunker_tank_e"] = "Generator 5 Tank Route 1";
            level.zone_names["zone_bunker_tank_e1"] = "Generator 5 Tank Route 2";
            level.zone_names["zone_bunker_tank_e2"] = "zone_bunker_tank_e2";
            level.zone_names["zone_bunker_tank_f"] = "Generator 5 Tank Route 3";
            level.zone_names["zone_nml_1"] = "Generator 5 Tank Route 4";
            level.zone_names["zone_nml_4"] = "Generator 5 Tank Route 5";
            level.zone_names["zone_nml_0"] = "Generator 5 Left Footstep";
            level.zone_names["zone_nml_5"] = "Generator 5 Right Footstep Walkway";
            level.zone_names["zone_nml_farm"] = "Generator 5";
            level.zone_names["zone_nml_farm_1"] = "zone_nml_farm_1";
            level.zone_names["zone_nml_celllar"] = "Generator 5 Cellar";
            level.zone_names["zone_bolt_stairs"] = "Lightning Tunnel";
            level.zone_names["zone_bolt_stairs_1"] = "zone_bolt_stairs_1";
            level.zone_names["zone_nml_3"] = "No Man's Land 1st Right Footstep";
            level.zone_names["zone_nml_2b"] = "No Man's Land Stairs";
            level.zone_names["zone_nml_6"] = "No Man's Land Left Footstep";
            level.zone_names["zone_nml_8"] = "No Man's Land 2nd Right Footstep";
            level.zone_names["zone_nml_10a"] = "Generator 4 Tank Route 1";
            level.zone_names["zone_nml_10"] = "Generator 4 Tank Route 2";
            level.zone_names["zone_nml_7"] = "Generator 4 Tank Route 3";
            level.zone_names["zone_nml_7a"] = "zone_nml_7a";
            level.zone_names["zone_bunker_tank_a"] = "Generator 4 Tank Route 4";
            level.zone_names["zone_bunker_tank_a1"] = "Generator 4 Tank Route 5";
            level.zone_names["zone_bunker_tank_a2"] = "zone_bunker_tank_a2";
            level.zone_names["zone_bunker_tank_b"] = "Generator 4 Tank Route 6";
            level.zone_names["zone_nml_9"] = "Generator 4 Left Footstep";
            level.zone_names["zone_nml_9a"] = "zone_nml_9a";
            level.zone_names["zone_air_stairs"] = "Wind Tunnel";
            level.zone_names["zone_air_stairs_1"] = "zone_air_stairs_1";
            level.zone_names["zone_nml_11"] = "Generator 4";
            level.zone_names["zone_nml_11a"] = "zone_nml_11a";
            level.zone_names["zone_nml_12"] = "Generator 4 Right Footstep";
            level.zone_names["zone_nml_12a"] = "zone_nml_12a";
            level.zone_names["zone_nml_16"] = "Excavation Site Front Path";
            //level.zone_names["zone_nml_16a"] = "zone_nml_16a";
            level.zone_names["zone_nml_17"] = "Excavation Site Back Path";
            //level.zone_names["zone_nml_17a"] = "zone_nml_17a";
            level.zone_names["zone_nml_18"] = "Excavation Site Level 3";
            level.zone_names["zone_nml_19"] = "Excavation Site Level 2";
            level.zone_names["ug_bottom_zone"] = "Excavation Site Level 1";
            level.zone_names["zone_nml_13"] = "Generator 5 To Generator 6 Path";
            level.zone_names["zone_nml_14"] = "Generator 4 To Generator 6 Path";
            level.zone_names["zone_nml_15"] = "Generator 6 Entrance";
            //level.zone_names["zone_nml_15a"] = "zone_nml_15a";
            level.zone_names["zone_village_0"] = "Generator 6 Left Footstep";
            level.zone_names["zone_village_5"] = "Generator 6 Tank Route 1";
            level.zone_names["zone_village_5a"] = "Generator 6 Tank Route 2";
            level.zone_names["zone_village_5b"] = "Generator 6 Tank Route 3";
            level.zone_names["zone_village_1"] = "Generator 6 Tank Route 4";
            //level.zone_names["zone_village_1a"] = "zone_village_1a";
            level.zone_names["zone_village_4b"] = "Generator 6 Tank Route 5";
            level.zone_names["zone_village_4a"] = "Generator 6 Tank Route 6";
            level.zone_names["zone_village_4"] = "Generator 6 Tank Route 7";
            level.zone_names["zone_village_2"] = "Church";
            level.zone_names["zone_village_3"] = "Generator 6 Right Footstep";
            level.zone_names["zone_village_3a"] = "Generator 6";
            level.zone_names["zone_village_3b"] = "zone_village_3b";
            level.zone_names["zone_ice_stairs"] = "Ice Tunnel";
            //level.zone_names["zone_ice_stairs_1"] = "zone_ice_stairs_1";
            level.zone_names["zone_bunker_6"] = "Above Generator 3 Bunker";
            level.zone_names["zone_nml_20"] = "Above No Man's Land";
            level.zone_names["zone_village_6"] = "Behind Church";
            //level.zone_names["zone_village_6a"] = "zone_village_6a";
            level.zone_names["zone_chamber_0"] = "The Crazy Place Lightning Chamber";
            level.zone_names["zone_chamber_1"] = "The Crazy Place Lightning & Ice";
            level.zone_names["zone_chamber_2"] = "The Crazy Place Ice Chamber";
            level.zone_names["zone_chamber_3"] = "The Crazy Place Fire & Lightning";
            level.zone_names["zone_chamber_4"] = "The Crazy Place Center";
            level.zone_names["zone_chamber_5"] = "The Crazy Place Ice & Wind";
            level.zone_names["zone_chamber_6"] = "The Crazy Place Fire Chamber";
            level.zone_names["zone_chamber_7"] = "The Crazy Place Wind & Fire";
            level.zone_names["zone_chamber_8"] = "The Crazy Place Wind Chamber";
            level.zone_names["zone_robot_head"] = "Robot's Head";
            break;
    }
    return level.zone_names[key];
}






