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
#include maps/mp/zombies/_zm_weap_riotshield;

main() {
	replaceFunc(maps\mp\zombies\_zm_utility::wait_network_frame, ::wait_network_frame_override);
}

init() {
	precacheshader("zombies_rank_1");
	precacheshader("zombies_rank_2");
	precacheshader("zombies_rank_3");
	precacheshader("zombies_rank_3_ded");
	precacheshader("zombies_rank_4");
	precacheshader("zombies_rank_4_ded");
	precacheshader("zombies_rank_5");
	precacheshader("zombies_rank_5_ded");
	precacheshader("specialty_doublepoints_zombies");
	precacheshader("menu_mp_lobby_frame_circle");
	precacheshader("damage_feedback");
	precacheshader("specialty_quickrevive");
	precacheshader("scorebar_zom_1");
	precacheshader("frame_alpha_debug");
	precacheshader("menu_mp_lobby_classified");
	precacheshader("line_horizontal");
	precacheshader("ui_scrollbar");
	precacheshader("gradient_fadein");
	
	setDvar("aim_automelee_enabled", 0);
	setDvar("player_strafeSpeedScale", 1);
	setDvar("player_sprintStrafeSpeedScale", 1);
	setDvar("player_backSpeedScale", 1);
	setDvar("jump_slowdownEnable", 0);
	setDvar("perk_weapRateEnhanced", 0);
	setDvar( "player_backSpeedScale", 1 );
	setDvar( "dtp_post_move_pause", 0 );
	setDvar( "dtp_startup_delay", 100 );
	setDvar( "dtp_exhaustion_window", 100 );
	setDvar( "player_meleeRange", 64 );
	setDvar( "player_breath_gasp_lerp", 0 );
	setDvar( "g_friendlyfireDist", 0 );
	setDvar( "perk_weapRateEnhanced", 0 );
	setDvar( "sv_patch_zm_weapons", 0 );
	setDvar( "sv_fix_zm_weapons", 1 );
	setDvar( "sv_voice", 2 );
	setDvar( "sv_voiceQuality", 9 );
	
	Discordlink = newhudelem();
    Discordlink.x = 320;
    Discordlink.y = 0;
    Discordlink.alignx = "center";
    Discordlink.horzalign = "fullscreen";
    Discordlink.vertalign = "fullscreen";
    Discordlink.alpha = 0.4;
    Discordlink.sort = 1;
    Discordlink.color = (1,1,1);
    Discordlink.archived = false;
    Discordlink.fontscale = 1;
    Discordlink.font = "objective";
	Discordlink.hidewheninmenu = true;
	Discordlink.hidewheninkillcam = true;
	Discordlink settext("www.Gillette^8Clan^7.com");
	
	precachestatusicon("waypoint_revive");
	precachestatusicon("hud_status_dead");
	
	level.round_think_func = ::round_think;
	level.perk_purchase_limit = 30;
	level.ui_better_grey = (0.8, 0.8, 0.8);
	level.ui_better_white = (0.8, 0.8, 0.8);
	level.ui_better_red = (0.5, 0, 0);
	
	level thread ZombieCounter();
    level thread on_connect();
}

wait_network_frame_override() {
    wait 0.1;
}

Statusiconwatcher() {
	self endon("disconnect");
	level endon("end_game");
	
	while(1) {
		if(self.sessionstate == "spectator" && self.statusicon != "hud_status_dead") 
			self.statusicon = "hud_status_dead";
		else if(isdefined(self.revivetrigger) && self.statusicon != "waypoint_revive")
			self.statusicon = "waypoint_revive";
		else if(!isdefined(self.revivetrigger) && self.sessionstate == "playing" && self.statusicon != "")
			self.statusicon = "";
		
		wait .2;
	}
}

on_connect() {
    for(;;) {
        level waittill("connected", player);
        player thread on_spawned();
        player thread on_disconnect();
        player setclientdvar("r_lodBiasRigid", -1000); //fov fix
        player.realname = player.name;
    }
}

on_spawned() {
    self endon("disconnect");
	level endon("game_ended");
	
	self.initial_spawn_main = 0;
	
    for(;;) {
        self waittill("spawned_player");
		if(self.initial_spawn_main == 0) {
			self.initial_spawn_main = 1;
			
			self setclientdvar("g_teamcolor_allies", "0.6 0 0 1");
        	self setclientdvar("g_teamcolor_axis", "0.6 0 0 1");
        	self setClientDvar( "player_lastStandBleedoutTime", 45);
			self setClientDvar( "dtp_post_move_pause", getDvarInt( "dtp_post_move_pause" ) );
			self setClientDvar( "dtp_startup_delay", getDvarInt( "dtp_startup_delay" ) );
			self setClientDvar( "dtp_exhaustion_window", getDvarInt( "dtp_exhaustion_window" ) );
			self setClientDvar( "aim_automelee_enabled", 0 );
			self setClientDvar( "cg_drawBreathHint", 0 );
			self setClientDvar( "cg_friendlyNameFadeIn", 0 );
			self setClientDvar( "cg_friendlyNameFadeOut", 250 );
			self setClientDvar( "cg_enemyNameFadeIn", 0 );
			self setClientDvar( "cg_enemyNameFadeOut", 250 );
			self setClientDvar( "waypointOffscreenPointerDistance", 30);
			self setClientDvar( "waypointOffscreenPadTop", 32);
			self setClientDvar( "waypointOffscreenPadBottom", 32);
			self setClientDvar( "waypointPlayerOffsetStand", 30);
			self setClientDvar( "waypointPlayerOffsetCrouch", 30);
			
			self Buildroundnumber(); 
			self thread CustomRoundNumber();
			self thread set_hitmarker();
			self thread create_shield_bar();
			self thread create_health_bar();
			self thread bleedout_bar_hud();
			self thread Statusiconwatcher();
			self thread bo4_max_ammo();
			self thread bo4_carpenter();
		}
		
		self setClientDvar("cg_usecolorcontrol", 1);
		self setclientdvar("cg_colortemp", 25000);
		
		if(level.round_number > 5)
			self thread SpawnProtection();
    }
    
    
    
}

trigger_watcher() {
	self endon("disconnect");
	
	while(1) {
		if(isalive(self)) {
			if(isdefined(level.total_triggers)) {
				for(i = 0;i < level.total_triggers.size;i++) {
					if(isdefined(level.total_triggers[i])) {
						if(self istouching(level.total_triggers[i]) && self.touching_trigger != level.total_triggers[i]) {
							self setlowermessage("msg", level.total_triggers[i].text);
							self.touching_trigger = level.total_triggers[i];
							self.lowermessage.hidewheninkillcam = false;
							self.lowermessage.archived = 1;
							self thread deleteLowerMsg(level.total_triggers[i], "msg");
						}
					}
				}
			}
		}

		wait .1;
	}
}

on_disconnect() {
	self waittill("disconnect");
	
	if(level.players.size == 0 && (int(GetTime() / 1000) >= 10800))
    	executeCommand("quit");
}

bo4_carpenter() {
	level endon("end_game");
	self endon("disconnect");
	for(;;) {
		level waittill( "carpenter_finished" );
		self.shielddamagetaken = 0;
	}
}

bo4_max_ammo() {
	level endon("end_game");
	self endon("disconnect");
	for(;;)  {
		self waittill("zmb_max_ammo");
		weaps = self getweaponslist(1);
		foreach (weap in weaps) 
			self setweaponammoclip(weap, weaponclipsize(weap));
	}
}

bleedout_bar_hud() {
	self endon("disconnect");

	bleedout_bar = self createbar((0.31, 0, 0), level.secondaryprogressbarwidth * 2, 4);
	bleedout_bar setpoint("CENTER", undefined, level.secondaryprogressbarx, -1 * level.secondaryprogressbary);
	bleedout_bar.hidewheninmenu = 1;
	bleedout_bar.bar.hidewheninmenu = 1;
	bleedout_bar.barframe.hidewheninmenu = 1;
	bleedout_bar hideelem();
	bleedout_bar thread destroy_on_notify( "end_game" );
	bleedout_bar.bar thread destroy_on_notify( "end_game" );
	bleedout_bar.barframe thread destroy_on_notify( "end_game" );

	while (1) {
		self waittill("entering_last_stand");

		if(!self maps/mp/zombies/_zm_laststand::player_is_in_laststand())
			continue;

		self thread bleedout_bar_hud_updatebar(bleedout_bar);

		bleedout_bar showelem();

		self waittill_any("player_revived", "bled_out", "player_suicide");
			
		bleedout_bar hideelem();
		
		if(self.sessionstate != "spectator") {
			self.ignoreme = 1;
			self.health = 150;
			self.maxhealth = self.health;
			wait 3;
			self.ignoreme = 0;
		}
	}
}

bleedout_bar_hud_updatebar(bleedout_bar) {
	self endon("player_revived");
	self endon("bled_out");
	self endon("player_suicide");

	bleedout_time = 30;
	interval_time = 30;
	interval_frac = interval_time / bleedout_time;
	num_intervals = int(bleedout_time / interval_time) + 1;

	bleedout_bar updatebar(1);

	for(i = 0; i < num_intervals; i++) {
		time = bleedout_time;
		if(time > interval_time)
			time = interval_time;

		frac = 0.99 - ((i + 1) * interval_frac);

		barwidth = int((bleedout_bar.width * frac) - 10);
		if(barwidth < 1)
			barwidth = 1;

		bleedout_bar.bar scaleovertime(time, barwidth, bleedout_bar.height);

		wait time;

		bleedout_time -= time;
	}
}

ZombieCounter() {
	level endon("end_game");
	flag_wait("initial_blackscreen_passed");
	level.ZombieCounterBG = newhudelem();
	level.ZombieCounterBG.alignx = "right";
    level.ZombieCounterBG.aligny = "top";
    level.ZombieCounterBG.horzalign = "fullscreen";
    level.ZombieCounterBG.vertalign = "fullscreen";
    level.ZombieCounterBG.x = 635;
    level.ZombieCounterBG.y = 55;
    level.ZombieCounterBG.alpha = 1;
    level.ZombieCounterBG.color = (0.21,0,0);
    level.ZombieCounterBG SetShader("scorebar_zom_1", 100, 23);
    level.ZombieCounterBG thread destroy_on_notify( "end_game" );
    level.ZombieCounterBG.hidewheninmenu = 1;
    
    level.ZombieCounterValue = newhudelem();
	level.ZombieCounterValue.alignx = "right";
    level.ZombieCounterValue.aligny = "center";
    level.ZombieCounterValue.horzalign = "fullscreen";
    level.ZombieCounterValue.vertalign = "fullscreen";
    level.ZombieCounterValue.fontscale = 1.3;
    level.ZombieCounterValue.alpha = 1;
    level.ZombieCounterValue.x = 620;
    level.ZombieCounterValue.y = 55;
    level.ZombieCounterValue.foreground = 1;
    level.ZombieCounterValue.color = (1,1,1);
    level.ZombieCounterValue.label = &"Zombies Remaining ^1";
    level.ZombieCounterValue thread destroy_on_notify( "end_game" );
    level.ZombieCounterValue.hidewheninmenu = 1;
    
    if(level.script == "zm_buried")
    	plus = 40;
    else if(level.script == "zm_tomb")
    	plus = 15;
    else if(level.script == "zm_prison")
    	plus = 35;
    else
    	plus = 0;
    	
    textset = "zombies";
    
    while(1) {
    	if(level.players.size == 1) {
    		if(level.ZombieCounterBG.y != 350 - plus) {
    			level.ZombieCounterBG.y = 350 - plus;
    			level.ZombieCounterValue.y = 355 - plus;
    		}
    	}
    	else if(level.players.size == 2) {
    		if(level.ZombieCounterBG.y != 330 - plus) {
    			level.ZombieCounterBG.y = 330 - plus;
    			level.ZombieCounterValue.y = 335 - plus;
    		}
    	}
    	else if(level.players.size == 3) {
    		if(level.ZombieCounterBG.y != 310 - plus) {
    			level.ZombieCounterBG.y = 310 - plus;
    			level.ZombieCounterValue.y = 315 - plus;
    		}
    	}
    	else if(level.players.size == 4) {
    		if(level.ZombieCounterBG.y != 290 - plus) {
    			level.ZombieCounterBG.y = 290 - plus;
    			level.ZombieCounterValue.y = 295 - plus;
    		}
    	}
    	else if(level.players.size == 5) {
    		if(level.ZombieCounterBG.y != 270 - plus) {
    			level.ZombieCounterBG.y = 270 - plus;
    			level.ZombieCounterValue.y = 275 - plus;
    		}
    	}
    	else if(level.players.size == 6) {
    		if(level.ZombieCounterBG.y != 250 - plus) {
    			level.ZombieCounterBG.y = 250 - plus;
    			level.ZombieCounterValue.y = 255 - plus;
    		}
    	}
    	else if(level.players.size == 7) {
    		if(level.ZombieCounterBG.y != 230 - plus) {
    			level.ZombieCounterBG.y = 230 - plus;
    			level.ZombieCounterValue.y = 235 - plus;
    		}
    	}
    	else if(level.players.size == 8) {
    		if(level.ZombieCounterBG.y != 210 - plus) {
    			level.ZombieCounterBG.y = 210 - plus;
    			level.ZombieCounterValue.y = 215 - plus;
    		}
    	}
    	
    	value = get_round_enemy_array().size + level.zombie_total;
    	
    	if(value == 0) {
    		if(level.ZombieCounterBG.alpha != 0) {
    			level.ZombieCounterBG fadeovertime(0.5);
    			level.ZombieCounterBG.alpha = 0;
    			level.ZombieCounterValue fadeovertime(0.5);
    			level.ZombieCounterValue.alpha = 0;
    		}
    	}
    	else {
    		if(level.ZombieCounterBG.alpha != 1) {
    			level.ZombieCounterBG fadeovertime(0.5);
    			level.ZombieCounterBG.alpha = 1;
    			level.ZombieCounterValue fadeovertime(0.5);
    			level.ZombieCounterValue.alpha = 1;
    		}
    	}
    	
    	level.ZombieCounterValue setvalue(value);
    	
    	if(isdefined(level.dog_rounds) && level.dog_rounds == level.round_number) {
    		if(isdefined(textset) && textset != "Dogs") {
    			level.ZombieCounterValue.label = &"Dogs Remaining ^1";
    			textset = "dogs";
    		}
    	}
    	else {
    		if(isdefined(textset) && textset != "zombies") {
    			level.ZombieCounterValue.label = &"Zombies Remaining ^1";
    			textset = "zombies";
    		}
    	}
    	wait .3;
    }
}

ShieldHud() {    
	level endon( "end_game" );
	self endon("disconnect");
    self.int_shield = self hasweapon(level.riotshield_name);   
    self.shield_hud = false;

	while (1) {
		if(self.sessionstate != "spectator" && !self maps/mp/zombies/_zm_laststand::player_is_in_laststand()) {
			if (self.int_shield || self hasweapon("riotshield_zm")) 
				self.int_shield = true;
			else 
				self.int_shield = false;
		
			if (self.int_shield && (self.shielddamagetaken < 2300)) {
				if (!self.shield_hud) {
            		x = 20;
            		y = 439;
            		base_width = 65;
            		base_height = 1;
                
            		self.shield_bar = newClientHudElem( self );
            		self.shield_bar.x = x + 1;
            		self.shield_bar.y = y;
            		self.shield_bar.alignx = "left";
            		self.shield_bar.aligny = "bottom";
            		self.shield_bar.horzalign = "fullscreen";
            		self.shield_bar.vertalign = "fullscreen";
            		self.shield_bar.color = ( 0.1, 0.7, 1 );
            		self.shield_bar.alpha = 1;
            		self.shield_bar.archived = true;
            		self.shield_bar.foreground = true;
            		self.shield_bar.sort = 100;
           	 		self.shield_bar.hidewheninmenu = true;
            		self.shield_bar.hidewhendead = true;
            		self.shield_bar thread destroy_on_notify( "end_game" );
                
               		self.shield_bar_frame = newClientHudElem( self );
               		self.shield_bar_frame.x = x;
                	self.shield_bar_frame.y = y + 1;
                	self.shield_bar_frame.alignx = "left";
                	self.shield_bar_frame.aligny = "bottom";
                	self.shield_bar_frame.horzalign = "fullscreen";
                	self.shield_bar_frame.vertalign = "fullscreen";
                	self.shield_bar_frame.alpha = .75;
                	self.shield_bar_frame.sort = -1;
                	self.shield_bar_frame.color = (0,0,0);
                	self.shield_bar_frame.archived = true;
               		self.shield_bar_frame.foreground = true;
              	    self.shield_bar_frame.hidewheninmenu = true;
              	    self.shield_bar_frame.hidewhendead = true;
              	    self.shield_bar_frame setshader("gradient_fadein", base_width + 2, base_height + 2);
             	    self.shield_bar_frame thread destroy_on_notify( "end_game" );

             	    self.shield_hud = true;
				}
			
				shield_hp = ((2300 - self.shielddamagetaken) / 2300);
				new_width = int(base_width * shield_hp);
			
				self.shield_bar setshader("progress_bar_fill", new_width, base_height);
			}
		
			else {
    			self.int_shield = false;
    			self.shield_hud = false;
    
    			if(isdefined(self.shield_bar))
					self.shield_bar destroy();
				if(isdefined(self.shield_bar_frame))
					self.shield_bar_frame destroy();
			}
		}	
		else {
			self.int_shield = false;
    		self.shield_hud = false;
    		
    		if(isdefined(self.shield_bar))
				self.shield_bar destroy();
			if(isdefined(self.shield_bar_frame))
				self.shield_bar_frame destroy();
		}
		wait .05;
	}
}

create_health_bar() {
    level endon("end_game");
    self endon("disconnect");
    
    flag_wait("initial_blackscreen_passed");
	
	color 		= (1, 1, 1);
    x 			= 20;
    y 			= 443;
    base_width 	= 80;
    base_height = 3;
    
    if(!isdefined(self.ui_healthbar))
    	self.ui_healthbar = [];

    self.ui_healthbar["healthbar"] = newClientHudElem(self);
    self.ui_healthbar["healthbar"].x = x;
    self.ui_healthbar["healthbar"].y = y;
    self.ui_healthbar["healthbar"].alignx = "left";
    self.ui_healthbar["healthbar"].aligny = "middle";
    self.ui_healthbar["healthbar"].horzalign = "fullscreen";
    self.ui_healthbar["healthbar"].vertalign = "fullscreen";
    self.ui_healthbar["healthbar"].alpha = 1;
    self.ui_healthbar["healthbar"].basealpha = 1;
    self.ui_healthbar["healthbar"].sort = 1;
    self.ui_healthbar["healthbar"].archived = true;
    self.ui_healthbar["healthbar"].foreground = true;
    self.ui_healthbar["healthbar"].hidewheninmenu = true;
    self.ui_healthbar["healthbar"] setshader("white", base_width, base_height);
    self.ui_healthbar["healthbar"] thread destroy_on_notify( "end_game" );
    
    self.ui_healthbar["frame"] = newClientHudElem(self);
    self.ui_healthbar["frame"].x = x;
    self.ui_healthbar["frame"].y = y;
    self.ui_healthbar["frame"].alignx = "left";
    self.ui_healthbar["frame"].aligny = "middle";
    self.ui_healthbar["frame"].horzalign = "fullscreen";
    self.ui_healthbar["frame"].vertalign = "fullscreen";
    self.ui_healthbar["frame"].alpha = .75;
    self.ui_healthbar["frame"].basealpha = .75;
    self.ui_healthbar["frame"].sort = -1;
    self.ui_healthbar["frame"].color = (.3, .3, .3);
    self.ui_healthbar["frame"].archived = true;
    self.ui_healthbar["frame"].foreground = true;
    self.ui_healthbar["frame"].hidewheninmenu = true;
    self.ui_healthbar["frame"].hidewhendead = true;
    self.ui_healthbar["frame"] setshader("white", base_width, base_height);
    self.ui_healthbar["frame"] thread destroy_on_notify( "end_game" );
    
    self.ui_healthbar["max_value"] = self createFontString("default", 1);
    self.ui_healthbar["max_value"].x = x + base_width;
    self.ui_healthbar["max_value"].y = y - 10;
    self.ui_healthbar["max_value"].alignx = "right";
    self.ui_healthbar["max_value"].aligny = "middle";
    self.ui_healthbar["max_value"].horzalign = "fullscreen";
    self.ui_healthbar["max_value"].vertalign = "fullscreen";
    self.ui_healthbar["max_value"].alpha = .75;
    self.ui_healthbar["max_value"].basealpha = .75;
    self.ui_healthbar["max_value"].archived = true;
    self.ui_healthbar["max_value"].color = (.7, .7, .7);
    self.ui_healthbar["max_value"].foreground = true;
    self.ui_healthbar["max_value"].hidewheninmenu = true;
    self.ui_healthbar["max_value"].label = &" / ";
    self.ui_healthbar["max_value"] thread destroy_on_notify( "end_game" );
    
    self.ui_healthbar["health"] = self createFontString("default", 1);
    self.ui_healthbar["health"].x = self.ui_healthbar["max_value"].x - 15;
    self.ui_healthbar["health"].y = y - 10;
    self.ui_healthbar["health"].alignx = "right";
    self.ui_healthbar["health"].aligny = "middle";
    self.ui_healthbar["health"].horzalign = "fullscreen";
    self.ui_healthbar["health"].vertalign = "fullscreen";
    self.ui_healthbar["health"].alpha = 1;
    self.ui_healthbar["health"].basealpha = 1;
    self.ui_healthbar["health"].archived = true;
    self.ui_healthbar["health"].foreground = true;
    self.ui_healthbar["health"].hidewheninmenu = true;
    self.ui_healthbar["health"] thread destroy_on_notify( "end_game" );
    
    self.ui_healthbar["health_icon"] = self createFontString("objective", 2);
    self.ui_healthbar["health_icon"].x = x;
    self.ui_healthbar["health_icon"].y = y - 12;
    self.ui_healthbar["health_icon"].alignx = "left";
    self.ui_healthbar["health_icon"].aligny = "middle";
    self.ui_healthbar["health_icon"].horzalign = "fullscreen";
    self.ui_healthbar["health_icon"].vertalign = "fullscreen";
    self.ui_healthbar["health_icon"].alpha = 1;
    self.ui_healthbar["health_icon"].basealpha = 1;
    self.ui_healthbar["health_icon"].archived = true;
    self.ui_healthbar["health_icon"].color = (1, 1, 1);
    self.ui_healthbar["health_icon"].foreground = true;
    self.ui_healthbar["health_icon"].hidewheninmenu = true;
    self.ui_healthbar["health_icon"] settext("+");
    self.ui_healthbar["health_icon"] thread destroy_on_notify( "end_game" );
    
    self.ui_healthbar["name"] = self createFontString("objective", 1.05);
    self.ui_healthbar["name"].x = 22;
    self.ui_healthbar["name"].y = 460;
    self.ui_healthbar["name"].alignx = "left";
    self.ui_healthbar["name"].aligny = "bottom";
    self.ui_healthbar["name"].horzalign = "fullscreen";
    self.ui_healthbar["name"].vertalign = "fullscreen";
    self.ui_healthbar["name"].alpha = 1;
    self.ui_healthbar["name"].color = (1, 1, 1);
    self.ui_healthbar["name"].archived = true;
    self.ui_healthbar["name"].sort = 10;
    self.ui_healthbar["name"].foreground = true;
    self.ui_healthbar["name"].hidewheninmenu = true;
    self.ui_healthbar["name"] settext(self.name);
    self.ui_healthbar["name"] thread destroy_on_notify( "end_game" );
    
    self.ui_healthbar["blood"] = newClientHudElem(self);
    self.ui_healthbar["blood"].x = 15;
    self.ui_healthbar["blood"].y = 418;
    self.ui_healthbar["blood"].alignx = "left";
    self.ui_healthbar["blood"].horzalign = "fullscreen";
    self.ui_healthbar["blood"].vertalign = "fullscreen";
    self.ui_healthbar["blood"].alpha = 1;
    self.ui_healthbar["blood"].sort = -1;
    self.ui_healthbar["blood"].archived = true;
    self.ui_healthbar["blood"].color = (0.31,0,0);
    self.ui_healthbar["blood"].foreground = false;
    self.ui_healthbar["blood"].hidewheninmenu = 1;
    self.ui_healthbar["blood"] setshader("scorebar_zom_1", 85, 50);
    self.ui_healthbar["blood"] thread destroy_on_notify( "end_game" );
        
    self thread LowHealthPulse();
    old_width 		= 0;
    downed			= 0;
    low_health		= 0;

    while (1) {
        if(isdefined(level.intermission) && level.intermission == 1)
            break;
        
        if(self.sessionstate != "spectator" && !self maps\mp\zombies\_zm_laststand::player_is_in_laststand()) {
        	downed = self player_is_in_laststand();
      	    low_health = self.health < 50;
       		
        	width = (self.health / self.maxhealth) * base_width * (250 / 250);
        	width = downed ? 1 : int(max(width, 1));
        	
        	if(width > base_width)
        		width = base_width;
			
			if(isdefined(old_width) && width != old_width) {
				if(width < old_width)
					self.ui_healthbar["healthbar"] setShader("white", width, base_height);
				else
					self.ui_healthbar["healthbar"] scaleovertime(.15, width, base_height);
				
				old_width = width;
			}
		
			if(!low_health && !isdefined(self.is_burning)) {
				self.ui_healthbar["healthbar"].color = color;
        		self.ui_healthbar["health"].color = color;
        	}
        	
        	self.ui_healthbar["max_value"] setvalue(self.maxhealth);
			self.ui_healthbar["health"] setValue(self.health);
      	}
      	else
      		wait .1;
      	
		wait .05;
    }
}

create_shield_bar() {    
	level endon( "end_game" );
	self endon("disconnect");
	
    self.int_shield = self hasweapon(level.riotshield_name);   

	while (1) {
		if(self.sessionstate != "spectator" && !self maps\mp\zombies\_zm_laststand::player_is_in_laststand()) {
			if (self.int_shield || self hasweapon("riotshield_zm")) 
				self.int_shield = true;
			else 
				self.int_shield = false;
		
			if (self.int_shield && (self.shielddamagetaken < 2300)) {
				if(!isdefined(self.shield_bar)) {
            		x = 20;
            		y = 441;
            		base_width = 80;
            		base_height = 1;
              
            		self.shield_bar = newClientHudElem( self );
            		self.shield_bar.x = x;
            		self.shield_bar.y = y;
            		self.shield_bar.alignx = "left";
            		self.shield_bar.aligny = "bottom";
            		self.shield_bar.horzalign = "fullscreen";
            		self.shield_bar.vertalign = "fullscreen";
            		self.shield_bar.color = ( .1, .5, 1 );
            		self.shield_bar.alpha = 1;
            		self.shield_bar.sort = 100;
           	 		self.shield_bar.hidewheninmenu = true;
            		self.shield_bar thread destroy_on_notify( "end_game" );
				}
			
				shield_hp = ((2300 - self.shielddamagetaken) / 2300);
				new_width = int(base_width * shield_hp);
	
				self.shield_bar setshader("white", new_width, base_height);
			}
			else {
				if(self.int_shield == true)
					self.int_shield = false;
				
    			if(isdefined(self.shield_bar))
    				self.shield_bar destroy();
			}	
		}	
		else {
			if(self.int_shield == true)
				self.int_shield = false;
			
    		if(isdefined(self.shield_bar))
    			self.shield_bar destroy();
		}
	
		wait .05;
	}
}

LowHealthPulse() {
	self endon("disconnect");
	level endon("end_game");
	
	while(1) {
		if(self.health < 75 && self.sessionstate == "playing") {
			self.health_bar fadeovertime(.2);
			self.health_bar.color = (1,0,0);
			wait .2;
			self.health_bar fadeovertime(.2);
			self.health_bar.color = (.31, 0, 0);
			wait .2;
			
			if(self.health > 75)
				low_health = false;
		}
		wait .10;
	}
}

round_think( restart ) {
	flag_wait( "start_zombie_round_logic" );
	
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
			
		wait 0.9;
		
		foreach(player in level.players) {
			if(isdefined(player.round_number_completed)) {
				player.round_number_completed.alpha = 0;
    			player.round_number_nextround.alpha = 0;
    			
    			player thread CustomRoundNumber();
    		}
    	}
    	
    	wait 0.5;
		
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
		
		foreach(player in level.players) {
			if(isdefined(player.round_number_hud)) {
				player.round_number_hud fadeovertime(0.5);
    			player.round_number_hud.alpha = 0;
    	
    			player.round_number_shader fadeovertime(0.5);
    			player.round_number_shader.alpha = 0;
    		}
    	}
    	wait 0.2;
		foreach(player in level.players) {
			if(isdefined(player.round_number_completed)) {
				player.round_number_completed.alpha = 1;
    			player.round_number_nextround.alpha = 1;
    			player.round_number_nextround Settimer(10);
    		}
    	}
    	
    	level.round_number++;
		level round_over();
		level notify( "between_round_over" );
		restart = 0;
		
		wait .05;
	}
}

CustomRoundNumber() {
   	if(level.round_number == 1 || level.round_number == 0)
    	flag_wait("initial_blackscreen_passed");
    
    self.round_number_hud setvalue(level.round_number);
    
    wait 0.5;
    
    self.round_number_hud fadeovertime(1);
    self.round_number_hud.alpha = 1;
    self.round_number_shader fadeovertime(1);
    self.round_number_shader.alpha = 1;
}

destroy_on_notify(notifyname) {
	level waittill(notifyname);
	
	if(isdefined(self))
		self destroy();
}

Buildroundnumber() {
	self.round_number_hud = newclienthudelem(self);
    self.round_number_hud.color = (1, 1, 1);
    self.round_number_hud.hidewheninmenu = 1;
    self.round_number_hud.foreground = 0;
    self.round_number_hud.fontscale = 1;
    self.round_number_hud.font = "bigfixed";
    self.round_number_hud.label = &"^9WAVE ^7";
    self.round_number_hud.alignx = "left";
    self.round_number_hud.aligny= "top";
    self.round_number_hud.horzalign = "fullscreen";
    self.round_number_hud.vertalign= "fullscreen";
    self.round_number_hud.x = 25;
    self.round_number_hud.y = 25;
    self.round_number_hud.alpha = 0;
    self.round_number_hud thread destroy_on_notify( "end_game" );
    
    self.round_number_shader = newclienthudelem(self);
    self.round_number_shader.color = (.21, 0, 0);
    self.round_number_shader.hidewheninmenu = 1;
    self.round_number_shader.foreground = 0;
    self.round_number_shader.alpha = 0;
    self.round_number_shader.alignx = "left";
    self.round_number_shader.aligny= "top";
    self.round_number_shader.x = 15;
    self.round_number_shader.y = 20;
    self.round_number_shader.horzalign = "fullscreen";
    self.round_number_shader.vertalign= "fullscreen";
    self.round_number_shader setshader("scorebar_zom_1", 75, 30);
    self.round_number_shader thread destroy_on_notify( "end_game" );
    
    self.round_number_completed = newclienthudelem(self);
    self.round_number_completed.color = (1, 1, 1);
    self.round_number_completed.hidewheninmenu = 1;
    self.round_number_completed.foreground = 0;
    self.round_number_completed.fontscale = 1;
    self.round_number_completed.font = "bigfixed";
    self.round_number_completed settext("^9WAVE COMPLETED");
    self.round_number_completed.alignx = "left";
    self.round_number_completed.aligny= "top";
    self.round_number_completed.horzalign = "fullscreen";
    self.round_number_completed.vertalign= "fullscreen";
    self.round_number_completed.x = 25;
    self.round_number_completed.y = 25;
    self.round_number_completed.alpha = 0;
    self.round_number_completed thread destroy_on_notify( "end_game" );
    
    self.round_number_nextround = newclienthudelem(self);
    self.round_number_nextround.color = (1, 1, 1);
    self.round_number_nextround.hidewheninmenu = 1;
    self.round_number_nextround.foreground = 0;
    self.round_number_nextround.fontscale = 1.3;
    self.round_number_nextround.font = "default";
    self.round_number_nextround.label = &"^9Next Wave in ^7";
    self.round_number_nextround.alignx = "left";
    self.round_number_nextround.aligny= "top";
    self.round_number_nextround.horzalign = "fullscreen";
    self.round_number_nextround.vertalign= "fullscreen";
    self.round_number_nextround.x = 25;
    self.round_number_nextround.y = 45;
    self.round_number_nextround.alpha = 0;
    self.round_number_nextround thread destroy_on_notify( "end_game" );
}

set_hitmarker() {
    self endon("disconnect");
    level endon("end_game");

    self.hitmarker = newdamageindicatorhudelem(self);
    self.hitmarker.horzalign = "center";
    self.hitmarker.vertalign = "middle";
    self.hitmarker.x = -12;
    self.hitmarker.y = -12;
    self.hitmarker.alpha = 0;
    self.hitmarker.foreground = true;
    self.hitmarker.hidewheninmenu = true;
    self.hitmarker.kill_event = false;
    self.hitmarker.archived = false;
    self.hitmarker setshader("damage_feedback", 24, 48);

    while (true) {
        foreach(zombie in get_round_enemy_array())  // TODO Test: for manually spawned enemies
            if (!isDefined(zombie.await_damage))
                zombie thread show_hitmarker();
                
        if(level.script == "zm_transit")
        	self setworldfogactivebank(0);
        wait 1;
    }
}

show_hitmarker() {
    self endon("killed_zombie");
    level endon("end_game");

    self.await_damage = true;
    scale_up = 1.25;
    scale_down = .875;
    scale_time = .04;

    while (true) {
        self waittill("damage", amount, attacker, direction, point, type, modelname, tagname, partname, weaponname);

        if (!isplayer(attacker) || isDefined(self.nuked))
            continue;

        if (attacker.hitmarker.kill_event)
            continue;

        // small base hitmarker
        attacker.hitmarker.alpha = 0;
        attacker.hitmarker.x = int(-12 * scale_down);
        attacker.hitmarker.y = int(-12 * scale_down);
        attacker setshader("damage_feedback", int(24 * scale_down), int(48 * scale_down));

        attacker playlocalsound("zmb_death_gibs");
        attacker playlocalsound("chr_zombie_head_gib");
        attacker playlocalsound("zmb_zombie_head_gib");

        if (isalive(self)) {
            // color fade (default by noobs is 1)
            attacker.hitmarker.color = (1, 1, 1);
            attacker.hitmarker.alpha = 1;
            attacker.hitmarker fadeovertime(.35);
            attacker.hitmarker.alpha = 0;

            // scale up
            attacker.hitmarker scaleovertime(scale_time, int(24 * scale_up), int(48 * scale_up));
            attacker.hitmarker moveovertime(scale_time);
            attacker.hitmarker.x = int(-12 * scale_up);
            attacker.hitmarker.y = int(-12 * scale_up);

            // scale down
            attacker.hitmarker scaleovertime(scale_time, int(24 * scale_down), int(48 * scale_down));
            attacker.hitmarker moveovertime(scale_time);
            attacker.hitmarker.x = int(-12 * scale_down);
            attacker.hitmarker.y = int(-12 * scale_down);
        }

        else {
            // larger scale for kills
            init_scale_up = scale_up;
            scale_up = 1.5;

            // headshot sound
            if (self damagelocationisany("head", "helmet", "neck")) {
                attacker playlocalsound("prj_bullet_impact_headshot");  // or "evt_player_death_imp"
            }

            attacker.hitmarker.color = isdefined(attacker.favorite_hud_color) ? attacker.favorite_hud_color : (.70, .15, .15);
            attacker.hitmarker.alpha = 1;

            // scale up
            attacker.hitmarker scaleovertime(scale_time, int(24 * scale_up), int(48 * scale_up));
            attacker.hitmarker moveovertime(scale_time);
            attacker.hitmarker.x = int(-12 * scale_up);
            attacker.hitmarker.y = int(-12 * scale_up);

            attacker.hitmarker.kill_event = true;
            wait float(scale_time * 2);
            attacker.hitmarker.kill_event = false;

            // scale down
            attacker.hitmarker scaleovertime(scale_time, int(24 * scale_down), int(48 * scale_down));
            attacker.hitmarker moveovertime(scale_time);
            attacker.hitmarker.x = int(-12 * scale_down);
            attacker.hitmarker.y = int(-12 * scale_down);

            // color fade (default by noobs is 1)
            attacker.hitmarker fadeovertime(.35);
            attacker.hitmarker.alpha = 0;

            scale_up = init_scale_up;
            self notify("killed_zombie");
        }
    }
}

SpawnProtection() {
	protectiontime = 20;
	self.health = 350;
	self.maxhealth = self.health;
	wait protectiontime;
	if(self hasperk("specialty_armorvest")) {
		self.health = 250;
		self.maxhealth = self.health;
	}
	else {
		self.health = 150;
		self.maxhealth = self.health;
	}
}
