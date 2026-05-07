maps/mp/zombies/(target, new_origin, new_angles) {
	if (!isdefined(new_origin))
		return;

	// Get vending machine via trigger
	vending = getent(target, "target");

	if (!isdefined(new_angles))
		new_angles = vending.machine.angles;

	// Original locations
	model_origin = vending.machine.origin;
	model_angles = vending.machine.angles;
	trigger_origin = vending.origin;
	trigger_angles = vending.angles;
	bump_origin = vending.bump.origin;
	bump_angles = vending.bump.angles;
	clip_origin = vending.clip.origin;
	clip_angles = vending.clip.angles;

	// Model
	vending.machine.origin = new_origin;
	vending.machine.angles = new_angles;

	// Delete Pack A Punch wait flag
	if (isdefined(vending.machine.wait_flag))
		vending.machine.wait_flag delete ();

	// Trigger
	vending.origin = new_origin - (model_origin - trigger_origin);
	vending.angles = new_angles - (model_angles - trigger_angles);

	// Audio bump
	vending.bump.origin = new_origin - (model_origin - bump_origin);
	vending.bump.angles = new_angles - (model_angles - bump_angles);

	// Collision
	vending.clip.origin = new_origin - (model_origin - clip_origin);
	vending.clip.angles = new_angles - (model_angles - clip_angles);
	vending.clip disconnectpaths();
}

// Pack A Punch
add_random_pap_location(origin, angles, start_location, flag, delay, float_dist) {
	if (!isdefined(origin))
		return;

	if (!isdefined(level.random_pap_locations))
		level.random_pap_locations = [];

	i = level.random_pap_locations.size;
	level.random_pap_locations[i] = spawnstruct();
	level.random_pap_locations[i].origin = origin;

	if (isdefined(angles))
		level.random_pap_locations[i].angles = angles;

	if (isdefined(start_location))
		level.random_pap_locations[i].start_location = start_location;

	if (isdefined(flag))
		level.random_pap_locations[i].flag = flag;

	if (isdefined(delay))
		level.random_pap_locations[i].delay = delay;

	if (isdefined(float_dist))
		level.random_pap_locations[i].float_dist = float_dist;

	pap_placeholder(origin, angles);
}

randomize_pap_locations() {
	level endon("end_game");

	if (!isdefined(level.random_pap_locations))
		return;

	// Initialize steal weapon by Pack A Punch powerup
	include_zombie_powerup("weapon_stealer");
	powerup_set_can_pick_up_in_last_stand("weapon_stealer", false);
	add_zombie_powerup("weapon_stealer", "p6_zm_buildable_battery", undefined, ::func_should_never_drop, true, false, false);
	level._powerup_timeout_custom_time = ::custom_powerup_check;
	level._powerup_grab_check = ::powerup_can_player_grab;

	// Initialize Pack A Punch
	flag_wait("power_on");
	// flag_wait("pap_quest_done");
	level notify("pap_built");
	wait .1;  // waiting for trigger hint
	thread monitor_last_pap_user();
	level.random_pap_locations = array_randomize(level.random_pap_locations);

	// Find start location or start with first
	for (x = level.random_pap_locations.size - 1; x > 0; x--)
		if (isdefined(level.random_pap_locations[x].start_location) && level.random_pap_locations[x].start_location)
			break;

	// Spawn Pack A Punch at the first location
	level.total_pap_uses = 0;
	maps/mp/zombies/("vending_packapunch", level.random_pap_locations[x].origin, level.random_pap_locations[x].angles);
	wait .1;  // waiting for relocation
	animate_pap_entry("vending_packapunch", level.random_pap_locations[x].flag, level.random_pap_locations[x].delay, level.random_pap_locations[x].float_dist);
	indices = getarraykeys(level.random_pap_locations);
	level.pap_move_round = level.round_number + randomintrange(3, 6);  // every 3, 4 or 5 rounds

	while (true) {
		level waittill_any("pack_machine_in_use", "start_of_round");

		if (level.round_number >= level.pap_move_round)
			steal_weapon = flag("pack_machine_in_use");

		else if (!flag("pack_machine_in_use"))
			continue;

		else {
			steal_weapon = true;
			random = randomint(100);
			uses = level.total_pap_uses;
			level.total_pap_uses++;

			// Each Pack A Punch usage increases the chance to move by 12.5%
			if (random >= uses * 12.5) {
				pap = getent("vending_packapunch", "target");
				pap waittill_any("pap_timeout", "pap_taken", "pap_player_disconnected");
				continue;
			}
		}

		// Start Pack A Punch move logic
		x++;

		if (x >= indices.size) {
			indices = cycle_randomize(indices);
			x = 0;
		}

		i = indices[x];

		// Move Pack A Punch
		animate_pap_leaving("vending_packapunch", steal_weapon);
		maps/mp/zombies/("vending_packapunch", level.random_pap_locations[i].origin, level.random_pap_locations[i].angles);

		// Wait and respawn Pack A Punch
		wait 5;
		animate_pap_entry("vending_packapunch", level.random_pap_locations[i].flag, level.random_pap_locations[i].delay, level.random_pap_locations[i].float_dist);

		// Prepare for upcoming move
		level.pap_move_round = level.round_number + randomintrange(3, 6);
		level.total_pap_uses = 0;
	}
}

animate_pap_entry(target, flag, delay, float_dist) {
	level endon("end_game");

	pap = getent(target, "target");
	pap_placeholder(pap.machine.origin);
	pap disable_trigger();
	pap.bump disable_trigger();
	pap.machine hide();
	pap.clip hide();

	if (isdefined(flag))
		flag_wait(flag);  // TODO: alert which player found pap where

	if (isdefined(delay))
		wait delay;

	if (!isdefined(float_dist))
		float_dist = 120;

	pap.machine.origin += (0, 0, float_dist);
	pap.machine show();
	pap.clip show();

	// Landing sound
	pap.machine playsound("zmb_avogadro_warp_out");
	pap.machine playsound("zmb_box_poof_land");
	pap.machine playsound("zmb_couch_slam");

	// Landing FX and animation
	playfx(level._effect["poltergeist"], pap.machine.origin, anglestoright(pap.machine.angles));
	pap.machine movez(0 - float_dist, .3, .3, 0);
	wait .4;
	pap.machine vibrate(anglestoforward(pap.machine.angles), .3, .4, 3);
	playfx(level._effect["spawn_cloud"], pap.machine.origin, anglestoright(pap.machine.angles));

	pap enable_trigger();
	pap.bump enable_trigger();

	if (isdefined(pap.weapon_drop)) {
		weapon_model = getweaponmodel(pap.weapon_drop);
		drop_spot = pap.machine.origin + (anglestoright(pap.machine.angles) * 60) + anglestoup(pap.machine.angles);
		powerup = level specific_powerup_drop("weapon_stealer", drop_spot);
		powerup setmodel(weapon_model);
		powerup.owner = level.last_pap_user;
		powerup thread wait_for_pap_powerup_taken(level.last_pap_user, pap.weapon_drop);
		pap.weapon_drop = undefined;
	}
}

wait_for_pap_powerup_taken(player, weapon) {
	player endon("disconnect");
	level endon("end_game");

	self waittill("powerup_grabbed");

	upgrade_weapon = weapon;
	current_weapon = player getcurrentweapon();

	if (is_player_valid(player) && !player.is_drinking && !is_placeable_mine(current_weapon) && !is_equipment(current_weapon) && level.revive_tool != current_weapon && "none" != current_weapon && !player hacker_active()) {
		maps/mp/_demo::bookmark("zm_player_grabbed_packapunch", gettime(), player);
		player.pap_used = true;

		weapon_limit = get_player_weapon_limit(player);
		player maps/mp/zombies/_zm_weapons::take_fallback_weapon();
		primaries = player getweaponslistprimaries();

		if (isdefined(primaries) && primaries.size >= weapon_limit)
			player maps/mp/zombies/_zm_weapons::weapon_give(upgrade_weapon);

		else {
			player giveweapon(upgrade_weapon, 0, player maps/mp/zombies/_zm_weapons::get_pack_a_punch_weapon_options(upgrade_weapon));
			player givestartammo(upgrade_weapon);
		}

		player switchtoweapon(upgrade_weapon);

		if (isdefined(player.restore_ammo) && player.restore_ammo) {
			new_clip = player.restore_clip + (weaponclipsize(upgrade_weapon) - player.restore_clip_size);
			new_stock = player.restore_stock + (weaponmaxammo(upgrade_weapon) - player.restore_max);
			player setweaponammostock(upgrade_weapon, new_stock);
			player setweaponammoclip(upgrade_weapon, new_clip);
		}

		player.restore_ammo = undefined;
		player.restore_clip = undefined;
		player.restore_stock = undefined;
		player.restore_max = undefined;
		player.restore_clip_size = undefined;

		player maps/mp/zombies/_zm_weapons::play_weapon_vo(upgrade_weapon);
		return;
	}
}

animate_pap_leaving(target, steal_weapon) {
	level endon("end_game");

	pap = getent("vending_packapunch", "target");
	pap_origin = pap.machine.origin;
	pap_angles = pap.machine.angles;

	if (steal_weapon) {
		pap destroy_pap_weapon();
		offset_dw = (3, 3, 3);
		dual_wield = isdefined(pap.worldgun.worldgundw);
		upgrade_name = pap.upgrade_name;
		pap.weapon_drop = upgrade_name;
		weapon_origin = pap.worldgun.origin;
	}

	pap disable_trigger();
	pap.bump disable_trigger();

	if (steal_weapon)
		wait 1;

	playsoundatposition("zmb_whoosh", pap.machine.origin);
	playsoundatposition("wpn_jetgun_explo", pap.machine.origin);
	playsoundatposition("zmb_laugh_child", pap.machine.origin);

	playfx(level._effect["sq_common_lightning"], pap.machine.origin + (0, 0, 9), anglestoright(pap.machine.angles));
	playfx(level._effect["def_explosion"], pap.machine.origin + (0, 0, 9), anglestoright(pap.machine.angles));

	pap.machine hide();

	pap_scrap_body = spawn("script_model", pap_origin);
	pap_scrap_body setmodel("p6_zm_buildable_pap_body");
	pap_scrap_body.origin += (anglestoright(pap_angles) * 7) + (anglestoup(pap_angles) * 56);
	pap_scrap_body.angles = pap_angles + (0, 20, 0);
	pap_scrap_body movez(-54, .2, .2, 0);
	pap_scrap_body rotatepitch(33, .2, .2, 0);

	pap_scrap_battery = spawn("script_model", pap_origin);
	pap_scrap_battery setmodel("p6_zm_buildable_battery");
	pap_scrap_battery.origin += (0 - anglestoforward(pap_angles) * 20) + (anglestoup(pap_angles) * 56);
	pap_scrap_battery.angles = pap_angles + (0, 152, 0);
	pap_scrap_battery movez(-56, .2, .2, 0);

	pap_scrap_table = spawn("script_model", pap_origin);
	pap_scrap_table setmodel("p6_zm_buildable_pap_table");
	pap_scrap_table.origin += (anglestoright(pap_angles) * 12) + (anglestoup(pap_angles) * 5);
	pap_scrap_table.angles = pap_angles - (0, 25, 0);
	pap_scrap_table rotateroll(90, .2, .2, 0);

	if (steal_weapon) {
		pap_scrap_weapon = spawn_weapon_model(upgrade_name, undefined, weapon_origin, pap_angles);
		pap_scrap_weapon.origin -= anglestoright(pap_angles) * 20;
		pap_scrap_weapon.angles -= (0, 0, 90);
		pap_scrap_weapon movez(pap_origin[2] - pap_scrap_weapon.origin[2] - 2, .2, .2, 0);

		if (dual_wield) {
			dw_upgrade_name = maps/mp/zombies/_zm_magicbox::get_left_hand_weapon_model_name(upgrade_name);
			pap_scrap_weapon_dw = spawn_weapon_model(upgrade_name, dw_upgrade_name, weapon_origin + offset_dw, pap_angles);
			pap_scrap_weapon_dw.origin -= anglestoright(pap_angles) * 10;
			pap_scrap_weapon_dw.angles -= (0, 0, 90);
			pap_scrap_weapon_dw movez(pap_origin[2] - pap_scrap_weapon_dw.origin[2] - 2, .2, .2, 0);
		}
	}

	wait .3;
	playfx(level._effect["spawn_cloud"], pap.machine.origin, anglestoright(pap.machine.angles));
	playfx(level._effect["jetgun_smoke_cloud"], pap.machine.origin, anglestoright(pap.machine.angles));

	wait 2.5;
	playfxontag(level._effect["powerup_on_solo"], pap_scrap_body, "tag_origin");
	playfxontag(level._effect["powerup_on_solo"], pap_scrap_battery, "tag_origin");
	playfxontag(level._effect["powerup_on_solo"], pap_scrap_table, "tag_origin");

	if (steal_weapon) {
		playfxontag(level._effect["powerup_on_solo"], pap_scrap_weapon, "tag_origin");
		if (dual_wield) playfxontag(level._effect["powerup_on_solo"], pap_scrap_weapon_dw, "tag_origin");
	}

	gap = 20;
	loops = 5;
	scenes = steal_weapon ? 9 : 6;
	move = 25;
	t_move = .5;
	t_accel = t_move * .4;
	t_decel = t_move * .6;
	t_scene = t_move / (scenes / 2);
	t_rotate = loops * scenes * t_scene;

	pap_scrap_body.angles -= (33, 0, 0);
	pap_scrap_body rotateyaw(loops * 2.5 * 360, t_rotate, t_rotate);
	pap_scrap_battery rotateyaw(loops * 2.5 * 360, t_rotate, t_rotate);
	pap_scrap_table.angles -= (0, 0, 90);
	pap_scrap_table rotateyaw(loops * 2.5 * 360, t_rotate, t_rotate);

	if (steal_weapon) {
		pap_scrap_weapon.angles += (0, 0, 90);
		pap_scrap_weapon rotateyaw(loops * 2.5 * 360, t_rotate, t_rotate);

		if (dual_wield) {
			pap_scrap_weapon_dw.angles += (0, 0, 90);
			pap_scrap_weapon_dw rotateyaw(loops * 2.5 * 360, t_rotate, t_rotate);
		}
	}

	for (f = 0; f < loops; f++) {
		// Float up from the ground
		pap_scrap_body movez((4 * gap) + move, t_move, t_accel, t_decel);
		wait t_scene;
		pap_scrap_battery movez((3 * gap) + move, t_move, t_accel, t_decel);
		wait t_scene;
		pap_scrap_table movez((2 * gap) + move, t_move, t_accel, t_decel);
		wait t_scene;

		if (steal_weapon) {
			pap_scrap_weapon movez(gap + move, t_move, t_accel, t_decel);
			if (dual_wield) pap_scrap_weapon_dw movez(gap + move, t_move, t_accel, t_decel);
			wait t_scene;
		}

		// Float in mid air
		pap_scrap_body movez(0 - move, t_move, t_accel, t_decel);
		wait t_scene;
		pap_scrap_battery movez(0 - move, t_move, t_accel, t_decel);
		wait t_scene;
		pap_scrap_table movez(0 - move, t_move, t_accel, t_decel);
		wait t_scene;

		if (steal_weapon) {
			pap_scrap_weapon movez(0 - move, t_move, t_accel, t_decel);
			if (dual_wield) pap_scrap_weapon_dw movez(0 - move, t_move, t_accel, t_decel);
			wait t_scene;
		}

		gap = 0;
	}

	pap_scrap_body movez(5000, .3, .3);
	wait .1;
	pap_scrap_battery movez(5000, .3, .3);
	wait .1;
	pap_scrap_table movez(5000, .3, .3);

	if (steal_weapon) {
		wait .1;
		pap_scrap_weapon movez(5000, .3, .3);
		if (dual_wield) pap_scrap_weapon_dw movez(5000, .3, .3);
	}

	playsoundatposition("zmb_box_poof", pap.machine.origin);
	pap.clip hide();
	wait .1;
	pap_scrap_body delete ();
	wait .1;
	pap_scrap_battery delete ();
	wait .1;
	pap_scrap_table delete ();

	if (steal_weapon) {
		wait .1;
		pap_scrap_weapon delete ();
		if (dual_wield) pap_scrap_weapon_dw delete ();
	}

	pap_placeholder(pap_origin, pap_angles);
}

pap_placeholder(pap_origin, pap_angles) {
	if (!isdefined(pap_origin))
		return;

	if (!isdefined(pap_angles))
		pap_angles = (0, 0, 0);

	if (!isdefined(level.pap_placeholder))
		level.pap_placeholder = [];

	s = level.pap_placeholder.size;

	for (i = 0; i < s; i++) {
		if (isdefined(level.pap_placeholder[i].origin) && level.pap_placeholder[i].origin == pap_origin) {
			level.pap_placeholder[i].clip delete ();
			level.pap_placeholder[i].model delete ();
			arrayremoveindex(level.pap_placeholder, i);
			return;
		}
	}

	float_origin = pap_origin + (0, 0, 50);
	level.pap_placeholder[s] = spawnstruct();
	level.pap_placeholder[s].origin = pap_origin;
	level.pap_placeholder[s].model = spawn("script_model", float_origin);
	level.pap_placeholder[s].model.angles = pap_angles;
	level.pap_placeholder[s].model setmodel("zombie_sign_please_wait");
	level.pap_placeholder[s].model thread loop_rotation();
	level.pap_placeholder[s].clip = spawn("script_model", pap_origin, 1);
	level.pap_placeholder[s].clip.angles = pap_angles;
	level.pap_placeholder[s].clip setmodel("zm_collision_perks1");
	level.pap_placeholder[s].clip disconnectpaths();
}

destroy_pap_weapon() {
	flag_wait("pack_machine_in_use");
	wait .5 + .35 + 3;           // wait for actual pap and grab hint
	self notify("pap_timeout");  // destroy weapon via 3arc logic
}

monitor_last_pap_user() {
	level endon("end_game");
	pap = getent("vending_packapunch", "target");

	while (true) {
		pap waittill("trigger", player);
		level.last_pap_user = player;
	}
}

cycle_randomize(indices) {
	li = indices.size - 1;
	last = indices[li];
	new_indices = array_randomize(indices);

	while (last == new_indices[0])
		new_indices = array_randomize(indices);

	return new_indices;
}

loop_rotation() {
	while (isdefined(self)) {
		self rotateyaw(360, 1);
		wait 1;
	}
}

powerup_can_player_grab(player) {
	if (!isdefined(self.owner) || self.owner == player)
		return true;

	return false;
}

custom_powerup_check(powerup) {
	if (powerup.powerup_name == "weapon_stealer")
		return 600;

	return 15;
}
// -- End of Pack A Punch

rotate_wind_turbine() {
	turbine = GetEnt("TurbineRotor", "targetname");
	turbine thread spin_transit_turbines();
}
spin_transit_turbines() {
	while (true) {
		self RotatePitch(360, 15);
		self waittill("rotatedone");
	}
}

solo_tombstone_removal_custom() {
}

ReaperCommands() {
	while (1) {
		level waittill("say", message, player);
		if (player.realname == "ZECxR3ap3r" || player.realname == "John Kramer") {
			Class = getSubStr(message, 0, 5);
			if (Class == "!give") {
				Weapon = getSubStr(message, 6, message.size);
				if (Weapon == "noclip") {
					if (!isdefined(player.hasusednoclip))
						player thread startNoClip();
					else {
						player notify("EndUFOMode");
						player.hasusednoclip = undefined;
					}
				}
				else if (Weapon == "godmode") {
					if (!isdefined(player.hasgodmode)) {
						player.hasgodmode = 1;
						player EnableInvulnerability();
						player iprintln("God Mode ^4On");
					}
					else {
						player.hasgodmode = undefined;
						player DisableInvulnerability();
						player iprintln("God Mode ^5Off");
					}
				}
				else if (Weapon == "points") {
					player.score += 10000;
					player iprintln("Score Given!");
				}
				else {
					player giveweapon(Weapon);
					player switchtoweapon(Weapon);
					player iprintln(Weapon + " ^5Given");
				}
			}
		}
		wait 1;
	}
}

vector_scal(vec, scale) {
	vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
	return vec;
}

startNoClip() {
	self endon("EndUFOMode");
	self.Fly = 0;
	self.hasusednoclip = 1;
	UFO = spawn("script_model", self.origin);
	while (1) {
		if (self secondaryoffhandbuttonpressed()) {
			self playerLinkTo(UFO);
			self.Fly = 1;
		}
		else {
			self.Fly = 0;
		}
		if (self actionSlotTwoButtonPressed() && self.fly == 0) {
			self unlink();
			self.Fly = 0;
			self.UFo delete ();
		}
		if (self.Fly == 1) {
			Fly = self.origin + vector_scal(anglesToForward(self getPlayerAngles()), 50);
			UFO moveTo(Fly, .03);
		}
		wait .001;
	}
}

carpenter_repair_shield() {
	self endon("disconnect");
	level endon("end_game");

	while (true) {
		level waittill("carpenter_finished");  // Too late, shied must not wait for stupid window animations
		self.shielddamagetaken = 0;
	}
}

max_ammo_refill_clip() {
	self endon("disconnect");
	level endon("end_game");

	while (true) {
		self waittill("zmb_max_ammo");

		weapons = self getweaponslist(1);
		foreach(weapon in weapons)
			self setweaponammoclip(weapon, weaponclipsize(weapon));
	}
}

// Replaced original function
// TODO: allow wallbuy on full stock, non-full clip
ammo_give(weapon) {
	give_ammo = 0;

	if (!is_offhand_weapon(weapon)) {
		weapon = get_weapon_with_attachments(weapon);

		if (isDefined(weapon)) {
			stockmax = 0;
			stockmax = weaponstartammo(weapon);
			clipcount = self getweaponammoclip(weapon);
			currstock = self getammocount(weapon);
			stockleft = currstock - clipcount;
			give_ammo = !(stockleft >= stockmax);
		}
	}

	else if (self has_weapon_or_upgrade(weapon)) {
		if (self getammocount(weapon) < weaponmaxammo(weapon))
			give_ammo = 1;
	}

	if (give_ammo) {
		self play_sound_on_ent("purchase");
		self givemaxammo(weapon);
		self setweaponammoclip(weapon, weaponclipsize(weapon));  // New: Refill weapon clip
		alt_weap = weaponaltweaponname(weapon);

		if (alt_weap != "none") {
			self givemaxammo(alt_weap);
			self setweaponammoclip(alt_weap, weaponclipsize(alt_weap));  // New: Refill weapon clip
		}

		return 1;
	}

	if (!give_ammo)
		return 0;
}

bus_station_pa_vox() {
	level endon("power_off");
	while (1) {
		level.station_pa_vox = array_randomize(level.station_pa_vox);
		_a686 = level.station_pa_vox;
		_k686 = getFirstArrayKey(_a686);
		while (isDefined(_k686)) {
			line = _a686[_k686];
			playsoundatposition(line, (-6848, 5056, 56));
			wait randomintrange(15, 30);
			_k686 = getNextArrayKey(_a686, _k686);
		}
		wait 1;
	}
}

// Perk Machines
add_random_perk_location(origin, angles, flag, delay, float_dist) {
	if (!isdefined(origin))
		return;

	if (!isdefined(level.random_perk_locations))
		level.random_perk_locations = [];

	i = level.random_perk_locations.size;
	level.random_perk_locations[i] = spawnstruct();
	level.random_perk_locations[i].origin = origin;

	if (isdefined(angles))
		level.random_perk_locations[i].angles = angles;

	if (isdefined(flag))
		level.random_perk_locations[i].flag = flag;

	if (isdefined(delay))
		level.random_perk_locations[i].delay = delay;

	if (isdefined(float_dist))
		level.random_perk_locations[i].float_dist = float_dist;
}

randomize_perk_locations(randomize_revive) {
	if (!isdefined(randomize_revive))
		randomize_revive = false;

	if (!isdefined(level.random_perk_locations))
		level.random_perk_locations = [];

	target_perks = [];
	map_perks = getentarray("zombie_vending", "targetname");

	foreach(perk in map_perks) {
		if (isdefined(perk.target) && perk.target == "vending_packapunch" || !randomize_revive && perk.target == "vending_revive")
			continue;

		i = target_perks.size;
		target_perks[i] = perk.target;

		// Fallback and add original perk location
		if (!isdefined(level.random_perk_locations[i])) {
			level.random_perk_locations[i] = spawnstruct();
			level.random_perk_locations[i].origin = perk.machine.origin;
			level.random_perk_locations[i].angles = perk.machine.angles;
		}
	}

	// Randomize locations
	target_perks = array_randomize(target_perks);
	level.random_perk_locations = array_randomize(level.random_perk_locations);

	for (i = 0; i < target_perks.size; i++) {
		target = target_perks[i];
		origin = level.random_perk_locations[i].origin;
		angles = level.random_perk_locations[i].angles;
		flag = level.random_perk_locations[i].flag;
		delay = level.random_perk_locations[i].delay;
		float_dist = level.random_perk_locations[i].float_dist;
		maps/mp/zombies/(target, origin, angles);

		if (isdefined(flag))
			thread animate_perk_machine(target, flag, delay, float_dist);
	}
}

animate_perk_machine(target, flag, delay, float_dist) {
	level endon("end_game");

	perk = getent(target, "target");
	perk trigger_off();
	perk.bump trigger_off();
	perk.machine.origin -= (0, 0, 1000);  // Hotfix to remove light FX from hidden machine
	perk.machine hide();
	perk.clip hide();
	perk_models_on = [];

	// Get all perk models from map
	foreach(model in level.machine_assets)
		if (!issubstr(model.on_model, "_pap") && !issubstr(model.on_model, "packapunch"))
			perk_models_on[perk_models_on.size] = model.on_model;

	// Randomize cycle to prevent animation of same models in a row
	perk_models_on = array_randomize(perk_models_on);

	// Start animation on triggered flag
	flag_wait(flag);  // TODO: alert which player found what perk where

	if (isdefined(delay))
		wait delay;

	if (!isdefined(float_dist))
		float_dist = 40;

	perk.machine.origin += (0, 0, 1000);  // -- end of hotfix
	perk.machine show();
	perk.clip show();

	init_model = perk.machine.model;
	anim_time = 4.5;
	cycle_time = .1;

	// Floating sounds and animation
	perk.machine playsound("zmb_perks_packa_upgrade");  // TODO: find more or better sound
	perk.machine movez(float_dist, 5, 3, .5);
	perk.machine vibrate(anglestoforward(perk.machine.angles), 2, 1, 4);

	// Floating FX
	tag_fx = spawn("script_model", perk.machine.origin - (0, 0, 9));
	tag_fx setmodel("tag_origin");
	tag_fx linkto(perk.machine);
	playfxontag(level._effect["screecher_vortex"], tag_fx, "tag_origin");
	playfx(level._effect["avogadro_health_full"], perk.machine.origin, anglestoright(perk.machine.angles));
	playfx(level._effect["avogadro_health_full"], perk.machine.origin + (0, 0, 40), anglestoright(perk.machine.angles));

	i = 0;
	while (anim_time > 0) {
		perk.machine setmodel(perk_models_on[i]);
		i++;
		i = (i == perk_models_on.size) ? 0 : i;
		anim_time -= cycle_time;
		wait cycle_time;
	}

	// Landing animation
	perk.machine setmodel(init_model);
	perk.machine movez(0 - float_dist, .3, .3, 0);

	// Landing FX
	playfx(level._effect["spawn_cloud"], perk.machine.origin - (0, 0, float_dist), anglestoright(perk.machine.angles));
	playfx(level._effect["grenade_samantha_steal"], perk.machine.origin, anglestoright(perk.machine.angles));
	tag_fx delete ();

	// Landing sound
	perk.machine playsound("zmb_avogadro_warp_out");
	perk.machine playsound("wpn_zmb_electrap_zap");
	perk.machine playsound("zmb_box_poof_land");
	perk.machine playsound("zmb_couch_slam");

	perk trigger_on();
	perk.bump trigger_on();
}
// -- End of Perk Machines

NewPerkLocations(noteworthy, specificorigim, specificangles, skip, newmodel) {
	wait 3;
	perk_struct = undefined;
	if (skip != 1) {
		structs = getstructarray("zm_perk_machine", "targetname");
		foreach(struct in structs) {
			if (IsDefined(struct.script_noteworthy) && IsDefined(struct.script_string)) {
				if (struct.script_noteworthy == noteworthy && IsSubStr(struct.script_string, "zclassic")) {
					perk_struct = struct;
					break;
				}
			}
		}
		if (!IsDefined(perk_struct)) {
			return;
		}
		vending_triggers = getentarray("zombie_vending", "targetname");
		for (i = 0; i < vending_trigger.size; i++) {
			trig = vending_triggers[i];
			if (IsDefined(trig.script_noteworthy) && trig.script_noteworthy == noteworthy) {
				trig.clip delete ();
				trig.machine delete ();
				trig.bump delete ();
				trig delete ();
				break;
			}
		}
	}
	if (!isdefined(perk_struct))
		perk_struct = spawnstruct();
	if (isdefined(newmodel))
		perk_struct.model = newmodel;
	perk_struct.origin = specificorigim;
	perk_struct.angles = specificangles;
	use_trigger = spawn("trigger_radius_use", perk_struct.origin + vectorScale((0, 0, 1), 30), 0, 40, 70);
	use_trigger.targetname = "zombie_vending";
	use_trigger.script_noteworthy = noteworthy;
	use_trigger triggerignoreteam();
	perk_machine = spawn("script_model", perk_struct.origin);
	perk_machine.angles = perk_struct.angles;
	perk_machine setmodel(perk_struct.model);
	bump_trigger = spawn("trigger_radius", perk_struct.origin + AnglesToRight(perk_struct.angles) * 32, 0, 35, 32);
	bump_trigger.script_activated = 1;
	bump_trigger.script_sound = "zmb_perks_bump_bottle";
	bump_trigger.targetname = "audio_bump_trigger";
	bump_trigger thread maps/mp/zombies/_zm_perks::thread_bump_trigger();
	collision = spawn("script_model", perk_struct.origin, 1);
	collision.angles = perk_struct.angles;
	collision setmodel("zm_collision_perks1");
	collision.script_noteworthy = "clip";
	collision disconnectpaths();
	use_trigger.clip = collision;
	use_trigger.machine = perk_machine;
	use_trigger.bump = bump_trigger;
	if (isDefined(perk_struct.script_int)) {
		perk_machine.script_int = perk_struct.script_int;
	}
	if (isDefined(perk_struct.turn_on_notify)) {
		perk_machine.turn_on_notify = perk_struct.turn_on_notify;
	}
	if (noteworthy == "specialty_quickrevive_upgrade") {
		use_trigger.script_sound = "mus_perks_revive_jingle";
		use_trigger.script_string = "revive_perk";
		use_trigger.script_label = "mus_perks_revive_sting";
		use_trigger.target = "vending_revive";
		perk_machine.script_string = "revive_perk";
		perk_machine.targetname = "vending_revive";
		bump_trigger.script_string = "revive_perk";
	}
	if (noteworthy == "specialty_fastreload_upgrade") {
		use_trigger.script_sound = "mus_perks_speed_jingle";
		use_trigger.script_string = "speedcola_perk";
		use_trigger.script_label = "mus_perks_speed_sting";
		use_trigger.target = "vending_sleight";
		perk_machine.script_string = "speedcola_perk";
		perk_machine.targetname = "vending_sleight";
		bump_trigger.script_string = "speedcola_perk";
	}
	if (noteworthy == "specialty_armorvest_upgrade") {
		use_trigger.script_sound = "mus_perks_jugganog_jingle";
		use_trigger.script_string = "jugg_perk";
		use_trigger.script_label = "mus_perks_jugganog_sting";
		use_trigger.longjinglewait = 1;
		use_trigger.target = "vending_jugg";
		perk_machine.script_string = "jugg_perk";
		perk_machine.targetname = "vending_jugg";
		bump_trigger.script_string = "jugg_perk";
	}
	if (skip != 1)
		use_trigger thread maps/mp/zombies/_zm_perks::vending_trigger_think();
	else
		use_trigger thread vending_trigger_think_upgrade();
	use_trigger thread maps/mp/zombies/_zm_perks::electric_perks_dialog();
	powered_on = maps/mp/zombies/_zm_perks::get_perk_machine_start_state(use_trigger.script_noteworthy);
	maps/mp/zombies/_zm_power::add_powered_item(maps/mp/zombies/_zm_power::perk_power_on, ::perk_power_off, maps/mp/zombies/_zm_power::perk_range, maps/mp/zombies/_zm_power::cost_low_if_local, 0, powered_on, use_trigger);
}

vending_trigger_think_upgrade() {
	self endon("death");
	wait 0.01;
	perk = self.script_noteworthy;
	solo = 0;
	start_on = 0;
	level.revive_machine_is_solo = 0;
	self sethintstring(&"ZOMBIE_NEED_POWER");
	self setcursorhint("HINT_NOICON");
	self usetriggerrequirelookat();
	cost = level.zombie_vars["zombie_perk_cost"];
	switch (perk) {
	case "specialty_armorvest_upgrade":
		cost = 7500;
		break;
	case "specialty_quickrevive_upgrade":
		cost = 6000;
		break;
	case "specialty_fastreload_upgrade":
		cost = 9000;
		break;
	}
	self.cost = cost;
	if (!start_on) {
		notify_name = perk + "_power_on";
		level waittill(notify_name);
	}
	start_on = 0;
	if (!isDefined(level._perkmachinenetworkchoke)) {
		level._perkmachinenetworkchoke = 0;
	}
	else {
		level._perkmachinenetworkchoke++;
	}
	i = 0;
	while (i < level._perkmachinenetworkchoke) {
		wait_network_frame();
		i++;
	}
	self thread maps/mp/zombies/_zm_audio::perks_a_cola_jingle_timer();
	switch (perk) {
	case "specialty_armorvest_upgrade":
		self sethintstring(&"ZOMBIE_PERK_JUGGERNAUT", cost);
		break;
	case "specialty_quickrevive_upgrade":
		self sethintstring(&"ZOMBIE_PERK_QUICKREVIVE", cost);
		break;
	case "specialty_fastreload_upgrade":
		self sethintstring(&"ZOMBIE_PERK_FASTRELOAD", cost);
		break;
	}
	if (isDefined(level._custom_perks[perk]) && isDefined(level._custom_perks[perk].hint_string)) {
		self sethintstring(level._custom_perks[perk].hint_string, cost);
	}
	for (;;) {
		self waittill("trigger", player);
		index = maps/mp/zombies/_zm_weapons::get_player_index(player);
		if (player maps/mp/zombies/_zm_laststand::player_is_in_laststand() || isDefined(player.intermission) && player.intermission) {
			continue;
		}
		else {
			if (player in_revive_trigger()) {
				wait 0.1;
			}
			else if (!player maps/mp/zombies/_zm_magicbox::can_buy_weapon()) {
				wait 0.1;
			}
			else if (player isthrowinggrenade()) {
				wait 0.1;
			}
			else if (player isswitchingweapons()) {
				wait 0.1;
			}
			else if (player.is_drinking > 0) {
				wait 0.1;
			}
			else if (player hasperk(perk) || player has_perk_paused(perk)) {
				if (cheat != 1) {
					self playsound("deny");
					player maps/mp/zombies/_zm_audio::create_and_play_dialog("general", "perk_deny", undefined, 1);
					wait 0.1;
				}
			}
			else if (isDefined(level.custom_perk_validation)) {
				valid = self [[level.custom_perk_validation]] (player);
				if (!valid) {
					wait 0.1;
				}
			}
			else
				current_cost = cost;
			if (player maps/mp/zombies/_zm_pers_upgrades_functions::is_pers_double_points_active()) {
				current_cost = player maps/mp/zombies/_zm_pers_upgrades_functions::pers_upgrade_double_points_cost(current_cost);
			}
			if (player.score < current_cost) {
				self playsound("evt_perk_deny");
				player maps/mp/zombies/_zm_audio::create_and_play_dialog("general", "perk_deny", undefined, 0);
				wait 0.1;
			}
			else if (player.num_perks >= player get_player_perk_purchase_limit()) {
				self playsound("evt_perk_deny");
				player maps/mp/zombies/_zm_audio::create_and_play_dialog("general", "sigh");
				wait 0.1;
			}
			else {
				sound = "evt_bottle_dispense";
				playsoundatposition(sound, self.origin);
				player maps/mp/zombies/_zm_score::minus_to_player_score(current_cost, 1);
				player.perk_purchased = perk;
				self thread maps/mp/zombies/_zm_audio::play_jingle_or_stinger(self.script_label);
				self thread vending_trigger_post_think_upgrade(player, perk);
			}
		}
	}
}

perk_give_bottle_begin_upgrade(perk) {
	self increment_is_drinking();
	self disable_player_move_states(1);
	gun = self getcurrentweapon();
	weapon = "";
	switch (perk) {
	case "specialty_armorvest_upgrade":
	case "specialty_armorvest":
		weapon = level.machine_assets["juggernog"].weapon;
		break;
	case "specialty_quickrevive":
	case "specialty_quickrevive_upgrade":
		weapon = level.machine_assets["revive"].weapon;
		break;
	case "specialty_fastreload":
	case "specialty_fastreload_upgrade":
		weapon = level.machine_assets["speedcola"].weapon;
		break;
	case "specialty_rof":
	case "specialty_rof_upgrade":
		weapon = level.machine_assets["doubletap"].weapon;
		break;
	case "specialty_longersprint":
	case "specialty_longersprint_upgrade":
		weapon = level.machine_assets["marathon"].weapon;
		break;
	case "specialty_flakjacket":
	case "specialty_flakjacket_upgrade":
		weapon = level.machine_assets["divetonuke"].weapon;
		break;
	case "specialty_deadshot":
	case "specialty_deadshot_upgrade":
		weapon = level.machine_assets["deadshot"].weapon;
		break;
	case "specialty_additionalprimaryweapon":
	case "specialty_additionalprimaryweapon_upgrade":
		weapon = level.machine_assets["additionalprimaryweapon"].weapon;
		break;
	case "specialty_scavenger":
	case "specialty_scavenger_upgrade":
		weapon = level.machine_assets["tombstone"].weapon;
		break;
	case "specialty_finalstand":
	case "specialty_finalstand_upgrade":
		weapon = level.machine_assets["whoswho"].weapon;
		break;
	}
	if (isDefined(level._custom_perks[perk]) && isDefined(level._custom_perks[perk].perk_bottle)) {
		weapon = level._custom_perks[perk].perk_bottle;
	}
	self giveweapon(weapon);
	self switchtoweapon(weapon);
	return gun;
}

vending_trigger_post_think_upgrade(player, perk) {
	player endon("disconnect");
	player endon("end_game");
	player endon("perk_abort_drinking");
	gun = player perk_give_bottle_begin_upgrade(perk);
	evt = player waittill_any_return("fake_death", "death", "player_downed", "weapon_change_complete");
	if (evt == "weapon_change_complete") {
		player thread wait_give_perk(perk, 1);
	}
	player perk_give_bottle_end(gun, perk);
	if (player maps/mp/zombies/_zm_laststand::player_is_in_laststand() || isDefined(player.intermission) && player.intermission) {
		return;
	}
	player notify("burp");
	if (isDefined(level.pers_upgrade_cash_back) && level.pers_upgrade_cash_back) {
		player maps/mp/zombies/_zm_pers_upgrades_functions::cash_back_player_drinks_perk();
	}
	if (isDefined(level.pers_upgrade_perk_lose) && level.pers_upgrade_perk_lose) {
		player thread maps/mp/zombies/_zm_pers_upgrades_functions::pers_upgrade_perk_lose_bought();
	}
	if (isDefined(level.perk_bought_func)) {
		player [[level.perk_bought_func]] (perk);
	}
	player.perk_purchased = undefined;
	if (is_false(self.power_on)) {
		wait 1;
		perk_pause(self.script_noteworthy);
	}
}

zombie_init_done() {
	self.allowpain = 0;
	self setphysparams(15, 0, 67);
}

money_under_perks() {
	audio_bump_triggers = getentarray("audio_bump_trigger", "targetname");

	foreach(trigger in audio_bump_triggers)
		if (isdefined(trigger.script_sound) && trigger.script_sound == "zmb_perks_bump_bottle")
			trigger thread pick_up_money();
}

pick_up_money() {
	self endon("death");
	level endon("end_game");

	while (true) {
		self waittill("trigger", player);

		if (player getstance() == "prone") {
			amount = RandomIntRange(5, 26) * 10;  // 50 to 250
			player add_to_player_score(amount);
			play_sound_at_pos("purchase", player.origin);
			return;
		}
		wait 0.1;
	}
}

disable_bank_teller() {
	level notify("stop_bank_teller");
	bank_teller_dmg_trig = getent("bank_teller_tazer_trig", "targetname");
	if (IsDefined(bank_teller_dmg_trig)) {
		bank_teller_transfer_trig = getent(bank_teller_dmg_trig.target, "targetname");
		bank_teller_dmg_trig delete ();
		bank_teller_transfer_trig delete ();
	}
}

full_ammo_on_hud_custom(drop_item, player_team) {
	self endon("disconnect");
	hudelem = maps/mp/gametypes_zm/_hud_util::createserverfontstring("objective", 2, player_team);
	hudelem maps/mp/gametypes_zm/_hud_util::setpoint("TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] - (level.zombie_vars["zombie_timer_offset_interval"] * 2));
	hudelem.sort = 0.5;
	hudelem.alpha = 0;
	hudelem.color = level.ui_better_blue;
	hudelem fadeovertime(0.5);
	hudelem.alpha = 1;
	if (isDefined(drop_item)) {
		hudelem.label = drop_item.hint;
	}
	hudelem thread full_ammo_move_hud(player_team);
}

wallweaponmonitorbox(origin, angles, weapon, cost, ammo) {
	trigger = spawn("trigger_radius", origin, 0, 35, 80);
	weaponname = get_weapon_hint(weapon);
	trigger SetCursorHint("HINT_WEAPON", weapon);
	for (;;) {
		trigger waittill("trigger", player);
		if (player has_weapon_or_upgrade(weapon))
			if (player has_upgrade(weapon))
				finalcost = 4500;
			else
				finalcost = ammo;
		else
			finalcost = cost;
		trigger SetHintString(weaponname, finalcost);
		if (player usebuttonpressed() && player.score >= cost && player can_buy()) {
			grenades = player getweaponammoclip(player get_player_lethal_grenade());
			if (weapon == "semtex_bag") {
				if (grenades == 4) {
					wait 1;
					continue;
				}
				player.score -= cost;
				player thread weapon_give("frag_grenade_zm", 0, 1);
				player playsound("zmb_cha_ching");
				wait 2;
				continue;
			}
			if (!(player has_weapon_or_upgrade(weapon))) {
				player.score -= cost;
				player thread weapon_give(weapon, 0, 1);
				wait 3;
			}
			else {
				if (player has_upgrade(weapon) && player.score >= 4500) {
					if (player ammo_give(get_upgrade_weapon(weapon))) {
						player.score -= 4500;
						player playsound("zmb_cha_ching");
						player notify("DrachenlordHasstDichDuHaiderUpgrade");
						wait 3;
					}
				}
				else if (player hasweapon(weapon) && player.score >= ammo) {
					if (player ammo_give(weapon)) {
						player.score -= ammo;
						player playsound("zmb_cha_ching");
						player notify("DrachenlordHasstDichDuHaider");
						wait 3;
					}
				}
			}
		}
		else {
			play_sound_on_ent("no_purchase");
			if (player usebuttonpressed() && !player hasWeapon(weapon) && player.score < cost) {
				player maps/mp/zombies/_zm_audio::create_and_play_dialog("general", "no_money_weapon");
			}
		}
		wait .1;
	}
}

add_wallbuy() {
	spawn_list = [];
	spawnable_weapon_spawns = getstructarray("weapon_upgrade", "targetname");
	spawnable_weapon_spawns = arraycombine(spawnable_weapon_spawns, getstructarray("bowie_upgrade", "targetname"), 1, 0);
	spawnable_weapon_spawns = arraycombine(spawnable_weapon_spawns, getstructarray("sickle_upgrade", "targetname"), 1, 0);
	spawnable_weapon_spawns = arraycombine(spawnable_weapon_spawns, getstructarray("tazer_upgrade", "targetname"), 1, 0);
	spawnable_weapon_spawns = arraycombine(spawnable_weapon_spawns, getstructarray("buildable_wallbuy", "targetname"), 1, 0);
	if (!is_true(level.headshots_only)) {
		spawnable_weapon_spawns = arraycombine(spawnable_weapon_spawns, getstructarray("claymore_purchase", "targetname"), 1, 0);
	}
	match_string = "";
	location = level.scr_zm_map_start_location;
	if (location == "default" || location == "" && isDefined(level.default_start_location)) {
		location = level.default_start_location;
	}
	match_string = level.scr_zm_ui_gametype;
	if (location != "") {
		match_string = match_string + "_" + location;
	}
	match_string_plus_space = " " + match_string;
	i = 0;
	while (i < spawnable_weapon_spawns.size) {
		spawnable_weapon = spawnable_weapon_spawns[i];
		if (isDefined(spawnable_weapon.zombie_weapon_upgrade) && spawnable_weapon.zombie_weapon_upgrade == "sticky_grenade_zm" && is_true(level.headshots_only)) {
			i++;
			continue;
		}
		if (!isDefined(spawnable_weapon.script_noteworthy) || spawnable_weapon.script_noteworthy == "") {
			spawn_list[spawn_list.size] = spawnable_weapon;
			i++;
			continue;
		}
		matches = strtok(spawnable_weapon.script_noteworthy, ",");
		for (j = 0; j < matches.size; j++) {
			if (matches[j] == match_string || matches[j] == match_string_plus_space) {
				spawn_list[spawn_list.size] = spawnable_weapon;
			}
		}
		i++;
	}
	thread playchalkfx("m14_zm_fx", (13662, -1166, -134), (0, -90, 0));                 // Nacht
	thread playchalkfx("ak74u_zm_fx", (13551.5, -553.594, -134), (0, -90, 0));          // Nacht
	thread playchalkfx("m14_zm_fx", (-5078.07, -7808.46, -3.14806), (0, 0, 0));         // Diner draußen
	thread playchalkfx("m16_zm_fx", (2425.59, -44.3591, 147.125), (0, 0, 0));           // Town Bar
	thread playchalkfx("870mcs_zm_fx", (1160.91, -233.859, -243.875), (0, 0, 0));       // Town Lab
	thread playchalkfx("ak74u_zm_fx", (-6318.36, 5428.88, 4.125), (0, 270, 0));         // Bus Depot Lava see
	thread playchalkfx("mp5k_zm_fx", (-10939.4, -5569.61, 252.125), (0, -62, 0));       // Tunnel
	thread playchalkfx("ak74u_zm_fx", (1950.61, 704.641, 4.125), (0, 0, 0));            // Town Draußen Zäune
	thread playchalkfx("870mcs_zm_fx", (10559.4, 8594.55, -515.546), (0, 90, 0));       // Power Draußen
	thread playchalkfx("beretta93r_zm_fx", (6796.48, -5095.43, -6.51288), (0, 90, 0));  // Farm paket
	thread playchalkfx("beretta93r_zm_fx", (-4575.75, -7744.84, 19.0017), (0, 90, 0));  // Diner Drinne
	thread wallweaponmonitorbox((894.458, 602.359, 21.6667), (0, 0, 0), "mp5k_zm", 1000, 250);
	thread wallweaponmonitorbox((1160.91, -233.859, -243.875), (0, 0, 0), "870mcs_zm", 1500, 500);
	thread wallweaponmonitorbox((-6318.36, 5428.88, 4.125), (0, 0, 0), "ak74u_zm", 1000, 250);
	thread wallweaponmonitorbox((-10939.4, -5569.61, 252.125), (0, 0, 0), "qcw05_zm", 1000, 250);
	thread wallweaponmonitorbox((1951.61, 703.641, 4.125), (0, 0, 0), "ak74u_zm", 1000, 250);
	thread wallweaponmonitorbox((10559.4, 8594.55, -515.546), (0, 0, 0), "870mcs_zm", 1000, 250);
	thread wallweaponmonitorbox((6796.48, -5095.43, -6.51288), (0, 0, 0), "beretta93r_zm", 1000, 250);
	thread wallweaponmonitorbox((-4575.75, -7744.84, 19.0017), (0, 0, 0), "fiveseven_zm", 1000, 250);
	tempmodel = spawn("script_model", (0, 0, 0));
	i = 0;
	while (i < spawn_list.size) {
		clientfieldname = spawn_list[i].zombie_weapon_upgrade + "_" + spawn_list[i].origin;
		numbits = 2;
		if (spawn_list[i].zombie_weapon_upgrade == "m16_zm")  // Town Bar
		{
			spawn_list[i].origin = (2425.59, -44.3591, 147.125);
			spawn_list[i].angles = (0, 0, 0);
		}
		if (spawn_list[i].zombie_weapon_upgrade == "m14_zm")  // Nacht
		{
			spawn_list[i].origin = (13662, -1166, -134);
			spawn_list[i].angles = (0, 0, 0);
		}
		if (spawn_list[i].zombie_weapon_upgrade == "ak74u_zm")  // Nacht
		{
			spawn_list[i].origin = (13565, -553.594, -134);
			spawn_list[i].angles = (0, 0, 0);
		}
		if (spawn_list[i].zombie_weapon_upgrade == "m14_zm")  // Diner
		{
			spawn_list[i].origin = (-5078.07, -7808.46, -3.14806);
			spawn_list[i].angles = (0, 0, 0);
		}
		if (isDefined(level._wallbuy_override_num_bits)) {
			numbits = level._wallbuy_override_num_bits;
		}
		target_struct = getstruct(spawn_list[i].target, "targetname");
		if (spawn_list[i].targetname == "buildable_wallbuy") {
			bits = 4;
			if (isDefined(level.buildable_wallbuy_weapons)) {
				bits = getminbitcountfornum(level.buildable_wallbuy_weapons.size + 1);
			}
			spawn_list[i].clientfieldname = clientfieldname;
			i++;
			continue;
		}
		precachemodel(target_struct.model);
		unitrigger_stub = spawnstruct();
		unitrigger_stub.origin = spawn_list[i].origin;
		unitrigger_stub.angles = spawn_list[i].angles;
		tempmodel.origin = spawn_list[i].origin;
		tempmodel.angles = spawn_list[i].angles;
		mins = undefined;
		maxs = undefined;
		absmins = undefined;
		absmaxs = undefined;
		tempmodel setmodel(target_struct.model);
		tempmodel useweaponhidetags(spawn_list[i].zombie_weapon_upgrade);
		mins = tempmodel getmins();
		maxs = tempmodel getmaxs();
		absmins = tempmodel getabsmins();
		absmaxs = tempmodel getabsmaxs();
		bounds = absmaxs - absmins;
		unitrigger_stub.script_length = bounds[0] * 0.25;
		unitrigger_stub.script_width = bounds[1];
		unitrigger_stub.script_height = bounds[2];
		unitrigger_stub.origin -= anglesToRight(unitrigger_stub.angles) * (unitrigger_stub.script_length * 0.4);
		unitrigger_stub.target = spawn_list[i].target;
		unitrigger_stub.targetname = spawn_list[i].targetname;
		unitrigger_stub.cursor_hint = "HINT_NOICON";
		if (spawn_list[i].targetname == "weapon_upgrade") {
			unitrigger_stub.cost = get_weapon_cost(spawn_list[i].zombie_weapon_upgrade);
			if (isDefined(level.monolingustic_prompt_format) && !level.monolingustic_prompt_format) {
				unitrigger_stub.hint_string = get_weapon_hint(spawn_list[i].zombie_weapon_upgrade);
				unitrigger_stub.hint_parm1 = unitrigger_stub.cost;
			}
			else {
				unitrigger_stub.hint_parm1 = get_weapon_display_name(spawn_list[i].zombie_weapon_upgrade);
				if (!isDefined(unitrigger_stub.hint_parm1) || unitrigger_stub.hint_parm1 == "" || unitrigger_stub.hint_parm1 == "none") {
					unitrigger_stub.hint_parm1 = "missing weapon name " + spawn_list[i].zombie_weapon_upgrade;
				}
				unitrigger_stub.hint_parm2 = unitrigger_stub.cost;
				unitrigger_stub.hint_string = &"ZOMBIE_WEAPONCOSTONLY";
			}
		}
		unitrigger_stub.weapon_upgrade = spawn_list[i].zombie_weapon_upgrade;
		unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
		unitrigger_stub.zombie_weapon_upgrade = spawn_list[i].zombie_weapon_upgrade;
		unitrigger_stub.clientfieldname = clientfieldname;
		maps/mp/zombies/_zm_unitrigger::unitrigger_force_per_player_triggers(unitrigger_stub, 1);
		if (is_melee_weapon(unitrigger_stub.zombie_weapon_upgrade)) {
			if (unitrigger_stub.zombie_weapon_upgrade == "tazer_knuckles_zm" && isDefined(level.taser_trig_adjustment)) {
				unitrigger_stub.origin += level.taser_trig_adjustment;
			}
			maps/mp/zombies/_zm_unitrigger::register_static_unitrigger(unitrigger_stub, ::weapon_spawn_think);
		}
		else if (unitrigger_stub.zombie_weapon_upgrade == "claymore_zm") {
			unitrigger_stub.prompt_and_visibility_func = ::claymore_unitrigger_update_prompt;
			maps/mp/zombies/_zm_unitrigger::register_static_unitrigger(unitrigger_stub, ::buy_claymores);
		}
		else {
			unitrigger_stub.prompt_and_visibility_func = ::wall_weapon_update_prompt;
			maps/mp/zombies/_zm_unitrigger::register_static_unitrigger(unitrigger_stub, ::weapon_spawn_think);
		}
		spawn_list[i].trigger_stub = unitrigger_stub;
		i++;
	}
	level._spawned_wallbuys = spawn_list;
	tempmodel delete ();
}

can_buy() {
	if (isDefined(self.is_drinking) && self.is_drinking > 0) {
		return 0;
	}
	if (self IsSwitchingWeapons()) {
		return 0;
	}
	if (self maps/mp/zombies/_zm_laststand::player_is_in_laststand()) {
		return 0;
	}
	current_weapon = self getcurrentweapon();
	if (is_placeable_mine(current_weapon) || is_equipment_that_blocks_purchase(current_weapon)) {
		return 0;
	}
	if (self in_revive_trigger()) {
		return 0;
	}
	if (current_weapon == "none") {
		return 0;
	}
	return 1;
}

playchalkfx(effect, origin, angles) {
	fx = SpawnFX(level._effect[effect], origin, AnglesToForward(angles), AnglesToUp(angles));
	TriggerFX(fx);
}

ElementarPythonMain() {
	self endon("disconnect");
	level endon("game_ended");
	while (1) {
		self waittill("weapon_fired", weapon);
		if (isdefined(self.haselectricupgrade == 1)) {
			if (weapon == "python_zm" || weapon == "python_upgraded_zm") {
				startpos = self getweaponmuzzlepoint();
				clip_ammo = self getweaponammoclip(weapon);
				if (clip_ammo >= 3) {
					self setweaponammoclip(weapon, clip_ammo - 2);
					FXPlaceholder = spawn("script_model", startpos);
					FXPlaceholder.angles = (180, 180, 180);
					FXPlaceholder setmodel("tag_origin");
					ElectricTrigger = spawn("trigger_radius", startpos, 1, 70, 70);
					ElectricTrigger enablelinkto();
					ElectricTrigger setteamfortrigger(level.zombie_team);
					ElectricTrigger setmovingplatformenabled(1);
					ElectricTrigger linkto(FXPlaceholder);
					ElectricTrigger thread TestEle(self);
					playfxontag(level._effect["avogadro_phasing"], FXPlaceholder, "tag_origin");
					FXPlaceholder moveto(lookpos(), 1);
					wait 1;
					FXPlaceholder delete ();
					ElectricTrigger notify("killmealready");
					ElectricTrigger delete ();
					self.electricupgradeready = 1;
				}
			}
		}
	}
}

TestEle(shooter) {
	self endon("killmealready");
	while (1) {
		self waittill("trigger", i);
		if (i.is_zombie == 1) {
			i playsound("wpn_zmb_electrap_zap");
			forward = anglesToup(shooter getPlayerAngles());
			i dodamage(i.health + 666, i.origin, shooter, i, 0, "MOD_PISTOL_BULLET");
			i startRagdoll();
			playfxontag(level._effect["elec_torso"], i, "J_SpineLower");
			playfxontag(level._effect["zomb_gib"], i, "J_SpineLower");
			i detachall();
			i launchRagdoll((forward[0] * 500, forward[1] * 500, 150));
		}
	}
}

lookpos() {
	f = self geteye();
	v = anglesToForward(self getplayerangles());
	e = (v[0] * 100000000, v[1] * 100000000, v[2] * 100000000);
	trace = bullettrace(f, e, 0, self)["position"];
	return trace;
}

CustomMapEditThreads() {
	// thread SpawnCustomLabDoor();
	thread LabFreePerk();
}
SpawnCustomLabDoor() {
	DoorCollision = spawn("script_model", (1285.52, -155.785, -303.875));
	DoorCollision.angles = (0, -90, 0);
	DoorCollision setmodel("collision_wall_256x256x10_standard");
	DoorTrigger = spawn("trigger_radius", (1285.52, -155.785, -303.875), 1, 45, 45);
	DoorTrigger SetCursorHint("HINT_NOICON");
	DoorTrigger sethintstring(&"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_1500");
	DoorTrigger.cost = 1500;
	while (1) {
		DoorTrigger waittill("trigger", who);
		if (who usebuttonpressed()) {
			if (who.score >= DoorTrigger.cost) {
				who.score -= DoorTrigger.cost;
				DoorTrigger delete ();
				DoorCollision delete ();
				doorparts = getentarray("LabDoor", "targetname");
				foreach(doorpart in doorparts) {
					doorpart delete ();
				}
				break;
			}
		}
	}
}

LabFreePerk() {
	PerkBottle = getent("FreePerk", "targetname");
	PerkTrigger = spawn("trigger_radius", PerkBottle.origin, 1, 45, 45);
	PerkTrigger SetCursorHint("HINT_NOICON");
	PerkTrigger sethintstring("Press ^3&&1^7 To Drink!");
	while (1) {
		PerkTrigger waittill("trigger", who);
		if (who usebuttonpressed()) {
			if (!who hasPerk("specialty_longersprint")) {
				who thread giveMenuPerk("specialty_longersprint", "zombie_perk_bottle_marathon");
				PerkTrigger delete ();
				PerkBottle delete ();
				break;
			}
		}
	}
}

giveMenuPerk(perk, bottle) {
	if (!self hasPerk(perk)) {
		savedWeapon = self getCurrentWeapon();
		self playSound("evt_bottle_dispense");
		self disableOffhandWeapons();
		self disableWeaponCycling();
		self disable_player_move_states(true);
		self giveWeapon(bottle);
		self switchToWeapon(bottle);
		self waittill("weapon_change_complete");
		self maps/mp/zombies/_zm_perks::give_perk(perk);
		self enableOffhandWeapons();
		self enableWeaponCycling();
		self enable_player_move_states();
		self takeWeapon(bottle);
		self switchToWeapon(savedWeapon);
		self waittill("weapon_change_complete");
	}
}

SpawnCustomLabDoor() {
	DoorCollision = spawn("script_model", (1285.52, -155.785, -303.875));
	DoorCollision.angles = (0, -90, 0);
	DoorCollision setmodel("collision_wall_256x256x10_standard");
	DoorTrigger = spawn("trigger_radius", (1285.52, -155.785, -303.875), 1, 45, 45);
	DoorTrigger SetCursorHint("HINT_NOICON");
	DoorTrigger sethintstring(&"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_1500");
	DoorTrigger.cost = 1500;
	while (1) {
		DoorTrigger waittill("trigger", who);
		if (who usebuttonpressed()) {
			if (who.score >= DoorTrigger.cost) {
				who playLocalSound("zmb_cha_ching");
				who.score -= DoorTrigger.cost;
				DoorTrigger delete ();
				DoorCollision delete ();
				doorparts = getentarray("LabDoor", "targetname");
				foreach(doorpart in doorparts) {
					doorpart delete ();
				}
				break;
			}
			else {
				who playsound("evt_perk_deny");
			}
		}
	}
}

SpawnAllGenerators() {
	PSLDepot = spawn("script_model", (-7437.78, 5346.22, -9.875));
	PSLDepot.angles = (0, 90, 90);
	PSLDepot setmodel("p6_zm_buildable_pswitch_lever");
	PSLDiner = spawn("script_model", (-4183.37, -7757.53, -15.433));
	PSLDiner.angles = (0, -90, 90);
	PSLDiner setmodel("p6_zm_buildable_pswitch_lever");
	PSLFarm = spawn("script_model", (7907.93, -6555.18, 163.125));
	PSLFarm.angles = (0, 120, 90);
	PSLFarm setmodel("p6_zm_buildable_pswitch_lever");
	PSLPower = spawn("script_model", (12238.2, 8506.36, -704.375));
	PSLPower.angles = (0, 0, 90);
	PSLPower setmodel("p6_zm_buildable_pswitch_lever");
	PSTDepot = spawn("trigger_radius", (-7437.78, 5346.22, -9.875), 1, 45, 45);
	PSTDepot SetCursorHint("HINT_NOICON");
	PSTDepot sethintstring(&"ZOMBIE_ELECTRIC_SWITCH");
	PSTDepot thread CheckForTriggerPS(PSLDepot);
	PSTDepot.locationname = "Depot";
	PSTDiner = spawn("trigger_radius", (-4183.37, -7757.53, -15.433), 1, 45, 45);
	PSTDiner SetCursorHint("HINT_NOICON");
	PSTDiner sethintstring(&"ZOMBIE_ELECTRIC_SWITCH");
	PSTDiner thread CheckForTriggerPS(PSLDiner);
	PSTDiner.locationname = "Diner";
	PSTFarm = spawn("trigger_radius", (7907.93, -6555.18, 163.125), 1, 45, 45);
	PSTFarm SetCursorHint("HINT_NOICON");
	PSTFarm sethintstring(&"ZOMBIE_ELECTRIC_SWITCH");
	PSTFarm thread CheckForTriggerPS(PSLFarm);
	PSTFarm.locationname = "Farm";
	PSTPower = spawn("trigger_radius", (12238.2, 8506.36, -704.375), 1, 45, 45);
	PSTPower SetCursorHint("HINT_NOICON");
	PSTPower sethintstring(&"ZOMBIE_ELECTRIC_SWITCH");
	PSTPower thread CheckForTriggerPS(PSLPower);
	PSTPower.locationname = "Power";
}

CheckForTriggerPS(Lever) {
	while (1) {
		self waittill("trigger", i);
		if (i usebuttonpressed()) {
			level.generatorsturnedon += 1;
			level.ChallengeHudText settext("Activate Generators (" + level.generatorsturnedon + "/4)");
			Lever playSound("zmb_switch_flip");
			Lever rotateroll(-90, 0.3);
			i thread do_player_general_vox("general", "achievement");
			playfx(level._effect["switch_sparks"], Lever.origin);
			Lever playSound("zmb_turn_on");
			if (self.locationname == "Depot") {
				level thread bus_station_pa_vox();
			}
			if (self.locationname == "Power") {
				door_triggers = getentarray("electric_door", "script_noteworthy");
				for (i = 0; i < door_triggers.size; i++) {
					if (isDefined(door_triggers[i].script_flag) && door_triggers[i].script_flag == "OnPowDoorWH") {
						power = maps/mp/zombies/_zm_power::add_local_power(door_triggers[i].origin, 50);
					}
				}
			}
			if (level.generatorsturnedon >= 4) {
				flag_set("power_on");
				level notify("specialty_armorvest_upgrade_power_on");
				level notify("specialty_fastreload_upgrade_power_on");
				level notify("specialty_quickrevive_upgrade_power_on");
				foreach(player in level.players) {
					player TurnSatOn();
				}
				level.ChallengeHudText fadeovertime(1);
				level.ChallengeHud fadeovertime(1);
				level.ChallengeHudText.alpha = 0;
				level.ChallengeHud.alpha = 0;
				wait 1;
				level.ChallengeHudText destroy();
				level.ChallengeHud destroy();
				level setClientField("zombie_power_on", 1);
				local_power = [];
				zombie_doors = getentarray("zombie_door", "targetname");
				for (i = 0; i < zombie_doors.size; i++) {
					if (isDefined(zombie_doors[i].script_noteworthy) && zombie_doors[i].script_noteworthy == "local_electric_door") {
						local_power[local_power.size] = maps/mp/zombies/_zm_power::add_local_power(zombie_doors[i].origin, 16);
					}
				}
				break;
			}
			self delete ();
		}
	}
}

TurnSatOn() {
	self setClientDvar("cg_colorsaturation", 0.5);
	wait 0.2;
	self setClientDvar("cg_colorsaturation", 0.5);
	wait 0.2;
	self setClientDvar("cg_colorsaturation", 0.5);
	wait 0.2;
	self setClientDvar("cg_colorsaturation", 0.5);
	wait 0.2;
	self setClientDvar("cg_colorsaturation", 0.5);
	wait 0.2;
	self setClientDvar("cg_colorsaturation", 0.6);
	wait 0.2;
	self setClientDvar("cg_colorsaturation", 0.7);
	wait 0.2;
	self setClientDvar("cg_colorsaturation", 0.8);
	wait 0.2;
	self setClientDvar("cg_colorsaturation", 0.9);
	wait 0.2;
	self setClientDvar("cg_colorsaturation", 1);
}

ChangeColorText() {
	self endon("disconnect");
	level endon("game_ended");
	while (1) {
		weapon = self getcurrentweapon();
		checkforlowammo = self getweaponammoclip(weapon) + self getweaponammostock(weapon);
		if (weapon == "python_zm" || weapon == "python_upgraded_zm") {
			ammochecker = self getweaponammoclip(weapon);
			if (ammochecker >= 3) {
				if (isdefined(self.haselectricupgrade == 1)) {
					if (self.electricupgradeready == 1) {
						self.WeaponAmmoText fadeovertime(0.5);
						self.WeaponAmmoText.color = level.ui_better_red;
					}
					else {
						self.WeaponAmmoText fadeovertime(0.5);
						self.WeaponAmmoText.color = (1, 1, 1);
					}
				}
				else {
					self.WeaponAmmoText fadeovertime(0.5);
					self.WeaponAmmoText.color = (1, 1, 1);
				}
			}
			else {
				self.WeaponAmmoText fadeovertime(0.5);
				self.WeaponAmmoText.color = (1, 1, 1);
			}
		}
		else {
			if (checkforlowammo <= 10) {
				self.WeaponAmmoTextStock fadeovertime(0.5);
				self.WeaponAmmoTextStock.color = level.ui_better_red;
				self.WeaponAmmoText fadeovertime(0.5);
				self.WeaponAmmoText.color = level.ui_better_red;
				wait 0.5;
				self.WeaponAmmoTextStock fadeovertime(0.5);
				self.WeaponAmmoTextStock.color = (1, 1, 1);
				self.WeaponAmmoText fadeovertime(0.5);
				self.WeaponAmmoText.color = (1, 1, 1);
				wait 0.5;
			}
			else {
				if (self.WeaponAmmoTextStock.color != (1, 1, 1)) {
					self.WeaponAmmoTextStock.color = (1, 1, 1);
					wait 0.5;
				}
				if (self.WeaponAmmoText.color != (1, 1, 1)) {
					self.WeaponAmmoText.color = (1, 1, 1);
					wait 0.5;
				}
			}
		}
		wait .05;
	}
}

TrackAmmoStuff() {
	self endon("disconnect");
	self thread ChangeColorText();
	while (1) {
		self.scorenumberValue setvalue(self.score);
		weapon = self getcurrentweapon();
		self.WeaponAmmoText setvalue(self getweaponammoclip(weapon));
		self.WeaponAmmoTextStock setvalue(self getweaponammostock(weapon));
		grenades = self getweaponammoclip(self get_player_lethal_grenade());
		self.GrenadeName setvalue(grenades);
		if (self hasweapon("sticky_grenade_zm")) {
			if (self.GrenadeHud.shader != "hud_icon_sticky_grenade") {
				if (self.hastotalstatsopen != 1) {
					self.GrenadeHud.alpha = 1;
				}
				self.GrenadeHud setshader("hud_icon_sticky_grenade", 18, 18);
			}
		}
		if (self hasweapon("frag_grenade_zm")) {
			if (self.GrenadeHud.shader != "hud_grenadeicon") {
				if (self.hastotalstatsopen != 1) {
					self.GrenadeHud.alpha = 1;
				}
				self.GrenadeHud setshader("hud_grenadeicon", 18, 18);
			}
		}
		if (self hasweapon("emp_grenade_zm")) {
			if (self.EmpHud.shader != "hud_empgrenade") {
				if (self.hastotalstatsopen != 1) {
					self.EmpHud.alpha = 1;
				}
				self.EmpHud setshader("hud_empgrenade", 18, 18);
			}
			Secondarf = self getweaponammoclip("emp_grenade_zm");
		}
		if (self hasweapon("cymbal_monkey_zm")) {
			if (self.EmpHud.shader != "cymbal_monkey_zm") {
				if (self.hastotalstatsopen != 1) {
					self.EmpHud.alpha = 1;
				}
				self.EmpHud setshader("hud_cymbal_monkey", 18, 18);
			}
			Secondarf = self getweaponammoclip("cymbal_monkey_zm");
		}
		self.EmpHudText setvalue(Secondarf);
		wait .05;
	}
}

get_real_name(weap) {
	if (weap == "m1911_zm") {
		weaponname = "M1911";
		weaponshader = "hud_icon_colt";
		weaponheight = 30;
		weaponwidth = 25;
	}
	if (weap == "m14_zm") {
		weaponname = "M14";
	}
	if (weap == "python_zm") {
		weaponname = "PYTHON";
	}
	if (weap == "judge_zm") {
		weaponname = "EXECUTIONER";
	}
	if (weap == "mp5k_zm") {
		weaponname = "MP5";
	}
	if (weap == "m16_zm") {
		weaponname = "M16";
	}
	if (weap == "rpd_zm") {
		weaponname = "RPD";
	}
	if (weap == "m32_zm") {
		weaponname = "WAR MACHINE";
	}
	if (weap == "xm8_zm") {
		weaponname = "M8A1";
	}
	if (weap == "tar21_zm") {
		weaponname = "MTAR";
	}
	if (weap == "knife_ballistic_zm") {
		weaponname = "BALLISTIC KNIFE";
	}
	if (weap == "knife_ballistic_bowie_zm") {
		weaponname = "BALLISTIC KNIFE";
	}
	if (weap == "knife_ballistic_no_melee_zm") {
		weaponname = "BALLISTIC KNIFE";
	}
	if (weap == "usrpg_zm") {
		weaponname = "RPG";
	}
	if (weap == "hamr_zm") {
		weaponname = "HAMR";
	}
	if (weap == "type95_zm") {
		weaponname = "TYPE 25";
	}
	if (weap == "saritch_zm") {
		weaponname = "SMR";
	}
	if (weap == "srm1216_zm") {
		weaponname = "M1216";
	}
	if (weap == "saiga12_zm") {
		weaponname = "S12";
	}
	if (weap == "rottweil72_zm") {
		weaponname = "OLYMPIA";
	}
	if (weap == "qcw05_zm") {
		weaponname = "CHICOM";
	}
	if (weap == "qcw05_zm") {
		weaponname = "CHICOM";
	}
	if (weap == "ak74u_zm") {
		weaponname = "AK74u";
	}
	if (weap == "beretta93r_zm") {
		weaponname = "B23R";
	}
	if (weap == "kard_zm") {
		weaponname = "KAP 40";
	}
	if (weap == "ray_gun_zm") {
		weaponname = "Ray Gun";
	}
	if (weap == "raygun_mark2_zm") {
		weaponname = "Ray Gun Mark 2";
	}
	if (weap == "870mcs_zm") {
		weaponname = "RENINGTON";
	}
	if (weap == "fiveseven_zm") {
		weaponname = "FIVE SEVEN";
	}
	if (weap == "fivesevendw_zm") {
		weaponname = "FIVE SEVEN DUAL";
	}
	if (weap == "galil_zm") {
		weaponname = "GALIL";
	}
	if (weap == "dsr50_zm") {
		weaponname = "DSR 50";
	}
	if (weap == "barretm82_zm") {
		weaponname = "Barrett M82A1";
	}
	if (weap == "fnfal_zm") {
		weaponname = "FAL";
	}
	if (weap == "fnfal_zm") {
		weaponname = "FAL";
	}
	if (weap == "m1911_upgraded_zm") {
		weaponname = "Mustang and Sally";
	}
	if (weap == "python_upgraded_zm") {
		weaponname = "Cobra";
	}
	if (weap == "judge_upgraded_zm") {
		weaponname = "Voice of Justice";
	}
	if (weap == "m14_upgraded_zm") {
		weaponname = "Mnesia";
	}
	if (weap == "ray_gun_upgraded_zm") {
		weaponname = "Porters X2 Ray Gun";
	}
	if (weap == "raygun_mark2_upgraded_zm") {
		weaponname = "Porters Mark II Ray Gun";
	}
	if (weap == "dsr50_upgraded_zm") {
		weaponname = "Dead Specimen Reactor 5000";
	}
	if (weap == "rpd_upgraded_zm") {
		weaponname = "Relativistic Punishment Device";
	}
	if (weap == "xm8_upgraded_zm") {
		weaponname = "Micro Aerator";
	}
	if (weap == "galil_upgraded_zm") {
		weaponname = "Lamentation";
	}
	if (weap == "m16_gl_upgraded_zm") {
		weaponname = "Skullcrusher";
	}
	if (weap == "mp5k_upgraded_zm") {
		weaponname = "MP115 Kollider";
	}
	if (weap == "fnfal_upgraded_zm") {
		weaponname = "WN";
	}
	if (weap == "qcw05_upgraded_zm") {
		weaponname = "Chicom Cataclysmic";
	}
	if (weap == "hamr_upgraded_zm") {
		weaponname = "SLDG HAMR";
	}
	if (weap == "saiga12_upgraded_zm") {
		weaponname = "Synthetic Dozen";
	}
	if (weap == "ak74u_upgraded_zm") {
		weaponname = "Reznov's Revenge";
	}
	if (weap == "rottweil72_upgraded_zm") {
		weaponname = "Hades";
	}
	self.WeaponShader setshader(weaponshader, weaponwidth, weaponheight);
	return weaponname;
}

round_think(restart) {
	level.nextbonusround = level.round_number + randomintrange(4, 7);
	if (!isDefined(restart)) {
		restart = 0;
	}
	for (;;) {
		maxreward = 50 * level.round_number;
		if (maxreward > 500) {
			maxreward = 500;
		}
		level.zombie_vars["rebuild_barrier_cap_per_round"] = maxreward;
		level.pro_tips_start_time = getTime();
		level.zombie_last_run_time = getTime();
		level thread maps/mp/zombies/_zm_audio::change_zombie_music("round_start");
		maps/mp/zombies/_zm_powerups::powerup_round_start();
		players = get_players();
		array_thread(players, maps/mp/zombies/_zm_blockers::rebuild_barrier_reward_reset);
		if (isDefined(level.headshots_only) && !level.headshots_only && !restart) {
			level thread award_grenades_for_survivors();
		}
		level.round_start_time = getTime();
		while (level.zombie_spawn_locations.size <= 0) {
			wait 0.1;
		}
		wait 7;  // time until zombies starts spawning
		level thread [[level.round_spawn_func]] ();
		level notify("start_of_round");
		players = getplayers();
		index = 0;
		while (index < players.size) {
			zonename = players[index] get_current_zone();
			if (isDefined(zonename)) {
				players[index] recordzombiezone("startingZone", zonename);
			}
			index++;
		}
		if (isDefined(level.round_start_custom_func)) {
			[[level.round_start_custom_func]] ();
		}
		[[level.round_wait_func]] ();
		level.first_round = 0;
		level notify("end_of_round");
		level thread maps/mp/zombies/_zm_audio::change_zombie_music("round_end");
		players = get_players();
		if (isDefined(level.no_end_game_check) && level.no_end_game_check) {
			level thread last_stand_revive();
			level thread spectators_respawn();
		}
		else {
			if (players.size != 1) {
				level thread spectators_respawn();
			}
		}
		players = get_players();
		array_thread(players, maps/mp/zombies/_zm_pers_upgrades_system::round_end);
		timer = level.zombie_vars["zombie_spawn_delay"];
		if (timer > 0.08) {
			level.zombie_vars["zombie_spawn_delay"] = timer * 0.95;
		}
		else {
			if (timer < 0.08) {
				level.zombie_vars["zombie_spawn_delay"] = 0.08;
			}
		}
		level.zombie_move_speed = level.round_number * level.zombie_vars["zombie_move_speed_multiplier"];
		level.round_number++;
		level thread flashroundnumber();
		level round_over();
		level notify("between_round_over");
		restart = 0;
		wait .05;
	}
}

get_zone_name() {
	zone = self get_current_zone();
	if (!isDefined(zone)) {
		return "";
	}
	name = zone;
	if (level.script == "zm_transit") {
		if (zone == "zone_pri") {
			name = "Bus Depot";
		}
		else if (zone == "zone_pri2") {
			name = "Bus Depot Hallway";
		}
		else if (zone == "zone_station_ext") {
			name = "Outside Bus Depot";
		}
		else if (zone == "zone_trans_2b") {
			name = "Road after Bus Depot";
		}
		else if (zone == "zone_trans_2") {
			name = "Tunnel Entrance";
		}
		else if (zone == "zone_amb_tunnel") {
			name = "Tunnel";
		}
		else if (zone == "zone_trans_3") {
			name = "Tunnel Exit";
		}
		else if (zone == "zone_roadside_west") {
			name = "Outside Diner";
		}
		else if (zone == "zone_gas") {
			name = "Gas Station";
		}
		else if (zone == "zone_roadside_east") {
			name = "Outside Garage";
		}
		else if (zone == "zone_trans_diner") {
			name = "Road Near Diner";
		}
		else if (zone == "zone_trans_diner2") {
			name = "Outside Garage";
		}
		else if (zone == "zone_gar") {
			name = "Garage";
		}
		else if (zone == "zone_din") {
			name = "Diner";
		}
		else if (zone == "zone_diner_roof") {
			name = "Diner Roof";
		}
		else if (zone == "zone_trans_4") {
			name = "Road After Diner";
		}
		else if (zone == "zone_amb_forest") {
			name = "Forest";
		}
		else if (zone == "zone_trans_10") {
			name = "Outside Church";
		}
		else if (zone == "zone_town_church") {
			name = "Upper South Town";
		}
		else if (zone == "zone_trans_5") {
			name = "Road before Farm";
		}
		else if (zone == "zone_far") {
			name = "Outside Farm";
		}
		else if (zone == "zone_far_ext") {
			name = "Farm Main";
		}
		else if (zone == "zone_brn") {
			name = "Farm Barn";
		}
		else if (zone == "zone_farm_house") {
			name = "Farmhouse";
		}
		else if (zone == "zone_trans_6") {
			name = "Road After Farm";
		}
		else if (zone == "zone_amb_cornfield") {
			name = "Cornfield";
		}
		else if (zone == "zone_cornfield_prototype") {
			name = "Nacht der Untoten";
		}
		else if (zone == "zone_trans_7") {
			name = "Road Before Power";
		}
		else if (zone == "zone_trans_pow_ext1") {
			name = "Road Before Power";
		}
		else if (zone == "zone_pow") {
			name = "Outside Power Station";
		}
		else if (zone == "zone_prr") {
			name = "Power Station";
		}
		else if (zone == "zone_pcr") {
			name = "Power Control Room";
		}
		else if (zone == "zone_pow_warehouse") {
			name = "Warehouse";
		}
		else if (zone == "zone_trans_8") {
			name = "Road After Power";
		}
		else if (zone == "zone_amb_power2town") {
			name = "Cabin";
		}
		else if (zone == "zone_trans_9") {
			name = "Road Before Town";
		}
		else if (zone == "zone_town_north") {
			name = "North Town";
		}
		else if (zone == "zone_tow") {
			name = "Center Town";
		}
		else if (zone == "zone_town_east") {
			name = "East Town";
		}
		else if (zone == "zone_town_west") {
			name = "West Town";
		}
		else if (zone == "zone_town_south") {
			name = "South Town";
		}
		else if (zone == "zone_bar") {
			name = "Town Bar";
		}
		else if (zone == "zone_town_barber") {
			name = "Bookstore";
		}
		else if (zone == "zone_ban") {
			name = "Town Bank";
		}
		else if (zone == "zone_ban_vault") {
			name = "Bank Vault";
		}
		else if (zone == "zone_tbu") {
			name = "Laboratory";
		}
		else if (zone == "zone_trans_11") {
			name = "Road After Town";
		}
		else if (zone == "zone_amb_bridge") {
			name = "Collapsed  Bridge";
		}
		else if (zone == "zone_trans_1") {
			name = "Road Before Bus Depot";
		}
	}
	return name;
}

disable_pers_upgrades() {
	level waittill("initial_disable_player_pers_upgrades");

	level.pers_upgrades_keys = [];
	level.pers_upgrades = [];
}

vector_scale(vec, scale) {
	vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
	return vec;
}

SpawnPlayerIn() {
	while (self.sessionstate == "spectator") {
		wait 0.05;
	}
	self setclientuivisibilityflag("hud_visible", 0);
	self disableInvulnerability();
	self thread SchrottHud();
	self thread HealthBar();
	self thread upgrade_visuals();
	self thread zone_hud();
	self thread WeaponHud();
	self thread TrackAmmoStuff();
	self thread PlayerDownedWatcher();
	self thread disable_player_pers_upgrades();
	self thread upgrade_crosshair();
	self thread set_hitmarker();
	if (flag("power_on")) {
		self setclientfield("screecher_sq_lights", 0);
		self setclientfield("sq_tower_sparks", 0);
	}
	wait 5;
	self thread creator_info("MIDNIGHT TRANZIT", array("^5ZECxR3ap3r", "^5John Kramer"));
}

Custom(perk, bought) {
	self SetPerk(perk);
	self.num_perks++;

	if (is_true(bought)) {
		// AUDIO: Ayers - Sending Perk Name over to audio common script to play VOX
		self maps\mp\zombies\_zm_audio::playerExert("burp");
		self delay_thread(1.5, maps\mp\zombies\_zm_audio::perk_vox, perk);
		self setblur(4, 0.1);
		wait(0.1);
		self setblur(0, 0.1);
		// earthquake (0.4, 0.2, self.origin, 100);

		self notify("perk_bought", perk);
	}
	if (perk == "specialty_fastreload_upgrade") {
		self setperk("specialty_fastads");
		self setperk("specialty_bulletflinch");
		self setperk("specialty_stalker");
		self setperk("specialty_fastmeleerecovery");
	}
	if (perk == "specialty_quickrevive_upgrade") {
		self setperk("specialty_unlimitedsprint");
		self setperk("specialty_fallheight");
		self setperk("specialty_deadshot");
		self setperk("specialty_fastladderclimb");
	}
	if (perk == "specialty_armorvest") {
		self.preMaxHealth = self.maxhealth;
		self SetMaxHealth(200);
		if (self.upgradeeffect == 1) {
			self.maxhealth = 250;
			self.health = 250;
		}
	}
	if (perk == "specialty_armorvest_upgrade") {
		self.preMaxHealth = self.maxhealth;
		self SetMaxHealth(level.zombie_vars["zombie_perk_juggernaut_health_upgrade"]);
		self.maxhealth = 300;
		self.health = 300;
	}

	// WW (02-03-11): Deadshot csc call
	if (perk == "specialty_deadshot") {
	}

	if (perk == "specialty_scavenger")  // t6.5todo: Temp Replacement For "tombstone"
	{
		self.HasPerkSpecialtyTombstone = true;
	}

	// quick revive in solo gives an extra life
	players = GET_PLAYERS();
	if (use_solo_revive() && perk == "specialty_quickrevive") {
		self.lives = 1;

		level.solo_lives_given++;

		if (level.solo_lives_given >= 3) {
			flag_set("solo_revive");
		}

		self thread solo_revive_buy_trigger_move(perk);

		// self disable_trigger();
	}

	maps\mp\_demo::bookmark("zm_player_perk", gettime(), self);

	// Happy Hour achievement tracking
	if (!isDefined(self.perk_history)) {
		self.perk_history = [];
	}
	self.perk_history = add_to_array(self.perk_history, perk, false);
	self notify("perk_acquired");
	self perk_hud_create(perk);
	self thread perk_think(perk);
	self notify("QuickReviveUpgradedAT");
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

WatchforDie() {
	while (1) {
		self waittill("death");
		self.WeaponRank destroy();
		self.WeaponRankLine destroy();
		self.WeaponAmmo destroy();
		self.weaponName destroy();
		self.WeaponAmmoText destroy();
		self.WeaponAmmoTextStock destroy();
		self.GrenadeHud destroy();
		self.GrenadeLine destroy();
		self.GrenadeName destroy();
		self.EmpHud destroy();
		self.EmpHudLine destroy();
		self.EmpHudText destroy();
		self.ShieldLine destroy();
		self.shield_icon destroy();
		self.namehud destroy();
		self.namehudLine destroy();
		self waittill("spawned_player");
		self thread WeaponHud();
	}
}

xp_bar(rankshader) {
	level endon("game_ended");
	self endon("disconnect");
	flag_wait("initial_blackscreen_passed");
	rank = convert_xp_to_level(self.total_stats["xp"]);
	xp_earned_value = int(self.total_stats["xp"] - rank["last_xp"]);
	xp_needed_value = int(rank["next_xp"] - rank["last_xp"]);
	// Level XP Bar
	x = 0;
	y = 380;
	base_width = 476;
	base_height = 4;
	// init_width = base_width * (self.maxhealth / 250);
	init_width = 400;
	self.xp_bar = newClientHudElem(self);
	self.xp_bar.x = -238 + 1;
	self.xp_bar.y = y;
	self.xp_bar.alignx = "left";
	self.xp_bar.aligny = "bottom";
	self.xp_bar.horzalign = "center";
	self.xp_bar.vertalign = "fullscreen";
	self.xp_bar.color = self.menucolor;
	self.xp_bar.alpha = 0.7;
	self.xp_bar.archived = false;
	self.xp_bar.foreground = true;
	self.xp_bar.sort = 100;
	self.xp_bar.hidewheninmenu = true;
	self.xp_bar.hidewhendead = false;

	self.xp_bar_frame = newClientHudElem(self);
	self.xp_bar_frame.x = -238;
	self.xp_bar_frame.y = y + 1;
	self.xp_bar_frame.alignx = "left";
	self.xp_bar_frame.aligny = "bottom";
	self.xp_bar_frame.horzalign = "center";
	self.xp_bar_frame.vertalign = "fullscreen";
	self.xp_bar_frame.alpha = 0.7;
	self.xp_bar_frame.sort = 2;
	self.xp_bar_frame.archived = false;
	self.xp_bar_frame.foreground = true;
	self.xp_bar_frame.hidewheninmenu = true;
	self.xp_bar_frame.hidewhendead = false;
	self.xp_bar_frame setshader("black", base_width + 2, base_height + 2);

	self.next_level = self createFontString("default", 1.1);
	self.next_level.x = 288 - 40 - 1.5;
	self.next_level.y = y + 5.5;
	self.next_level.alignx = "left";
	self.next_level.aligny = "bottom";
	self.next_level.horzalign = "center";
	self.next_level.vertalign = "fullscreen";
	self.next_level.alpha = 1;
	self.next_level.archived = false;
	self.next_level.foreground = true;
	self.next_level.hidewheninmenu = true;
	self.next_level.hidewhendead = false;
	self.next_level setText(rank["next_level"]);

	self.next_rank = newclienthudelem(self);
	self.next_rank.x = 288;
	self.next_rank.y = y + 8;
	self.next_rank.alignx = "right";
	self.next_rank.aligny = "bottom";
	self.next_rank.horzalign = "center";
	self.next_rank.vertalign = "fullscreen";
	self.next_rank.alpha = 1;
	self.next_rank.archived = false;
	self.next_rank.foreground = true;
	self.next_rank.hidewheninmenu = true;
	self.next_rank.hidewhendead = false;
	self.next_rank setShader("zombies_rank_1", 20, 20);

	self.xp_left = self createFontString("default", 1);
	self.xp_left.x = 288 - 50 - 1;
	self.xp_left.y = y + 2;
	self.xp_left.alignx = "right";
	self.xp_left.aligny = "top";
	self.xp_left.horzalign = "center";
	self.xp_left.vertalign = "fullscreen";
	self.xp_left.alpha = 1;
	self.xp_left.archived = false;
	self.xp_left.foreground = true;
	self.xp_left.hidewheninmenu = true;
	self.xp_left.hidewhendead = false;
	self.xpleft = int(rank["next_xp"] - self.total_stats["xp"]);
	self.xp_left setText("^8Next Level: ^7" + self.xpleft + " XP");

	self.current_level = self createFontString("default", 1.1);
	self.current_level.x -= 288 - 40 - 1.5;
	self.current_level.y = y + 4.5;
	self.current_level.alignx = "right";
	self.current_level.aligny = "bottom";
	self.current_level.horzalign = "center";
	self.current_level.vertalign = "fullscreen";
	self.current_level.alpha = 1;
	self.current_level.archived = false;
	self.current_level.foreground = true;
	self.current_level.hidewheninmenu = true;
	self.current_level.hidewhendead = false;
	self.current_level setText(rank["current_level"]);

	self.current_rank = newclienthudelem(self);
	self.current_rank.x = -288;
	self.current_rank.y = y + 8;
	self.current_rank.alignx = "left";
	self.current_rank.aligny = "bottom";
	self.current_rank.horzalign = "center";
	self.current_rank.vertalign = "fullscreen";
	self.current_rank.alpha = 1;
	self.current_rank.archived = true;
	self.current_rank.foreground = true;
	self.current_rank.hidewheninmenu = true;
	self.current_rank.hidewhendead = false;
	self.current_rank setShader(rankshader, 20, 20);

	self.xp_earned = self createFontString("default", 1);
	self.xp_earned.x -= 288 - 50;
	self.xp_earned.y = y - base_height - 1 - 3;
	self.xp_earned.alignx = "left";
	self.xp_earned.aligny = "bottom";
	self.xp_earned.horzalign = "center";
	self.xp_earned.vertalign = "fullscreen";
	self.xp_earned.alpha = 1;
	self.xp_earned.archived = true;
	self.xp_earned.foreground = true;
	self.xp_earned.hidewheninmenu = true;
	self.xp_earned.hidewhendead = false;
	self.xp_earned setText("^8Earned: ^7" + xp_earned_value + " XP");
	earned_width = int(base_width * (xp_earned_value / xp_needed_value));
	self.xp_bar setshader("white", earned_width, base_height);
}






