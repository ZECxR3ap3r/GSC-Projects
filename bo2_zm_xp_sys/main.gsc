#include codescripts\struct;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\gametypes_zm\_hud_util;

// XP System by ZECxR3ap3r & John Kramer

init() {
	precacheshader("zombies_rank_1");
	precacheshader("zombies_rank_2");
	precacheshader("zombies_rank_3");
	precacheshader("zombies_rank_3_ded");
	precacheshader("zombies_rank_4");
	precacheshader("zombies_rank_4_ded");
	precacheshader("zombies_rank_5");
	precacheshader("zombies_rank_5_ded");
	
	level.new_players = 0;
	
	level thread track_points_spent();
	level thread on_connect();

	print("^5XP System^7 By ^5ZECxR3ap3r^7 & ^5John Kramer");
}

on_connect() {
	while(1) {
		level waittill("connected", player);
		
		player thread on_spawned();
		
		player.realname = player.name;
	}
}

on_spawned() {
	self endon("disconnect");
	
	while(1) {
		self waittill("spawned_player");
		
		if(!isdefined(self.main_initial_spawn)) {
			self.main_initial_spawn = 1;
        	
			self thread handle_player_stats();
			self thread xp_bar_setup();
			
			rank = convert_xp_to_level(self.total_stats["xp"]);
			self setClantag("^1" + rank.current_level);
		}
	}
}

// XP Bar
xp_bar_setup() {
	self endon("disconnect");
	
	x 				= 0;
	y 				= 440;
	base_width 		= 476;
	base_height 	= 4;
	init_width 		= 400;
	
	if(!isdefined(self.xp_bar)) {
		self.xp_bar = newClientHudElem(self);
		self.xp_bar.x = -238 + 1;
		self.xp_bar.y = y;
		self.xp_bar.alignx = "left";
		self.xp_bar.aligny = "bottom";
		self.xp_bar.horzalign = "center";
		self.xp_bar.vertalign = "fullscreen";
		self.xp_bar.color = (1, .25, .25);
		self.xp_bar.alpha = 1;
		self.xp_bar.archived = false;
		self.xp_bar.foreground = true;
		self.xp_bar.sort = 100;
		self.xp_bar.hidewheninmenu = true;
		self.xp_bar.hidewhendead = false;
	}
	
	if(!isdefined(self.xp_bar_frame)) {
		self.xp_bar_frame = newClientHudElem(self);
		self.xp_bar_frame.x = -238;
		self.xp_bar_frame.y = y + 1;
		self.xp_bar_frame.alignx = "left";
		self.xp_bar_frame.aligny = "bottom";
		self.xp_bar_frame.horzalign = "center";
		self.xp_bar_frame.vertalign = "fullscreen";
		self.xp_bar_frame.alpha = 1;
		self.xp_bar_frame.sort = 0;
		self.xp_bar_frame.archived = false;
		self.xp_bar_frame.foreground = true;
		self.xp_bar_frame.hidewheninmenu = true;
		self.xp_bar_frame.hidewhendead = false;
		self.xp_bar_frame setshader("black", base_width + 2, base_height + 2);
	}

	if(!isdefined(self.next_level)) {
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
	}

	if(!isdefined(self.next_rank)) {
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
	}

	if(!isdefined(self.xp_left)) {
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
		self.xp_left.label = &"XP Left: ^1 ";
	}

	if(!isdefined(self.current_level)) {
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
	}

	if(!isdefined(self.current_rank)) {
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
		self.current_rank setShader("zombies_rank_1", 20, 20);
	}

	if(!isdefined(self.xp_earned)) {
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
		self.xp_earned.label = &"XP Earned: ^1 ";
	}
	
	while(1) {
		rank = 				convert_xp_to_level(self.total_stats["xp"]);
		xp_earned_value = 	int(self.total_stats["xp"] - rank.last_xp);
		xp_needed_value = 	int(rank.next_xp  - rank.last_xp);
		earned_width = 		int(base_width * (xp_earned_value / xp_needed_value));
		
		self.current_level 	setvalue(rank.current_level);
		self.xp_earned 		setvalue(xp_earned_value);
		self.xp_left 		setvalue(int(rank.next_xp - self.total_stats["xp"]));
		self.xp_bar 		setshader("progress_bar_fill", earned_width, base_height + 1);
		self.next_level 	setvalue(rank.next_level);

		wait .2;
	}
}

track_points_spent() {
	level endon("end_game");
	
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

handle_player_stats() {
	self endon("disconnect");

	file_path = getDvar("fs_homepath") + "/xp_system";
	players_dir = file_path + "/players/";

	if(!directoryexists(file_path))
		createdirectory(file_path);

	if(!directoryexists(players_dir))
		createdirectory(players_dir);

	int_total 		= [];
	
	int_columns 	= strTok("kills,headshots,melee_kills,grenade_kills,hits,downs,revives,magicbox_uses,pap_uses,powerup_uses,rounds_played,time_played,perk_uses,score_earned,score_spent,xp", ",");

	self.session_stats = [];

	foreach(s_column in int_columns)
		self.session_stats[s_column] = 0;

	self.session_stats["uid"] 				= self getGUID();
	self.session_stats["username"] 			= self.realname;
	self.session_stats["round_joined"] 		= level.round_number;
	self.session_stats["highest_round"] 	= (isDefined(level.round_number)) ? level.round_number : 0;
	self.session_stats["time_joined"] 		= GetUTC();

	player_file = players_dir + self getGUID() + ".csv";
	player_csv_data = readFile(player_file);

	if (!isDefined(player_csv_data) || player_csv_data == "") {
		level.new_players++;
		self.total_stats = [];

		foreach(t_column in int_columns)
			self.total_stats[t_column] = 0;

		self.total_stats["uid"] 			= self getGUID();
		self.total_stats["username"] 		= self.realname;
		self.total_stats["time_joined"] 	= GetUTC();
		self.total_stats["sessions"] 		= 0;
		self.total_stats["highest_round"] 	= 0;
	}
	else {
		self.total_stats = csv_decode(player_csv_data)[0];
		
		foreach(i_column in int_columns) {
			if(!isdefined(self.total_stats[i_column]))
				self.total_stats[i_column] = 0;
		}
	}
	
	self.total_stats["sessions"] = int(self.total_stats["sessions"]) + 1;
	self.total_stats["highest_round"] = int(self.total_stats["highest_round"]);
	
	foreach(i_column in int_columns)
		int_total[i_column] = int(self.total_stats[i_column]);

	int_xp = false;

	while (1) {
		// Update session stats
		self.session_stats["kills"] 			= self.pers["kills"];
		self.session_stats["headshots"]			= self.pers["headshots"];
		self.session_stats["melee_kills"] 		= self.pers["melee_kills"];
		self.session_stats["grenade_kills"] 	= self.pers["grenade_kills"];
		self.session_stats["hits"] 				= self.pers["hits"];
		self.session_stats["downs"] 			= self.pers["downs"];
		self.session_stats["revives"] 			= self.pers["revives"];
		self.session_stats["magicbox_uses"] 	= self.pers["use_magicbox"];
		self.session_stats["pap_uses"] 			= self.pers["use_pap"];
		self.session_stats["powerup_uses"] 		= self.pers["drops"];
		self.session_stats["rounds_played"] 	= level.round_number - self.session_stats["round_joined"];
		self.session_stats["time_played"] 		= self.pers["time_played_total"];
		self.session_stats["perk_uses"] 		= self.pers["perks_drank"];
		self.session_stats["score_earned"] 		= self.score_total;
		self.session_stats["score_spent"] 		= self.score_spent;

		if (level.round_number > self.session_stats["highest_round"])
			self.session_stats["highest_round"] 	= level.round_number;

		if ((self.session_stats["round_joined"] == 1) && level.round_number > self.total_stats["highest_round"])
			self.total_stats["highest_round"] 		= level.round_number;
		
		if((self.session_stats["round_joined"] == 1) && level.round_number > self.total_stats[level.current_map]) {
			self.total_stats[level.current_map] 	= int(level.round_number);
			int_total[level.current_map] 			= int(level.round_number);
		}

		foreach(p_column in int_columns) {
			if(isdefined(self.session_stats[p_column]))
				self.total_stats[p_column] = int_total[p_column] + self.session_stats[p_column];
			else
				self.total_stats[p_column] = int_total[p_column];
		}

		if (!int_xp) self thread handle_player_xp();
			int_xp = true;

		player_data = csv_encode(self.total_stats);

		writeFile(player_file, player_data);

		wait 3;
	}
}

handle_player_xp() {
	self endon("disconnect");

	self thread reward_xp_on("kill");
	self thread reward_xp_on("player_revived");
	self thread reward_xp_on("round_survived"); 
	
	while (1) {
		rank = convert_xp_to_level(self.total_stats["xp"]);

		if (!isDefined(trigger_level)) trigger_level = rank.next_level;
		if (trigger_level < 1) break;

		if (rank.current_level >= trigger_level) {
			trigger_level = rank["next_level"];

			if (rank.current_level < 100) rank_icon = "zombies_rank_1";
			else if (rank.current_level < 200) rank_icon = "zombies_rank_2";
			else if (rank.current_level < 300) rank_icon = "zombies_rank_3";
			else if (rank.current_level < 400) rank_icon = "zombies_rank_3_ded";
			else if (rank.current_level < 500) rank_icon = "zombies_rank_4";
			else if (rank.current_level < 600) rank_icon = "zombies_rank_4_ded";
			else if (rank.current_level < 700) rank_icon = "zombies_rank_5";
			else if (rank.current_level < 800) rank_icon = "zombies_rank_5_ded";

			self draw_rank_popup(rank.current_level, rank_icon);
			self.total_stats["pap_uses"] = 0;
		}
		
		wait 5;
	}
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
	level_hint.label = &"LEVEL ^1&&1";
	level_hint setvalue(new_level);

	rank_icon fadeovertime(.25);
	rank_icon scaleovertime(.25, 46, 46);
	rank_icon.alpha = 1;

	wait .25;
	level_hint fadeovertime(.25);
	level_hint.alpha = 1;

	wait 3;
	rank_icon fadeovertime(.25);
	level_hint fadeovertime(.25);
	rank_icon.alpha = 0;
	level_hint.alpha = 0;

	wait .25;
	rank_icon destroy();
	level_hint destroy();
	
	rank = convert_xp_to_level(self.total_stats["xp"]);
	self setClantag("^1" + rank.current_level);
	
	iprintln("^1" + self.realname + " ^7Was Promoted to Level ^1" + new_level);
}

convert_xp_to_level(xp_value) {
	xp_value 			= int(xp_value);
	max_level 			= 1000;
    max_xp_level 		= 100;
    base_level_xp 		= 543;
    last_level_xp 		= 0;
    
	rank = spawnstruct();

    for (i = 1; i <= max_level; i++) {
        multiplier 				= (i > max_xp_level) ? max_xp_level : i;
        xp_increase 			= base_level_xp * multiplier;
        next_level_xp 			= last_level_xp + xp_increase;

        // Level 1000 cap
        if (i == max_level) {
            rank.current_level 	= i;
            rank.next_level 	= -1;
            rank.level_xp 		= 0;
            rank.last_xp 		= last_level_xp;
            rank.next_xp 		= -1;

            break;
        }

        // Current level range
        if (xp_value < next_level_xp) {
            rank.current_level 	= i;
            rank.next_level 	= i + 1;
            rank.level_xp 		= xp_increase;
            rank.last_xp 		= last_level_xp;
            rank.next_xp 		= next_level_xp;

            break;
        }

        last_level_xp 			= next_level_xp;
    }

    return rank;
}

reward_xp_on(type) {
	self endon("disconnect");

	base_xp = [];			// XP Values
	base_xp["kill"] 		= 50; 
	base_xp["revive"] 		= 100;
	base_xp["round"] 		= 50;

	while (1) {
		self waittill("zom_kill", zombie);
		
		switch (type) {
			case "kill":
				if (zombie.damagemod == "MOD_MELEE") {
					if(isdefined(self.doublexprunning))
						add_kill_xp = int(base_xp["kill"] * 6);
					else
						add_kill_xp = int(base_xp["kill"] * 3);  // Melee kill: +200% multiplier
				}
				else if (zombie.damagelocation == "head" || zombie.damagelocation == "helmet" || zombie.damagelocation == "neck") {
					if(isdefined(self.doublexprunning))
						add_kill_xp = int(base_xp["kill"] * 4);
					else
						add_kill_xp = int(base_xp["kill"] * 2);  // Headshot kill: +100% multiplier
				}
				else if (zombie.damagemod == "MOD_GRENADE" || zombie.damagemod == "MOD_GRENADE_SPLASH" || zombie.damagemod == "MOD_EXPLOSIVE") {
					if(isdefined(self.doublexprunning))
						add_kill_xp = int(base_xp["kill"] * 3);
					else
						add_kill_xp = int(base_xp["kill"] * 1.5);  // Explosive kill: +50% multiplier
				}
				else
					add_kill_xp = int(base_xp["kill"]);

				self.session_stats["xp"] += add_kill_xp;
				//self thread draw_xp(add_kill_xp, kill_type_hint);
				break;

			case "round_survived":
				level waittill("end_of_round");

				round_multiplier = (level.round_number > 20) ? 20 : level.round_number;  // Max round multiplier: 20
				add_round_xp = int(base_xp["round"] * round_multiplier);
				self.session_stats["xp"] += add_round_xp;
				//self thread draw_xp(add_round_xp, "Round Survived", 6);
				break;
		}
	}
}