#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

main() {
	replacefunc(maps\mp\gametypes\_gamelogic::startgame, ::startGame_New);
}

init() {
	precacheshader("demo_play");
	precacheshader("hud_white_box");
	precacheshader("minimap_light_on");
	
	setdvar("g_hardcore", 1);
	
	level thread on_connect();
}

on_connect() {
	while(1) {
		level waittill("connected", player);
		
		player thread on_spawned();
	}
}

startGame_New() {
	game["strings"]["objective_hint_allies"] = "";
	game["strings"]["objective_hint_axis"  ] = "";
	game["strings"]["axis_name"] = "";	
	game["strings"]["allies_name"] = "";
	
	gameFlagSet( "prematch_done" );	
	level notify("prematch_over");
	thread maps\mp\gametypes\_missions::roundBegin();	
}

on_spawned() {
	self endon("disconnect");
	
	self waittill("spawned_player");
	
	self freezecontrols(1);
	self setclientdvar("cg_crosshairalpha", 0);
	self thread start_flappy_main();
}

start_flappy_main() {
	if(!isdefined(self.ui_elements))
		self.ui_elements = [];
	
	self notifyonplayercommand("start_flappy", "+gostand");
	
	self thread create_huds();
	self thread check_movement();
	self thread flappy_think();
}

create_huds() {
	if(!isdefined(self.ui_elements["background_sky"])) {
		self.ui_elements["background_sky"] = newclienthudelem(self);
		self.ui_elements["background_sky"].horzalign = "fullscreen";
		self.ui_elements["background_sky"].vertalign = "fullscreen";
		self.ui_elements["background_sky"].alignx = "left";
		self.ui_elements["background_sky"].aligny = "top";
		self.ui_elements["background_sky"].x = 0;
		self.ui_elements["background_sky"].y = 0;
		self.ui_elements["background_sky"].sort = -1;
		self.ui_elements["background_sky"] setshader("minimap_light_on", 640, 480);
	}
	
	/*if(!isdefined(self.ui_elements["background_star_1"])) {
		self.ui_elements["background_star_1"] = newclienthudelem(self);
		self.ui_elements["background_star_1"].horzalign = "fullscreen";
		self.ui_elements["background_star_1"].vertalign = "fullscreen";
		self.ui_elements["background_star_1"].alignx = "center";
		self.ui_elements["background_star_1"].aligny = "top";
		self.ui_elements["background_star_1"].x = 320;
		self.ui_elements["background_star_1"].y = 50;
		self.ui_elements["background_star_1"].sort = 0;
		self.ui_elements["background_star_1"] setshader("motd_ticker_bg", 50, 50);
	}*/
	
	if(!isdefined(self.ui_elements["background_grass"])) {
		self.ui_elements["background_grass"] = newclienthudelem(self);
		self.ui_elements["background_grass"].horzalign = "fullscreen";
		self.ui_elements["background_grass"].vertalign = "fullscreen";
		self.ui_elements["background_grass"].alignx = "left";
		self.ui_elements["background_grass"].aligny = "top";
		self.ui_elements["background_grass"].x = 0;
		self.ui_elements["background_grass"].y = 360;
		self.ui_elements["background_grass"].sort = 0;
		self.ui_elements["background_grass"].color = (0, .18, .059);
		self.ui_elements["background_grass"] setshader("hud_white_box", 640, 15);
	}
	
	if(!isdefined(self.ui_elements["background_dirt"])) {
		self.ui_elements["background_dirt"] = newclienthudelem(self);
		self.ui_elements["background_dirt"].horzalign = "fullscreen";
		self.ui_elements["background_dirt"].vertalign = "fullscreen";
		self.ui_elements["background_dirt"].alignx = "left";
		self.ui_elements["background_dirt"].aligny = "top";
		self.ui_elements["background_dirt"].x = 0;
		self.ui_elements["background_dirt"].y = 375;
		self.ui_elements["background_dirt"].sort = 0;
		self.ui_elements["background_dirt"].color = (.22, .18, .118);
		self.ui_elements["background_dirt"] setshader("hud_white_box", 840, 200);
	}
	
	if(!isdefined(self.ui_elements["title_screen"])) {
		self.ui_elements["title_screen"] = newclienthudelem(self);
		self.ui_elements["title_screen"].alignx = "center";
		self.ui_elements["title_screen"].aligny = "top";
		self.ui_elements["title_screen"].horzalign = "fullscreen";
		self.ui_elements["title_screen"].vertalign = "fullscreen";
		self.ui_elements["title_screen"].x = 320;
		self.ui_elements["title_screen"].y = 100;
		self.ui_elements["title_screen"].sort = 5;
		self.ui_elements["title_screen"].font = "hudsmall";
		self.ui_elements["title_screen"].fontscale = 1.6;
		self.ui_elements["title_screen"].color = (1, 1, 1);
		self.ui_elements["title_screen"] settext("^2IW5 ^7Flappy Bird by ^2ZECxR3ap3r");
	}
	
	if(!isdefined(self.ui_elements["playgame"])) {
		self.ui_elements["playgame"] = newclienthudelem(self);
		self.ui_elements["playgame"].alignx = "center";
		self.ui_elements["playgame"].aligny = "top";
		self.ui_elements["playgame"].horzalign = "fullscreen";
		self.ui_elements["playgame"].vertalign = "fullscreen";
		self.ui_elements["playgame"].x = 320;
		self.ui_elements["playgame"].y = 200;
		self.ui_elements["playgame"].sort = 5;
		self.ui_elements["playgame"].font = "hudsmall";
		self.ui_elements["playgame"].fontscale = 1.2;
		self.ui_elements["playgame"].color = (1, 1, 1);
		self.ui_elements["playgame"] settext("Press ^2[{+gostand}] ^7to Play");
		self.ui_elements["playgame"] thread pulsy();
	}
	
	self waittill("start_flappy");
	
	self.flappy_count = 0;
	
	self thread flappy_endgame();
	
	if(isdefined(self.ui_elements["your_score"]))
		self.ui_elements["your_score"] destroy();
	self.ui_elements["title_screen"] destroy();
	self.ui_elements["playgame"] destroy();
	
	self.tubes = [];
	
	if(!isdefined(self.ui_elements["flappy_counter"])) {
		self.ui_elements["flappy_counter"] = newclienthudelem(self);
		self.ui_elements["flappy_counter"].alignx = "center";
		self.ui_elements["flappy_counter"].aligny = "top";
		self.ui_elements["flappy_counter"].horzalign = "fullscreen";
		self.ui_elements["flappy_counter"].vertalign = "fullscreen";
		self.ui_elements["flappy_counter"].x = 320;
		self.ui_elements["flappy_counter"].y = 20;
		self.ui_elements["flappy_counter"].sort = 5;
		self.ui_elements["flappy_counter"].font = "hudsmall";
		self.ui_elements["flappy_counter"].fontscale = 1.4;
		self.ui_elements["flappy_counter"].color = (1, 1, 1);
		self.ui_elements["flappy_counter"] setvalue(self.flappy_count);
	}
	
	if(!isdefined(self.ui_elements["flappy_bird"])) {
		self.ui_elements["flappy_bird"] = newclienthudelem(self);
		self.ui_elements["flappy_bird"].alignx = "left";
		self.ui_elements["flappy_bird"].aligny = "top";
		self.ui_elements["flappy_bird"].x = 70;
		self.ui_elements["flappy_bird"].y = 100;
		self.ui_elements["flappy_bird"].sort = 1;
		self.ui_elements["flappy_bird"].color = (1, 1, 0);
		self.ui_elements["flappy_bird"] setshader("demo_play", 20, 20);
	}
	
	for(i = 0;i < 5;i++) {
		if(!isdefined(self.ui_elements["mario_tube_top_" + i])) {
			self.ui_elements["mario_tube_top_" + i] = newclienthudelem(self);
			self.ui_elements["mario_tube_top_" + i].alignx = "right";
			self.ui_elements["mario_tube_top_" + i].aligny = "top";
			self.ui_elements["mario_tube_top_" + i].x = 200 * i;
			self.ui_elements["mario_tube_top_" + i].y = 0;
			self.ui_elements["mario_tube_top_" + i].sort = 1;
			self.ui_elements["mario_tube_top_" + i].alpha = 0;
			self.ui_elements["mario_tube_top_" + i].color = (.416, .675, .150);
			self.ui_elements["mario_tube_top_" + i] setshader("white", 40, 140);
			self.tubes[self.tubes.size] = self.ui_elements["mario_tube_top_" + i];
		}
		
		if(!isdefined(self.ui_elements["mario_tube_bottom_" + i])) {
			self.ui_elements["mario_tube_bottom_" + i] = newclienthudelem(self);
			self.ui_elements["mario_tube_bottom_" + i].alignx = "right";
			self.ui_elements["mario_tube_bottom_" + i].aligny = "bottom";
			self.ui_elements["mario_tube_bottom_" + i].x = 200 * i;
			self.ui_elements["mario_tube_bottom_" + i].y = 360;
			self.ui_elements["mario_tube_bottom_" + i].sort = 1;
			self.ui_elements["mario_tube_bottom_" + i].alpha = 0;
			self.ui_elements["mario_tube_bottom_" + i].number = 0;
			self.ui_elements["mario_tube_bottom_" + i].brother = self.ui_elements["mario_tube_top_" + i];
			self.ui_elements["mario_tube_bottom_" + i].color = (.416, .675, .150);
			self.ui_elements["mario_tube_bottom_" + i] setshader("white", 40, 140);
			self.ui_elements["mario_tube_bottom_" + i] thread movetube();
			self.ui_elements["mario_tube_bottom_" + i] thread countdown(self);
			self.tubes[self.tubes.size] = self.ui_elements["mario_tube_bottom_" + i];
		}
		
		wait 1;
	}
}

flappy_endgame() {
	self waittill("end_flappy");
	
	foreach(hud in self.tubes) {
		if(isdefined(hud))
			hud destroy();
	}
	if(isdefined(self.ui_elements["flappy_counter"]))
		self.ui_elements["flappy_counter"] destroy();
	if(isdefined(self.ui_elements["flappy_bird"]))
		self.ui_elements["flappy_bird"] destroy();
	
	if(!isdefined(self.ui_elements["your_score"])) {
		self.ui_elements["your_score"] = newclienthudelem(self);
		self.ui_elements["your_score"].alignx = "center";
		self.ui_elements["your_score"].aligny = "top";
		self.ui_elements["your_score"].horzalign = "fullscreen";
		self.ui_elements["your_score"].vertalign = "fullscreen";
		self.ui_elements["your_score"].x = 320;
		self.ui_elements["your_score"].y = 150;
		self.ui_elements["your_score"].sort = 5;
		self.ui_elements["your_score"].font = "hudsmall";
		self.ui_elements["your_score"].fontscale = 1.4;
		self.ui_elements["your_score"].color = (1, 1, 1);
		self.ui_elements["your_score"] settext("Your Last Score ^2" + self.flappy_count);
	}
	
	self thread create_huds();
}

pulsy() {
	while(isdefined(self)) {
		self fadeovertime(.7);
		self.alpha = .3;
		wait .7;
		self fadeovertime(.7);
		self.alpha = 1;
		wait .7;
	}
}

movetube() {
	self endon("death");
	
    bottom      = 360;
    gap         = 80;
    
    while(isdefined(self)) {
    	self.given_points 	= 0;
        self 				moveovertime(5);
        self.x 				= -120;
        self.brother 		moveovertime(5);
        self.brother.x 		= -120;
        
        wait 5;
        
        self.x 				= 780;
        self.brother.x 		= 780;
        
        self notify("start_count");
        
        num = randomintrange(40, 160);
        self.brother setshader("white", 40, num); 
        self setshader("white", 40, bottom - num - gap);
        self.gap_start = num - 20; 
        self.gap_end = num + gap - 20;
        
        self.brother.givensize = num;
        self.givensize = bottom - num - gap;
        
        if(self.alpha == 0)
            self.alpha = 1;
            
        if(self.brother.alpha == 0)
            self.brother.alpha = 1;
    }
}

countdown(player) {
	self endon("death");
	
	while(isdefined(self)) {
		self waittill("start_count");
	
		for(i = 780;i > 0;i -= 8) {
			self.number = i;
			
			if(i < 180 && i > 160) {
				if(player.ui_elements["flappy_bird"].y < self.gap_start)
					player notify("end_flappy");
				if(player.ui_elements["flappy_bird"].y > self.gap_end)
					player notify("end_flappy");
			}
			
			if(i < 150) {
				player.flappy_count += 1;
				player.ui_elements["flappy_counter"] setvalue(player.flappy_count);
				i = 0;
			}
			wait .05;
		}
	}
} 

check_movement() {
	self endon("disconnect");
	
	self notifyonplayercommand("jumpy", "+gostand");
	
	self.flappy_jump = 0;
	
	while(1) {
		if(isdefined(self.ui_elements["flappy_bird"])) {
			if(self attackbuttonpressed()) {
				if(self.flappy_jump == 0) {
					self.flappy_jump = 1;
		
					self.ui_elements["flappy_bird"] moveovertime(.2);
					self.ui_elements["flappy_bird"].y = self.ui_elements["flappy_bird"].y - 30;
					wait .2;
					self.flappy_jump = 0;
				}
			}
		}
		
		wait .05;
	}
}

flappy_think() {
	self endon("disconnect");
	
	while(1) {
		if(isdefined(self.ui_elements["flappy_bird"])) {
			if(self.flappy_jump == 0)
				self.ui_elements["flappy_bird"].y = self.ui_elements["flappy_bird"].y + 5;
				
			if(self.ui_elements["flappy_bird"].y > 340)
				self iprintln("^1Dead");
		}
			
		wait .05;
	}
}

is_touching(elem, cursor) {
    x1 = elem.x;
    y1 = elem.y;
    x2 = cursor.x;
    y2 = cursor.y;
    
    if (abs(x1 - x2) < 20 && abs(y1 - y2) < 10)
        return true;
    else
        return false;
}

