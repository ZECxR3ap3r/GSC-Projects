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

createBar_new( color, width, height, flashFrac ) {
	barelem = newclienthudelem( self );
	barelem.x = 0;
	barelem.y = 0;
	barelem.frac = 0;
	barelem.color = color;
	barelem.aligny = "middle";
	barelem.sort = -2;
	barelem.archived = false;
	barelem.shader = "progress_bar_fill";
	barelem setshader( "progress_bar_fill", width, height );
	barelem.hidden = 0;
	if ( isDefined( flashfrac ) )
		barelem.flashfrac = flashfrac;
	barelemframe = newclienthudelem( self );
	barelemframe.elemtype = "icon";
	barelemframe.x = 0;
	barelemframe.y = 0;
	barelemframe.width = width;
	barelemframe.height = height;
	barelemframe.xoffset = 0;
	barelemframe.yoffset = 0;
	barelemframe.aligny = "middle";
	barelemframe.bar = barelem;
	barelemframe.archived = false;
	barelemframe.barframe = barelemframe;
	barelemframe.children = [];
	barelemframe.sort = -1;
	barelemframe.color = ( 1, 0, 0 );
	barelemframe setparent( level.uiparent );
	barelemframe.hidden = 0;
	barelembg = newclienthudelem( self );
	barelembg.elemtype = "bar";
	if ( !self issplitscreen() ) {
		barelembg.x = -2;
		barelembg.y = -2;
	}
	barelembg.width = width;
	barelembg.height = height;
	barelembg.xoffset = 0;
	barelembg.yoffset = 0;
	barelembg.bar = barelem;
	barelembg.aligny = "middle";
	barelembg.barframe = barelemframe;
	barelembg.children = [];
	barelembg.archived = false;
	barelembg.sort = -3;
	barelembg.color = ( 1, 0, 0 );
	barelembg.alpha = 0.5;
	barelembg setparent( level.uiparent );
	barelembg setshader( "black", width, height);
	barelembg.hidden = 0;
	return barelembg;
}

main() {
	register_player_damage_callback( ::damage_callback );
}

init() {
	replacefunc(maps/mp/zombies/_zm_laststand::cleanup_laststand_on_disconnect, ::cleanup_laststand_on_disconnect);
	replacefunc(maps/mp/zombies/_zm_laststand::laststand_clean_up_on_disconnect, ::laststand_clean_up_on_disconnect);
	replacefunc(maps/mp/zombies/_zm_laststand::revive_trigger_spawn, ::revive_trigger_spawn);
	replacefunc(::give_perk, ::give_perk_new);
	replacefunc(::add_to_player_score, ::add_to_player_score_new);
	replacefunc(::minus_to_player_score, ::minus_to_player_score_new);
	replacefunc(maps/mp/gametypes_zm/_hud_util::createbar, ::createBar_new);
	
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
	precacheshader("hud_icon_claymore_256");
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
	precacheshader("line_vertical");
	precacheshader("progress_bar_fill");
	precacheshader("hud_offscreenobjectivepointer");
	precacheshader("ui_slider2");
	precacheshader("waypoint_revive");
	
	level.zombie_last_stand = ::LastStand;
	level.get_player_weapon_limit = ::custom_get_player_weapon_limit;
	
	level.ui_better_orange = (0.898,0.643,0.169);
	level.ui_better_red_bright = (0.678,0.012,0.031);
	level.ui_better_red = (0.678,0.012,0.031);
	level.ui_better_blue = (0.102,0.537,0.906);
	level.hud = create_simple_hud();
	level.hudtext = create_simple_hud();
	level.hud.fontscale = 1.7;
	level.hud.color = level.ui_better_red;
	level.hudtext.color = level.ui_better_red;
	level.hud.font = "default";
	level.hudtext.font = "default";
	level.hudtext.hidewheninmenu = 1;
	level.hud.hidewheninmenu = 1;
	level.hud thread DestroyBefore();
	level.hudtext thread DestroyBefore();
    level thread onPlayerConnect();
    level thread CustomRoundNumber();
    flag_wait( "start_zombie_round_logic" );
    level notify("end_round_think");
    wait 1;
    level thread round_think();
}

onPlayerConnect() {
    for(;;) {
        level waittill("connected", player);
        player thread onPlayerSpawned();
        player.realname = player.name;
    }
}

onPlayerSpawned() {
    self endon("disconnect");
	level endon("end_game");
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
			self thread update_powerup_hud();
			self thread upgrade_visuals();
			self thread WeaponHud();
			self thread TrackAmmoStuff();
			self thread removeperkshader();
			self thread upgrade_crosshair();
			self thread set_hitmarker();
			self thread Perk_Hud_Watcher();
			self.addedpoints = 0;
			self setclientuivisibilityflag("hud_visible", 0);
			
			wait 5;
			
			self iprintlnbold("Press ^8[{+actionslot 3}] ^7to Open the ^8Perk List");
        }
    }
}

revive_trigger_spawn() {
	if(isdefined(level.revive_trigger_spawn_override_link))
		[[level.revive_trigger_spawn_override_link]](self);
	else {
		radius = GetDvarInt("revive_trigger_radius");
		self.revivetrigger = spawn("trigger_radius",  0, 0, 0, 0, radius, radius);
		self.revivetrigger sethintstring("");
		self.revivetrigger setcursorhint("HINT_NOICON");
		self.revivetrigger setmovingplatformenabled(1);
		self.revivetrigger enablelinkto();
		self.revivetrigger.origin = self.origin;
		self.revivetrigger linkto(self);
		self.revivetrigger.beingrevived = 0;
		self.revivetrigger.createtime = GetTime();
	}
	if(!isdefined(self.player_revive_hud_elem))
		self thread revive_hud_think();
	self thread revive_trigger_think();
}

revive_hud_think() {
	self endon("disconnect");
	level endon("end_game");
	self endon("death");
	height_offset = 30;
	hud_elem = newhudelem();
	self.player_revive_hud_elem = hud_elem;
	hud_elem.x = self.origin[0];
	hud_elem.y = self.origin[1];
	hud_elem.z = self.origin[2] + height_offset;
	hud_elem.alpha = 1;
	hud_elem.archived = false;
	hud_elem setshader("waypoint_revive", 5, 5);
	hud_elem setwaypoint(1);
	hud_elem.hidewheninmenu = 1;
	hud_elem.immunetodemogamehudsettings = 1;
	hud_elem setinvisibletoplayer(self);
	while(1) {
		if(isdefined(self.revivetrigger)) {
			hud_elem.x = self.origin[0];
			hud_elem.y = self.origin[1];
			hud_elem.z = self.origin[2] + height_offset;
		}
		else {
			if(isdefined(hud_elem))
				hud_elem destroy();
				
			break;
		}
		wait .05;
	}
}

cleanup_laststand_on_disconnect() {
	self endon("player_revived");
	self endon("player_suicide");
	self endon("bled_out");
	trig = self.revivetrigger;
	revivehud = self.player_revive_hud_elem;
	self waittill("disconnect");
	if(isdefined(trig))
		trig delete();
	
	if(isdefined(revivehud)) {
		revivehud destroy();
		revivehud = undefined;
	}
}

laststand_clean_up_on_disconnect(playerbeingrevived, revivergun) {
	self endon("do_revive_ended_normally");
	revivetrigger = playerbeingrevived.revivetrigger;
	revivehud = playerbeingrevived.player_revive_hud_elem;
	playerbeingrevived waittill("disconnect");
	if(isdefined(revivetrigger))
		revivetrigger delete();
	if(isdefined(revivehud)) {
		revivehud destroy();
		revivehud = undefined;
	}
	self cleanup_suicide_hud();
	if(isdefined(self.reviveprogressbar))
		self.reviveprogressbar maps/mp/gametypes_zm/_hud_util::destroyelem();
	if(isdefined(self.revivetexthud))
		self.revivetexthud destroy();
	self revive_give_back_weapons(revivergun);
}

DestroyBefore() {
	level waittill("end_game");
	
	foreach(hud in self.WeaponHud)
		hud destroy();
	
	if(isdefined(self))
		self destroy();
		
	self = undefined;
}

Perk_Hud_Watcher() {
	self endon("disconnect");
	level endon("end_game");
	
	self.currentperkstitle = newClientHudElem(self);
   	self.currentperkstitle.x = 20;
    self.currentperkstitle.y = 60;  // 220;
    self.currentperkstitle.alignx = "left";
    self.currentperkstitle.aligny = "top";
   	self.currentperkstitle.color = (1, 1, 1);
    self.currentperkstitle.alpha = 0;
    self.currentperkstitle.sort = 80;
    self.currentperkstitle.archived = false;
    self.currentperkstitle.foreground = true;
    self.currentperkstitle.fontscale = 1.2;
    self.currentperkstitle.font = "objective";
    self.currentperkstitle.horzalign = "fullscreen";
    self.currentperkstitle.vertalign = "fullscreen";
    self.currentperkstitle.hidewheninmenu = 1;
    self.currentperkstitle.hidewhendeath = 1;
    self.currentperkstitle settext("^8Current Perks:");
    self.currentperkstitle thread DestroyBefore();
    	
    self.currentperkstitleshader = newClientHudElem(self);
   	self.currentperkstitleshader.x = 20;
    self.currentperkstitleshader.y = 75;  // 220;
    self.currentperkstitleshader.alignx = "left";
    self.currentperkstitleshader.aligny = "top";
   	self.currentperkstitleshader.color = (1, 1, 1);
    self.currentperkstitleshader.alpha = 0;
    self.currentperkstitleshader.sort = 80;
    self.currentperkstitleshader.archived = false;
    self.currentperkstitleshader.foreground = true;
    self.currentperkstitleshader.horzalign = "fullscreen";
    self.currentperkstitleshader.vertalign = "fullscreen";
    self.currentperkstitleshader.hidewheninmenu = 1;
    self.currentperkstitleshader.hidewhendeath = 1;
    self.currentperkstitleshader setshader("white", 1, 12);
    self.currentperkstitleshader thread DestroyBefore();
	
	while(1) {
		if(self actionslotthreebuttonpressed()) {
			if(self.currentperkstitleshader.alpha != 1) {
				self.currentperkstitleshader fadeovertime(0.5);
				self.currentperkstitleshader.alpha = 1;
				self.currentperkstitle fadeovertime(0.5);
				self.currentperkstitle.alpha = 1;
				
				if(isdefined(self.currentperks)) {
					self.currentperks fadeovertime(0.5);
					self.currentperks.alpha = 1;
				}
				
				wait .5;
			}
			else {
				self.currentperkstitleshader fadeovertime(0.5);
				self.currentperkstitleshader.alpha = 0;
				self.currentperkstitle fadeovertime(0.5);
				self.currentperkstitle.alpha = 0;
				
				if(isdefined(self.currentperks)) {
					self.currentperks fadeovertime(0.5);
					self.currentperks.alpha = 0;
				}
				
				wait .5;
			}
		}
		wait .05;
	}
}

minus_to_player_score_new( points, ignore_double_points_upgrade ) {
	if ( !isDefined( points ) || level.intermission )
		return;
	if ( !is_true( ignore_double_points_upgrade ) ) {
		if ( is_true( level.pers_upgrade_double_points ) )
			points = maps/mp/zombies/_zm_pers_upgrades_functions::pers_upgrade_double_points_set_score( points );
	}
	
	if(points != 0) {
		self.ScoreNumberGained notify("stopnewpoints");
		self.ScoreNumberGained.alpha = 1;
		
		if(isdefined(self.addedpoints)) {
			total = int(self.addedpoints - points);
		}
		else {
			self.addedpoints = 0;
			total = int(self.addedpoints - points);
		}
		
		self.addedpoints -= points;
		
		if(total >= 0)
			self.ScoreNumberGained.glowcolor = (0,1,0);
		else
			self.ScoreNumberGained.glowcolor = level.ui_better_red_bright;
		
		self.ScoreNumberGained setvalue(total);
		self.ScoreNumberGained thread fadeinBlackOut(5,0, self);
	}
	
	self.score -= points;
	self.pers[ "score" ] = self.score;
	level notify( "spent_points" );
}

add_to_player_score_new( points, add_to_total ) {
	if ( !isDefined( add_to_total ) )
		add_to_total = 1;
	if ( !isDefined( points ) || level.intermission )
		return;
		
	if(points != 0) {
		self.ScoreNumberGained notify("stopnewpoints");
		self.ScoreNumberGained.alpha = 1;
		
		if(isdefined(self.addedpoints)) {
			total = int(self.addedpoints + points);
		}
		else {
			self.addedpoints = 0;
			total = points;
		}
		
		self.addedpoints += points;
		
		if(total >= 0)
			self.ScoreNumberGained.glowcolor = (0,1,0);
		else
			self.ScoreNumberGained.glowcolor = level.ui_better_red_bright;
		
		self.ScoreNumberGained setvalue(total);
		self.ScoreNumberGained thread fadeinBlackOut(5,0, self);
	}
	
	self.score += points;
	self.pers[ "score" ] = self.score;
	if ( add_to_total )
		self.score_total += points;
	self incrementplayerstat( "score", points );
}

fadeinBlackOut( duration, alpha, player) {
	self endon("stopnewpoints");
	wait duration;
	self.alpha = alpha;
	player.addedpoints = undefined;
}

update_powerup_hud(powerup_hud) {
	self endon("disconnect");
	
	if(!isdefined(self.powerup_hud))
		self.powerup_hud = [];
	
	while(1) {
		if(is_true(level.zombie_vars["zombie_powerup_fire_sale_on"] == 1) && !isdefined(self.powerup_hud["fire_sale"]))
			self powerup_hud_create("fire_sale", "specialty_firesale_zombies", 0);
		else if(!is_true(level.zombie_vars["zombie_powerup_fire_sale_on"] == 1) && isdefined(self.powerup_hud["fire_sale"]))
			self powerup_hud_destroy("fire_sale");
		
		if(is_true(level.zombie_vars[self.team]["zombie_powerup_insta_kill_on"] == 1) && !isdefined(self.powerup_hud["insta_kill"]))
			self powerup_hud_create("insta_kill", "specialty_instakill_zombies", 1);
		else if(!is_true(level.zombie_vars[self.team]["zombie_powerup_insta_kill_on"] == 1) && isdefined(self.powerup_hud["insta_kill"]))
			self powerup_hud_destroy("insta_kill");
		
		if(is_true(level.zombie_vars[self.team]["zombie_powerup_point_doubler_on"] == 1) && !isdefined(self.powerup_hud["double_points"]))
			self powerup_hud_create("double_points", "specialty_doublepoints_zombies", 1);
		else if(!is_true(level.zombie_vars[self.team]["zombie_powerup_point_doubler_on"] == 1) && isdefined(self.powerup_hud["double_points"]))
			self powerup_hud_destroy("double_points");
		
		wait .1;
	}
}

powerup_hud_create(powerup, shader, team) {
	if(!isdefined(self.powerup_hud))
		self.powerup_hud = [];
	
	if(isdefined(self.powerup_hud[powerup]))
		return;
	
	hud = self createicon(shader, 20, 20);
	hud setpoint("CENTER", "BOTTOM", 0, -20);
	hud.foreground = 1;
	hud.sort = 1;
	hud.hidewheninmenu = 1;
	hud.alpha = 1;
	hud thread powerup_hud_fade(powerup, self, team);
	self.powerup_hud[powerup] = hud;
	self powerup_hud_update();
}

powerup_hud_destroy(powerup) {
	if(!isdefined(self.powerup_hud))
		return;
	
	if(!isdefined(self.powerup_hud[powerup]))
		return;
	
	self.powerup_hud[powerup] destroy();
	self.powerup_hud[powerup] = undefined;
	self powerup_hud_update();
}

powerup_hud_update() {
	if(self.powerup_hud.size <= 0)
		return;
	
	i = 0;
	foreach(element in self.powerup_hud) {
		element.x = i * 18;
		for(k = i + 1; k < self.powerup_hud.size; k++)
			element.x = element.x - 18;
		i++;
	}
}

powerup_hud_fade(powerup, player, team) {
	self endon("death");
	
	if(is_true(level.zombie_powerups[powerup].solo))
		user = player;
	else
		user = level;
	
	while(1) {
		if(is_true(user.zombie_vars[level.zombie_powerups[powerup].time_name] < 5)) {
			wait .1;
			self.alpha = 0;
			wait .1;
		}
		else if(is_true(user.zombie_vars[level.zombie_powerups[powerup].time_name] < 10)) {
			wait .2;
			self.alpha = 0;
			wait .18;
		}
		self.alpha = 1;
		wait .05;
	}
}


zone_hud() {
    self endon("disconnect");
    self.zone_hud = newClientHudElem(self);
    self.zone_hud.alignx = "left";
    self.zone_hud.aligny = "top";
    self.zone_hud.font = "objective";
    self.zone_hud.horzalign = "fullscreen";
    self.zone_hud.vertalign = "fullscreen";
    self.zone_hud.x = 20;
    self.zone_hud.y = 15;
    self.zone_hud.fontscale = 1.3;
    self.zone_hud.alpha = 1;
    self.zone_hud.color = (1, 1, 1);
    self.zone_hud thread DestroyBefore();

    flag_wait("initial_blackscreen_passed");

    prev_zone = "";
    while (1) {
    	CurrentZone = self get_current_zone();
        zone = self get_zone_name(CurrentZone);

        if (prev_zone != zone) {
            prev_zone = zone;

            self.zone_hud fadeovertime(0.1);
            self.zone_hud.alpha = 0;
            wait 0.1;

            self.zone_hud settext(zone);

            self.zone_hud fadeovertime(0.1);
            self.zone_hud.alpha = 1;
            wait 0.1;

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
		level.round_number++;
		level thread flashroundnumber();
		level round_over();
		level notify( "between_round_over" );
		restart = 0;
		wait .05;
	}
}

CustomRoundNumber() {
    level.hud.alignx = "center";
    level.hud.aligny = "top";
    level.hud.horzalign = "center";
    level.hud.vertalign = "user_top";
    level.hudtext.alignx = "center";
    level.hudtext.aligny = "top";
    level.hudtext.horzalign = "center";
    level.hudtext.vertalign = "user_top";
    flag_wait("initial_blackscreen_passed");
    level.hudtext settext("WAVE");
    level.hud setvalue(level.round_number);
    level.hud.fontscale = 3;
    level.hud.x = 0;
    level.hud.y = 90;
    level.hud.alpha = 0;
    level.hudtext.fontscale = 2;
    level.hudtext.x = 0;
    level.hudtext.y = 70;
    level.hudtext.alpha = 0;
    level.hud fadeovertime(0.5);
    level.hud.alpha = 1;
    level.hudtext fadeovertime(0.5);
    level.hudtext.alpha = 1;
    wait 3;
    level.hudtext fadeovertime(0.5);
    level.hudtext.alpha = 0;
    level.hud moveovertime(1);
    level.hud.alignx = "left";
    level.hud.aligny = "top";
    level.hud.horzalign = "fullscreen";
    level.hud.vertalign = "fullscreen";
    level.hud.x = 20;
    level.hud.y = 30;  // 15
}

flashroundnumber() {
    level.hud fadeovertime(1);
    level.hud.alpha = 0;
    wait 1;
    level.hud.alignx = "center";
    level.hud.aligny = "top";
    level.hud.horzalign = "center";
    level.hud.vertalign = "user_top";
    level.hud setvalue(level.round_number);
    level.hud.alignx = "CENTER";
    level.hud.aligny = "top";
    level.hud.horzalign = "user_center";
    level.hud.vertalign = "user_top";
    level.hud.x = 0;
    level.hud.y = 90;
    level.hud.fontscale = 2.6;
    level.hud fadeovertime(0.5);
    level.hud.alpha = 1;
    level.hudtext fadeovertime(0.5);
    level.hudtext.alpha = 1;
    wait 3;
    level.hudtext fadeovertime(0.5);
    level.hudtext.alpha = 0;
    wait 1;
    level.hud moveovertime(1);
    level.hud.alignx = "left";
    level.hud.aligny = "top";
    level.hud.horzalign = "fullscreen";
    level.hud.vertalign = "fullscreen";
    level.hud.x = 20;
    level.hud.y = 30;
    level.hud fadeovertime(0.5);
    level.hud.alpha = 1;
}

get_zone_name(key) {
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
            level.zone_names["zone_trans_8"] = "Box Room";
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

give_perk_new( perk, bought ) {
	self SetPerk( perk );
	self.num_perks++;
	
	
	
	print = 1;
	
	if ( is_true( bought ) ) {
		self maps\mp\zombies\_zm_audio::playerExert( "burp" );
		self setblur( 4, 0.1 );
		wait 0.1;
		self setblur(0, 0.1);
	}
	
	if(perk == "specialty_armorvest") {
		self.preMaxHealth = self.maxhealth;
		self SetMaxHealth( level.zombie_vars["zombie_perk_juggernaut_health"] );
	}
	else if ( perk == "specialty_scavenger" )
		self.HasPerkSpecialtyTombstone = true;	
	else if ( perk == "specialty_grenadepulldeath" )
         self thread maps/mp/zombies/_zm_perk_electric_cherry::electric_cherry_reload_attack();
    else if ( perk == "specialty_finalstand" ) {
         self.lives = 1;
         self.hasperkspecialtychugabud = 1;
         self notify( "perk_chugabud_activated" );
    }
    else if(perk == "Downers_Delight") {
    	self thread DDown();
    	self.Downers_Delight = 1;
    	if(print) {
			self iprintln("^9Downer's Delight");
			wait 0.2;
			self iprintln("This Perk will increase players bleedout time by 10 seconds and current weapons is used in laststand.");
		}
    }
    else if(perk == "MULE") {
    	self.MULE = 1;
    	if(print) {
			self iprintln("^9Mule Kick");
			wait 0.2;
			self iprintln("This Perk enables additional primary weapon slot for player. ");
		}
    }
    else if(perk == "PHD_FLOPPER") {
    	self.PHD_FLOPPER = 1;
    	if(print) {
			self iprintln("^9PhD Flopper");
			wait 0.2;
			self iprintln("This Perk removes explosion and fall damage also player creates explosion when dive to prone.");
		}
    }
    else if(perk == "Victorious_Tortoise") {
    	self.Victorious_Tortoise = 1;
    	if(print) {
			self iprintln("^9Victorious Tortoise");
			wait 0.2;
			self iprintln("This Perk allows shield block damage from all directions when in use.");
		}
    }
   	else if(perk == "ELECTRIC_CHERRY") {
    	self thread start_ec();
    	self.ELECTRIC_CHERRY = 1;
    	if(print) {
			self iprintln("^9Electric Cherry");
			wait 0.2;
			self iprintln("This Perk creates an electric shockwave around the player whenever they reload.");
		}
    }
    else if(perk == "WIDOWS_WINE") {
    	self.WIDOWS_WINE = 1;
    	self thread ww_nades();
    	if(print) {
			self iprintln("^9Widow's Wine");
			wait 0.2;
			self iprintln("This Perk damages zombies around the player when player is hit and grenades are upgraded.");
		}
    }
    else if(perk == "Ethereal_Razor") {
    	self.Ethereal_Razor = 1;
		self thread start_er();
    	if(print) {
			self iprintln("^9Ethereal Razor");
			wait 0.2;
			self iprintln("This Perk deals extra damage when player using melee attacks and restores a small amount of health.");
		}
    }
    else if(perk == "Ammo_Regen") {
    	self.Ammo_Regen = 1;
		self thread ammoregen();
        self thread grenadesregen();
    	if(print) {
			self iprintln("^9Ammo Regen");
			wait 0.2;
			self iprintln("This Perk will slowly regenerades players ammonation and grenades.");	
		}
    }
    else if(perk == "Burn_Heart") {
    	self.Burn_Heart = 1;
    	self.ignore_lava_damage = 1;
    	if(print) {
			self iprintln("^9Burn Heart");
			wait 0.2;
			self iprintln("This Perk removes lava damage.");
		}
    }
    else if(perk == "Dying_Wish") {
    	self.Dying_Wish = 1;
		self thread dying_wish_checker();
    	if(print) {
			self iprintln("^9Dying Wish");
			wait 0.2;
			self iprintln("This Perk allow player to go berserker mode for 9 seconds instead of laststand.");
			wait 0.1;
			self iprintln(" (cooldown 5mins and it's increased 30sec every time perk is used. - max 10mins) ");
		}
    }
    else if(perk == "deadshot") {
    	self.deadshot = 1;
		self thread aimassist();
    	if(print) {
			self iprintln("^9Deadshot");
			wait 0.2;
			self iprintln("This Perk aims automatically enemys head instead of body.");
		}
    }
	
	maps/mp/_demo::bookmark( "zm_player_perk", getTime(), self );
	self maps/mp/zombies/_zm_stats::increment_client_stat( "perks_drank" );
	self maps/mp/zombies/_zm_stats::increment_player_stat( "perks_drank" );
	
	players = GET_PLAYERS();
	if ( use_solo_revive() && perk == "specialty_quickrevive" ) {
		self.lives = 1;
		level.solo_lives_given++;
		
		if( level.solo_lives_given >= 3 )
			flag_set( "solo_revive" );
		
		self thread solo_revive_buy_trigger_move( perk );
	}
	
	maps\mp\_demo::bookmark( "zm_player_perk", gettime(), self );
	
	if(!isDefined(self.perk_history))
		self.perk_history = [];
	
	self.perk_history = add_to_array(self.perk_history,perk,false);
	self notify("perk_acquired");	
	self perk_hud_create( perk );
	self thread perk_think( perk );
}

perk_hud_create( perk ) {
    if(!isdefined(self.currentperks)) {
    	self.currentperks = newClientHudElem(self);
   	 	self.currentperks.x = 27;
    	self.currentperks.y = 75;  // 220;
    	self.currentperks.alignx = "left";
    	self.currentperks.aligny = "top";
   	 	self.currentperks.color = (1, 1, 1);
    	self.currentperks.alpha = 0;
    	self.currentperks.sort = 80;
    	self.currentperks.archived = false;
    	self.currentperks.foreground = true;
    	self.currentperks.fontscale = 1;
    	self.currentperks.font = "objective";
    	self.currentperks.horzalign = "fullscreen";
    	self.currentperks.vertalign = "fullscreen";
    	self.currentperks.hidewheninmenu = 1;
    	self.currentperks.hidewhendeath = 1;
    	self.currentperks thread DestroyBefore();
    }
    
    self playlocalsound( "zmb_box_poof" );
    
    if(isdefined(perk)) {
    	self.perktext = newClientHudElem(self);
  	 	self.perktext.x = 320;
   	 	self.perktext.y = -50;  // 220;
   	 	self.perktext.alignx = "center";
    	self.perktext.aligny = "top";
   		self.perktext.color = (1, 1, 1);
    	self.perktext.alpha = 0.9;
    	self.perktext.sort = 80;
    	self.perktext.archived = false;
    	self.perktext.foreground = true;
    	self.perktext.fontscale = 1;
    	self.perktext.font = "bigfixed";
    	self.perktext.horzalign = "fullscreen";
    	self.perktext.vertalign = "fullscreen";
	    self.perktext.hidewheninmenu = 1;
	    self.perktext.hidewhendeath = 1;
   		self.perktext settext(getperkname(perk));
   		self.perktext thread DestroyBefore();
    
    	self.perktext thread FlashMe();
    }
    
    if(!isdefined(self.myperks))
    	self.myperks = [];
    	
    if(isdefined(perk))
    	self.myperks[self.myperks.size] = getperkname(perk);
    
    self.currentperkstitleshader setshader("white", 1, 12 * self.myperks.size);
    
    text = "";
    
    for(i = 0;i < self.myperks.size;i++)
    	text += self.myperks[i] + "\n";
    
    self.currentperks settext(text);
}

FlashMe() {
	self endon("death");
	
	self moveovertime(0.15);
	self.y = 75;
	wait 1.25;
	self moveovertime(0.15);
	self.y = -50;
	wait .2;
	self destroy();
}

getperkname(perk) {
	output = "";
	
	switch(perk) {
		case "specialty_armorvest":
			output = "Juggernog";
			break;
		case "specialty_quickrevive":
			output = "Quick Revive";
			break;
		case "specialty_rof":
			output = "Double Tab";
			break;
		case "specialty_fastreload":
			output = "Speed Cola";
			break;
		case "specialty_longersprint":
			output = "Stamin Up";
			break;
		case "deadshot":
			output = "Deadshot";
			break;
		case "Burn_Heart":
			output = "Burn Heart";
			break;
		case "WIDOWS_WINE":
			output = "Widows Wine";
			break;
		case "ELECTRIC_CHERRY":
			output = "Electric Cherry";
			break;
		case "Ethereal_Razor":
			output = "Ethereal Razor";
			break;
		case "MULE":
			output = "Mule Kick";
			break;
		case "PHD_FLOPPER":
			output = "PHD Flopper";
			break;
		case "Downers_Delight":
			output = "Downers Delight";
			break;
		case "Dying_Wish":
			output = "Dying Wish";
			break;
		case "Ammo_Regen":
			output = "Ammo Regen";
			break;
		case "Victorious_Tortoise":
			output = "Victorious Tortoise";
			break;
	}
	
	return output;
}

custom_get_player_weapon_limit( player ) {
    weapon_limit = 2;
    if ( isdefined(player.MULE) )
        weapon_limit = 3;
	else {
        weapons = self getWeaponsListPrimaries();
        if(weapons.size > 2)
            self takeWeapon(weapons[2]);
    }
    return weapon_limit;
}

LastStand() {
    if(isdefined(self.Downers_Delight)) {
        self.customlaststandweapon = self getcurrentweapon();
		self switchtoweapon( self.customlaststandweapon );
		self setweaponammoclip( self.customlaststandweapon, 150 );
		self.bleedout_time = 40;
    } 
	else 
        self maps/mp/zombies/_zm::last_stand_pistol_swap();
}

start_ec() {
	level endon("end_game");
	self endon("disconnect");
	self endon("stopcustomperk");
	for(;;) {
		self waittill( "reload_start" );
    	playfxontag( level._effect[ "poltergeist"], self, "J_SpineUpper" );
		self EnableInvulnerability();
		RadiusDamage(self.origin, 120, 200, 100, self);
		self DisableInvulnerability();
		self playsound( "zmb_turbine_explo" );
		wait 1;
	}
}

start_er() {
    level endon("end_game");
    self endon("disconnect");
    self endon("stopcustomperk");
    for(;;) {
        if( isdefined(self.Ethereal_Razor) && self ismeleeing()) {
            foreach(zombie in getAiArray(level.zombie_team)) {
                if( distance( self.origin, zombie.origin ) <= 100 ) {
					if(self is_insta_kill_active())
						zombie doDamage(zombie.maxhealth + 666, (0, 0, 0));
                    zombie dodamage(500, (0, 0, 0));
                    if(zombie.health <= 0) {
                        self maps/mp/zombies/_zm_score::add_to_player_score( 100 );
						self.kills++;
					} 
					else 
                        self maps/mp/zombies/_zm_score::add_to_player_score( 10 );
                } 
            }
            self.health += 20;
            if(self.health > self.maxhealth)
                self.health = self.maxhealth;
            while(self ismeleeing())
                wait .1;
        }
        wait .05;
    }
}

DDown() {
	self endon( "disconnect" );
	level endon( "end_game" );
	self endon( "stopcustomperk" );
	for(;;) {
		self waittill("player_downed");
		self playsound( "zmb_phdflop_explo" );
		playfx(loadfx("explosions/fx_default_explosion"), self.origin, anglestoforward( ( 0, 45, 55  ) ) ); 
		RadiusDamage(self.origin, 150, 600, 400, self);
		wait .1;
	}
}

ammoregen() {
	self endon( "disconnect" );
	level endon( "end_game" );
	self endon( "stopcustomperk" );
	for(;;) {
		if(!self GetCurrentWeapon() == "claymore_zm" && !is_grenade_launcher( self GetCurrentWeapon()) ) {
			stockcount = self getweaponammostock( self GetCurrentWeapon() );
			self setWeaponAmmostock( self GetCurrentWeapon(), stockcount + 1 );
			wait 2;
		}
		wait .1;
	}
}

ww_points( player ) {
    for(i = 0; i < 3; i++) {
		self maps/mp/zombies/_zm_utility::set_zombie_run_cycle("walk");
        player maps/mp/zombies/_zm_score::add_to_player_score( 10 );
        PlayFXOnTag(level.effect_WebFX,self,"j_spineupper");
        self doDamage(150, (0, 0, 0));
        wait 1;
    }
}

ww_nade_explosion() {
    wait 2;
    if( self object_touching_lava()) {
        self delete();
        return 0;
    }
	foreach(zombie in getAiArray(level.zombie_team)) {
        if( distance( zombie.origin, self.origin ) < 210 )
            zombie thread ww_points( self );
    }
    self delete();
}

ww_nades() {
    level endon("end_game");
    self endon("disconnect");
    self endon("stopcustomperk");
    for(;;) {
        self waittill( "grenade_fire", grenade, weapname );
        if( weapname == "sticky_grenade_zm" ) {
            ww_nade = spawnsm( grenade.origin, "zombie_bomb" );
            ww_nade hide();
            ww_nade linkto( grenade );
            ww_nade thread ww_nade_explosion();
        }
    }
}

spawnsm( origin, model, angles ) {
    ent = spawn( "script_model", origin );
    ent setmodel( model );
    if( IsDefined( angles ) )
        ent.angles = angles;
    return ent;
}


grenadesregen() {
	self endon( "disconnect" );
	level endon( "end_game" );
	self endon( "stopcustomperk" );
	for(;;) {
		grenades = self get_player_lethal_grenade();
        grenade_count = self getweaponammoclip(grenades);
        if(grenade_count < 4)
        	self setweaponammoclip(grenades, (grenade_count + 1));
		tactical_grenades = self get_player_tactical_grenade();
        tactical_grenade_count = self getweaponammoclip(tactical_grenades);
        if(tactical_grenade_count < 3 )
        	self setweaponammoclip(tactical_grenades, (tactical_grenade_count + 1));
		wait 300;
	}
}

dying_wish_checker() {
    level endon("end_game");
    self endon("disconnect");
    self endon( "stopcustomperk" );
    self.dying_wish_uses = 0;
    for(;;) {
        self.dying_wish_on_cooldown = 0;
        self.perk10back.alpha = 1;
        self.perk10front.alpha = 1;
        self waittill("dying_wish_charge");
        //self thread power_up_hud(0, 0, "Dying Wish Saved You!" );
        self.perk10back.alpha = 0.3;
        self.perk10front.alpha = 0.4;
        self.dying_wish_uses++;
        self.dying_wish_on_cooldown = 1;
        delay = 300 + (self.dying_wish_uses * 30);
        if(delay >= 600)
        	delay = 600;
        wait delay;
    }
}

dying_wish_effect() {
    self enableInvulnerability();
    self.ignoreme = 1;
    self useServerVisionSet(true);
    self setvisionsetforplayer( "zombie_death", 0 );
    self freezeControls(1);
    wait 1;
    self freezeControls(0);
    wait 8;
	self.health = 1;
    self disableInvulnerability();
    self.ignoreme = 0;
    self useServerVisionSet(false);
    self setvisionsetforplayer("remote_mortar_enhanced", 0);
}

damage_callback( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex ) {
    if( isDefined( eAttacker.is_zombie ) && eAttacker.is_zombie && isdefined(self.WIDOWS_WINE) ) {
		zombies = getaiarray(level.zombie_team);
        foreach(zombie in zombies) {
	   		if(distance(self.origin, zombie.origin) < 150) {
				grenades = self get_player_lethal_grenade();
            	grenade_count = self getweaponammoclip(grenades);
            	if(grenade_count > 0) {
					self PlaySound("zmb_elec_jib_zombie");
                	self setweaponammoclip(grenades, (grenade_count - 1));
					zombie thread ww_points( self );
				}
            }
		}
    }
	
	if(isdefined(self.PHD_FLOPPER)) {
        if( smeansofdeath == "MOD_FALLING" ) {
            if(isDefined( self.divetoprone ) && self.divetoprone == 1 ) {
                radiusdamage( self.origin, 300, 5000, 1000, self, "MOD_GRENADE_SPLASH" );
                playfx(loadfx("explosions/fx_default_explosion"), self.origin, anglestoforward( ( 0, 45, 55  ) ) ); 
                self playsound( "zmb_phdflop_explo" );
            }
            return 0;
        }
        if( smeansofdeath == "MOD_PROJECTILE" || smeansofdeath == "MOD_PROJECTILE_SPLASH" || smeansofdeath == "MOD_GRENADE" || smeansofdeath == "MOD_GRENADE_SPLASH" && eattacker == self)
            return 0;
    }
    
    if( isDefined( eAttacker.is_zombie ) && eAttacker.is_zombie && isdefined(self.Victorious_Tortoise )) {
        if(self getcurrentweapon() == "riotshield_zm" || self getcurrentweapon() == "alcatraz_shield_zm" || self getcurrentweapon() == "tomb_shield_zm") {
            shield_hp = 1500;
            if ( !isDefined( self.shielddamagetaken ) )
                self.shielddamagetaken = 0;
            self.shielddamagetaken += idamage;
            self playsound( "fly_riotshield_zm_impact_zombies" );
            if ( self.shielddamagetaken >= shield_hp ){
                if ( isDefined( self.stub ) )
                    thread maps/mp/zombies/_zm_unitrigger::unregister_unitrigger( self.stub );
                playsoundatposition( "wpn_riotshield_zm_destroy", self.origin );
                self notify("destroy_riotshield");
                if(getdvar( "mapname" ) == "zm_prison")
                    self maps/mp/zombies/_zm_equipment::equipment_take( "alcatraz_shield_zm" );
                if(getdvar( "mapname" ) == "zm_tomb")
                    self maps/mp/zombies/_zm_equipment::equipment_take( "tomb_shield_zm" );
                if(getdvar( "mapname" ) == "zm_transit")
                    self maps/mp/zombies/_zm_equipment::equipment_take( "riotshield_zm" );
                maps/mp/zombies/_zm_equipment::equipment_disappear_fx( self.origin, level._riotshield_dissapear_fx );
                self enableInvulnerability();
                wait 1;
                self disableInvulnerability();
            }
            else
                self deployed_set_shield_health( self.shielddamagetaken, damagemax );
            return 0;
        }
    }
	
	if(isdefined(self.has_cluster) && self.has_cluster && isdefined(eattacker) && eattacker == self)
        return 0;
	players = get_players();
	for(i=0;i<players.size;i++) {
		if(isdefined(players[i].firework_weapon) && eattacker == players[i].firework_weapon)
			return 0;
	}
	
	if(idamage > self.health && !self.dying_wish_on_cooldown && isdefined(self.Dying_Wish) ) {
        self notify("dying_wish_charge");
        self thread dying_wish_effect();
        return 0;
	}
	
    return idamage;
}

removeperkshader() {
    level endon( "end_game" );
    for(;;) {
        self waittill_any_return( "fake_death", "player_downed", "player_revived", "spawned_player", "disconnect", "death" );
        self.num_perks = 0;
        self.perk_reminder = 0;
        self.perk_count = 0;
        self.dying_wish_on_cooldown = 0;
        
        self.myperks = undefined;
        
        self notify( "stopcustomperk" );
        
        self.bleedout_time = 30;
        self.ignore_lava_damage = 0;
        
        if(isdefined(self.Downers_Delight))
    		self.Downers_Delight = undefined;
     	if(isdefined(self.MULE))
    		self.MULE = undefined;
    	if(isdefined(self.PHD_FLOPPER))
    		self.PHD_FLOPPER = undefined;
     	if(isdefined(self.Victorious_Tortoise))
    		self.Victorious_Tortoise = undefined;
    	if(isdefined(self.ELECTRIC_CHERRY))
    		self.ELECTRIC_CHERRY = undefined;
    	if(isdefined(self.WIDOWS_WINE))
    		self.WIDOWS_WINE = undefined;
   		if(isdefined(self.Ethereal_Razor))
   		 	self.Ethereal_Razor = undefined;
    	 if(isdefined(self.Ammo_Regen))
   	 		self.Ammo_Regen = undefined;
     	if(isdefined(self.Burn_Heart))
    		self.Burn_Heart = undefined;
    	if(isdefined(self.deadshot))
    		self.deadshot = undefined;
    	if(isdefined(self.Dying_Wish))
    		self.Dying_Wish = undefined;
        
        self setclientfieldtoplayer( "deadshot_perk", 0 );
        
        self perk_hud_create();
    }
}

WeaponHud() {
    self endon("disconnect");
    level endon("end_game");
    
    x = 620;

    self.Weaponnameline = newClientHudElem(self);
    self.Weaponnameline.x = x;
    self.Weaponnameline.y = 445;
    self.Weaponnameline.alignx = "RIGHT";
    self.Weaponnameline.aligny = "BOTTOM";
    self.Weaponnameline.horzalign = "fullscreen";
    self.Weaponnameline.vertalign = "fullscreen";
    self.Weaponnameline.alpha = 1;
    self.Weaponnameline.sort = 1;
    self.Weaponnameline.color = (0,0,0);
    self.Weaponnameline.archived = true;
    self.Weaponnameline.foreground = true;
    self.Weaponnameline.hidewheninmenu = 1;
    self.Weaponnameline setshader("black", 115, 1);
    self.Weaponnameline thread DestroyBefore();

    self.Weaponname = createfontstring("hudbig", 1.4);
    self.Weaponname.x = x - 20;
    self.Weaponname.y = 428;
    self.Weaponname.alignx = "RIGHT";
    self.Weaponname.aligny = "BOTTOM";
    self.Weaponname.color = (1, 1, 1);
    self.Weaponname.alpha = 1;
    self.Weaponname.archived = true;
    self.Weaponname.sort = 80;
    self.Weaponname.font = "hudbig";
    self.Weaponname.foreground = true;
    self.Weaponname.fontscale = 1.4;
    self.Weaponname.horzalign = "fullscreen";
    self.Weaponname.vertalign = "fullscreen";
    self.Weaponname.hidewheninmenu = 1;
    self.Weaponname.realx = x - 4;

    self.Weaponammostock = newClientHudElem(self);
    self.Weaponammostock.x = x - 4;
    self.Weaponammostock.y = 445;  // 220;
    self.Weaponammostock.alignx = "RIGHT";
    self.Weaponammostock.aligny = "BOTTOM";
    self.Weaponammostock.color = (1, 1, 1);
    self.Weaponammostock.alpha = 1;
    self.Weaponammostock.sort = 80;
    self.Weaponammostock.archived = true;
    self.Weaponammostock.foreground = true;
    self.Weaponammostock.fontscale = 1.8;
    self.Weaponammostock.font = "objective";
    self.Weaponammostock.horzalign = "fullscreen";
    self.Weaponammostock.vertalign = "fullscreen";
    self.Weaponammostock.hidewheninmenu = 1;// 15 -
    self.Weaponammostock thread DestroyBefore();
    
    self.Weaponammocllip = newClientHudElem(self);
    self.Weaponammocllip.x = self.Weaponammostock.x - 20;
    self.Weaponammocllip.y = 445;
    self.Weaponammocllip.alignx = "RIGHT";
    self.Weaponammocllip.aligny = "BOTTOM";
    self.Weaponammocllip.color = (1, 1, 1);
    self.Weaponammocllip.alpha = 1;
    self.Weaponammocllip.archived = true;
    self.Weaponammocllip.foreground = true;
    self.Weaponammocllip.font = "objective";
    self.Weaponammocllip.fontscale = 1.8;
    self.Weaponammocllip.horzalign = "fullscreen";
    self.Weaponammocllip.vertalign = "fullscreen";
    self.Weaponammocllip.hidewheninmenu = 1;
    self.Weaponammocllip thread DestroyBefore();

    self.Grenadeicon = newClientHudElem(self);
    self.Grenadeicon.x = x - 15;
    self.Grenadeicon.y = 450;  // 220;
    self.Grenadeicon.alignx = "RIGHT";
    self.Grenadeicon.aligny = "TOP";
    self.Grenadeicon.horzalign = "fullscreen";
    self.Grenadeicon.vertalign = "fullscreen";
    self.Grenadeicon.alpha = 0;
    self.Grenadeicon.sort = 10;
    self.Grenadeicon.color = (1, 1, 1);
    self.Grenadeicon.archived = true;
    self.Grenadeicon.foreground = false;
    self.Grenadeicon setshader("hud_grenadeicon", 13, 13);
    self.Grenadeicon.hidewheninmenu = 1;
    
    self.Grenadeicon2 = newClientHudElem(self);
    self.Grenadeicon2.x = x - 10;
    self.Grenadeicon2.y = 450;  // 220;
    self.Grenadeicon2.alignx = "RIGHT";
    self.Grenadeicon2.aligny = "TOP";
    self.Grenadeicon2.horzalign = "fullscreen";
    self.Grenadeicon2.vertalign = "fullscreen";
    self.Grenadeicon2.alpha = 0;
    self.Grenadeicon2.sort = 10;
    self.Grenadeicon2.color = (0.5, 0.5, 0.5);
    self.Grenadeicon2.archived = true;
    self.Grenadeicon2.foreground = false;
    self.Grenadeicon2 setshader("hud_grenadeicon", 13, 13);
    self.Grenadeicon2.hidewheninmenu = 1;
    
    self.Grenadeicon3 = newClientHudElem(self);
    self.Grenadeicon3.x = x - 5;
    self.Grenadeicon3.y = 450;  // 220;
    self.Grenadeicon3.alignx = "RIGHT";
    self.Grenadeicon3.aligny = "TOP";
    self.Grenadeicon3.horzalign = "fullscreen";
    self.Grenadeicon3.vertalign = "fullscreen";
    self.Grenadeicon3.alpha = 0;
    self.Grenadeicon3.sort = 10;
    self.Grenadeicon3.color = (0.5, 0.5, 0.5);
    self.Grenadeicon3.archived = true;
    self.Grenadeicon3.foreground = false;
    self.Grenadeicon3 setshader("hud_grenadeicon", 13, 13);
    self.Grenadeicon3.hidewheninmenu = 1;
    
    self.Grenadeicon4 = newClientHudElem(self);
    self.Grenadeicon4.x = x;
    self.Grenadeicon4.y = 450;  // 220;
    self.Grenadeicon4.alignx = "RIGHT";
    self.Grenadeicon4.aligny = "TOP";
    self.Grenadeicon4.horzalign = "fullscreen";
    self.Grenadeicon4.vertalign = "fullscreen";
    self.Grenadeicon4.alpha = 0;
    self.Grenadeicon4.sort = 10;
    self.Grenadeicon4.color = (0.5, 0.5, 0.5);
    self.Grenadeicon4.archived = true;
    self.Grenadeicon4.foreground = false;
    self.Grenadeicon4 setshader("hud_grenadeicon", 13, 13);
    self.Grenadeicon4.hidewheninmenu = 1;

    self.Secondayicon1 = newClientHudElem(self);
    self.Secondayicon1.x = x - 40;
    self.Secondayicon1.y = 450;  // 220;
    self.Secondayicon1.alignx = "RIGHT";
    self.Secondayicon1.aligny = "TOP";
    self.Secondayicon1.horzalign = "fullscreen";
    self.Secondayicon1.vertalign = "fullscreen";
    self.Secondayicon1.alpha = 0;
    self.Secondayicon1.sort = 10;
    self.Secondayicon1.color = (1, 1, 1);
    self.Secondayicon1.archived = true;
    self.Secondayicon1.foreground = true;
    self.Secondayicon1.hidewheninmenu = 1;
    self.Secondayicon1 thread DestroyBefore();
    
    self.Secondayicon2 = newClientHudElem(self);
    self.Secondayicon2.x = x - 35;
    self.Secondayicon2.y = 450;  // 220;
    self.Secondayicon2.alignx = "RIGHT";
    self.Secondayicon2.aligny = "TOP";
    self.Secondayicon2.horzalign = "fullscreen";
    self.Secondayicon2.vertalign = "fullscreen";
    self.Secondayicon2.alpha = 0;
    self.Secondayicon2.sort = 10;
    self.Secondayicon2.color = (0.5, 0.5, 0.5);
    self.Secondayicon2.archived = true;
    self.Secondayicon2.foreground = true;
    self.Secondayicon2.hidewheninmenu = 1;
    self.Secondayicon2 thread DestroyBefore();
    
    self.Secondayicon3 = newClientHudElem(self);
    self.Secondayicon3.x = x - 30;
    self.Secondayicon3.y = 450;  // 220;
    self.Secondayicon3.alignx = "RIGHT";
    self.Secondayicon3.aligny = "TOP";
    self.Secondayicon3.horzalign = "fullscreen";
    self.Secondayicon3.vertalign = "fullscreen";
    self.Secondayicon3.alpha = 0;
    self.Secondayicon3.sort = 10;
    self.Secondayicon3.color = (0.5, 0.5, 0.5);
    self.Secondayicon3.archived = true;
    self.Secondayicon3.foreground = true;
    self.Secondayicon3.hidewheninmenu = 1;
    self.Secondayicon3 thread DestroyBefore();
    
    self.WeaponAmmoTextNew = newClientHudElem(self);
    self.WeaponAmmoTextNew.x = x - 40;
    self.WeaponAmmoTextNew.y = 435;
    self.WeaponAmmoTextNew.alignx = "RIGHT";
    self.WeaponAmmoTextNew.aligny = "MIDDLE";
    self.WeaponAmmoTextNew.color = (1, 1, 1);
    self.WeaponAmmoTextNew.alpha = 1;
    self.WeaponAmmoTextNew.archived = true;
    self.WeaponAmmoTextNew.sort = 1;
    self.WeaponAmmoTextNew.fontscale = 1;
    self.WeaponAmmoTextNew.horzalign = "fullscreen";
    self.WeaponAmmoTextNew.vertalign = "fullscreen";
    self.WeaponAmmoTextNew.hidewheninmenu = 1;
    self.WeaponAmmoTextNew thread DestroyBefore();
    
    self.WeaponAmmoTextNew2 = newClientHudElem(self);
    self.WeaponAmmoTextNew2.x = x - 40;
    self.WeaponAmmoTextNew2.y = 425;
    self.WeaponAmmoTextNew2.alignx = "RIGHT";
    self.WeaponAmmoTextNew2.aligny = "MIDDLE";
    self.WeaponAmmoTextNew2.color = (1, 1, 1);
    self.WeaponAmmoTextNew2.alpha = 0;
    self.WeaponAmmoTextNew2.archived = true;
    self.WeaponAmmoTextNew2.sort = 1;
    self.WeaponAmmoTextNew2.fontscale = 1;
    self.WeaponAmmoTextNew2.horzalign = "fullscreen";
    self.WeaponAmmoTextNew2.vertalign = "fullscreen";
    self.WeaponAmmoTextNew2.hidewheninmenu = 1;
    self.WeaponAmmoTextNew2 thread DestroyBefore();
    
    while (1) {
        weapon = get_base_name(self getcurrentweapon());
        
        weaponname = self get_real_name(weapon);
        if(weaponname != "none") {
       		self.Weaponname.alpha = 1;
        	self.Weaponammostock.alpha = 1;
        	self.Weaponammocllip.alpha = 1;
        	self.WeaponAmmoTextNew2.alpha = 1;
        	self.WeaponAmmoTextNew.alpha = 1;
        	self.Weaponname.x = self.Weaponname.x - 20;
        	self.Weaponname settext(weaponname);
        	self.Weaponname moveOverTime(.1);
        	self.Weaponname.x = self.Weaponname.realx;
        }
        else {
        	self.Weaponammostock.alpha = 0;
        	self.Weaponammocllip.alpha = 0;
        	self.Weaponname.alpha = 0;
        	self.WeaponAmmoTextNew2.alpha = 0;
        	self.WeaponAmmoTextNew.alpha = 0;
        }
        self waittill("weapon_change");
    }
}

monitor_buildables() {
	level endon("end_game");
    self endon("disconnect");
    
	self.players_buildable_part = self createicon("", 20, 20);
	self.players_buildable_part.x = -23;
	self.players_buildable_part.y = -100;
	self.players_buildable_part.alignx = "CENTER";
	self.players_buildable_part.aligny = "BOTTOM";
	self.players_buildable_part.color = (1,1,1);
	self.players_buildable_part.alpha = 1;
	self.players_buildable_part.archived = false;
	self.players_buildable_part.sort = 80;
	self.players_buildable_part.foreground = true;
	self.players_buildable_part.hidewheninmenu = true;
	self.players_buildable_part.fontscale = 1;
	self.players_buildable_part.horzalign = "USER_RIGHT";
	self.players_buildable_part.vertalign = "USER_BOTTOM";
	self.players_buildable_part.shader = "";
	self.players_buildable_part thread DestroyBefore();

	self.players_shield_shader = self createicon("", 20, 20);
	self.players_shield_shader.x = -23;
	self.players_shield_shader.y = -70;
	self.players_shield_shader.alignx = "CENTER";
	self.players_shield_shader.aligny = "BOTTOM";
	self.players_shield_shader.color = (1,1,1);
	self.players_shield_shader.alpha = 1;
	self.players_shield_shader.archived = false;
	self.players_shield_shader.sort = 80;
	self.players_shield_shader.foreground = true;
	self.players_shield_shader.hidewheninmenu = true;
	self.players_shield_shader.fontscale = 1;
	self.players_shield_shader.horzalign = "USER_RIGHT";
	self.players_shield_shader.vertalign = "USER_BOTTOM";
	self.players_shield_shader.shader = "";
	self.players_shield_shader thread DestroyBefore();
	for ( ;; )
	{
		if(self hasweapon("riotshield_zm"))
		{
			if(self.players_shield_shader.shader != "riotshield_zm_icon")
			{
				self.players_shield_shader setshader("riotshield_zm_icon", 20, 20);
				self.players_shield_shader.shader = "riotshield_zm_icon";
			}
		}
		else if(self hasweapon("alcatraz_shield_zm"))
		{
			if(self.players_shield_shader.shader != "zm_riotshield_hellcatraz_icon")
			{
				self.players_shield_shader setshader("zm_riotshield_hellcatraz_icon", 20, 20);
				self.players_shield_shader.shader = "zm_riotshield_hellcatraz_icon";
			}
		}
		else if(self hasweapon("tomb_shield_zm"))
		{
			if(self.players_shield_shader.shader != "riotshield_zm_icon")
			{
				self.players_shield_shader setshader("riotshield_zm_icon", 20, 20);
				self.players_shield_shader.shader = "riotshield_zm_icon";
			}
		}
		else
		{
			if(self.players_shield_shader.shader != "")
			{
				self.players_shield_shader setshader("", 20, 20);
				self.players_shield_shader.shader = "";
			}
		}
		if(isdefined(self.current_buildable_pieces) && isdefined(self.current_buildable_pieces[0]))
		{
			if(self.players_buildable_part.shader != self.current_buildable_pieces[0].hud_icon)
			{
				self.players_buildable_part setshader(self.current_buildable_pieces[0].hud_icon, 20, 20);
				self.players_buildable_part.shader = self.current_buildable_pieces[0].hud_icon;
			}
		}
		else if(isdefined(self.current_buildable_pieces) && isdefined(self.current_buildable_pieces[1]))
		{
			if(self.players_buildable_part.shader != self.current_buildable_pieces[1].hud_icon)
			{
				self.players_buildable_part setshader(self.current_buildable_pieces[1].hud_icon, 20, 20);
				self.players_buildable_part.shader = self.current_buildable_pieces[1].hud_icon;
			}
		}
		else if(isdefined(self.current_buildable_pieces) && isdefined(self.current_buildable_pieces[2]))
		{
			if(self.players_buildable_part.shader != self.current_buildable_pieces[2].hud_icon)
			{
				self.players_buildable_part setshader(self.current_buildable_pieces[2].hud_icon, 20, 20);
				self.players_buildable_part.shader = self.current_buildable_pieces[2].hud_icon;
			}
		}
		else
		{
			if(self.players_buildable_part.shader != "")
			{
				self.players_buildable_part setshader("", 20, 20);
				self.players_buildable_part.shader = "";
			}
		}
		wait .1;
	}
}

HealthBar() {
    level endon("end_game");
    self endon("death");
    self endon("disconnect");
    flag_wait("initial_blackscreen_passed");
    
	self thread monitor_buildables();
	
    x = 20;
    y = 443;
    base_width = 65;
    base_height = 2;
    init_width = base_width * (self.maxhealth / 250);

    self.health_bar = newClientHudElem(self);
    self.health_bar.x = x + 1;
    self.health_bar.y = y + 1;
    self.health_bar.alignx = "left";
    self.health_bar.aligny = "bottom";
    self.health_bar.horzalign = "fullscreen";
    self.health_bar.vertalign = "fullscreen";
    self.health_bar.alpha = 1;
    self.health_bar.sort = 1;
    self.health_bar.archived = true;
    self.health_bar.foreground = true;
    self.health_bar.hidewheninmenu = true;
    self.health_bar setshader("progress_bar_fill", init_width, base_height);
    self.health_bar thread DestroyBefore();

    self.health_text = self createFontString("default", 1);
    self.health_text.x = x + base_width + 5;
    self.health_text.y = y + 3;
    self.health_text.alignx = "left";
    self.health_text.aligny = "bottom";
    self.health_text.horzalign = "fullscreen";
    self.health_text.vertalign = "fullscreen";
    self.health_text.alpha = 1;
    self.health_text.archived = true;
    self.health_text.foreground = true;
    self.health_text.hidewheninmenu = true;
    self.health_text thread DestroyBefore();
    
    self.namehud = self createFontString("objective", 1.05);
    self.namehud.x = 22;
    self.namehud.y = 460;
    self.namehud.alignx = "left";
    self.namehud.aligny = "bottom";
    self.namehud.horzalign = "fullscreen";
    self.namehud.vertalign = "fullscreen";
    self.namehud.alpha = 1;
    self.namehud.color = (1, 1, 1);
    self.namehud.archived = true;
    self.namehud.foreground = true;
    self.namehud.hidewheninmenu = true;
    self.namehud settext(self.realname);
    self.namehud thread DestroyBefore();

    self.scorenumberValue = self createFontString("objective", 1.3);
    self.scorenumberValue.x = 22;
    self.scorenumberValue.y = 440;
    self.scorenumberValue.alignx = "left";
    self.scorenumberValue.aligny = "bottom";
    self.scorenumberValue.horzalign = "fullscreen";
    self.scorenumberValue.vertalign = "fullscreen";
    self.scorenumberValue.alpha = 1;
    self.scorenumberValue.color = (1, 1, 1);
    self.scorenumberValue.glowalpha = 1;
    self.scorenumberValue.glowcolor = level.ui_better_red;
    self.scorenumberValue.archived = true;
    self.scorenumberValue.foreground = true;
    self.scorenumberValue.hidewheninmenu = true;
    self.scorenumberValue.hidewhendead = true;
    self.scorenumberValue.label = &"$ ";
    self.scorenumberValue thread DestroyBefore();

    self.ScoreNumberGained = self createFontString("objective", 1);
    self.ScoreNumberGained.x = 22;
    self.ScoreNumberGained.y = 425;
    self.ScoreNumberGained.alignx = "left";
    self.ScoreNumberGained.aligny = "bottom";
    self.ScoreNumberGained.horzalign = "fullscreen";
    self.ScoreNumberGained.vertalign = "fullscreen";
    self.ScoreNumberGained.alpha = 0;
    self.ScoreNumberGained.color = (1, 1, 1);
    self.ScoreNumberGained.glowalpha = 1;
    self.ScoreNumberGained.glowcolor = (0,1,0);
    self.ScoreNumberGained.archived = true;
    self.ScoreNumberGained.foreground = true;
    self.ScoreNumberGained.hidewheninmenu = true;
    self.ScoreNumberGained.label = &"$ ";
    self.ScoreNumberGained thread DestroyBefore();
    
    self.Test = newClientHudElem(self);
    self.Test.x = 15;
    self.Test.y = 418;
    self.Test.alignx = "left";
    self.Test.aligny = "center";
    self.Test.horzalign = "fullscreen";
    self.Test.vertalign = "fullscreen";
    self.Test.alpha = 1;
    self.Test.archived = true;
    self.Test.color = (0,0,0);
    self.Test.foreground = false;
    self.Test.hidewheninmenu = 1;
    self.Test setshader("line_vertical", 85, 50);
    self.Test thread DestroyBefore();

    if (!isDefined(self.maxhealth) || self.maxhealth <= 0)
        self.maxhealth = 100;

    while (1) {
        if (level.intermission) {
            self.health_bar destroy();
            self.health_text destroy();
            break;
        }
        downed = self player_is_in_laststand();
        low_health = self.health < 75;

        if (downed || low_health)
            color = level.ui_better_red_bright;
        else
            color = (1, 1, 1);
       
        width = (self.health / self.maxhealth) * base_width * (250 / 250);
        width = downed ? 1 : int(max(width, 1));

        if (color == level.ui_better_red_bright) {
            self.health_bar.color = color;
            self.health_bar setShader("white", width, base_height);
        }
        else {
            self.health_bar.color = (1, 1, 1);
            self.health_bar setShader("white", width, base_height);
        }

        self.health_text.color = color;
        self.health_text setValue(downed ? 1 : self.health);
        wait .05;
    }
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
    self.hitmarker thread DestroyBefore();

    while (true) {
        foreach(zombie in get_round_enemy_array())  // TODO Test: for manually spawned enemies
            if (!isDefined(zombie.await_damage))
                zombie thread show_hitmarker();
        wait 1;
    }
}

upgrade_crosshair() {
    self setclientdvar("cg_cursorHints", 1);
    self setclientdvar("cg_crosshairAlphaMin", 0);
    self set_crossdot();
    self thread highlight_crossdot();
}

set_crossdot() {
    self endon("disconnect");

    self.crossdot = newclienthudelem(self);
    self.crossdot.horzalign = "center";
    self.crossdot.alignx = "center";
    self.crossdot.vertalign = "middle";
    self.crossdot.aligny = "middle";
    self.crossdot.foreground = true;
    self.crossdot.hidewheninmenu = true;
    self.crossdot.sort = 1;
    self.crossdot.hidden = false;
    self.crossdot.color = (.8, .8, .8);
    self.crossdot thread DestroyBefore();

    self.crossdot_frame = newclienthudelem(self);
    self.crossdot_frame.horzalign = "center";
    self.crossdot_frame.alignx = "center";
    self.crossdot_frame.vertalign = "middle";
    self.crossdot_frame.aligny = "middle";
    self.crossdot_frame.foreground = true;
    self.crossdot_frame.hidewheninmenu = true;
    self.crossdot_frame.hidden = false;
    self.crossdot_frame.color = (.125, .125, .125);
    self.crossdot_frame thread DestroyBefore();

    flag_wait("initial_blackscreen_passed");

    self.crossdot_frame setshader("menu_mp_lobby_frame_circle", 4, 4);
    self.crossdot setshader("menu_mp_lobby_frame_circle", 2, 2);
    self thread ads_crossdot();
}

highlight_crossdot() {
    self endon("disconnect");
    level endon("end_game");

    base_color = self.crossdot.color;
    base_frame_color = self.crossdot_frame.color;
    scale = 100000;

    while (true) {
        wait .05;

        eye = self get_eye();
        vector = anglestoforward(self getplayerangles());
        direction_vector = (vector[0] * scale, vector[1] * scale, vector[2] * scale);
        trace = bullettrace(eye, eye + direction_vector, true, self);
        self.crossdot.color = base_color;
        self.crossdot_frame.color = base_frame_color;

        if (!isdefined(trace["entity"]))
            continue;

        if (isplayer(trace["entity"])) {
            self.crossdot.color = (.38, .68, .38);  // TODO: color blind (.34, .98, 97)
            self.crossdot_frame.color = (0, 0, 0);
        }

        if (trace["entity"] is_zombie() && isalive(trace["entity"]) && !isDefined(trace["entity"].nuked)) {
            self.crossdot.color = (.97, .31, .34);  // TODO: color blind (.97, .5, 0)
            self.crossdot_frame.color = (0, 0, 0);
        }
    }
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

        // hide crossdot on hit
        attacker.crossdot.alpha = 0;
        attacker.crossdot.hidden = true;
        attacker.crossdot_frame.alpha = 0;
        attacker.crossdot_frame.hidden = true;

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

            // crossdot reset
            attacker.crossdot fadeovertime(.35);
            attacker.crossdot.alpha = 1;
            attacker.crossdot.hidden = false;
            attacker.crossdot_frame fadeovertime(.35);
            attacker.crossdot_frame.alpha = 1;
            attacker.crossdot_frame.hidden = false;
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

            // crossdot reset
            attacker.crossdot fadeovertime(.35);
            attacker.crossdot.alpha = 1;
            attacker.crossdot.hidden = false;
            attacker.crossdot_frame fadeovertime(.35);
            attacker.crossdot_frame.alpha = 1;
            attacker.crossdot_frame.hidden = false;

            scale_up = init_scale_up;
            self notify("killed_zombie");
        }
    }
}

EmpHudWatcher() {
	self endon("disconnect");
	
	self.iconsize = 13;
	self.SecondaryShader = "";
	self.SecondaryGrenades = 0;
	SecondaryAmount = 0;
	
	while(1) {
		wait .2;
		if (self hasweapon("emp_grenade_zm") && isdefined(self.Secondayicon1)) {
			if (self.SecondaryShader != "hud_empgrenade") {
				self.Secondayicon1 setshader("hud_empgrenade", self.iconsize, self.iconsize);
				self.Secondayicon2 setshader("hud_empgrenade", self.iconsize, self.iconsize);
				self.Secondayicon3 setshader("hud_empgrenade", self.iconsize, self.iconsize);
				self.SecondaryShader = "hud_empgrenade";
			}
			SecondaryAmount = self getweaponammoclip("emp_grenade_zm");
			if(self.SecondaryGrenades != SecondaryAmount) {
				self.SecondaryGrenades = SecondaryAmount;
				if(SecondaryAmount == 2) {
					a = 1;
					b = 1;
					c = 0;
					
					self.Secondayicon2.color = (0.5,0.5,0.5);
					self.Secondayicon1.color = (1,1,1);
				}
				else if(SecondaryAmount == 1) {
					a = 0;
					b = 1;
					c = 0;
				
					self.Secondayicon2.color = (1,1,1);
					self.Secondayicon1.color = (0.5,0.5,0.5);
				}
				else {
					a = 0;
					b = 0;
					c = 0;
				}
				
				if(isdefined(a)) {
					self.Secondayicon2.alpha = b;
					self.Secondayicon1.alpha = a;
					self.Secondayicon3.alpha = c;
				}
			}
		}
		else if (self hasweapon("cymbal_monkey_zm") && isdefined(self.Secondayicon1)) {
			if (self.SecondaryShader != "hud_cymbal_monkey") {
				self.Secondayicon1 setshader("hud_cymbal_monkey", self.iconsize, self.iconsize);
				self.Secondayicon2 setshader("hud_cymbal_monkey", self.iconsize, self.iconsize);
				self.Secondayicon3 setshader("hud_cymbal_monkey", self.iconsize, self.iconsize);
				self.SecondaryShader = "hud_cymbal_monkey";
			}
			SecondaryAmount = self getweaponammoclip("cymbal_monkey_zm");
			
			if(self.SecondaryGrenades != SecondaryAmount) {
				self.SecondaryGrenades = SecondaryAmount;
				
				if(SecondaryAmount == 3) {
					a = 1;
					b = 1;
					c = 1;
					
					self.Secondayicon3.color = (0.5,0.5,0.5);
					self.Secondayicon2.color = (0.5,0.5,0.5);
					self.Secondayicon1.color = (1,1,1);
				}
				else if(SecondaryAmount == 2) {
					a = 0;
					b = 1;
					c = 1;
					
					self.Secondayicon3.color = (0.5,0.5,0.5);
					self.Secondayicon2.color = (1,1,1);
					self.Secondayicon1.color = (1,1,1);
				}
				else if(SecondaryAmount == 1) {
					a = 0;
					b = 0;
					c = 1;
					
					self.Secondayicon3.color = (1,1,1);
					self.Secondayicon1.color = (0.5,0.5,0.5);
					self.Secondayicon2.color = (0.5,0.5,0.5);
				}
				else {
					a = 0;
					b = 0;
					c = 0;
				}
				
				if(isdefined(a)) {
					self.Secondayicon2.alpha = b;
					self.Secondayicon1.alpha = a;
					self.Secondayicon3.alpha = c;
				}
			}
		}
		else if(self hasweapon("claymore_zm") ) {
			ThirdAmount = self getweaponammoclip("claymore_zm");
			
        	if(!isdefined(self.ClaymoreIcon)) {
        		self.ClaymoreIcon = newClientHudElem(self);
    			self.ClaymoreIcon.x = 570;
    			self.ClaymoreIcon.y = 450;
   				self.ClaymoreIcon.alignx = "RIGHT";
    			self.ClaymoreIcon.aligny = "TOP";
   				self.ClaymoreIcon.color = (1, 1, 1);
    			self.ClaymoreIcon.alpha = 1;
    			self.ClaymoreIcon.archived = false;
    			self.ClaymoreIcon.sort = 1;
    			self.ClaymoreIcon.horzalign = "fullscreen";
    			self.ClaymoreIcon.vertalign = "fullscreen";
    			self.ClaymoreIcon.hidewheninmenu = 1;
    			self.ClaymoreIcon setshader("hud_icon_claymore_256", self.iconsize + 3, self.iconsize + 3);
    			self.ClaymoreIcon thread DestroyBefore();
    			
    			self iprintlnbold("Press ^8[{+actionslot 4}] ^7To Use ^8Claymores^7!");
        	}
        	
        	if(ThirdAmount > 0 && self.ClaymoreIcon.alpha != 1)
        		self.ClaymoreIcon.alpha = 1;
        	else if(ThirdAmount < 1 && self.ClaymoreIcon.alpha != 0)
        		self.ClaymoreIcon.alpha = 0;
        }
	}
}

WeaponNewAmmoHud() {
	self endon("disconnect");
	
	while(1) {
		wait .05;
		weapon = self getcurrentweapon();
		clipcount = self getweaponammoclip(weapon);
		
		if(weaponClipSize(weapon) <= 20) {
			output = "";
			
			for(i = 0;i < clipcount;i++) 
				output += "| ";
			self.WeaponAmmoTextNew settext(output);
			self.WeaponAmmoTextNew2.alpha = 0;
		}
		else if(weaponClipSize(weapon) >= 50) {
			output = "";
			output2 = "";
			
			for(i = 0;i < clipcount;i++) {
				if(i < 100) {
					if(i >= 50)
						output2 += "|";
					else
						output += "|";
				}
			}
			
			self.WeaponAmmoTextNew settext(output);
			self.WeaponAmmoTextNew2.alpha = 1;
			self.WeaponAmmoTextNew2 settext(output2);
		}
		else {
			output = "";
			for(i = 0;i < clipcount;i++) 
				output += "|";
			self.WeaponAmmoTextNew settext(output);
			self.WeaponAmmoTextNew2.alpha = 0;
		}
	}
}

TrackAmmoStuff() {
	self endon("disconnect");
	self thread ChangeColorText();
	self thread EmpHudWatcher();
	self thread WeaponNewAmmoHud();
	
	self.iconsize = 13;
	self.SecondaryShader = "";
	self.SecondaryGrenades = 0;
	
	while (1) {
		wait .05;
		if(self.score != 1000000) 
			self.scorenumberValue setvalue(self.score);
		else
			self.scorenumberValue settext("1000000");
		
		weapon = self getcurrentweapon();
		if(weapon != "slowgun_zm" && weapon != "slowgun_upgraded_zm" && weapon != "jetgun_zm") {
			clipcount = self getweaponammoclip(weapon);
			self.Weaponammocllip setvalue(clipcount);
			self.Weaponammostock setvalue(self getweaponammostock(weapon));
			if(self.Weaponammocllip.alpha != 1)
				self.Weaponammocllip.alpha = 1;
		}
		else {
			self.Weaponammostock setvalue(int(self isweaponoverheating(1, self getcurrentweapon())));
			if(self.Weaponammocllip.alpha != 0)
				self.Weaponammocllip.alpha = 0;
		}
		
		grenades = self getweaponammoclip(self get_player_lethal_grenade());
		
		if(isdefined(grenades) && grenades == 0) {
			a = 0;
			b = 0;
			c = 0;
			d = 0;
		}
		else if(isdefined(grenades) && grenades == 1) {
			a = 0;
			b = 0;
			c = 0;
			d = 1;
			
			self.Grenadeicon.color = (0.5,0.5,0.5);
			self.Grenadeicon2.color = (0.5,0.5,0.5);
			self.Grenadeicon3.color = (0.5,0.5,0.5);
			self.Grenadeicon4.color = (1,1,1);
		}
		else if(isdefined(grenades) && grenades == 2) {
			a = 0;
			b = 0;
			c = 1;
			d = 1;
			
			self.Grenadeicon.color = (0.5,0.5,0.5);
			self.Grenadeicon2.color = (0.5,0.5,0.5);
			self.Grenadeicon4.color = (0.5,0.5,0.5);
			self.Grenadeicon3.color = (1,1,1);
		}
		else if(isdefined(grenades) && grenades == 3) {
			a = 0;
			b = 1;
			c = 1;
			d = 1;
			
			self.Grenadeicon.color = (0.5,0.5,0.5);
			self.Grenadeicon3.color = (0.5,0.5,0.5);
			self.Grenadeicon4.color = (0.5,0.5,0.5);
			self.Grenadeicon2.color = (1,1,1);
		}
		else if(isdefined(grenades) && grenades == 4) {
			a = 1;
			b = 1;
			c = 1;
			d = 1;
			
			self.Grenadeicon2.color = (0.5,0.5,0.5);
			self.Grenadeicon3.color = (0.5,0.5,0.5);
			self.Grenadeicon4.color = (0.5,0.5,0.5);
			self.Grenadeicon.color = (1,1,1);
		}
		
		if(isdefined(a)) {
			self.Grenadeicon.alpha = a;
			self.Grenadeicon2.alpha = b;
			self.Grenadeicon3.alpha = c;
			self.Grenadeicon4.alpha = d;
		}
		
		if (self hasweapon("sticky_grenade_zm") && isdefined(self.Grenadeicon)) {
			if (self.Grenadeicon.shader != "hud_icon_sticky_grenade") {
				self.Grenadeicon setshader("hud_icon_sticky_grenade", self.iconsize, self.iconsize);
				self.Grenadeicon2 setshader("hud_icon_sticky_grenade", self.iconsize, self.iconsize);
				self.Grenadeicon3 setshader("hud_icon_sticky_grenade", self.iconsize, self.iconsize);
				self.Grenadeicon4 setshader("hud_icon_sticky_grenade", self.iconsize, self.iconsize);
			}
		}
		else if (self hasweapon("frag_grenade_zm") && isdefined(self.Grenadeicon)) {
			if (self.Grenadeicon.shader != "hud_grenadeicon") {
				self.Grenadeicon setshader("hud_grenadeicon", self.iconsize, self.iconsize);
				self.Grenadeicon2 setshader("hud_grenadeicon", self.iconsize, self.iconsize);
				self.Grenadeicon3 setshader("hud_grenadeicon", self.iconsize, self.iconsize);
				self.Grenadeicon4 setshader("hud_grenadeicon", self.iconsize, self.iconsize);
			}
		}
	}
}

get_real_name(weap) {
	if(weap == "raygun_mark2_zm")
		Weaponname = &"ZMWEAPON_RAYGUN_MARK2";
	else if(weap == "jetgun_zm")
		Weaponname = &"ZMWEAPON_JETGUN";
	else if(weap == "riotshield_zm")
		Weaponname = &"ZMWEAPON_RIOTSHIELD";
	else if(weap == "slipgun_zm")
		Weaponname = &"ZMWEAPON_SLIPGUN";
	else if(weap == "tazer_knuckles_zm")
		Weaponname = &"ZMWEAPON_TAZER";
	else if(weap == "knife_ballistic_no_melee_zm")
		Weaponname = &"WEAPON_KNIFE_BALLISTIC";
	else if(weap == "knife_ballistic_bowie_zm")
		Weaponname = &"WEAPON_KNIFE_BALLISTIC";
	else if(weap == "knife_ballistic_zm")
		Weaponname = &"WEAPON_KNIFE_BALLISTIC";
	else if(weap == "ray_gun_zm")
		Weaponname = &"WEAPON_RAY_GUN";
	else if(weap == "cymbal_monkey_zm")
		Weaponname = &"ZOMBIE_CYMBAL_MONKEY";
	else if(weap == "an94_zm")
		Weaponname = &"WEAPON_AN94";
	else if(weap == "m32_zm")
		Weaponname = &"WEAPON_M32";
	else if(weap == "usrpg_zm")
		Weaponname = &"WEAPON_USRPG";
	else if(weap == "claymore_zm")
		Weaponname = &"WEAPON_CLAYMORE";
	else if(weap == "sticky_grenade_zm")
		Weaponname = &"WEAPON_STICKY_GRENADE";
	else if(weap == "frag_grenade_zm")
		Weaponname = &"WEAPON_M2FRAGGRENADE";
	else if(weap == "hamr_zm")
		Weaponname = &"WEAPON_HAMR";
	else if(weap == "rpd_zm")
		Weaponname = &"WEAPON_RPD";
	else if(weap == "svu_zm")
		Weaponname = &"WEAPON_SVU";
	else if(weap == "barretm82_zm")
		Weaponname = &"WEAPON_BARRETM82";
	else if(weap == "dsr50_zm")
		Weaponname = &"WEAPON_DSR50";
	else if(weap == "fnfal_zm")
		Weaponname = &"ZMWEAPON_FNFAL";
	else if(weap == "galil_zm")
		Weaponname = &"WEAPON_GALIL";
	else if(weap == "tar21_zm")
		Weaponname = &"WEAPON_TAR21";
	else if(weap == "type95_zm")
		Weaponname = &"WEAPON_TYPE95";
	else if(weap == "xm8_zm")
		Weaponname = &"WEAPON_XM8";
	else if(weap == "m16_zm")
		Weaponname = &"WEAPON_M16";
	else if(weap == "saritch_zm")
		Weaponname = &"WEAPON_SARITCH";
	else if(weap == "m14_zm")
		Weaponname = &"WEAPON_M14";
	else if(weap == "srm1216_zm")
		Weaponname = &"WEAPON_SRM1216";
	else if(weap == "saiga12_zm")
		Weaponname = &"WEAPON_SAIGA12";
	else if(weap == "rottweil72_zm")
		Weaponname = &"WEAPON_ROTTWEIL72";
	else if(weap == "870mcs_zm")
		Weaponname = &"WEAPON_870MCS";
	else if(weap == "pdw57_zm")
		Weaponname = &"WEAPON_PDW57";
	else if(weap == "qcw05_zm")
		Weaponname = &"WEAPON_QCW05";
	else if(weap == "mp5k_zm")
		Weaponname = &"WEAPON_MP5K";
	else if(weap == "ak74u_zm")
		Weaponname = &"WEAPON_AK74U";
	else if(weap == "fivesevendw_zm")
		Weaponname = &"WEAPON_FIVESEVEN_DW";
	else if(weap == "beretta93r_zm")
		Weaponname = &"WEAPON_BERETTA93R";
	else if(weap == "fiveseven_zm")
		Weaponname = &"WEAPON_FIVESEVEN";
	else if(weap == "kard_zm")
		Weaponname = &"WEAPON_KARD";
	else if(weap == "judge_zm")
		Weaponname = &"WEAPON_JUDGE";
	else if(weap == "python_zm")
		Weaponname = &"WEAPON_PYTHON";
	else if(weap == "m1911_zm")
		Weaponname = &"WEAPON_M1911";
	else if(weap == "raygun_mark2_upgraded_zm")
		Weaponname = &"ZMWEAPON_RAYGUN_MARK2_UPGRADED";
	else if(weap == "knife_ballistic_no_melee_upgraded_zm")
		Weaponname = &"ZOMBIE_KNIFE_BALLISTIC_UPGRADED";
	else if(weap == "knife_ballistic_bowie_upgraded_zm")
		Weaponname = &"ZOMBIE_KNIFE_BALLISTIC_UPGRADED";
	else if(weap == "knife_ballistic_upgraded_zm")
		Weaponname = &"ZOMBIE_KNIFE_BALLISTIC_UPGRADED";
	else if(weap == "ray_gun_upgraded_zm")
		Weaponname = &"ZOMBIE_RAY_GUN_UPGRADED";
	else if(weap == "an94_upgraded_zm")
		Weaponname = &"ZMWEAPON_AN94_UPGRADED";
	else if(weap == "m32_upgraded_zm")
		Weaponname = &"ZMWEAPON_M32_UPGRADED";
	else if(weap == "usrpg_upgraded_zm")
		Weaponname = &"ZMWEAPON_USRPG_UPGRADED";
	else if(weap == "hamr_upgraded_zm")
		Weaponname = &"ZMWEAPON_HAMR_UPGRADED";
	else if(weap == "rpd_upgraded_zm")
		Weaponname = &"ZMWEAPON_RPD_UPGRADED";
	else if(weap == "svu_upgraded_zm")
		Weaponname = &"ZMWEAPON_SVU_UPGRADED";
	else if(weap == "barretm82_upgraded_zm")
		Weaponname = &"ZMWEAPON_BARRETM82_UPGRADED";
	else if(weap == "dsr50_upgraded_zm")
		Weaponname = &"ZMWEAPON_DSR50_UPGRADED";
	else if(weap == "fnfal_upgraded_zm")
		Weaponname = &"ZOMBIE_FNFAL_UPGRADED";
	else if(weap == "galil_upgraded_zm")
		Weaponname = &"ZOMBIE_GALIL_UPGRADED";
	else if(weap == "tar21_upgraded_zm")
		Weaponname = &"ZMWEAPON_TAR21_UPGRADED";
	else if(weap == "type95_upgraded_zm")
		Weaponname = &"ZMWEAPON_TYPE95_UPGRADED";
	else if(weap == "xm8_upgraded_zm")
		Weaponname = &"ZMWEAPON_XM8_UPGRADED";
	else if(weap == "m16_gl_upgraded_zm")
		Weaponname = &"ZOMBIE_M16_UPGRADED";
	else if(weap == "saritch_upgraded_zm")
		Weaponname = &"ZMWEAPON_SARITCH_UPGRADED";
	else if(weap == "m14_upgraded_zm")
		Weaponname = &"ZOMBIE_M14_UPGRADED";
	else if(weap == "srm1216_upgraded_zm")
		Weaponname = &"ZMWEAPON_SRM1216_UPGRADED";
	else if(weap == "saiga12_upgraded_zm")
		Weaponname = &"ZMWEAPON_SAIGA12_UPGRADED";
	else if(weap == "rottweil72_upgraded_zm")
		Weaponname = &"ZOMBIE_ROTTWEIL72_UPGRADED";
	else if(weap == "870mcs_upgraded_zm")
		Weaponname = &"ZMWEAPON_870MCS_UPGRADED";
	else if(weap == "pdw57_upgraded_zm")
		Weaponname = &"ZMWEAPON_PDW57_UPGRADED";
	else if(weap == "qcw05_upgraded_zm")
		Weaponname = &"ZMWEAPON_QCW05_UPGRADED";
	else if(weap == "mp5k_upgraded_zm")
		Weaponname = &"ZOMBIE_MP5K_UPGRADED";
	else if(weap == "ak74u_upgraded_zm")
		Weaponname = &"ZOMBIE_AK74U_UPGRADED";
	else if(weap == "fivesevendw_upgraded_zm")
		Weaponname = &"ZMWEAPON_FIVESEVEN_DW_UPGRADED";
	else if(weap == "beretta93r_upgraded_zm")
		Weaponname = &"ZMWEAPON_BERETTA93R_UPGRADED";
	else if(weap == "fiveseven_upgraded_zm")
		Weaponname = &"ZMWEAPON_FIVESEVEN_UPGRADED";
	else if(weap == "kard_upgraded_zm")
		Weaponname = &"ZMWEAPON_KARD_UPGRADED";
	else if(weap == "judge_upgraded_zm")
		Weaponname = &"ZMWEAPON_JUDGE_UPGRADED";
	else if(weap == "python_upgraded_zm")
		Weaponname = &"ZOMBIE_PYTHON_UPGRADED";
	else if(weap == "m1911_upgraded_zm")
		Weaponname = &"ZOMBIE_M1911_UPGRADED";
	else if(weap == "thompson_upgraded_zm")
		Weaponname = &"ZMWEAPON_THOMPSON_UPGRADED";
	else if(weap == "uzi_upgraded_zm")
		Weaponname = &"ZMWEAPON_UZI_UPGRADED";
	else if(weap == "ak47_upgraded_zm")
		Weaponname = &"ZMWEAPON_AK47_UPGRADED";
	else if(weap == "blundersplat_upgraded_zm")
		Weaponname = &"ZMWEAPON_ACIDGAT_UPGRADED";
	else if(weap == "blundergat_upgraded_zm")
		Weaponname = &"ZMWEAPON_BLUNDERGAT_UPGRADED";
	else if(weap == "lsat_upgraded_zm")
		Weaponname = &"ZMWEAPON_LSAT_UPGRADED";
	else if(weap == "upgraded_tomahawk_zm")
		Weaponname = &"ZMWEAPON_TOMAHAWK_UPGRADED";
	else if(weap == "thompson_zm")
		Weaponname = &"ZMWEAPON_THOMPSON";
	else if(weap == "uzi_zm")
		Weaponname = &"WEAPON_UZI";
	else if(weap == "ak47_zm")
		Weaponname = &"WEAPON_AK47";
	else if(weap == "blundersplat_zm")
		Weaponname = &"ZMWEAPON_ACIDGAT";
	else if(weap == "blundergat_zm")
		Weaponname = &"ZMWEAPON_BLUNDERGAT";
	else if(weap == "lsat_zm")
		Weaponname = &"WEAPON_LSAT";
	else if(weap == "willy_pete_zm")
		Weaponname = &"WEAPON_SMOKE_GRENADE";
	else if(weap == "bouncing_tomahawk_zm")
		Weaponname = &"ZMWEAPON_TOMAHAWK";
	else if(weap == "upgraded_tomahawk_zm")
		Weaponname = &"ZMWEAPON_TOMAHAWK_UPGRADED";
	else if(weap == "time_bomb_zm")
		Weaponname = &"ZMWEAPON_TIME_BOMB";
	else if(weap == "slowgun_zm")
		Weaponname = &"ZMWEAPON_PARALYZER";
	else if(weap == "rnma_zm")
		Weaponname = &"ZMWEAPON_RNMA";
	else if(weap == "slowgun_upgraded_zm")
		Weaponname = &"ZMWEAPON_PARALYZER_UPGRADED";
	else if(weap == "rnma_upgraded_zm")
		Weaponname = &"ZMWEAPON_RNMA_UPGRADED";
	else if(weap == "staff_revive_zm")
		Weaponname = &"ZMWEAPON_STAFF_REVIVE";
	else if(weap == "staff_water_upgraded_zm")
		Weaponname = &"ZMWEAPON_STAFF_WATER_UPGRADED";
	else if(weap == "staff_water_zm_cheap")
		Weaponname = &"ZMWEAPON_STAFF_WATER";
	else if(weap == "staff_water_zm")
		Weaponname = &"ZMWEAPON_STAFF_WATER";
	else if(weap == "staff_lightning_upgraded_zm")
		Weaponname = &"ZMWEAPON_STAFF_LIGHTNING_UPGRADED";
	else if(weap == "staff_lightning_zm")
		Weaponname = &"ZMWEAPON_STAFF_LIGHTNING";
	else if(weap == "staff_fire_upgraded_zm")
		Weaponname = &"ZMWEAPON_STAFF_FIRE_UPGRADED";
	else if(weap == "staff_fire_zm")
		Weaponname = &"ZMWEAPON_STAFF_FIRE";
	else if(weap == "staff_air_upgraded_zm")
		Weaponname = &"ZMWEAPON_STAFF_AIR_UPGRADED";
	else if(weap == "staff_air_zm")
		Weaponname = &"ZMWEAPON_STAFF_AIR";
	else if(weap == "beacon_zm")
		Weaponname = &"ZOMBIE_BEACON";
	else if(weap == "c96_zm")
		Weaponname = &"ZMWEAPON_C96";
	else if(weap == "ballista_zm")
		Weaponname = &"WEAPON_BALLISTA";
	else if(weap == "evoskorpion_zm")
		Weaponname = &"WEAPON_EVOSKORPION";
	else if(weap == "mp40_stalker_zm")
		Weaponname = &"ZMWEAPON_MP40_STALKER";
	else if(weap == "mp40_zm")
		Weaponname = &"ZMWEAPON_MP40";
	else if(weap == "ksg_zm")
		Weaponname = &"WEAPON_KSG";
	else if(weap == "scar_zm")
		Weaponname = &"WEAPON_SCAR";
	else if(weap == "mp44_zm")
		Weaponname = &"ZMWEAPON_MP44";
	else if(weap == "mg08_zm")
		Weaponname = &"ZMWEAPON_MG08";
	else if(weap == "c96_upgraded_zm")
		Weaponname = &"ZMWEAPON_C96_UPGRADED";
	else if(weap == "ballista_upgraded_zm")
		Weaponname = &"ZMWEAPON_BALLISTA_UPGRADED";
	else if(weap == "evoskorpion_upgraded_zm")
		Weaponname = &"ZMWEAPON_EVOSKORPION_UPGRADED";
	else if(weap == "mp40_stalker_upgraded_zm")
		Weaponname = &"ZMWEAPON_MP40_STALKER_UPGRADED";
	else if(weap == "mp40_upgraded_zm")
		Weaponname = &"ZMWEAPON_MP40_UPGRADED";
	else if(weap == "ksg_upgraded_zm")
		Weaponname = &"ZMWEAPON_KSG_UPGRADED";
	else if(weap == "scar_upgraded_zm")
		Weaponname = &"ZMWEAPON_SCAR_UPGRADED";
	else if(weap == "mp44_upgraded_zm")
		Weaponname = &"ZMWEAPON_MP44_UPGRADED";
	else if(weap == "mg08_upgraded_zm")
		Weaponname = &"ZMWEAPON_MG08_UPGRADED";
	else
		Weaponname = "none";
	return Weaponname;
}

ChangeColorText() {
	self endon("disconnect");
	level endon("end_game");
	while (1) {
		weapon = self getcurrentweapon();
		
		stockMax = WeaponMaxAmmo( weapon ) / 8;
		checkforlowammo = self getweaponammoclip(weapon) + self getweaponammostock(weapon);
		
		maxclip = weaponclipsize(weapon) / 3;
		checkforclip = self getweaponammoclip(weapon);
		
		if(weapon != "" && weapon != "none" && !self isthrowinggrenade() && isDefined(self.is_drinking) && self.is_drinking != 1 && !isdefined(self.screecher_weapon) && weapon != "slowgun_zm") {
			if(checkforlowammo <= stockMax) {
				self.Weaponammostock fadeovertime(0.5);
				self.Weaponammostock.color = level.ui_better_red;
				self.Weaponammocllip fadeovertime(0.5);
				self.Weaponammocllip.color = level.ui_better_red;
				self.WeaponAmmoTextNew fadeovertime(0.5);
				self.WeaponAmmoTextNew.color = level.ui_better_red;
				wait 0.5;
				self.Weaponammostock fadeovertime(0.5);
				self.Weaponammostock.color = (1, 1, 1);
				self.Weaponammocllip fadeovertime(0.5);
				self.Weaponammocllip.color = (1, 1, 1);
				self.WeaponAmmoTextNew fadeovertime(0.5);
				self.WeaponAmmoTextNew.color = (1,1,1);
				wait 0.5;
			}
			else if(checkforclip <= maxclip) {
				self.Weaponammocllip fadeovertime(0.5);
				self.Weaponammocllip.color = level.ui_better_red;
				self.WeaponAmmoTextNew fadeovertime(0.5);
				self.WeaponAmmoTextNew.color = level.ui_better_red;
				wait 0.5;
				self.Weaponammocllip fadeovertime(0.5);
				self.Weaponammocllip.color = (1, 1, 1);
				self.WeaponAmmoTextNew fadeovertime(0.5);
				self.WeaponAmmoTextNew.color = (1,1,1);
				wait 0.5;
			}
			else {
				if (self.Weaponammostock.color != (1, 1, 1)) {
					self.Weaponammostock.color = (1, 1, 1);
					self.WeaponAmmoTextNew.color = (1,1,1);
					wait 0.5;
				}
				if (self.Weaponammocllip.color != (1, 1, 1)) {
					self.Weaponammocllip.color = (1, 1, 1);
					self.WeaponAmmoTextNew.color = (1,1,1);
					wait 0.5;
				}
			}
		}
		wait .05;
	}
}

BleedoutIcon() {
	self endon("disconnect");
	level endon("intermission");
	while (1) {
		self waittill("player_downed");
		height_offset = 30;
		index = self.clientid;
		hud_elem = create_simple_hud();
		self.revive_hud_elem = hud_elem;
		hud_elem.x = self.origin[0];
		hud_elem.y = self.origin[1];
		hud_elem.z = self.origin[2] + height_offset;
		hud_elem.alpha = 1;
		hud_elem.archived = 1;
		hud_elem.color = level.ui_better_blue;
		hud_elem setshader("waypoint_revive", 5, 5);
		hud_elem setwaypoint(1);
		hud_elem.hidewheninmenu = 1;
		hud_elem.immunetodemogamehudsettings = 1;
		hud_elem thread RefreshMe(self);
		self waittill_any("bled_out", "player_revived", "fake_death");
		hud_elem notify("stoprevivehud");
		hud_elem destroy();
		self.revive_hud_elem = undefined;
	}
}

RefreshMe(player) {
	player endon("disconnect");
	level endon("intermission");
	self endon("stoprevivehud");
	height_offset = 30;
	while (1) {
		if (!isDefined(player.revive_hud_elem)) {
			return;
		}
		else {
			self.x = player.origin[0];
			self.y = player.origin[1];
			self.z = player.origin[2] + height_offset;
			wait 0.01;
		}
	}
}

upgrade_visuals() {
	self thread set_base_vision();
	self thread set_gfx_settings();
	self thread set_visual_effects();
}

set_base_vision() {
	// last stand fallback
	self useservervisionset(1);
	self setvisionsetforplayer("zm_transit_farm_ext_on", 0);  // Alternative: zm_transit_cornfield_on ?: remote_mortar_enhanced
}

set_gfx_settings() {
	self setclientdvar("r_fxaa", 0);
	self setclientdvar("r_ssao", 1);
	self setclientdvar("r_ssaoRadius", 16);
	// self setclientdvar("r_enablePlayerShadow", 1); // Player shadow: glitches and disables muzzle flash sadly
	self setclientdvar("r_grassEnable", 1);
	self setclientdvar("r_grassWindForceEnable", 1);
	self setclientdvar("r_znear", 1);
	self setclientdvar("ai_corpseCount", 8);
	self setclientdvar("r_dobjLimit", 1024);  // could show more zombies on screen

	self setclientdvar("r_texFilterQuality", 2);
	self setclientdvar("r_texFilterMipMode", "Force Trilinear");
	self setclientdvar("r_texFilterAnisoMin", 16);
	self setclientdvar("r_texFilterAnisoMax", 16);

	self setclientdvar("sm_sunQuality", 2);
	self setclientdvar("sm_spotQuality", 2);
	self setclientdvar("sm_sunShadowScale", 1);
	self setclientdvar("sm_sunsamplesizenear", 0.5);
	self setclientdvar("sm_fastSunShadow", 0);  // off = slow = more quaility (?)

	self setclientdvar("r_autoLodScale", 0);
	self setclientdvar("r_lodBiasRigid", -1000);
	self setclientdvar("r_lodBiasSkinned", -1000);
	self setclientdvar("r_lodScaleRigid", 1);
	self setclientdvar("r_lodScaleSkinned", 1);

	self setclientdvar("r_dof_enable", 0);  // enables ONLY default DOF
	self setclientdvar("r_dof_tweak", 1);
	self setclientdvar("r_dofHDR", 2);
	self setclientdvar("r_dof_viewModelEnd", 0);  // removes DOF from ADS gun
	self setclientdvar("r_dof_bias", .7);
	self setclientdvar("r_dof_nearEnd", 0);  // removes near DOF fully
	self setclientdvar("r_dof_farBlur", 1.4);
	self setclientdvar("r_anaglyphFX_enable", 0);  // 0 = premium DOF effect

	self setclientdvar("ragdoll_fps", 60);
	self setclientdvar("r_clipFPS", 60);
	self setclientdvar("r_flameFX_FPS", 60);
}

set_visual_effects() {
	self setclientdvar("r_brightness", 1.0);
    // flips skybox vertically
	self setclientdvar("r_skyColorTemp", 25000);             // 1650 (red) to 25000 (blue)
	self setclientdvar("r_lightTweakSunLight", 20);          // 0 to 32
	self setclientdvar("r_sky_intensity_factor0", 10);       // 0 to 10
	self setclientdvar("r_sky_intensity_factor1", 10);       // 0 to 10
	self setclientdvar("r_lightTweakSunColor", ".4 .5 .7");  // RGB Percent // todo: more color and less white?

	self setclientdvar("r_exposureTweak", 1);
	self setclientdvar("r_exposureValue", 2.8);  // -6 to 16

	self setclientdvar("r_reviveFX_edgeColorTemp", 25000);

	self setclientdvar("r_bloomTweaks", 1);
	self setclientdvar("r_bloomHiQuality", 1);
	self setclientdvar("vc_LOW", "16 16 16 16");  // Reflection spread per channel (alpha seems to be ignored)
	self setclientdvar("vc_LIW", "32 32 32 32");  // Reflection wide spread per channel (alpha seems to be ignored)
	self setclientdvar("vc_RGBH", "1 1 1 1");     // todo: more color and less white?, // Reflection color inner strength and spread
	self setclientdvar("vc_RGBL", "2 2 2 1");     // todo: more color and less white? // Reflection color outer strength and spread

	self setclientdvar("vc_YL", "0 .15 1 0");
	self setclientdvar("vc_YH", "0 0 .2 0"); 

	self setClientDvar("cg_usecolorcontrol", 1);
	self setClientDvar("cg_colortemp", 15000);
	self setClientDvar("cg_colorsaturation", 1);
}

AimAssist() {
	level endon("end_game");
	self endon("disconnect");
    self waittill( "spawned_player" );
    
    flag_wait( "initial_blackscreen_passed" );
    
	for(;;) {
		aim = 0;
		if( self GamepadUsedLast() && self is_assisted_weapon() && self.sessionstate != "spectator" ) {
            if(isdefined(self.perkarray) && self.deadshot) //custom perk check
                tag = "j_head";
            else if(isDefined( level.zombiemode_using_deadshot_perk ) && level.zombiemode_using_deadshot_perk && self hasperk("specialty_deadshot")) //original perk check
                tag = "j_head";
            else
                tag = "j_spine4";

			view_pos = self GetWeaponMuzzlePoint();
			zombies = get_array_of_closest( view_pos, getaiarray( level.zombie_team ), undefined, undefined, undefined );
			range_squared = 500 * 500;
			for ( i = 0; i < zombies.size; i++ ) {
				if ( !IsDefined( zombies[i] ) || !IsAlive( zombies[i] ) )
					continue;
				enemy_origin = zombies[i].origin;
				test_range_squared = DistanceSquared( view_pos, enemy_origin );
				if ( test_range_squared < range_squared ) {
					if(zombies[i] player_can_see_me(self, tag)) {
                        while(self adsButtonPressed() && !self IsReloading() && self GamepadUsedLast()) {
							if(aim < 3)
                                self setPlayerAngles(vectorToAngles((zombies[i] getTagOrigin(tag)) - (self getEye())));
                            aim++;
                            wait .01;
                        }
					}
				} 
			}
		}
        if( !self GamepadUsedLast())
            wait 1;
		wait .05;
	}
}

player_can_see_me( player, tag ) {
    playerangles = player getplayerangles();
    playerforwardvec = anglesToForward( playerangles );
    playerunitforwardvec = vectornormalize( playerforwardvec );
    banzaipos = self.origin;
    playerpos = player getorigin();
    playertobanzaivec = banzaipos - playerpos;
    playertobanzaiunitvec = vectornormalize( playertobanzaivec );
    forwarddotbanzai = vectordot( playerunitforwardvec, playertobanzaiunitvec );
    if ( forwarddotbanzai >= 1 )
        anglefromcenter = 0;
    else if ( forwarddotbanzai <= -1 )
        anglefromcenter = 180;
    else
        anglefromcenter = acos( forwarddotbanzai );
    playerfov = getDvarFloat( "cg_fov" );
    banzaivsplayerfovbuffer = getDvarFloat( "g_banzai_player_fov_buffer" );
    if ( banzaivsplayerfovbuffer <= 0 )
        banzaivsplayerfovbuffer = 0.2;
	distance = self check_distance(player);

	playercanseeme = anglefromcenter <= ( ( playerfov * distance ) * ( 1 - banzaivsplayerfovbuffer ) );

	if (IsDefined(self.isOnBus) && self.isOnBus)
		return playercanseeme;

    can_see = BulletTracePassed(player getEye(), self getTagOrigin(tag), false, self);
    
	if(can_see)
	    return playercanseeme;

    return 0;
}

check_distance(player) {
	if(distance(self.origin, player.origin) < 90)
		return .45;
	
	if(distance(self.origin, player.origin) <= 100)
		return .4;
	
	if(distance(self.origin, player.origin) <= 150)
		return .3;
	
	if(distance(self.origin, player.origin) <= 200)
		return .25;
	
	if(distance(self.origin, player.origin) <= 250)
		return .225;
	
	if(distance(self.origin, player.origin) <= 300)
		return .2;
	
	if(distance(self.origin, player.origin) <= 350)
		return .175;
	
	if(distance(self.origin, player.origin) <= 400)
		return .15;
	
	return .125;
}

is_assisted_weapon() {
    gun = self getCurrentWeapon();
    not_assisted = array("none", "syrette_zm", "jetgun_zm", "bouncing_tomahawk_zm", "slipgun_zm", "slipgun_upgraded_zm", "slowgun_zm", "slowgun_upgraded_zm", "riotshield_zm", "alcatraz_shield_zm", "tomb_shield_zm", "knife_ballistic_zm", "knife_ballistic_upgraded_zm", "knife_ballistic_bowie_zm", "knife_ballistic_bowie_upgraded_zm", "knife_ballistic_no_melee_zm", "knife_ballistic_no_melee_upgraded_zm", "upgraded_tomahawk_zm" );
    if( weaponisdualwield( gun ))
        return 0;
    if( is_melee_weapon( gun ))
        return 0;
    if( is_lethal_grenade( gun ) || is_tactical_grenade( gun ) )
        return 0;
    for(i=0;i<not_assisted.size;i++) {
        if( gun == not_assisted[i] )
            return 0;
    }

    return 1;
}

object_touching_lava() {
	if ( !isDefined( level.lava ) )
		level.lava = getentarray( "lava_damage", "targetname" );
	if ( !isDefined( level.lava ) || level.lava.size < 1 )
		return 0;
	if ( isDefined( self.lasttouching ) && self istouching( self.lasttouching ) )
		return 1;
	i = 0;
	while ( i < level.lava.size ) {
		if ( distancesquared( self.origin, level.lava[ i ].origin ) < 2250000 ) {
			if ( isDefined( level.lava[ i ].target ) ) {
				if ( self istouching( level.lava[ i ].volume ) ) {
					if ( isDefined( level.lava[ i ].script_float ) && level.lava[ i ].script_float <= 0.1 )
						return 0;
					self.lasttouching = level.lava[ i ].volume;
					return 1;
				}
			}
			else {
				if ( self istouching( level.lava[ i ] ) ) {
					self.lasttouching = level.lava[ i ];
					return 1;
				}
			}
		}
		i++;
	}
	self.lasttouching = undefined;
	return 0;
}

deployed_set_shield_health( damage, max_damage ) {
	shieldhealth = int( ( 100 * ( max_damage - damage ) ) / max_damage );
	if ( shieldhealth >= 50 )
		self.shield_damage_level = 0;
	else if ( shieldhealth >= 25 )
		self.shield_damage_level = 2;
	else
		self.shield_damage_level = 3;
	self updatestandaloneriotshieldmodel();
}

updatestandaloneriotshieldmodel() {
	update = 0;
	if ( !isDefined( self.prev_shield_damage_level ) || self.prev_shield_damage_level != self.shield_damage_level ) {
		self.prev_shield_damage_level = self.shield_damage_level;
		update = 1;
	}
	if ( update )
		self setmodel( level.deployedshieldmodel[ self.prev_shield_damage_level ] );
}















