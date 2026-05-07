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

init() {
	level thread on_connect();
	makedvarserverinfo( "ui_allow_teamchange", 1 );
    setdvar( "ui_allow_teamchange", 1 );
}

on_connect() {
	while(1) {
		level waittill("connected", player);
		
		player thread on_spawned();
	}
}

on_spawned() {
	self endon("disconnect");
	
	while(1) {
		self waittill("spawned_player");
		
		self thread create_calculator();
	}
}

create_calculator() {
	self endon("disconnect");
	
	self thread create_calculator_hud();
	self thread monitor_input();
	self thread handle_calculator();
}

create_calculator_hud() {
	if(!isdefined(self.hud_elements))
		self.hud_elements = [];
		
	i = self.hud_elements.size;
	
	iF(!isdefined(self.hud_elements[i])) {
		self.hud_elements[i] = newclienthudelem(self);
		self.hud_elements[i].horzalign = "fullscreen";
		self.hud_elements[i].vertalign = "fullscreen";
		self.hud_elements[i].alignx = "center";
		self.hud_elements[i].aligny = "top";
		self.hud_elements[i].fontscale = 1.3;
		self.hud_elements[i].x = 290;
		self.hud_elements[i].y = 240;
		self.hud_elements[i].key1 = 7;
		self.hud_elements[i].key2 = 4;
		self.hud_elements[i].key3 = 1;
		self.hud_elements[i].alpha = 0;
		self.hud_elements[i].key4 = "R";
	}
	
	i = self.hud_elements.size;
	
	iF(!isdefined(self.hud_elements[i])) {
		self.hud_elements[i] = newclienthudelem(self);
		self.hud_elements[i].horzalign = "fullscreen";
		self.hud_elements[i].vertalign = "fullscreen";
		self.hud_elements[i].alignx = "center";
		self.hud_elements[i].aligny = "top";
		self.hud_elements[i].fontscale = 1.3;
		self.hud_elements[i].x = 310;
		self.hud_elements[i].y = 240;
		self.hud_elements[i].key1 = 8;
		self.hud_elements[i].key2 = 5;
		self.hud_elements[i].key3 = 2;
		self.hud_elements[i].alpha = 0;
		self.hud_elements[i].key4 = 0;
	}
	
	i = self.hud_elements.size;
	
	iF(!isdefined(self.hud_elements[i])) {
		self.hud_elements[i] = newclienthudelem(self);
		self.hud_elements[i].horzalign = "fullscreen";
		self.hud_elements[i].vertalign = "fullscreen";
		self.hud_elements[i].alignx = "center";
		self.hud_elements[i].aligny = "top";
		self.hud_elements[i].fontscale = 1.3;
		self.hud_elements[i].x = 330;
		self.hud_elements[i].y = 240;
		self.hud_elements[i].key1 = 9;
		self.hud_elements[i].key2 = 6;
		self.hud_elements[i].key3 = 3;
		self.hud_elements[i].alpha = 0;
		self.hud_elements[i].key4 = ".";
	}
	
	i = self.hud_elements.size;
	
	iF(!isdefined(self.hud_elements[i])) {
		self.hud_elements[i] = newclienthudelem(self);
		self.hud_elements[i].horzalign = "fullscreen";
		self.hud_elements[i].vertalign = "fullscreen";
		self.hud_elements[i].alignx = "center";
		self.hud_elements[i].aligny = "top";
		self.hud_elements[i].fontscale = 1.3;
		self.hud_elements[i].x = 350;
		self.hud_elements[i].y = 240;
		self.hud_elements[i].key1 = "*";
		self.hud_elements[i].key2 = "-";
		self.hud_elements[i].key3 = "+";
		self.hud_elements[i].alpha = 0;
		self.hud_elements[i].key4 = "=";
	}
	
	if(!isdefined(self.calc_bg)) {
		self.calc_bg = newclienthudelem(self);
		self.calc_bg.horzalign = "fullscreen";
		self.calc_bg.vertalign = "fullscreen";
		self.calc_bg.alignx = "center";
		self.calc_bg.aligny = "top";
		self.calc_bg.x = 320;
		self.calc_bg.y = 200;
		self.calc_bg.alpha = 0;
		self.calc_bg.sort = -10;
		self.calc_bg.color = (0,0,0);
		self.calc_bg setshader("white", 86, 35);
	}
	
	if(!isdefined(self.calc_bottom_bg)) {
		self.calc_bottom_bg = newclienthudelem(self);
		self.calc_bottom_bg.horzalign = "fullscreen";
		self.calc_bottom_bg.vertalign = "fullscreen";
		self.calc_bottom_bg.alignx = "center";
		self.calc_bottom_bg.aligny = "top";
		self.calc_bottom_bg.x = 320;
		self.calc_bottom_bg.y = 235;
		self.calc_bottom_bg.alpha = 0;
		self.calc_bottom_bg.sort = -9;
		self.calc_bottom_bg.color = (0,0,0);
		self.calc_bottom_bg setshader("white", 86, 125);
	}
	
	if(!isdefined(self.lookbetter)) {
		self.lookbetter = newclienthudelem(self);
		self.lookbetter.horzalign = "fullscreen";
		self.lookbetter.vertalign = "fullscreen";
		self.lookbetter.alignx = "center";
		self.lookbetter.aligny = "top";
		self.lookbetter.x = 320;
		self.lookbetter.y = 355;
		self.lookbetter.alpha = 0;
		self.lookbetter.sort = -7;
		self.lookbetter.color = (1,.25,.25);
		self.lookbetter setshader("white", 86, 10);
	}
	
	if(!isdefined(self.end_result)) {
		self.end_result = newclienthudelem(self);
		self.end_result.horzalign = "fullscreen";
		self.end_result.vertalign = "fullscreen";
		self.end_result.alignx = "right";
		self.end_result.aligny = "top";
		self.end_result.x = 355;
		self.end_result.y = 220;
		self.end_result.fontscale = 1.3;
		self.end_result.alpha = 0;
		self.end_result.sort = 5;
		self.end_result setvalue(0);
	}
	
	if(!isdefined(self.current_calculation)) {
		self.current_calculation = newclienthudelem(self);
		self.current_calculation.horzalign = "fullscreen";
		self.current_calculation.vertalign = "fullscreen";
		self.current_calculation.alignx = "right";
		self.current_calculation.aligny = "top";
		self.current_calculation.x = 355;
		self.current_calculation.y = 205;
		self.current_calculation.fontscale = 1.2;
		self.current_calculation.alpha = 0;
		self.current_calculation.sort = 5;
	}
}

monitor_input() {
	self endon("disconnect");
	
	self.calculator_open 	= false;
	self.current_focus 		= 1;
	self.current_row		= 0;
	self.calculation 		= "";
	self.calc_stage 		= 0;
	self.real_calc			= [];
	self.real_symbols		= [];
	
	while(1) {
		wait .05;
		
		if(self actionslottwobuttonpressed()) {
			if(self.calculator_open == false) {
				foreach(hud in self.hud_elements)
					hud.alpha = 1;
					
				self.calc_bg.alpha = .6;
				self.calc_bottom_bg.alpha = .8;
				self.lookbetter.alpha = .6;
				self.end_result.alpha = 1;
				self.current_calculation.alpha = 1;
					
				self.calculator_open = true;
				self notify("text_refresh");
			}
			else {
				if((self.current_focus + 1) > 4)
					self.current_focus = 1;
				else
					self.current_focus += 1;
				
				self notify("text_refresh");
			}
		}
		
		if(self actionslotonebuttonpressed()) {
			if((self.current_focus - 1) < 1)
				self.current_focus = 4;
			else
				self.current_focus -= 1;
			
			self notify("text_refresh");
		}
		
		if(self actionslotfourbuttonpressed()) {
			if((self.current_row + 1) > 3)
				self.current_row = 0;
			else
				self.current_row += 1;
			
			self notify("text_refresh");
		}
		
		if(self actionslotthreebuttonpressed()) {
			if((self.current_row - 1) < 0)
				self.current_row = 3;
			else
				self.current_row -= 1;
			
			self notify("text_refresh");
		}
		
		if(self usebuttonpressed()) {
			if(isint(self.button_track)) {
				self.calculation += self.button_track;
				if(!isdefined(self.real_calc[self.calc_stage]))
					self.real_calc[self.calc_stage] = "" + self.button_track;
				else
					self.real_calc[self.calc_stage] += self.button_track;
				self iprintln(self.real_calc[self.calc_stage]);
				self.current_calculation settext(self.calculation);
			}
			else {
				if(self.button_track == "R") {
					self.calculation = "";
					self.real_calc = [];
					self.current_calculation settext(self.calculation);
				}
				if(self.button_track == "+") {
					self.calculation += " + ";
					self.calc_stage += 1;
					self.real_symbols[self.real_symbols.size] = "plus";
					self.current_calculation settext(self.calculation);
				}
				if(self.button_track == "-") {
					self.calculation += " - ";
					self.real_symbols[self.real_symbols.size] = "minus";
					self.calc_stage += 1;
					self.current_calculation settext(self.calculation);
				}
				if(self.button_track == "*") {
					self.calculation += " * ";
					self.real_symbols[self.real_symbols.size] = "multi";
					self.calc_stage += 1;
					self.current_calculation settext(self.calculation);
				}
				if(self.button_track == "=") {
					if(isdefined(self.real_symbols[0])) {
						math 				= 0;
						current_result 		= 0;
						for(i = 0;i < self.real_calc.size;i += 2) {
							if(isdefined(self.real_calc[i])) {
								if(self.real_symbols[0] == "plus")
									math = (float(self.real_calc[i]) + float(self.real_calc[i + 1]));
								if(self.real_symbols[0] == "minus")
									math = (float(self.real_calc[i]) - float(self.real_calc[i + 1]));
								if(self.real_symbols[0] == "multi")
									math = (float(self.real_calc[i]) * float(self.real_calc[i + 1]));
								
								current_result += math;
							}
						}
						
						self.end_result setvalue(current_result);
						self.calc_stage = 0;
					}
					else
						self iprintln("No");
				}
			}
			
			wait .15;
		}
	}
}

handle_calculator() {
	self endon("disconnect");
	
	self.select_color = 1;
	
	while(1) {
		self waittill("text_refresh");
		
		for(i = 0;i < self.hud_elements.size;i++) {
			if(isdefined(self.hud_elements[i])) {
				if(i == self.current_row) {
					if(self.current_focus == 1) {
						self.button_track = self.hud_elements[self.current_row].key1;
						self.hud_elements[self.current_row] settext("^" + self.select_color + self.hud_elements[self.current_row].key1 + "^7\n\n" + self.hud_elements[self.current_row].key2 + "\n\n" + self.hud_elements[self.current_row].key3 + "\n\n" + self.hud_elements[self.current_row].key4);
					}
					if(self.current_focus == 2) {
						self.button_track = self.hud_elements[self.current_row].key2;
						self.hud_elements[self.current_row] settext(self.hud_elements[self.current_row].key1 + "\n\n^" + self.select_color + "" + self.hud_elements[self.current_row].key2 + "^7\n\n" + self.hud_elements[self.current_row].key3 + "\n\n" + self.hud_elements[self.current_row].key4);
					}
					if(self.current_focus == 3) {
						self.button_track = self.hud_elements[self.current_row].key3;
						self.hud_elements[self.current_row] settext(self.hud_elements[self.current_row].key1 + "\n\n" + self.hud_elements[self.current_row].key2 + "\n\n^" +self.select_color + "" + self.hud_elements[self.current_row].key3 + "^7\n\n" + self.hud_elements[self.current_row].key4);
					}
					if(self.current_focus == 4) {
						self.button_track = self.hud_elements[self.current_row].key4;
						self.hud_elements[self.current_row] settext(self.hud_elements[self.current_row].key1 + "\n\n" + self.hud_elements[self.current_row].key2 + "\n\n" + self.hud_elements[self.current_row].key3 + "\n\n^" + self.select_color + "" + self.hud_elements[self.current_row].key4);
					}
				}
				else
					self.hud_elements[i] settext(self.hud_elements[i].key1 + "\n\n" + self.hud_elements[i].key2 + "\n\n" + self.hud_elements[i].key3 + "\n\n" + self.hud_elements[i].key4);	
			}
		}
	}
}

on_connect() {
	while(1) {
		level waittill("connected", player);
		
		player thread trigger_watcher();
		player.touching_trigger = player;
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

createText(position, text, range, height) {
    trigger = Spawn( "trigger_radius", position, 0, range, height);
	trigger.text = text;

	if(!isdefined(level.total_triggers))
		level.total_triggers = [];

	level.total_triggers[level.total_triggers.size] = trigger;
}

deleteLowerMsg(trigger, name) {
    self notify("Deletemsg");
    self endon("Deletemsg");
    self endon("disconnect");
    
    while(self istouching(trigger))
        wait .5;
        
    self clearLowerMessage(name);
    self.touching_trigger = self;
}
