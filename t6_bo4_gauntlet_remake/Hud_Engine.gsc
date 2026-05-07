perk_hud_create(perk) {
    if (!IsDefined(self.perk_hud))
        self.perk_hud = [];
    
    if (!IsDefined(self.perk_hud_upgraded))
        self.perk_hud_upgraded = [];

    shader = "";
    perk_name = "";

    switch (perk) {
    case "specialty_armorvest_upgrade":
        shader = "specialty_juggernaut_zombies_pro";
        perk_name = "Juggernog Pro";
        color = (1,.25,25);
        break;
    
    case "specialty_armorvest":
        shader = "specialty_juggernaut_zombies";
        perk_name = "Juggernog";
        color = (1,.25,25);
        break;

    case "specialty_quickrevive_upgrade":
        shader = "specialty_quickrevive_zombies_pro";
        perk_name = "Quick Revive Pro";
        color = (.15,.75,.75);
        break;
   
    case "specialty_quickrevive":
        shader = "specialty_quickrevive_zombies";
        perk_name = "Quick Revive";
        color = (.15,.75,.75);
        break;

    case "specialty_fastreload_upgrade":
        shader = "specialty_fastreload_zombies_pro";
        perk_name = "Speed Cola Pro";
        color = (.25,1,.25);
        break;
    
    case "specialty_fastreload":
        shader = "specialty_fastreload_zombies";
        perk_name = "Speed Cola";
        color = (.25,1,.25);
        break;

    case "specialty_rof":
        shader = "specialty_doubletap_zombies";
        perk_name = "Double Tap";
        color = (1,.75,.25);
        break;

    case "specialty_longersprint":
        shader = "specialty_marathon_zombies";
        perk_name = "Stamin Up";
        color = (1,.75,.25);
        break;

    case "specialty_scavenger":
        shader = "specialty_tombstone_zombies";
        perk_name = "Tombstone";
        color = (.4,0,1);
        break;

    default:
        shader = "";
        break;
    }
    
    InfoMessage = newClientHudElem( self );
    InfoMessage.x = 320;
    InfoMessage.y = 95;
    InfoMessage.alignx = "center";
   	InfoMessage.aligny = "bottom";
    InfoMessage.horzalign = "fullscreen";
    InfoMessage.vertalign = "fullscreen";
    InfoMessage.alpha = 1;
   	InfoMessage.sort = 1;
   	InfoMessage.fontscale = 1.2;
    InfoMessage.color = (1,1,1);
   	InfoMessage.archived = true;
   	InfoMessage.foreground = true;
   	InfoMessage.glowalpha = 1;
   	InfoMessage.glowcolor = color;
    InfoMessage settext(perk_name);
    InfoMessage.hidewheninmenu = true;
    
	PerkShader = newClientHudElem( self );
    PerkShader.x = 320;
    PerkShader.y = 80;
    PerkShader.alignx = "center";
   	PerkShader.aligny = "bottom";
    PerkShader.horzalign = "fullscreen";
    PerkShader.vertalign = "fullscreen";
    PerkShader.alpha = 1;
   	PerkShader.sort = 1;
    PerkShader.color = (1,1,1);
   	PerkShader.archived = true;
   	PerkShader.foreground = true;
    PerkShader setshader(shader, 25, 25);
    PerkShader.hidewheninmenu = true;
	wait 3;
	InfoMessage destroy();
	PerkShader scaleovertime( 1, 15, 15);
	PerkShader moveOverTime( 1 );
	PerkShader.alignx = "left";
	if (shader == "specialty_fastreload_zombies_pro" || shader == "specialty_juggernaut_zombies_pro" || shader == "specialty_quickrevive_zombies_pro") {
		PerkShader.x = 150 + (self.perk_hud_upgraded.size * 20);
        PerkShader.y = 445;
        self.perk_hud_upgraded[self.perk_hud_upgraded.size] = PerkShader;
    }
    else {
        PerkShader.x = 150 + (self.perk_hud.size * 20);
        PerkShader.y = 465;
        self.perk_hud[self.perk_hud.size] = PerkShader;
	}
	wait 1;
}

WeaponHud() {
    self endon("disconnect");
	
	self.namehud = self createFontString("default", 1);
    self.namehud.x = 19;
    self.namehud.y = 465;
    self.namehud.alignx = "left";
    self.namehud.aligny = "bottom";
    self.namehud.horzalign = "fullscreen";
    self.namehud.vertalign = "fullscreen";
    self.namehud.alpha = 1;
    self.namehud.color = (1, 1, 1);
    self.namehud.archived = false;
    self.namehud.foreground = true;
    self.namehud.hidewheninmenu = true;
    self.namehud.hidewhendead = true;
    self.namehud settext(self.name);

    self.namehudLine = newClientHudElem(self);
    self.namehudLine.x = 15;
    self.namehudLine.y = 465;
    self.namehudLine.alignx = "left";
    self.namehudLine.aligny = "bottom";
    self.namehudLine.horzalign = "fullscreen";
    self.namehudLine.vertalign = "fullscreen";
    self.namehudLine.alpha = 1;
    self.namehudLine.archived = false;
    self.namehudLine.color = level.ui_better_red;
    self.namehudLine.foreground = true;
    self.namehudLine.hidewheninmenu = true;
    self.namehudLine.hidewhendead = true;
    self.namehudLine setshader("white", 1, 10);
	
    self.WeaponRank = newClientHudElem(self);
    self.WeaponRank.x = 625;
    self.WeaponRank.y = 469;
    self.WeaponRank.alignx = "RIGHT";
    self.WeaponRank.aligny = "BOTTOM";
    self.WeaponRank.horzalign = "fullscreen";
    self.WeaponRank.vertalign = "fullscreen";
    self.WeaponRank.alpha = 0.8;
    self.WeaponRank.sort = 1;
    self.WeaponRank.color = (0, 0, 0);
    self.WeaponRank.archived = false;
    self.WeaponRank.foreground = true;
    self.WeaponRank setshader("gradient_fadein", 110, 13);
    
    self.WeaponShader = newClientHudElem( self );
    self.WeaponShader.x = 565;
    self.WeaponShader.y = 440;
    self.WeaponShader.alignx = "right";
    self.WeaponShader.aligny = "middle";
    self.WeaponShader.horzalign = "fullscreen";
    self.WeaponShader.vertalign = "fullscreen";
    self.WeaponShader.alpha = 0.7;
    self.WeaponShader.sort = 1;
    self.WeaponShader.color = (1,1,1);
    self.WeaponShader.archived = false;
    self.WeaponShader setshader("", 53, 30);
    self.WeaponShader.hidewheninmenu = true;
    self.WeaponShader.hidewhendead = true;

    self.WeaponRankLine = newClientHudElem(self);
    self.WeaponRankLine.x = 625;
    self.WeaponRankLine.y = 453;
    self.WeaponRankLine.alignx = "RIGHT";
    self.WeaponRankLine.aligny = "BOTTOM";
    self.WeaponRankLine.horzalign = "fullscreen";
    self.WeaponRankLine.vertalign = "fullscreen";
    self.WeaponRankLine.alpha = 1;
    self.WeaponRankLine.sort = 1;
    self.WeaponRankLine.color = (1, 1, 1);
    self.WeaponRankLine.archived = false;
    self.WeaponRankLine.foreground = true;
    self.WeaponRankLine setshader("white", 110, 1);

    self.WeaponAmmo = newClientHudElem(self);
    self.WeaponAmmo.x = 625;
    self.WeaponAmmo.y = 449;
    self.WeaponAmmo.alignx = "RIGHT";
    self.WeaponAmmo.aligny = "BOTTOM";
    self.WeaponAmmo.horzalign = "fullscreen";
    self.WeaponAmmo.vertalign = "fullscreen";
    self.WeaponAmmo.alpha = 1;
    self.WeaponAmmo.sort = 1;
    self.WeaponAmmo.color = (0, 0, 0);
    self.WeaponAmmo.archived = false;
    self.WeaponAmmo.foreground = true;
    self.WeaponAmmo setshader("gradient_fadein", 50, 20);

    self.weaponName = newClientHudElem(self);
    self.weaponName.x = 622;
    self.weaponName.y = 469;  // 220;
    self.weaponName.alignx = "RIGHT";
    self.weaponName.aligny = "BOTTOM";
    self.weaponName.color = (1, 1, 1);
    self.weaponName.alpha = 1;
    self.weaponName.archived = false;
    self.weaponName.sort = 80;
    self.weaponName.foreground = true;
    self.weaponName.fontscale = 1.2;
    self.weaponName.horzalign = "fullscreen";
    self.weaponName.vertalign = "fullscreen";

    self.WeaponAmmoText = newClientHudElem(self);
    self.WeaponAmmoText.x = 593;
    self.WeaponAmmoText.y = 454;
    self.WeaponAmmoText.alignx = "RIGHT";
    self.WeaponAmmoText.aligny = "BOTTOM";
    self.WeaponAmmoText.color = (1, 1, 1);
    self.WeaponAmmoText.alpha = 1;
    self.WeaponAmmoText.archived = false;
    self.WeaponAmmoText.foreground = true;
    self.WeaponAmmoText.font = "default";
    self.WeaponAmmoText.fontscale = 2.6;
    self.WeaponAmmoText.horzalign = "fullscreen";
    self.WeaponAmmoText.vertalign = "fullscreen";

    self.WeaponAmmoTextStock = newClientHudElem(self);
    self.WeaponAmmoTextStock.x = 622;
    self.WeaponAmmoTextStock.y = 449;  // 220;
    self.WeaponAmmoTextStock.alignx = "RIGHT";
    self.WeaponAmmoTextStock.aligny = "BOTTOM";
    self.WeaponAmmoTextStock.color = (1, 1, 1);
    self.WeaponAmmoTextStock.alpha = 1;
    self.WeaponAmmoTextStock.sort = 80;
    self.WeaponAmmoTextStock.archived = false;
    self.WeaponAmmoTextStock.foreground = true;
    self.WeaponAmmoTextStock.fontscale = 1.8;
    self.WeaponAmmoTextStock.horzalign = "fullscreen";
    self.WeaponAmmoTextStock.vertalign = "fullscreen";

    self.GrenadeHud = newClientHudElem(self);
    self.GrenadeHud.x = 493;
    self.GrenadeHud.y = 450;  // 220;
    self.GrenadeHud.alignx = "RIGHT";
    self.GrenadeHud.aligny = "BOTTOM";
    self.GrenadeHud.horzalign = "fullscreen";
    self.GrenadeHud.vertalign = "fullscreen";
    self.GrenadeHud.alpha = 0;
    self.GrenadeHud.sort = 10;
    self.GrenadeHud.color = (1, 1, 1);
    self.GrenadeHud.archived = false;
    self.GrenadeHud.foreground = true;
    self.GrenadeHud setshader("hud_grenadeicon", 18, 18);

    self.GrenadeLine = newClientHudElem(self);
    self.GrenadeLine.x = 495;
    self.GrenadeLine.y = 453;  // 220;
    self.GrenadeLine.alignx = "RIGHT";
    self.GrenadeLine.aligny = "BOTTOM";
    self.GrenadeLine.horzalign = "fullscreen";
    self.GrenadeLine.vertalign = "fullscreen";
    self.GrenadeLine.alpha = 1;
    self.GrenadeLine.sort = 1;
    self.GrenadeLine.color = (1, 1, 1);
    self.GrenadeLine.archived = false;
    self.GrenadeLine.foreground = true;
    self.GrenadeLine setshader("white", 20, 1);

    self.GrenadeName = newClientHudElem(self);
    self.GrenadeName.x = 485;
    self.GrenadeName.y = 470;  // 220;
    self.GrenadeName.alignx = "CENTER";
    self.GrenadeName.aligny = "BOTTOM";
    self.GrenadeName.color = (1, 1, 1);
    self.GrenadeName.alpha = 1;
    self.GrenadeName.archived = false;
    self.GrenadeName.sort = 80;
    self.GrenadeName.foreground = true;
    self.GrenadeName.fontscale = 1;
    self.GrenadeName.horzalign = "fullscreen";
    self.GrenadeName.vertalign = "fullscreen";

    self.EmpHud = newClientHudElem(self);
    self.EmpHud.x = 463;
    self.EmpHud.y = 450;  // 220;
    self.EmpHud.alignx = "RIGHT";
    self.EmpHud.aligny = "BOTTOM";
    self.EmpHud.horzalign = "fullscreen";
    self.EmpHud.vertalign = "fullscreen";
    self.EmpHud.alpha = 0;
    self.EmpHud.sort = 10;
    self.EmpHud.color = (1, 1, 1);
    self.EmpHud.archived = false;
    self.EmpHud.foreground = true;

    self.EmpHudLine = newClientHudElem(self);
    self.EmpHudLine.x = 465;
    self.EmpHudLine.y = 453;  // 220;
    self.EmpHudLine.alignx = "RIGHT";
    self.EmpHudLine.aligny = "BOTTOM";
    self.EmpHudLine.horzalign = "fullscreen";
    self.EmpHudLine.vertalign = "fullscreen";
    self.EmpHudLine.alpha = 1;
    self.EmpHudLine.sort = 1;
    self.EmpHudLine.color = (1, 1, 1);
    self.EmpHudLine.archived = false;
    self.EmpHudLine.foreground = true;
    self.EmpHudLine setshader("white", 20, 1);

    self.EmpHudText = newClientHudElem(self);
    self.EmpHudText.x = 455;
    self.EmpHudText.y = 470;  // 220;
    self.EmpHudText.alignx = "CENTER";
    self.EmpHudText.aligny = "BOTTOM";
    self.EmpHudText.color = (1, 1, 1);
    self.EmpHudText.alpha = 1;
    self.EmpHudText.archived = false;
    self.EmpHudText.sort = 80;
    self.EmpHudText.foreground = true;
    self.EmpHudText.fontscale = 1;
    self.EmpHudText.horzalign = "fullscreen";
    self.EmpHudText.vertalign = "fullscreen";

    self.ShieldLine = newClientHudElem(self);
    self.ShieldLine.x = 433;
    self.ShieldLine.y = -27;  // 220;
    self.ShieldLine.alignx = "RIGHT";
    self.ShieldLine.aligny = "BOTTOM";
    self.ShieldLine.horzalign = "fullscreen";
    self.ShieldLine.vertalign = "fullscreen";
    self.ShieldLine.alpha = 0;
    self.ShieldLine.sort = 1;
    self.ShieldLine.color = (1, 1, 1);
    self.ShieldLine.archived = false;
    self.ShieldLine.foreground = true;
    self.ShieldLine setshader("white", 20, 1);

    self.shield_icon = newClientHudElem(self);
    self.shield_icon.x = 433;
    self.shield_icon.y = -30;
    self.shield_icon.alignx = "RIGHT";
    self.shield_icon.aligny = "BOTTOM";
    self.shield_icon.horzalign = "fullscreen";
    self.shield_icon.vertalign = "fullscreen";
    self.shield_icon.alpha = 0;
    self.shield_icon.archived = false;
    self.shield_icon.foreground = true;
    self.shield_icon.hidewheninmenu = true;
    self.shield_icon.hidewhendead = true;
    self.shield_icon setshader("riotshield_zm_icon", 18, 18);
    while (1) {
        if (isdefined(self.shielddamagetaken) && self.shielddamagetaken >= 1) {
            if (self.shield_icon.alpha != 1) {
                self.shield_icon.alpha = 1;
            }
        }
        else {
            if (self.shield_icon.alpha != 0) {
                self.shield_icon.alpha = 0;
            }
        }
        weapon = self getcurrentweapon();
        weapona = self get_real_name(weapon);
        if (weapona == "" || weapona == "none") {
            if (self.WeaponAmmoText.alpha == 1) {
                self.WeaponAmmoText.alpha = 0;
                self.weaponName.alpha = 0;
                self.WeaponAmmoTextStock.alpha = 0;
            }
        }
        else {
            if (self.WeaponAmmoText.alpha == 0) {
                self.WeaponAmmoText.alpha = 1;
                self.weaponName.alpha = 1;
                self.WeaponAmmoTextStock.alpha = 1;
            }
            weaponname = self get_real_name(weapon);
            self.weaponName settext(weaponname);
        }
        self waittill("weapon_change");
    }
}

ShieldHud() {
    level endon("game_ended");
    level endon("end_game");
    self endon("disconnect");
    self.int_shield = self hasweapon("riotshield_zm");
    self.shield_hud = false;

    while (1) {
        if (self.int_shield || self hasweapon("riotshield_zm"))
            self.int_shield = true;
        else
            self.int_shield = false;

        if (self.int_shield && (self.shielddamagetaken < 2300)) {
            if (!self.shield_hud) {
                shield_bar = newClientHudElem(self);
                shield_bar.x = -238;
                shield_bar.y = -15;  // 220;
                shield_bar.alignx = "CENTER";
                shield_bar.aligny = "BOTTOM";
                shield_bar.color = (1, 1, 1);
                shield_bar.alpha = 1;
                shield_bar.archived = false;
                shield_bar.sort = 80;
                shield_bar.foreground = true;
                shield_bar.fontscale = 1;
                shield_bar.horzalign = "USER_RIGHT";
                shield_bar.vertalign = "USER_BOTTOM";

                self.shield_hud = true;
            }

            shield_hp = ((2300 - self.shielddamagetaken) / 2300);
            final_value = int(shield_hp * 100);

            if (shield_hp < .35)
                shield_bar.color = level.ui_better_red;
            else
                shield_bar.color = (1, 1, 1);

            shield_bar setvalue(final_value);
        }

        else {
            self.int_shield = false;
            self.shield_hud = false;

            shield_bar destroy();
        }

        wait .05;
    }
}

HealthBar() {
    level endon("game_ended");
    self endon("death");
    self endon("disconnect");
    self thread ShieldHud();
    flag_wait("initial_blackscreen_passed");

    x = 15;
    y = 450;
    base_width = 60;
    base_height = 2;
    init_width = base_width * (self.maxhealth / 250);

    self.health_bar = newClientHudElem(self);
    self.health_bar.x = x + 1;
    self.health_bar.y = y;
    self.health_bar.alignx = "left";
    self.health_bar.aligny = "bottom";
    self.health_bar.horzalign = "fullscreen";
    self.health_bar.vertalign = "fullscreen";
    self.health_bar.alpha = 1;
    self.health_bar.archived = true;
    self.health_bar.foreground = true;
    self.health_bar.hidewheninmenu = true;
    self.health_bar.hidewhendead = true;
    self.health_bar setshader("white", init_width, base_height);

    self.health_bar_frame = newClientHudElem(self);
    self.health_bar_frame.x = x;
    self.health_bar_frame.y = y + 1;
    self.health_bar_frame.alignx = "left";
    self.health_bar_frame.aligny = "bottom";
    self.health_bar_frame.horzalign = "fullscreen";
    self.health_bar_frame.vertalign = "fullscreen";
    self.health_bar_frame.alpha = .75;
    self.health_bar_frame.sort = -1;
    self.health_bar_frame.color = (0, 0, 0);
    self.health_bar_frame.archived = true;
    self.health_bar_frame.foreground = true;
    self.health_bar_frame.hidewheninmenu = true;
    self.health_bar_frame.hidewhendead = true;
    self.health_bar_frame setshader("gradient_fadein", base_width + 2, base_height + 2);

    self.health_text = self createFontString("default", 1);
    self.health_text.x = x + base_width + 2 + 3;
    self.health_text.y = y + 3.5;
    self.health_text.alignx = "left";
    self.health_text.aligny = "bottom";
    self.health_text.horzalign = "fullscreen";
    self.health_text.vertalign = "fullscreen";
    self.health_text.alpha = 1;
    self.health_text.archived = true;
    self.health_text.foreground = true;
    self.health_text.hidewheninmenu = true;
    self.health_text.hidewhendead = true;

    self.scorenumber = self createFontString("default", 1);
    self.scorenumber.x = x;
    self.scorenumber.y = 445;
    self.scorenumber.alignx = "left";
    self.scorenumber.aligny = "bottom";
    self.scorenumber.horzalign = "fullscreen";
    self.scorenumber.vertalign = "fullscreen";
    self.scorenumber.alpha = 1;
    self.scorenumber.color = level.ui_better_red;
    self.scorenumber.archived = true;
    self.scorenumber.foreground = true;
    self.scorenumber.hidewheninmenu = true;
    self.scorenumber.hidewhendead = true;
    self.scorenumber.label = &"$";

    self.scorenumberValue = self createFontString("default", 1);
    self.scorenumberValue.x = 20;
    self.scorenumberValue.y = 445;
    self.scorenumberValue.alignx = "left";
    self.scorenumberValue.aligny = "bottom";
    self.scorenumberValue.horzalign = "fullscreen";
    self.scorenumberValue.vertalign = "fullscreen";
    self.scorenumberValue.alpha = 1;
    self.scorenumberValue.color = (1, 1, 1);
    self.scorenumberValue.archived = true;
    self.scorenumberValue.foreground = true;
    self.scorenumberValue.hidewheninmenu = true;
    self.scorenumberValue.hidewhendead = true;

    self.lowhealthoverlay = newclienthudelem(self);
    self.lowhealthoverlay.x = 0;
    self.lowhealthoverlay.y = 0;
    self.lowhealthoverlay.horzAlign = "fullscreen";
    self.lowhealthoverlay.vertAlign = "fullscreen";
    self.lowhealthoverlay.sort = 1;
    self.lowhealthoverlay SetShader("overlay_low_health", 640, 480);
    self.lowhealthoverlay.alpha = 0;

    if (!isDefined(self.maxhealth) || self.maxhealth <= 0)
        self.maxhealth = 100;

    while (1) {
        if (level.intermission) {
            self.health_bar destroy();
            self.health_bar_frame destroy();
            self.health_text destroy();
            break;
        }
        downed = self player_is_in_laststand();
        low_health = self.health < 75;

        if (downed || low_health)
            color = level.ui_better_red;
        else
            color = (1, 1, 1);

        if (low_health) {
            self.lowhealthoverlay fadeovertime(0.3);
            self.lowhealthoverlay.alpha = 0.5;
        }
        else {
            self.lowhealthoverlay fadeovertime(0.3);
            self.lowhealthoverlay.alpha = 0;
        }
        width = (self.health / self.maxhealth) * base_width * (250 / 250);
        width = downed ? 1 : int(max(width, 1));

        if (color == level.ui_better_red) {
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
    self.hitmarker setshader("damage_feedback", 24, 48);

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

    self.crossdot_frame = newclienthudelem(self);
    self.crossdot_frame.horzalign = "center";
    self.crossdot_frame.alignx = "center";
    self.crossdot_frame.vertalign = "middle";
    self.crossdot_frame.aligny = "middle";
    self.crossdot_frame.foreground = true;
    self.crossdot_frame.hidewheninmenu = true;
    self.crossdot_frame.hidden = false;
    self.crossdot_frame.color = (.125, .125, .125);

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

