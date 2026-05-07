ChallengeHud() {
    flag_wait("start_zombie_round_logic");
    level.ChallengeHud.alignx = "left";
    level.ChallengeHud.aligny = "top";
    level.ChallengeHud.horzalign = "fullscreen";
    level.ChallengeHud.vertalign = "fullscreen";
    level.ChallengeHudText.alignx = "left";
    level.ChallengeHudText.aligny = "top";
    level.ChallengeHudText.horzalign = "fullscreen";
    level.ChallengeHudText.vertalign = "fullscreen";
    level.ChallengeHud SetShader("scorebar_zom_1", 100, 15);
    level.ChallengeHudText.fontscale = 1.1;
    level.ChallengeHudText.alpha = 1;
    level.ChallengeHudText.foreground = true;
    level.ChallengeHud.x = 10;
    level.ChallengeHud.y = 110;
    level.ChallengeHud.alpha = 1;
    level.ChallengeHudText.x = 15;
    level.ChallengeHudText.y = 110;
    level.ChallengeHud.alpha = 1;
    level.ChallengeHudText settext("Activate Generators (0/4)");
}

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

schrotthud() {
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
    self.namehud settext(self.realname);

    self.namehudLine = newClientHudElem(self);
    self.namehudLine.x = 15;
    self.namehudLine.y = 465;
    self.namehudLine.alignx = "left";
    self.namehudLine.aligny = "bottom";
    self.namehudLine.horzalign = "fullscreen";
    self.namehudLine.vertalign = "fullscreen";
    self.namehudLine.alpha = 1;
    self.namehudLine.archived = false;
    self.namehudLine.color = (1, 0.785, 0);
    self.namehudLine.foreground = true;
    self.namehudLine.hidewheninmenu = true;
    self.namehudLine.hidewhendead = true;
    self.namehudLine setshader("white", 1, 10);
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
    self.namehud settext(self.realname);

    self.namehudLine = newClientHudElem(self);
    self.namehudLine.x = 15;
    self.namehudLine.y = 465;
    self.namehudLine.alignx = "left";
    self.namehudLine.aligny = "bottom";
    self.namehudLine.horzalign = "fullscreen";
    self.namehudLine.vertalign = "fullscreen";
    self.namehudLine.alpha = 1;
    self.namehudLine.archived = false;
    self.namehudLine.color = (1, 0.785, 0);
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
    
    self.WeaponShaderBackground = newClientHudElem( self );
    self.WeaponShaderBackground.x = 555;
    self.WeaponShaderBackground.y = 449;
    self.WeaponShaderBackground.alignx = "center";
    self.WeaponShaderBackground.aligny = "bottom";
    self.WeaponShaderBackground.horzalign = "fullscreen";
    self.WeaponShaderBackground.vertalign = "fullscreen";
    self.WeaponShaderBackground.alpha = 0.7;
    self.WeaponShaderBackground.sort = 0;
    self.WeaponShaderBackground.color = (.75,.25,.25);
    self.WeaponShaderBackground.archived = false;
    self.WeaponShaderBackground setshader("line_horizontal", 70, 20);
    self.WeaponShaderBackground.hidewheninmenu = true;
    self.WeaponShaderBackground.hidewhendead = true;

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
    self.scorenumber.color = (1, 0.785, 0);
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

CustomRoundNumber() {
    level.hud.alignx = "left";
    level.hud.aligny = "top";
    level.hud.horzalign = "center";
    level.hud.vertalign = "user_top";
    level.hudtext.alignx = "center";
    level.hudtext.aligny = "top";
    level.hudtext.horzalign = "center";
    level.hudtext.vertalign = "user_top";
    flag_wait("initial_blackscreen_passed");
    level.hudtext settext("WAVE");
    level.hud setvalue(level.round_number);
    level.hud.fontscale = 2;
    level.hud.x = 0;
    level.hud.y = 90;
    level.hud.alpha = 0;
    level.hudtext.fontscale = 2;
    level.hudtext.x = 0;
    level.hudtext.y = 70;
    level.hudtext.alpha = 0;
    level.hud fadeovertime(1);
    level.hud.alpha = 1;
    level.hudtext fadeovertime(1);
    level.hudtext.alpha = 1;
    wait 3;
    level.hudtext fadeovertime(1);
    level.hudtext.alpha = 0;
    level.hud moveovertime(3);
    level.hud.alignx = "left";
    level.hud.aligny = "top";
    level.hud.horzalign = "fullscreen";
    level.hud.vertalign = "fullscreen";
    level.hud.x = 15;
    level.hud.y = 15;  // 15
}

flashroundnumber() {
    level.hud fadeovertime(1);
    level.hud.alpha = 0;
    wait 1;
    level.hud.alignx = "left";
    level.hud.aligny = "top";
    level.hud.horzalign = "center";
    level.hud.vertalign = "user_top";
    level.hud setvalue(level.round_number);
    level.hud.alignx = "CENTER";
    level.hud.aligny = "top";
    level.hud.horzalign = "user_center";
    level.hud.vertalign = "user_top";
    level.hud.x = 0;
    level.hud.y = 90;
    level.hud.fontscale = 2;
    level.hud fadeovertime(1);
    level.hud.alpha = 1;
    level.hudtext fadeovertime(1);
    level.hudtext.alpha = 1;
    wait 3;
    level.hudtext fadeovertime(1);
    level.hudtext.alpha = 0;
    wait 1;
    level.hud moveovertime(2.5);
    level.hud.alignx = "left";
    level.hud.aligny = "top";
    level.hud.horzalign = "fullscreen";
    level.hud.vertalign = "fullscreen";
    level.hud.x = 15;
    level.hud.y = 15;
    level.hud fadeovertime(1);
    level.hud.alpha = 1;
}

zone_hud() {
    self endon("disconnect");
    self.zone_hud = newClientHudElem(self);
    self.zone_hud.alignx = "left";
    self.zone_hud.aligny = "top";
    self.zone_hud.horzalign = "user_left";
    self.zone_hud.vertalign = "user_top";
    self.zone_hud.x = 55;
    self.zone_hud.y = 18;
    self.zone_hud.fontscale = 1;
    self.zone_hud.alpha = .75;
    self.zone_hud.color = (1, 1, 1);

    flag_wait("initial_blackscreen_passed");

    prev_zone = "";
    while (1) {
        zone = self get_zone_name();

        if (prev_zone != zone) {
            prev_zone = zone;

            self.zone_hud fadeovertime(0.25);
            self.zone_hud.alpha = 0;
            wait 0.25;

            self.zone_hud settext(zone);

            self.zone_hud fadeovertime(0.25);
            self.zone_hud.alpha = 1;
            wait 0.25;

            continue;
        }

        wait 0.05;
    }
}

creator_info(title, names, intermission) {
    self endon("disconnect");

    // Mod name
    wait .5;
    headline = newclienthudelem(self);
    headline.horzalign = "center";
    headline.alignx = "center";
    headline.vertalign = "fullscreen";
    headline.aligny = "middle";
    headline.y = 80;
    headline.foreground = true;
    headline.hidewhendead = false;
    headline.hidewheninmenu = true;
    headline.alpha = 0;
    headline.color = (1, 1, 1);
    headline.fontscale = 5;
    headline settext(title);

    headline changefontscaleovertime(.25);
    headline fadeovertime(.25);
    headline.alpha = 1;
    headline.fontscale = 2.5;

    // Creators
    wait .5;
    subtext = newclienthudelem(self);
    subtext.horzalign = "center";
    subtext.alignx = "center";
    subtext.vertalign = "fullscreen";
    subtext.aligny = "middle";
    subtext.y = 99;
    subtext.foreground = true;
    subtext.hidewhendead = false;
    subtext.hidewheninmenu = true;
    subtext.alpha = 0;
    subtext.color = (.8, .8, .8);
    subtext.fontscale = 1.3;

    if (isstring(names))
        names = array(names);

    creator_names = "";

    for (i = 0; i < names.size; i++) {
        if (i == names.size - 2)
            creator_names += names[i] + " ^7and ";

        else if (i < names.size - 1)
            creator_names += names[i] + "^7, ";

        else
            creator_names += names[i];
    }

    subtext settext("^7A Mod by " + creator_names);

    subtext fadeovertime(.25);
    subtext.alpha = 1;

    // Outro that stays on intermission screen
    if (isdefined(intermission) && intermission) {
        outrotext = newclienthudelem(self);
        outrotext.horzalign = "center";
        outrotext.alignx = "center";
        outrotext.vertalign = "fullscreen";
        outrotext.aligny = "middle";
        outrotext.y = 58;
        outrotext.foreground = true;
        outrotext.hidewhendead = false;
        outrotext.hidewheninmenu = true;
        outrotext.alpha = 0;
        outrotext.color = (.8, .8, .8);
        outrotext.fontscale = 1.3;
        outrotext settext("Thanks for playing");

        outrotext fadeovertime(.25);
        outrotext.alpha = 1;

        return;
    }

    // Intro fadeout animation
    wait 4;
    headline fadeovertime(.5);
    headline.alpha = 0;

    subtext fadeovertime(.5);
    subtext.alpha = 0;

    headline destroy();
    subtext destroy();

    // Repeat on intermission
    level waittill("intermission");
    self thread creator_info(title, names, true);
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






