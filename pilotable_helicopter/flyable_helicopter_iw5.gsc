#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

// Made by ZECxR3ap3r

init() {
	setdvar("g_hardcore", 1);
	
    level thread on_connect();
}

on_connect() {
  	for (;;) {
    	level waittill("connected", player);
    	player thread on_spawned();
  	}
}

on_spawned() {
	level endon("game_ended");
	self endon( "disconnect" );
	
	self.initial_spawn = 0;
	
	for (;;) {
		self waittill( "spawned_player" );
		
		if(isdefined(self.personal_chopper)) {
			self.personal_chopper delete();
    		self.heli_camera_model delete();
		}
		
		if(self.initial_spawn == 0) {
			self.initial_spawn = 1;
			
			self notifyonplayercommand("Change_Heli_Weapon", "vote yes");
			self notifyonplayercommand("Change_Heli_Cam", "vote no");
			
			self thread heli_weapon_think();
			self thread heli_controls();
			
			if(isdefined(self.ui_elements["ui_weaponname"]))
				self.ui_elements["ui_weaponname"] settext(self.firetype);
			
			wait 1;
		}
		
		helicopter = spawnHelicopter(self, self.origin + (0,0,2000), (0,0,0), "apache_strafe_mp", "vehicle_apache_mp" );
		helicopter MakeVehicleSolidCapsule(500, 500, 500); 
		helicopter setyawspeed(400, 400);
           
        camera_model = spawn("script_model", self.origin);
        camera_model setmodel("tag_origin");
        camera_model linkto(helicopter, "tag_player", (-520,0,240), (0,0,0));
            
        self thread heli_camera_think(camera_model);
     	
     	self.heli_pov = "out";
     	self PlayerLinkToAbsolute(camera_model, "tag_player", 1.0, 0, 0, 0, 0, true );
        self controlslinkto(helicopter);
    		
    	self setThirdPersonDOF( false );
    	self.personal_chopper = helicopter;
    	self.heli_camera_model = camera_model;
        self disableweapons();
        self setmodel("tag_origin");
        self detachall();
        self takeallweapons();
        self setclientdvar("cg_thirdperson", 1);
	}
}

heli_camera_think(camera_model) {
	self endon("disconnect");
	self endon("death");
	level endon("game_ended");
	
	while(1) {
		self waittill("Change_Heli_Cam");
		
		camera_model unlink();
		
		if(self.heli_pov == "out") {
			camera_model linkto(self.personal_chopper, "tag_player", (100,0,-300), (80,0,0));
			
			self setclientdvar("cg_thirdperson", 0);
			self.heli_pov = "first";
			
			self VisionSetThermalForPlayer( level.ac130.enhanced_vision, 0 );
			self ThermalVisionOn();
			self ThermalVisionFOFOverlayOn();
			self thread maps\mp\killstreaks\_helicopter::thermalVision( self.personal_chopper );
		}
		else {
			self.personal_chopper notify("end_autopilot");
			self unlink();
			self controlslinkto(self.personal_chopper);
			self PlayerLinkToAbsolute(camera_model, "tag_player", 1.0, 0, 0, 0, 0, true );
			camera_model linkto(self.personal_chopper, "tag_player", (-520,0,240), (0,0,0));
			self ThermalVisionOff();
			self ThermalVisionFOFOverlayOff();
			self visionSetThermalForPlayer( game["thermal_vision"], 0 );
			self.heli_pov = "out";
			self setclientdvar("cg_thirdperson", 1);
		}
		
		wait .5;
	}
}

heli_weapon_think() {
	self endon("disconnect");
	level endon("game_ended");
	
	shots = "right";
	self.firetype = "aamissile_projectile_mp";
	self.currentshots = [];
	self.currentshots["aamissile_projectile_mp"] = 12;
	self.currentshots["ac130_105mm_mp"] = 4;
	self.currentshots["ac130_40mm_mp"] = 30;
	self.currentshots["ac130_25mm_mp"] = 60;
	
	self thread change_weapon_think();
	
	while(1) {
		if(self attackbuttonpressed()) {
			eye	= self geteye();
    		vec = anglesToForward(self getplayerangles());
    		end = (vec[0] * 100000000,vec[1] * 100000000,vec[2] * 100000000);
    		end_pos = BulletTrace(eye,end,0,self)["position"];
    		
    		if(self.firetype == "aamissile_projectile_mp") {
    			if(shots == "right") {
					rocket = MagicBullet(self.firetype, eye - (100, 100, 400), end_pos, self);
					shots = "left";
				}
				else {
					rocket = MagicBullet(self.firetype, eye + (100, 100, -400), end_pos, self);
					shots = "right";
				}
			}
			else
				MagicBullet(self.firetype, eye + (0, 0, -400), end_pos, self);
			
			self.currentshots[self.firetype] -= 1;
			
			if(self.currentshots[self.firetype] <= 0) {
				self.ui_elements["ui_currentammo"] settext("^3Reloading...");
				self.heli_reloading = 1;
				wait 2;
				if(self.firetype == "aamissile_projectile_mp")
					self.currentshots["aamissile_projectile_mp"] = 12;
				else if(self.firetype == "ac130_105mm_mp")
					self.currentshots["ac130_105mm_mp"] = 4;
				else if(self.firetype == "ac130_40mm_mp")
					self.currentshots["ac130_40mm_mp"] = 30;
				else if(self.firetype == "ac130_25mm_mp")
					self.currentshots["ac130_25mm_mp"] = 60;
				self.heli_reloading = undefined;
				self.ui_elements["ui_currentammo"].label = &"Ammo: ^3";
			}
			
			
			// to give them some time between each shot
			if(self.firetype == "aamissile_projectile_mp") 
				wait .25;
			else if(self.firetype == "ac130_105mm_mp") 
				wait .6;
			else if(self.firetype == "ac130_40mm_mp") 
				wait .1;
		}
		
		wait .05;
	}
}

change_weapon_think() {
	self endon("disconnect");
	level endon("game_ended");
	
	while(1) {
		self waittill("Change_Heli_Weapon");
		
		if(!isdefined(self.heli_reloading)) {
			if(self.firetype == "aamissile_projectile_mp") {
				self.firetype = "ac130_105mm_mp";
				self iprintlnbold("^3Changed to 105mm Missles");
			}
			else if(self.firetype == "ac130_105mm_mp") {
				self.firetype = "ac130_40mm_mp";
				self iprintlnbold("^3Changed to 40mm Missles");
			}
			else if(self.firetype == "ac130_40mm_mp") {
				self.firetype = "ac130_25mm_mp";
				self iprintlnbold("^3Changed to 25mm Missles");
			}
			else if(self.firetype == "ac130_25mm_mp") {
				self.firetype = "aamissile_projectile_mp";
				self iprintlnbold("^3Changed to Rockets");
			}
		
			self.ui_elements["ui_weaponname"] settext(self.firetype);
		
			wait .2;
		}
	}
}

heli_controls() {
	self endon("disconnect");
	level endon("game_ended");
	
	if(!isdefined(self.ui_elements))
		self.ui_elements = [];
		
	if(!isdefined(self.ui_elements["ui_controls"])) {
		self.ui_elements["ui_controls"] = newclienthudelem(self);
		self.ui_elements["ui_controls"].horzalign = "fullscreen";
		self.ui_elements["ui_controls"].vertalign = "fullscreen";
		self.ui_elements["ui_controls"].alignx = "left";
		self.ui_elements["ui_controls"].aligny = "top";
		self.ui_elements["ui_controls"].alpha = 1;
		self.ui_elements["ui_controls"].x = 5;
		self.ui_elements["ui_controls"].y = 5;
		self.ui_elements["ui_controls"].fontscale = .45;
		self.ui_elements["ui_controls"].hidewheninmenu = 1;
		self.ui_elements["ui_controls"].font = "hudbig";
		self.ui_elements["ui_controls"] settext("^3[{+smoke}] ^7Fly Down\n^3[{+frag}] ^7Fly Up\n\n^3[{vote yes}] ^7Change Weapon\n^3[{vote no}] ^7Change Camera");
	}
	
	if(!isdefined(self.ui_elements["ui_weaponname"])) {
		self.ui_elements["ui_weaponname"] = newclienthudelem(self);
		self.ui_elements["ui_weaponname"].horzalign = "fullscreen";
		self.ui_elements["ui_weaponname"].vertalign = "fullscreen";
		self.ui_elements["ui_weaponname"].alignx = "right";
		self.ui_elements["ui_weaponname"].aligny = "top";
		self.ui_elements["ui_weaponname"].alpha = 1;
		self.ui_elements["ui_weaponname"].x = 635;
		self.ui_elements["ui_weaponname"].y = 440;
		self.ui_elements["ui_weaponname"].sort = 1;
		self.ui_elements["ui_weaponname"].color = (1,1,1);
		self.ui_elements["ui_weaponname"].fontscale = .7;
		self.ui_elements["ui_weaponname"].hidewheninmenu = 1;
		self.ui_elements["ui_weaponname"].font = "hudbig";
	}
	
	if(!isdefined(self.ui_elements["ui_currentammo"])) {
		self.ui_elements["ui_currentammo"] = newclienthudelem(self);
		self.ui_elements["ui_currentammo"].horzalign = "fullscreen";
		self.ui_elements["ui_currentammo"].vertalign = "fullscreen";
		self.ui_elements["ui_currentammo"].alignx = "right";
		self.ui_elements["ui_currentammo"].aligny = "top";
		self.ui_elements["ui_currentammo"].alpha = 1;
		self.ui_elements["ui_currentammo"].x = 635;
		self.ui_elements["ui_currentammo"].y = 455;
		self.ui_elements["ui_currentammo"].sort = 1;
		self.ui_elements["ui_currentammo"].color = (1,1,1);
		self.ui_elements["ui_currentammo"].fontscale = .55;
		self.ui_elements["ui_currentammo"].hidewheninmenu = 1;
		self.ui_elements["ui_currentammo"].font = "hudbig";
		self.ui_elements["ui_currentammo"].label = &"Ammo: ^3";
	}
	
	while(1) {
		if(!isdefined(self.heli_reloading))
			self.ui_elements["ui_currentammo"] setvalue(int(self.currentshots[self.firetype]));
		
		wait .05;
	}
}