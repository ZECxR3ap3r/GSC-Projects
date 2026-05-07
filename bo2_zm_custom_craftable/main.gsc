#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\gametypes_zm\_weapons;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_game_module;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\gametypes_zm\_spawning;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_power;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zm_alcatraz_traps;
#include maps\mp\gametypes_zm\_zm_gametype;

main() {
	replacefunc(::player_take_piece, ::player_take_piece_custom);
}

init() {
	precachemodel("p6_zm_work_bench");
	precachemodel("ch_corkboard_metaltrim_4x8");
	precachemodel("p_rus_desklamp_wmd_on");
	precachemodel("p_glo_tools_chest_short");
	
	precacheshader("hud_cymbal_monkey");
	
	flag_wait("initial_blackscreen_passed");
	
	level thread create_craftable_table("monkey_table", level.players[0].origin, (0, 0, 0), "cymbal_monkey_zm", 1500, ::craftable_custom_trigger_final_equipment, (0, 0, 43), (0, 90, 0));
	level thread create_craftable_piece("monkey_table", level.players[0].origin, (0, 0, 0), getweaponmodel("cymbal_monkey_zm"), "hud_cymbal_monkey");
	level thread create_craftable_piece("monkey_table", level.players[0].origin + (0, 0, 200), (0, 0, 0), getweaponmodel("cymbal_monkey_zm"), "hud_cymbal_monkey");
}

create_craftable_table(targetname, origin, angles, weapon, cost, final_function, part0_origin, part0_angles, part1_origin, part1_angles, part2_origin, part2_angles) {
	workbench = spawn("script_model", (0, 0, 0));
	workbench.angles = angles + (0, 90, 0);
	workbench setmodel("p6_zm_work_bench");
	workbench.targetname = targetname;
	
	collision = spawn("script_model", workbench.origin + (0, -15, 100));
    collision setmodel("collision_clip_64x64x256");
    collision.angles = angles;
    collision LinkTo(workbench);
    
    lamp = spawn( "script_model", workbench.origin + (42.46, -11.62, 44));
	lamp.angles = (0, -135, 0);
	lamp setmodel("p_rus_desklamp_wmd_on");
	lamp LinkTo(workbench);
	
	tools = spawn( "script_model", workbench.origin + (-28.53, 6.33, 44));
	tools.angles = (0, 130, 0);
	tools setmodel("p_glo_tools_chest_short");
	tools LinkTo(workbench);
	
	corkboard = spawn( "script_model", workbench.origin + (-2.62, -16.64, 69.909));
	corkboard.angles = (0, -180, 0);
	corkboard setmodel("ch_corkboard_metaltrim_4x8");
	corkboard LinkTo(workbench);
	
	workbench.origin = origin;
	
	if(isdefined(part0_origin)) {
		workbench.part_0 = spawn("script_model", origin + part0_origin);
		workbench.part_0.angles = part0_angles;
		workbench.part_0 setmodel("tag_origin");
	}
	if(isdefined(part1_origin)) {
		workbench.part_1 = spawn("script_model", origin + part1_origin);
		workbench.part_1.angles = part1_angles;
		workbench.part_1 setmodel("tag_origin");
	}
	if(isdefined(part2_origin)) {
		workbench.part_2 = spawn("script_model", origin + part2_origin);
		workbench.part_2.angles = part2_angles;
		workbench.part_2 setmodel("tag_origin");
	}
	
	workbench.trigger = spawn("trigger_box", origin + (0, 0, 40), 0, 80, 80, 100);
	workbench.trigger triggerignoreteam();
	workbench.trigger usetriggerrequirelookat();
	workbench.trigger setcursorhint("HINT_NOICON");
	workbench.trigger.targetname = targetname + "_trigger";
	
	workbench.trigger linkto(workbench);
	
	workbench thread craftable_custom_trigger(weapon, cost, final_function);
}

craftable_custom_trigger(weapon, cost, final_function) {
	self.trigger sethintstring(&"ZOMBIE_BUILD_PIECE_MORE");
	self.parts_added = 0;
	
	maxtime = 3;
	
	while(1) {
		self.trigger waittill("trigger", player);
		
		if(isdefined(player.craftable_custom_part) && player.craftable_custom_part.target == self.targetname) {
			self.trigger sethintstring(&"ZOMBIE_BUILD_SQ_COMMON");
			
			if(player usebuttonpressed()) {
				player.usebar = player createprimaryprogressbar();
				player.usebartext = player createprimaryprogressbartext();
				player.usebartext settext(&"ZOMBIE_BUILDING");
				
				player disable_player_move_states(1);
				player increment_is_drinking();
				last_weapon = player getcurrentweapon();
				player giveweapon("zombie_builder_zm");
				player switchtoweapon("zombie_builder_zm");
				
				audio_org = spawn("script_origin", self.origin);
				audio_org playloopsound("zmb_buildable_loop");
				
				progress = 0;
				while(player usebuttonpressed() && progress < (maxtime - .05)) {
					progress += .05;
					
					player.usebar updatebar(progress / maxtime, maxtime);
					
					wait .05;
				}
				
				audio_org delete();
			
				player maps\mp\zombies\_zm_weapons::switch_back_primary_weapon(last_weapon);
				player takeweapon("zombie_builder_zm");
				if(isDefined(player.is_drinking) && player.is_drinking)
					player decrement_is_drinking();
				player enable_player_move_states();
				
				player.usebartext destroyelem();
				player.usebar destroyelem();
				
				if(progress > (maxtime - .05)) {
					if(self.craftable_custom_part.slot == 0)
						self.part_0 setmodel(player.craftable_custom_part.model);
					else if(self.craftable_custom_part.slot == 1)
						self.part_1 setmodel(player.craftable_custom_part.model);
					else if(self.craftable_custom_part.slot == 2)
						self.part_2 setmodel(player.craftable_custom_part.model);
					
					player.craftable_custom_part = undefined;
					if(isdefined(player.craftable_hud))
						player.craftable_hud destroy();
					
					self.parts_added++;
					if(self.parts_added == self.parts.size) {
						self [[ final_function ]](weapon, cost);
						break;
					}
					else
						self.trigger sethintstring(&"ZOMBIE_BUILD_PIECE_MORE");
				}
			}
		}
		else if(isdefined(player.current_buildable_pieces) && player.current_buildable_pieces.size > 0)
			self.trigger sethintstring(&"ZOMBIE_BUILD_PIECE_WRONG");
			
		wait .15;
	}
}

craftable_custom_trigger_final_equipment(weapon, cost) {
	self.trigger sethintstring("Press ^3&&1^7 for ^3" + weapon + "^7 [Cost: " + cost + "^7]");
	
	wait 1;
	
	while(1) {
		self.trigger waittill("trigger", player);
		
		if(player usebuttonpressed()) {
			if(player can_buy_weapon()) {
				if(player.score >= cost) {
					if(!player hasweapon(weapon)) {
						player maps\mp\zombies\_zm_score::minus_to_player_score(cost, 1);
						player playLocalSound("zmb_cha_ching");
						player giveweapon(weapon);
					}
					else if(player getammocount(weapon) < weaponmaxammo(weapon)) {
						player maps\mp\zombies\_zm_score::minus_to_player_score(cost, 1);
						player playLocalSound("zmb_cha_ching");
						player givemaxammo(weapon);
					}
				}
			}
			
			wait .15;
		}
	}
}

create_craftable_piece(targetname, origin, angles, model, material) {
	if(isdefined(targetname)) {
		workbench = getent(targetname, "targetname");
		
		if(isdefined(workbench)) {
			if(!isdefined(workbench.parts))
				workbench.parts = [];
				
			part = spawn("script_model", origin);
			part.angles = angles;
			part setmodel(model);
			part.target = targetname;
			part.org_origin = origin;
			part.org_angles = angles;
			part.slot = workbench.parts.size;
			
			part.trigger = spawn("trigger_radius_use", origin, 1, 30, 30);
			part.trigger triggerignoreteam();
			part.trigger setcursorhint("HINT_NOICON");
			part.trigger sethintstring(&"ZOMBIE_BUILD_PIECE_GRAB");
			
			part thread craftable_piece_watcher(material);
			
			workbench.parts[workbench.parts.size] = part;
		}
		else
			print("Entity with Targetname [^1" + targetname + "^7]: not defined");
	}
	else
		print("Targetname [^1" + targetname + "^7]: not defined");
}

craftable_piece_watcher(material) {
	while(!isdefined(self.placed)) {
		self.trigger waittill("trigger", player);
		
		if(isdefined(player.current_buildable_pieces)) {
			for(i = 0;i < player.current_buildable_pieces.size;i++) {
				if(isdefined(player.current_buildable_pieces[i])) {
					player.current_buildable_pieces[i] piece_spawn_at(player.origin, (0, 0, 0));
					player clear_buildable_clientfield(i);
					player player_set_buildable_piece(undefined, i);
				}
			}
		}
		
		if(isdefined(player.craftable_custom_part))
			player.craftable_custom_part drop_custom_craftable_piece(player.origin, (0, 0, 0));
		
		self hide();
		self.trigger setinvisibletoall();
		
		player.craftable_custom_part = self;
		
		self thread craftable_dc_death_watcher(player);
		
		player thread craftable_create_icon(material);
	}
}

craftable_create_icon(material) {
	if(!isdefined(self.craftable_hud)) {
		self.craftable_hud = newclienthudelem(self);
		self.craftable_hud.horzalign = "fullscreen";
		self.craftable_hud.vertalign = "fullscreen";
		self.craftable_hud.alignx = "center";
		self.craftable_hud.aligny = "bottom";
		self.craftable_hud.x = 400;
		self.craftable_hud.y = 480;
		self.craftable_hud.alpha = 1;
		self.craftable_hud setshader(material, 24, 24);
	}
}

craftable_dc_death_watcher(player) {
	self endon("custom_craftable_placed");

	player waittill("death_or_disconnect");
	
	self drop_custom_craftable_piece(self.org_origin, self.org_angles, player);
}

drop_custom_craftable_piece(origin, angles, player) {
	self.origin = origin;
	self.angles = angles;
	
	self.trigger.origin = origin;
	
	self show();
	self.trigger setvisibletoall();
	if(isdefined(player))
		player.craftable_custom_part = undefined;
}

player_take_piece_custom( piece ) {
	piece_slot = piece.buildable_slot;
	damage = piece.damage;
	
	if(isDefined(self player_get_buildable_piece(piece_slot))) {
		other_piece = self player_get_buildable_piece( piece_slot );
		self player_drop_piece(self player_get_buildable_piece(piece_slot), piece_slot);
		other_piece.damage = damage;
		self do_player_general_vox("general", "build_swap");
	}
	
	if(isdefined(self.craftable_custom_part)) {
		self.craftable_custom_part drop_custom_craftable_piece(self.origin, (0, 0, 0), self);
		if(isdefined(self.craftable_hud))
			self.craftable_hud destroy();
	}
	
	if(isDefined(piece.onpickup))
		piece [[ piece.onpickup ]](self);
	piece piece_unspawn();
	piece notify("pickup");
	
	if(isplayer(self)) {
		if(isDefined(piece.client_field_state))
			self set_buildable_clientfield(piece_slot, piece.client_field_state);
		self player_set_buildable_piece(piece, piece_slot);
		self thread player_drop_piece_on_death(piece_slot);
		self track_buildable_piece_pickedup(piece);
	}
}
