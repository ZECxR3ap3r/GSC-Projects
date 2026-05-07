#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

main() {
	replacefunc(maps\mp\gametypes\_gamelogic::startgame, ::startGame_New);
	replacefunc(maps\mp\gametypes\_menus::beginClassChoice, ::beginClassChoice_edit);
}

beginClassChoice_edit( forceNewChoice ) {
	team = self.pers["team"];
	
	self thread maps\mp\gametypes\_menus::bypassClassChoice();
	
	if (!isAlive(self))
		self thread maps\mp\gametypes\_playerlogic::predictAboutToSpawnPlayerOverTime( 0.1 );
}

init() {
	precacheshader("iw5_cardtitle_specialty_veteran");
	precacheshader("hud_javelin_lock_box");
	
    level thread on_connect();
    
    setdvar("g_hardcore", 1);
    
    makeDvarServerInfo("ui_allow_teamchange", 0);
	makeDvarServerInfo("ui_allow_classchange", 0);
	
	level.teamchange_keepbalanced = false;
    level.game_time = 240;
    level.concussionfx = loadfx("explosions/concussion_grenade");
    
    setdynamicdvar("scr_war_roundlimit", 3);
    setdynamicdvar("scr_war_winlimit", 3);
    setdynamicdvar("scr_war_numlives", 10);
    
    create_models_array();
    
    level thread pregame();
    
    level thread local_huds_handler();
}

on_connect() {
	while(1) {
		level waittill("connected", player);
		
		player thread on_spawned();
	}
}

on_spawned() {
	self endon("disconnect");
	
	self notify("menuresponse", undefined, "back");
	self maps\mp\gametypes\_menus::addtoteam("allies", 1);
	
	while(1) {
		self waittill("spawned_player");
		
		if(!isdefined(self.initial_spawn)) {
			self.initial_spawn = 1;
			
			self setclientdvar("g_compassShowEnemies", 1);
			
			if(!isdefined(level.jointospectate))
				self thread prop_setup_main();
			else {
				self.sessionstate = "spectator";
				self.sessionteam = "spectator";
				
				self allowspectateteam("allies", 1);
    			self allowspectateteam("axis", 1);
    			self allowspectateteam("freelook", 0);
    			self allowspectateteam("none", 1);
			}
		}
	}
}

local_huds_handler() {
	if(!isdefined(level.info_ui_elements))
		level.info_ui_elements = [];
		
	if(!isdefined(level.info_ui_elements["background"])) {
		level.info_ui_elements["background"] = newhudelem();
		level.info_ui_elements["background"].horzalign = "fullscreen";
		level.info_ui_elements["background"].vertalign = "fullscreen";
		level.info_ui_elements["background"].alignx = "center";
		level.info_ui_elements["background"].aligny = "top";
		level.info_ui_elements["background"].x = 320;
		level.info_ui_elements["background"].y = -15;
		level.info_ui_elements["background"].color = (.2, .2, .2);
		level.info_ui_elements["background"].sort = -1;
		level.info_ui_elements["background"] setshader("iw5_cardtitle_specialty_veteran", 200, 40);
	}
	
	if(!isdefined(level.info_ui_elements["host"])) {
		level.info_ui_elements["host"] = newhudelem();
		level.info_ui_elements["host"].horzalign = "fullscreen";
		level.info_ui_elements["host"].vertalign = "fullscreen";
		level.info_ui_elements["host"].alignx = "center";
		level.info_ui_elements["host"].aligny = "top";
		level.info_ui_elements["host"].x = 320;
		level.info_ui_elements["host"].y = 1;
		level.info_ui_elements["host"].font = "bigfixed";
		level.info_ui_elements["host"].fontscale = .5;
		level.info_ui_elements["host"] settext("www.^1Gillette^7clan.com");
	}
	
	level waittill("begin_prophunt");
	
	level thread whistle_handler_local();
	
	seekers = int(level.players.size / 4);
	for(i = seekers;i > 0;i = seekers) {
		num = randomintrange(0, level.players.size);
		
		if(isdefined(level.players[num]) && level.players[num].team == "allies") {
			level.players[num] maps\mp\gametypes\_menus::addtoteam("axis", 1);
			iprintln("^1" + level.players[num].name + " ^7Got Picked as Seeker!");
			
			if(isdefined(level.players[num].prop.model)) {
				level.players[num].prop.model delete();
				level.players[num].prop.linker delete();
			}
			
			level.players[num].seeker = 1;
			level.players[num] suicide();
			level.players[num] thread seeker_setup();
			
			seekers--;
		}
	}
	
	wait .5;
	
	setdynamicdvar("scr_war_numlives", 1);
	
	level.info_ui_elements["host"] destroy();
		
	if(!isdefined(level.info_ui_elements["timer"])) {
		level.info_ui_elements["timer"] = newhudelem();
		level.info_ui_elements["timer"].horzalign = "fullscreen";
		level.info_ui_elements["timer"].vertalign = "fullscreen";
		level.info_ui_elements["timer"].alignx = "center";
		level.info_ui_elements["timer"].aligny = "top";
		level.info_ui_elements["timer"].x = 320;
		level.info_ui_elements["timer"].y = 1;
		level.info_ui_elements["timer"].font = "bigfixed";
		level.info_ui_elements["timer"].fontscale = .45;
		level.info_ui_elements["timer"].label = &"Time: ^1";
	}
	
	if(!isdefined(level.info_ui_elements["props_left"])) {
		level.info_ui_elements["props_left"] = newhudelem();
		level.info_ui_elements["props_left"].horzalign = "fullscreen";
		level.info_ui_elements["props_left"].vertalign = "fullscreen";
		level.info_ui_elements["props_left"].alignx = "right";
		level.info_ui_elements["props_left"].aligny = "top";
		level.info_ui_elements["props_left"].x = 295;
		level.info_ui_elements["props_left"].y = 4;
		level.info_ui_elements["props_left"].font = "bigfixed";
		level.info_ui_elements["props_left"].fontscale = .35;
		level.info_ui_elements["props_left"].label = &"Props Left: ^1";
	}
	
	level.info_ui_elements["timer"] settimer(level.game_time);
	
	level.props_left = 0;
	
	while(1) {
		level.props_left = 0;
		
		foreach(player in level.players) {
			if(player.sessionteam == "allies" && isdefined(player.prop))
				level.props_left++;
		}
		
		level.info_ui_elements["props_left"] setvalue(level.props_left);
		
		wait .05;
	}
}

seeker_setup() {
	self waittill("spawned_player");
	
	self iprintlnbold("You are a ^1Seeker!");
	self takeallweapons();
	
	self.smokes_left = 1;
	self giveweapon("iw5_mp7_mp");
	self switchtoweapon("iw5_mp7_mp");
	self giveweapon("iw5_deserteagle_mp");
	self giveweapon("concussion_grenade_mp");
	self setoffhandsecondaryclass("smoke");
	self setweaponammoclip("concussion_grenade_mp", 1);
	self unlink();
	self show();
	self notify("picked_seeker");
	self giveperk("_specialty_blastshield_ks", 1);
	self giveperk("_specialty_blastshield_ks_pro", 1);
	
	self thread smoke_handler();
	self thread ammo_handler();
}

whistle_handler_local() {
	whistletime = 30;
	
	while(1) {
		foreach(player in level.players) {
			if(isdefined(player.prop) && player.sessionteam == "allies") {
				if(isdefined(player.ui_elements["whistle_time"])) {
					player.ui_elements["whistle_time"] settimer(whistletime);
					
					player playsound("scrambler_beep");
					player playsound("scrambler_beep");
					
					wait .3;
				}
			}
		}
		
		wait whistletime;
	}
}

startGame_New() {
	game["strings"]["objective_hint_allies"] = "";
	game["strings"]["objective_hint_axis"  ] = "";
	game["strings"]["axis_name"] = "";	
	game["strings"]["allies_name"] = "";
	
	gameFlagSet("prematch_done");	
	level notify("prematch_over");
	
	thread maps\mp\gametypes\_missions::roundBegin();	
}

pregame() {
	gameflaginit("finders_collected", 0);
	
	time = 30;
	
	gameflagset("finders_collected");
	
	if(!isdefined(level.ui_elements))
		level.ui_elements = [];
	
	if(!isdefined(level.ui_elements["background"])) {
		level.ui_elements["background"] = newhudelem();
		level.ui_elements["background"].horzalign = "fullscreen";
		level.ui_elements["background"].vertalign = "fullscreen";
		level.ui_elements["background"].alignx = "center";
		level.ui_elements["background"].aligny = "middle";
		level.ui_elements["background"].alpha = 1;
		level.ui_elements["background"].x = 320;
		level.ui_elements["background"].y = 40;
		level.ui_elements["background"].sort = 0;
		level.ui_elements["background"].color = (.85, .85, .25);
		level.ui_elements["background"] setshader("white", 90, 12);
	}
	
	if(!isdefined(level.ui_elements["title"])) {
		level.ui_elements["title"] = newhudelem();
		level.ui_elements["title"].horzalign = "fullscreen";
		level.ui_elements["title"].vertalign = "fullscreen";
		level.ui_elements["title"].alignx = "center";
		level.ui_elements["title"].aligny = "middle";
		level.ui_elements["title"].alpha = 1;
		level.ui_elements["title"].x = 320;
		level.ui_elements["title"].y = 40;
		level.ui_elements["title"].sort = 1;
		level.ui_elements["title"].font = "bigfixed";
		level.ui_elements["title"].fontscale = .42;
		level.ui_elements["title"].color = (0, 0, 0);
		level.ui_elements["title"].label = &"Match Starting In: ";
		level.ui_elements["title"] setvalue(time);
	}
	
	if(!isdefined(level.ui_elements["objective"])) {
		level.ui_elements["objective"] = newhudelem();
		level.ui_elements["objective"].horzalign = "fullscreen";
		level.ui_elements["objective"].vertalign = "fullscreen";
		level.ui_elements["objective"].alignx = "center";
		level.ui_elements["objective"].aligny = "middle";
		level.ui_elements["objective"].alpha = 1;
		level.ui_elements["objective"].x = 320;
		level.ui_elements["objective"].y = 55;
		level.ui_elements["objective"].sort = 1;
		level.ui_elements["objective"].font = "small";
		level.ui_elements["objective"].fontscale = 1;
		level.ui_elements["objective"] settext("Find a hiding Spot!");
	}
	
	for(i = 0;i < 30;i++) {
		wait 1;
		
		time -= 1;
		level.ui_elements["title"] setvalue(time);
	}
	
	foreach(hud in level.ui_elements)
		hud destroy();
		
	level notify("begin_prophunt");
	gameflagclear("finders_collected");
	
	level.jointospectate = true;
}

prop_setup_main() {
	self endon("disconnect");
	
	gameflagwait("finders_collected");
	
	self notifyonplayercommand("decoy", "+smoke");
	
	if(!isdefined(self.seeker)) {
		self.prop_changes = 500;
		self.concuss_left = 1;
		self.decoys_left = 3;
			
		self notifyonplayercommand("lock", "+attack");
		self notifyonplayercommand("rotate", "+toggleads_throw");
		self notifyonplayercommand("concuss", "+frag");
		self notifyonplayercommand("change", "weapnext");
			
		self thread setup_prop();
		self thread setup_hud_handler();
		self thread stance_setter();
		self thread button_handler();
		self thread on_start_handler();
	}
}

on_start_handler() {
	self endon("disconnect");
	self endon("picked_seeker");
	
	level waittill("begin_prophunt");
	
	if(!isdefined(self.ui_elements["whistle_time"])) {
		self.ui_elements["whistle_time"] = newclienthudelem(self);
		self.ui_elements["whistle_time"].horzalign = "fullscreen";
		self.ui_elements["whistle_time"].vertalign = "fullscreen";
		self.ui_elements["whistle_time"].alignx = "left";
		self.ui_elements["whistle_time"].aligny = "top";
		self.ui_elements["whistle_time"].x = 345;
		self.ui_elements["whistle_time"].y = 4;
		self.ui_elements["whistle_time"].font = "bigfixed";
		self.ui_elements["whistle_time"].fontscale = .35;
		self.ui_elements["whistle_time"].label = &"Whistle: ^1";
	}
	
	wait 1;
	
	if(isdefined(self.prop.model))
		self.prop.model show();
}

ammo_handler() {
	self endon("disconnect");
	
	while(1) {
		self waittill("reloading");
		
		self givemaxammo(self getcurrentweapon());
	}
}

smoke_handler() {
	self endon("disconnect");
	
	foreach(hud in self.ui_elements)
		hud destroy();
	
	if(!isdefined(self.ui_elements))
		self.ui_elements = [];
	
	if(!isdefined(self.ui_elements["smokes_left"])) {
		self.ui_elements["smokes_left"] = newclienthudelem(self);
		self.ui_elements["smokes_left"].horzalign = "fullscreen";
		self.ui_elements["smokes_left"].vertalign = "fullscreen";
		self.ui_elements["smokes_left"].alignx = "left";
		self.ui_elements["smokes_left"].aligny = "top";
		self.ui_elements["smokes_left"].x = 345;
		self.ui_elements["smokes_left"].y = 4;
		self.ui_elements["smokes_left"].font = "bigfixed";
		self.ui_elements["smokes_left"].fontscale = .35;
		self.ui_elements["smokes_left"].label = &"Concuss: ^1";
		self.ui_elements["smokes_left"] setvalue(self.smokes_left);
	}
	
	while(1) {
		self waittill("grenade_fire", grenade, weapname);
		
		if(weapname == "concussion_grenade_mp")
			self.smokes_left -= 1;
			
		self.ui_elements["smokes_left"] setvalue(self.smokes_left);
	}
}

button_handler() {
	self endon("disconnect");
	self endon("picked_seeker");
	
	while(1) {
		ntf = self waittill_any_return("lock", "rotate", "change", "concuss", "decoy");
		
		if(isdefined(self.prop)) {
			if(isalive(self)) {
				if(ntf == "rotate") {
					if(!isdefined(self.locked_pos)) {
						self.prop.model unlink();
						self.prop.model.angles = (self.prop.model.angles[0], int(self.prop.model.angles[1] + 10), self.prop.model.angles[2]);
						self.prop.model linkto(self.prop.linker);
					}
				}
				else if(ntf == "change") {
					if(self.prop_changes > 0) {
						model = self.prop.model.model;
						while(model == self.prop.model.model) {
							model = level.modelsarray[randomintrange(0, level.modelsarray.size - 1)];
							if(model != self.prop.model.model) {
								self.prop.model setmodel(model);
								break;
							}
							
							wait .05;
						}
						self.prop_changes -= 1;
						self.prop.model unlink();
						
						self.prop.model.origin = self.origin + (0, 0, 5000);
						self iprintln("Health ^5" + get_model_size(self.prop.model));
						self.prop.model.origin = self.origin;
						
						if(model == "chicken" || model == "chicken_black_white" || model == "chicken_black_white")
							self.prop.model scriptmodelplayanim("chicken_cage_loop_01");
					}
					else
						self iprintlnbold("^1You Cannot change anymore!");
				}
				else if(ntf == "lock") {
					if(!isdefined(self.locked_pos)) {
						self iprintlnbold("Locked!");
						self.prop.model unlink();
						self.prop.model.origin = self.origin;
						self playerlinkto(self.prop.model);
						self PlayerLinkedOffsetEnable();
						self.locked_pos = 1;
					}
					else {
						self iprintlnbold("Unlocked!");
						self unlink();
						self.prop.linker linkto(self);
						self.locked_pos = undefined;
						self.prop.model linkto(self.prop.linker);
					}
				}
				else if(ntf == "decoy") {
					if(isdefined(self.decoys_left) && self.decoys_left > 0) {
						ent = spawn("script_model", self.origin);
						ent setmodel(self.prop.model.model);
						ent.angles = self.prop.model.angles;
						ent setcandamage(1);
						
						self.decoys_left -= 1;
					}
				}
				else if(ntf == "concuss") {
					self thread magicgrenade_2("concussion_grenade_mp", self.origin, self);
					
				}
			}
		}
	}
}

stance_setter() {
	self endon("disconnect");
	self endon("picked_seeker");
	
	while(1) {
		wait .05;
		
		if(isalive(self)) {
			if(self getstance() != "stand")
				self setstance("stand");
		}
	}
}

setup_hud_handler() {
	self endon("disconnect");
	
	x = 610;
	fontscale = .3;
	spacing = 25;
	font = "bigfixed";
	
	if(!isdefined(self.ui_elements))
		self.ui_elements = [];
		
	if(!isdefined(self.ui_elements["background"])) {
		self.ui_elements["background"] = newclienthudelem(self);
		self.ui_elements["background"].horzalign = "fullscreen";
		self.ui_elements["background"].vertalign = "fullscreen";
		self.ui_elements["background"].alignx = "center";
		self.ui_elements["background"].aligny = "top";
		self.ui_elements["background"].alpha = .35;
		self.ui_elements["background"].x = x;
		self.ui_elements["background"].y = 320;
		self.ui_elements["background"].sort = 0;
		self.ui_elements["background"] setshader("black", 34, 140);
	}
	
	if(!isdefined(self.ui_elements["lock_button"])) {
		self.ui_elements["lock_button"] = newclienthudelem(self);
		self.ui_elements["lock_button"].horzalign = "fullscreen";
		self.ui_elements["lock_button"].vertalign = "fullscreen";
		self.ui_elements["lock_button"].alignx = "center";
		self.ui_elements["lock_button"].aligny = "top";
		self.ui_elements["lock_button"].alpha = 1;
		self.ui_elements["lock_button"].x = x;
		self.ui_elements["lock_button"].y = self.ui_elements["background"].y + 5;
		self.ui_elements["lock_button"].sort = 1;
		self.ui_elements["lock_button"].font = "small";
		self.ui_elements["lock_button"].fontscale = fontscale * 2.5;
		self.ui_elements["lock_button"] settext("^1[{+attack}]");
	}
	
	if(!isdefined(self.ui_elements["lock_text"])) {
		self.ui_elements["lock_text"] = newclienthudelem(self);
		self.ui_elements["lock_text"].horzalign = "fullscreen";
		self.ui_elements["lock_text"].vertalign = "fullscreen";
		self.ui_elements["lock_text"].alignx = "center";
		self.ui_elements["lock_text"].aligny = "top";
		self.ui_elements["lock_text"].alpha = 1;
		self.ui_elements["lock_text"].x = x;
		self.ui_elements["lock_text"].y = self.ui_elements["lock_button"].y + 9;
		self.ui_elements["lock_text"].sort = 1;
		self.ui_elements["lock_text"].font = font;
		self.ui_elements["lock_text"].fontscale = fontscale;
		self.ui_elements["lock_text"] settext("Lock");
	}
	
	if(!isdefined(self.ui_elements["rotate_button"])) {
		self.ui_elements["rotate_button"] = newclienthudelem(self);
		self.ui_elements["rotate_button"].horzalign = "fullscreen";
		self.ui_elements["rotate_button"].vertalign = "fullscreen";
		self.ui_elements["rotate_button"].alignx = "center";
		self.ui_elements["rotate_button"].aligny = "top";
		self.ui_elements["rotate_button"].alpha = 1;
		self.ui_elements["rotate_button"].x = x;
		self.ui_elements["rotate_button"].y = self.ui_elements["lock_button"].y + spacing;
		self.ui_elements["rotate_button"].sort = 1;
		self.ui_elements["rotate_button"].font = "small";
		self.ui_elements["rotate_button"].fontscale = fontscale * 2.5;
		self.ui_elements["rotate_button"] settext("^1[{+toggleads_throw}]");
	}
	
	if(!isdefined(self.ui_elements["rotate_text"])) {
		self.ui_elements["rotate_text"] = newclienthudelem(self);
		self.ui_elements["rotate_text"].horzalign = "fullscreen";
		self.ui_elements["rotate_text"].vertalign = "fullscreen";
		self.ui_elements["rotate_text"].alignx = "center";
		self.ui_elements["rotate_text"].aligny = "top";
		self.ui_elements["rotate_text"].alpha = 1;
		self.ui_elements["rotate_text"].x = x;
		self.ui_elements["rotate_text"].y = self.ui_elements["rotate_button"].y + 9;
		self.ui_elements["rotate_text"].sort = 1;
		self.ui_elements["rotate_text"].font = font;
		self.ui_elements["rotate_text"].fontscale = fontscale;
		self.ui_elements["rotate_text"] settext("Rotate");
	}
	
	if(!isdefined(self.ui_elements["concuss_button"])) {
		self.ui_elements["concuss_button"] = newclienthudelem(self);
		self.ui_elements["concuss_button"].horzalign = "fullscreen";
		self.ui_elements["concuss_button"].vertalign = "fullscreen";
		self.ui_elements["concuss_button"].alignx = "center";
		self.ui_elements["concuss_button"].aligny = "top";
		self.ui_elements["concuss_button"].alpha = 1;
		self.ui_elements["concuss_button"].x = x;
		self.ui_elements["concuss_button"].y = self.ui_elements["rotate_button"].y + spacing;
		self.ui_elements["concuss_button"].sort = 1;
		self.ui_elements["concuss_button"].font = "small";
		self.ui_elements["concuss_button"].fontscale = fontscale * 2.5;
		self.ui_elements["concuss_button"] settext("^1[{+frag}]");
	}
	
	if(!isdefined(self.ui_elements["concuss_text"])) {
		self.ui_elements["concuss_text"] = newclienthudelem(self);
		self.ui_elements["concuss_text"].horzalign = "fullscreen";
		self.ui_elements["concuss_text"].vertalign = "fullscreen";
		self.ui_elements["concuss_text"].alignx = "center";
		self.ui_elements["concuss_text"].aligny = "top";
		self.ui_elements["concuss_text"].alpha = 1;
		self.ui_elements["concuss_text"].x = x;
		self.ui_elements["concuss_text"].y = self.ui_elements["concuss_button"].y + 9;
		self.ui_elements["concuss_text"].sort = 1;
		self.ui_elements["concuss_text"].fontscale = fontscale;
		self.ui_elements["concuss_text"].font = font;
		self.ui_elements["concuss_text"].label = &"Concuss: ";
	}
	
	if(!isdefined(self.ui_elements["change_button"])) {
		self.ui_elements["change_button"] = newclienthudelem(self);
		self.ui_elements["change_button"].horzalign = "fullscreen";
		self.ui_elements["change_button"].vertalign = "fullscreen";
		self.ui_elements["change_button"].alignx = "center";
		self.ui_elements["change_button"].aligny = "top";
		self.ui_elements["change_button"].alpha = 1;
		self.ui_elements["change_button"].x = x;
		self.ui_elements["change_button"].y = self.ui_elements["concuss_button"].y + spacing;
		self.ui_elements["change_button"].sort = 1;
		self.ui_elements["change_button"].font = "small";
		self.ui_elements["change_button"].fontscale = fontscale * 2.5;
		self.ui_elements["change_button"] settext("^1[{weapnext}]");
	}
	
	if(!isdefined(self.ui_elements["change_text"])) {
		self.ui_elements["change_text"] = newclienthudelem(self);
		self.ui_elements["change_text"].horzalign = "fullscreen";
		self.ui_elements["change_text"].vertalign = "fullscreen";
		self.ui_elements["change_text"].alignx = "center";
		self.ui_elements["change_text"].aligny = "top";
		self.ui_elements["change_text"].alpha = 1;
		self.ui_elements["change_text"].x = x;
		self.ui_elements["change_text"].y = self.ui_elements["change_button"].y + 9;
		self.ui_elements["change_text"].sort = 1;
		self.ui_elements["change_text"].fontscale = fontscale;
		self.ui_elements["change_text"].font = font;
		self.ui_elements["change_text"].label = &"Change: ";
	}
	
	if(!isdefined(self.ui_elements["decoy_button"])) {
		self.ui_elements["decoy_button"] = newclienthudelem(self);
		self.ui_elements["decoy_button"].horzalign = "fullscreen";
		self.ui_elements["decoy_button"].vertalign = "fullscreen";
		self.ui_elements["decoy_button"].alignx = "center";
		self.ui_elements["decoy_button"].aligny = "top";
		self.ui_elements["decoy_button"].alpha = 1;
		self.ui_elements["decoy_button"].x = x;
		self.ui_elements["decoy_button"].y = self.ui_elements["change_button"].y + spacing;
		self.ui_elements["decoy_button"].sort = 1;
		self.ui_elements["decoy_button"].font = "small";
		self.ui_elements["decoy_button"].fontscale = fontscale * 2.5;
		self.ui_elements["decoy_button"] settext("^1[{+smoke}]");
	}
	
	if(!isdefined(self.ui_elements["decoy_text"])) {
		self.ui_elements["decoy_text"] = newclienthudelem(self);
		self.ui_elements["decoy_text"].horzalign = "fullscreen";
		self.ui_elements["decoy_text"].vertalign = "fullscreen";
		self.ui_elements["decoy_text"].alignx = "center";
		self.ui_elements["decoy_text"].aligny = "top";
		self.ui_elements["decoy_text"].alpha = 1;
		self.ui_elements["decoy_text"].x = x;
		self.ui_elements["decoy_text"].y = self.ui_elements["decoy_button"].y + 9;
		self.ui_elements["decoy_text"].sort = 1;
		self.ui_elements["decoy_text"].fontscale = fontscale;
		self.ui_elements["decoy_text"].font = font;
		self.ui_elements["decoy_text"].label = &"Decoy: ";
	}
	
	while(isdefined(self.ui_elements["change_text"])) {
		wait .05;
		
		if(isdefined(self.ui_elements["change_text"]))
			self.ui_elements["change_text"] setvalue(self.prop_changes);
		if(isdefined(self.ui_elements["concuss_text"]))
			self.ui_elements["concuss_text"] setvalue(self.concuss_left);
		if(isdefined(self.ui_elements["decoy_text"]))
			self.ui_elements["decoy_text"] setvalue(self.decoys_left);
	}
}

setup_prop() {
	self endon("disconnect");
    
    model = level.modelsarray[randomintrange(0, level.modelsarray.size - 1)];
    
    self.prop = spawnstruct();
    
    self.prop.linker = spawn("script_origin", self.origin);
    
    self.prop.model = spawn("script_model", self.origin);
    self.prop.model.angles = (0, 45, 0);
	self.prop.model setcandamage(1);
	self.prop.model.maxhealth = 100;
	self.prop.model.health = self.prop.model.maxhealth;
	self.prop.model setmodel(model);
	self.prop.model thread damage_handler(self);
	
	self.prop.model setcontents(1);
	self.prop.model solid();
	self.prop.model linkto(self.prop.linker);
	self.prop.linker linkto(self);
	self PlayerLinkedOffsetEnable();
	self.prop.model hide();
	self.prop.model showtoplayer(self);
	
	if(model == "chicken" || model == "chicken_black_white" || model == "chicken_black_white")
		self.prop.model scriptmodelplayanim("chicken_cage_loop_01");
	
	self setclientdvar("cg_thirdperson", 1);
	self takeallweapons();
	self disableweapons();
	self.prop.linker hide();
	self hide();
	self playerhide();
}

damage_handler(owner) {
	self endon("imdead");
	owner endon("disconnect");
	
	self thread on_disconnect_handler(owner);
	
	while(1) {
		self waittill("damage", amount, attacker, direction, point, type, modelname, tagname, partname, weaponname);
		
		if(isdefined(attacker)) {
			owner thread maps\mp\gametypes\_damage::finishplayerdamagewrapper(attacker, attacker, amount, 0, "MOD_PROJECTILE", attacker getcurrentweapon(), owner.origin, owner.origin, "none", 0, 0 );
			attacker thread maps\mp\gametypes\_damagefeedback::updatedamagefeedback("flash");
			
			if(owner.health <= 0) {
				playfxontag(common_scripts\utility::getfx( "sentry_explode_mp" ), self, "tag_origin");
				self delete();
				owner.prop.linker delete();
				
				wait 1;
				
				owner.sessionstate = "spectator";
				owner.sessionteam = "spectator";
				
				owner allowspectateteam( "allies", 1 );
    			owner allowspectateteam( "axis", 1 );
    			owner allowspectateteam( "freelook", 0);
    			owner allowspectateteam( "none", 1 );
   				
   				self notify("imdead");
			}
		}
	}
}

magicgrenade_2(weaponname, origin, owner) {
	if(isdefined(weaponname)) {
		modelname = getweaponmodel(weaponname);
		
		ent = spawn("script_model", origin);
		ent setmodel(modelname);
		ent.owner = owner;
		ent physicslaunchserver(( 0.0, 0.0, 0.0), (0, 0, 0));
		
		wait .5;
		ent playfx(level.concussionfx, ent.origin);
		ent playsound("stungrenade_explode_default");
		
		radius = 256;
		foreach(player in level.players) {
			if(player.sessionteam == "axis") {
				if(distance(player.origin, ent.origin) < 256) {
					scale = 1 - (distance(ent.origin, player.origin) / radius);
				
					if(scale < 0)
						scale = 0;

					time = 2 + (4 * scale);
				
					player shellshock("concussion_grenade_mp", time);
				}
			}
		}
		
		wait .5;
		
		ent delete();
	}
}

on_disconnect_handler(owner) {
	owner waittill("disconnect");
	
	if(isdefined(self))
		self delete();
}

create_models_array() {
	level.modelsarray = [];
	
    switch(getdvar("mapname")) {
    	case "mp_terminal_cls":
    		level.modelsarray[level.modelsarray.size] = "727_coach_seat01";
    		level.modelsarray[level.modelsarray.size] = "ap_couch01";
    		level.modelsarray[level.modelsarray.size] = "cargo_cage_64x96x48";
    		level.modelsarray[level.modelsarray.size] = "ch_russian_table";
    		level.modelsarray[level.modelsarray.size] = "com_computer_case";
    		level.modelsarray[level.modelsarray.size] = "com_fire_extinguisher";
    		level.modelsarray[level.modelsarray.size] = "com_plasticcase_beige_big";
    		level.modelsarray[level.modelsarray.size] = "com_plasticcase_black_big";
    		level.modelsarray[level.modelsarray.size] = "com_plasticcase_green_big";
    		level.modelsarray[level.modelsarray.size] = "com_potted_plant_large";
    		level.modelsarray[level.modelsarray.size] = "com_potted_plant_medium";
    		level.modelsarray[level.modelsarray.size] = "com_restaurantkitchentable_5";
    		level.modelsarray[level.modelsarray.size] = "com_restaurantstainlessteelshelf_01";
    		level.modelsarray[level.modelsarray.size] = "com_restaurantstove";
    		level.modelsarray[level.modelsarray.size] = "com_restaurantstovewithburner";
    		level.modelsarray[level.modelsarray.size] = "com_roofvent2_animated";
    		level.modelsarray[level.modelsarray.size] = "com_trafficcone01_uk";
    		level.modelsarray[level.modelsarray.size] = "com_trash_bin_sml01";
    		level.modelsarray[level.modelsarray.size] = "com_trashbag2_white";
    		level.modelsarray[level.modelsarray.size] = "com_trashcan";
    		level.modelsarray[level.modelsarray.size] = "com_tv1";
    		level.modelsarray[level.modelsarray.size] = "com_tv2";
    		level.modelsarray[level.modelsarray.size] = "concrete_barrier_damaged_1";
    		level.modelsarray[level.modelsarray.size] = "com_vending_can_new2_lit";
    		level.modelsarray[level.modelsarray.size] = "concrete_barrier_damaged_2";
    		level.modelsarray[level.modelsarray.size] = "ma_garbage_bin_1";
    		level.modelsarray[level.modelsarray.size] = "ma_restaurant_barstool";
    		level.modelsarray[level.modelsarray.size] = "ma_restaurant_boothchair";
    		level.modelsarray[level.modelsarray.size] = "ma_restaurant_table_side";
    		level.modelsarray[level.modelsarray.size] = "machinery_cart";
    		level.modelsarray[level.modelsarray.size] = "machinery_generator";
    		level.modelsarray[level.modelsarray.size] = "machinery_baggage_container";
    		level.modelsarray[level.modelsarray.size] = "road_barrier_white";
    		level.modelsarray[level.modelsarray.size] = "road_barrier_orange";
    		level.modelsarray[level.modelsarray.size] = "prop_telephone_box";
    		break;
    }
}

get_model_size(model) {
	max_health = 500;
	min_health = 1;
	
	size = 400;
	
	x_pos = bullettrace(model.origin + (size, 0, 0), model.origin + (-size, 0, 0), 1, undefined, 1, 1);
	x_neg = bullettrace(model.origin + (-size, 0, 0), model.origin + (size, 0, 0), 1, undefined, 1, 1);
	
	y_pos = bullettrace(model.origin + (0, size, 0), model.origin + (0, -size, 0), 1, undefined, 1, 1);
	y_neg = bullettrace(model.origin + (0, -size, 0), model.origin + (0, size, 0), 1, undefined, 1, 1);
	
	z_pos = bullettrace(model.origin + (0, 0, size), model.origin + (0, 0, -size), 1, undefined, 1, 1);
	z_neg = bullettrace(model.origin + (0, 0, -size), model.origin + (0, 0, size), 1, undefined, 1, 1);
	
	x_calc = distance(x_pos["position"], x_neg["position"]);
	y_calc = distance(y_pos["position"], y_neg["position"]);
	z_calc = distance(z_pos["position"], z_neg["position"]);
	
	if(BulletTracePassed(model.origin + (size, 0, 0), model.origin + (-size, 0, 0), 1, undefined)) {
		x_calc = 10;
		iprintln("Didnt Hit ^5X");
	}
		
	if(BulletTracePassed(model.origin + (0, size, 0), model.origin + (0, -size, 0), 1, undefined)) {
		y_calc = 10;
		iprintln("Didnt Hit ^5Y");
	}
		
	if(BulletTracePassed(model.origin + (0, 0, size), model.origin + (0, 0, -size), 1, undefined)) {
		z_calc = 10;
		iprintln("Didnt Hit ^5Z");
	}
	
	return int((x_calc * .5) + (y_calc * .5) + (z_calc * .5));
}
