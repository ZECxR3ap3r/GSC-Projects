buildbuildables() {
	// need a wait or else some buildables dont build
	wait 1;
	buildbuildable("turbine", 1);
	buildbuildable("electric_trap", 1);
	buildbuildable("turret", 1);
	buildbuildable("riotshield_zm", 1);
	removebuildable("jetgun_zm", 1);
	removebuildable("powerswitch", 1);
	removebuildable("pap", 1);
	removebuildable("sq_common", 1);
}

buildbuildable(buildable, craft) {
	if (!isDefined(craft)) {
		craft = 0;
	}

	player = get_players()[0];
	foreach(stub in level.buildable_stubs) {
		if (!isDefined(buildable) || stub.equipname == buildable) {
			if (isDefined(buildable) || stub.persistent != 3) {
				displayname = stub get_equipment_display_name();
				stub.cost = stub get_equipment_cost();
				stub.trigger_hintstring = "Hold ^3[{+activate}]^7 for " + displayname + " [Cost: " + stub.cost + "]";
				stub.trigger_func = ::buildable_place_think;

				if (craft) {
					stub maps/mp/zombies/_zm_buildables::buildablestub_finish_build(player);
					stub maps/mp/zombies/_zm_buildables::buildablestub_remove();
					stub.model notsolid();
					stub.model show();
				}
				i = 0;
				foreach(piece in stub.buildablezone.pieces) {
					piece maps/mp/zombies/_zm_buildables::piece_unspawn();
					if (!craft && i > 0) {
						stub.buildablezone maps/mp/zombies/_zm_buildables::buildable_set_piece_built(piece);
					}
					i++;
				}

				return;
			}
		}
	}
}

get_equipment_display_name() {
	if (self.equipname == "turbine") {
		return "Turbine";
	}
	else if (self.equipname == "turret") {
		return "Turret";
	}
	else if (self.equipname == "electric_trap") {
		return "Electric Trap";
	}
	else if (self.equipname == "riotshield_zm") {
		return "Zombie Shield";
	}
}

get_equipment_cost() {
	if (self.equipname == "turbine") {
		return 500;
	}
	if (self.equipname == "electric_trap") {
		return 1000;
	}
	if (self.equipname == "turret") {
		return 1000;
	}
	return 1250;
}

buildable_place_think() {
	self endon("kill_trigger");
	player_built = undefined;
	while (isDefined(self.stub.built) && !self.stub.built) {
		self waittill("trigger", player);
		if (player != self.parent_player) {
			continue;
		}
		if (isDefined(player.screecher_weapon)) {
			continue;
		}
		if (!is_player_valid(player)) {
			player thread ignore_triggers(0.5);
		}
		status = player maps/mp/zombies/_zm_buildables::player_can_build(self.stub.buildablezone);
		if (!status) {
			self.stub.hint_string = "";
			self sethintstring(self.stub.hint_string);
			if (isDefined(self.stub.oncantuse)) {
				self.stub [[self.stub.oncantuse]] (player);
			}
			continue;
		}
		else {
			if (isDefined(self.stub.onbeginuse)) {
				self.stub [[self.stub.onbeginuse]] (player);
			}
			result = self maps/mp/zombies/_zm_buildables::buildable_use_hold_think(player);
			team = player.pers["team"];
			if (isDefined(self.stub.onenduse)) {
				self.stub [[self.stub.onenduse]] (team, player, result);
			}
			if (!result) {
				continue;
			}
			if (isDefined(self.stub.onuse)) {
				self.stub [[self.stub.onuse]] (player);
			}
			prompt = player maps/mp/zombies/_zm_buildables::player_build(self.stub.buildablezone);
			player_built = player;
			self.stub.hint_string = prompt;
			self sethintstring(self.stub.hint_string);
		}
	}
	if (isDefined(player_built)) {
	}
	if (self.stub.persistent == 0) {
		self.stub maps/mp/zombies/_zm_buildables::buildablestub_remove();
		thread maps/mp/zombies/_zm_unitrigger::unregister_unitrigger(self.stub);
		return;
	}
	if (self.stub.persistent == 3) {
		maps/mp/zombies/_zm_buildables::stub_unbuild_buildable(self.stub, 1);
		return;
	}
	if (self.stub.persistent == 2) {
		if (isDefined(player_built)) {
			self buildabletrigger_update_prompt(player_built);
		}
		if (!maps/mp/zombies/_zm_weapons::limited_weapon_below_quota(self.stub.weaponname, undefined)) {
			self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
			self sethintstring(self.stub.hint_string);
			return;
		}
		if (isDefined(self.stub.bought) && self.stub.bought) {
			self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
			self sethintstring(self.stub.hint_string);
			return;
		}
		if (isDefined(self.stub.model)) {
			self.stub.model notsolid();
			self.stub.model show();
		}
		while (self.stub.persistent == 2) {
			self waittill("trigger", player);
			if (isDefined(player.screecher_weapon)) {
				continue;
			}
			if (!maps/mp/zombies/_zm_weapons::limited_weapon_below_quota(self.stub.weaponname, undefined)) {
				self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
				self sethintstring(self.stub.hint_string);
				return;
			}
			if (isDefined(self.stub.built) && !self.stub.built) {
				self.stub.hint_string = "";
				self sethintstring(self.stub.hint_string);
				return;
			}
			if (player != self.parent_player) {
				continue;
			}
			if (!is_player_valid(player)) {
				player thread ignore_triggers(0.5);
			}

			if (player.score < self.stub.cost) {
				self play_sound_on_ent("no_purchase");
				continue;
			}

			player maps/mp/zombies/_zm_score::minus_to_player_score(self.stub.cost);
			self play_sound_on_ent("purchase");

			self.stub.bought = 1;
			if (isDefined(self.stub.model)) {
				self.stub.model thread maps/mp/zombies/_zm_buildables::model_fly_away();
			}
			player maps/mp/zombies/_zm_weapons::weapon_give(self.stub.weaponname);
			if (isDefined(level.zombie_include_buildables[self.stub.equipname].onbuyweapon)) {
				self [[level.zombie_include_buildables[self.stub.equipname].onbuyweapon]] (player);
			}
			if (!maps/mp/zombies/_zm_weapons::limited_weapon_below_quota(self.stub.weaponname, undefined)) {
				self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
			}
			else {
				self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
			}
			self sethintstring(self.stub.hint_string);
			player maps/mp/zombies/_zm_buildables::track_buildables_pickedup(self.stub.weaponname);
		}
	}
	else {
		while (!isDefined(player_built) || self buildabletrigger_update_prompt(player_built)) {
			if (isDefined(self.stub.model)) {
				self.stub.model notsolid();
				self.stub.model show();
			}
			while (self.stub.persistent == 1) {
				self waittill("trigger", player);
				if (isDefined(player.screecher_weapon)) {
					continue;
				}
				if (isDefined(self.stub.built) && !self.stub.built) {
					self.stub.hint_string = "";
					self sethintstring(self.stub.hint_string);
					return;
				}
				if (player != self.parent_player) {
					continue;
				}
				if (!is_player_valid(player)) {
					player thread ignore_triggers(0.5);
				}
				if (player has_player_equipment(self.stub.weaponname)) {
					continue;
				}
				if (player.score < self.stub.cost) {
					self play_sound_on_ent("no_purchase");
					continue;
				}
				if (!maps/mp/zombies/_zm_equipment::is_limited_equipment(self.stub.weaponname) || !maps/mp/zombies/_zm_equipment::limited_equipment_in_use(self.stub.weaponname)) {
					player maps/mp/zombies/_zm_score::minus_to_player_score(self.stub.cost);
					self play_sound_on_ent("purchase");

					player maps/mp/zombies/_zm_equipment::equipment_buy(self.stub.weaponname);
					player giveweapon(self.stub.weaponname);
					player setweaponammoclip(self.stub.weaponname, 1);
					if (isDefined(level.zombie_include_buildables[self.stub.equipname].onbuyweapon)) {
						self [[level.zombie_include_buildables[self.stub.equipname].onbuyweapon]] (player);
					}
					if (self.stub.weaponname != "keys_zm") {
						player setactionslot(1, "weapon", self.stub.weaponname);
					}
					if (isDefined(level.zombie_buildables[self.stub.equipname].bought)) {
						self.stub.hint_string = level.zombie_buildables[self.stub.equipname].bought;
					}
					else {
						self.stub.hint_string = "";
					}
					self sethintstring(self.stub.hint_string);
					player maps/mp/zombies/_zm_buildables::track_buildables_pickedup(self.stub.weaponname);
					continue;
				}
				else {
					self.stub.hint_string = "";
					self sethintstring(self.stub.hint_string);
				}
			}
		}
	}
}

buildabletrigger_update_prompt(player) {
	can_use = 0;
	if (isDefined(level.buildablepools)) {
		can_use = self.stub pooledbuildablestub_update_prompt(player, self);
	}
	else {
		can_use = self.stub buildablestub_update_prompt(player, self);
	}

	self sethintstring(self.stub.hint_string);
	if (isDefined(self.stub.cursor_hint)) {
		if (self.stub.cursor_hint == "HINT_WEAPON" && isDefined(self.stub.cursor_hint_weapon)) {
			self setcursorhint(self.stub.cursor_hint, self.stub.cursor_hint_weapon);
		}
		else {
			self setcursorhint(self.stub.cursor_hint);
		}
	}
	return can_use;
}

buildablestub_update_prompt(player, trigger) {
	if (!self maps/mp/zombies/_zm_buildables::anystub_update_prompt(player)) {
		return 0;
	}

	if (isDefined(self.buildablestub_reject_func)) {
		rval = self [[self.buildablestub_reject_func]] (player);
		if (rval) {
			return 0;
		}
	}

	if (isDefined(self.custom_buildablestub_update_prompt) && !(self [[self.custom_buildablestub_update_prompt]] (player))) {
		return 0;
	}

	self.cursor_hint = "HINT_NOICON";
	self.cursor_hint_weapon = undefined;
	if (isDefined(self.built) && !self.built) {
		slot = self.buildablestruct.buildable_slot;
		piece = self.buildablezone.pieces[0];
		player maps/mp/zombies/_zm_buildables::player_set_buildable_piece(piece, slot);

		if (!isDefined(player maps/mp/zombies/_zm_buildables::player_get_buildable_piece(slot))) {
			if (isDefined(level.zombie_buildables[self.equipname].hint_more)) {
				self.hint_string = level.zombie_buildables[self.equipname].hint_more;
			}
			else {
				self.hint_string = &"ZOMBIE_BUILD_PIECE_MORE";
			}
			return 0;
		}
		else {
			if (!self.buildablezone maps/mp/zombies/_zm_buildables::buildable_has_piece(player maps/mp/zombies/_zm_buildables::player_get_buildable_piece(slot))) {
				if (isDefined(level.zombie_buildables[self.equipname].hint_wrong)) {
					self.hint_string = level.zombie_buildables[self.equipname].hint_wrong;
				}
				else {
					self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";
				}
				return 0;
			}
			else {
				if (isDefined(level.zombie_buildables[self.equipname].hint)) {
					self.hint_string = level.zombie_buildables[self.equipname].hint;
				}
				else {
					self.hint_string = "Missing buildable hint";
				}
			}
		}
	}
	else {
		if (self.persistent == 1) {
			if (maps/mp/zombies/_zm_equipment::is_limited_equipment(self.weaponname) && maps/mp/zombies/_zm_equipment::limited_equipment_in_use(self.weaponname)) {
				self.hint_string = &"ZOMBIE_BUILD_PIECE_ONLY_ONE";
				return 0;
			}

			if (player has_player_equipment(self.weaponname)) {
				self.hint_string = &"ZOMBIE_BUILD_PIECE_HAVE_ONE";
				return 0;
			}

			self.hint_string = self.trigger_hintstring;
		}
		else if (self.persistent == 2) {
			if (!maps/mp/zombies/_zm_weapons::limited_weapon_below_quota(self.weaponname, undefined)) {
				self.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
				return 0;
			}
			else {
				if (isDefined(self.bought) && self.bought) {
					self.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
					return 0;
				}
			}
			self.hint_string = self.trigger_hintstring;
		}
		else {
			self.hint_string = "";
			return 0;
		}
	}
	return 1;
}

pooledbuildablestub_update_prompt(player, trigger) {
	if (!self maps/mp/zombies/_zm_buildables::anystub_update_prompt(player)) {
		return 0;
	}

	if (isDefined(self.custom_buildablestub_update_prompt) && !(self [[self.custom_buildablestub_update_prompt]] (player))) {
		return 0;
	}

	self.cursor_hint = "HINT_NOICON";
	self.cursor_hint_weapon = undefined;
	if (isDefined(self.built) && !self.built) {
		trigger thread buildablestub_build_succeed();

		if (level.buildables_available.size > 1) {
			self thread choose_open_buildable(player);
		}

		slot = self.buildablestruct.buildable_slot;

		if (self.buildables_available_index >= level.buildables_available.size) {
			self.buildables_available_index = 0;
		}

		foreach(stub in level.buildable_stubs) {
			if (stub.buildablezone.buildable_name == level.buildables_available[self.buildables_available_index]) {
				piece = stub.buildablezone.pieces[0];
				break;
			}
		}

		player maps/mp/zombies/_zm_buildables::player_set_buildable_piece(piece, slot);

		piece = player maps/mp/zombies/_zm_buildables::player_get_buildable_piece(slot);

		if (!isDefined(piece)) {
			if (isDefined(level.zombie_buildables[self.equipname].hint_more)) {
				self.hint_string = level.zombie_buildables[self.equipname].hint_more;
			}
			else {
				self.hint_string = &"ZOMBIE_BUILD_PIECE_MORE";
			}

			if (isDefined(level.custom_buildable_need_part_vo)) {
				player thread [[level.custom_buildable_need_part_vo]] ();
			}
			return 0;
		}
		else {
			if (isDefined(self.bound_to_buildable) && !self.bound_to_buildable.buildablezone maps/mp/zombies/_zm_buildables::buildable_has_piece(piece)) {
				if (isDefined(level.zombie_buildables[self.bound_to_buildable.equipname].hint_wrong)) {
					self.hint_string = level.zombie_buildables[self.bound_to_buildable.equipname].hint_wrong;
				}
				else {
					self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";
				}

				if (isDefined(level.custom_buildable_wrong_part_vo)) {
					player thread [[level.custom_buildable_wrong_part_vo]] ();
				}
				return 0;
			}
			else {
				if (!isDefined(self.bound_to_buildable) && !self.buildable_pool pooledbuildable_has_piece(piece)) {
					if (isDefined(level.zombie_buildables[self.equipname].hint_wrong)) {
						self.hint_string = level.zombie_buildables[self.equipname].hint_wrong;
					}
					else {
						self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";
					}
					return 0;
				}
				else {
					if (isDefined(self.bound_to_buildable)) {
						if (isDefined(level.zombie_buildables[piece.buildablename].hint)) {
							self.hint_string = level.zombie_buildables[piece.buildablename].hint;
						}
						else {
							self.hint_string = "Missing buildable hint";
						}
					}

					if (isDefined(level.zombie_buildables[piece.buildablename].hint)) {
						self.hint_string = level.zombie_buildables[piece.buildablename].hint;
					}
					else {
						self.hint_string = "Missing buildable hint";
					}
				}
			}
		}
	}
	else {
		return trigger [[self.original_prompt_and_visibility_func]] (player);
	}
	return 1;
}

pooledbuildable_has_piece(piece) {
	return isDefined(self pooledbuildable_stub_for_piece(piece));
}

pooledbuildable_stub_for_piece(piece) {
	foreach(stub in self.stubs) {
		if (!isDefined(stub.bound_to_buildable)) {
			if (stub.buildablezone maps/mp/zombies/_zm_buildables::buildable_has_piece(piece)) {
				return stub;
			}
		}
	}

	return undefined;
}

choose_open_buildable(player) {
	self endon("kill_choose_open_buildable");

	n_playernum = player getentitynumber();
	b_got_input = 1;
	hinttexthudelem = newclienthudelem(player);
	hinttexthudelem.alignx = "center";
	hinttexthudelem.aligny = "middle";
	hinttexthudelem.horzalign = "center";
	hinttexthudelem.vertalign = "bottom";
	hinttexthudelem.y = -100;
	hinttexthudelem.foreground = 1;
	hinttexthudelem.font = "default";
	hinttexthudelem.fontscale = 1;
	hinttexthudelem.alpha = 1;
	hinttexthudelem.color = (1, 1, 1);
	hinttexthudelem settext("Press [{+actionslot 1}] or [{+actionslot 2}] to change item");

	if (!isDefined(self.buildables_available_index)) {
		self.buildables_available_index = 0;
	}

	while (isDefined(self.playertrigger[n_playernum]) && !self.built) {
		if (!player isTouching(self.playertrigger[n_playernum])) {
			hinttexthudelem.alpha = 0;
			wait 0.05;
			continue;
		}

		hinttexthudelem.alpha = 1;

		if (player actionslotonebuttonpressed()) {
			self.buildables_available_index++;
			b_got_input = 1;
		}
		else {
			if (player actionslottwobuttonpressed()) {
				self.buildables_available_index--;

				b_got_input = 1;
			}
		}

		if (self.buildables_available_index >= level.buildables_available.size) {
			self.buildables_available_index = 0;
		}
		else {
			if (self.buildables_available_index < 0) {
				self.buildables_available_index = level.buildables_available.size - 1;
			}
		}

		if (b_got_input) {
			piece = undefined;
			foreach(stub in level.buildable_stubs) {
				if (stub.buildablezone.buildable_name == level.buildables_available[self.buildables_available_index]) {
					piece = stub.buildablezone.pieces[0];
					break;
				}
			}
			slot = self.buildablestruct.buildable_slot;
			player maps/mp/zombies/_zm_buildables::player_set_buildable_piece(piece, slot);

			self.equipname = level.buildables_available[self.buildables_available_index];
			self.hint_string = level.zombie_buildables[self.equipname].hint;
			self.playertrigger[n_playernum] sethintstring(self.hint_string);
			b_got_input = 0;
		}

		if (player is_player_looking_at(self.playertrigger[n_playernum].origin, 0.76)) {
			hinttexthudelem.alpha = 1;
		}
		else {
			hinttexthudelem.alpha = 0;
		}

		wait 0.05;
	}

	hinttexthudelem destroy();
}

buildablestub_build_succeed() {
	self notify("buildablestub_build_succeed");
	self endon("buildablestub_build_succeed");

	self waittill("build_succeed");

	self.stub maps/mp/zombies/_zm_buildables::buildablestub_remove();
	arrayremovevalue(level.buildables_available, self.stub.buildablezone.buildable_name);
	if (level.buildables_available.size == 0) {
		foreach(stub in level.buildable_stubs) {
			switch (stub.equipname) {
			case "turbine":
			case "subwoofer_zm":
			case "springpad_zm":
			case "headchopper_zm":
				maps/mp/zombies/_zm_unitrigger::unregister_unitrigger(stub);
				break;
			}
		}
	}
}

// adds updated hintstring and functionality
updatebuildables() {
	foreach(stub in level._unitriggers.trigger_stubs) {
		if (IsDefined(stub.equipname)) {
			displayname = stub get_equipment_display_name();
			stub.cost = 1000;
			stub.trigger_hintstring = "Hold ^3[{+activate}]^7 for " + displayname + " [Cost: " + stub.cost + "]";
			stub.trigger_func = ::buildable_place_think;
		}
	}
}

removebuildable(buildable, after_built) {
	if (!isDefined(after_built)) {
		after_built = 0;
	}

	if (after_built) {
		foreach(stub in level._unitriggers.trigger_stubs) {
			if (IsDefined(stub.equipname) && stub.equipname == buildable) {
				stub.model hide();
				maps/mp/zombies/_zm_unitrigger::unregister_unitrigger(stub);
				return;
			}
		}
	}
	else {
		foreach(stub in level.buildable_stubs) {
			if (!isDefined(buildable) || stub.equipname == buildable) {
				if (isDefined(buildable) || stub.persistent != 3) {
					stub maps/mp/zombies/_zm_buildables::buildablestub_remove();
					foreach(piece in stub.buildablezone.pieces) {
						piece maps/mp/zombies/_zm_buildables::piece_unspawn();
					}
					maps/mp/zombies/_zm_unitrigger::unregister_unitrigger(stub);
					return;
				}
			}
		}
	}
}

buildable_piece_remove_on_last_stand() {
	self endon("disconnect");

	self thread buildable_get_last_piece();

	while (1) {
		self waittill("entering_last_stand");

		if (isDefined(self.last_piece)) {
			self.last_piece maps/mp/zombies/_zm_buildables::piece_unspawn();
		}
	}
}

buildable_get_last_piece() {
	self endon("disconnect");

	while (1) {
		if (!self maps/mp/zombies/_zm_laststand::player_is_in_laststand()) {
			self.last_piece = maps/mp/zombies/_zm_buildables::player_get_buildable_piece(0);
		}

		wait 0.05;
	}
}






