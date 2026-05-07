#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

main() {
	replacefunc(maps\mp\_utility::allowclasschoice, ::class_choice);
    replacefunc(maps\mp\gametypes\_class::loadoutAllPerks, ::loadoutAllPerks_edit);
    replacefunc(maps\mp\gametypes\_menus::onMenuResponse, ::onMenuResponse_edit);
    replacefunc(maps\mp\gametypes\_gamelogic::displayGameEnd, ::displayGameEnd_edit);
    replacefunc(maps\mp\gametypes\_gamelogic::waittillFinalKillcamDone, ::waittillFinalKillcamDone_edit);
}

waittillFinalKillcamDone_edit() {
	if(!IsDefined(level.finalKillCam_winner))
		return false;

    wait 2;

	return true;
}

displayGameEnd_edit( winner, endReasonText ) {
    level waittill("start_killcam");

	level notify("round_end_finished");
}

init() {
    precacheshader("hud_1st");
    precacheshader("hud_2nd");
    precacheshader("hud_3rd");
    precacheshader("hud_4th");
    precacheshader("hud_bullet");
    precacheshader("hud_frame");
    precacheshader("player_life");
    precacheshader("line_horizontal");

    setdvar( "disable_challenges", 1);

    setObjectiveText( "allies", &"OBJECTIVES_OIC" );
	setObjectiveText( "axis", &"OBJECTIVES_OIC" );
	setObjectiveScoreText( "allies", &"OBJECTIVES_OIC_SCORE" );
	setObjectiveScoreText( "axis", &"OBJECTIVES_OIC_SCORE" );
	setObjectiveHintText( "allies", &"OBJECTIVES_OIC_HINT" );
	setObjectiveHintText( "axis", &"OBJECTIVES_OIC_HINT" );

    maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_dm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_dm_spawn" );
    game["dialog"]["gametype"] = undefined;

    level.getSpawnPoint = ::getSpawnPoint;

    level.game_info = [];
    level thread update_top_players();
    level thread handle_game();
    level thread handle_new_players();

    level.current_weapon = get_oic_weapon();

    level.callbackPlayerKilled = ::Callback_PlayerKilled;
    level.callbackPlayerDamage = ::Callback_PlayerDamage;

    setdvar("g_hardcore", 1);
    level.teambased = 0;

    level thread on_connect();

    if(!isdefined(level.hud_elements))
        level.hud_elements = [];

    if(!isdefined(level.hud_elements["gametime"])) {
        level.hud_elements["gametime"] = newhudelem();
        level.hud_elements["gametime"].horzalign = "fullscreen";
        level.hud_elements["gametime"].vertalign = "fullscreen";
        level.hud_elements["gametime"].alignx = "center";
        level.hud_elements["gametime"].aligny = "bottom";
        level.hud_elements["gametime"].fontscale = .7;
        level.hud_elements["gametime"].font = "hudbig";
        level.hud_elements["gametime"].x = 30;
        level.hud_elements["gametime"].y = 410;
        level.hud_elements["gametime"] settimer((60 * 10));
    }

    while(1) {
        wait .05;

        alive = 0;
        foreach(player in level.players) {
            if(isdefined(player.lives) && player.lives > 0)
                alive++;
        }

        level.game_info["alive"] = alive;
    }
}

getSpawnPoint()
{
	spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
	spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM( spawnPoints );

	return spawnPoint;
}

handle_game() {
    while(1) {
        if(level.game_info["alive"] == 1 && level.players.size > 1) {
            level notify("oic_end");

            level.hud_elements["gametime"] destroy();
            setSlowMotion(1, .5, 1);
            VisionSetNaked( "mpOutro", 1);
            foreach(player in level.players) {
                foreach(hud in player.hud_elements)
                    hud destroy();

                player thread ShowWinners();
            }
            setSlowMotion(1, 1, 0-05);

            thread maps\mp\gametypes\_gamelogic::endGame(level.game_info["top_players"].firstplace, "");

            wait level.roundEndDelay;

            level notify("start_killcam");

            break;
        }

        wait .1;
    }
}

handle_new_players() {
    while(level.players.size < 6)
        wait .05;

    wait 30;
    level.cannot_spawn_in = 1;
}

on_connect() {
    while(1) {
        level waittill("connected", player);

        player thread on_spawned();

        player setclientdvar("g_compassShowEnemies", 1);
    }
}

on_spawned() {
    self endon("disconnect");

    self [[level.autoassign]]();

    if(!isdefined(level.cannot_spawn_in)) {
        self.lives = 3;
        self thread hud_setup();

        while(1) {
            self waittill("spawned_player");

            self takeallweapons();
            self giveweapon(level.current_weapon);
            self setspawnweapon(level.current_weapon);
            self setweaponammoclip(level.current_weapon, 1);
            self setweaponammostock(level.current_weapon, 0);
        }
    }
    else {
        wait .05;

        self [[level.spectator]]();
        self iprintlnbold("Game is already running, please wait until next round!");
    }
}

hud_setup() {
    level endon("oic_end");
    self endon("disconnect");

    if(!isdefined(self.hud_elements))
        self.hud_elements = [];

    if(!isdefined(self.hud_elements["left_frame"])) {
        self.hud_elements["left_frame"] = newclienthudelem(self);
        self.hud_elements["left_frame"].horzalign = "fullscreen";
        self.hud_elements["left_frame"].vertalign = "fullscreen";
        self.hud_elements["left_frame"].alignx = "left";
        self.hud_elements["left_frame"].aligny = "bottom";
        self.hud_elements["left_frame"].x = -20;
        self.hud_elements["left_frame"].y = 480;
        self.hud_elements["left_frame"].sort = -1;
        self.hud_elements["left_frame"] setshader("hud_frame", 170, 60);
    }

    if(!isdefined(self.hud_elements["medal"])) {
        self.hud_elements["medal"] = newclienthudelem(self);
        self.hud_elements["medal"].horzalign = "fullscreen";
        self.hud_elements["medal"].vertalign = "fullscreen";
        self.hud_elements["medal"].alignx = "left";
        self.hud_elements["medal"].aligny = "bottom";
        self.hud_elements["medal"].x = 5;
        self.hud_elements["medal"].y = 475;
        self.hud_elements["medal"].sort = -1;
    }

    if(!isdefined(self.hud_elements["hud_alive"])) {
        self.hud_elements["hud_alive"] = newclienthudelem(self);
        self.hud_elements["hud_alive"].horzalign = "fullscreen";
        self.hud_elements["hud_alive"].vertalign = "fullscreen";
        self.hud_elements["hud_alive"].alignx = "left";
        self.hud_elements["hud_alive"].aligny = "bottom";
        self.hud_elements["hud_alive"].x = 63;
        self.hud_elements["hud_alive"].y = 478;
        self.hud_elements["hud_alive"].sort = 1;
        self.hud_elements["hud_alive"].fontscale = 1.6;
        self.hud_elements["hud_alive"].label = &"&&1 ALIVE";
    }

    if(!isdefined(self.hud_elements["hud_score"])) {
        self.hud_elements["hud_score"] = newclienthudelem(self);
        self.hud_elements["hud_score"].horzalign = "fullscreen";
        self.hud_elements["hud_score"].vertalign = "fullscreen";
        self.hud_elements["hud_score"].alignx = "left";
        self.hud_elements["hud_score"].aligny = "bottom";
        self.hud_elements["hud_score"].x = 63;
        self.hud_elements["hud_score"].y = 458;
        self.hud_elements["hud_score"].sort = 1;
        self.hud_elements["hud_score"].fontscale = 1.6;
    }

    for(i = 1; i < 4;i++) {
        if(!isdefined(self.hud_elements["hud_life_" + i])) {
            self.hud_elements["hud_life_" + i] = newclienthudelem(self);
            self.hud_elements["hud_life_" + i].horzalign = "fullscreen";
            self.hud_elements["hud_life_" + i].vertalign = "fullscreen";
            self.hud_elements["hud_life_" + i].alignx = "right";
            self.hud_elements["hud_life_" + i].aligny = "bottom";
            self.hud_elements["hud_life_" + i].x = 650 - (i * 14);
            self.hud_elements["hud_life_" + i].y = 433;
            self.hud_elements["hud_life_" + i].alpha = 1;
            self.hud_elements["hud_life_" + i].sort = -1;
            self.hud_elements["hud_life_" + i].archived = 0;
            self.hud_elements["hud_life_" + i] setshader("player_life", 40, 40);
            self.hud_elements["hud_life_" + i] thread visible_on_player_lives(i, self);
        }
    }

    for(i = 1; i < 4;i++) {
        if(!isdefined(self.hud_elements["hud_bullet_" + i])) {
            self.hud_elements["hud_bullet_" + i] = newclienthudelem(self);
            self.hud_elements["hud_bullet_" + i].horzalign = "fullscreen";
            self.hud_elements["hud_bullet_" + i].vertalign = "fullscreen";
            self.hud_elements["hud_bullet_" + i].alignx = "right";
            self.hud_elements["hud_bullet_" + i].aligny = "bottom";
            self.hud_elements["hud_bullet_" + i].x = 650 - (i * 15);
            self.hud_elements["hud_bullet_" + i].y = 475;
            self.hud_elements["hud_bullet_" + i].alpha = 1;
            self.hud_elements["hud_bullet_" + i].sort = -1;
            self.hud_elements["hud_bullet_" + i] setshader("hud_bullet", 20, 50);
            self.hud_elements["hud_bullet_" + i] thread visible_on_clip_ammo(i, self);
        }
    }

    while(1) {
        wait .05;

        self.adrenaline = 0;
        self.hud_elements["hud_score"] setvalue(self.score);
        self.hud_elements["hud_alive"] setvalue(level.game_info["alive"]);

        if(isdefined(level.game_info["top_players"].firstplace) && self.name == level.game_info["top_players"].firstplace.name)
            self.hud_elements["medal"] setshader("hud_1st", 50, 65);
        else if(isdefined(level.game_info["top_players"].secondplace) && self.name == level.game_info["top_players"].secondplace.name)
            self.hud_elements["medal"] setshader("hud_2nd", 50, 65);
        else if(isdefined(level.game_info["top_players"].thirdplace) && self.name == level.game_info["top_players"].thirdplace.name)
            self.hud_elements["medal"] setshader("hud_3rd", 50, 65);
        else
            self.hud_elements["medal"] setshader("hud_4th", 50, 65);

        if(self.lives == 0) {
            self [[level.spectator]]();
            break;
        }
    }
}

update_top_players() {
    level endon("oic_end");

    level waittill("connected", player);

    level.game_info["top_players"] = spawnstruct();
    level.game_info["top_players"].firstplace = undefined;
    level.game_info["top_players"].secondplace = undefined;
    level.game_info["top_players"].thirdplace = undefined;

    while(1) {
        top_players = [];

        for(i = 0; i < level.players.size; i++) {
            if(isdefined(level.players[i])) {
                top_players[top_players.size] = level.players[i];
            }
        }

        for(i = 0; i < top_players.size; i++) {
            for(j = i + 1; j < top_players.size; j++) {
                if(top_players[j].score > top_players[i].score) {
                    temp = top_players[i];
                    top_players[i] = top_players[j];
                    top_players[j] = temp;
                }
            }
        }

        level.game_info["top_players"].firstplace = top_players.size > 0 ? top_players[0] : undefined;
        level.game_info["top_players"].secondplace = top_players.size > 1 ? top_players[1] : undefined;
        level.game_info["top_players"].thirdplace = top_players.size > 2 ? top_players[2] : undefined;

        wait .1;
    }
}


visible_on_player_lives(num, player) {
    player endon("disconnect");

    while(isdefined(self)) {
        if(player.lives >= num)
            self.alpha = 1;
        else
            self.alpha = 0;

        wait .05;
    }
}

visible_on_clip_ammo(num, player) {
    player endon("disconnect");

    while(isdefined(self)) {
        ammo_clip = player getweaponammoclip(level.current_weapon);
        if(ammo_clip >= num)
            self.alpha = 1;
        else
            self.alpha = 0;

        wait .05;
    }
}

get_oic_weapon() {
    weapons = [];
    weapons[weapons.size] = "iw5_1911_mp";
    weapons[weapons.size] = "iw5_1911_mp";

    return weapons[randomintrange(0, weapons.size)];
}

Callback_PlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration ) {
    if(isdefined(attacker)) {
        if(attacker getweaponammoclip(level.current_weapon) < 3) {
            attacker setweaponammoclip(level.current_weapon, attacker getweaponammoclip(level.current_weapon) + 1);
            attacker playLocalSound( "scavenger_pack_pickup" );
        }
    }

    self.lives--;

	maps\mp\gametypes\_damage::PlayerKilled_internal( eInflictor, attacker, self, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, false );
}

Callback_PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime ) {
    if(isdefined(eattacker)) {
        if(isdefined(eattacker.name))
            iDamage = int(1000);
    }

	maps\mp\gametypes\_damage::Callback_PlayerDamage_internal( eInflictor, eAttacker, self, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
}

class_choice() {
	return false;
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

loadoutAllPerks_edit( loadoutEquipment, loadoutPerk1, loadoutPerk2, loadoutPerk3, loadoutPrimaryBuff, loadoutSecondaryBuff ) {
}


ShowWinners(struct) {
	self.victoryhud = newclienthudelem(self);
    self.victoryhud.x = 320;
    self.victoryhud.y = 200;
    self.victoryhud.alignx = "center";
    self.victoryhud.horzalign = "fullscreen";
    self.victoryhud.vertalign = "fullscreen";
    self.victoryhud.alpha = 1;
    self.victoryhud.sort = 2;
    self.victoryhud.color = (1,1,1);
    self.victoryhud.archived = false;
    self.victoryhud.fontscale = 5;
    self.victoryhud.font = "bigfixed";
	self.victoryhud.hidewheninmenu = true;
	self.victoryhud.hidewheninkillcam = true;
	self.victoryhud settext("VICTORY");
	self.victoryhud ChangeFontScaleOverTime(0.15);
	self.victoryhud.fontscale = 1.7;

	self.victorybg = newclienthudelem(self);
	self.victorybg.horzalign = "fullscreen";
   	self.victorybg.alignx = "center";
    self.victorybg.vertalign = "fullscreen";
    self.victorybg.foreground = false;
    self.victorybg.hidewheninkillcam = false;
    self.victorybg.hidewhendead = false;
    self.victorybg.archived = false;
    self.victorybg.sort = 1;
    self.victorybg.alpha = 1;
    self.victorybg.color = (0, 0, 0);
    self.victorybg.x = 320;
    self.victorybg.y = 202;
    self.victorybg setshader("line_horizontal", 1, 40);
	self.victorybg scaleovertime(0.2, 450, 40);

	wait 0.5;

	self.endreason = newclienthudelem(self);
    self.endreason.x = 320;
    self.endreason.y = 242;
    self.endreason.alignx = "center";
    self.endreason.horzalign = "fullscreen";
    self.endreason.vertalign = "fullscreen";
    self.endreason.sort = 2;
    self.endreason.color = (1,1,1);
    self.endreason.archived = false;
    self.endreason.fontscale = 1.3;
    self.endreason.font = "default";
	self.endreason.hidewheninmenu = true;
	self.endreason.hidewheninkillcam = true;
	self.endreason settext("Scorelimit Reached");
	self.endreason fadeovertime(0.2);
	self.endreason.alpha = 1;

	self.rank1line = newclienthudelem(self);
	self.rank1line.horzalign = "fullscreen";
   	self.rank1line.alignx = "center";
    self.rank1line.vertalign = "fullscreen";
    self.rank1line.foreground = false;
    self.rank1line.hidewheninkillcam = false;
    self.rank1line.hidewhendead = false;
    self.rank1line.archived = false;
    self.rank1line.sort = 1;
    self.rank1line.alpha = 1;
    self.rank1line.color = (1, 0.827, 0);
    self.rank1line.x = 200;
    self.rank1line.y = 275;
    self.rank1line setshader("white", 1, 20);

    self.rank2line = newclienthudelem(self);
	self.rank2line.horzalign = "fullscreen";
   	self.rank2line.alignx = "center";
    self.rank2line.vertalign = "fullscreen";
    self.rank2line.foreground = false;
    self.rank2line.hidewheninkillcam = false;
    self.rank2line.hidewhendead = false;
    self.rank2line.archived = false;
    self.rank2line.sort = 1;
    self.rank2line.alpha = 1;
    self.rank2line.color = (0.753, 0.753, 0.753);
    self.rank2line.x = 200;
    self.rank2line.y = 300;
    self.rank2line setshader("white", 1, 20);

    self.rank3line = newclienthudelem(self);
	self.rank3line.horzalign = "fullscreen";
   	self.rank3line.alignx = "center";
    self.rank3line.vertalign = "fullscreen";
    self.rank3line.foreground = false;
    self.rank3line.hidewheninkillcam = false;
    self.rank3line.hidewhendead = false;
    self.rank3line.archived = false;
    self.rank3line.sort = 1;
    self.rank3line.alpha = 1;
    self.rank3line.color = (0.745, 0.537, 0.439);
    self.rank3line.x = 200;
    self.rank3line.y = 325;
    self.rank3line setshader("white", 1, 20);
    self.backgroundsend = [];
    for(i = 0;i < 3;i++) {
    	self.backgroundsend[i] = newclienthudelem(self);
		self.backgroundsend[i].horzalign = "fullscreen";
   		self.backgroundsend[i].alignx = "left";
    	self.backgroundsend[i].vertalign = "fullscreen";
    	self.backgroundsend[i].foreground = false;
    	self.backgroundsend[i].hidewheninkillcam = false;
    	self.backgroundsend[i].hidewhendead = false;
    	self.backgroundsend[i].archived = false;
    	self.backgroundsend[i].sort = 1;
   	 	self.backgroundsend[i].alpha = 0.4;
   	 	self.backgroundsend[i].color = (0, 0, 0);
    	self.backgroundsend[i].x = 200;
    	self.backgroundsend[i].y = 275 + (i * 25);
    	self.backgroundsend[i] setshader("black", 240, 20);
    }

    self.rank1text = newclienthudelem(self);
    self.rank1text.x = 210;
    self.rank1text.y = 277;
    self.rank1text.alignx = "left";
    self.rank1text.aligny = "top";
    self.rank1text.horzalign = "fullscreen";
    self.rank1text.vertalign = "fullscreen";
    self.rank1text.sort = 2;
    self.rank1text.color = (1, 0.827, 0);
    self.rank1text.archived = false;
    self.rank1text.fontscale = 1.2;
    self.rank1text.font = "default";
	self.rank1text.hidewheninmenu = true;
	self.rank1text.hidewheninkillcam = true;
	self.rank1text settext("1st");
	self.rank1text.alpha = 1;

	self.rank2text = newclienthudelem(self);
    self.rank2text.x = 210;
    self.rank2text.y = 302;
    self.rank2text.alignx = "left";
    self.rank2text.aligny = "top";
    self.rank2text.horzalign = "fullscreen";
    self.rank2text.vertalign = "fullscreen";
    self.rank2text.sort = 2;
    self.rank2text.color = (0.753, 0.753, 0.753);
    self.rank2text.archived = false;
    self.rank2text.fontscale = 1.2;
    self.rank2text.font = "default";
	self.rank2text.hidewheninmenu = true;
	self.rank2text.hidewheninkillcam = true;
	self.rank2text settext("2nd");
	self.rank2text.alpha = 1;

	self.rank3text = newclienthudelem(self);
    self.rank3text.x = 210;
    self.rank3text.y = 327;
    self.rank3text.alignx = "left";
    self.rank3text.aligny = "top";
    self.rank3text.horzalign = "fullscreen";
    self.rank3text.vertalign = "fullscreen";
    self.rank3text.sort = 2;
    self.rank3text.color = (0.745, 0.537, 0.439);
    self.rank3text.archived = false;
    self.rank3text.fontscale = 1.2;
    self.rank3text.font = "default";
	self.rank3text.hidewheninmenu = true;
	self.rank3text.hidewheninkillcam = true;
	self.rank3text settext("3rd");
	self.rank3text.alpha = 1;

	self.rank1name = newclienthudelem(self);
    self.rank1name.x = 260;
    self.rank1name.y = 277;
    self.rank1name.alignx = "left";
    self.rank1name.aligny = "top";
    self.rank1name.horzalign = "fullscreen";
    self.rank1name.vertalign = "fullscreen";
    self.rank1name.sort = 2;
    self.rank1name.color = (1,1,1);
    self.rank1name.archived = false;
    self.rank1name.fontscale = 1.2;
    self.rank1name.font = "default";
	self.rank1name.hidewheninmenu = true;
	self.rank1name.hidewheninkillcam = true;
	self.rank1name settext(level.game_info["top_players"].firstplace.name);
	self.rank1name.alpha = 1;

	self.rank2name = newclienthudelem(self);
    self.rank2name.x = 260;
    self.rank2name.y = 302;
    self.rank2name.alignx = "left";
    self.rank2name.aligny = "top";
    self.rank2name.horzalign = "fullscreen";
    self.rank2name.vertalign = "fullscreen";
    self.rank2name.sort = 2;
    self.rank2name.color = (1,1,1);
    self.rank2name.archived = false;
    self.rank2name.fontscale = 1.2;
    self.rank2name.font = "default";
	self.rank2name.hidewheninmenu = true;
	self.rank2name.hidewheninkillcam = true;
	self.rank2name settext(level.game_info["top_players"].secondplace.name);
	self.rank2name.alpha = 1;

	self.rank3name = newclienthudelem(self);
    self.rank3name.x = 260;
    self.rank3name.y = 327;
    self.rank3name.alignx = "left";
    self.rank3name.aligny = "top";
    self.rank3name.horzalign = "fullscreen";
    self.rank3name.vertalign = "fullscreen";
    self.rank3name.sort = 2;
    self.rank3name.color = (1,1,1);
    self.rank3name.archived = false;
    self.rank3name.fontscale = 1.2;
    self.rank3name.font = "default";
	self.rank3name.hidewheninmenu = true;
	self.rank3name.hidewheninkillcam = true;
	self.rank3name settext(level.game_info["top_players"].thirdplace.name);
	self.rank3name.alpha = 1;

	self.rank1score = newclienthudelem(self);
    self.rank1score.x = 430;
    self.rank1score.y = 277;
    self.rank1score.alignx = "right";
    self.rank1score.aligny = "top";
    self.rank1score.horzalign = "fullscreen";
    self.rank1score.vertalign = "fullscreen";
    self.rank1score.sort = 2;
    self.rank1score.color = (1,1,1);
    self.rank1score.archived = false;
    self.rank1score.fontscale = 1.2;
    self.rank1score.font = "default";
	self.rank1score.hidewheninmenu = true;
	self.rank1score.hidewheninkillcam = true;
	self.rank1score setvalue(level.game_info["top_players"].firstplace.score);
	self.rank1score.alpha = 1;

	self.rank2score = newclienthudelem(self);
    self.rank2score.x = 430;
    self.rank2score.y = 302;
    self.rank2score.alignx = "right";
    self.rank2score.aligny = "top";
    self.rank2score.horzalign = "fullscreen";
    self.rank2score.vertalign = "fullscreen";
    self.rank2score.sort = 2;
    self.rank2score.color = (1,1,1);
    self.rank2score.archived = false;
    self.rank2score.fontscale = 1.2;
    self.rank2score.font = "default";
	self.rank2score.hidewheninmenu = true;
	self.rank2score.hidewheninkillcam = true;
	self.rank2score setvalue(level.game_info["top_players"].secondplace.score);
	self.rank2score.alpha = 1;

	self.rank3score = newclienthudelem(self);
    self.rank3score.x = 430;
    self.rank3score.y = 327;
    self.rank3score.alignx = "right";
    self.rank3score.aligny = "top";
    self.rank3score.horzalign = "fullscreen";
    self.rank3score.vertalign = "fullscreen";
    self.rank3score.sort = 2;
    self.rank3score.color = (1,1,1);
    self.rank3score.archived = false;
    self.rank3score.fontscale = 1.2;
    self.rank3score.font = "default";
	self.rank3score.hidewheninmenu = true;
	self.rank3score.hidewheninkillcam = true;
	self.rank3score setvalue(level.game_info["top_players"].thirdplace.score);
	self.rank3score.alpha = 1;

	self.matchbonus = newclienthudelem(self);
    self.matchbonus.x = 320;
    self.matchbonus.y = 380;
    self.matchbonus.alignx = "center";
    self.matchbonus.horzalign = "fullscreen";
    self.matchbonus.vertalign = "fullscreen";
    self.matchbonus.sort = 2;
    self.matchbonus.color = (1,1,1);
    self.matchbonus.alpha = 0;
    self.matchbonus.archived = false;
    self.matchbonus.fontscale = 1.5;
    self.matchbonus.font = "default";
	self.matchbonus.hidewheninmenu = true;
	self.matchbonus.hidewheninkillcam = true;
	self.matchbonus settext("Match Bonus");
	self.matchbonus fadeovertime(0.2);
	self.matchbonus.alpha = 1;

	self.matchbonusnum = newclienthudelem(self);
    self.matchbonusnum.x = 320;
    self.matchbonusnum.y = 400;
    self.matchbonusnum.alignx = "center";
    self.matchbonusnum.horzalign = "fullscreen";
    self.matchbonusnum.vertalign = "fullscreen";
    self.matchbonusnum.sort = 2;
    self.matchbonusnum.alpha = 0;
    self.matchbonusnum.color = (1, 1, 1);
    self.matchbonusnum.archived = false;
    self.matchbonusnum.fontscale = 1.5;
    self.matchbonusnum.font = "default";
	self.matchbonusnum.hidewheninmenu = true;
	self.matchbonusnum.hidewheninkillcam = true;
	self.matchbonusnum.label = &"^3&&1 ^7XP";
	self.matchbonusnum setvalue(5703);
	self.matchbonusnum fadeovertime(0.35);
	self.matchbonusnum.alpha = 1;

	level waittill("start_killcam");

	self.rank3score destroy();
	self.rank2score destroy();
	self.rank1score destroy();
	self.rank3name destroy();
	self.rank2name destroy();
	self.rank1name destroy();
	self.rank3text destroy();
	self.rank2text destroy();
	self.rank1text destroy();
	self.rank3line destroy();
	self.rank2line destroy();
	self.rank1line destroy();
	self.matchbonus destroy();
	self.matchbonusnum destroy();
	foreach(h in self.backgroundsend)
		h destroy();
	self.victorybg destroy();
	self.endreason destroy();
	self.victoryhud destroy();
}

onMenuResponse_edit() {
	self endon("disconnect");

	for(;;) {
		self waittill("menuresponse", menu, response);

		if(response == "back") {
			self closepopupMenu();
			self closeInGameMenu();

			if(isOptionsMenu(menu)) {
				if( self.pers["team"] == "allies" )
					self openpopupMenu( game["menu_class_allies"] );
				if( self.pers["team"] == "axis" )
					self openpopupMenu( game["menu_class_axis"] );
			}
			continue;
		}
	}
}

isOptionsMenu( menu ) {
	if ( menu == game["menu_changeclass"] )
		return true;

	if ( menu == game["menu_team"] )
		return true;

	if ( menu == game["menu_controls"] )
		return true;

	if ( isSubStr( menu, "pc_options" ) )
		return true;

	return false;
}