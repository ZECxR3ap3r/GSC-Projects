#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_gv_actions;

addRandomAttachmentToWeaponName_N( baseWeaponName, attachmentList ) {
	if ( !IsDefined( attachmentList ) )
		return baseWeaponName;
	attachments = StrTok( attachmentList, " " );
	// Sort out all the junk :)
	attachments = array_remove( attachments, "dw" ); 
	attachments = array_remove( attachments, "gl" );
	attachments = array_remove( attachments, "ft" );
	attachments = array_remove( attachments, "mk" ); 
	attachments = array_remove( attachments, "ir" ); 
	
	if ( attachments.size <= 0 )
		return baseWeaponName;
		
	attachments[attachments.size] = "";
	attachment = random( attachments );
	if ( attachment == "" )
		return baseWeaponName;
		
	return baseWeaponName+"_"+attachment;
}

init() {
	// Replace
	replacefunc(maps\mp\_tacticalinsertion::cancel_button_press, ::blank);
	replacefunc(maps\mp\gametypes\_rank::updateRankScoreHUD, ::updateRankScoreHUD_N);
	flag_init("prematch_over");
	precacheshader("rank_prestige14");
	precacheshader("rank_prestige15");
	precacheshader("gradient_fadein");
	precacheshader("hud_icon_cz75");
	precacheshader("hud_python");
	precacheshader("hud_icon_colt");
	precacheshader("hud_asp");
	precacheshader("hud_icon_makarov");
	precacheshader("hud_icon_dragunov");
	precacheshader("hud_l96");
	precacheshader("hud_psg1");
	precacheshader("hud_icon_m16a4");
	precacheshader("hud_enfield");
	precacheshader("hud_icon_famas");
	precacheshader("hud_icon_m14");
	precacheshader("hud_icon_fnfal");
	precacheshader("hud_icon_galil");
	precacheshader("hud_commando");
	precacheshader("hud_icon_ak47");
	precacheshader("hud_icon_aug");
	precacheshader("hud_icon_skorpion");
	precacheshader("hud_icon_mp5");
	precacheshader("hud_icon_ak74u");
	precacheshader("hud_icon_mac11");
	precacheshader("hud_icon_uzi");
	precacheshader("hud_icon_mpl");
	precacheshader("hud_icon_pm63");
	precacheshader("hud_icon_spectre");
	precacheshader("hud_ithaca");
	precacheshader("hud_icon_spas12");
	precacheshader("hud_hs10");
	precacheshader("hud_icon_waw2000");
	precacheshader("hud_beretta");
	precacheshader("hud_rpk");
	precacheshader("hud_hk21");
	precacheshader("hud_icon_m60e4");
	precacheshader("hud_icon_stoner63a");
	precacheshader("hud_icon_g11");
	precacheshader("hud_icon_m72law");
	precacheshader("hud_icon_rpg");
	precacheshader("hud_strela");
	precacheshader("hud_china_lake");
	precacheshader("hud_ballistic_knife");
	precacheshader("hud_icon_crossbow");
	precacheshader("hud_icon_kiparis");
	precacheshader("hud_icon_sticky_grenade");
	precacheshader("rank_prestige07");
	precacheshader("menu_mp_reticle_radiation");
	precacheshader("hud_grenadeicon");
	precacheshader("hud_hatchet");
	precacheshader("hud_us_smokegrenade");
	precacheshader("hud_tact_insert");
	precacheshader("hud_icon_claymore");
	precacheshader("hud_deployable_camera");
	precacheshader("hud_acoustic_sensor");
	precacheshader("hud_icon_scrambler");
	precacheshader("menu_mp_reticle_circles02");
	precacheshader("menu_mp_lobby_frame_circle");
	precacheshader("hud_icon_syrette");
	
	precachemodel("collision_wall_128x128x10");
	precachemodel("collision_geo_128x128x128");
	precachemodel("weapon_c4_mp_detect");
	
	PrecacheString( &"MP_BONUS_ACQUIRED" );
	
	setdvar("sv_cheats", 1);
	setDvar( "jump_height", 46);
	setDvar( "jump_slowdownEnable", 0 );
	setDvar( "bg_fallDamageMinHeight", 10000 );
	setDvar( "bg_fallDamageMaxHeight", 10000 );
	setDvar( "player_sprintUnlimited", 1 );
	setdvar("scr_disable_weapondrop", 1);
    setdvar("scr_allowannouncer", 0);
    setdvar("sv_enableBounces", 1);
    setdvar("jump_stepSize", 64);
    setdvar("jump_ladderPushVel", 1024);
    setdvar("g_speed", 235);
    setdvar("g_gravity", 800);
    setdvar("g_playerCollision", 1);
    setdvar("g_TeamName_Allies", "^2SURVIVORS" );
    setdvar("g_TeamName_Axis", "^:INFECTED" );
    setdvar("ui_allow_teamchange", 0);
    setdvar("ui_allow_classchange", 0);
    setdvar("g_allow_teamchange", 0);
    setdvar("g_allow_classchange", 0);
    setdvar("g_teamcolor_axis", "0.75 0.25 0.25 1");
    setdvar("g_teamcolor_allies", "0.25 0.75 0.25 1");
    setDvar("ui_guncycle", 0 );
	setDvar("scr_teambalance", 0 );
	setdvar("r_skycolortemp", 25000);
	setdvar("r_filmusetweaks", 0);
	setdvar("r_exposuretweak", 1);
    setdvar("r_filmtweakcolortemp", "6500 6500 6500");
    setdvar("phys_ai_collision_mode", 0);
    setdvar("g_playercollision", 0);
    setmatchflag( "radar_allies", 1 );
	setmatchflag( "radar_axis", 1 );
	setMatchFlag( "hud_hardcore", 1);
    
    level.vars = [];
    level.initialinfected = undefined;
   	level.vars["Axis"] = (0.75,0.25,0.25);
   	level.vars["Allies"] = (0.25,0.75,0.25);
   	level.ui_grey = (0.2, 0.2, 0.2);
   	
	PrecacheRumble("artillery_rumble");
	// Class Settings
	
	level.ClassSettings["FirstInfected"] = spawnstruct();
	level.ClassSettings["FirstInfected"].weapon = "knife_ballistic_mp";
	level.ClassSettings["FirstInfected"].grenade = "sticky_grenade_mp";
	level.ClassSettings["FirstInfected"].equipment = "tactical_insertion_mp";
	level.ClassSettings["FirstInfected"].perk1 = "specialty_movefaster";
	level.ClassSettings["FirstInfected"].perk2 = "specialty_sprintrecovery";
	level.ClassSettings["FirstInfected"].perk3 = "none";
	
	level.ClassSettings["Infected"] = spawnstruct();
	level.ClassSettings["Infected"].weapon = "knife_ballistic_mp";
	level.ClassSettings["Infected"].grenade = "none";
	level.ClassSettings["Infected"].equipment = "tactical_insertion_mp";
	level.ClassSettings["Infected"].perk1 = "specialty_movefaster";
	level.ClassSettings["Infected"].perk2 = "specialty_sprintrecovery";
	level.ClassSettings["Infected"].perk3 = "none";
	
	level.ClassSettings["Survivor"] = spawnstruct();
	level.ClassSettings["Survivor"].weapon = "commando_mp";
	level.ClassSettings["Survivor"].grenade = "hatchet_mp";
	level.ClassSettings["Survivor"].equipment = "none";
	level.ClassSettings["Survivor"].perk1 = "none";
	level.ClassSettings["Survivor"].perk2 = "none";
	level.ClassSettings["Survivor"].perk3 = "none";
	
	game["strings"]["objective_hint_allies"] = "";
	game["strings"]["objective_hint_axis"] = "";
	game["strings"]["victory"] = "^:HUMANS ELIMINATED";
	game["strings"]["defeat"] = "^2HUMANS WIN";
	game["dialog"]["wm_oot_money"] = "boost_gen_07";
	game["dialog"]["timesup"] = "timesup";
	game["dialog"]["winning"] = "";
	game["dialog"]["losing"] = "";
	game["dialog"]["min_draw"] = "";
	game["dialog"]["lead_lost"] = "";
	game["dialog"]["lead_tied"] = "";
	game["dialog"]["lead_taken"] = "";
	game["dialog"]["last_alive"] = "lastalive";
	
	map = getdvar("mapname");
	if(map == "mp_array") {
		level thread CreateJumpPad((2586.66, 129.528, 364.125), 150, 2);
	}
	if(map == "mp_crisis") {
		level thread CreateJumpPad((-2424.34, 154.256, 121.125), 90, 2);
	}
	if(map == "mp_firingrange") {
		Bombmodel = Spawn("script_model", (344.068, -839.977, 60.1250));
    	Bombmodel SetModel("p_glo_bomb_stack_d");
    	Bombmodel.angles = (35, 245, 0);
    	Bombmodel2 = Spawn("script_model", (359.068, 864.977, 100.125));
    	Bombmodel2 SetModel("p_glo_bomb_stack_d");
    	Bombmodel2.angles = (85, 245, 0);
    	spawncollision("collision_geo_128x128x128","collider",(386.183, 860.54, 55), (0, -30, 45));
	}
	if(map == "mp_duga") {
		MapEdit = Spawn("script_model", (-587.412, -4291.23, 3.69902));
    	MapEdit SetModel("vehicle_uaz_whole_snowy");
    	MapEdit.angles = (0,0,0);
	}
	if(map == "mp_hanoi") {
		Car = Spawn("script_model", (-421, 1079.37, -74.375));
    	Car SetModel("t5_veh_civ_smallcar_whole_blue");
    	Car.angles = (0,50,-5);
    	spawncollision("collision_geo_128x128x128","collider",(-452.93, 1109.78, 0), (0,50,0));
    	spawncollision("collision_geo_128x128x128","collider",(-452.93, 1109.78, 80), (0,50,0));
	}
	if(map == "mp_villa") {
    	spawncollision("collision_wall_128x128x10","collider",(4101, 2977.05, 274), (0,0,-90));
    	spawncollision("collision_geo_128x128x128","collider",(4101, 2977.05, 274), (-14,110,0));
	}
	if(map == "mp_russianbase") {
    	level thread CreateJumpPad((-1685.52, 713.36, 159.214), 50, 2);
	}
	
    level.oldschool = 1;
    
	level thread on_connect();
	level thread GunRotation();
	level thread onPlayerDisconnect();
	
	level.onplayerkilled = ::playerkilledinf;
	level.giveCustomLoadout = ::giveCustomLoadout;
	
	level waittill("prematch_over");
	flag_set("prematch_over");
	level.TeamElems = [];
    
    level.TeamElems["Discord"] = newhudelem();
    level.TeamElems["Discord"].x = 320;
    level.TeamElems["Discord"].y = 0;
    level.TeamElems["Discord"].alignx = "center";
    level.TeamElems["Discord"].horzalign = "fullscreen";
    level.TeamElems["Discord"].vertalign = "fullscreen";
    level.TeamElems["Discord"].alpha = 0.4;
    level.TeamElems["Discord"].sort = 2;
    level.TeamElems["Discord"].color = (1,1,1);
    level.TeamElems["Discord"].archived = true;
    level.TeamElems["Discord"].foreground = true;
    level.TeamElems["Discord"].fontscale = 1;
	level.TeamElems["Discord"] settext("GilletteClan.com");
	level.TeamElems["Discord"].hidewheninmenu = true;
    level.TeamElems["Discord"].hideWhenDead = true;
    
    level.TeamElems["Background"] = newhudelem();
    level.TeamElems["Background"].x = 320;
    level.TeamElems["Background"].y = 10;
    level.TeamElems["Background"].alignx = "center";
    level.TeamElems["Background"].horzalign = "fullscreen";
    level.TeamElems["Background"].vertalign = "fullscreen";
    level.TeamElems["Background"].alpha = 0.5;
    level.TeamElems["Background"].archived = true;
    level.TeamElems["Background"].sort = 0;
    level.TeamElems["Background"].color = (1,1,1);
    level.TeamElems["Background"] setshader("rank_prestige15", 20, 20);
    level.TeamElems["Background"].hidewheninmenu = true;
    level.TeamElems["Background"].hideWhenInKillcam = true;
    level.TeamElems["Background"].hideWhenDead = true;
    level.TeamElems["Background"] thread DestroyWhenEndGame();
   	
    level.TeamElems["Timer"] = newhudelem();
    level.TeamElems["Timer"].x = 320;
    level.TeamElems["Timer"].y = 30;
    level.TeamElems["Timer"].alignx = "center";
    level.TeamElems["Timer"].horzalign = "fullscreen";
    level.TeamElems["Timer"].vertalign = "fullscreen";
    level.TeamElems["Timer"].alpha = 1;
    level.TeamElems["Timer"].sort = 2;
    level.TeamElems["Timer"].color = (1,1,1);
    level.TeamElems["Timer"].archived = true;
    level.TeamElems["Timer"].foreground = true;
    level.TeamElems["Timer"].fontscale = 1;
	level.TeamElems["Timer"] settimer(599);
	level.TeamElems["Timer"].hidewheninmenu = true;
	level.TeamElems["Timer"].hideWhenInKillcam = true;
    level.TeamElems["Timer"].hideWhenDead = true;
    level.TeamElems["Timer"] thread DestroyWhenEndGame();
	
	level.TeamElems["Allies"] = newhudelem();
    level.TeamElems["Allies"].x = 300;
    level.TeamElems["Allies"].y = 15;
    level.TeamElems["Allies"].alignx = "center";
    level.TeamElems["Allies"].horzalign = "fullscreen";
    level.TeamElems["Allies"].vertalign = "fullscreen";
    level.TeamElems["Allies"].alpha = 1;
    level.TeamElems["Allies"].sort = 0;
    level.TeamElems["Allies"].color = level.vars["Allies"];
    level.TeamElems["Allies"].archived = true;
    level.TeamElems["Allies"] setshader("white", 15, 15);
    level.TeamElems["Allies"].hidewheninmenu = true;
    level.TeamElems["Allies"].hideWhenInKillcam = true;
    level.TeamElems["Allies"].hideWhenDead = true;
    level.TeamElems["Allies"] thread DestroyWhenEndGame();
    
    level.TeamElems["Axis"] = newhudelem();
    level.TeamElems["Axis"].x = 340;
    level.TeamElems["Axis"].y = 15;
    level.TeamElems["Axis"].alignx = "center";
    level.TeamElems["Axis"].horzalign = "fullscreen";
    level.TeamElems["Axis"].vertalign = "fullscreen";
    level.TeamElems["Axis"].alpha = 1;
    level.TeamElems["Axis"].sort = 0;
    level.TeamElems["Axis"].color = level.vars["Axis"];
    level.TeamElems["Axis"].archived = true;
    level.TeamElems["Axis"] setshader("white", 15, 15);
    level.TeamElems["Axis"].hidewheninmenu = true;
    level.TeamElems["Axis"].hideWhenInKillcam = true;
    level.TeamElems["Axis"].hideWhenDead = true;
    level.TeamElems["Axis"] thread DestroyWhenEndGame();
    
    level.TeamElems["AlliesScore"] = newhudelem();
    level.TeamElems["AlliesScore"].x = 300;
    level.TeamElems["AlliesScore"].y = 15;
    level.TeamElems["AlliesScore"].alignx = "center";
    level.TeamElems["AlliesScore"].horzalign = "fullscreen";
    level.TeamElems["AlliesScore"].vertalign = "fullscreen";
    level.TeamElems["AlliesScore"].alpha = 1;
    level.TeamElems["AlliesScore"].sort = 1;
    level.TeamElems["AlliesScore"].color = (1,1,1);
    level.TeamElems["AlliesScore"].archived = true;
    level.TeamElems["AlliesScore"].fontscale = 1;
    level.TeamElems["AlliesScore"].foreground = true;
    level.TeamElems["AlliesScore"].hidewheninmenu = true;
    level.TeamElems["AlliesScore"].hideWhenInKillcam = true;
    level.TeamElems["AlliesScore"].hideWhenDead = true;
    level.TeamElems["AlliesScore"] thread DestroyWhenEndGame();
    
    level.TeamElems["AxisScore"] = newhudelem();
    level.TeamElems["AxisScore"].x = 340;
    level.TeamElems["AxisScore"].y = 15;
    level.TeamElems["AxisScore"].alignx = "center";
    level.TeamElems["AxisScore"].horzalign = "fullscreen";
    level.TeamElems["AxisScore"].vertalign = "fullscreen";
    level.TeamElems["AxisScore"].alpha = 1;
    level.TeamElems["AxisScore"].sort = 1;
    level.TeamElems["AxisScore"].color = (1,1,1);
    level.TeamElems["AxisScore"].archived = true;
    level.TeamElems["AxisScore"].fontscale = 1;
    level.TeamElems["AxisScore"].foreground = true;
    level.TeamElems["AxisScore"].hidewheninmenu = true;
    level.TeamElems["AxisScore"].hideWhenInKillcam = true;
    level.TeamElems["AxisScore"].hideWhenDead = true;
    level.TeamElems["AxisScore"] thread DestroyWhenEndGame();
    
    level.TeamElems["AxisBarBack"] = newhudelem();
    level.TeamElems["AxisBarBack"].x = 350;
    level.TeamElems["AxisBarBack"].y = 20;
    level.TeamElems["AxisBarBack"].alignx = "left";
    level.TeamElems["AxisBarBack"].horzalign = "fullscreen";
    level.TeamElems["AxisBarBack"].vertalign = "fullscreen";
    level.TeamElems["AxisBarBack"].alpha = 0.5;
    level.TeamElems["AxisBarBack"].sort = 1;
    level.TeamElems["AxisBarBack"].color = (1,1,1);
    level.TeamElems["AxisBarBack"].archived = true;
    level.TeamElems["AxisBarBack"] setshader("black", 50, 5);
    level.TeamElems["AxisBarBack"].hidewheninmenu = true;
    level.TeamElems["AxisBarBack"].hideWhenInKillcam = true;
    level.TeamElems["AxisBarBack"].hideWhenDead = true;
    level.TeamElems["AxisBarBack"] thread DestroyWhenEndGame();
    
    level.TeamElems["AxisBar"] = newhudelem();
    level.TeamElems["AxisBar"].x = level.TeamElems["AxisBarBack"].x + 1;
    level.TeamElems["AxisBar"].y = 21;
    level.TeamElems["AxisBar"].alignx = "left";
    level.TeamElems["AxisBar"].horzalign = "fullscreen";
    level.TeamElems["AxisBar"].vertalign = "fullscreen";
    level.TeamElems["AxisBar"].alpha = 1;
    level.TeamElems["AxisBar"].sort = 1;
    level.TeamElems["AxisBar"].color = level.vars["Axis"];
    level.TeamElems["AxisBar"].archived = true;
    level.TeamElems["AxisBar"] setshader("white", 1, 5);
    level.TeamElems["AxisBar"].foreground = true;
    level.TeamElems["AxisBar"].hidewheninmenu = true;
    level.TeamElems["AxisBar"].hideWhenInKillcam = true;
    level.TeamElems["AxisBar"].hideWhenDead = true;
    level.TeamElems["AxisBar"] thread DestroyWhenEndGame();
    
    level.TeamElems["AlliesBarBack"] = newhudelem();
    level.TeamElems["AlliesBarBack"].x = 290;
    level.TeamElems["AlliesBarBack"].y = 20;
    level.TeamElems["AlliesBarBack"].alignx = "right";
    level.TeamElems["AlliesBarBack"].horzalign = "fullscreen";
    level.TeamElems["AlliesBarBack"].vertalign = "fullscreen";
    level.TeamElems["AlliesBarBack"].alpha = 0.5;
    level.TeamElems["AlliesBarBack"].sort = 0;
    level.TeamElems["AlliesBarBack"].color = (1,1,1);
    level.TeamElems["AlliesBarBack"].archived = true;
    level.TeamElems["AlliesBarBack"] setshader("black", 50, 5);
    level.TeamElems["AlliesBarBack"].hidewheninmenu = true;
    level.TeamElems["AlliesBarBack"].hideWhenInKillcam = true;
    level.TeamElems["AlliesBarBack"].hideWhenDead = true;
    level.TeamElems["AlliesBarBack"] thread DestroyWhenEndGame();
    
    level.TeamElems["AlliesBar"] = newhudelem();
    level.TeamElems["AlliesBar"].x = level.TeamElems["AlliesBarBack"].x - 1;
    level.TeamElems["AlliesBar"].y = 21;
    level.TeamElems["AlliesBar"].alignx = "right";
    level.TeamElems["AlliesBar"].horzalign = "fullscreen";
    level.TeamElems["AlliesBar"].vertalign = "fullscreen";
    level.TeamElems["AlliesBar"].alpha = 1;
    level.TeamElems["AlliesBar"].sort = 2;
    level.TeamElems["AlliesBar"].color = level.vars["Allies"];
    level.TeamElems["AlliesBar"].archived = true;
    level.TeamElems["AlliesBar"] setshader("white", 1, 5);
    level.TeamElems["AlliesBar"].foreground = true;
    level.TeamElems["AlliesBar"].hidewheninmenu = true;
    level.TeamElems["AlliesBar"].hideWhenInKillcam = true;
    level.TeamElems["AlliesBar"].hideWhenDead = true;
    level.TeamElems["AlliesBar"] thread DestroyWhenEndGame();
    
    level.TeamElems["GunRotation"] = newhudelem();
    level.TeamElems["GunRotation"].x = 7;
    level.TeamElems["GunRotation"].y = 120;
    level.TeamElems["GunRotation"].alignx = "left";
    level.TeamElems["GunRotation"].aligny = "middle";
    level.TeamElems["GunRotation"].horzalign = "fullscreen";
    level.TeamElems["GunRotation"].vertalign = "fullscreen";
    level.TeamElems["GunRotation"].sort = 2;
    level.TeamElems["GunRotation"].color = (1,1,1);
    level.TeamElems["GunRotation"].archived = false;
    level.TeamElems["GunRotation"].foreground = true;
    level.TeamElems["GunRotation"].fontscale = 1.2;
	level.TeamElems["GunRotation"].hidewheninmenu = true;
	level.TeamElems["GunRotation"].hideWhenInKillcam = true;
    level.TeamElems["GunRotation"].hideWhenDead = true;
    level.TeamElems["GunRotation"].label = &"Gun Rotation ^:";
    level.TeamElems["GunRotation"].alpha = 0;
    level.TeamElems["GunRotation"] thread DestroyWhenEndGame();
	
	level.TeamElems["Infect"] = newhudelem();
    level.TeamElems["Infect"].x = 7;
    level.TeamElems["Infect"].y = 135;
    level.TeamElems["Infect"].alignx = "left";
    level.TeamElems["Infect"].aligny = "middle";
    level.TeamElems["Infect"].horzalign = "fullscreen";
    level.TeamElems["Infect"].vertalign = "fullscreen";
    level.TeamElems["Infect"].sort = 2;
    level.TeamElems["Infect"].color = (1,1,1);
    level.TeamElems["Infect"].archived = false;
    level.TeamElems["Infect"].foreground = true;
    level.TeamElems["Infect"].fontscale = 1.1;
	level.TeamElems["Infect"].hidewheninmenu = true;
	level.TeamElems["Infect"].hideWhenInKillcam = true;
    level.TeamElems["Infect"].hideWhenDead = true;
    level.TeamElems["Infect"].label = &"Infection Countdown ^:";
    level.TeamElems["Infect"].alpha = 1;
	level.TeamElems["Infect"] SetTenthsTimer(10);
	level.TeamElems["Infect"] thread DestroyWhenEndGame();
    allieswidth = 0;
    axiswidth = 0;	
    while(1) {
    	game["teamScores"]["axis"] = int(level maps\mp\gametypes\_teams::CountPlayers()["axis"]);
    	game["teamScores"]["allies"] = int(level maps\mp\gametypes\_teams::CountPlayers()["allies"]);
    	maps\mp\gametypes\_globallogic_score::updateTeamScores( "axis" );
    	maps\mp\gametypes\_globallogic_score::updateTeamScores( "allies" );
		allieswidth = ((level maps\mp\gametypes\_teams::CountPlayers()["allies"] * level.players.size) / level.players.size) * 48 / level.players.size;
		axiswidth = ((level maps\mp\gametypes\_teams::CountPlayers()["axis"] * level.players.size) / level.players.size) * 48 / level.players.size;
		if(level maps\mp\gametypes\_teams::CountPlayers()["allies"] == 0) {
			if(level.TeamElems["AlliesBar"].alpha == 1)
				level.TeamElems["AlliesBar"].alpha = 0;
		}
		else {
			if(level.TeamElems["AlliesBar"].alpha == 0)
				level.TeamElems["AlliesBar"].alpha = 1;
			level.TeamElems["AlliesBar"] setshader("white", int(allieswidth), 3);
		}
		
		if(level maps\mp\gametypes\_teams::CountPlayers()["axis"] == 0) {
			if(level.TeamElems["AxisBar"].alpha == 1)
				level.TeamElems["AxisBar"].alpha = 0;
		}
		else {
			if(level.TeamElems["AxisBar"].alpha == 0)
				level.TeamElems["AxisBar"].alpha = 1;
			level.TeamElems["AxisBar"] setshader("white", int(axiswidth), 3);
		}
		
		level.TeamElems["AlliesScore"] setvalue(level maps\mp\gametypes\_teams::CountPlayers()["allies"]);
		level.TeamElems["AxisScore"] setvalue(level maps\mp\gametypes\_teams::CountPlayers()["axis"]);
		if(game["teamScores"]["axis"] != 1 && isdefined(level.firstinfectedplayer)) {
			level.firstinfectedplayer thread giveCustomLoadout();
			level.firstinfectedplayer = undefined;
		}
		
		if(isdefined(level.gamebegin) && level.gamebegin == 1) {
			if(game["teamScores"]["allies"] == 1 && !isdefined(level.globaluavonline))
				level GloabalUAV(1);
			else if(game["teamScores"]["allies"] != 1 && isdefined(level.globaluavonline))
				level GloabalUAV(0);
		}
		
		if(game["teamScores"]["axis"] == 0 && isdefined(level.firstkillfallen))
			thread maps\mp\gametypes\_globallogic::endGame("allies", "");
		
		if(game["teamScores"]["allies"] == 0 && isdefined(level.firstkillfallen))
			thread maps\mp\gametypes\_globallogic::endGame("axis", "");
		
		wait .1;
    }
}

Jumppadtester() {
	/*setdvar("jumpdytesty", 3);
	while(1) {
		if(self jumpbuttonpressed()) {
			vel = self getvelocity();
			self setvelocity(vector_scale((vel[0],vel[1],vel[2] + 25), getdvarint("jumpdytesty")));
			wait 2;
		}
		self iprintln("Origin ^:" + self.origin);
		wait 0.05;
	}*/
}

CreateJumpPad(Origin, Velocity, Num) {
	level endon("game_ended");
	trigger = Spawn( "trigger_radius", Origin, 1, 50, 50);
	zone = spawn("script_model", Origin);
    zone setModel("weapon_c4_mp_detect");
	while(1) {
		trigger waittill("trigger", who);
		
		if(who jumpbuttonpressed() && !who isOnLadder() && !who isMantling()) {
			vel = who getvelocity();
			who setvelocity(vector_scale((0, 0, vel[2] + Velocity), Num));
			wait 1;
		}
	}
}

GloabalUAV(state) {
	if(state == 1) {
		level.globaluavonline = 1;
		for(i = 0;i < level.players.size;i++) {
			if(level.players[i].sessionteam == "axis") {
				level.players[i].pers["hasRadar"] = 1;
				level.players[i].hasSpyplane = 1;
				level.players[i] setClientUIVisibilityFlag( "radar_client", 1);
			}
		}
		iprintlnbold("Last ^2Human^7 Position ^2Revealed^7!");
	}
	else if(state == 0) {
		level.globaluavonline = undefined;
		for(i = 0;i < level.players.size;i++) {
			if(level.players[i].sessionteam == "axis") {
				level.players[i].pers["hasRadar"] = 0;
				level.players[i].hasSpyplane = 0;
				level.players[i] setClientUIVisibilityFlag( "radar_client", 0);
			}
		}
	}
}

DestroyWhenEndGame() {
	self endon("gone");
	level waittill("game_ended");
	if(isdefined(self))
		self destroy();
}

onPlayerDisconnect() {
	level endon("game_ended");
	for(;;) {
		level waittill("DCWatcherNotify");
		
		if ( !isdefined(level.infect_choseFirstInfected ) ) {				
			if(level maps\mp\gametypes\_teams::CountPlayers()["allies"] == 0) {
				thread maps\mp\gametypes\_globallogic::endGame("axis", "");
			}
			else if(level maps\mp\gametypes\_teams::CountPlayers()["axis"] == 0) {
				level.TeamElems["Infect"].alpha = 1;
				level.TeamElems["Infect"] SetTenthsTimer(10);
				level thread ChooseInfected();				
			}
			else if(level maps\mp\gametypes\_teams::CountPlayers()["axis"] == 1 && !isdefined(level.firstinfectedplayer)) {
				for(i = 0;i < level.players.size;i++) {
					if(level.players[i].team == "axis") {
						level.initialinfected = 1;
						level.firstinfectedplayer = level.players[i];
						level.players[i] thread giveCustomLoadout();
					}
				}
			}
		}	
		wait .05;
	}
}

getRandomGunFromProgression() {	
	weaponIDKeys = GetArrayKeys( level.tbl_weaponIDs );
	numWeaponIDKeys = weaponIDKeys.size;
	
	while ( true ) {
		wait 0.05;
		randomIndex = RandomInt( numWeaponIDKeys+level.gunProgression.size );
		baseWeaponName = "";
		weaponName = "";
		
		if ( randomIndex < numWeaponIDKeys ) {
			id = random( level.tbl_weaponIDs );
			if ( ( id[ "slot" ] != "primary" ) && ( id[ "slot" ] != "secondary" ) )
				continue;
				
			if ( id[ "reference" ] == "weapon_null" )
				continue;
				
			if ( id[ "cost" ] == "-1" )
				continue;
				
			baseWeaponName = id[ "reference" ];
			attachmentList = id[ "attachment" ];
			weaponName = addRandomAttachmentToWeaponName_N( baseWeaponName, attachmentList );
		}
		else {
			baseWeaponName = level.gunProgression[randomIndex - numWeaponIDKeys].names[0];
			weaponName = level.gunProgression[randomIndex - numWeaponIDKeys].names[0];
		}
		
		if ( !IsDefined( level.usedBaseWeapons ) ) {
			level.usedBaseWeapons = [];
			level.usedBaseWeapons[level.usedBaseWeapons.size] = "strela";
			level.usedBaseWeapons[level.usedBaseWeapons.size] = "m72_law";
			level.usedBaseWeapons[level.usedBaseWeapons.size] = "rpg";
			level.usedBaseWeapons[level.usedBaseWeapons.size] = "china_lake";
			level.usedBaseWeapons[level.usedBaseWeapons.size] = "knife_ballistic";
			level.usedBaseWeapons[level.usedBaseWeapons.size] = "crossbow_explosive";
			level.usedBaseWeapons[level.usedBaseWeapons.size] = "mac11dw";
			level.usedBaseWeapons[level.usedBaseWeapons.size] = "aspdw";
			level.usedBaseWeapons[level.usedBaseWeapons.size] = "asp";
			level.usedBaseWeapons[level.usedBaseWeapons.size] = "cz75";
			level.usedBaseWeapons[level.usedBaseWeapons.size] = "m1911";
			level.usedBaseWeapons[level.usedBaseWeapons.size] = "makarov";
			level.usedBaseWeapons[level.usedBaseWeapons.size] = "python";
			level.usedBaseWeapons[level.usedBaseWeapons.size] = "cz75dw";
			level.usedBaseWeapons[level.usedBaseWeapons.size] = "m1911dw";
			level.usedBaseWeapons[level.usedBaseWeapons.size] = "kiparisdw";
			level.usedBaseWeapons[level.usedBaseWeapons.size] = "pm63dw";
			level.usedBaseWeapons[level.usedBaseWeapons.size] = "skorpiondw";
			level.usedBaseWeapons[level.usedBaseWeapons.size] = "hs10dw";
			level.usedBaseWeapons[level.usedBaseWeapons.size] = "pythondw";
			level.usedBaseWeapons[level.usedBaseWeapons.size] = "makarovdw";
		}
		skipWeapon = false;
		for ( i = 0 ; i < level.usedBaseWeapons.size ; i++ ) {
			if ( level.usedBaseWeapons[i] == baseWeaponName ) {
				skipWeapon = true;
				break;
			}
		}
		if ( skipWeapon )
			continue;
		level.usedBaseWeapons[level.usedBaseWeapons.size] = baseWeaponName;
		weaponName = weaponName+"_mp";
		return weaponName;
	}
}

GunRotation() {
	level waittill("prematch_over");
	level.TeamElems["GunRotation"].alpha = 1;
	camo = 4;
	while(1) {
		level.TeamElems["GunRotation"] SetTenthsTimer(45);
		level.shrpRandomWeapon = getRandomGunFromProgression();
		camo = randomintrange(0,16);
		for(i = 0;i < level.players.size;i++) {
			if(level.players[i].team == "allies") {
				weapons = level.players[i] GetWeaponsListPrimaries();
				max = WeaponMaxAmmo(weapons[0]);
				ammo = level.players[i] GetFractionMaxAmmo(weapons[0]);
				stock = ceil((max * ammo));
				if(isdefined(weapons[0]))
					level.players[i] takeweapon(weapons[0]);
				if(isdefined(weapons[1]))
					level.players[i] takeweapon(weapons[1]);
				level.players[i] giveWeapon( level.shrpRandomWeapon, 0, camo);
				level.players[i] switchToWeapon( level.shrpRandomWeapon );
				level.players[i] setWeaponAmmoStock(level.players[i] GetWeaponsListPrimaries()[0], int(stock));
				level.players[i] giveWeapon( "knife_mp" );
				level.players[i] notify("NewGunRotation");
			}
		}
		level.currentrotationweapon = level.shrpRandomWeapon;
		level.currentrotationcamo = camo;
		wait 45;
	}
}

ChooseInfected() {
	flag_wait("prematch_over");
	level.infect_choseFirstInfected = 1;
	wait 10;
	num = randomintrange(0, level.players.size);
	
	level.initialinfected = 1;
	level.gamebegin = 1;
	
	firstinf = level.players[num];
	firstinf suicide();
	firstinf.pers["team"] = "axis";
	firstinf.team = "axis";
	level.firstinfectedplayer = firstinf;
	level notify("firstinfectchoosen");
	
	if(isdefined(level.ClassSettings["FirstInfected"].grenade) && level.ClassSettings["FirstInfected"].grenade != "none") {
		firstinf setOffhandPrimaryClass( level.ClassSettings["FirstInfected"].grenade );
		firstinf giveWeapon( level.ClassSettings["FirstInfected"].grenade );
		firstinf setWeaponAmmoClip( level.ClassSettings["FirstInfected"].grenade, 2 );
	}
	if(isdefined(level.ClassSettings["FirstInfected"].equipment) && level.ClassSettings["FirstInfected"].equipment != "none") {
		firstinf giveWeapon( level.ClassSettings["FirstInfected"].equipment );
		firstinf SetActionSlot( 1, "weapon", level.ClassSettings["FirstInfected"].equipment );
	}
	
	if(isdefined(level.ClassSettings["FirstInfected"].weapon) && level.ClassSettings["FirstInfected"].weapon != "none")
		firstinf giveWeapon( level.ClassSettings["FirstInfected"].weapon );
	if(isdefined(level.ClassSettings["FirstInfected"].perk1) && level.ClassSettings["FirstInfected"].perk1 != "none")
		firstinf DoGivePerk( level.ClassSettings["FirstInfected"].perk1);
	if(isdefined(level.ClassSettings["FirstInfected"].perk2) && level.ClassSettings["FirstInfected"].perk2 != "none")
		firstinf DoGivePerk( level.ClassSettings["FirstInfected"].perk2);
	if(isdefined(level.ClassSettings["FirstInfected"].perk3) && level.ClassSettings["FirstInfected"].perk3 != "none")
		firstinf DoGivePerk( level.ClassSettings["FirstInfected"].perk3);
	
	level thread maps\mp\_popups::DisplayTeamMessageToAll("First Infected", firstinf);
	
	if(isdefined(level.TeamElems["Infect"]))
		level.TeamElems["Infect"].alpha = 0;
	level.infect_choseFirstInfected = undefined;
}

giveCustomLoadout() {
	self.pers["class"] = level.defaultClass;
	self.class = level.defaultClass;
	self maps\mp\gametypes\_wager::setupBlankRandomPlayer();
	if(isdefined(self.team) && self.team == "axis") {
		if(isdefined(level.initialinfected)) {
			if(isdefined(level.ClassSettings["FirstInfected"].weapon) && level.ClassSettings["FirstInfected"].weapon != "none") {
				self giveWeapon( level.ClassSettings["FirstInfected"].weapon );
				self switchtoweapon( level.ClassSettings["FirstInfected"].weapon );
			}
			
			if(isdefined(level.ClassSettings["FirstInfected"].perk1) && level.ClassSettings["FirstInfected"].perk1 != "none")
				self DoGivePerk( level.ClassSettings["FirstInfected"].perk1);
			
			if(isdefined(level.ClassSettings["FirstInfected"].perk2) && level.ClassSettings["FirstInfected"].perk2 != "none")
				self DoGivePerk( level.ClassSettings["FirstInfected"].perk2);
			
			if(isdefined(level.ClassSettings["FirstInfected"].perk3) && level.ClassSettings["FirstInfected"].perk3 != "none")
				self DoGivePerk( level.ClassSettings["FirstInfected"].perk3);
				
			if(isdefined(level.ClassSettings["FirstInfected"].grenade) && level.ClassSettings["FirstInfected"].grenade != "none") {
				self setOffhandPrimaryClass( level.ClassSettings["FirstInfected"].grenade );
				self giveWeapon( level.ClassSettings["FirstInfected"].grenade );
				self setWeaponAmmoClip( level.ClassSettings["FirstInfected"].grenade, 1 );
			}
			
			if(isdefined(level.ClassSettings["FirstInfected"].equipment) && level.ClassSettings["FirstInfected"].equipment != "none") {
				self giveWeapon( level.ClassSettings["FirstInfected"].equipment );
				self SetActionSlot( 1, "weapon", level.ClassSettings["FirstInfected"].equipment );
			}
		}
		else {
			if(isdefined(level.ClassSettings["Infected"].weapon) && level.ClassSettings["Infected"].weapon != "none") {
				self giveWeapon( level.ClassSettings["Infected"].weapon );
				self switchtoweapon( level.ClassSettings["Infected"].weapon );
			}
			
			if(isdefined(level.ClassSettings["Infected"].perk1) && level.ClassSettings["Infected"].perk1 != "none")
				self DoGivePerk( level.ClassSettings["Infected"].perk1);
			
			if(isdefined(level.ClassSettings["Infected"].perk2) && level.ClassSettings["Infected"].perk2 != "none")
				self DoGivePerk( level.ClassSettings["Infected"].perk2);
			
			if(isdefined(level.ClassSettings["Infected"].perk3) && level.ClassSettings["Infected"].perk3 != "none")
				self DoGivePerk( level.ClassSettings["Infected"].perk3);
				
			if(isdefined(level.ClassSettings["Infected"].grenade) && level.ClassSettings["Infected"].grenade != "none") {
				self setOffhandPrimaryClass( level.ClassSettings["Infected"].grenade );
				self giveWeapon( level.ClassSettings["Infected"].grenade );
				self setWeaponAmmoClip( level.ClassSettings["Infected"].grenade, 1 );
			}
			
			if(isdefined(level.ClassSettings["Infected"].equipment) && level.ClassSettings["Infected"].equipment != "none") {
				self giveWeapon( level.ClassSettings["Infected"].equipment );
				self SetActionSlot( 1, "weapon", level.ClassSettings["Infected"].equipment );
				self setWeaponAmmoClip(level.classSetup["Infected"].equipment, 1);
                self setWeaponAmmoStock(level.classSetup["Infected"].equipment, 1);
			}
		}
	}
	else {
		if(isdefined(level.ClassSettings["Survivor"].weapon) && level.ClassSettings["Survivor"].weapon != "none") {
			self giveWeapon( level.ClassSettings["Survivor"].weapon );
			self switchtoweapon( level.ClassSettings["Survivor"].weapon );
		}
		
		if(isdefined(level.ClassSettings["Survivor"].perk1) && level.ClassSettings["Survivor"].perk1 != "none")
			self DoGivePerk( level.ClassSettings["Survivor"].perk1);
		
		if(isdefined(level.ClassSettings["Survivor"].perk2) && level.ClassSettings["Survivor"].perk2 != "none")
			self DoGivePerk( level.ClassSettings["Survivor"].perk2);
		
		if(isdefined(level.ClassSettings["Survivor"].perk3) && level.ClassSettings["Survivor"].perk3 != "none")
			self DoGivePerk( level.ClassSettings["Survivor"].perk3);
		
		if(isdefined(level.currentrotationweapon)) {
			self takeweapon(self GetWeaponsListPrimaries()[0]);
			self takeweapon(self GetWeaponsListPrimaries()[1]);
			self giveweapon(level.currentrotationweapon, 0, level.currentrotationcamo);
			self switchtoweapon(level.currentrotationweapon);
		}
		
		if(isdefined(level.ClassSettings["Survivor"].grenade) && level.ClassSettings["Survivor"].grenade != "none") {
			self setOffhandPrimaryClass( level.ClassSettings["Survivor"].grenade );
			self giveWeapon( level.ClassSettings["Survivor"].grenade );
			self setWeaponAmmoClip( level.ClassSettings["Survivor"].grenade, 1 );
		}
		
		if(isdefined(level.ClassSettings["Survivor"].equipment) && level.ClassSettings["Survivor"].equipment != "none") {
			self giveWeapon( level.ClassSettings["Survivor"].equipment );
			self SetActionSlot( 1, "weapon", level.ClassSettings["Survivor"].equipment );
		}
	}
	self giveWeapon( "knife_mp" );
	if(self.team == "axis")
		self maps\mp\gametypes\_class::setWeaponAmmoOverall(self getcurrentweapon(), 0);
		
	if(isdefined(self.martydomcounter) && self.martydomcounter >= 4)
		self thread JuicedUp();
	else
		self setMoveSpeedScale(1.10);
	self setperk("specialty_extraammo");
	self setperk( "specialty_fallheight" );
    self setperk( "specialty_fastequipmentuse" );
    self setperk( "specialty_fastmantle" );
	self setPerk("specialty_longersprint");
	self setPerk("specialty_unlimitedsprint");
	self setPerk("specialty_noname");
	self setsprintcooldown( 0 );
}

JuicedUp() {
	self endon("death");
	self thread SendDeathstreakNotif();
	self setMoveSpeedScale(1.4);
	wait 3;
	self setMoveSpeedScale(1.10);
}

SendDeathstreakNotif() {
	/*if(isdefined(self.deathstreakrunning))
		self waittill("DeathStreakgone");
	
	self.deathstreakrunning = 1;
	self playLocalSound( "mus_last_stand" );
	
	InfoMessage = newClientHudElem( self );
    InfoMessage.x = 320;
    InfoMessage.x = 200;
    InfoMessage.alignx = "center";
   	InfoMessage.aligny = "bottom";
    InfoMessage.horzalign = "fullscreen";
    InfoMessage.vertalign = "fullscreen";
    InfoMessage.alpha = 1;
   	InfoMessage.sort = 1;
   	InfoMessage.fontscale = 1.4;
   	InfoMessage.glowalpha = 1;
   	InfoMessage.glowColor = (1,0,0);
    InfoMessage.color = (1,1,1);
   	InfoMessage.archived = true;
    InfoMessage settext("JUICED UP");
    InfoMessage.hidewheninmenu = true;
    InfoMessage.hideWhenInKillcam = true;
    
    InfoIcon = newClientHudElem( self );
    InfoIcon.x = 320;
    InfoIcon.x = 230;
    InfoIcon.alignx = "center";
   	InfoIcon.aligny = "bottom";
    InfoIcon.horzalign = "fullscreen";
    InfoIcon.vertalign = "fullscreen";
    InfoIcon.alpha = 1;
   	InfoIcon.sort = 1;
    InfoIcon.color = (1,1,1);
   	InfoIcon.archived = true;
    InfoIcon setshader("hud_icon_syrette", 25, 25);
    InfoIcon.hidewheninmenu = true;
    InfoIcon.hideWhenInKillcam = true;
	wait 1;
	InfoMessage destroy();
	InfoIcon destroy();
	self.deathstreakrunning = undefined;
	self notify("DeathStreakgone");*/
}

giveallperkies() {
	if(!self hasperk("specialty_movefaster"))
		self setPerk("specialty_movefaster");
	if(!self hasperk("specialty_fallheight"))
		self setPerk("specialty_fallheight");
	if(!self hasperk("specialty_scavenger"))
		self setPerk("specialty_scavenger");
	if(!self hasperk("specialty_extraammo"))
		self setPerk("specialty_extraammo");
	if(!self hasperk("specialty_gpsjammer"))
		self setPerk("specialty_gpsjammer");
	if(!self hasperk("specialty_nottargetedbyai"))
		self setPerk("specialty_nottargetedbyai");
	if(!self hasperk("specialty_flakjacket"))
		self setPerk("specialty_flakjacket");
	if(!self hasperk("specialty_killstreak"))
		self setPerk("specialty_killstreak");
	if(!self hasperk("specialty_fireproof"))
		self setPerk("specialty_fireproof");
	if(!self hasperk("specialty_gambler"))
		self setPerk("specialty_gambler");
	if(!self hasperk("specialty_bulletaccuracy"))
		self setPerk("specialty_bulletaccuracy");
	if(!self hasperk("specialty_sprintrecovery"))
		self setPerk("specialty_sprintrecovery");
	if(!self hasperk("specialty_holdbreath"))
		self setPerk("specialty_holdbreath");
	if(!self hasperk("specialty_fastweaponswitch"))
		self setPerk("specialty_fastweaponswitch");
	if(!self hasperk("specialty_bulletpenetration"))
		self setPerk("specialty_bulletpenetration");
	if(!self hasperk("specialty_armorpiercing"))
		self setPerk("specialty_armorpiercing");
	if(!self hasperk("specialty_fastreload"))
		self setPerk("specialty_fastreload");
	if(!self hasperk("specialty_fastads"))
		self setPerk("specialty_fastads");
	if(!self hasperk("specialty_twoattach"))
		self setPerk("specialty_twoattach");
	if(!self hasperk("specialty_twogrenades"))
		self setPerk("specialty_twogrenades");
	if(!self hasperk("specialty_longersprint"))
		self setPerk("specialty_longersprint");
	if(!self hasperk("specialty_unlimitedsprint"))
		self setPerk("specialty_unlimitedsprint");
	if(!self hasperk("specialty_quieter"))
		self setPerk("specialty_quieter");
	if(!self hasperk("specialty_loudenemies"))
		self setPerk("specialty_loudenemies");
	if(!self hasperk("specialty_finalstand"))
		self setPerk("specialty_finalstand");
	if(!self hasperk("specialty_showenemyequipment"))
		self setPerk("specialty_showenemyequipment");
	if(!self hasperk("specialty_detectexplosive"))
		self setPerk("specialty_detectexplosive");
	if(!self hasperk("specialty_gas_mask"))
		self setPerk("specialty_gas_mask");
	if(!self hasperk("specialty_stunprotection"))
		self setPerk("specialty_stunprotection");
	if(!self hasperk("specialty_shades"))
		self setPerk("specialty_shades");
}

CommandsWatcher() {
	self endon("disconnect");
	hey = undefined;
	while(1) {
		hey = self waittill_any_return("Znear", "Fullbright", "suicide");
		if(isalive(self)) {
			if(hey == "Znear") {
				if(!isdefined(self.zfar)) {
					self setclientdvar("r_zfar", 3000);
					self iprintln("Distance Set to ^:3000");
					self.zfar = 1;
				}
				else if(self.zfar == 1) {
					self setclientdvar("r_zfar", 2000);
					self iprintln("Distance Set to ^:2000");
					self.zfar = 2;
				}
				else if(self.zfar == 2) {
					self setclientdvar("r_zfar", 1000);
					self iprintln("Distance Set to ^:1000");
					self.zfar = 3;
				}
				else if(self.zfar == 3) {
					self setclientdvar("r_zfar", 500);
					self iprintln("Distance Set to ^:500");
					self.zfar = 4;
				}
				else if(self.zfar == 4) {
					self setclientdvar("r_zfar", 0);
					self iprintln("Distance Set to ^:Default");
					self.zfar = undefined;
				}
			}
			else if(hey == "Fullbright") {
				if(!isdefined(self.fullbrighty)) {
					self setclientdvar("r_fog", 0);
					self setclientdvar("fx_enable", 0);
					self iprintln("FX/FOG ^:Disabled");
					self.fullbrighty = 1;
				}
				else if(self.fullbrighty == 1) {
					self setclientdvar("r_fullbright", 1);
					self iprintln("Fullbright ^:Enabled");
					self.fullbrighty = 2;
				}
				else if(self.fullbrighty == 2) {
					self setclientdvar("r_fullbright", 1);
					self setclientdvar("r_fog", 0);
					self setclientdvar("fx_enable", 0);
					self iprintln("Fullbright/FX/Fog ^:Enabled");
					self.fullbrighty = 3;
				}
				else if(self.fullbrighty == 3) {
					self setclientdvar("r_fullbright", 0);
					self setclientdvar("r_fog", 1);
					self setclientdvar("fx_enable", 1);
					self iprintln("Fullbright/FX/Fog ^:Reset");
					self.fullbrighty = undefined;
				}
			}
			else if(hey == "suicide") {
				self suicide();
			}
		}
	}
}

onSpawnPlayer() {
	if(!isdefined(self.doubleloadprotection)) {
		self.doubleloadprotection = 1;
		if ( !level.infect_choosingFirstInfected ) {
			level.infect_choosingFirstInfected = true;
			level thread ChooseInfected();
		}	
		
		if(isdefined(level.NukeVision)) {
			self setclientdvar("r_skycolortemp", 1650);
			self setclientdvar("r_filmusetweaks", 0);
			self setclientdvar("r_exposuretweak", 1);
			self setclientdvar("r_filmtweakcolortemp", "4000 4000 4000");
		}
		else {
			self setclientdvar("r_skycolortemp", 25000);
			self setclientdvar("r_filmusetweaks", 0);
			self setclientdvar("r_exposuretweak", 1);
			self setclientdvar("r_filmtweakcolortemp", "6500 6500 6500");
		}
		
		if(self.name != "[3arc]democlient") {
			if(!isdefined(level.playerinfectedlist))
				level.playerinfectedlist = [];
	
			if(isdefined(level.playerinfectedlist[self.name]))
				self SpawnAsInf();
	
			if(!isdefined(self.hasteamy)) {
				self.team = "allies";
				self.pers["team"] = "allies";
				self.sessionteam = "allies";
				self.switching_teams = true;
				self.joining_team = "allies";
				self.leaving_team = self.pers["team"];
				self [[level.allies]]();
				self.hasteamy = 1;
			}
			self.Focus = 0;
			self freezecontrols(false);
			if(!isdefined(self.spawnyhuddy) && self.pers["isbot"] != true) {
				self.spawnyhuddy = 1;
				level.playerinfectedlist[self.name] = 1;
				self thread WeaponHud();
				self thread AmmoTracker();
				self thread LowAmmoCheck();
				self thread HealthBar();
				self thread PointsWatcher();
				self thread DVWatcher();
				self thread set_crossdot();
				self thread CommandsWatcher();
				self thread Jumppadtester();
				self notifyonplayercommand("Znear", "+actionslot 2");
				self notifyonplayercommand("Fullbright", "+actionslot 3");
				self notifyonplayercommand("suicide", "+actionslot 4");
			}
			spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM( spawnPoints );

			self spawn( spawnPoint.origin, spawnPoint.angles, "dm" );
			
			if (self.pers["team"] == "axis")
				spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_axis_start);
			else
				spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_allies_start);
		
			self spawn(spawnpoint.origin, spawnpoint.angles, "twar");
			
			level notify ( "spawned_player" );
			self giveCustomLoadout();
		}
	}
	else {
		if (self.pers["team"] == "axis")
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_axis_start);
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_allies_start);
		
		self spawn(spawnpoint.origin, spawnpoint.angles, "twar");
	}
}

on_connect() {
	level endon("game_ended");
	for(;;) {
		level waittill( "connected", player );
		if(player.name != "[3arc]democlient") {
			player thread doSplash();
			player onSpawnPlayer();
		}
	}
}

SpawnAsInf() {
	self.team = "axis";
	self.pers["team"] = "axis";
	self.sessionteam = "axis";
	self.switching_teams = true;
	self.joining_team = "axis";
	self.leaving_team = self.pers["team"];
	self [[level.axis]]();
	self.hasteamy = 1;
}

upgrade_crosshair() {
    self setclientdvar("cg_cursorHints", 1);
    self setclientdvar("cg_crosshairAlphaMin", 0);
    self set_crossdot();
}

set_crossdot() {
    self endon("disconnect");

    self.crossdot = newclienthudelem(self);
    self.crossdot.horzalign = "center";
    self.crossdot.alignx = "center";
    self.crossdot.vertalign = "middle";
    self.crossdot.aligny = "middle";
    self.crossdot.foreground = true;
    self.crossdot.archived = false;
    self.crossdot.hidewheninmenu = true;
    self.crossdot.sort = 1;
    self.crossdot.hidden = false;
    self.crossdot.color = (.8, .8, .8);
    self.crossdot.hidewhendead = true;
    self.crossdot.hidewheninkillcam = true;
    self.crossdot thread DestroyWhenEndGame();

    self.crossdot_frame = newclienthudelem(self);
    self.crossdot_frame.horzalign = "center";
    self.crossdot_frame.alignx = "center";
    self.crossdot_frame.vertalign = "middle";
    self.crossdot_frame.aligny = "middle";
    self.crossdot_frame.foreground = true;
    self.crossdot_frame.archived = false;
    self.crossdot_frame.hidewheninmenu = true;
    self.crossdot_frame.hidden = false;
    self.crossdot_frame.color = (.125, .125, .125);
    self.crossdot_frame.hidewhendead = true;
    self.crossdot_frame.hidewheninkillcam = true;
    self.crossdot_frame thread DestroyWhenEndGame();

    self.crossdot_frame setshader("menu_mp_lobby_frame_circle", 4, 4);
    self.crossdot setshader("menu_mp_lobby_frame_circle", 2, 2);
    self thread ads_crossdot();
}

ads_crossdot() {
    self endon("disconnect");
    level endon("end_game");

    while (true) {
        if (!self.crossdot.hidden && !self.crossdot_frame.hidden) {
            is_aiming = self playerads() > .75;

            self.crossdot.alpha = !is_aiming;
            self.crossdot_frame.alpha = !is_aiming;
        }

        wait .1;
    }
}

DVWatcher() {
	self waittill("disconnect");
	level notify("DCWatcherNotify");
}

PointsWatcher() {
	self endon("disconnect");
	level endon("game_ended");
	
	while(1) {
		self waittill_any("PlayerKilledSomeone", "death", "spawned_player");
		if(self.sessionteam != "axis") {
			if(isdefined(self.Focus)) {
				if(self.Focus >= 2 && self.killstreakslots[0].color != (1,1,1)) {
					self.killstreakslots[0].color = (1,1,1);
					self setperk("specialty_movefaster");
    				self setperk("specialty_fallheight");
    				self thread SendMeANotification((1,1,1), "perk_lightweight_pro", 0, (0,.5,1));
				}
				else if(self.Focus < 2 && self.killstreakslots[0].color == (1,1,1))
					self.killstreakslots[0].color = level.ui_grey;
			
				if(self.Focus >= 4 && self.Killstreakslots[1].color != (1,1,1)) {
					self.killstreakslots[1].color = (1,1,1);
					self setperk("specialty_fastreload");
   					self setperk("specialty_fastads");
   					self thread SendMeANotification((1,1,1), "perk_sleight_of_hand_pro", 1, (1, .5, 0));
				}
				else if(self.Focus < 4 && self.killstreakslots[1].color == (1,1,1))
					self.killstreakslots[1].color = level.ui_grey;
			
				if(self.Focus >= 6 && self.Killstreakslots[2].color != (1,1,1)) {
					self.killstreakslots[2].color = (1,1,1);
					self setperk("specialty_scavenger");
    				self thread SendMeANotification((1,1,1), "perk_scavenger_pro", 2, (0, .5, 1));
				}
				else if(self.Focus < 6 && self.killstreakslots[2].color == (1,1,1))
					self.killstreakslots[2].color = level.ui_grey;
					
				if(self.Focus >= 8 && self.Killstreakslots[3].alpha == 0) {
					self.killstreakslots[3].alpha = 1;
					self giveallperkies();
					self thread SendMeANotification((.75,.75,.75), "rank_prestige07", 3, (0.25,0.25,1));
				}
				else if(self.Focus < 8 && self.killstreakslots[3].alpha == 1)
					self.killstreakslots[3].alpha = 0;
					
				if(self.Focus >= 24 && self.Killstreakslots[4].alpha == 0) {
					self.killstreakslots[4].alpha = 1;
					self thread SendMeANotification((1,.5,0), "menu_mp_reticle_radiation", 4, (1, .3, 0), 1);
					self.focus = undefined;
					self thread NukeWatcher();
				}
				else if(self.Focus < 24 && self.killstreakslots[4].alpha == 1)
					self.killstreakslots[4].alpha = 0;
			}
		}
		else {
			self.killstreakslots[0] destroy();
			self.killstreakslots[1] destroy();
			self.killstreakslots[2] destroy();
			self.killstreakslots[3] destroy();
			self.killstreakslots[4] destroy();
			break;
		}
	}
}

NukeWatcher() {
	self endon("nukedone");
	while(1) {
		if(self actionslotonebuttonpressed() && !isdefined(level.nukerunning) && self.team != "axis") {
			level.nukerunning = 1;
			level thread maps\mp\_popups::DisplayTeamMessageToAll("^3TACTICAL NUKE", self);
			self.killstreakslots[0] destroy();
			self.killstreakslots[1] destroy();
			self.killstreakslots[2] destroy();
			self.killstreakslots[3] destroy();
			self.killstreakslots[4] destroy();
			// Create Hud Elem
    		level.TeamElems["NukeSymbol"] = newhudelem();
    		level.TeamElems["NukeSymbol"].x = 320;
    		level.TeamElems["NukeSymbol"].y = 63;
    		level.TeamElems["NukeSymbol"].alignx = "center";
    		level.TeamElems["NukeSymbol"].aligny = "middle";
    		level.TeamElems["NukeSymbol"].horzalign = "fullscreen";
    		level.TeamElems["NukeSymbol"].vertalign = "fullscreen";
    		level.TeamElems["NukeSymbol"].alpha = 1;
    		level.TeamElems["NukeSymbol"].archived = true;
    		level.TeamElems["NukeSymbol"].sort = 1;
    		level.TeamElems["NukeSymbol"].color = (1,0.5,0);
    		level.TeamElems["NukeSymbol"] setshader("menu_mp_reticle_radiation", 25, 25);
    		level.TeamElems["NukeSymbol"].hidewheninmenu = true;
    		level.TeamElems["NukeSymbol"].hideWhenInKillcam = true;
    		level.TeamElems["NukeSymbol"].hideWhenDead = true;
    		level.TeamElems["NukeSymbol"] thread DoAlpha();
    		level.TeamElems["NukeSymbol"] thread DestroyWhenEndGame();
    		
    		level.TeamElems["NukeSymbolBack"] = newhudelem();
    		level.TeamElems["NukeSymbolBack"].x = level.TeamElems["NukeSymbol"].x - 1;
    		level.TeamElems["NukeSymbolBack"].y = 65;
    		level.TeamElems["NukeSymbolBack"].alignx = "center";
    		level.TeamElems["NukeSymbolBack"].aligny = "middle";
    		level.TeamElems["NukeSymbolBack"].horzalign = "fullscreen";
    		level.TeamElems["NukeSymbolBack"].vertalign = "fullscreen";
    		level.TeamElems["NukeSymbolBack"].alpha = 1;
    		level.TeamElems["NukeSymbolBack"].archived = true;
    		level.TeamElems["NukeSymbolBack"].sort = 0;
    		level.TeamElems["NukeSymbolBack"].color = (0,0,0);
    		level.TeamElems["NukeSymbolBack"] setshader("menu_mp_reticle_circles02", 55, 55);
    		level.TeamElems["NukeSymbolBack"].hidewheninmenu = true;
    		level.TeamElems["NukeSymbolBack"].hideWhenInKillcam = true;
    		level.TeamElems["NukeSymbolBack"].hideWhenDead = true;
    		level.TeamElems["NukeSymbolBack"] thread DoAlpha();
    		level.TeamElems["NukeSymbolBack"] thread DestroyWhenEndGame();
    		
    		level.TeamElems["NukeTimer"] = newhudelem();
   			level.TeamElems["NukeTimer"].x = level.TeamElems["NukeSymbol"].x;
    		level.TeamElems["NukeTimer"].y = level.TeamElems["NukeSymbol"].y + 24;
    		level.TeamElems["NukeTimer"].alignx = "center";
    		level.TeamElems["NukeTimer"].horzalign = "fullscreen";
    		level.TeamElems["NukeTimer"].vertalign = "fullscreen";
    		level.TeamElems["NukeTimer"].alpha = 1;
    		level.TeamElems["NukeTimer"].sort = 2;
    		level.TeamElems["NukeTimer"].archived = true;
    		level.TeamElems["NukeTimer"].foreground = true;
    		level.TeamElems["NukeTimer"].fontscale = 1.1;
    		level.TeamElems["NukeTimer"].glowalpha = 1;
			level.TeamElems["NukeTimer"].hidewheninmenu = true;
    		level.TeamElems["NukeTimer"].hideWhenDead = true;
    		level.TeamElems["NukeTimer"] SetTenthsTimer(10);
    		level.TeamElems["NukeTimer"].glowcolor = (1,.5,0);
    		level.TeamElems["NukeTimer"] thread DestroyWhenEndGame();
    		for(i = 0;i < 10;i++) {
    			thread playSoundOnPlayers( "wpn_semtex_alert");
    			wait 1;
    		}
    		level.TeamElems["NukeTimer"] notify("gone");
    		level.TeamElems["NukeSymbolBack"] notify("gone");
    		level.TeamElems["NukeTimer"] destroy();
    		level.TeamElems["NukeSymbol"] destroy();
    		level.TeamElems["NukeSymbolBack"] destroy();
    		for(i = 0;i < level.players.size;i++) {
    			level.players[i] thread AftermathVision();
    			level.players[i] thread SkyColor();
    		}
    		Earthquake(0.8,7,self.origin,2000);
    		for(i = 1;i < 12;i += 0.5) {
    			for(a = 0;a < level.players.size;a++)
    				level.players[a] setclientdvar("r_exposurevalue", i);
    			wait 0.05;
    		}
    		thread playsoundinspace( "mpl_kls_napalm_exlpo", (0,0,1000));
    		thread playsoundinspace( "mpl_kls_napalm_exlpo", (100,100,900));
    		thread playsoundinspace( "mpl_kls_napalm_exlpo", (0,100,800));
    		thread playsoundinspace( "mpl_kls_napalm_exlpo", (100,0,1000));
    		thread playsoundinspace( "mpl_kls_napalm_exlpo", (200,0,1000));
    		thread playsoundinspace( "mpl_kls_napalm_exlpo", (0,200,1000));
    		thread playsoundinspace( "mpl_kls_napalm_exlpo", (300,0,1000));
    		thread playsoundinspace( "mpl_kls_napalm_exlpo", (0,500,1000));
    		thread playsoundinspace( "mpl_kls_napalm_exlpo", (300,500,1000));
    		thread playsoundinspace( "mpl_kls_napalm_exlpo", (500,100,1000));
    		thread playsoundinspace( "mpl_kls_napalm_exlpo", (600,700,900));
    		thread playsoundinspace( "mpl_kls_napalm_exlpo", (1000,1000,800));
    		thread playsoundinspace( "mpl_kls_napalm_exlpo", (900,1500,1000));
    		thread playsoundinspace( "mpl_kls_napalm_exlpo", (800,2000,1000));
    		thread playsoundinspace( "mpl_kls_napalm_exlpo", (2000,100,1000));
    		thread playsoundinspace( "mpl_kls_napalm_exlpo", (666,444,1000));
    		thread playsoundinspace( "mpl_kls_napalm_exlpo", (324,454,1000));
    		thread playsoundinspace( "mpl_kls_napalm_exlpo", (900,1000,1000));
    		wait 1;
    		for(i = 10;i > 1;i -= 0.5) {
    			for(a = 0;a < level.players.size;a++) {
    				level.players[a] setclientdvar("r_exposurevalue", i);
    			}
    			wait 0.1;
    		}
    		wait 0.5;
    		Earthquake(0.8,7,self.origin,2000);
    		for(i = 1;i < 12;i += 0.5) {
    			for(a = 0;a < level.players.size;a++)
    				level.players[a] setclientdvar("r_exposurevalue", i);
    			wait 0.05;
    		}
    		thread playSoundOnPlayers( "mpl_kls_napalm_exlpo");
    		thread playSoundOnPlayers( "mpl_kls_napalm_exlpo");
    		thread playSoundOnPlayers( "mpl_kls_napalm_exlpo");
    		thread playSoundOnPlayers( "mpl_kls_napalm_exlpo");
    		thread playSoundOnPlayers( "mpl_kls_napalm_exlpo");
    		thread playSoundOnPlayers( "mpl_kls_napalm_exlpo");
    		thread playSoundOnPlayers( "mpl_kls_napalm_exlpo");
    		thread playSoundOnPlayers( "mpl_kls_napalm_exlpo");
    		thread playSoundOnPlayers( "mpl_kls_napalm_exlpo");
    		thread playSoundOnPlayers( "mpl_kls_napalm_exlpo");
    		thread playSoundOnPlayers( "mpl_kls_napalm_exlpo");
    		thread playSoundOnPlayers( "mpl_kls_napalm_exlpo");
    		wait 1;
    		thread playSoundOnPlayers( "mpl_kls_exlpo_tinitus");
    		for(i = 0;i < level.players.size;i++) {
    			PlayRumbleOnPosition( "artillery_rumble", level.players[i].origin);
    			if(level.players[i].team == "axis")
    				level.players[i] DoDamage(int(level.players[i].health * 2), level.players[i].origin, self, self, 0, "MOD_EXPLOSIVE", 0, "weapon_reticle_radiation");
    		}
    		spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM( spawnPoints );
			self setorigin(spawnPoint.origin);
			self setplayerangles(spawnPoint.angles);
			for(i = 10;i > 1;i -= 0.5) {
    			for(a = 0;a < level.players.size;a++)
    				level.players[a] setclientdvar("r_exposurevalue", i);
    			wait 0.1;
    		}
    		level.nukerunning = undefined;
    		level.NukeVision = 1;
    		self notify("nukedone");
		}
		wait .05;
	}
}

DoAlpha() {
	self endon("Gone");
	while(isdefined(self)) {
		self fadeOverTime( 0.5 );
		self.alpha = 0;
		wait 0.5;
		self fadeOverTime( 0.5 );
		self.alpha = 1;
		wait 0.5;
	}
}

AftermathVision() {
	self endon("disconnect");
	self setclientdvar("r_filmusetweaks", 1);
    self setclientdvar("r_filmtweakcolortemp", "6000 6000 6000");
    wait 0.2;
    self setclientdvar("r_filmtweakcolortemp", "5500 5500 5500");
    wait 0.2;
    self setclientdvar("r_filmtweakcolortemp", "5300 5300 5300");
    wait 0.2;
    self setclientdvar("r_filmtweakcolortemp", "5000 5000 5000");
    wait 0.2;
    self setclientdvar("r_filmtweakcolortemp", "4800 4800 4800");
    wait 0.2;
    self setclientdvar("r_filmtweakcolortemp", "4500 4500 4500");
    wait 0.2;
    self setclientdvar("r_filmtweakcolortemp", "4300 4300 4300");
    wait 0.2;
    self setclientdvar("r_filmtweakcolortemp", "4000 4000 4000");
}

SkyColor() {
	self endon("disconnect");
	for(i = 25000;i > 2000;i -= 1000) {
		self setclientdvar("r_skycolortemp", i);
		if(i == 1000)
			self setclientdvar("r_skycolortemp", 1650);
		wait 0.1;
	}
}

NukeTimescale() {
	for(i = 1;i > 0.3;i -= 0.1) {
		setdvar("timescale", i);
		wait 0.07;
	}
	wait 2;
	for(i = 0.3;i < 1.1;i += 0.1) {
		setdvar("timescale", i);
		wait 0.07;
	}
}

HealthBar() {
	level endon("game_ended");
    self endon("disconnect");

    x = 15;
    y = 450;
	base_width = 60;
	base_height = 3;
	init_width = base_width * (self.maxhealth / 100);
    
	self.health_bar = newClientHudElem( self );
    self.health_bar.x = x + 1;
    self.health_bar.y = y;
    self.health_bar.alignx = "left";
    self.health_bar.aligny = "bottom";
    self.health_bar.horzalign = "fullscreen";
    self.health_bar.vertalign = "fullscreen";
    self.health_bar.alpha = 1;
    self.health_bar.archived = false;
    self.health_bar.foreground = true;
    self.health_bar.hidewheninmenu = true;
    self.health_bar.hideWhenInKillcam = true;
    self.health_bar setshader("white", int(init_width), int(base_height));
    self.health_bar thread DestroyWhenEndGame();
    
	self.health_bar_frame = newClientHudElem( self );
    self.health_bar_frame.x = x;
    self.health_bar_frame.y = y + 1;
    self.health_bar_frame.alignx = "left";
    self.health_bar_frame.aligny = "bottom";
    self.health_bar_frame.horzalign = "fullscreen";
    self.health_bar_frame.vertalign = "fullscreen";
    self.health_bar_frame.alpha = .75;
    self.health_bar_frame.sort = -1;
    self.health_bar_frame.color = (0,0,0);
    self.health_bar_frame.archived = false;
    self.health_bar_frame.foreground = true;
    self.health_bar_frame.hidewheninmenu = true;
    self.health_bar_frame.hideWhenInKillcam = true;
    self.health_bar_frame setshader("white", int(base_width) + 2, int(base_height) + 2);
    self.health_bar_frame thread DestroyWhenEndGame();

	self.health_text = self createFontString( "default", 1 );
    self.health_text.x = x + base_width + 2 + 3;
    self.health_text.y = y + 3.5;
    self.health_text.alignx = "left";
    self.health_text.aligny = "bottom";
    self.health_text.horzalign = "fullscreen";
    self.health_text.vertalign = "fullscreen";
    self.health_text.alpha = 1;
    self.health_text.archived = false;
    self.health_text.foreground = true;
    self.health_text.hidewheninmenu = true;
    self.health_text.hideWhenInKillcam = true;
    self.health_text thread DestroyWhenEndGame();
    
    self.namehud = self createFontString( "default", 1 );
    self.namehud.x = x;
    self.namehud.y = 465;
    self.namehud.alignx = "left";
    self.namehud.aligny = "bottom";
    self.namehud.horzalign = "fullscreen";
    self.namehud.vertalign = "fullscreen";
    self.namehud.alpha = 1;
    self.namehud.color = (1,1,1);
    self.namehud.archived = false;
    self.namehud.foreground = true;
    self.namehud.hidewheninmenu = true;
    self.namehud settext(self.name);
    self.namehud.hideWhenInKillcam = true;
    self.namehud thread DestroyWhenEndGame();

    if (!isDefined(self.maxhealth) || self.maxhealth <= 0)
		self.maxhealth = 100;
	
	self AllowSprint( true );
	
    while (1) {	
    	if(isalive(self)) {
			low_health = self.health < 25;
		
			if(low_health) 
				color = (1,0,0);
			else 
				color = (1,1,1);
			
       	 	width = (self.health / self.maxhealth) * base_width * (self.maxhealth / 100);
       	 	width = int(max(width, 1));

        	self.health_bar.color = color;
			self.health_bar setShader("white", width, base_height);

        	self.health_text.color = color;
        	self.health_text setValue(self.health);
        }
    	wait .05;
    }
}

AmmoTracker() {
	self endon("disconnect");
    level endon("game_ended");	
    loadout_primary = "";
    loadout_primary_count = 0;
	while(1) {
		wait .05;
		if(isalive(self)) {
			weapon = self getcurrentweapon();
        	self.WeaponAmmoText setvalue(self getweaponammoclip(weapon));
        	self.WeaponAmmoTextStock setvalue(self getweaponammostock(weapon));
        
       	 	loadout_primary = self getcurrentoffhand( "primarygrenade" );
        	loadout_primary_count = self getammocount(loadout_primary);
        	if ( loadout_primary == "frag_grenade_mp" ) {
        		if(loadout_primary_count >= 1 && self.GrenadeHud.alpha == 0) {
					self.GrenadeHud.alpha = 1;
					self.GrenadeName.alpha = 1;
				}
				else if(loadout_primary_count <= 0 && self.GrenadeHud.alpha == 1 ) {
					self.GrenadeHud.alpha = 0;
					self.GrenadeName.alpha = 0;
				}
				
        		if(self.GrenadeHud.shadericon != "hud_grenadeicon") {
        			self.GrenadeHud setshader("hud_grenadeicon", 18, 18);
        			self.GrenadeHud.shadericon = "hud_grenadeicon";
        		}
        	}
       	 	else if ( loadout_primary == "hatchet_mp" ) {
        		if(loadout_primary_count >= 1 && self.GrenadeHud.alpha == 0) {
					self.GrenadeHud.alpha = 1;
					self.GrenadeName.alpha = 1;
				}
				else if(loadout_primary_count <= 0 && self.GrenadeHud.alpha == 1 ) {
					self.GrenadeHud.alpha = 0;
					self.GrenadeName.alpha = 0;
				}
			
        		if(self.GrenadeHud.shadericon != "hud_hatchet") {
        			self.GrenadeHud setshader("hud_hatchet", 18, 18);
        			self.GrenadeHud.shadericon = "hud_hatchet";
        		}
        	}
       	 	else if ( loadout_primary == "sticky_grenade_mp" ) {
        		if(loadout_primary_count >= 1 && self.GrenadeHud.alpha == 0) {
					self.GrenadeHud.alpha = 1;
					self.GrenadeName.alpha = 1;
				}
				else if(loadout_primary_count <= 0 && self.GrenadeHud.alpha == 1 ) {
					self.GrenadeHud.alpha = 0;
					self.GrenadeName.alpha = 0;
				}
			
        		if(self.GrenadeHud.shadericon != "hud_icon_sticky_grenade") {
        			self.GrenadeHud setshader("hud_icon_sticky_grenade", 18, 18);
        			self.GrenadeHud.shadericon = "hud_icon_sticky_grenade";
        		}
       		}
			else {
				self.GrenadeHud.alpha = 0;
				self.GrenadeName.alpha = 0;
        	}
        
        	if(self HasWeapon( "tactical_insertion_mp" )) {
        		loadout_secondary_count = self getammocount("tactical_insertion_mp");
        		if(loadout_secondary_count >= 1 && self.EmpHud.alpha == 0) {
					self.EmpHud.alpha = 1;
					self.EmpHudText.alpha = 1;
				}
				else if(loadout_secondary_count <= 0 && self.EmpHud.alpha == 1 ) {
					self.EmpHud.alpha = 0;
					self.EmpHudText.alpha = 0;
				}
		
        		if(self.EmpHud.shadericon != "hud_tact_insert") {
        			self.EmpHud setshader("hud_tact_insert", 18, 18);
        			self.EmpHud.shadericon = "hud_tact_insert";
        		}	
	        }
	       	else if(self HasWeapon( "claymore_mp" )) {
        		loadout_secondary_count = self getammocount("claymore_mp");
        		if(loadout_secondary_count >= 1 && self.EmpHud.alpha == 0) {
					self.EmpHud.alpha = 1;
					self.EmpHudText.alpha = 1;
				}
				else if(loadout_secondary_count <= 0 && self.EmpHud.alpha == 1 ) {
					self.EmpHud.alpha = 0;
					self.EmpHudText.alpha = 0;
				}
		
        		if(self.EmpHud.shadericon != "hud_icon_claymore") {
        			self.EmpHud setshader("hud_icon_claymore", 18, 18);
        			self.EmpHud.shadericon = "hud_icon_claymore";
        		}	
        	}
        	else if(self HasWeapon( "camera_spike_mp" )) {
        		loadout_secondary_count = self getammocount("camera_spike_mp");
        		if(loadout_secondary_count >= 1 && self.EmpHud.alpha == 0) {
					self.EmpHud.alpha = 1;
					self.EmpHudText.alpha = 1;
				}
				else if(loadout_secondary_count <= 0 && self.EmpHud.alpha == 1 ) {
					self.EmpHud.alpha = 0;
					self.EmpHudText.alpha = 0;
				}
		
        		if(self.EmpHud.shadericon != "hud_deployable_camera") {
        			self.EmpHud setshader("hud_deployable_camera", 18, 18);
        			self.EmpHud.shadericon = "hud_deployable_camera";
        		}	
        	}
      	  	else if(self HasWeapon( "acoustic_sensor_mp" )) {
       	 		loadout_secondary_count = self getammocount("acoustic_sensor_mp");
        		if(loadout_secondary_count >= 1 && self.EmpHud.alpha == 0) {
					self.EmpHud.alpha = 1;
					self.EmpHudText.alpha = 1;
				}
				else if(loadout_secondary_count <= 0 && self.EmpHud.alpha == 1 ) {
					self.EmpHud.alpha = 0;
					self.EmpHudText.alpha = 0;
				}
		
        		if(self.EmpHud.shadericon != "hud_acoustic_sensor") {
        			self.EmpHud setshader("hud_acoustic_sensor", 18, 18);
        			self.EmpHud.shadericon = "hud_acoustic_sensor";
        		}	
      	  }
      	  else if(self HasWeapon( "scrambler_mp" )) { // shader doesnt work
      		  	loadout_secondary_count = self getammocount("scrambler_mp");
        		if(loadout_secondary_count >= 1 && self.EmpHud.alpha == 0) {
					self.EmpHud.alpha = 1;
					self.EmpHudText.alpha = 1;
				}
				else if(loadout_secondary_count <= 0 && self.EmpHud.alpha == 1 ) {
					self.EmpHud.alpha = 0;
					self.EmpHudText.alpha = 0;
				}
		
        		if(self.EmpHud.shadericon != "hud_icon_scrambler") {
        			self.EmpHud setshader("hud_icon_scrambler", 18, 18);
        			self.EmpHud.shadericon = "hud_icon_scrambler";
        		}	
      	   } 
      	   else {
       	 		self.EmpHud.alpha = 0;
				self.EmpHudText.alpha = 0;
      	   }
     	
        // Check for infected ammo so far
        	if(self.sessionteam == "axis") {
        		self unsetPerk( "specialty_scavenger" );
        		if(self getcurrentweapon() != "none") {
        			if(!IsWeaponEquipment(self getcurrentweapon()))
						self maps\mp\gametypes\_class::setWeaponAmmoOverall(self getcurrentweapon(), 0);
				}
			}
		}
    }
}

LowAmmoCheck() {
	self endon("disconnect");
    level endon("game_ended");	
	while(1) {
		wait .05;
		if(isalive(self)) {
        	if(self getweaponammoclip(self getcurrentweapon()) + self getweaponammostock(self getcurrentweapon()) <= 15) {
        		self.WeaponAmmoTextStock fadeovertime(0.5);
        		self.WeaponAmmoTextStock.color = (1,0,0);
        		self.WeaponAmmoText fadeovertime(0.5);
        		self.WeaponAmmoText.color = (1,0,0);
        		wait 0.5;
        		self.WeaponAmmoTextStock fadeovertime(0.5);
        		self.WeaponAmmoTextStock.color = (1,1,1);
        		self.WeaponAmmoText fadeovertime(0.5);
        		self.WeaponAmmoText.color = (1,1,1);
        		wait 0.5;
       		}
        	else {
        		if(self.WeaponAmmoTextStock.color != (1,1,1)) {
        			self.WeaponAmmoTextStock.color = (1,1,1);
        			wait 0.5;
        		}
        		if(self.WeaponAmmoText.color != (1,1,1)) {
        			self.WeaponAmmoText.color = (1,1,1);
        			wait 0.5;
        		}
        	}
        }
	}
}

SendMeANotification(color, icon, index, glowcolora, howto) {
	self endon("disconnect");
	if(isdefined(self.notification))
		self waittill("NotificationGone");
	
	self.notification = 1;
	xpos = 110;
	ypos = 465;
	
	if(!isdefined(self.killstreakslots))
		self.killstreakslots = [];
	
	self playLocalSound( "mus_challenge_complete" );
	
	InfoMessage = newClientHudElem( self );
    InfoMessage.x = 320;
    if(isdefined(howto))
    	InfoMessage.y = 60;
    else
    	InfoMessage.y = 80;
    InfoMessage.alignx = "center";
   	InfoMessage.aligny = "bottom";
    InfoMessage.horzalign = "fullscreen";
    InfoMessage.vertalign = "fullscreen";
    InfoMessage.alpha = 1;
   	InfoMessage.sort = 1;
   	InfoMessage.fontscale = 1.4;
   	InfoMessage.glowalpha = 1;
   	InfoMessage.glowColor = glowcolora;
    InfoMessage.color = (1,1,1);
   	InfoMessage.archived = true;
   	InfoMessage.foreground = true;
   	if(isdefined(howto))
    	InfoMessage settext("TACTICAL NUKE \n Press ^:[{+actionslot 1}] ^7To Use!");
    else
    	InfoMessage settext(&"MP_BONUS_ACQUIRED");
    InfoMessage.hidewheninmenu = true;
    InfoMessage.hideWhenInKillcam = true;
	
	if(!isdefined(self.killstreakslots[index])) {
		self.killstreakslots[index] = newClientHudElem( self );
    	self.killstreakslots[index].x = 320;
    	self.killstreakslots[index].y = 120;
    	self.killstreakslots[index].alignx = "center";
   		self.killstreakslots[index].aligny = "bottom";
    	self.killstreakslots[index].horzalign = "fullscreen";
    	self.killstreakslots[index].vertalign = "fullscreen";
    	self.killstreakslots[index].alpha = 1;
   	 	self.killstreakslots[index].sort = 1;
    	self.killstreakslots[index].color = color;
   		self.killstreakslots[index].archived = true;
   		self.killstreakslots[index].foreground = true;
    	self.killstreakslots[index] setshader(icon, 40, 40);
    	self.killstreakslots[index].hidewheninmenu = true;
    	self.killstreakslots[index].hideWhenInKillcam = true;
    	self.killstreakslots[index] thread DestroyWhenEndGame();
	}
	wait 3;
	InfoMessage destroy();
	self.killstreakslots[index] scaleovertime( 1, 20, 20);
	self.killstreakslots[index] moveOverTime( 1 );
	self.killstreakslots[index].alignx = "left";
	self.killstreakslots[index].y = ypos;
	if(!isdefined(self.killstreakslots[index-1].x))
		self.killstreakslots[index].x = xpos;
	else
		self.killstreakslots[index].x = self.killstreakslots[index-1].x + 20;
	self.notification = undefined;
	self notify("NotificationGone");
}

WeaponHud() {
	self endon("disconnect");
    level endon("game_ended");	
	
	self.WeaponRank = newClientHudElem( self );
    self.WeaponRank.x = 625;
    self.WeaponRank.y = 469;
    self.WeaponRank.alignx = "right";
    self.WeaponRank.aligny = "bottom";
    self.WeaponRank.horzalign = "fullscreen";
    self.WeaponRank.vertalign = "fullscreen";
    self.WeaponRank.alpha = 0.8;
    self.WeaponRank.sort = 1;
    self.WeaponRank.color = (0,0,0);
    self.WeaponRank.archived = true;
    self.WeaponRank setshader("gradient_fadein", 100, 13);
    self.WeaponRank.hidewheninmenu = true;
    self.WeaponRank.hideWhenInKillcam = true;
    self.WeaponRank thread DestroyWhenEndGame();
    
    self.WeaponShader = newClientHudElem( self );
    self.WeaponShader.x = 565;
    self.WeaponShader.y = 440;
    self.WeaponShader.alignx = "right";
    self.WeaponShader.aligny = "middle";
    self.WeaponShader.horzalign = "fullscreen";
    self.WeaponShader.vertalign = "fullscreen";
    self.WeaponShader.alpha = 0.7;
    self.WeaponShader.sort = 1;
    self.WeaponShader.color = (1,1,1);
    self.WeaponShader.archived = false;
    self.WeaponShader setshader("", 53, 30);
    self.WeaponShader.hidewheninmenu = true;
    self.WeaponShader.hideWhenInKillcam = true;
    self.WeaponShader.hidewhendead = true;
    self.WeaponShader thread DestroyWhenEndGame();
    
    self.WeaponRankLine = newClientHudElem( self );
    self.WeaponRankLine.x = 625;
    self.WeaponRankLine.y = 453;
    self.WeaponRankLine.alignx = "right";
    self.WeaponRankLine.aligny = "bottom";
    self.WeaponRankLine.horzalign = "fullscreen";
    self.WeaponRankLine.vertalign = "fullscreen";
    self.WeaponRankLine.alpha = 1;
    self.WeaponRankLine.sort = 500;
    self.WeaponRankLine.color = (1,1,1);
    self.WeaponRankLine.archived = true;
    self.WeaponRankLine setshader("white", 110, 1);
    self.WeaponRankLine.hidewheninmenu = true;
    self.WeaponRankLine.hideWhenInKillcam = true;
    self.WeaponRankLine thread DestroyWhenEndGame();
    
    self.WeaponAmmo = newClientHudElem( self );
    self.WeaponAmmo.x = 625;
    self.WeaponAmmo.y = 449;
    self.WeaponAmmo.alignx = "right";
    self.WeaponAmmo.aligny = "bottom";
    self.WeaponAmmo.horzalign = "fullscreen";
    self.WeaponAmmo.vertalign = "fullscreen";
    self.WeaponAmmo.alpha = 1;
    self.WeaponAmmo.sort = 1;
    self.WeaponAmmo.color = (0,0,0);
    self.WeaponAmmo.archived = true;
    self.WeaponAmmo setshader("gradient_fadein", 50, 20);
    self.WeaponAmmo.hidewheninmenu = true;
    self.WeaponAmmo.hideWhenInKillcam = true;
    self.WeaponAmmo thread DestroyWhenEndGame();
    
    self.weaponName = newClientHudElem( self );
    self.weaponName.x = 622;
    self.weaponName.y = 469;
    self.weaponName.alignx = "right";
	self.weaponName.aligny = "bottom";
	self.weaponName.color = (1,1,1);
	self.weaponName.alpha = 1;
	self.weaponName.archived = true;
	self.weaponName.sort = 80;
    self.weaponName.foreground = true;
    self.weaponName.fontscale = 1.2;
	self.weaponName.horzalign = "fullscreen";
	self.weaponName.vertalign = "fullscreen";
	self.weaponName.hidewheninmenu = true;
	self.weaponName.hideWhenInKillcam = true;
	self.weaponName thread DestroyWhenEndGame();
	
	self.WeaponAmmoText = newClientHudElem( self );
    self.WeaponAmmoText.x = 593;
    self.WeaponAmmoText.y = 454;
    self.WeaponAmmoText.alignx = "right";
	self.WeaponAmmoText.aligny = "bottom";
	self.WeaponAmmoText.color = (1,1,1);
	self.WeaponAmmoText.alpha = 1;
	self.WeaponAmmoText.archived = true;
    self.WeaponAmmoText.foreground = true;
    self.WeaponAmmoText.fontscale = 2.6;
	self.WeaponAmmoText.horzalign = "fullscreen";
	self.WeaponAmmoText.vertalign = "fullscreen";
	self.WeaponAmmoText.hidewheninmenu = true;
	self.WeaponAmmoText.hideWhenInKillcam = true;
	self.WeaponAmmoText thread DestroyWhenEndGame();
	
	self.WeaponAmmoTextStock = newClientHudElem( self );
    self.WeaponAmmoTextStock.x = 622;
    self.WeaponAmmoTextStock.y = 449;
    self.WeaponAmmoTextStock.alignx = "right";
	self.WeaponAmmoTextStock.aligny = "bottom";
	self.WeaponAmmoTextStock.color = (1,1,1);
	self.WeaponAmmoTextStock.alpha = 1;
	self.WeaponAmmoTextStock.sort = 80;
	self.WeaponAmmoTextStock.archived = true;
    self.WeaponAmmoTextStock.foreground = true;
    self.WeaponAmmoTextStock.fontscale = 1.8;
	self.WeaponAmmoTextStock.horzalign = "fullscreen";
	self.WeaponAmmoTextStock.vertalign = "fullscreen";
	self.WeaponAmmoTextStock.hidewheninmenu = true;
	self.WeaponAmmoTextStock.hideWhenInKillcam = true;
	self.WeaponAmmoTextStock thread DestroyWhenEndGame();
	
	self.GrenadeHud = newClientHudElem( self );
    self.GrenadeHud.x = 493;
    self.GrenadeHud.y = 450;
    self.GrenadeHud.alignx = "right";
    self.GrenadeHud.aligny = "bottom";
    self.GrenadeHud.horzalign = "fullscreen";
    self.GrenadeHud.vertalign = "fullscreen";
    self.GrenadeHud.alpha = 0;
    self.GrenadeHud.sort = 10;
    self.GrenadeHud.color = (1,1,1);
    self.GrenadeHud.archived = true;
    self.GrenadeHud.foreground = true;
    self.GrenadeHud.hidewheninmenu = true;
    self.GrenadeHud.hideWhenInKillcam = true;
    self.GrenadeHud thread DestroyWhenEndGame();
    
    self.GrenadeLine = newClientHudElem( self );
    self.GrenadeLine.x = 495;
    self.GrenadeLine.y = 453;
    self.GrenadeLine.alignx = "right";
    self.GrenadeLine.aligny = "bottom";
    self.GrenadeLine.horzalign = "fullscreen";
    self.GrenadeLine.vertalign = "fullscreen";
    self.GrenadeLine.alpha = 1;
    self.GrenadeLine.sort = 100;
    self.GrenadeLine.color = (1,1,1);
    self.GrenadeLine.archived = false;
    self.GrenadeLine.foreground = true;
    self.GrenadeLine setshader("white", 20, 1);
    self.GrenadeLine.hidewheninmenu = true;
    self.GrenadeLine.hideWhenInKillcam = true;
    self.GrenadeLine thread DestroyWhenEndGame();
    
    self.GrenadeName = newClientHudElem( self );
    self.GrenadeName.x = 485;
    self.GrenadeName.y = 470;
    self.GrenadeName.alignx = "center";
	self.GrenadeName.aligny = "bottom";
	self.GrenadeName.alpha = 0;
	self.GrenadeName.archived = false;
	self.GrenadeName.sort = 80;
    self.GrenadeName.foreground = true;
    self.GrenadeName.fontscale = 1;
    self.GrenadeName settext("^:[{+frag}]");
	self.GrenadeName.horzalign = "fullscreen";
	self.GrenadeName.vertalign = "fullscreen";
	self.GrenadeName.hidewheninmenu = true;
	self.GrenadeName.hideWhenInKillcam = true;
	self.GrenadeName thread DestroyWhenEndGame();
	
	self.EmpHud = newClientHudElem( self );
    self.EmpHud.x = 463;
    self.EmpHud.y = 450;
    self.EmpHud.alignx = "right";
    self.EmpHud.aligny = "bottom";
    self.EmpHud.horzalign = "fullscreen";
    self.EmpHud.vertalign = "fullscreen";
    self.EmpHud.alpha = 0;
    self.EmpHud.sort = 10;
    self.EmpHud.color = (1,1,1);
    self.EmpHud.archived = false;
    self.EmpHud.foreground = true;
    self.EmpHud.hidewheninmenu = true;
    self.EmpHud.hideWhenInKillcam = true;
    self.EmpHud thread DestroyWhenEndGame();
    
    self.EmpHudLine = newClientHudElem( self );
    self.EmpHudLine.x = 465;
    self.EmpHudLine.y = 453;
    self.EmpHudLine.alignx = "right";
    self.EmpHudLine.aligny = "bottom";
    self.EmpHudLine.horzalign = "fullscreen";
    self.EmpHudLine.vertalign = "fullscreen";
    self.EmpHudLine.alpha = 1;
    self.EmpHudLine.sort = 100;
    self.EmpHudLine.color = (1,1,1);
    self.EmpHudLine.archived = false;
    self.EmpHudLine.foreground = true;
    self.EmpHudLine setshader("white", 20, 1);
    self.EmpHudLine.hidewheninmenu = true;
    self.EmpHudLine.hideWhenInKillcam = true;
    self.EmpHudLine thread DestroyWhenEndGame();
    
    self.EmpHudText = newClientHudElem( self );
    self.EmpHudText.x = 455;
    self.EmpHudText.y = 470;
    self.EmpHudText.alignx = "center";
	self.EmpHudText.aligny = "bottom";
	self.EmpHudText.alpha = 0;
	self.EmpHudText.archived = false;
	self.EmpHudText.sort = 80;
    self.EmpHudText.foreground = true;
    self.EmpHudText.fontscale = 1;
	self.EmpHudText.horzalign = "fullscreen";
	self.EmpHudText.vertalign = "fullscreen";
	self.EmpHudText settext("^:[{+actionslot 1}]");
	self.EmpHudText.hidewheninmenu = true;
	self.EmpHudText.hideWhenInKillcam = true;
	self.EmpHudText thread DestroyWhenEndGame();
	
	self.CommandsInfo = newClientHudElem( self );
    self.CommandsInfo.x = 85;
    self.CommandsInfo.y = 7;
    self.CommandsInfo.alignx = "left";
	self.CommandsInfo.aligny = "top";
	self.CommandsInfo.alpha = 1;
	self.CommandsInfo.archived = true;
	self.CommandsInfo.sort = 80;
    self.CommandsInfo.foreground = true;
    self.CommandsInfo.fontscale = 1;
	self.CommandsInfo.horzalign = "fullscreen";
	self.CommandsInfo.vertalign = "fullscreen";
	self.CommandsInfo settext("Press ^:[{+actionslot 2}] ^7For ^:High FPS\n^7Press ^:[{+actionslot 4}] ^7For ^:Suicide\n^7Press ^:[{+actionslot 3}] ^7For ^:Fullbright/No FX");
	self.CommandsInfo.hidewheninmenu = true;
	self.CommandsInfo.hideWhenInKillcam = true;
	self.CommandsInfo thread DestroyWhenEndGame();
	weapon = "";
	while(1) {
		weapon = self getcurrentweapon();
		if(weapon == "" || weapon == "none") {
			if(self.WeaponAmmoText.alpha == 1) {
				self.WeaponAmmoText.alpha = 0;
				self.weaponName.alpha = 0;
				self.WeaponAmmoTextStock.alpha = 0;
			}
		}
		else{
			if(self.WeaponAmmoText.alpha == 0) {
				self.WeaponAmmoText.alpha = 1;
				self.weaponName.alpha = 1;
				self.WeaponAmmoTextStock.alpha = 1;
			}
			baseWeaponName = GetRefFromItemIndex( GetBaseWeaponItemIndex( weapon ) );
			self set_weapon_info(baseWeaponName);
		}
		self waittill_any("weapon_change", "NewGunRotation");
	}
}

doSplash() {
    self endon("disconnect");
    wait 6;
    notifyData = spawnstruct();
    notifyData.titleText = "^:Gillette Infected";
    notifyData.notifyText = "Welcome " + self.name + "!";
    notifyData.glowColor = (.75, 0, 0);
    notifyData.duration = 5;
    self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
    wait 1;
}

playerkilledinf( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, lifeId ) {
	if(!isdefined(level.infect_choseFirstInfected) && isdefined(level.gamebegin)) {
		if(isdefined(attacker.focus)) {
			attacker.Focus += 1;
			attacker notify("PlayerKilledSomeone");
		}
		
		if(isdefined(attacker) && attacker == self) {
			if(self.sessionteam == "allies") {
				level.firstkillfallen = 1;
				if(isdefined(level.initialinfected)) {
					level.initialinfected = undefined;
					level.firstinfectedplayer thread giveCustomLoadout();
					level.firstinfectedplayer = undefined;
				}
				self.pers["team"] = "axis";
				self.team = "axis";
				//self thread MartydomWatcher();
				self.sessionteam = self.pers[ "team"];
				playSoundOnPlayers( "mpl_hq_cap_us");
				self iprintlnbold("^:INFECTED");
				level thread maps\mp\_popups::DisplayTeamMessageToAll("^:Got Infected", self);
			}
			if(level maps\mp\gametypes\_teams::CountPlayers()["allies"] == 1 && level maps\mp\gametypes\_teams::CountPlayers()["axis"] != 1) {
				for(i = 0;i < level.players.size;i++) {
					if(level.players[i].team == "allies") {
						level.players[i] maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( "last_alive" );
					}
				}
			}
		}
		
		if(isdefined(attacker) && attacker.sessionteam == "axis" ) {
			attacker notify("infectedplayerkilled");
			if(self.sessionteam == "allies") {
				level.firstkillfallen = 1;
				if(isdefined(level.initialinfected)) {
					level.initialinfected = undefined;
					level.firstinfectedplayer thread giveCustomLoadout();
					level.firstinfectedplayer = undefined;
				}
				self.pers["team"] = "axis";
				self.team = "axis";
				self thread MartydomWatcher();
				self.sessionteam = self.pers[ "team"];
				playSoundOnPlayers( "mpl_hq_cap_us");
				self iprintlnbold("^:INFECTED");
				level thread maps\mp\_popups::DisplayTeamMessageToAll("^:Got Infected", self);
			}
			if(level maps\mp\gametypes\_teams::CountPlayers()["allies"] == 1 && level maps\mp\gametypes\_teams::CountPlayers()["axis"] != 1) {
				for(i = 0;i < level.players.size;i++) {
					if(level.players[i].team == "allies") {
						level.players[i] maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( "last_alive" );
					}
				}
			}
		}
		else if(isdefined(attacker) && attacker.sessionteam == "allies")
			self notify("diedbyplayer");
		
		if(level maps\mp\gametypes\_teams::CountPlayers()["allies"] == 0 && level maps\mp\gametypes\_teams::CountPlayers()["axis"] != 1)
			thread maps\mp\gametypes\_globallogic::endGame("axis", "");
	}
}

MartydomWatcher() {
	self endon("disconnect");
	level endon("game_ended");
	self.martydomcounter = 0;
	while(1) {
		ntf = self waittill_any_return("infectedplayerkilled", "diedbyplayer");
		if(ntf == "diedbyplayer")
			self.martydomcounter += 1;
		else
			self.martydomcounter = 0;
	}
}

set_weapon_info(weapon) {
	weaponwidth = 0;
	weaponheight = 0;
	weaponshader = "";
	weaponname = "";
	switch( weapon ) {
		// Pistolen
		case "cz75":
			weaponshader = "hud_icon_cz75";
			weaponheight = 30;
			weaponwidth = 25;
			weaponname = "CZ75";
			break;
		case "python":
			weaponshader = "hud_python";
			weaponheight = 53;
			weaponwidth = 25;
			weaponname = "Python";
			break;
		case "m1911":
			weaponshader = "hud_icon_colt";
			weaponheight = 30;
			weaponwidth = 25;
			weaponname = "M1911";
			break;
		case "asp":
			weaponshader = "hud_asp";
			weaponheight = 30;
			weaponwidth = 25;
			weaponname = "ASP";
			break;
		case "makarov":
			weaponshader = "hud_icon_makarov";
			weaponheight = 30;
			weaponwidth = 25;
			weaponname = "Makarov";
			break;
		// Sniper
		case "dragunov":
			weaponshader = "hud_icon_dragunov";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "Dragunov";
			break;
		case "l96a1":
			weaponshader = "hud_l96";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "L96A1";
			break;
		case "psg1":
			weaponshader = "hud_psg1";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "PSG1";
			break;
		case "wa2000":
			weaponshader = "hud_icon_waw2000";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "WA2000";
			break;
		// Sturmgewehre
		case "m16":
			weaponshader = "hud_icon_m16a4";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "M16";
			break;
		case "enfield":
			weaponshader = "hud_enfield";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "Enfield";
			break;
		case "m14":
			weaponshader = "hud_icon_m14";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "M14";
			break;
		case "famas":
			weaponshader = "hud_icon_famas";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "Famas";
			break;
		case "galil":
			weaponshader = "hud_icon_galil";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "Galil";
			break;
		case "fnfal":
			weaponshader = "hud_icon_fnfal";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "FN FAL";
			break;
		case "ak47":
			weaponshader = "hud_icon_ak47";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "AK-47";
			break;
		case "commando":
			weaponshader = "hud_commando";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "Commando";
			break;
		case "aug":
			weaponshader = "hud_icon_aug";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "AUG";
			break;
		case "g11":
			weaponshader = "hud_icon_g11";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "G11";
			break;
		// MPs
		case "mp5k":
			weaponshader = "hud_icon_mp5";
			weaponheight = 30;
			weaponwidth = 25;
			weaponname = "MP5K";
			break;
		case "skorpion":
			weaponshader = "hud_icon_skorpion";
			weaponheight = 30;
			weaponwidth = 25;
			weaponname = "Skorpion";
			break;
		case "mac11":
			weaponshader = "hud_icon_mac11";
			weaponheight = 30;
			weaponwidth = 25;
			weaponname = "MAC11";
			break;
		case "uzi":
			weaponshader = "hud_icon_uzi";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "Uzi";
			break;
		case "ak74u":
			weaponshader = "hud_icon_ak74u";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "AK74u";
			break;
		case "pm63":
			weaponshader = "hud_icon_pm63";
			weaponheight = 25;
			weaponwidth = 53;
			weaponname = "PM63";
			break;
		case "mpl":
			weaponshader = "hud_icon_mpl";
			weaponheight = 25;
			weaponwidth = 53;
			weaponname = "MPL";
			break;
		case "spectre":
			weaponshader = "hud_icon_spectre";
			weaponheight = 25;
			weaponwidth = 53;
			weaponname = "Spectre";
			break;
		case "kiparis":
			weaponshader = "hud_icon_kiparis";
			weaponheight = 25;
			weaponwidth = 53;
			weaponname = "Kiparis";
			break;
		// Shotguns
		case "rottweil72":
			weaponshader = "hud_beretta";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "Olympia";
			break;
		case "ithaca":
			weaponshader = "hud_ithaca";
			weaponheight = 25;
			weaponwidth = 53;
			weaponname = "Stakeout";
			break;
		case "spas":
			weaponshader = "hud_icon_spas12";
			weaponheight = 25;
			weaponwidth = 53;
			weaponname = "Spas-12";
			break;
		case "hs10":
			weaponshader = "hud_hs10";
			weaponheight = 25;
			weaponwidth = 53;
			weaponname = "HS10";
			break;
		// LMG
		case "hk21":
			weaponshader = "hud_hk21";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "HK21";
			break;
		case "rpk":
			weaponshader = "hud_rpk";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "RPK";
			break;
		case "m60":
			weaponshader = "hud_icon_m60e4";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "M60";
			break;
		case "stoner63":
			weaponshader = "hud_icon_stoner63a";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "Stoner63";
			break;
		// Launcher
		case "m72_law":
			weaponshader = "hud_icon_m72law";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "M72 LAW";
			break;
		case "rpg":
			weaponshader = "hud_icon_rpg";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "RPG";
			break;
		case "strela":
			weaponshader = "hud_strela";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "Strela-3";
			break;
		case "china_lake":
			weaponshader = "hud_china_lake";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "China Lake";
			break;
		// Special
		case "crossbow_explosive":
			weaponshader = "hud_icon_crossbow";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "Crossbow";
			break;
		case "knife_ballistic":
			weaponshader = "hud_ballistic_knife";
			weaponheight = 30;
			weaponwidth = 53;
			weaponname = "Ballistic Knife";
			break;
	}
	wait 0.05;
	self.WeaponShader setshader(weaponshader, weaponwidth, weaponheight);
	self.weaponName setText(weaponname);
}

blank() {
	
}

updateRankScoreHUD_N( amount ) {
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );

	if ( amount == 0 )
		return;

	self notify( "update_score" );
	self endon( "update_score" );

	self.rankUpdateTotal += amount;

	wait ( 0.05 );

	if( isDefined( self.hud_rankscroreupdate ) ) {			
		if ( self.rankUpdateTotal < 0 ) {
			self.hud_rankscroreupdate.label = &"";
			self.hud_rankscroreupdate.color = (1,0,0);
		}
		else {
			self.hud_rankscroreupdate.label = &"MP_PLUS";
			self.hud_rankscroreupdate.color = (1,0,0);
		}

		self.hud_rankscroreupdate setValue(self.rankUpdateTotal);

		self.hud_rankscroreupdate.alpha = 0.85;
		self.hud_rankscroreupdate thread maps\mp\gametypes\_hud::fontPulse( self );

		wait 1;
		self.hud_rankscroreupdate fadeOverTime( 0.75 );
		self.hud_rankscroreupdate.alpha = 0;
		
		self.rankUpdateTotal = 0;
	}
}



