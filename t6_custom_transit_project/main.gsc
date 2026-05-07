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
#include maps/mp/zombies/_zm_unitrigger;
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
#include maps/mp/zombies/_zm_ai_dogs;
#include maps/mp/zombies/_zm_ai_screecher;
#include maps/mp/zombies/_zm_ai_basic;
#include maps/mp/zombies/_zm_blockers;
#include maps/mp/zombies/_zm_buildables;
#include maps/mp/zm_transit_lava;
#include maps/mp/zombies/_zm_powerups;
#include maps/mp/zm_transit_buildables;
#include maps/mp/_visionset_mgr;
#include maps/mp/animscripts/zm_utility;
#include maps/mp/zm_transit_utility;
#include maps/mp/zm_transit_bus;

init() {
	replacefunc(::player_lava_damage, ::player_lava_damage_c);
	replacefunc(maps/mp/zombies/_zm_weapons::ammo_give, ::ammo_give);
	replaceFunc(maps/mp/zombies/_zm_playerhealth::playerhealthregen, ::playerhealthregen_custom);
	replacefunc(::full_ammo_on_hud, ::full_ammo_on_hud_custom);
	replacefunc(::boxstub_update_prompt, ::boxstub_update_prompt_c);
	replacefunc(::give_perk, ::Custom);
	replacefunc(::solo_tombstone_removal, ::solo_tombstone_removal_custom);

	precachemodel("p6_zm_core_panel_02");
	precachemodel("p6_zm_open_power_panel");
	precachemodel("collision_clip_wall_128x128x10");
	precachemodel("collision_clip_wall_256x256x10");
	precachemodel("collision_clip_wall_512x512x10");
	precachemodel("collision_clip_64x64x256");
	precachemodel("collision_clip_256x256x256");
	precachemodel("collision_clip_128x128x10");
	precachemodel("collision_clip_128x128x128");
	precachemodel("collision_clip_256x256x256");
	precachemodel("collision_clip_32x32x10");
	precachemodel("collision_clip_32x32x128");
	precachemodel("collision_clip_32x32x32");
	precachemodel("collision_clip_512x512x512");
	precachemodel("collision_clip_512x512x10");
	precachemodel("collision_clip_64x64x10");
	precachemodel("collision_clip_64x64x128");
	precachemodel("collision_clip_64x64x256");
	precachemodel("collision_clip_64x64x64");
	precachemodel("collision_clip_cylinder_32x128");
	precachemodel("collision_clip_ramp");
	precachemodel("collision_clip_wall_32x32x10");
	precachemodel("collision_clip_wall_64x64x10");
	precachemodel("collision_wall_256x256x10_standard");
	precachemodel("collision_wall_128x128x10_standard");
	precachemodel("collision_wall_512x512x10_standard");
	precachemodel("collision_wall_32x32x10_standard");
	precachemodel("collision_wall_64x64x10_standard");
	precachemodel("collision_player_512x512x512");
	precachemodel("collision_ai_64x64x10");
	precachemodel("collision_clip_sphere_32");
	precachemodel("veh_t6_civ_movingtrk_cab_dead");
	precachemodel("veh_t6_civ_60s_coupe_dead");
	precachemodel("p6_zm_quarantine_fence_03");
	precachemodel("veh_t6_civ_bus_zombie");
	precachemodel("p6_zm_quarantine_fence_02");
	precachemodel("p6_zm_quarantine_fence_01");
	precachemodel("t5_foliage_bush05");
	precachemodel("t5_foliage_tree_burnt03");
	precachemodel("t5_foliage_tree_burnt02");
	precachemodel("p6_grass_wild_mixed_med");
	precachemodel("p6_zm_rocks_large_cluster_01");
	precachemodel("p_jun_metal_shelves_town");
	precachemodel("afr_powerpole1");
	precachemodel("com_debris_car_panal02");
	precachemodel("p6_anim_zm_barricade_board_collision");
	precachemodel("p_glo_tools_chest_tall");
	precachemodel("p_lights_hangingbulb_off");
	precachemodel("p_rus_desklamp_wmd_on");
	precachemodel("p_glo_tools_chest_short");
	precachemodel("p6_plant_cornstalk_lrg_dry");
	precachemodel("p6_plant_cornstalk_lrg_row_256_dry");
	precachemodel("p6_plant_cornstalk_lrg_row_512_dry");
	precachemodel("p6_zm_building_rundown_01");
	precachemodel("p6_zm_keys");
	precachemodel("p6_zm_building_rundown_03");
	precachemodel("zombie_teddybear");
	precachemodel("p6_zm_work_bench");
	precachemodel("zombie_ammocan");
	precachemodel("p_glo_street_light01");
	precachemodel("p_glo_street_light01_on");
	precachemodel("p_glo_street_light02");
	precachemodel("p6_zm_window_dest_glass_small");
	precachemodel("p6_zm_buildable_turbine_mannequin");
	precachemodel("p6_zm_buildable_etrap_tvtube");
	precachemodel("p6_zm_buildable_etrap_base");
	precachemodel("veh_t6_civ_bus_zombie_roof_hatch");
	precachemodel("t6_wpn_lmg_rpd_world");
	precachemodel("vehicle_tractor_2");
	precachemodel("zm_awning_01_blue");
	precachemodel("zm_t6_civ_movingtrk_box_dead");
	precachemodel("p6_zm_buildable_turret_ammo");
	precachemodel("p6_zm_buildable_turret_mower");
	precachemodel("p6_anim_zm_buildable_turret");
	precachemodel("t6_wpn_zmb_jet_gun_world");
	precachemodel("p6_zm_rocks_medium_05");
	precachemodel("veh_t6_civ_bus_zombie_cow_catcher");
	precachemodel("com_stepladder_large_closed");
	precachemodel("p6_anim_zm_buildable_turbine");
	precachemodel("p6_zm_buildable_sq_meteor");
	precachemodel("p6_zm_buildable_pap_table");
	precachemodel("t6_wpn_zmb_shield_world");
	precachemodel("p6_zm_buildable_turbine_fan");
	precachemodel("p6_zm_buildable_jetgun_guages");
	precachemodel("semtex_bag");
	precachemodel("p6_zm_buildable_turret_ammo");
	precachemodel("p6_zm_buildable_turret_mower");
	precachemodel("p6_anim_zm_buildable_turret");
	precachemodel("t6_wpn_zmb_jet_gun_world");
	precachemodel("veh_t6_civ_bus_zombie_cow_catcher");
	precachemodel("p6_anim_zm_buildable_turbine");
	precachemodel("p6_zm_buildable_sq_meteor");
	precachemodel("p6_zm_buildable_sq_meteor");
	precachemodel("p6_zm_buildable_pap_table");
	precachemodel("t6_wpn_zmb_shield_world");
	precachemodel("p6_zm_buildable_turbine_fan");
	precachemodel("p6_zm_buildable_jetgun_guages");
	precachemodel("p6_zm_buildable_jetgun_engine");
	precachemodel("world_knife_bowie");
	precachemodel("p6_zm_kiosk");
	precachemodel("p6_zm_sign_terminal");
	precachemodel("zombie_meteor_chunk_sml2");
	precachemodel("t6_wpn_taser_knuckles_world");
	precachemodel("p6_zm_outhouse");
	precachemodel("t6_wpn_zmb_raygun_view");
	precachemodel("t6_wpn_zmb_raygun_world");
	precachemodel("p6_zm_bank_vault_floor_hatch");
	precachemodel("pap_p6_zm_buildable_pap_body");
	precachemodel("p6_zm_buildable_pap_table");
	precachemodel("p6_zm_buildable_battery");
	precachemodel("ch_corkboard_metaltrim_4x8");
	precachemodel("p_cub_door_wood_frame01");
	precachemodel("p6_zm_door_tearin_wood01");
	precachemodel("p_glo_cinder_block");
	precachemodel("p_glo_powerline_tower_redwhite");
	precachemodel("pap_p6_zm_buildable_pap_body");
	precachemodel("p6_zm_buildable_pap_table");
	precachemodel("p6_zm_buildable_battery");
	precachemodel("ch_corkboard_metaltrim_4x8");
	precachemodel("p_cub_door_wood_frame01");
	precachemodel("p6_zm_door_tearin_wood01");
	precachemodel("p_glo_cinder_block");
	precachemodel("mlv_p6_zm_tm_sandbags_128");
	precachemodel("p_glo_sandbags_green_lego_mdl");
	precachemodel("mlv_p6_zm_tm_sandbags_64");
	precachemodel("mlv_p6_zm_tm_sandbags_corner_01");
	precachemodel("mlv_p6_zm_tm_sandbags_door");
	precachemodel("fxanim_zom_bus_interior_mod");
	precachemodel("p6_zm_broken_asphault_debris");
	precachemodel("test_macbeth_chart_unlit");
	precachemodel("p6_zm_water_tower");
	precachemodel("p_glo_corrugated_metal4x8_holes");
	precachemodel("veh_t6_civ_bus_zombie");
	precachemodel("p_jun_caution_sign");
	precachemodel("p_glo_street_light02_on_light");
	precachemodel("ap_table01");
	precachemodel("foliage_red_pine_stump_lg");
	precachemodel("p6_monsoon_crate_01_shell");
	precachemodel("p_jun_storage_crate");
	precachemodel("p_jun_storage_crate_forest2");
	precachemodel("com_crate02_farm");
	precachemodel("afr_barrel_biohazard_white_rust");
	precachemodel("afr_junktire");
	precachemodel("afr_pallet_destroyed");
	precachemodel("ch_gas_pump");
	precachemodel("ch_radiator01");
	precachemodel("ch_washer_01");
	precachemodel("com_debris_car_panal02");
	precachemodel("com_debris_metal_grille");
	precachemodel("com_debris_engine02");
	precachemodel("com_file_cabinets_a_long");
	precachemodel("com_food_prep_station_stove");
	precachemodel("com_pipe_8x256_ceramic");
	precachemodel("com_powerline_tower_top2_broken2");
	precachemodel("com_powerline_tower_top2_broken2_forest");
	precachemodel("debris_rubble_chunk_03");
	precachemodel("debris_rubble_pile_01");
	precachemodel("p6_zm_power_station_pipe_2x256");
	precachemodel("iw_rooftop_ac_unit");
	precachemodel("com_pipe_4_45angle_metal");
	precachemodel("light_outdoorwall01_on");
	precachemodel("light_outdoorwall01_on_power");
	precachemodel("locomotive_sidevent_01");
	precachemodel("mp_radiation_building_supports02");
	precachemodel("ny_harbor_planter");
	precachemodel("p6_billboard_pillar_top");
	precachemodel("p6_duct_sq_sml_64_dirty");
	precachemodel("p6_pak_veh_train_boxcar");
	precachemodel("p6_street_pole_sign_broken");
	precachemodel("p6_zm_ball_return");
	precachemodel("p6_zm_bank_pilaster_1");
	precachemodel("p6_zm_core_panel_01");
	precachemodel("p6_zm_core_reactor_base");
	precachemodel("p6_zm_farm_chickencoop");
	precachemodel("p6_zm_farm_trough");
	precachemodel("p6_zm_highway_sign");
	precachemodel("p6_zm_open_power_panel");
	precachemodel("p6_zm_rain_gutter_01");
	precachemodel("p6_zm_score_table");
	precachemodel("p6_zm_shoe_rack");
	precachemodel("p6_zm_sign_bowling_large");
	precachemodel("p6_zm_sign_bookstore");
	precachemodel("p6_zm_sign_bus_rooftop");
	precachemodel("p6_zm_sign_church");
	precachemodel("p6_zm_sign_diner");
	precachemodel("p6_zm_sign_diner_24hrs");
	precachemodel("p6_zm_sign_diner_base");
	precachemodel("p6_zm_sign_diner_rooftop");
	precachemodel("p6_zm_sign_diner_supports");
	precachemodel("p6_zm_sign_laundromat");
	precachemodel("p6_zm_sign_neon_bar");
	precachemodel("p6_zm_sign_neon_bowling");
	precachemodel("p6_zm_sign_neon_bowling_flicker");
	precachemodel("p6_zm_sign_neon_loans");
	precachemodel("p6_zm_sign_neon_open");
	precachemodel("p6_zm_sign_tickets");
	precachemodel("p6_zm_silo");
	precachemodel("p6_zm_wind_turbine");
	precachemodel("p6_zm_wind_turbine_rotor");
	precachemodel("p_glo_bookshelf_wide_d_forest2");
	precachemodel("p_glo_bucket_metal");
	precachemodel("p_glo_bucket_metal_farm");
	precachemodel("p_glo_cans_multiple");
	precachemodel("p_glo_cardboardbox_1");
	precachemodel("p_glo_palette");
	precachemodel("p_glo_sandbags_green_long_128x64_khe_sahn");
	precachemodel("p_glo_tools_hoe");
	precachemodel("p_glo_tools_rake");
	precachemodel("p_glo_tools_saw");
	precachemodel("p_glo_tools_shovel");
	precachemodel("p_glo_tools_wheelbarrow");
	precachemodel("p_glo_trashcan");
	precachemodel("p_glo_trashcan_diner");
	precachemodel("p_glo_trashcan_town");
	precachemodel("p_jun_ashtray_town");
	precachemodel("p_jun_dockpost_pow");
	precachemodel("veh_t6_civ_smallwagon_dead");
	precachemodel("veh_t6_civ_microbus_dead");
	precachemodel("p_jun_metal_shelves_cornfield");
	precachemodel("p_jun_rubble02");
	precachemodel("p_lights_barefixture_on_power");
	precachemodel("p_lights_cagelight02_red_off");
	precachemodel("p_lights_lantern_hang_on_corn");
	precachemodel("p_rus_ac_unit");
	precachemodel("p_rus_animal_cage_medium_01");
	precachemodel("p_rus_blinds02");
	precachemodel("p_rus_building_supports01");
	precachemodel("p_rus_crate_metal_1");
	precachemodel("p_rus_crate_metal_2");
	precachemodel("com_pipe_4_90angle_metal_rusted");
	precachemodel("zombie_vending_tombstone_on");
	precachemodel("zombie_vending_tombstone");
	precachemodel("p_rus_desklamp_wmd_on");
	precachemodel("p_rus_pneumatic_dolly");
	precachemodel("p_rus_sign_biohazard");
	precachemodel("p6_zm_work_bench");
	precachemodel("ch_corkboard_metaltrim_4x8");
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

	setDvar("player_strafeSpeedScale", 1);
	setDvar("player_sprintStrafeSpeedScale", 1);
	setDvar("player_backSpeedScale", 1);
	setDvar("jump_slowdownEnable", 0);
	setDvar("scr_screecher_ignore_player", 1);
	setDvar("g_friendlyfireDist", 0);
	setDvar("perk_weapRateEnhanced", 0);
	setdvar("dtp_post_move_pause", 0);
	setdvar("dtp_exhaustion_window", 100);
	setdvar("dtp_startup_delay", 100);

	spawnpoints = getstructarray("initial_spawn_points", "targetname");
	spawnpoints[0].origin = (1410.8, -2415.09, -43.0649);
	spawnpoints[0].angles = (0, -68, 0);
	spawnpoints[1].origin = (1719.91, -2354.47, -39.272);
	spawnpoints[1].angles = (0, -136, 0);
	spawnpoints[2].origin = (1835.05, -2643.17, -21.3829);
	spawnpoints[2].angles = (0, -163, 0);
	spawnpoints[3].origin = (1860.4, -3024.3, -8.73568);
	spawnpoints[3].angles = (0, 142, 0);
	spawnpoints[4].origin = (1570.7, -2925.44, -9.75053);
	spawnpoints[4].angles = (0, 56, 0);
	spawnpoints[5].origin = (1363.62, -2631.72, -5.63956);
	spawnpoints[5].angles = (0, 25, 0);
	spawnpoints[6].origin = (1759.14, -3569.79, -10.5737);
	spawnpoints[6].angles = (0, 111, 0);
	spawnpoints[7].origin = (1289.25, -3336.46, 16.125);
	spawnpoints[7].angles = (0, 23, 0);  // at this point we can use the the same origin positions
	spawnpoints[8].origin = (1410.8, -2415.09, -43.0649);
	spawnpoints[8].angles = (0, -68, 0);
	spawnpoints[9].origin = (1719.91, -2354.47, -39.272);
	spawnpoints[9].angles = (0, -136, 0);
	spawnpoints[10].origin = (1835.05, -2643.17, -21.3829);
	spawnpoints[10].angles = (0, -163, 0);
	spawnpoints[11].origin = (1860.4, -3024.3, -8.73568);
	spawnpoints[11].angles = (0, 142, 0);

	spawn_points = getstructarray("player_respawn_point", "targetname");
	for (i = 0; i < spawn_points.size; i++) {
		spawn_points[i].target = "pf1801_auto2374";
	}

	spawn_points_respawn = getstructarray("pf1801_auto2374", "targetname");
	spawn_points_respawn[0].origin = (1410.8, -2415.09, -43.0649);
	spawn_points_respawn[1].origin = (1719.91, -2354.47, -39.272);
	spawn_points_respawn[2].origin = (1835.05, -2643.17, -21.3829);
	spawn_points_respawn[3].origin = (1860.4, -3024.3, -8.73568);
	spawn_points_respawn[4].origin = (1570.7, -2925.44, -9.75053);
	spawn_points_respawn[5].origin = (1759.14, -3569.79, -10.5737);
	spawn_points_respawn[6].origin = (1289.25, -3336.46, 16.125);
	spawn_points_respawn[7].origin = (1410.8, -2415.09, -43.0649);

	precacheshellshock("electrocution");

	labpaptrigger = getent("lab_secret_hatch", "target");
	labpaptrigger delete ();
	
	level thread onPlayerConnect();
	level.ui_better_red = (.625, .08, .08);  // .59 .08 .08
	level.ui_better_blue = (0, 0.5, 0.8);

	level.ChallengeHud = create_simple_hud();
	level.ChallengeHudText = create_simple_hud();
	level.ChallengeHud.color = level.ui_better_red;
	level.ChallengeHudText.color = (1, 1, 1);
	level.intserverstats = 0;
	level.new_players = 0;
	level.new_sessions = 0;
	level.InfernosSpawned = 0;
	level.perk_purchase_limit = 9;
	level.generatorsturnedon = 0;
	level.player_intersection_tracker_override = ::blank;
	level.callbackActorKilled = ::actor_killed_override;
	level.hud = create_simple_hud();
	level.hudtext = create_simple_hud();
	level.hud.color = level.ui_better_red;
	level.hudtext.color = level.ui_better_red;
	level.zombie_init_done = ::zombie_init_done;
	foreach(powerup in level.zombie_powerups)
		powerup.solo = 1;
		
	disable_pers_upgrades();
	thread track_points_spent();
	thread CustomModelsArrayFreeSpace();
	thread SpawnAllExtraModels();
	thread CustomMapEditThreads();
	
	level thread CustomRoundNumber();
	level thread add_wallbuy();
	level thread ReaperCommands();
	level thread SpawnFastTravels();
	level thread InfernoSpawners();
	level thread custom_powerup_grab();
	level thread HandleServerStats();
	level thread ResetInfernoCounter();
	level thread SpawnAllGenerators();

	flag_wait("start_zombie_round_logic");
	add_random_perk_location((2303.15, 561.419, -55.875), (0, -45, 0), "OnTowDoorBar", 1);        // Town
	add_random_perk_location((-7314.64, 5462.36, -55.875), (0, 0, 0), "OnPriDoorYar3", 3);        // Bus Depot
	add_random_perk_location((-6496.36, -7694.92, 0.306789), (0, 90, 0), "OnGasDoorDin", 1, 30);  // Diner
	add_random_perk_location((8440.97, -5338.6, 48.125), (0, -140, 0), "OnFarm_enter", 4);        // Farm
	add_random_perk_location((11571.1, 7724.36, -755.375), (0, -360, 0), "OnPowDoorRR", 3);       // Power
	level thread randomize_perk_locations(false);
	add_random_pap_location((549.936, -1344.36, 120.125), (0, -180, 0), true);  // true = first pap start location
	add_random_pap_location((-3539.64, -7215.64, -58.875), (0, -40, 0));
	add_random_pap_location((7966.09, -6206.15, 245.125), (0, -60, 0));
	add_random_pap_location((13461.7, 55.0111, -181.826), (0, -40, 0));
	add_random_pap_location((5209.34, 7111.64, -63.875), (0, 180, 0));
	level thread randomize_pap_locations();
	level.zombie_vars["zombie_score_damage_normal"] = 0;
	level.zombie_vars["zombie_score_damage_light"] = 0;
	level notify("end_round_think");
	level thread buildbuildables();
	level thread EditAllDoorTriggers();
	NewPerkLocations("specialty_quickrevive", (1920.95, -2823.47, -13.3977), (-3, -80, 0), 0, undefined);
	NewPerkLocations("specialty_armorvest_upgrade", (5020.99, 6690.51, -24.4824), (0, 130, 0), 1, "zombie_vending_jugg");
	NewPerkLocations("specialty_fastreload_upgrade", (13552.4, -1366.66, -188.875), (0, 90, 0), 1, "zombie_vending_sleight");
	NewPerkLocations("specialty_quickrevive_upgrade", (-10638.7, -507.798, 196.125), (0, -60, 0), 1, "zombie_vending_revive");
	level.weapon_locker_online = 0;
	level thread round_think();
	ChallengeHud();
	level thread setupmusicstate("round_end", "mus_load_zm_transit_dr", 1, 1, 1, "WAVE");
	disable_bank_teller();
	money_under_perks();
	rotate_wind_turbine();
	wait 20;
	spawncollisionsforbus();
}

onPlayerConnect() {
	level endon("game_ended");
	for (;;) {
		level waittill("connected", player);
		if (isDefined(level.player_out_of_playable_area_monitor) && level.player_out_of_playable_area_monitor)
			level.player_out_of_playable_area_monitor = 0;
		if (isDefined(level.player_too_many_weapons_monitor) && level.player_too_many_weapons_monitor)
			level.player_too_many_weapons_monitor = 0;
		executeCommand("setclantagraw " + player getentitynumber() + "");
		player.realname = player.name;
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned() {
	self endon("disconnect");
	level endon("game_ended");
	self.score_spent = 0;
	self.initial_spawn = 1;
	for (;;) {
		self waittill("spawned_player");
		if (self.initial_spawn == 1) {
			self.haselectricupgrade = 1;
			self.initial_spawn = 0;
			self thread HandlePlayerStats();
			self thread BleedoutIcon();
			wait 0.5;
			self.menucolor = (0, 0.5, 1);
			self setclientuivisibilityflag("hud_visible", 0);
			flag_wait("initial_blackscreen_passed");
			rank = convert_xp_to_level(self.total_stats["xp"]);
			executeCommand("setclantagraw " + self getentitynumber() + " ^5" + rank["current_level"] + "^7");
			self.statusicon = "hud_icon_colt";
			self thread SpawnPlayerIn();
			self thread carpenter_repair_shield();
			self thread max_ammo_refill_clip();
			self setclientuivisibilityflag("hud_visible", 0);
		}
	}
}

SpawnFastTravels() {
	flag_wait("power_on");
	level thread spawnFastTravel("Cabin", (5400.3, 6591.86, 35.125), (0, 90, 90), "Nacht Der Untoten");
	level thread spawnFastTravel("Nacht", (13195, -280.315, -135.436), (0, 270, 90), "Cabin");
	level thread spawnFastTravel("Farm", (7902.37, -6553.76, 311.125), (0, -60, 90), "Bus Depot");
	level thread spawnFastTravel("Depot", (-6145.85, 4110.64, 8.125), (0, 0, 90), "Farm");
	level thread spawnFastTravel("Town", (493.642, -1279.75, 180.125), (0, 270, 90), "Diner");
	level thread spawnFastTravel("Diner", (-5584.23, -7631.64, 288.288), (0, 135, 90), "Town");
}

WatchForFlagTravel(Goal, cost) {
	level endon("end_game");
	self endon("travelcheckcompletedTown");
	while (1) {
		if (flag("OnTowDoorBar")) {
			self sethintstring("Press ^3&&1^7 To Travel to " + Goal + " [Cost: " + cost + "]");
			self notify("travelcheckcompletedTown");
		}
		else
			self sethintstring("Please Come Back Later!");
		wait 1;
	}
}

WatchForFlagTravel2(Goal, cost) {
	level endon("end_game");
	self endon("travelcheckcompletedDiner");
	while (1) {
		diner_hatch_col = getent("diner_hatch_collision", "targetname");
		if (!isdefined(diner_hatch_col)) {
			self sethintstring("Press ^3&&1^7 To Travel to " + Goal + " [Cost: " + cost + "]");
			self notify("travelcheckcompletedDiner");
		}
		else
			self sethintstring("Please Come Back Later!");
		wait 1;
	}
}

spawnFastTravel(Location, Origin, PortalAngles, Goal) {
	cost = 500;
	thread playchalkfx("screecher_vortex", Origin, PortalAngles);
	use_trigger = spawn("trigger_radius_use", Origin, 0, 20, 20);
	use_trigger.targetname = "Fast_Travel_Trigger";
	use_trigger triggerignoreteam();
	use_trigger setcursorhint("HINT_NOICON");
	use_trigger sethintstring("Press ^3&&1^7 To Travel to " + Goal + " [Cost: " + cost + "]");
	if (goal == "Town") {
		use_trigger thread WatchForFlagTravel(Goal, cost);
		use_trigger waittill("travelcheckcompletedTown");
	}
	if (goal == "Diner") {
		use_trigger thread WatchForFlagTravel2(Goal, cost);
		use_trigger waittill("travelcheckcompletedDiner");
	}
	while (1) {
		use_trigger waittill("trigger", player);
		if (player usebuttonpressed()) {
			if (player.score >= cost) {
				player.score -= cost;
				player playsound("zmb_cha_ching");
				player playsoundtoplayer("zmb_screecher_portal_warp_2d", player);
				player.crossdot_frame.alpha = 0;
				player fast_travel_handler(Location);
			}
			else {
				player playsound("door_deny");
				player maps/mp/zombies/_zm_audio::create_and_play_dialog("general", "no_money_weapon");
			}
		}
	}
}

fast_travel_handler(location) {
	self endon("FastTravelOver");
	if (location == "Diner")
		points = array((-5592.55, -7375.98, 242.125), (-5489.12, -7084.75, 193.804), (-5251.6, -7000.16, 165.736), (-4932.47, -7143.71, 126.821), (-4699.47, -7309.51, 50.3267), (-4413.07, -7354.39, -12.6567), (-4104.56, -7409.97, 21.3285), (-3808.71, -7640.88, 153.152), (-3513.98, -7728.93, 209.687), (-3258.8, -7588.64, 216.875), (-3144.83, -7295.66, 200.007), (-2857.17, -6298.78, 152.075), (-2658.05, -6002.39, 153.358), (-2245.26, -5730.43, 171.299), (-1184.07, -5453.83, 209), (-193.638, -5289.65, 94.7666), (-9.04335, -5223.18, 61.3637), (122.843, -5134.6, 54.3625), (438.428, -4587.52, 124.776), (942.364, -3981.8, 241.8), (1185.9, -3580.45, 405.258), (1319.82, -3165.17, 603.277), (1401.78, -2720.67, 659.343), (1421.16, -2183.31, 516.416), (1418.14, -1697.54, 280.85), (1448.59, -1207.28, 117.654), (1537.87, -779.184, 80.0433), (1656.43, -380.409, 124.702), (1857.96, -63.2872, 158.955));
	if (location == "Farm")
		points = array((7738.53, -6579.96, 325.875), (6930.74, -6466.81, 273.937), (4104.33, -5720.57, 103.082), (3225.49, -5624.87, 288.257), (2155.45, -5538.04, 635.773), (1759.3, -5417.82, 334.99), (1490.83, -5209.22, 185.298), (1448.29, -4843.83, 90.1441), (1477.82, -4487.89, 64.0064), (1325.41, -4281.43, 59.1305), (1401.38, -3641.06, 116.772), (1638.24, -2311.62, 178.442), (1744.63, -1119.88, 99.3762), (1766.72, -502.495, 70.6735), (1478.19, -172.683, 82.5729), (749.026, -177.996, 94.2465), (-610.895, -494.276, 85.3969), (-1663.54, -206.889, 140.512), (-2850.12, 231.977, 192.23), (-4251.69, 397.389, 353.536), (-4986.2, 972.881, 505.346), (-5303.59, 1783.88, 412.582), (-5307.72, 2748.04, 285.657), (-5281.08, 3759.6, 174.457), (-5225.09, 4710.53, 190.277), (-5154.95, 5103.07, 192.281), (-5397.91, 5460.21, 154.076), (-5708.26, 5501.35, 107.185), (-6210.89, 5456.37, 40.214));
	if (location == "Cabin")
		points = array((5656.34, 6529.94, 65.551), (6344.09, 6140.73, 86.068), (6707.4, 6158.86, 7.77422), (7138.2, 6811.04, -71.4006), (7403.37, 7052.04, -124.568), (7740.1, 7043.11, -147.124), (8092.7, 6792.86, -186.982), (8319.19, 6431.67, -279.637), (8498.18, 5417.72, -218.902), (8236.75, 4565.33, -143.333), (7945.18, 4011.3, -18.9288), (7775.87, 3463.41, 211.072), (7548.76, 2069.64, 436.365), (7375.26, 833.168, 344.158), (7168.68, 213.619, 302.061), (7061.14, -262.09, 469.324), (7170.52, -662.407, 699.908), (7525.5, -903.39, 887.319), (8150.78, -990.349, 876.218), (8620.41, -864.64, 656.029), (9615.56, -247.084, 100.873), (10729.9, 148.407, -12.3349), (12094.6, 192.667, 30.0111), (12931.4, -144.948, 34.9662), (13129.4, -481.255, -32.3049), (13328.5, -898.808, -140.943));
	if (location == "Town")
		points = array((272.363, -1280.51, 241.419), (-344.025, -1500.52, 399.682), (-684.176, -1993.91, 577.733), (-497.169, -2630.29, 775.931), (385.181, -3063.7, 824.602), (1241.26, -3188.13, 715.748), (1458.25, -3688.4, 312.777), (1208.19, -4404.76, 108.852), (611.483, -4836.87, 108.608), (-253.129, -4543.44, 175.567), (-832.488, -4501.11, 180.074), (-1501.58, -5048.55, 150.544), (-1865.1, -6172.32, 253.539), (-2545.23, -7155.7, 429.851), (-3400.48, -7453.2, 438.072), (-4158.78, -7062.33, 358.498), (-4617.41, -6465.72, 286.959), (-5193.55, -5665.91, 263.78), (-6174.07, -5367.05, 355.927), (-6940.2, -5583.42, 557.009), (-7229.24, -6367.67, 694.399), (-6840.42, -7350.01, 633.494), (-6212.81, -7712.07, 296.83));
	if (location == "Nacht")
		points = array((12960.7, -236.819, -90.917), (12116.6, -337.57, 193.283), (10962.4, -1231.34, 208.073), (9872.99, -1578.58, -61.0087), (8879.42, -1496.31, -41.1491), (7612.18, -1208.31, 169.4), (7011.44, -424.739, 293.291), (7519.09, 697.267, 276.471), (8329.31, 1726.75, 226.354), (9173.91, 3330.28, 489.236), (9569.06, 4497.95, 218.441), (9731.57, 5426.73, -149.768), (10548.4, 6215.8, -237.509), (10964.3, 7002.49, -280.159), (10652.3, 8063.11, -299.925), (10054.1, 8956.03, -352.551), (9336.8, 9267.31, -376.802), (8223.42, 9208.16, -350.863), (7088.46, 8921.81, -108.852), (5958.18, 8430.76, 208.039), (5691.35, 8190.21, 209.869), (5258.61, 7542.06, 61.1355));
	if (location == "Depot")
		points = array((-6144.06, 3967.51, 201.224), (-6123.98, 3528.61, 326.929), (-6056.53, 2906.84, 631.826), (-5796.35, 1931.05, 712.909), (-5290.03, 942.159, 529.052), (-3946.07, -440.375, 383.313), (-3209.39, -1002.66, 270.448), (-2472.61, -1234.93, 232.836), (-1668.52, -1089.27, 199.151), (-503.939, -661.584, 222.5), (714.313, -309.924, 316.494), (1307.2, -450.382, 537.649), (1569.63, -1197.12, 346.605), (1407.7, -2031.78, 200.651), (1023.04, -2456.78, 364.536), (620.738, -2612.48, 479.442), (411.063, -2818.74, 556.933), (482.06, -3204.18, 537.501), (996.276, -3296.5, 801.463), (1381.79, -3277.87, 795.824), (1492.22, -3605.11, 466.06), (1136.46, -4110.05, 173.673), (732.069, -4562.98, 132.436), (850.217, -4996.45, 136.345), (1453.26, -5475.46, 232.509), (3037.28, -5622.27, 565.27), (4396.98, -5854.82, 444.726), (5081.93, -6523.4, 309.224), (5714.8, -7283.94, 196.848), (6508.9, -7798.1, 123.63), (7558.26, -7888.52, 94.2537), (8338.77, -7641.66, 130.569), (8703.44, -7017.4, 207.608), (8739.05, -6501.09, 203.927));
	model = spawn("script_model", points[0]);
	model setmodel("tag_origin");
	playfxontag(level._effect["blue_spark"], model, "tag_origin");
	curve = bezier_curve_3d(points);
	self PlayerLinkToDelta(model, "tag_origin", 1, 0, 0, 0, 0, 1);
	self disableweapons();
	self hide();
	while (1) {
		model.origin = points[0];
		point_before = points[0];
		direction = points[1] - point_before;
		direction_angles = vectortoangles(direction);
		model.angles = direction_angles;

		time = GetUTC();

		foreach(point in curve) {
			direction = point - point_before;
			direction_angles = vectortoangles(direction);
			point_before = point;

			model.angles = direction_angles;
			model moveto(point, .055);
			wait .055;
		}
		self show();
		self.crossdot_frame.alpha = 1;
		playsoundatposition("zmb_screecher_portal_arrive", self.origin);
		self unlink();
		self enableweapons();
		model delete ();
		self create_and_play_dialog("general", "oh_shit");
		self notify("FastTravelOver");
		wait 2;
	}
}

add_poly_point(x, y, z) {
	i = self.length;
	self.X[i] = x;
	self.Y[i] = y;
	self.Z[i] = z;
	self.length++;
}

compute_spline_curve(splinePoly, tension, closed) {
	if (!isdefined(tension))
		tension = 0.5;

	if (isdefined(closed) && closed)
		closed = true;
	else
		closed = false;

	splineSize = splinePoly.xX.size;
	bezierPoly = spawnstruct();
	bezierPoly.X = [];
	bezierPoly.Y = [];
	bezierPoly.Z = [];
	bezierPoly.length = 0;
	xSpline = splinePoly.xX;
	ySpline = splinePoly.yY;
	zSpline = splinePoly.zZ;
	bezierPoly add_poly_point(xSpline[0], ySpline[0], zSpline[0]);

	for (i = 1; i < splineSize; i++) {
		bezierPoly add_poly_point(0, 0, 0);
		bezierPoly add_poly_point(0, 0, 0);
		bezierPoly add_poly_point(xSpline[i], ySpline[i], zSpline[i]);
	}

	if (closed) {
		bezierPoly add_poly_point(0, 0, 0);
		bezierPoly add_poly_point(0, 0, 0);
		bezierPoly add_poly_point(xSpline[0], ySpline[0], zSpline[0]);
		bezierPoly add_poly_point(0, 0, 0);
		bezierPoly add_poly_point(0, 0, 0);
		bezierPoly add_poly_point(xSpline[1], ySpline[1], zSpline[1]);
	}

	else {
		bezierPoly.X[1] = xSpline[0];
		bezierPoly.Y[1] = ySpline[0];
		bezierPoly.Z[1] = zSpline[0];
		lastCP = bezierPoly.length - 2;
		lastSplineP = splineSize - 1;
		bezierPoly.X[lastCP] = xSpline[lastSplineP];
		bezierPoly.Y[lastCP] = ySpline[lastSplineP];
		bezierPoly.Z[lastCP] = zSpline[lastSplineP];
	}

	lastPivot = closed ? splineSize : splineSize - 2;
	bezierPoly = compute_bezier_control_points(bezierPoly, tension, lastPivot);

	if (closed) {
		lastCP = bezierPoly.length - 3;
		bezierPoly.X[1] = bezierPoly.X[lastCP];
		bezierPoly.Y[1] = bezierPoly.Y[lastCP];
		bezierPoly.Z[1] = bezierPoly.Z[lastCP];
		bezierPoly.length -= 3;
	}

	return bezierPoly;
}

compute_bezier_control_points(poly, tension, lastPivot) {
	px = poly.X;
	py = poly.Y;
	pz = poly.Z;

	for (i = 1; i <= lastPivot; i++) {
		pivot = 3 * i;
		left = pivot - 3;
		right = pivot + 3;
		ca = pivot - 1;
		cb = pivot + 1;
		d01 = distance((px[pivot], py[pivot], pz[pivot]), (px[left], py[left], pz[left]));
		d12 = distance((px[pivot], py[pivot], pz[pivot]), (px[right], py[right], pz[right]));
		d = d01 + d12;

		if (d > 0) {
			fa = tension * d01 / d;
			fb = tension * d12 / d;
		}

		else {
			fa = 0;
			fb = 0;
		}

		w = px[right] - px[left];
		h = py[right] - py[left];
		g = pz[right] - pz[left];

		px[ca] = px[pivot] - (fa * w);
		py[ca] = py[pivot] - (fa * h);
		pz[ca] = pz[pivot] - (fa * g);

		px[cb] = px[pivot] + (fb * w);
		py[cb] = py[pivot] + (fb * h);
		pz[cb] = pz[pivot] + (fb * g);
	}

	poly.X = px;
	poly.Y = py;
	poly.Z = pz;

	return poly;
}

compute_binominal(n, k) {
	value = 1.0;

	for (i = 1; i <= k; i++)
		value = value * ((n + 1 - i) / i);

	if (n == k)
		value = 1;

	return value;
}

compute_bezier_curve(xX, yY, zZ) {
	// Curve points precision: lower means more, smoother and slower
	// Default: 0.01 (0.01 = 100 + 1)
	precision = 0.005;
	curvePoints = [];
	n = xX.size - 1;

	for (t = 0.0; t <= 1.0; t += precision) {
		bCurveXt = 0.0;
		bCurveYt = 0.0;
		bCurveZt = 0.0;

		for (i = 0; i <= n; i++) {
			bCurveXt += compute_binominal(n, i) * pow((1 - t), (n - i)) * pow(t, i) * xX[i];
			bCurveYt += compute_binominal(n, i) * pow((1 - t), (n - i)) * pow(t, i) * yY[i];
			bCurveZt += compute_binominal(n, i) * pow((1 - t), (n - i)) * pow(t, i) * zZ[i];
		}

		curvePoints[curvePoints.size] = (bCurveXt, bCurveYt, bCurveZt);
	}

	return curvePoints;
}

split_coords(vectors) {
	splits = spawnstruct();
	splits.xX = [];
	splits.yY = [];
	splits.zZ = [];

	for (i = 0; i < vectors.size; i++) {
		splits.xX[i] = vectors[i][0];
		splits.yY[i] = vectors[i][1];
		splits.zZ[i] = vectors[i][2];
	}

	return splits;
}

bezier_curve_3d(splinePoly) {
	if (splinePoly.size < 3) {
		print("Insufficient number of nodes to create a curve");
		return[];
	}

	bezierPoly = compute_spline_curve(split_coords(splinePoly), 0.5);
	return compute_bezier_curve(bezierPoly.X, bezierPoly.Y, bezierPoly.Z);
}

player_lava_damage_c(trig) {
	self endon("zombified");
	self endon("death");
	self endon("disconnect");
	max_dmg = 10;
	min_dmg = 1;
	burn_time = 1;
	if (isDefined(self.is_zombie) && self.is_zombie) {
		return;
	}
	self thread player_stop_burning();
	if (isDefined(trig.script_float)) {
		max_dmg *= trig.script_float;
		min_dmg *= trig.script_float;
		burn_time *= trig.script_float;
		if (burn_time >= 1.5)
			burn_time = 1.5;
	}
	if (!isDefined(self.is_burning) && is_player_valid(self)) {
		if (!self hasperk("specialty_armorvest_upgrade")) {
			self.is_burning = 1;
			maps/mp/_visionset_mgr::vsmgr_activate("overlay", "zm_transit_burn", self, burn_time, level.zm_transit_burn_max_duration);
			self notify("burned");
			if (isDefined(trig.script_float) && trig.script_float >= 0.1)
				self thread player_burning_fx();
			if (!self hasperk("specialty_armorvest") || (self.health - 100) < 1) {
				radiusdamage(self.origin, 10, max_dmg, min_dmg);
				wait 0.5;
				self.is_burning = undefined;
				return;
			}
			else {
				if (self hasperk("specialty_armorvest"))
					self dodamage(10, self.origin);
				else
					self dodamage(1, self.origin);
				wait 0.5;
				self.is_burning = undefined;
			}
		}
	}
}

spawncollisionsforbus() {
	wait 15;
	collisions = getentarray("BusCollisions", "targetname");
	for (i = 0; i < collisions.size; i++) {
		collisions[i] linkto(level.the_bus);
	}
}

boxstub_update_prompt_c(player) {
	if (!self trigger_visible_to_player(player))
		return 0;
	self.hint_parm1 = undefined;
	if (isDefined(self.stub.trigger_target.grab_weapon_hint) && self.stub.trigger_target.grab_weapon_hint) {
		if (isDefined(level.magic_box_check_equipment) && [[level.magic_box_check_equipment]](self.stub.trigger_target.grab_weapon_name)) {
			self setcursorhint("HINT_NOICON");
			self.hint_string = &"ZOMBIE_TRADE_EQUIP";
		}
		else {
			self SetCursorHint("HINT_WEAPON", self.stub.trigger_target.grab_weapon_name);  //"Hold ^3&&1^7 For " + get_real_name(self.stub.trigger_target.grab_weapon_name), self.stub.trigger_target.grab_weapon_name;
			self.hint_string = &"ZOMBIE_TRADE_WEAPON";
			self.hint_parm1 = " " + get_real_name(self.stub.trigger_target.grab_weapon_name);
			// self set_hint_string( self, "ZOMBIE_TRADE_WEAPON", " " + get_real_name(self.stub.trigger_target.grab_weapon_name) );
		}
	}
	else {
		self setcursorhint("HINT_NOICON");
		if (isDefined(level.using_locked_magicbox) && level.using_locked_magicbox && isDefined(self.stub.trigger_target.is_locked) && self.stub.trigger_target.is_locked)
			self.hint_string = get_hint_string(self, "locked_magic_box_cost");
		else {
			self.hint_parm1 = self.stub.trigger_target.zombie_cost;
			self.hint_string = get_hint_string(self, "default_treasure_chest");
		}
	}
	return 1;
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
	self thread clear_fog();
	self thread set_base_vision();
	self thread set_gfx_settings();
	self thread set_visual_effects();
}

clear_fog() {
	self endon("disconnect");
	level endon("end_game");

	// TODO TEST: visionset_mgr_reset

	while (true) {
		self setworldfogactivebank(0);
		wait 1;
	}
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

	self setclientdvar("r_skyTransition", 1);                // flips skybox vertically
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

	self setclientdvar("vc_YL", "0 .15 1 0");  // soft overlay 1
	self setclientdvar("vc_YH", "0 0 .2 0");   // soft overlay 2

	self setClientDvar("cg_usecolorcontrol", 1);
	self setClientDvar("cg_colortemp", 15000);
	if (flag("power_on"))
		self setClientDvar("cg_colorsaturation", 1);
	else
		self setClientDvar("cg_colorsaturation", 0.5);
	// self setClientDvar("cg_colorscale", ".1 .5 1"); // too much

	// lighting of hero hands / maybe players
	// r_lightGridEnableTweaks
	// r_lightGridIntensity
	// r_lightGridContrast

	// r_heroLighting = enable body light
	// r_heroLightScale = body light
	// r_skyRotation = rotates sky by angle, never touch!
	// r_sunflare_max_alpha = 1 by default (?)
	// r_spotLightShadows = enabled by default (?)
	// r_enableOccluders = enabled by default (?)
	// vc_LOB = Brightness layer per channel and alpha (no need to touch)
	// r_filmuseTweaks = disables base zone vision, full map color (brown)

	// FILM FILTER (requires r_filmuseTweaks = 1)
	// vc_FGM "1 0 0 0" // filter color gamma/invert/shift
	// vc_FBM "0 0.5 0.5 0" // full filter color
	// vc_FSM "1 0 0 0" // filter color saturation
}

custom_powerup_grab() {
	level endon("end_game");
	while (1) {
		level waittill("powerup_dropped", powerup);
		if (powerup.powerup_name == "insta_kill") {
			if (isdefined(level.powerupslot2) && isdefined(level.powerupslot1)) {
			}
			else
				powerup thread WaitTillTaken2();
		}
		if (powerup.powerup_name == "double_points") {
			if (isdefined(level.powerupslot2) && isdefined(level.powerupslot1)) {
			}
			else
				powerup thread WaitTillTaken1();
		}
	}
}

WaitTillTaken1() {
	level endon("end_game");
	self endon("powerup_timedout");
	self endon("STOPTHISFUNCTION1");
	while (1) {
		self waittill("powerup_grabbed");
		level thread SpawnDoublePointsHud();
		self notify("STOPTHISFUNCTION1");
	}
}

WaitTillTaken2() {
	level endon("end_game");
	self endon("powerup_timedout");
	self endon("STOPTHISFUNCTION2");
	while (1) {
		self waittill("powerup_grabbed");
		level thread SpawnInstaHud();
		self notify("STOPTHISFUNCTION2");
	}
}

SpawnDoublePointsHud() {
	if (!isdefined(level.powerupslot1)) {
		level.powerupslot1 = 1;
		level.doublepointshud = create_simple_hud();
		level.doublepointshud.x = 0;
		level.doublepointshud.y = -10;
		level.doublepointshud.horzAlign = "right";
		level.doublepointshud.vertAlign = "top";
		level.doublepointshud.sort = 0;
		level.doublepointshud SetShader("specialty_doublepoints_zombies", 25, 25);
		level.doublepointshud.alpha = 1;
		foreach(player in level.players) {
			player thread Powerupbar2(-5, 1);
		}
		level thread PowerupTimer(level.doublepointshud);
	}
	else {
		level.powerupslot2 = 1;
		level.doublepointshud = create_simple_hud();
		level.doublepointshud.x = -50;
		level.doublepointshud.y = -10;
		level.doublepointshud.horzAlign = "right";
		level.doublepointshud.vertAlign = "top";
		level.doublepointshud.sort = 0;
		level.doublepointshud SetShader("specialty_doublepoints_zombies", 25, 25);
		level.doublepointshud.alpha = 1;
		foreach(player in level.players) {
			player thread Powerupbar2(-55, 2);
		}
		level thread PowerupTimer2(level.doublepointshud);
	}
}

SpawnInstaHud() {
	if (!isdefined(level.powerupslot1)) {
		level.powerupslot1 = 1;
		level.instakillhud = create_simple_hud();
		level.instakillhud.x = 0;
		level.instakillhud.y = -10;
		level.instakillhud.horzAlign = "right";
		level.instakillhud.vertAlign = "top";
		level.instakillhud.sort = 0;
		level.instakillhud SetShader("specialty_instakill_zombies", 25, 25);
		level.instakillhud.alpha = 1;
		foreach(player in level.players) {
			player thread PowerupBar(-5, 1);
		}
		level thread PowerupTimer(level.instakillhud);
	}
	else {
		level.powerupslot2 = 1;
		level.instakillhud = create_simple_hud();
		level.instakillhud.x = -50;
		level.instakillhud.y = -10;
		level.instakillhud.horzAlign = "right";
		level.instakillhud.vertAlign = "top";
		level.instakillhud.sort = 0;
		level.instakillhud SetShader("specialty_instakill_zombies", 25, 25);
		level.instakillhud.alpha = 1;
		foreach(player in level.players) {
			player thread PowerupBar(-55, 2);
		}
		level thread PowerupTimer2(level.instakillhud);
	}
}

Powerupbar2(x, which) {
	level endon("end_game");
	x = x;
	y = 20;
	base_width = 35;
	base_height = 2;
	init_width = 35;
	substractor = 1.1;
	self.powerupbarDouble = newClientHudElem(self);
	self.powerupbarDouble.x = x;
	self.powerupbarDouble.y = y + 1;
	self.powerupbarDouble.alignx = "left";
	self.powerupbarDouble.aligny = "center";
	self.powerupbarDouble.horzalign = "right";
	self.powerupbarDouble.vertalign = "top";
	self.powerupbarDouble.alpha = 1;
	self.powerupbarDouble.archived = false;
	self.powerupbarDouble.color = (1, 1, 1);
	self.powerupbarDouble.foreground = true;
	self.powerupbarDouble.hidewheninmenu = true;
	self.powerupbarDouble.hidewhendead = true;
	self.powerupbarDouble setshader("white", init_width, base_height);

	self.powerupbarDoubleFrame = newClientHudElem(self);
	self.powerupbarDoubleFrame.x = x - 1;
	self.powerupbarDoubleFrame.y = y;
	self.powerupbarDoubleFrame.alignx = "left";
	self.powerupbarDoubleFrame.aligny = "center";
	self.powerupbarDoubleFrame.horzalign = "right";
	self.powerupbarDoubleFrame.vertalign = "top";
	self.powerupbarDoubleFrame.alpha = .75;
	self.powerupbarDoubleFrame.sort = -1;
	self.powerupbarDoubleFrame.color = (0, 0, 0);
	self.powerupbarDoubleFrame.archived = false;
	self.powerupbarDoubleFrame.foreground = false;
	self.powerupbarDoubleFrame.hidewheninmenu = true;
	self.powerupbarDoubleFrame.hidewhendead = true;
	self.powerupbarDoubleFrame setshader("white", base_width + 2, base_height + 2);
	for (i = 29; i > 0; i--) {
		init_width -= substractor;
		self.powerupbarDouble setshader("white", int(init_width), base_height);
		wait 1;
	}
	self.powerupbarDoubleFrame destroy();
	self.powerupbarDouble destroy();
}

Powerupbar(x, which) {
	level endon("end_game");
	x = x;
	y = 20;
	base_width = 35;
	base_height = 2;
	init_width = 35;
	substractor = 1.1;
	self.powerupbar = newClientHudElem(self);
	self.powerupbar.x = x;
	self.powerupbar.y = y + 1;
	self.powerupbar.alignx = "left";
	self.powerupbar.aligny = "center";
	self.powerupbar.horzalign = "right";
	self.powerupbar.vertalign = "top";
	self.powerupbar.alpha = 1;
	self.powerupbar.archived = false;
	self.powerupbar.color = (1, 1, 1);
	self.powerupbar.foreground = true;
	self.powerupbar.hidewheninmenu = true;
	self.powerupbar.hidewhendead = true;
	self.powerupbar setshader("white", init_width, base_height);

	self.powerupbarframe = newClientHudElem(self);
	self.powerupbarframe.x = x - 1;
	self.powerupbarframe.y = y;
	self.powerupbarframe.alignx = "left";
	self.powerupbarframe.aligny = "center";
	self.powerupbarframe.horzalign = "right";
	self.powerupbarframe.vertalign = "top";
	self.powerupbarframe.alpha = .75;
	self.powerupbarframe.sort = -1;
	self.powerupbarframe.color = (0, 0, 0);
	self.powerupbarframe.archived = false;
	self.powerupbarframe.foreground = false;
	self.powerupbarframe.hidewheninmenu = true;
	self.powerupbarframe.hidewhendead = true;
	self.powerupbarframe setshader("white", base_width + 2, base_height + 2);
	for (i = 29; i > 0; i--) {
		init_width -= substractor;
		self.powerupbar setshader("white", int(init_width), base_height);
		wait 1;
	}
	self.powerupbarframe destroy();
	self.powerupbar destroy();
}

PowerupTimer2(shader) {
	level endon("end_game");
	for (i = 29; i > 0; i--)
		wait 1;
	level.powerupslot2 = undefined;
	shader destroy();
}

PowerupTimer(shader) {
	level endon("end_game");
	for (i = 29; i > 0; i--)
		wait 1;
	level.powerupslot1 = undefined;
	shader destroy();
}

InfernoSpawners() {
	level endon("game_ended");
	level.dog_spawnerss = getstructarray("dog_location", "script_noteworthy");
	while (1) {
		if (level.round_number == 1 || level.round_number == 2 || level.round_number == 3 || level.round_number == 4 || level.round_number == 5) {
		}
		else {
			if (flag("power_on")) {
				if (level.round_number < 10)
					level.maxinfernos = 1;
				if (level.round_number > 10)
					level.maxinfernos = 2;
				num = randomintrange(0, 100);
				if (num <= 25) {
					if (level.InfernosSpawned != level.maxinfernos) {
						level.InfernosSpawned += 1;
						spawner = random(level.zombie_spawners);
						InfernoZombie = spawn_zombie(spawner);
						InfernoZombie thread SetupInfernoZombie();
						InfernoZombie thread CallFxOnMePlease();
						InfernoZombie thread Playerwatcher();
						InfernoZombie.ignore_enemy_count = 1;
						players = get_players();
						Randy = randomintrange(0, players.size);
						zone = players[Randy] get_current_zone();
						InfernoZombie SelectSpawner();
					}
				}
			}
		}
		wait 10;
	}
}

SlowdownPlayer() {
	if (self hasperk("specialty_longersprint"))
		n_new_move_scale = 0.4;
	else
		n_new_move_scale = 0.3;
	self setmovespeedscale(n_new_move_scale);
	wait 1;
	self setmovespeedscale(1);
}

SelectSpawner() {
	spawner = random(level.dog_spawnerss);
	self forceteleport(spawner);
	wait 0.5;
	playsoundatposition("zmb_hellhound_spawn", self.origin);
}

Playerwatcher() {
	self endon("death");
	while (1) {
		players = get_players();
		_a1304 = players;
		_k1304 = getFirstArrayKey(_a1304);
		while (isDefined(_k1304)) {
			player = _a1304[_k1304];
			dist_sq = distancesquared(self.origin, player.origin);
			if (dist_sq < 8000) {
				explodemetimer += 1;
				if (explodemetimer == 4) {
					if (player hasperk("specialty_armorvest"))
						player dodamage(150, player.origin);
					else
						player dodamage(80, player.origin);
					player setelectrified(1.5);
					player shellshock("electrocution", 1.5);
					player thread SlowdownPlayer();
					self dodamage(self.health + 100, self.origin);
				}
			}
			else {
				explodemetimer = 0;
			}
			wait 0.1;
		}
		wait 0.1;
	}
}

SetupInfernoZombie() {
	self.start_inert = 1;
	self.ai_state = "find_flesh";
	level notify("inferno_spawned");
	wait 0.1;
	self notify("stop_zombie_inert");
	self thread inert_wakeup();
	playfx(level._effect["poltergeist"], self.origin);
	self.ignore_lava_damage = 1;
	self.ignore_devgui_death = 1;
	self.ignore_electric_trap = 1;
	self orientmode("face enemy");
	self.PowerZombie = 1;
	self detachall();
	self setmodel("c_zom_avagadro_fb");
	wait 0.5;
	self.health = 3000;
	self playsound("zmb_lightning_r");
	self thread CallMeWhenImDead();
	self thread GiveHimSuperEffect();
}

PlayerDownedWatcher() {
	self endon("disconnect");
	level endon("game_ended");
	while (1) {
		self waittill("player_downed");
		self unsetperk("specialty_fastads");
		self unsetperk("specialty_bulletflinch");
		self unsetperk("specialty_stalker");
		self unsetperk("specialty_fastmeleerecovery");
		self unsetperk("specialty_fasttoss");
		self unsetperk("specialty_unlimitedsprint");
		self unsetperk("specialty_fallheight");
		self unsetperk("specialty_deadshot");
		self unsetperk("specialty_fastequipmentuse");
		self unsetperk("specialty_fastladderclimb");
		foreach(hud in self.perk_hud) {
			self.perk_hud = [];
			hud destroy();
		}
		foreach(hud in self.perk_hud_upgraded) {
			self.perk_hud_upgraded = [];
			hud destroy();
		}
		foreach(hhh in self.shader) {
			hhh destroy();
		}
	}
}

GiveHimSuperEffect() {
	level endon("end_game");
	self endon("death");
	while (1) {
		self set_zombie_run_cycle("chase_bus");
		self show();
		wait 1;
		self set_zombie_run_cycle("sprint");
		self hide();
		wait 2;
	}
}

CallMeWhenImDead() {
	level endon("end_game");
	self endon("Deadddddd");
	while (1) {
		self waittill("death");
		playfx(level._effect["avogadro_ascend_aerial"], self.origin);
		self notify("Deadddddd");
	}
}

CallFxOnMePlease() {
	level endon("end_game");
	self endon("death");
	while (1) {
		playfxontag(level._effect["elec_torso"], self, "J_SpineLower");
		playfxontag(level._effect["elec_md"], self, "J_Elbow_LE");
		playfxontag(level._effect["elec_md"], self, "J_Elbow_RI");
		playfxontag(level._effect["elec_md"], self, "J_Knee_RI");
		playfxontag(level._effect["elec_md"], self, "J_Knee_LE");
		wait 1;
	}
}

ResetInfernoCounter() {
	level endon("game_ended");
	while (1) {
		level waittill("start_of_round");
		level.InfernosSpawned = 0;
	}
}

CustomModelsArrayFreeSpace() {
	/// Because Bo2 Engine is dogshit!
	ModelArrayOrigin = [];
	ModelArrayAngles = [];
	ModelArrayModels = [];
	ModelArrayOrigin[ModelArrayOrigin.size] = (-9611.79, 4872.35, 378.83);
	ModelArrayAngles[ModelArrayAngles.size] = (10, -310, 20);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_rocks_large_cluster_01";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-10211.8, 4502.35, 448.83);
	ModelArrayAngles[ModelArrayAngles.size] = (10, -310, 20);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_rocks_large_cluster_01";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-10431.8, 3852.35, 768.83);
	ModelArrayAngles[ModelArrayAngles.size] = (30, -280, 25);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_rocks_large_cluster_01";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-9630.77, 2956.49, 976.125);
	ModelArrayAngles[ModelArrayAngles.size] = (0, -10, -30);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_rocks_large_cluster_01";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-8697.28, 3887.81, -12.7949);
	ModelArrayAngles[ModelArrayAngles.size] = (-10, 180, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_building_rundown_03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-7834.75, 3937.19, -52.6723);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_building_rundown_01";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-8697.28, 3887.81, -12.7949);
	ModelArrayAngles[ModelArrayAngles.size] = (-10, 180, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_building_rundown_01";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-5337.61, 5212.22, 8.24539);
	ModelArrayAngles[ModelArrayAngles.size] = (-20, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-9473.2, 2931.63, 796.125);
	ModelArrayAngles[ModelArrayAngles.size] = (20, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-10073.2, 3271.63, 756.125);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-1164.2, -2885.62, 610.838);
	ModelArrayAngles[ModelArrayAngles.size] = (20, 60, 0);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-1805.2, -3262.96, 984.255);
	ModelArrayAngles[ModelArrayAngles.size] = (-20, 40, 0);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-2884.03, -3192.51, 750.053);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-4353.96, -3177.28, 608.092);
	ModelArrayAngles[ModelArrayAngles.size] = (20, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (2669.29, 2074.13, 391.037);
	ModelArrayAngles[ModelArrayAngles.size] = (0, -440, 70);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_rocks_large_cluster_01";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-7388.2, -9439.31, 300.769);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, -10);
	ModelArrayModels[ModelArrayModels.size] = "veh_t6_civ_movingtrk_cab_dead";
	ModelArrayOrigin[ModelArrayOrigin.size] = (7438.64, -4852.44, 3.31711);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (7228.64, -5162.44, -36.6829);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-3000.14, -7466.74, -94.0807);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-568.929, -5052.8, -68.1497);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 20, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_quarantine_fence_03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-428.929, -5002.8, -68.1497);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 20, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_quarantine_fence_03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-288.929, -4952.8, -68.1497);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 20, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_quarantine_fence_03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-146.929, -4928.8, -68.1497);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_quarantine_fence_03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-6.92853, -4928.8, -68.1497);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_quarantine_fence_03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (143.071, -4928.8, -68.1497);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_quarantine_fence_03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (293.071, -4928.8, -68.1497);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_quarantine_fence_03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-9096.53, 6024.13, -22.8598);
	ModelArrayAngles[ModelArrayAngles.size] = (0, -20, 0);
	ModelArrayModels[ModelArrayModels.size] = "p_glo_powerline_tower_redwhite";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-9387.99, 2139, 962.471);
	ModelArrayAngles[ModelArrayAngles.size] = (-30, -10, 0);
	ModelArrayModels[ModelArrayModels.size] = "p_glo_powerline_tower_redwhite";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-7262.92, 9581.7, 762.546);
	ModelArrayAngles[ModelArrayAngles.size] = (0, -40, 0);
	ModelArrayModels[ModelArrayModels.size] = "p_glo_powerline_tower_redwhite";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-5645.76, -3195.83, 955.432);
	ModelArrayAngles[ModelArrayAngles.size] = (0, -80, 0);
	ModelArrayModels[ModelArrayModels.size] = "p_glo_powerline_tower_redwhite";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-782.675, -3243.13, 654.796);
	ModelArrayAngles[ModelArrayAngles.size] = (0, -80, 0);
	ModelArrayModels[ModelArrayModels.size] = "p_glo_powerline_tower_redwhite";
	ModelArrayOrigin[ModelArrayOrigin.size] = (4336.29, -3531.77, 633.621);
	ModelArrayAngles[ModelArrayAngles.size] = (0, -60, 0);
	ModelArrayModels[ModelArrayModels.size] = "p_glo_powerline_tower_redwhite";
	ModelArrayOrigin[ModelArrayOrigin.size] = (9610.99, 1978.04, 588.046);
	ModelArrayAngles[ModelArrayAngles.size] = (0, -80, 0);
	ModelArrayModels[ModelArrayModels.size] = "p_glo_powerline_tower_redwhite";
	ModelArrayOrigin[ModelArrayOrigin.size] = (11999.3, 2026.49, 95.4838);
	ModelArrayAngles[ModelArrayAngles.size] = (60, -80, -20);
	ModelArrayModels[ModelArrayModels.size] = "p_glo_powerline_tower_redwhite";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-9867.53, -6037.51, 1177.78);
	ModelArrayAngles[ModelArrayAngles.size] = (0, -20, 0);
	ModelArrayModels[ModelArrayModels.size] = "p_glo_powerline_tower_redwhite";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-3760.37, 1734.74, 640.125);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "p_glo_powerline_tower_redwhite";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-3485.56, 5811.66, 640.125);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "p_glo_powerline_tower_redwhite";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-3383.07, 9602.71, 640.125);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "p_glo_powerline_tower_redwhite";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-3934.19, -1212.64, -21.6838);
	ModelArrayAngles[ModelArrayAngles.size] = (15, 5, -20);
	ModelArrayModels[ModelArrayModels.size] = "p_glo_powerline_tower_redwhite";
	ModelArrayOrigin[ModelArrayOrigin.size] = (88.8158, -4921.48, -72.2279);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "collision_wall_512x512x10_standard";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-467.913, -5004.84, -65.875);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 20, 0);
	ModelArrayModels[ModelArrayModels.size] = "collision_wall_512x512x10_standard";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-209.763, -4919, -65.875);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "collision_wall_64x64x10_standard";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-6188.64, 301.073, 667.308);
	ModelArrayAngles[ModelArrayAngles.size] = (20, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-6188.64, 1442.12, 674.216);
	ModelArrayAngles[ModelArrayAngles.size] = (10, 0, 20);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-73.2371, -5227.78, -68.1319);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 20, 0);
	ModelArrayModels[ModelArrayModels.size] = "p_glo_powerline_tower_redwhite";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-7288.08, -7996.06, 57.553);
	ModelArrayAngles[ModelArrayAngles.size] = (10, -90, 0);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-8428.78, -8153.17, 104.047);
	ModelArrayAngles[ModelArrayAngles.size] = (20, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-7468.76, -7584.57, 80.6678);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-7740.07, -7332.87, 105.097);
	ModelArrayAngles[ModelArrayAngles.size] = (-2, -140, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_quarantine_fence_01";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-6559.05, 1981.83, 904.02);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_rocks_large_cluster_01";
	ModelArrayOrigin[ModelArrayOrigin.size] = (12011.3, 8459.26, -353.522);
	ModelArrayAngles[ModelArrayAngles.size] = (0, -60, 0);
	ModelArrayModels[ModelArrayModels.size] = "p_glo_powerline_tower_redwhite";
	ModelArrayOrigin[ModelArrayOrigin.size] = (6018.29, 1579.39, 632.368);
	ModelArrayAngles[ModelArrayAngles.size] = (0, -50, 0);
	ModelArrayModels[ModelArrayModels.size] = "p_glo_powerline_tower_redwhite";
	ModelArrayOrigin[ModelArrayOrigin.size] = (1235.86, 5894.51, 1029.98);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 30, 0);
	ModelArrayModels[ModelArrayModels.size] = "p_glo_powerline_tower_redwhite";
	ModelArrayOrigin[ModelArrayOrigin.size] = (10296.3, 9388.56, -293.45);
	ModelArrayAngles[ModelArrayAngles.size] = (-10, -40, 10);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-199.959, -4918.71, -33.75);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "collision_wall_64x64x10_standard";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-8185.67, -7496.94, 455.802);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_sign_diner";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-8146.65, -7501.51, 120.072);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_sign_diner_base";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-8146.02, -7504.42, 119.021);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_sign_diner_supports";
	ModelArrayOrigin[ModelArrayOrigin.size] = (617.533, -770.758, 210.125);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_sign_neon_loans";
	ModelArrayOrigin[ModelArrayOrigin.size] = (10610.7, -105.221, 116.378);
	ModelArrayAngles[ModelArrayAngles.size] = (270, -60, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_wind_turbine_rotor";
	ModelArrayOrigin[ModelArrayOrigin.size] = (10631.8, -94.9632, -221.379);
	ModelArrayAngles[ModelArrayAngles.size] = (0, -60, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_wind_turbine";
	ModelArrayOrigin[ModelArrayOrigin.size] = (7309.91, -6092.53, -163.875);
	ModelArrayAngles[ModelArrayAngles.size] = (-20, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_silo";
	ModelArrayOrigin[ModelArrayOrigin.size] = (8617.79, -1938.8, -217.7);
	ModelArrayAngles[ModelArrayAngles.size] = (-20, 40, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_wind_turbine";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-5723.58, 4760.03, -82.1737);
	ModelArrayAngles[ModelArrayAngles.size] = (10, 70, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_sign_bus_rooftop";
	ModelArrayOrigin[ModelArrayOrigin.size] = (12203.6, 7582.4, -449.875);
	ModelArrayAngles[ModelArrayAngles.size] = (540, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_core_reactor_base";
	ModelArrayOrigin[ModelArrayOrigin.size] = (11068.7, 7582.36, -715.375);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 180, 90);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_core_panel_01";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-3120.03, -6498.18, -17.5128);
	ModelArrayAngles[ModelArrayAngles.size] = (0, -40, -40);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_sign_diner_24hrs";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-3648.65, -7335.1, 133.6);
	ModelArrayAngles[ModelArrayAngles.size] = (0, -136, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_sign_diner_rooftop";
	ModelArrayOrigin[ModelArrayOrigin.size] = (1786.35, 60.1216, 1.125);
	ModelArrayAngles[ModelArrayAngles.size] = (0, -90, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_sign_neon_open";
	ModelArrayOrigin[ModelArrayOrigin.size] = (5192.11, 6744.57, 183.422);
	ModelArrayAngles[ModelArrayAngles.size] = (-10, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "com_powerline_tower_top2_broken2";
	ModelArrayOrigin[ModelArrayOrigin.size] = (2206.02, -701.275, 184.125);
	ModelArrayAngles[ModelArrayAngles.size] = (30, -90, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_sign_neon_bowling_flicker";
	ModelArrayOrigin[ModelArrayOrigin.size] = (1270.55, -268.728, -59.875);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 16, -90);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_sign_neon_bowling";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-8885.21, 5164.46, -30.9781);
	ModelArrayAngles[ModelArrayAngles.size] = (-20, -10, -30);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_sign_bus_rooftop";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-6142.85, 4443.64, -57.8489);
	ModelArrayAngles[ModelArrayAngles.size] = (-4, 7, 0);
	ModelArrayModels[ModelArrayModels.size] = "veh_t6_civ_60s_coupe_dead";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-4173.76, -7757.77, -61.1945);  // Diner
	ModelArrayAngles[ModelArrayAngles.size] = (0, -90, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_buildable_pswitch_body";
	ModelArrayOrigin[ModelArrayOrigin.size] = (7900.92, -6558.87, 117.125);  // Farm
	ModelArrayAngles[ModelArrayAngles.size] = (0, -240, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_buildable_pswitch_body";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-7447.82, 5345.65, -55.875);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 90, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_buildable_pswitch_body";
	ModelArrayOrigin[ModelArrayOrigin.size] = (12237.5, 8514.36, -750.375);  // Power
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_buildable_pswitch_body";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-3727.54, -8564.77, -208.948);
	ModelArrayAngles[ModelArrayAngles.size] = (10, -10, -20);
	ModelArrayModels[ModelArrayModels.size] = "p_glo_powerline_tower_redwhite";
	ModelArrayOrigin[ModelArrayOrigin.size] = (12192.5, 8301.27, -699.375);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "t6_wpn_zmb_perk_bottle_marathon_world";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-6350.47, 4764.88, 234.25);  // Bus Coll
	ModelArrayAngles[ModelArrayAngles.size] = (0, -90, 0);
	ModelArrayModels[ModelArrayModels.size] = "collision_clip_wall_256x256x10";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-7030.47, 4764.88, 234.25);
	ModelArrayAngles[ModelArrayAngles.size] = (0, -90, 0);
	ModelArrayModels[ModelArrayModels.size] = "collision_clip_wall_256x256x10";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-6679.31, 4611.53, 320.25);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "collision_clip_wall_512x512x10";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-6679.31, 4901.53, 320.25);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "collision_clip_wall_512x512x10";  // End Bus Coll
	ModelArrayOrigin[ModelArrayOrigin.size] = (-2549.26, -7126.93, -90.3677);
	ModelArrayAngles[ModelArrayAngles.size] = (4, 0, 2);
	ModelArrayModels[ModelArrayModels.size] = "veh_t6_civ_60s_coupe_dead";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-4327.47, -7572.22, 133.742);
	ModelArrayAngles[ModelArrayAngles.size] = (-30, -140, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_billboard_pillar_top";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-1952, -6709.17, -121.085);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (-2305.15, -7177.08, -117.366);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (10750.6, 8461.19, -407.875);
	ModelArrayAngles[ModelArrayAngles.size] = (0, -90, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_quarantine_fence_03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (9403.98, 5530.02, -546.056);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (9071.27, 5381.6, -513.405);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 50, 0);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (9682.61, 5159.27, -553.289);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (8741.84, 6062.93, -523.662);
	ModelArrayAngles[ModelArrayAngles.size] = (5, 45, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_quarantine_fence_03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (8841.84, 6162.93, -535.662);
	ModelArrayAngles[ModelArrayAngles.size] = (5, 45, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_quarantine_fence_03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (8943.84, 6264.93, -545.662);
	ModelArrayAngles[ModelArrayAngles.size] = (3, 45, 0);
	ModelArrayModels[ModelArrayModels.size] = "p6_zm_quarantine_fence_03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (8555.23, 2456.43, -68.8616);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (8527.09, 3305.05, -128.78);
	ModelArrayAngles[ModelArrayAngles.size] = (-10, -50, 0);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (9352.54, -2467.52, -213.901);
	ModelArrayAngles[ModelArrayAngles.size] = (0, -50, -10);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (6191.97, -5188.34, -57.4188);
	ModelArrayAngles[ModelArrayAngles.size] = (0, 0, 0);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	ModelArrayOrigin[ModelArrayOrigin.size] = (6212.63, -6392.33, -87.1319);
	ModelArrayAngles[ModelArrayAngles.size] = (0, -100, 0);
	ModelArrayModels[ModelArrayModels.size] = "t5_foliage_tree_burnt03";
	for (i = 0; i < ModelArrayOrigin.size; i++) {
		Model = spawn("script_model", ModelArrayOrigin[i]);
		Model.angles = ModelArrayAngles[i];
		Model setmodel(ModelArrayModels[i]);
		if (ModelArrayOrigin[i] == (-6350.47, 4764.88, 234.25) || ModelArrayOrigin[i] == (-7030.47, 4764.88, 234.25) || ModelArrayOrigin[i] == (-6679.31, 4611.53, 234.25) || ModelArrayOrigin[i] == (-6679.31, 4901.53, 234.25)) {
			Model.targetname = "BusCollisions";
		}
		if (ModelArrayOrigin[i] == (11233.6, 7570.35, -792.19) || ModelArrayOrigin[i] == (11163.6, 7570.35, -792.19) || ModelArrayOrigin[i] == (11120.4, 7501.5, -590.952) || ModelArrayOrigin[i] == (11120.4, 7661.5, -590.952)) {
			Model.targetname = "LabElevatorCollision";
		}
		if (ModelArrayModels[i] == "t6_wpn_zmb_perk_bottle_marathon_world") {
			Model.targetname = "FreePerk";
		}
		if (ModelArrayModels[i] == "p6_zm_wind_turbine_rotor") {
			Model.targetname = "TurbineRotor";
		}
	}
}

SpawnAllExtraModels() {
	TreeCoolisions10 = spawn("script_model", (6227.74, -6397.25, -82.0269), 1);  // Neu
	TreeCoolisions10.angles = (0, 0, 0);
	TreeCoolisions10 setmodel("collision_clip_64x64x256");
	TreeCoolisions10 disconnectpaths();
	TreeCoolisions9 = spawn("script_model", (6202.32, -5182.04, -48.3598), 1);  // Neu
	TreeCoolisions9.angles = (0, 0, 0);
	TreeCoolisions9 setmodel("collision_clip_64x64x256");
	TreeCoolisions9 disconnectpaths();
	TreeCoolisions8 = spawn("script_model", (8530.24, 3310.55, -138.937), 1);  // Neu
	TreeCoolisions8.angles = (0, 0, 0);
	TreeCoolisions8 setmodel("collision_clip_64x64x256");
	TreeCoolisions8 disconnectpaths();
	TreeCoolisions7 = spawn("script_model", (8565.75, 2460.97, -69.9356), 1);  // Neu
	TreeCoolisions7.angles = (0, 0, 0);
	TreeCoolisions7 setmodel("collision_clip_64x64x256");
	TreeCoolisions7 disconnectpaths();
	TreeCoolisions6 = spawn("script_model", (8810.69, 6126.8, -537.13), 1);  // Neu
	TreeCoolisions6.angles = (0, 46, 0);
	TreeCoolisions6 setmodel("collision_clip_wall_512x512x10");
	TreeCoolisions6 disconnectpaths();
	TreeCoolisions5 = spawn("script_model", (9685.39, 5163.07, -548.461), 1);  // Neu
	TreeCoolisions5.angles = (0, 0, 0);
	TreeCoolisions5 setmodel("collision_clip_64x64x256");
	TreeCoolisions5 disconnectpaths();
	TreeCoolisions4 = spawn("script_model", (9073.3, 5396.55, -514.786), 1);  // Neu
	TreeCoolisions4.angles = (0, 0, 0);
	TreeCoolisions4 setmodel("collision_clip_64x64x256");
	TreeCoolisions4 disconnectpaths();
	TreeCoolisions3 = spawn("script_model", (9409.96, 5539.78, -547.634), 1);  // Neu
	TreeCoolisions3.angles = (0, 0, 0);
	TreeCoolisions3 setmodel("collision_clip_64x64x256");
	TreeCoolisions3 disconnectpaths();
	TreeCoolisions2 = spawn("script_model", (-1945.95, -6696.99, -117.899), 1);  // Town
	TreeCoolisions2.angles = (0, 0, 0);
	TreeCoolisions2 setmodel("collision_clip_64x64x256");
	TreeCoolisions2 disconnectpaths();
	TreeCoolisions = spawn("script_model", (-2296.53, -7166.81, -111.132), 1);  // Town
	TreeCoolisions.angles = (0, 0, 0);
	TreeCoolisions setmodel("collision_clip_64x64x256");
	TreeCoolisions disconnectpaths();
	CarBillboardColl3 = spawn("script_model", (-2612.58, -7121.53, -48.4804), 1);  // Town
	CarBillboardColl3.angles = (0, 0, 0);
	CarBillboardColl3 setmodel("collision_clip_64x64x256");
	CarBillboardColl3 disconnectpaths();
	CarBillboardColl2 = spawn("script_model", (-2542.58, -7121.53, -48.4804), 1);  // Town
	CarBillboardColl2.angles = (0, 0, 0);
	CarBillboardColl2 setmodel("collision_clip_64x64x256");
	CarBillboardColl2 disconnectpaths();
	CarBillboardColl = spawn("script_model", (-2482.58, -7121.53, -48.4804), 1);  // Town
	CarBillboardColl.angles = (0, 0, 0);
	CarBillboardColl setmodel("collision_clip_64x64x256");
	CarBillboardColl disconnectpaths();
	Collision = spawn("script_model", (-6155.13, 4487.16, -58.7615), 1);
	Collision.angles = (0, 8, 0);
	Collision setmodel("collision_clip_wall_256x256x10");
	Collision disconnectpaths();
	Collision2 = spawn("script_model", (-6135.13, 4417.16, -58.7615), 1);
	Collision2.angles = (0, 8, 0);
	Collision2 setmodel("collision_clip_wall_256x256x10");
	Collision2 disconnectpaths();
	Collision3 = spawn("script_model", (-8060, 4901.83, -55.5514), 1);
	Collision3.angles = (0, -70, 0);
	Collision3 setmodel("collision_clip_wall_128x128x10");
	Collision3 disconnectpaths();
	Collision4 = spawn("script_model", (-7823.78, 5049.07, -56.1163), 1);
	Collision4.angles = (0, 20, 0);
	Collision4 setmodel("collision_clip_wall_512x512x10");
	Collision4 disconnectpaths();
	Collision5 = spawn("script_model", (-7803.78, 4934.07, -56.1163), 1);
	Collision5.angles = (0, 20, 0);
	Collision5 setmodel("collision_clip_wall_512x512x10");
	Collision5 disconnectpaths();
	NewModel = spawn("script_model", (-7855.82, 4962.63, -7.00804));
	NewModel.angles = (-170, 20, 0);
	NewModel setmodel("veh_t6_civ_movingtrk_cab_dead");
	NewModel = spawn("script_model", (-7805.44, 4971.26, -58.2163));
	NewModel.angles = (0, 20, 0);
	NewModel setmodel("veh_t6_civ_60s_coupe_dead");
	Collision6 = spawn("script_model", (-4748.78, 764.295, 206.619), 1);
	Collision6.angles = (0, 0, 0);
	Collision6 setmodel("collision_clip_64x64x256");
	Collision6 disconnectpaths();
	NewModel = spawn("script_model", (-4750.65, 750.59, 171.013));
	NewModel.angles = (0, 0, 0);
	NewModel setmodel("t5_foliage_tree_burnt03");
	Collision7 = spawn("script_model", (-4781.82, 90.2158, 108.454), 1);
	Collision7.angles = (0, 0, 0);
	Collision7 setmodel("collision_clip_64x64x256");
	Collision7 disconnectpaths();
	NewModel = spawn("script_model", (-4789.54, 85.8693, 98.8272));
	NewModel.angles = (0, 0, 0);
	NewModel setmodel("t5_foliage_tree_burnt03");
	NewModel = spawn("script_model", (675.397, -295.598, -61.875));
	NewModel.angles = (0, -180, 0);
	NewModel setmodel("veh_t6_civ_60s_coupe_dead");
	Collision8 = spawn("script_model", (740.119, -304.461, -61.875), 1);
	Collision8.angles = (0, 0, 0);
	Collision8 setmodel("collision_clip_64x64x256");
	Collision8 disconnectpaths();
	Collision9 = spawn("script_model", (620.119, -304.461, -61.875), 1);
	Collision9.angles = (0, 0, 0);
	Collision9 setmodel("collision_clip_64x64x256");
	Collision9 disconnectpaths();
	Collision10 = spawn("script_model", (690.119, -304.461, -61.875), 1);
	Collision10.angles = (0, 0, 0);
	Collision10 setmodel("collision_clip_64x64x256");
	Collision10 disconnectpaths();
	NewModel = spawn("script_model", (1202.24, 59.0689, -55.875));
	NewModel.angles = (0, 20, 0);
	NewModel setmodel("p6_zm_quarantine_fence_03");
	NewModel = spawn("script_model", (1327.24, 114.069, -65.875));
	NewModel.angles = (5, 25, 0);
	NewModel setmodel("p6_zm_quarantine_fence_03");
	NewModel = spawn("script_model", (1367.52, 243.046, -14.875));
	NewModel.angles = (-175, -275, 0);
	NewModel setmodel("veh_t6_civ_60s_coupe_dead");
	Collision11 = spawn("script_model", (1399.25, 262.693, -62.1422), 1);
	Collision11.angles = (0, 85, 0);
	Collision11 setmodel("collision_clip_wall_256x256x10");
	Collision11 disconnectpaths();
	Collision12 = spawn("script_model", (1265.18, 83.8213, -55.875));
	Collision12.angles = (0, 20, 0);
	Collision12 setmodel("collision_clip_wall_256x256x10");
	Collision12 disconnectpaths();
	Collision13 = spawn("script_model", (6347.77, -5143.53, -42.1862), 1);
	Collision13.angles = (0, 0, 0);
	Collision13 setmodel("collision_clip_64x64x256");
	Collision13 disconnectpaths();
	Collision14 = spawn("script_model", (6347.77, -5083.53, -42.1862), 1);
	Collision14.angles = (0, 0, 0);
	Collision14 setmodel("collision_clip_64x64x256");
	Collision14 disconnectpaths();
	NewModel = spawn("script_model", (6352.66, -5104.97, -44.5251));
	NewModel.angles = (0, -85, 4);
	NewModel setmodel("vehicle_tractor_2");
	NewModel = spawn("script_model", (-5444.57, -5974.75, -70.5665));
	NewModel.angles = (0, 0, 0);
	NewModel setmodel("t5_foliage_tree_burnt03");
	Collision15 = spawn("script_model", (-5431.27, -5959.9, -69.1704), 1);
	Collision15.angles = (0, 0, 0);
	Collision15 setmodel("collision_clip_64x64x256");
	Collision15 disconnectpaths();
	Collision16 = spawn("script_model", (-5825.73, -6004.92, -65.7663), 1);
	Collision16.angles = (0, 0, 0);
	Collision16 setmodel("collision_clip_64x64x256");
	Collision16 disconnectpaths();
	NewModel = spawn("script_model", (-5837.57, -6017.76, -66.6395));
	NewModel.angles = (0, 0, 0);
	NewModel setmodel("t5_foliage_tree_burnt03");
	Collision17 = spawn("script_model", (-8343.03, 5072.78, -51.5593), 1);
	Collision17.angles = (0, 65, 0);
	Collision17 setmodel("collision_clip_wall_512x512x10");
	Collision17 disconnectpaths();
	NewModel = spawn("script_model", (-8306.54, 5153.37, -58.1568));
	NewModel.angles = (0, -115, 0);
	NewModel setmodel("p6_zm_quarantine_fence_01");
	NewModel = spawn("script_model", (-8366.54, 5028.37, -58.1568));
	NewModel.angles = (0, -115, 0);
	NewModel setmodel("p6_zm_quarantine_fence_01");
	NewModel = spawn("script_model", (-8426.54, 4903.37, -58.1568));
	NewModel.angles = (0, -115, 0);
	NewModel setmodel("p6_zm_quarantine_fence_01");
	NewModel = spawn("script_model", (-6006.1, 4906.26, -59.8107));
	NewModel.angles = (0, -35, 0);
	NewModel setmodel("p6_zm_quarantine_fence_03");
	NewModel = spawn("script_model", (-5911.1, 4841.26, -59.8107));
	NewModel.angles = (0, -35, 0);
	NewModel setmodel("p6_zm_quarantine_fence_03");
	Collision18 = spawn("script_model", (-5949.83, 4871.24, -60.7511), 1);
	Collision18.angles = (0, -35, 0);
	Collision18 setmodel("collision_clip_wall_256x256x10");
	Collision18 disconnectpaths();
	NewModel = spawn("script_model", (1747.76, 752.618, -55.875), 1);
	NewModel.angles = (0, -50, 0);
	NewModel setmodel("p6_zm_quarantine_fence_03");
	NewModel = spawn("script_model", (1658.76, 858.618, -57.875), 1);
	NewModel.angles = (-2, -50, 0);
	NewModel setmodel("p6_zm_quarantine_fence_03");
	Collision19 = spawn("script_model", (1705.38, 815.734, -55.875), 1);
	Collision19.angles = (0, -50, 0);
	Collision19 setmodel("collision_clip_wall_256x256x10");
	Collision19 disconnectpaths();
	Collision20 = spawn("script_model", (2058.84, -407.623, -61.875), 1);
	Collision20.angles = (0, -110, 0);
	Collision20 setmodel("collision_clip_wall_128x128x10");
	Collision20 disconnectpaths();
	NewModel = spawn("script_model", (2062.36, -403.395, -61.875), 1);
	NewModel.angles = (-2, -110, 0);
	NewModel setmodel("p6_zm_quarantine_fence_03");
	Collision21 = spawn("script_model", (10954, 7689.13, -595.807), 1);
	Collision21.angles = (0, 0, 0);
	Collision21 setmodel("collision_clip_wall_128x128x10");
	Collision21 disconnectpaths();
	NewModel = spawn("script_model", (10952.8, 7687.19, -596.215), 1);
	NewModel.angles = (0, 0, 0);
	NewModel setmodel("p6_zm_quarantine_fence_03");
	Collision22 = spawn("script_model", (10750, 8452.5, -407.875), 1);
	Collision22.angles = (0, -90, 0);
	Collision22 setmodel("collision_clip_wall_128x128x10");
	Collision22 disconnectpaths();
	Collision23 = spawn("script_model", (7881.36, -5464.73, 32.0521), 1);
	Collision23.angles = (0, 0, 0);
	Collision23 setmodel("collision_clip_64x64x256");
	Collision23 disconnectpaths();
	Collision25 = spawn("script_model", (7761.25, -5464.55, 39.4592), 1);
	Collision25.angles = (0, 0, 0);
	Collision25 setmodel("collision_clip_64x64x256");
	Collision25 disconnectpaths();
	Collision26 = spawn("script_model", (7801.25, -5464.55, 39.4592), 1);
	Collision26.angles = (0, 0, 0);
	Collision26 setmodel("collision_clip_64x64x256");
	Collision26 disconnectpaths();
	NewModel = spawn("script_model", (6784.68, -5953.23, -63.875), 1);
	NewModel.angles = (0, 35, 0);
	NewModel setmodel("veh_t6_civ_60s_coupe_dead");
	NewModel = spawn("script_model", (6614.68, -6098.23, -23.875), 1);
	NewModel.angles = (0, 55, 160);
	NewModel setmodel("veh_t6_civ_60s_coupe_dead");
	Collision27 = spawn("script_model", (6809.21, -5906.49, -63.875), 1);
	Collision27.angles = (0, 30, 0);
	Collision27 setmodel("collision_clip_wall_256x256x10");
	Collision27 disconnectpaths();
	Collision28 = spawn("script_model", (6610.42, -6069.61, -69.3012), 1);
	Collision28.angles = (0, 50, 0);
	Collision28 setmodel("collision_clip_wall_256x256x10");
	Collision28 disconnectpaths();
	Collision29 = spawn("script_model", (6460.74, -6421.91, -74.4166), 1);
	Collision29.angles = (0, -105, 0);
	Collision29 setmodel("collision_clip_wall_512x512x10");
	Collision29 disconnectpaths();
	NewModel = spawn("script_model", (6534.08, -6409.99, -2.71288), 1);
	NewModel.angles = (5, 80, 0);
	NewModel setmodel("veh_t6_civ_movingtrk_cab_dead");
	Collision30 = spawn("script_model", (1559.92, -1370.52, -61.875), 1);
	Collision30.angles = (0, -20, 0);
	Collision30 setmodel("collision_clip_64x64x256");
	Collision30 disconnectpaths();
	Collision31 = spawn("script_model", (1479.92, -1342.52, -61.875), 1);
	Collision31.angles = (0, -20, 0);
	Collision31 setmodel("collision_clip_64x64x256");
	Collision30 disconnectpaths();
	NewModel = spawn("script_model", (1529.69, -1353.19, -1.875), 1);
	NewModel.angles = (10, -20, 180);
	NewModel setmodel("veh_t6_civ_smallwagon_dead");
	NewModel = spawn("script_model", (-655.128, -160.71, -8.875), 1);
	NewModel.angles = (10, -20, 180);
	NewModel setmodel("veh_t6_civ_smallwagon_dead");
	Coll = spawn("script_model", (-622.441, -166.815, -48.875), 1);
	Coll.angles = (0, -20, 0);
	Coll setmodel("collision_clip_64x64x256");
	Coll disconnectpaths();
	Coll2 = spawn("script_model", (-672.441, -156.815, -48.875), 1);
	Coll2.angles = (0, -20, 0);
	Coll2 setmodel("collision_clip_64x64x256");
	Coll2 disconnectpaths();
	Coll3 = spawn("script_model", (-5061.21, -7314.56, -60.0579), 1);
	Coll3.angles = (0, 30, 0);
	Coll3 setmodel("collision_clip_64x64x256");
	Coll3 disconnectpaths();
	Coll4 = spawn("script_model", (-5023.03, -7289.07, -55.7836), 1);
	Coll4.angles = (0, 30, 0);
	Coll4 setmodel("collision_clip_64x64x256");
	Coll4 disconnectpaths();
	Coll5 = spawn("script_model", (-4962.23, -7253.4, -59.8313), 1);
	Coll5.angles = (0, 30, 0);
	Coll5 setmodel("collision_clip_64x64x256");
	Coll5 disconnectpaths();
	NewModel = spawn("script_model", (-5011.05, -7283.13, -61.2873), 1);
	NewModel.angles = (0, 30, 0);
	NewModel setmodel("veh_t6_civ_microbus_dead");
	Coll6 = spawn("script_model", (-4430.35, -7213.18, -61.8502), 1);
	Coll6.angles = (0, 0, 0);
	Coll6 setmodel("collision_clip_64x64x256");
	Coll6 disconnectpaths();
	Coll7 = spawn("script_model", (-4505.35, -7213.18, -61.8502), 1);
	Coll7.angles = (0, 0, 0);
	Coll7 setmodel("collision_clip_64x64x256");
	Coll7 disconnectpaths();
	NewModel = spawn("script_model", (-4465.58, -7217.56, -61.6005), 1);
	NewModel.angles = (0, 0, 0);
	NewModel setmodel("veh_t6_civ_smallwagon_dead");
	Coll8 = spawn("script_model", (1387.74, 560.332, -11.875), 1);
	Coll8.angles = (0, -90, 0);
	Coll8 setmodel("collision_clip_wall_128x128x10");
	Coll8 disconnectpaths();
	NewModel = spawn("script_model", (1395.76, 561.152, -61.875), 1);
	NewModel.angles = (0, -90, 0);
	NewModel setmodel("p6_zm_quarantine_fence_03");
	NewModel = spawn("script_model", (7823.36, -5467.61, 34.0929), 1);
	NewModel.angles = (0, -90, 5);
	NewModel setmodel("p_jun_storage_crate");
	Coll9 = spawn("script_model", (1599.34, -1388, -61.875), 1);
	Coll9.angles = (0, -35, 0);
	Coll9 setmodel("collision_clip_64x64x256");
	Coll9 disconnectpaths();
	Coll10 = spawn("script_model", (1423.63, -1313.07, -61.875), 1);
	Coll10.angles = (0, -35, 0);
	Coll10 setmodel("collision_clip_64x64x256");
	Coll10 disconnectpaths();
	NewModel = spawn("script_model", (-1475.27, -675.79, -71.5471), 1);
	NewModel.angles = (10, 30, 0);
	NewModel setmodel("t5_foliage_tree_burnt03");
	NewModel = spawn("script_model", (-660.508, -716.837, -70.3448), 1);
	NewModel.angles = (-5, 120, 0);
	NewModel setmodel("t5_foliage_tree_burnt03");
	Coll11 = spawn("script_model", (-1458.63, -657.501, -61.7781), 1);
	Coll11.angles = (0, 0, 0);
	Coll11 setmodel("collision_clip_64x64x256");
	Coll11 disconnectpaths();
	Coll12 = spawn("script_model", (-669.279, -710.024, -55.8921), 1);
	Coll12.angles = (0, 0, 0);
	Coll12 setmodel("collision_clip_64x64x256");
	Coll12 disconnectpaths();
	Coll13 = spawn("script_model", (1708.79, 551.604, -55.875), 1);
	Coll13.angles = (0, 0, 0);
	Coll13 setmodel("collision_clip_64x64x256");
	Coll13 disconnectpaths();
	NewModel = spawn("script_model", (1721.74, 549.105, -65.875), 1);
	NewModel.angles = (-5, 120, 0);
	NewModel setmodel("t5_foliage_tree_burnt03");
	Coll14 = spawn("script_model", (1398.79, -635.832, -52.3531), 1);
	Coll14.angles = (0, 30, 0);
	Coll14 setmodel("collision_clip_64x64x256");
	Coll14 disconnectpaths();
	Coll15 = spawn("script_model", (1463.28, -597.062, -44.5041), 1);
	Coll15.angles = (0, 30, 0);
	Coll15 setmodel("collision_clip_64x64x256");
	Coll15 disconnectpaths();
	NewModel = spawn("script_model", (1444.16, -615.281, -47.8796), 1);
	NewModel.angles = (-10, 35, -10);
	NewModel setmodel("veh_t6_civ_smallwagon_dead");
	NewModel = spawn("script_model", (3856.74, 5227.19, -63.875), 1);
	NewModel.angles = (-5, 120, 0);
	NewModel setmodel("t5_foliage_tree_burnt03");
	Coll16 = spawn("script_model", (3847.05, 5222.58, -63.875), 1);
	Coll16.angles = (0, 30, 0);
	Coll16 setmodel("collision_clip_64x64x256");
	Coll16 disconnectpaths();
	NewModel = spawn("script_model", (4066.82, 5526.96, -63.875), 1);
	NewModel.angles = (-5, 120, 0);
	NewModel setmodel("t5_foliage_tree_burnt03");
	Coll17 = spawn("script_model", (4060.03, 5529.71, -63.875), 1);
	Coll17.angles = (0, 30, 0);
	Coll17 setmodel("collision_clip_64x64x256");
	Coll17 disconnectpaths();
	NewModel = spawn("script_model", (4056.93, 4802.51, -83.921), 1);
	NewModel.angles = (-15, 120, 0);
	NewModel setmodel("t5_foliage_tree_burnt03");
	Coll18 = spawn("script_model", (4052.98, 4796.42, -65.1407), 1);
	Coll18.angles = (0, 30, 0);
	Coll18 setmodel("collision_clip_64x64x256");
	Coll18 disconnectpaths();
	Coll19 = spawn("script_model", (12159, 8324.41, -751.375), 1);
	Coll19.angles = (0, 0, 0);
	Coll19 setmodel("collision_clip_64x64x256");
	Coll19 disconnectpaths();
	Coll20 = spawn("script_model", (12229, 8324.41, -751.375), 1);
	Coll20.angles = (0, 0, 0);
	Coll20 setmodel("collision_clip_64x64x256");
	Coll20 disconnectpaths();
	NewModel = spawn("script_model", (12191.9, 8324.57, -731.375), 1);
	NewModel.angles = (90, 90, 0);
	NewModel setmodel("p6_zm_core_panel_02");
	NewModel = spawn("script_model", (12190.7, 8325.36, -731.375), 1);
	NewModel.angles = (-90, 270, 180);
	NewModel setmodel("p6_zm_core_panel_02");
	NewModel = spawn("script_model", (12187.7, 8329.54, -591.375), 1);
	NewModel.angles = (270, -90, 0);
	NewModel setmodel("p6_zm_core_panel_01");
	NewModel = spawn("script_model", (6825.3, -5146.65, -66.9532), 1);
	NewModel.angles = (0, 0, 0);
	NewModel setmodel("p_jun_storage_crate");
	Coll21 = spawn("script_model", (6829.13, -5093.38, -66.0917), 1);
	Coll21.angles = (0, 0, 0);
	Coll21 setmodel("collision_clip_64x64x256");
	Coll21 disconnectpaths();
	Coll22 = spawn("script_model", (6829.13, -5143.38, -66.0917), 1);
	Coll22.angles = (0, 0, 0);
	Coll22 setmodel("collision_clip_64x64x256");
	Coll22 disconnectpaths();
	Coll23 = spawn("script_model", (6829.13, -5203.38, -66.0917), 1);
	Coll23.angles = (0, 0, 0);
	Coll23 setmodel("collision_clip_64x64x256");
	Coll23 disconnectpaths();
	NewModel14th = spawn("script_model", (-5664.78, 4090.79, 37.8869));
	NewModel14th.angles = (9, 133, 100);
	NewModel14th setmodel("veh_t6_civ_movingtrk_cab_dead");
	Coll24 = spawn("script_model", (-5751.72, 4206.23, -28.3347), 1);
	Coll24.angles = (0, -50, 0);
	Coll24 setmodel("collision_clip_128x128x128");
	Coll24 disconnectpaths();
	Coll25 = spawn("script_model", (-5716.65, 4121.27, -23.9156), 1);
	Coll25.angles = (0, 40, 0);
	Coll25 setmodel("collision_clip_64x64x128");
	Coll25 disconnectpaths();
	Coll26 = spawn("script_model", (-5671.35, 4063.59, -20.9147), 1);
	Coll26.angles = (0, 40, 0);
	Coll26 setmodel("collision_clip_64x64x128");
	Coll26 disconnectpaths();
	NewModel14th2 = spawn("script_model", (-1891.03, -7620.66, 96.8049));
	NewModel14th2.angles = (5, 220, 0);
	NewModel14th2 setmodel("p6_zm_rocks_large_cluster_01");
	NewModel14th3 = spawn("script_model", (-1431.03, -7020.66, 106.805));
	NewModel14th3.angles = (0, 360, 0);
	NewModel14th3 setmodel("p6_zm_rocks_large_cluster_01");
	Coll27 = spawn("script_model", (-2096.96, -7724.39, -145.713), 1);
	Coll27.angles = (0, 60, 0);
	Coll27 setmodel("collision_clip_512x512x512");
	Coll27 disconnectpaths();
	Coll28 = spawn("script_model", (-1981.46, -7517.13, -165.397), 1);
	Coll28.angles = (0, 60, 0);
	Coll28 setmodel("collision_clip_512x512x512");
	Coll28 disconnectpaths();
	Coll29 = spawn("script_model", (-1566.36, -6903.13, -96.1263), 1);
	Coll29.angles = (0, 80, 0);
	Coll29 setmodel("collision_clip_512x512x512");
	Coll29 disconnectpaths();
	NewModel14th4 = spawn("script_model", (1703.43, -3642.46, -12.5074));
	NewModel14th4.angles = (0, -42, -16);
	NewModel14th4 setmodel("p6_zm_quarantine_fence_03");
	NewModel14th5 = spawn("script_model", (1655.43, -3606.46, -12.5074));
	NewModel14th5.angles = (0, -36, -16);
	NewModel14th5 setmodel("p6_zm_quarantine_fence_03");
	NewModel14th6 = spawn("script_model", (1463.43, -3492.46, -2.50737));
	NewModel14th6.angles = (6, -20, -86);
	NewModel14th6 setmodel("p6_zm_quarantine_fence_03");
	NewModel14th7 = spawn("script_model", (1321.27, -3439.48, 8.70153));
	NewModel14th7.angles = (4, -20, 0);
	NewModel14th7 setmodel("p6_zm_quarantine_fence_02");
	Coll30 = spawn("script_model", (1708.16, -3630.21, -15.2013), 1);
	Coll30.angles = (0, -36, 0);
	Coll30 setmodel("collision_clip_wall_256x256x10");
	Coll30 disconnectpaths();
	Coll31 = spawn("script_model", (1259.58, -3413.83, 16.0831), 1);
	Coll31.angles = (0, -18, 0);
	Coll31 setmodel("collision_clip_wall_256x256x10");
	Coll31 disconnectpaths();
	NewModel14th8 = spawn("script_model", (1230.69, -3399.29, 16.088));
	NewModel14th8.angles = (0, -110, 0);
	NewModel14th8 setmodel("p_glo_sandbags_green_lego_mdl");
	Coll33 = spawn("script_model", (1240.35, -3858.02, -43.3029), 1);
	Coll33.angles = (0, 0, 0);
	Coll33 setmodel("collision_clip_64x64x128");
	Coll33 disconnectpaths();
	NewModel14th10 = spawn("script_model", (1234.87, -3865.51, -43.8886));
	NewModel14th10.angles = (0, 0, 0);
	NewModel14th10 setmodel("t5_foliage_tree_burnt03");
}

enemy_location_override(zombie, enemy) {
	location = enemy.origin;
	if (is_true(self.reroute)) {
		if (isDefined(self.reroute_origin)) {
			location = self.reroute_origin;
		}
	}
	return location;
}

track_points_spent() {
	level endon("game_ended");
	while (1) {
		level waittill("spent_points", player, points);

		if (!isDefined(player.score_spent))
			player.score_spent = 0;

		player.score_spent += points;
	}
}

csv_decode(string) {
	result = [];
	rows = strToK(string, "\r\n");
	columns = strToK(rows[0], ",");

	for (x = 1; x < rows.size; x++) {
		row = strToK(rows[x], ",");

		for (y = 0; y < columns.size; y++) {
			r_index = (x - 1);
			c_index = columns[y];

			result[r_index][c_index] = row[y];
		}
	}

	return result;
}

csv_encode(array) {
	if (!isDefined(array[0])) {
		temp_array = array;
		array = [];
		array[0] = temp_array;
	}

	columns = GetArrayKeys(array[0]);
	csv_result = "";

	for (x = -1; x < array.size; x++) {
		c_i = 0;

		foreach(column in columns) {
			seperator = ",";
			c_i++;

			if (c_i == columns.size) {
				row_id = int(x + 1);
				seperator = (row_id == int(array.size)) ? "" : "\n";
				c_i = 0;
			}

			if (x == -1)
				csv_result += column + seperator;

			else
				csv_result += array[x][column] + seperator;
		}
	}

	return csv_result;
}

getmenucolor() {
	if (self.Menu_Setting["Menu_Color"] == "Orange") {
		color = (.75, .3, 0);
	}
	if (self.Menu_Setting["Menu_Color"] == "Green") {
		color = (0, 1, 0);
	}
	if (self.Menu_Setting["Menu_Color"] == "Cyan") {
		color = (0, 0.808, 0.808);
	}
	if (self.Menu_Setting["Menu_Color"] == "Red") {
		color = (1, 0, 0);
	}
	if (self.Menu_Setting["Menu_Color"] == "Blue") {
		color = (0, 0, 1);
	}
	if (self.Menu_Setting["Menu_Color"] == "Light Blue") {
		color = (0, .639, 1);
	}
	if (self.Menu_Setting["Menu_Color"] == "Purple") {
		color = (0.506, 0, 1);
	}
	if (self.Menu_Setting["Menu_Color"] == "Pink") {
		color = (1, 0, 1);
	}
	if (self.Menu_Setting["Menu_Color"] == "White") {
		color = (1, 1, 1);
	}
	if (self.Menu_Setting["Menu_Color"] == "Yellow") {
		color = (0.98, 0.843, 0);
	}
	if (self.Menu_Setting["Menu_Color"] == "LGreen") {
		color = (0.486, 0.988, 0);
	}
	if (self.Menu_Setting["Menu_Color"] == "Special1") {
		color = (0.482, 0.408, 0.933);
	}
	return color;
}

HandleMenuSettings() {
	level endon("end_game");
	self endon("disconnect");
	basepath = getDvar("fs_basepath") + "/t6r/data/stats";
	players_dir_settings = basepath + "/menu_settings/";

	players_dir_settings_file = players_dir_settings + self.realname + ".csv";
	players_dir_settings_data = readFile(players_dir_settings_file);

	self.Menu_Setting = [];

	players_dir_settings_data_test = csv_decode(players_dir_settings_data)[0];

	if (!isDefined(players_dir_settings_data_test)) {
		self.Menu_Setting["Menu_Color"] = "Special1";
		self.Menu_Setting["Menu_Cursor_Speed"] = "Medium";
		self.Menu_Setting["Menu_Choosen_Weapon"] = "m1911_zm";
		self.Menu_Setting["Menu_Choosen_Tactical"] = "none";
		self.Menu_Setting["Menu_Choosen_Lethal"] = "frag_grenade_zm";
		self.Menu_Setting["Menu_Choosen_MeleeWeapon"] = "none";
		self.Menu_Setting["Menu_Choosen_Background"] = "loadscreen_zm_meat";
		self.Menu_Setting["Menu_Choosen_Teleport"] = "Diner";
		self.Menu_Setting["Menu_Choosen_RankColor"] = "^5";
		player_default_settings = csv_encode(self.Menu_Setting);
		writeFile(players_dir_settings_file, player_default_settings);
	}
	else {
		self.Menu_Setting = csv_decode(players_dir_settings_data)[0];
		self.Menu_Setting["Menu_Color"] = self.Menu_Setting["Menu_Color"];
		self.Menu_Setting["Menu_Cursor_Speed"] = self.Menu_Setting["Menu_Cursor_Speed"];
		self.Menu_Setting["Menu_Choosen_Weapon"] = self.Menu_Setting["Menu_Choosen_Weapon"];
		self.Menu_Setting["Menu_Choosen_Tactical"] = self.Menu_Setting["Menu_Choosen_Tactical"];
		self.Menu_Setting["Menu_Choosen_Lethal"] = self.Menu_Setting["Menu_Choosen_Lethal"];
		self.Menu_Setting["Menu_Choosen_MeleeWeapon"] = self.Menu_Setting["Menu_Choosen_MeleeWeapon"];
		self.Menu_Setting["Menu_Choosen_Background"] = self.Menu_Setting["Menu_Choosen_Background"];
		self.Menu_Setting["Menu_Choosen_Teleport"] = self.Menu_Setting["Menu_Choosen_Teleport"];
		self.Menu_Setting["Menu_Choosen_RankColor"] = self.Menu_Setting["Menu_Choosen_RankColor"];
	}
	while (1) {
		self waittill("Menu_Setting_Changed", which, value);
		if (which == "Rank_Color") {
			self.Menu_Setting["Menu_Color"] = self.Menu_Setting["Menu_Color"];
			self.Menu_Setting["Menu_Choosen_Weapon"] = self.Menu_Setting["Menu_Choosen_Weapon"];
			self.Menu_Setting["Menu_Choosen_Tactical"] = self.Menu_Setting["Menu_Choosen_Tactical"];
			self.Menu_Setting["Menu_Choosen_Lethal"] = self.Menu_Setting["Menu_Choosen_Lethal"];
			self.Menu_Setting["Menu_Choosen_MeleeWeapon"] = self.Menu_Setting["Menu_Choosen_MeleeWeapon"];
			self.Menu_Setting["Menu_Choosen_Background"] = self.Menu_Setting["Menu_Choosen_Background"];
			self.Menu_Setting["Menu_Choosen_Teleport"] = self.Menu_Setting["Menu_Choosen_Teleport"];
			self.Menu_Setting["Menu_Choosen_RankColor"] = value;
			self.Menu_Setting["Menu_Cursor_Speed"] = self.Menu_Setting["Menu_Cursor_Speed"];
		}
		if (which == "Teleport_Changed") {
			self.Menu_Setting["Menu_Color"] = self.Menu_Setting["Menu_Color"];
			self.Menu_Setting["Menu_Choosen_Weapon"] = self.Menu_Setting["Menu_Choosen_Weapon"];
			self.Menu_Setting["Menu_Choosen_Tactical"] = self.Menu_Setting["Menu_Choosen_Tactical"];
			self.Menu_Setting["Menu_Choosen_Lethal"] = self.Menu_Setting["Menu_Choosen_Lethal"];
			self.Menu_Setting["Menu_Choosen_MeleeWeapon"] = self.Menu_Setting["Menu_Choosen_MeleeWeapon"];
			self.Menu_Setting["Menu_Choosen_Background"] = self.Menu_Setting["Menu_Choosen_Background"];
			self.Menu_Setting["Menu_Choosen_Teleport"] = value;
			self.Menu_Setting["Menu_Choosen_RankColor"] = self.Menu_Setting["Menu_Choosen_RankColor"];
			self.Menu_Setting["Menu_Cursor_Speed"] = self.Menu_Setting["Menu_Cursor_Speed"];
		}
		if (which == "Weapon_Changed") {
			self.Menu_Setting["Menu_Color"] = self.Menu_Setting["Menu_Color"];
			self.Menu_Setting["Menu_Choosen_Weapon"] = value;
			self.Menu_Setting["Menu_Choosen_Tactical"] = self.Menu_Setting["Menu_Choosen_Tactical"];
			self.Menu_Setting["Menu_Choosen_Lethal"] = self.Menu_Setting["Menu_Choosen_Lethal"];
			self.Menu_Setting["Menu_Choosen_MeleeWeapon"] = self.Menu_Setting["Menu_Choosen_MeleeWeapon"];
			self.Menu_Setting["Menu_Choosen_Background"] = self.Menu_Setting["Menu_Choosen_Background"];
			self.Menu_Setting["Menu_Choosen_Teleport"] = self.Menu_Setting["Menu_Choosen_Teleport"];
			self.Menu_Setting["Menu_Choosen_RankColor"] = self.Menu_Setting["Menu_Choosen_RankColor"];
			self.Menu_Setting["Menu_Cursor_Speed"] = self.Menu_Setting["Menu_Cursor_Speed"];
		}
		if (which == "Cursor_Speed") {
			self.Menu_Setting["Menu_Color"] = self.Menu_Setting["Menu_Color"];
			self.Menu_Setting["Menu_Choosen_Weapon"] = self.Menu_Setting["Menu_Choosen_Weapon"];
			self.Menu_Setting["Menu_Choosen_Tactical"] = self.Menu_Setting["Menu_Choosen_Tactical"];
			self.Menu_Setting["Menu_Choosen_Lethal"] = self.Menu_Setting["Menu_Choosen_Lethal"];
			self.Menu_Setting["Menu_Choosen_MeleeWeapon"] = self.Menu_Setting["Menu_Choosen_MeleeWeapon"];
			self.Menu_Setting["Menu_Choosen_Background"] = self.Menu_Setting["Menu_Choosen_Background"];
			self.Menu_Setting["Menu_Choosen_Teleport"] = self.Menu_Setting["Menu_Choosen_Teleport"];
			self.Menu_Setting["Menu_Choosen_RankColor"] = self.Menu_Setting["Menu_Choosen_RankColor"];
			self.Menu_Setting["Menu_Cursor_Speed"] = value;
		}
		if (which == "Menu_Background") {
			self.Menu_Setting["Menu_Color"] = self.Menu_Setting["Menu_Color"];
			self.Menu_Setting["Menu_Choosen_Weapon"] = self.Menu_Setting["Menu_Choosen_Weapon"];
			self.Menu_Setting["Menu_Choosen_Tactical"] = self.Menu_Setting["Menu_Choosen_Tactical"];
			self.Menu_Setting["Menu_Choosen_Lethal"] = self.Menu_Setting["Menu_Choosen_Lethal"];
			self.Menu_Setting["Menu_Choosen_MeleeWeapon"] = self.Menu_Setting["Menu_Choosen_MeleeWeapon"];
			self.Menu_Setting["Menu_Choosen_Background"] = value;
			self.Menu_Setting["Menu_Choosen_Teleport"] = self.Menu_Setting["Menu_Choosen_Teleport"];
			self.Menu_Setting["Menu_Choosen_RankColor"] = self.Menu_Setting["Menu_Choosen_RankColor"];
			self.Menu_Setting["Menu_Cursor_Speed"] = self.Menu_Setting["Menu_Cursor_Speed"];
			self.CursorMenu.MainElements["Background"] SetShader(self.Menu_Setting["Menu_Choosen_Background"], 640, 480);
		}
		if (which == "Menu_Color") {
			self.Menu_Setting["Menu_Color"] = value;
			self.Menu_Setting["Menu_Choosen_Weapon"] = self.Menu_Setting["Menu_Choosen_Weapon"];
			self.Menu_Setting["Menu_Choosen_Tactical"] = self.Menu_Setting["Menu_Choosen_Tactical"];
			self.Menu_Setting["Menu_Choosen_Lethal"] = self.Menu_Setting["Menu_Choosen_Lethal"];
			self.Menu_Setting["Menu_Choosen_MeleeWeapon"] = self.Menu_Setting["Menu_Choosen_MeleeWeapon"];
			self.Menu_Setting["Menu_Choosen_Background"] = self.Menu_Setting["Menu_Choosen_Background"];
			self.Menu_Setting["Menu_Choosen_Teleport"] = self.Menu_Setting["Menu_Choosen_Teleport"];
			self.Menu_Setting["Menu_Choosen_RankColor"] = self.Menu_Setting["Menu_Choosen_RankColor"];
			self.Menu_Setting["Menu_Cursor_Speed"] = self.Menu_Setting["Menu_Cursor_Speed"];
			self.menucolor = self getmenucolor();
			self.CursorMenu.MainElements["PlayernameBackColorTop"] fadeovertime(0.5);
			self.CursorMenu.MainElements["TopbarColor"] fadeovertime(0.5);
			self.CursorMenu.MainElements["BottombarColor"] fadeovertime(0.5);
			self.xp_bar fadeovertime(0.5);
			self.CursorMenu.MainElements["PlayernameBackColorTop"].color = self.menucolor;
			self.CursorMenu.MainElements["TopbarColor"].color = self.menucolor;
			self.CursorMenu.MainElements["BottombarColor"].color = self.menucolor;
			self.xp_bar.color = self.menucolor;
		}
		player_default_settings = csv_encode(self.Menu_Setting);
		writeFile(players_dir_settings_file, player_default_settings);
	}
}

HandlePlayerStats() {
	level endon("end_game");
	self endon("disconnect");

	basepath = getDvar("fs_basepath") + "/t6r/data/stats";
	sessions_dir = basepath + "/sessions/";
	players_dir = basepath + "/players/";

	int_total = [];
	int_columns = strTok("kills,headshots,melee_kills,grenade_kills,hits,downs,revives,magicbox_uses,pap_uses,powerup_uses,rounds_played,time_played,perk_uses,score_earned,score_spent,xp", ",");

	// Create player session
	level.new_sessions++;
	self.session_stats = [];

	foreach(s_column in int_columns) {
		self.session_stats[s_column] = 0;
	}

	self.session_stats["uid"] = self getGUID();
	self.session_stats["username"] = self.realname;
	self.session_stats["round_joined"] = level.round_number;
	self.session_stats["highest_round"] = (isDefined(level.round_number)) ? level.round_number : 0;
	self.session_stats["time_joined"] = GetUTC();
	session_file = sessions_dir + self.session_stats["time_joined"] + "_" + self getGUID() + ".csv";

	// Initialize player stats
	player_file = players_dir + self getGUID() + ".csv";
	player_csv_data = readFile(player_file);  // via plugin func

	// Player stats on first join
	if (!isDefined(player_csv_data) || player_csv_data == "") {
		level.new_players++;
		self.total_stats = [];

		foreach(t_column in int_columns) {
			self.total_stats[t_column] = 0;
		}

		self.total_stats["uid"] = self getGUID();
		self.total_stats["username"] = self.realname;
		self.total_stats["time_joined"] = GetUTC();
		self.total_stats["sessions"] = 0;
		self.total_stats["highest_round"] = 0;
	}

	// Player stats from file
	else
		self.total_stats = csv_decode(player_csv_data)[0];
	self.total_stats["sessions"] = int(self.total_stats["sessions"]) + 1;
	self.total_stats["highest_round"] = int(self.total_stats["highest_round"]);

	foreach(i_column in int_columns) {
		int_total[i_column] = int(self.total_stats[i_column]);
	}

	int_xp = false;

	while (1) {
		// Update session stats
		self.session_stats["kills"] = self.pers["kills"];
		self.session_stats["headshots"] = self.pers["headshots"];
		self.session_stats["melee_kills"] = self.pers["melee_kills"];
		self.session_stats["grenade_kills"] = self.pers["grenade_kills"];
		self.session_stats["hits"] = self.pers["hits"];
		self.session_stats["downs"] = self.pers["downs"];  // WIP: last down = death doesn't count
		self.session_stats["revives"] = self.pers["revives"];
		self.session_stats["magicbox_uses"] = self.pers["use_magicbox"];
		self.session_stats["pap_uses"] = self.pers["use_pap"];
		self.session_stats["powerup_uses"] = self.pers["drops"];
		self.session_stats["rounds_played"] = level.round_number - self.session_stats["round_joined"];
		self.session_stats["time_played"] = self.pers["time_played_total"];
		self.session_stats["perk_uses"] = self.pers["perks_drank"];
		self.session_stats["score_earned"] = self.score_total;
		self.session_stats["score_spent"] = self.score_spent;

		if (level.round_number > self.session_stats["highest_round"])
			self.session_stats["highest_round"] = level.round_number;

		if ((self.session_stats["round_joined"] == 1) && level.round_number > self.total_stats["highest_round"])
			self.total_stats["highest_round"] = level.round_number;

		// Update player stats
		foreach(p_column in int_columns) {
			self.total_stats[p_column] = int_total[p_column] + self.session_stats[p_column];
		}

		if (!int_xp) self thread HandlePlayerXP();
		int_xp = true;

		session_data = csv_encode(self.session_stats);
		player_data = csv_encode(self.total_stats);

		// writeFile(session_file, session_data);
		writeFile(player_file, player_data);
		wait 1;
	}
}

HandleServerStats() {
	if (level.intserverstats == 1) return;
	level.intserverstats = 1;
	level endon("end_game");

	basepath = getDvar("fs_basepath") + "/t6r/data/stats/";
	server_file = basepath + "server.csv";

	int_server = [];
	int_columns = strTok("players,sessions,matches,rounds,time_played", ",");
	level.match_start = GetUTC();
	level thread HandleLeaderboard();
	server_csv_data = readFile(server_file);

	// New server stats
	if (!isDefined(server_csv_data)) {
		self.server_stats = [];

		foreach(v_column in int_columns) {
			self.server_stats[v_column] = 0;
		}
	}

	// Re-initialize server stats from file
	else
		self.server_stats = csv_decode(server_csv_data)[0];
	self.server_stats["matches"] = int(self.server_stats["matches"]) + 1;

	int_server["players"] = int(self.server_stats["players"]);
	int_server["sessions"] = int(self.server_stats["sessions"]);
	int_server["rounds"] = int(self.server_stats["rounds"]);
	int_server["time_played"] = int(self.server_stats["time_played"]);

	while (1) {
		self.server_stats["players"] = int_server["players"] + level.new_players;
		self.server_stats["sessions"] = int_server["sessions"] + level.new_sessions;
		self.server_stats["rounds"] = int_server["rounds"] + (level.round_number - 1);
		self.server_stats["time_played"] = int_server["time_played"] + int(GetUTC() - level.match_start);

		server_data = csv_encode(self.server_stats);
		writeFile(server_file, server_data);

		wait 5;
	}
}

HandleLeaderboard() {
	level endon("end_game");

	basepath = getDvar("fs_basepath") + "/t6r/data/stats/";
	leaderboard_file = basepath + "leaderboard.csv";
	leaderboard_csv_data = readFile(leaderboard_file);
	self.leaderboard_stats = [];

	// Re-initialize leaderboard from file
	if (isDefined(leaderboard_csv_data))
		self.leaderboard_stats = csv_decode(leaderboard_csv_data);

	id = self.leaderboard_stats.size;
	int_endon = false;
	joined_too_late = false;

	while (1) {
		level waittill("between_round_over");
		if (level.round_number < 10) continue;  // round on which record tracking starts

		players = get_players();

		foreach(player in players) {
			if (player.session_stats["round_joined"] > 1)  // round until player must have joined
				joined_too_late = true;

			if (!int_endon) player endon("disconnect");
		}

		int_endon = true;
		if (joined_too_late) continue;

		record_found = false;
		highest_record = 0;

		foreach(record in self.leaderboard_stats) {
			if (int(record["players"]) != players.size) continue;

			record_found = true;
			highest_record = (int(record["round"]) >= highest_record) ? int(record["round"]) : highest_record;
		}

		if (!record_found || level.round_number >= highest_record) {
			self.leaderboard_stats[id]["timestamp"] = GetUTC();
			self.leaderboard_stats[id]["players"] = players.size;
			self.leaderboard_stats[id]["round"] = level.round_number;
			self.leaderboard_stats[id]["time_played"] = int(GetUTC() - level.match_start);
			self.leaderboard_stats[id]["player_1"] = (isDefined(players[0].name)) ? players[0].name : "-";
			self.leaderboard_stats[id]["player_2"] = (isDefined(players[1].name)) ? players[1].name : "-";
			self.leaderboard_stats[id]["player_3"] = (isDefined(players[2].name)) ? players[2].name : "-";
			self.leaderboard_stats[id]["player_4"] = (isDefined(players[3].name)) ? players[3].name : "-";

			leaderboard_data = csv_encode(self.leaderboard_stats);
			writeFile(leaderboard_file, leaderboard_data);
		}
	}
}

HandlePlayerXP() {
	level endon("end_game");
	self endon("disconnect");
	self endon("Menu_Setting_Rank_C");

	// WIP: Stoppe XP Verdienst wenn Spieler max Level ist
	self thread reward_xp_on("kill");
	self thread reward_xp_on("player_revived");
	self thread reward_xp_on("round_survived");  // WIP: Nur wenn spieler nicht tot ist
	self thread reward_xp_on("door_opened");
	self thread reward_xp_on("powerup_taken");

	// DEBUG
	// self draw_rank_popup( 935, "zombies_rank_2" );

	// WIP: Echtes Spieler Rank Icon (wenigstens im Scoreboard) synchron halten
	// WIP: Als func machen und direkt beim XP verdienen triggern (könnt 3arc auch mal machen)
	// self thread GiveRewards();
	while (1) {
		rank = convert_xp_to_level(self.total_stats["xp"]);

		if (!isDefined(trigger_level)) trigger_level = rank["next_level"];
		if (trigger_level < 1) break;

		if (rank["current_level"] >= trigger_level) {
			trigger_level = rank["next_level"];

			if (rank["current_level"] < 200)
				rank_icon = "zombies_rank_1";

			else if (rank["current_level"] < 400)
				rank_icon = "zombies_rank_2";

			else if (rank["current_level"] < 500)
				rank_icon = "zombies_rank_3";

			else if (rank["current_level"] < 600)
				rank_icon = "zombies_rank_3_ded";

			else if (rank["current_level"] < 700)
				rank_icon = "zombies_rank_4";

			else if (rank["current_level"] < 800)
				rank_icon = "zombies_rank_4_ded";

			else if (rank["current_level"] < 900)
				rank_icon = "zombies_rank_5";

			else if (rank["current_level"] < 1000)
				rank_icon = "zombies_rank_5_ded";

			self draw_rank_popup(rank["current_level"], rank_icon);
			self.total_stats["pap_uses"] = 0;
		}
		// self.current_level setSafeText(self, rank[ "current_level" ] );
		// self.next_rank setShader( "zombies_rank_1" , 20, 20 );
		//	self.current_rank setShader( "zombies_rank_1" , 20, 20 );
		// self.next_level setSafeText(self, rank[ "next_level" ] );
		// self.xpleft = int( rank[ "next_xp" ] - self.total_stats[ "xp" ]);
		// self.xp_left setSafeText(self, "^8Next Level: ^7" + self.xpleft + " XP" );
		// self.xp_earned setSafeText(self, "^8Earned: ^7" + self.total_stats[ "xp" ] + " XP ");
		// self.xp_earned setText( "^8Earned: ^7" + self.xpearnedperlvl + " XP ");
		// base_width = 476; //476
		// base_height = 4;
		// self.xp_bar setshader("white", int((self.total_stats[ "xp" ] / rank[ "next_xp" ]) * base_width), base_height);
		// self.xp_bar setshader("white", int((self.total_stats[ "xp" ] / rank[ "next_xp" ]) * base_width), base_height);
		// DEBUG

		/*if (self.name == "John Kramer" || self.name == "ZECxR3ap3r")
			self iprintln(
				"^8XP: ^5" + self.total_stats[ "xp" ] +
				" ^8Left: ^5" + int( rank[ "next_xp" ] - self.total_stats[ "xp" ]) +
				" ^8Level: ^5" + rank[ "current_level" ] +
				" ^8Next: ^5" + rank[ "next_level" ]
			);*/

		wait 5;
	}

	/* DEBUG
	convert_xp_to_level(0);
	convert_xp_to_level(1);
	convert_xp_to_level(519060);
	convert_xp_to_level(519061);
	convert_xp_to_level(519062);
	convert_xp_to_level(49934999);
	convert_xp_to_level(49935999);
	convert_xp_to_level(49999999);
	convert_xp_to_level(50000000);
	*/
}

draw_rank_popup(new_level, new_icon) {
	self playlocalsound("zmb_box_move");  // zmb_turbine_pulse

	rank_icon = newclienthudelem(self);
	rank_icon.y = -160;
	rank_icon.alignx = "center";
	rank_icon.aligny = "middle";
	rank_icon.horzalign = "center";
	rank_icon.vertalign = "middle";
	rank_icon.archived = false;
	rank_icon.foreground = true;
	rank_icon.alpha = 0;
	rank_icon.hidewheninmenu = true;
	rank_icon.hidewhendead = true;
	rank_icon setShader(new_icon, 102, 102);

	level_hint = newclienthudelem(self);
	level_hint.y = -129;
	level_hint.alignx = "center";
	level_hint.aligny = "middle";
	level_hint.horzalign = "center";
	level_hint.vertalign = "middle";
	level_hint.archived = false;
	level_hint.foreground = true;
	level_hint.fontscale = 1.15;
	level_hint.alpha = 0;
	level_hint.color = (1, 1, 1);
	level_hint.hidewheninmenu = true;
	level_hint.hidewhendead = true;
	level_hint.font = "default";
	level_hint setText("^7LEVEL ^5" + new_level);

	rank_icon fadeovertime(0.25);
	rank_icon scaleovertime(0.25, 46, 46);
	rank_icon.alpha = 1;

	wait .25;
	level_hint fadeovertime(0.25);
	level_hint.alpha = 1;

	wait 3;
	rank_icon fadeovertime(0.25);
	level_hint fadeovertime(0.25);
	rank_icon.alpha = 0;
	level_hint.alpha = 0;

	wait .25;
	rank_icon destroy();
	level_hint destroy();
	rank = convert_xp_to_level(self.total_stats["xp"]);
	executeCommand("setclantagraw " + self getentitynumber() + " ^5" + rank["current_level"] + "^7");
	foreach(player in level.players) {
		player iprintln("^5" + self.realname + " ^7 Ranked up to Rank ^5" + new_level);
	}
}

draw_xp(xp_value, hint_text, color) {
	if (!isDefined(color))
		color = 3;

	if (isDefined(self.xp_hint)) {
		self.xp_hint_text += "\n^" + color + "+" + xp_value + " XP^7 " + hint_text;
		self.xp_hint setText(self.xp_hint_text);
		return;
	}

	self.xp_hint = newclienthudelem(self);
	self.xp_hint.x = 35;
	self.xp_hint.y = -25;
	self.xp_hint.alignx = "left";
	self.xp_hint.aligny = "top";
	self.xp_hint.horzalign = "center";
	self.xp_hint.vertalign = "middle";
	self.xp_hint.archived = false;
	self.xp_hint.foreground = false;
	self.xp_hint.fontscale = 2;
	self.xp_hint.alpha = 0;
	self.xp_hint.color = (1, 1, 1);
	self.xp_hint.hidewheninmenu = true;
	self.xp_hint.hidewhendead = true;
	self.xp_hint.font = "default";

	self.xp_hint_text = "^" + color + "+" + xp_value + " XP^7 " + hint_text;
	self.xp_hint setText(self.xp_hint_text);

	self.xp_hint changefontscaleovertime(0.25);
	self.xp_hint fadeovertime(0.25);
	self.xp_hint.alpha = 1;
	self.xp_hint.fontscale = 1;

	wait 1.5;

	self.xp_hint fadeovertime(0.25);
	self.xp_hint.alpha = 0;

	wait .25;
	self.xp_hint destroy();
}

round(value) {
	return int(floor(value + 0.5));
}

convert_xp_to_level(xp_value) {
	test_out = "";

	xp_value = int(xp_value);
	max_level = 1000;
	max_xp = 50000000;
	divisor = 10;
	decreaser = 0.9575;
	subtractor = 6500000;
	quotient = int(max_level / divisor);
	rank = [];

	high_pointer = max_xp;
	low_pointer = round(high_pointer - subtractor);

	// Level zwischen geteilte Bereiche eingränzen (100, 200, ... 900, 1000)
	for (i = 1; i <= divisor; i++) {
		is_last_before = (i + 1) == divisor;

		// DEBUG
		// test_out += high_pointer + " - " + low_pointer + " (Abzug: -" + subtractor + ")\n";

		if (xp_value <= high_pointer && xp_value > low_pointer) {
			// Bereich gefunden
			lvl_area = round((max_level - (i * quotient)) + 1);

			// DEBUG
			// test_out += "Area: " + lvl_area + "\n";

			break;
		}

		if (!is_last_before) {
			high_pointer = low_pointer;
			subtractor = round(subtractor * decreaser);
			low_pointer = round(high_pointer - subtractor);
		}

		else {
			high_pointer = low_pointer;
			subtractor = 0;
			low_pointer = -1;
		}
	}

	main_low_pointer = low_pointer;
	subtractor = round((high_pointer - low_pointer) / quotient);
	low_pointer = round(high_pointer - subtractor);

	// Level genau ermitteln (600 ... 601)
	for (j = 1; j <= quotient; j++) {
		is_last_before = (j + 1) == quotient;
		
		if (xp_value <= high_pointer && xp_value > low_pointer) {
			rank["current_level"] = round(lvl_area + (quotient - j));
			rank["next_level"] = (rank["current_level"] == 1000) ? -1 : (rank["current_level"] + 1);
			rank["next_xp"] = high_pointer;
			rank["last_xp"] = max(low_pointer, 0);
			break;
		}

		if (!is_last_before) {
			high_pointer = low_pointer;
			low_pointer = round(high_pointer - subtractor);
		}

		else {
			high_pointer = low_pointer;
			subtractor = 0;
			low_pointer = main_low_pointer;
		}
	}

	return rank;
}

EditAllDoorTriggers() {
	zombie_doors = getentarray("zombie_door", "targetname");
	for (i = 0; i < zombie_doors.size; i++) {
		if (isDefined(zombie_doors[i].zombie_cost)) {
			zombie_doors[i] thread door_init();
		}
	}
}

door_init() {
	self.type = undefined;
	self.purchaser = undefined;
	self._door_open = 0;
	targets = getentarray(self.target, "targetname");
	while (isDefined(self.script_flag) && !isDefined(level.flag[self.script_flag])) {
		while (isDefined(self.script_flag)) {
			tokens = strtok(self.script_flag, ",");
			i = 0;
			while (i < tokens.size) {
				flag_init(self.script_flag);
				i++;
			}
		}
	}
	if (!isDefined(self.script_noteworthy)) {
		self.script_noteworthy = "default";
	}
	self.doors = [];
	i = 0;
	while (i < targets.size) {
		targets[i] door_classify(self);
		if (!isDefined(targets[i].og_origin)) {
			targets[i].og_origin = targets[i].origin;
			targets[i].og_angles = targets[i].angles;
		}
		i++;
	}
	cost = 1000;
	if (isDefined(self.zombie_cost)) {
		cost = self.zombie_cost;
	}
	self setcursorhint("HINT_NOICON");
	self thread door_think();
	if (isDefined(self.script_noteworthy)) {
		if (self.script_noteworthy == "electric_door" || self.script_noteworthy == "electric_buyable_door") {
			if (getDvar("ui_gametype") == "zgrief") {
				self setinvisibletoall();
				return;
			}
			self sethintstring(&"ZOMBIE_NEED_POWER");
			if (isDefined(level.door_dialog_function)) {
				self thread [[level.door_dialog_function]] ();
			}
			return;
		}
		else {
			if (self.script_noteworthy == "local_electric_door") {
				if (getDvar("ui_gametype") == "zgrief") {
					self setinvisibletoall();
					return;
				}
				self sethintstring(&"ZOMBIE_NEED_LOCAL_POWER");
				if (isDefined(level.door_dialog_function)) {
					self thread [[level.door_dialog_function]] ();
				}
				return;
			}
			else {
				if (self.script_noteworthy == "kill_counter_door") {
					self sethintstring(&"ZOMBIE_DOOR_ACTIVATE_COUNTER", cost);
					return;
				}
			}
		}
	}
	self set_hint_string(self, "default_buy_door_" + cost);
}

door_think() {
	self endon("kill_door_think");
	cost = 1000;
	if (isDefined(self.zombie_cost)) {
		cost = self.zombie_cost;
	}
	self sethintlowpriority(1);
	for (;;) {
		while (1) {
			switch (self.script_noteworthy) {
			case "local_electric_door":
				if (isDefined(self.local_power_on) && !self.local_power_on) {
					self waittill("local_power_on");
				}
			case "electric_door":
				if (isDefined(self.power_on) && !self.power_on) {
					self waittill("power_on");
				}
			case "electric_buyable_door":
				flag_wait("power_on");
				self set_hint_string(self, "default_buy_door_" + cost);
				while (!self door_buy_Custom()) {
					continue;
				}
			case "delay_door":
				while (!self door_buy_Custom()) {
					continue;
				}
				self door_delay();
				break;
			default:
				if (isDefined(level._default_door_custom_logic)) {
					self [[level._default_door_custom_logic]] ();
					break;
				}
				else
					while (!self door_buy_Custom()) {
						continue;
					}
			}
			self door_opened(cost);
			if (!flag("door_can_close")) {
				return;
			}
		}
	}
}

reward_xp_on(type) {
	level endon("game_ended");
	self endon("disconnect");

	base_xp = [];
	base_xp["kill"] = 50;
	base_xp["revive"] = 150;
	base_xp["round"] = 50;
	base_xp["door"] = 250;
	base_xp["powerup"] = 50;

	while (1) {
		switch (type) {
		case "kill":
			self waittill("zom_kill", zombie);

			if (zombie.damagemod == "MOD_MELEE" || zombie.damagemod == "MOD_IMPACT") {
				add_kill_xp = int(base_xp["kill"] * 3);  // Melee kill: +200% multiplier
				kill_type_hint = "Melee Kill";
			}
			else if (zombie.damagelocation == "head" || zombie.damagelocation == "helmet" || zombie.damagelocation == "neck") {
				add_kill_xp = int(base_xp["kill"] * 2);  // Headshot kill: +100% multiplier
				kill_type_hint = "Headshot Kill";
			}
			else if (zombie.damagemod == "MOD_GRENADE" || zombie.damagemod == "MOD_GRENADE_SPLASH" || zombie.damagemod == "MOD_EXPLOSIVE") {
				add_kill_xp = int(base_xp["kill"] * 1.5);  // Explosive kill: +50% multiplier
				kill_type_hint = "Explosive Kill";
			}
			else {
				add_kill_xp = int(base_xp["kill"]);  // Basic kill
				kill_type_hint = "Zombie Elimination";
			}

			self.session_stats["xp"] += add_kill_xp;
			self thread draw_xp(add_kill_xp, kill_type_hint);
			self.xpearnedperlvl += add_kill_xp;
			break;

		case "player_revived":  // WIP
			self notify("player_revived", reviver);
			self iprintln("Du wurdest revived von: " + reviver.name);
			add_revive_xp = base_xp["revive"];
			reviver.session_stats["xp"] += add_revive_xp;
			reviver.xpearnedperlvl += add_revive_xp;
			reviver thread draw_xp(add_revive_xp, "Teammate Revived");
			break;

		case "round_survived":
			level waittill("end_of_round");
			round_multiplier = (level.round_number > 20) ? 20 : level.round_number;  // Max round multiplier: 20
			add_round_xp = int(base_xp["round"] * round_multiplier);
			self.session_stats["xp"] += add_round_xp;
			self.xpearnedperlvl += add_round_xp;
			self thread draw_xp(add_round_xp, "Round Survived", 6);
			break;

		case "door_opened":                             // WIP
			self waittill("XP_SYSTEM_Door_Purchased");  // pseudo flag
			add_door_xp = int(base_xp["door"]);
			self.session_stats["xp"] += add_door_xp;
			self.xpearnedperlvl += add_door_xp;
			self thread draw_xp(add_door_xp, "Door Purchased");
			break;

		case "powerup_taken":                   // WIP
			self waittill("powerup_taken_xp");  // pseudo flag
			add_powerup_xp = int(base_xp["powerup"]);
			self.session_stats["xp"] += add_powerup_xp;
			self.xpearnedperlvl += add_powerup_xp;
			self thread draw_xp(add_powerup_xp, "Powerup Grabbed");
			break;
		}
	}
}

door_buy_custom() {
	level endon("end_game");
	self waittill("trigger", who, force);
	if (isDefined(level.custom_door_buy_check)) {
		if (!(who [[level.custom_door_buy_check]] (self))) {
			return 0;
		}
	}
	if (getDvarInt("zombie_unlock_all") > 0 || isDefined(force) && force) {
		return 1;
	}
	if (!who usebuttonpressed()) {
		return 0;
	}
	if (who in_revive_trigger()) {
		return 0;
	}
	if (is_player_valid(who)) {
		players = get_players();
		cost = self.zombie_cost;
		if (who maps/mp/zombies/_zm_pers_upgrades_functions::is_pers_double_points_active()) {
			cost = who maps/mp/zombies/_zm_pers_upgrades_functions::pers_upgrade_double_points_cost(cost);
		}
		if (self._door_open == 1) {
			self.purchaser = undefined;
		}
		else if (who.score >= cost) {
			who maps/mp/zombies/_zm_score::minus_to_player_score(cost, 1);
			who notify("XP_SYSTEM_Door_Purchased");
			maps/mp/_demo::bookmark("zm_player_door", getTime(), who);
			who maps/mp/zombies/_zm_stats::increment_client_stat("doors_purchased");
			who maps/mp/zombies/_zm_stats::increment_player_stat("doors_purchased");
			self.purchaser = who;
		}
		else {
			play_sound_at_pos("no_purchase", self.doors[0].origin);
			if (isDefined(level.custom_generic_deny_vo_func)) {
				who thread [[level.custom_generic_deny_vo_func]] (1);
			}
			else {
				who maps/mp/zombies/_zm_audio::create_and_play_dialog("general", "door_deny");
			}
			return 0;
		}
	}
	if (isDefined(level._door_open_rumble_func)) {
		who thread [[level._door_open_rumble_func]] ();
	}
	return 1;
}

actor_killed_override(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime) {
	if (game["state"] == "postgame") {
		return;
	}
	/*if ( isDefined( self.completed_emerging_into_playable_area ))
	{
			if ( randomint( 100 ) > 85 )
			{
					self thread schrotthandler(self.origin);
			}
	}*/
	if (isai(attacker) && isDefined(attacker.script_owner)) {
		if (attacker.script_owner.team != self.aiteam) {
			attacker = attacker.script_owner;
		}
	}
	if (attacker.classname == "script_vehicle" && isDefined(attacker.owner)) {
		attacker = attacker.owner;
	}
	if (isDefined(attacker) && isplayer(attacker)) {
		multiplier = 1;
		if (is_headshot(sweapon, shitloc, smeansofdeath)) {
			multiplier = 1.5;
		}
		type = undefined;
		if (isDefined(self.animname)) {
			switch (self.animname) {
			case "quad_zombie":
				type = "quadkill";
				break;
			case "ape_zombie":
				type = "apekill";
				break;
			case "zombie":
				type = "zombiekill";
				break;
			case "zombie_dog":
				type = "dogkill";
				break;
			}
		}
	}
	if (isDefined(self.is_ziplining) && self.is_ziplining) {
		self.deathanim = undefined;
	}
	if (isDefined(self.actor_killed_override)) {
		self [[self.actor_killed_override]] (einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime);
	}
}

playerhealthregen_custom() {
	self notify("playerHealthRegen");
	self endon("playerHealthRegen");
	self endon("death");
	self endon("disconnect");

	if (!isDefined(self.flag)) {
		self.flag = [];
		self.flags_lock = [];
	}

	if (!isDefined(self.flag["player_has_red_flashing_overlay"])) {
		self player_flag_init("player_has_red_flashing_overlay");
		self player_flag_init("player_is_invulnerable");
	}

	self player_flag_clear("player_has_red_flashing_overlay");
	self player_flag_clear("player_is_invulnerable");
	self thread maps/mp/zombies/_zm_playerhealth::healthoverlay();

	level.playerhealth_regularregendelay = 2000;
	level.longregentime = 4000;

	oldratio = 1;
	veryhurt = 0;
	playerjustgotredflashing = 0;
	invultime = 0;
	hurttime = 0;
	newhealth = 0;
	lastinvulratio = 1;
	healthoverlaycutoff = 0.2;

	self thread maps/mp/zombies/_zm_playerhealth::playerhurtcheck();
	if (!isDefined(self.veryhurt)) {
		self.veryhurt = 0;
	}
	self.bolthit = 0;

	if (getDvar("scr_playerInvulTimeScale") == "") {
		setdvar("scr_playerInvulTimeScale", 1);
	}
	playerinvultimescale = getDvarFloat("scr_playerInvulTimeScale");

	for (;;) {
		wait 0.05;
		waittillframeend;

		health_ratio = self.health / self.maxhealth;
		maxhealthratio = self.maxhealth / 100;
		regenrate = 0.05 / maxhealthratio;
		regularregendelay = 2000;
		longregendelay = 4000;

		if (self hasPerk("specialty_quickrevive")) {
			regularregendelay *= 0.75;
			longregendelay *= 0.75;
		}

		if (health_ratio > healthoverlaycutoff) {
			if (self player_flag("player_has_red_flashing_overlay")) {
				player_flag_clear("player_has_red_flashing_overlay");
			}
			lastinvulratio = 1;
			playerjustgotredflashing = 0;
			veryhurt = 0;

			if (self.health == self.maxhealth) {
				continue;
			}
		}
		else if (self.health <= 0) {
			return;
		}

		wasveryhurt = veryhurt;

		if (health_ratio <= healthoverlaycutoff) {
			veryhurt = 1;
			if (!wasveryhurt) {
				hurttime = getTime();
				self player_flag_set("player_has_red_flashing_overlay");
				playerjustgotredflashing = 1;
			}
		}

		if (self.hurtagain) {
			hurttime = getTime();
			self.hurtagain = 0;
		}

		if (health_ratio >= oldratio) {
			if ((getTime() - hurttime) < regularregendelay) {
				continue;
			}
			else {
				self.veryhurt = veryhurt;
				newhealth = health_ratio;
				if (veryhurt) {
					if ((getTime() - hurttime) >= longregendelay) {
						newhealth += regenrate;
					}
				}
				else {
					newhealth += regenrate;
				}
			}

			if (newhealth > 1) {
				newhealth = 1;
			}

			if (newhealth <= 0) {
				return;
			}

			self setnormalhealth(newhealth);
			oldratio = self.health / self.maxhealth;
			continue;
		}
		else {
			invulworthyhealthdrop = (lastinvulratio - health_ratio) > level.worthydamageratio;
		}

		if (self.health <= 1) {
			self setnormalhealth(1 / self.maxhealth);
			invulworthyhealthdrop = 1;
		}

		oldratio = self.health / self.maxhealth;
		self notify("hit_again");
		hurttime = getTime();

		if (!invulworthyhealthdrop || playerinvultimescale <= 0) {
			continue;
		}
		else {
			if (self player_flag("player_is_invulnerable")) {
				continue;
			}
			else {
				self player_flag_set("player_is_invulnerable");
				level notify("player_becoming_invulnerable");
				if (playerjustgotredflashing) {
					invultime = level.invultime_onshield;
					playerjustgotredflashing = 0;
				}
				else if (veryhurt) {
					invultime = level.invultime_postshield;
				}
				else {
					invultime = level.invultime_preshield;
				}
				invultime *= playerinvultimescale;
				lastinvulratio = self.health / self.maxhealth;
				self thread maps/mp/zombies/_zm_playerhealth::playerinvul(invultime);
			}
		}
	}
}







