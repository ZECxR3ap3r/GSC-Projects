#include codescripts/struct;
#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud;
#include maps/mp/gametypes_zm/_hud_util;

main() 
{
    if(getDvar("first_gamemode") != "1" ) 
	{
        setDvar("gamemode", "none");
        setDvar("first_gamemode", 1);
    }
}

init() 
{
	precacheshader("zombies_rank_5_ded");
	precacheshader("white");
	precacheshader("gradient_fadein");
	precacheshader("gradient_center");
	precacheshader("menu_mp_star_rating_empty");
	precacheshader("menu_mp_star_rating");
	precacheshader("menu_select_highlight");
	precacheshader("ui_arrow_right");
	precachemodel("p6_zm_tunnel_pillar_1");

	level thread maps/mp/zombies/_zm_audio::setupmusicstate( "eggy", "mus_zmb_secret_song", 1, 0, undefined, "SILENCE" );
	level.sndgameovermusicoverride = "eggy";

	level.result = 0;
	level.cursor_spacing = 20;
	level.Verified = []; 
	level.mapselectedvote = [];
	level._supress_survived_screen = 0;
	level.custom_end_screen = ::custom_end_screen;
	
	if(level.script == "zm_prison")
		level thread PrisonIntermission();
	
    level.mapselectedvote[0] = 0;
    level.mapselectedvote[1] = 0;
    level.mapselectedvote[2] = 0;
    level.mapselectedvote[3] = 0;
    level.mapselectedvote[4] = 0;
    level.mapselectedvote[5] = 0;
    level.mapselectedvote[6] = 0;
    level.mapselectedvote[7] = 0;
	level.mapselectedvote[8] = 0;
	level.mapselectedvote[9] = 0;
	level.mapselectedvote[10] = 0;
	level.mapselectedvote[11] = 0;
	level.mapselectedvote[12] = 0;
	level.mapselectedvote[13] = 0;
    setDvar("skip_map_vote", 0);
    
	level thread wait_endgame();
	
	flag_wait("initial_blackscreen_passed");
	
    level.custom_intermission = ::new_intermission;
}

PrisonIntermission() {
	level waittill("pre_end_game");
	wait .05;
	level.custom_intermission = ::new_intermission;
}

new_intermission() {
	self endon( "disconnect" );
	
	points = getstructarray( "intermission", "targetname" );
	if ( !isDefined( points ) || points.size == 0 ) {
		points = getentarray( "info_intermission", "classname" );
		if ( points.size < 1 )
			return;
	}
	org = undefined;
	while ( 1 ) {
		points = array_randomize( points );
		i = 0;
		while ( i < points.size ) {
			point = points[ i ];
			if ( !isDefined( org ) )
				self spawn( point.origin, point.angles );
			if ( isDefined( points[ i ].target ) ) {
				if ( !isDefined( org ) ) {
					org = spawn( "script_model", self.origin + vectorScale( ( 0, 0, -1 ), 60 ) );
					org setmodel( "tag_origin" );
				}
				org.origin = points[ i ].origin;
				org.angles = points[ i ].angles;
				j = 0;
				while ( j < get_players().size ) {
					player = get_players()[ j ];
					player camerasetposition( org );
					player camerasetlookat();
					player cameraactivate( 1 );
					j++;
				}
				speed = 20;
				if ( isDefined( points[ i ].speed ) )
					speed = points[ i ].speed;
				target_point = getstruct( points[ i ].target, "targetname" );
				dist = distance( points[ i ].origin, target_point.origin );
				time = dist / speed;
				q_time = time * 0.25;
				if ( q_time > 1 )
					q_time = 1;
				org moveto( target_point.origin, time, q_time, q_time );
				org rotateto( target_point.angles, time, q_time, q_time );
				wait ( time - q_time );
				wait q_time;
				i++;
				continue;
			}
			i++;
		}
	}
}

wait_endgame() {
    level waittill("end_game");
    players = get_players();
    for(i=0;i<players.size;i++) {
		if(isDefined(players[i].perkarray)) {
            for(x=0;x<players[i].perkarray.size;x++)
                players[i].perkarray[x] destroy();
        }
	}
}

custom_end_screen() {
	wait 3;
	players = get_players();
    for ( i = 0; i < level.players.size; i++ ) {
    	if (level.players[i].sessionstate == "spectator" ) {
         	level.players[i] [[level.spawnplayer]]();
         	level.players[i] EnableInvulnerability();
        }
    }
	wait 1;
    level notify("vote_start");
	
    if(players.size > 0 && getDvar("skip_map_vote") != "1") {
        for(i=0;i<players.size;i++) {
        	players[i].mapvotecounter = [];
			players[i].text_amount = 0;
            players[i] freezeControls(0);
            players[i] thread [[ level.custom_intermission ]]();
            players[i].mapvotecounter = [];
            players[i].CursorMenu = spawnStruct();
            players[i].menucolor = (0.506, 0.392, 0.855);
            players[i] thread BuildMenu();
            players[i] thread openMenu();
            players[i] thread monitorButtons();
            players[i] thread MonitorPulse();
            players[i] hide();
            players[i] EnableInvulnerability();
        }
        level thread MonitorVotes();
        level thread StartTheTimer();
        level waittill("CountVotes");
        for(i=0;i<players.size;i++) {
            players[i].countingvotes = 1;
			players[i].text_amount = 0;
			players[i] EnableInvulnerability();
        }
        SelectedMap = ConvertHighestVote(0);
        level.hint_gamemode = SelectedMap;
    
        for(i = 0;i < level.mapselectedvote.size;i++)
            level.mapselectedvote[i] = 0;
		
        for(i=0;i<players.size;i++) {
            if(isdefined(players[i].mapvotecounter)) {
                foreach(hud in players[i].mapvotecounter)
                    hud destroy();
                players[i].hasvoted = undefined;
                
                if(SelectedMap == "None" || SelectedMap == "Elevator Room" || SelectedMap == "Bus Depot" || SelectedMap == "Custom Map Beta")
                    players[i] thread submenu("Gamemodes_None", "VOTE A GAMEMODE");
                else if(SelectedMap == "Nacht Der Untoten" )
                    players[i] thread submenu("Gamemodes_Nacht", "VOTE A GAMEMODE");
                else if(SelectedMap == "Bridge" || SelectedMap == "Rooftop" || SelectedMap == "Crazy Place" )
                    players[i] thread submenu("Gamemodes_Motd", "VOTE A GAMEMODE");
                else
                    players[i] thread submenu("Gamemodes_Transit", "VOTE A GAMEMODE");
                players[i].countingvotes = undefined;
                elem = players[i].CursorMenu.MainElements["SelectionDot"];
                elem.y = -150;
				players[i] notify("NewOption");
            }
        }
		level.highest_vote = 1;
        level.highest_vote_map = undefined;
        level.submenusel = 1;
        level waittill("CountVotes");
        Gamemode = ConvertHighestVote(1);
        StartTheEnding(SelectedMap,Gamemode);
        for(i=0;i<players.size;i++) {
            players[i] notify("closedMenu");
            players[i].background_vote destroy();
            foreach(hud in players[i].CursorMenu.MainElements)
                hud destroy();
        }
        level.hint_gamemode = undefined;
    }
    else {
        if(getDvar("skip_map_vote") != "1")
            setDvar("skip_map", 0);
    }
    level notify( "map_vote_done");
    wait .02;
	
    level thread maps\mp\zombies\_zm::zombie_game_over_death();
}

vector_scal( vec, scale ) {
	vec = ( vec[ 0] * scale, vec[ 1] * scale, vec[ 2] * scale );
	return vec;
}

MonitorVotes() //after vote been higher have to reset 
{
	level endon("endeverything");
	level endon("end_count");
	for(;;)
	{
		level.highest_vote = 1;
		players = get_players();
		for(x=0;x<players.size;x++)
        {
			for(i = 0;i < level.mapselectedvote.size;i++)
			{
				if(isdefined(players[x].mapvotecounter))
            	{
					players[x].mapvotecounter[i] setvalue(level.mapselectedvote[i]);
				}
				if(level.mapselectedvote[i] >= level.highest_vote)
				{
					level.highest_vote = level.mapselectedvote[i];
					level.highest_vote_map = i;
				}
			}
		}

		for(x=0;x<players.size;x++)
        {
			for(i = 0;i < level.mapselectedvote.size;i++)
			{
				if(level.highest_vote == level.mapselectedvote[i])
				{
					if(isdefined(players[x].mapvotecounter))
            		{
						players[x].mapvotecounter[i].color = (0.506, 0.392, 0.855);//Color to show which vote is winning
					}
				}
				else
				{
					if(isdefined(players[x].mapvotecounter))
            		{
						players[x].mapvotecounter[i].color = (1,1,1);//Resets Color
					}
				}
			}
		}
		level notify("count_done");
		wait 0.1;
	}
}

StartTheEnding(Map,Gamemode) {
    if(Map == "None")
        setDvar("skip_map", 0);
    else {
        setDvar("skip_map", 1);
        if(Map == "Nacht Der Untoten") {
            setDvar( "CUSTOM_MAP", 1 );
            SetDvar("sv_maprotation", "exec zm_classic_transit.cfg map zm_transit");
        }
        else if(Map == "The Diner") {
            SetDvar("sv_maprotation", "exec zm_classic_transit.cfg map zm_transit");
            setDvar( "CUSTOM_MAP", 2 );
        }
        else if(Map == "The Bus") {
            SetDvar("sv_maprotation", "exec zm_classic_transit.cfg map zm_transit");
            setDvar( "CUSTOM_MAP", 3 );
        }
        else if(Map == "Burning Forest") {
            SetDvar("sv_maprotation", "exec zm_classic_transit.cfg map zm_transit");
            setDvar( "CUSTOM_MAP", 4 );
        }
        else if(Map == "Laboratory") {
            SetDvar("sv_maprotation", "exec zm_classic_transit.cfg map zm_transit");
            setDvar( "CUSTOM_MAP", 5 );
        }
        else if(Map == "Bridge") {
            SetDvar("sv_maprotation", "exec zm_classic_prison.cfg map zm_prison");
            setDvar( "CUSTOM_MAP", 6 );
        }
        else if(Map == "Rooftop") {
            SetDvar("sv_maprotation", "exec zm_classic_prison.cfg map zm_prison");
            setDvar( "CUSTOM_MAP", 7 );
        }
        else if(Map == "Town") {
            SetDvar("sv_maprotation", "exec zm_standard_town.cfg map zm_transit");
            setDvar( "CUSTOM_MAP", 8 );
        }
		else if(Map == "Crazy Place") {
            SetDvar("sv_maprotation", "exec zm_classic_tomb.cfg map zm_tomb");
            setDvar( "CUSTOM_MAP", 9 );
        }
		else if(Map == "Witch's House") {
            SetDvar("sv_maprotation", "exec zm_classic_processing.cfg map zm_buried");
            setDvar( "CUSTOM_MAP", 10 );
        }
		else if(Map == "Buried Start Room") {
            SetDvar("sv_maprotation", "exec zm_classic_processing.cfg map zm_buried");
            setDvar( "CUSTOM_MAP", 11 );
        }
        else if(Map == "Elevator Room") {
            SetDvar("sv_maprotation", "exec zm_classic_rooftop.cfg map zm_highrise");
            setDvar( "CUSTOM_MAP", 12 );
        }
		else if(Map == "Bus Depot") {
            SetDvar("sv_maprotation", "exec zm_standard_transit.cfg map zm_transit");
            setDvar( "CUSTOM_MAP", 13 );
        }
		else if(Map == "Custom Map Beta") 
		{
            SetDvar("sv_maprotation", "exec zm_standard_town.cfg map zm_transit");
            setDvar( "CUSTOM_MAP", 14 );
        }
    }
    if(Gamemode == "None")
		setDvar( "Gamemode", "none" );
	else if(Gamemode == "Standard")
		setDvar( "Gamemode", 0 );
	else if(Gamemode == "Hardcore")
		setDvar( "Gamemode", 1 );
	else if(Gamemode == "Cranked")
		setDvar( "Gamemode", 2 );
	else if(Gamemode == "Gun Game")
		setDvar( "Gamemode", 3 );
	else if(Gamemode == "Chaos")
		setDvar( "Gamemode", 4 );
	else if(Gamemode == "Legacy")
		setDvar( "Gamemode", 5 );
	
	foreach(player in level.players) {
		foreach(element in player.CursorMenu.OptionElements)
	  		element destroy();
		foreach(elementa in player.eMenu["OPT"])
	    	elementa destroy();
		foreach(elementb in player.mapvotecounter)
	    	elementb destroy();
	}
}

ConvertHighestVote(mode) {
	if(mode == 0) {
		if(!isdefined(level.highest_vote_map))
			return "None";
		else if(level.highest_vote_map == 0)
			return "Nacht Der Untoten";
		else if(level.highest_vote_map == 1)
			return "The Diner";
		else if(level.highest_vote_map == 2)
			return "The Bus";
		else if(level.highest_vote_map == 3)
			return "Burning Forest";
		else if(level.highest_vote_map == 4)
			return "Laboratory";
		else if(level.highest_vote_map == 5)
			return "Bridge";
		else if(level.highest_vote_map == 6)
			return "Rooftop";
		else if(level.highest_vote_map == 7)
			return "Town";
		else if(level.highest_vote_map == 8)
			return "Crazy Place";
		else if(level.highest_vote_map == 9)
			return "Witch's House";
		else if(level.highest_vote_map == 10)
			return "Buried Start Room";
		else if(level.highest_vote_map == 11)
			return "Elevator Room";
		else if(level.highest_vote_map == 12)
			return "Bus Depot";
		else if(level.highest_vote_map == 13)
			return "Custom Map Beta";
	}
	else {
        if(!isdefined(level.highest_vote_map))
			return "None";
		else if(level.hint_gamemode == "None" || level.hint_gamemode == "Elevator Room" || level.hint_gamemode == "Bus Depot" || level.hint_gamemode == "Custom Map Beta") {
            if(level.highest_vote_map == 0)
                return "Standard";
        }
        else if(level.hint_gamemode == "Nacht Der Untoten") {
            if(level.highest_vote_map == 0)
                return "Standard";
            if(level.highest_vote_map == 1)
                return "Gun Game";
        }
        else if(level.hint_gamemode == "Bridge" || level.hint_gamemode == "Rooftop" || level.hint_gamemode == "Crazy Place" ) {
            if(level.highest_vote_map == 0)
                return "Standard";
            if(level.highest_vote_map == 1)
                return "Cranked";
            if(level.highest_vote_map == 2)
                return "Chaos";
			if(level.highest_vote_map == 3)
                return "Gun Game";
        }
        else {
            if(level.highest_vote_map == 0)
                return "Standard";
            if(level.highest_vote_map == 1)
                return "Cranked";
            if(level.highest_vote_map == 2)
			    return "Gun Game";
            if(level.highest_vote_map == 3)
                return "Chaos";
        }
    }
}

setvoteing(map) {
	if(!isdefined(self.hasvoted)) {
		self.hasvoted = map;
		level.mapselectedvote[map]++;
	}
	else {
		level.mapselectedvote[self.hasvoted]--;
		self.hasvoted = map;
		level.mapselectedvote[map]++;
	}
}

//¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

AddOptions()
{
	self endon("disconnect");
	self NewTopLevelMenu("main", undefined, "ZOMBIES", "Verified");
	self NewOption("main", "NACHT DER UNTOTEN", level.mapselectedvote["Nacht"], "loadscreen_zm_prototype", "Fight Endless Hordes of Zombies in Unknown Love & ZECxR3ap3r \nNacht der Untoten Remake with Alternative Ammo Types \nand 4 Original + 2 Custom Perks", ::setvoteing, 0);
	self NewOption("main", "THE DINER", level.mapselectedvote["Diner"], "loadscreen_zm_transit_dr_zcleansed_diner", "Fight Endless Hordes of Zombies on The Diner Survival Map with 5 original perks and shootable easter egg \nCreated by Unknown Love", ::setvoteing, 1);
	self NewOption("main", "THE BUS", level.mapselectedvote["Bus"], "loadscreen_zm_transit_zclassic_transit", "The Bus survival with 5 original and 9 custom perks \nCreated by Unknown Love & ZECxR3ap3r", ::setvoteing, 2);
	self NewOption("main", "BURNING FOREST", level.mapselectedvote["Forest"], "loadscreen_zm_transit_zstandard_transit", "The Burning Forest survival with 5 original + 9 custom perks and alternative ammo types \nCreated by Unknown Love", ::setvoteing, 3);
	self NewOption("main", "LABORATORY", level.mapselectedvote["Lab"], "loadscreen_zm_transit_zstandard_town", "The Laboratory One Window Challenge with 4 original perks \nCreated by Unknown Love", ::setvoteing, 4);
	self NewOption("main", "BRIDGE", level.mapselectedvote["Bridge"], "loadscreen_zm_prison_zclassic_prison", "The Bridge survival with 5 original and 7 custom perks \nCreated by Unknown Love", ::setvoteing, 5);
	self NewOption("main", "ROOFTOP", level.mapselectedvote["Roof"], "loadscreen_zm_prison_zgrief_cellblock", "The Rooftop survival with 5 original and 7 custom perks \nCreated by Unknown Love", ::setvoteing, 6);
	self NewOption("main", "TOWN", level.mapselectedvote["Town"], "loadscreen_zm_transit_zstandard_town", "The Town survival with dogs, shootable easter egg, 5 original + 11 custom perks and alternative ammo types \nCreated by Unknown Love", ::setvoteing, 7);
	self NewOption("main", "CRAZY PLACE", level.mapselectedvote["Crazy"], "loadscreen_zm_tomb_zclassic_tomb", "The Crazy Place with 9 original perks and some fun challenges \nCreated by Unknown Love", ::setvoteing, 8);
	self NewOption("main", "WITCH'S HOUSE", level.mapselectedvote["Witch"], "loadscreen_zm_buried_zgrief_street", "The Witch's House with 7 original perks and alternative ammo types \nCreated by Unknown Love", ::setvoteing, 9);
	self NewOption("main", "BURIED START ROOM", level.mapselectedvote["StartRoom"], "loadscreen_zm_buried_zgrief_street", "The Buried start room with 7 original perks \nCreated by Unknown Love", ::setvoteing, 10);
	self NewOption("main", "ELEVATOR ROOM", level.mapselectedvote["ElevatorRoom"], "loadscreen_zm_buried_zgrief_street", "(BETA) Highrise Elevator Room Challenge \nCreated By Unknown Love", ::setvoteing, 11);
	self NewOption("main", "BUS DEPOT", level.mapselectedvote["BusDepot"], "loadscreen_zm_transit_zstandard_transit", "(BETA) Bus Depot survival with dogs \nCreated By Unknown Love", ::setvoteing, 12);
	self NewOption("main", "CUSTOM MAP BETA [ ^8NEW^7 ]", level.mapselectedvote["BusDepot"], "loadscreen_zm_transit_zstandard_transit", "(BETA) Bus Depot survival with dogs \nCreated By Unknown Love", ::setvoteing, 13);

	self NewSubMenu("Gamemodes_All", "", "", "Verified");
	self NewOption("Gamemodes_All", "STANDARD", level.mapselectedvote["Normal"], "menu_mp_lobby_icon_customgamemode", "Normal Round Based", ::setvoteing, 0);
	self NewOption("Gamemodes_All", "HARDCORE", level.mapselectedvote["Hardcore"], "menu_mp_lobby_icon_customgamemode", "Fight Endless Hordes of Zombies with a Harder Difficulty", ::setvoteing, 1);
	self NewOption("Gamemodes_All", "CRANKED", level.mapselectedvote["Cranked"], "menu_mp_lobby_icon_customgamemode", "All players have to fill their Cranked Timer by chaining zombie kills together \nin a frantic survival while the allotted time between kills becomes lessened \nas the rounds become higher", ::setvoteing, 2);
	self NewOption("Gamemodes_All", "GUNGAME", level.mapselectedvote["Gun"], "menu_mp_lobby_icon_customgamemode", "Player get random gun every 2000 points and first who finishes wins", ::setvoteing, 3);
	self NewOption("Gamemodes_All", "CHAOS", level.mapselectedvote["Chaos"], "menu_mp_lobby_icon_customgamemode", "Want some challenge? This gamemode does random effect after every 10 seconds", ::setvoteing, 4);

	self NewSubMenu("Gamemodes_None", "", "", "Verified");
	self NewOption("Gamemodes_None", "STANDARD", level.mapselectedvote["Normal"], "menu_mp_lobby_icon_customgamemode", "Normal Round Based", ::setvoteing, 0);

    self NewSubMenu("Gamemodes_For_All", "", "", "Verified");
	self NewOption("Gamemodes_For_All", "STANDARD", level.mapselectedvote["Normal"], "menu_mp_lobby_icon_customgamemode", "Normal Round Based", ::setvoteing, 0);
	self NewOption("Gamemodes_For_All", "CHAOS", level.mapselectedvote["Chaos"], "menu_mp_lobby_icon_customgamemode", "Want some challenge? This gamemode does random effect after every 10 seconds", ::setvoteing, 1);

    self NewSubMenu("Gamemodes_Nacht", "", "", "Verified");
	self NewOption("Gamemodes_Nacht", "STANDARD", level.mapselectedvote["Normal"], "menu_mp_lobby_icon_customgamemode", "Normal Round Based", ::setvoteing, 0);
	self NewOption("Gamemodes_Nacht", "GUNGAME", level.mapselectedvote["Gun"], "menu_mp_lobby_icon_customgamemode", "Player get random gun every 2000 points and first who finishes wins", ::setvoteing, 1);
	
    self NewSubMenu("Gamemodes_Transit", "", "", "Verified");
	self NewOption("Gamemodes_Transit", "STANDARD", level.mapselectedvote["Normal"], "menu_mp_lobby_icon_customgamemode", "Normal Round Based", ::setvoteing, 0);
	self NewOption("Gamemodes_Transit", "CRANKED", level.mapselectedvote["Cranked"], "menu_mp_lobby_icon_customgamemode", "All players have to fill their Cranked Timer by chaining zombie kills together \nin a frantic survival while the allotted time between kills becomes lessened \nas the rounds become higher", ::setvoteing, 1);
	self NewOption("Gamemodes_Transit", "GUNGAME", level.mapselectedvote["Gun"], "menu_mp_lobby_icon_customgamemode", "Player get random gun every 2000 points and first who finishes wins", ::setvoteing, 2);
	self NewOption("Gamemodes_Transit", "CHAOS", level.mapselectedvote["Chaos"], "menu_mp_lobby_icon_customgamemode", "Want some challenge? This gamemode does random effect after every 10 seconds", ::setvoteing, 3);

    self NewSubMenu("Gamemodes_Motd", "", "", "Verified");
	self NewOption("Gamemodes_Motd", "STANDARD", level.mapselectedvote["Normal"], "menu_mp_lobby_icon_customgamemode", "Normal Round Based", ::setvoteing, 0);
	self NewOption("Gamemodes_Motd", "CRANKED", level.mapselectedvote["Cranked"], "menu_mp_lobby_icon_customgamemode", "All players have to fill their Cranked Timer by chaining zombie kills together \nin a frantic survival while the allotted time between kills becomes lessened \nas the rounds become higher", ::setvoteing, 1);
	self NewOption("Gamemodes_Motd", "CHAOS", level.mapselectedvote["Chaos"], "menu_mp_lobby_icon_customgamemode", "Want some challenge? This gamemode does random effect after every 10 seconds", ::setvoteing, 2);
	self NewOption("Gamemodes_Motd", "GUNGAME", level.mapselectedvote["Gun"], "menu_mp_lobby_icon_customgamemode", "Player get random gun every 2000 points and first who finishes wins", ::setvoteing, 3);

}

NewTopLevelMenu(Menu, prevmenu, menutitle, status)
{
	self.CursorMenu.menus[self.CursorMenu.menutotal] = Menu;
	self.CursorMenu.VerificationStatus[Menu] = status;
	self.CursorMenu.menucount[Menu] = 0;
	self.CursorMenu.subtitle[Menu] = menutitle;
	self.CursorMenu.menusubtitle[self.CursorMenu.menutotal] = menutitle;
	self.CursorMenu.previousmenu[Menu] = prevmenu;
	self.CursorMenu.menutotal++;
}

NewSubMenu(Menu, prevmenu, menutitle, status)
{
	self.CursorMenu.VerificationStatus[Menu] = status;
	self.CursorMenu.menucount[Menu] = 0;
	self.CursorMenu.subtitle[Menu] = menutitle;
	self.CursorMenu.previousmenu[Menu] = prevmenu;
}

NewOption(Menu, Text, Desc, DescShader, Desc2, Func, arg1, arg2, arg3)
{
	Num = self.CursorMenu.menucount[Menu];
	self.CursorMenu.menuopt[Menu][Num] = Text;
	self.CursorMenu.menufunc[Menu][Num] = Func;
	self.CursorMenu.menuinput[Menu][Num] = arg1;
	self.CursorMenu.menuinput1[Menu][Num] = arg2;
	self.CursorMenu.menuinput2[Menu][Num] = arg3;
	self.CursorMenu.menucount[Menu] += 1;
}

BuildMenu()
{
	self endon("disconnect");
	self.CursorMenu.InMenu = false;
	self.CursorMenu.MenuAccess = "Host";
	self.CursorMenu.menutotal = 0;
	self.CursorMenu.ival = 0;
	self.CursorMenu.LeftRightScroll = 0;
	self.CursorMenu.OptionElements = [];
	self.CursorMenu.menuopt = [];
	self.CursorMenu.menufunc = [];
	self.CursorMenu.menuinput = [];
	self.CursorMenu.menuinput1 = [];
	self.CursorMenu.menuinput2 = [];
	self.eMenu_D[ menu ] = [];
	self.CursorMenu.menus = [];
	self.CursorMenu.menucount = [];
	self.CursorMenu.subtitle = [];
	self.CursorMenu.menusubtitle = [];
	self.CursorMenu.previousmenu = [];
	self.CursorMenu.VerificationStatus = [];
	
	self AddOptions();
	self.CursorMenu.curMenu = "main";
			
	self.CursorMenu.MainElements = [];
	self.CursorMenu.MainElements["SelectionDot"] = self createText("default", 1.5, "LEFT", "CENTER", -250, -150, 20, 1, (1, 1, 1), "");
	self.CursorMenu.MainElements["MidTitle"] = self createText("objective", 2.6, "LEFT", "CENTER", -300, -178, 8, 1, (1, 1, 1), self.CursorMenu.menusubtitle[0]);
	self.CursorMenu.MainElements["LeftSideGradient"] = self createRectangle("LEFT", "CENTER", -450, 0, 600, 400, 1, (0,0,0), 1, "gradient");
	self.CursorMenu.MainElements["Topbar"] = self createRectangle("CENTER", "CENTER", 0, -220, 1000, 40, 10, (1,1,1), 0.9, "black");
	self.CursorMenu.MainElements["Bottombar"] = self createRectangle("CENTER", "CENTER", 0, 220, 1000, 40, 10, (1,1,1), 0.9, "black");
    self.CursorMenu.MainElements["TopbarColor"] = self createRectangle("CENTER", "CENTER", 0, -200, 1000, 1, 11, self.menucolor, 0.7, "white");
	self.CursorMenu.MainElements["BottombarColor"] = self createRectangle("CENTER", "CENTER", 0, 200, 1000, 1, 11, self.menucolor, 0.7, "white");
    self.CursorMenu.MainElements["Controls"] = self createText("objective", 1.4, "LEFT", "CENTER", -300, 220, 11, 1, (1, 1, 1), "^8[{+attack}]^7 Scroll Down      ^8[{+speed_throw}]^7 Scroll Up       ^8[{+gostand}]^7 Select");
    
    self.CursorMenu.MainElements["NewsbarTop"] = self createRectangle_user("user_right", "user_center", "CENTER", "CENTER", -380, 140, 1, 20, 11, self.menucolor, 0.7, "white");
    self.CursorMenu.MainElements["NewsbarBack"] = self createRectangle_user("user_right", "user_center", "CENTER", "CENTER", -200, 140, 400, 20, 11, (0,0,0), 0.7, "gradient_fadein");
	self.CursorMenu.MainElements["NewsText"] = self createText_user("objective", 1.2, "user_right", "user_center", "RIGHT", "CENTER", -15, 142, 12, 1, (1,1,1), "Discord Link ^8https://discord.io/UnknownsServer^7       ||       Server Owner ^8Unknown Love^7");
}

StartTheTimer() {
	timer = createserverfontstring("default" , 2.6);
    timer.x = 288;
    timer.y = 47;
    timer.alignx = "RIGHT";
    timer.aligny = "TOP";
    timer.horzalign = "FULLSCREEN";
    timer.vertalign = "FULLSCREEN";
    timer.alpha = 1;
    timer.sort = 10;
    timer.color = (0.506, 0.392, 0.855);
    timer.foreground = 1;
    timer.hidewheninmenu = 1;
    timer setTimer(20);
    wait 20;
	level waittill("count_done");
    level notify("CountVotes");
    wait 1;
    
    timer setTimer(15);
    wait 15;
    timer destroy();
	level waittill("count_done");
    level notify("CountVotes");
	level notify("end_count");
    
}

openMenu() {
	self setClientUiVisibilityFlag("hud_visible", 0);
	self.CursorMenu.MainElements["SelectionDot"].alpha = 1;
	self.CursorMenu.MainElements["Background"].alpha = 1;
	self.CursorMenu.MainElements["MidTitle"].alpha = 1;
    self disableweapons();
    setDvar("cg_crosshairAlpha", 0);
    
    self EnableInvulnerability();
    
	self.CursorMenu.InMenu = true;
	self setclientdvar("g_teamcolor_allies", "0.506 0.392 0.855 1");
    self setclientdvar("g_teamcolor_axis", "0.506 0.392 0.855 1");
   
	self thread submenu(self.CursorMenu.curMenu, self.CursorMenu.curTitle);
}

buttonPressed(button) 
{
	if(button == "[]")
		return self useButtonPressed();
	if(button == "X")
		return self jumpButtonPressed();
	if(button == "O")
		return self stanceButtonPressed();
	if(button == "DPAD_UP")
		return self actionSlotOneButtonPressed();
	if(button == "DPAD_DOWN")
		return self actionSlotTwoButtonPressed();
	if(button == "R2")
		return self attackButtonPressed();
	if(button == "L2")
		return self adsButtonPressed();
	if(button == "R3")
		return self meleeButtonPressed();
}

monitorButtons() 
{ 
	self endon("disconnect");
	self endon("closedMenu");
	votestart_y = -150;
	for(;;) {
		if(self.CursorMenu.InMenu) 
		{
			if(!isdefined(self.countingvotes)) 
			{
				if(buttonPressed("X")) 
				{
					select();
					wait 0.25;
				}
				if(buttonPressed("R2")) 
				{
					elem = self.CursorMenu.MainElements["SelectionDot"];
					elem.y += level.cursor_spacing;
					if(!isdefined(level.submenusel)) 
					{
						if(elem.y > 130)
							elem.y = -150;
					}
					else
                    {//Second Menu

						if(level.hint_gamemode == "None" || level.hint_gamemode == "WITCH'S HOUSE" )
						{
							if(elem.y > votestart_y + (level.cursor_spacing - 1))
								elem.y = votestart_y;
						}
						else if(level.hint_gamemode == "Nacht Der Untoten")
						{
							if(elem.y > votestart_y + (level.cursor_spacing * 2 - 1))
								elem.y = votestart_y;
						}
						else if(level.hint_gamemode == "Bridge" || level.hint_gamemode == "Rooftop" || level.hint_gamemode == "Crazy Place")
						{
							if(elem.y > votestart_y + (level.cursor_spacing * 4 - 1))
								elem.y = votestart_y;
						}
						else if(elem.y > votestart_y + (level.cursor_spacing * 4 - 1))
								elem.y = votestart_y;
					}
					self notify("NewOption");
					wait 0.25;
				}
				if(buttonPressed("L2")) {
					if(isads(self) == 0) {
						elem = self.CursorMenu.MainElements["SelectionDot"];
						elem.y -= level.cursor_spacing;
						if(!isdefined(level.submenusel)) {
							if(elem.y < -160)
								elem.y = 111;
						}
						else
                        {//Second Menu
							if(level.hint_gamemode == "None" || level.hint_gamemode == "Witch's House")
							{
								if(elem.y < votestart_y - 1)
									elem.y = votestart_y;
							}
							else if(level.hint_gamemode == "Nacht Der Untoten")
							{
								if(elem.y < votestart_y - 1)
									elem.y = votestart_y + (level.cursor_spacing * 2 - 1);
							}
							else if(level.hint_gamemode == "Bridge" || level.hint_gamemode == "Rooftop" || level.hint_gamemode == "Crazy Place")
							{
								if(elem.y < votestart_y - 1)
									elem.y = votestart_y + (level.cursor_spacing * 4 - 1);
							}
							else if(elem.y < votestart_y - 1)
									elem.y = votestart_y + (level.cursor_spacing * 4 - 1);
						}
						self notify("NewOption");
					}
					wait 0.25;
				}
			}
		}
		wait 0.05;
	}
}

isads( player )
{
	return player playerads() > 0.5;
}

select()
{
	cursor = self.CursorMenu.MainElements["SelectionDot"];
	menu2 = self.CursorMenu.MainElements["MidTitle"];
	for(i = 0; i < self.CursorMenu.menucount[self.CursorMenu.curMenu]; i++)
	{
		self.CursorMenu.ival = i;
		if (is_touching(self.CursorMenu.OptionElements[i], cursor)) 
		{
			self thread [[self.CursorMenu.menufunc[self.CursorMenu.curMenu][self.CursorMenu.ival]]](self.CursorMenu.menuinput[self.CursorMenu.curMenu][i], self.CursorMenu.menuinput1[self.CursorMenu.curMenu][i], self.CursorMenu.menuinput2[self.CursorMenu.curMenu][i]);
			break;
		}
	}
}

is_touching(elem, cursor)
{
	xval = elem.x;
	yval = elem.y;
	
	xtest = cursor.x - xval;
	ytest = cursor.y - yval;
	
	if ((xtest > -40 && xtest < 120) && (ytest > -10 && ytest < 10))
		return true;
	else
		return false;
}

submenu(input, title)
{
	self.CursorMenu.curMenu = input;
	self.CursorMenu.curTitle = title;
	if(level.hint_gamemode == "None")
		hint = "NOT SELECTED";
	if(level.hint_gamemode == "Witch's House" || level.hint_gamemode == "Buried Start Room")
		hint = level.hint_gamemode;
	if(input == "Gamemodes_Transit" || input == "Gamemodes_Nacht" || input == "Gamemodes_Motd" || input == "Gamemodes_For_All" || input == "Gamemodes_None")
		if(isDefined(hint))
			self.CursorMenu.MainElements["MidTitle"] setText("VOTE A GAMEMODE                   	^2NEXT MAP: 	^7" + hint);
		else
			self.CursorMenu.MainElements["MidTitle"] setText("VOTE A GAMEMODE                   	^2NEXT MAP: 	^7" + level.hint_gamemode);
	else	
		self.CursorMenu.MainElements["MidTitle"] settext("VOTE A MAP");
	
	foreach(element in self.CursorMenu.OptionElements)
	    element destroy();
	foreach(elementa in self.eMenu["OPT"])
	    elementa destroy();
	    
	self thread StoreText(input, title);
}

StoreText(input, title) {
	self endon("disconnect");
	for(i = 0; i < self.CursorMenu.menucount[input]; i++) {
    	self.CursorMenu.OptionElements[i] = self createtext("objective", 1.5, "LEFT", "CENTER", -300, -150 + (i * level.cursor_spacing), 8, 1, (1, 1, 1), self.CursorMenu.menuopt[input][i]);
    	
   	 	self.mapvotecounter[i] = self createText("objective", 1.5, "LEFT", "CENTER", -50, -150 + (i * level.cursor_spacing), 30, 1, (1, 1, 1), level.mapselectedvote[i]);
		self.mapvotecounter[i] setvalue(level.mapselectedvote[i]);
	}
}

createtext(font, fontscale, align, relative, x, y, sort, alpha, color, text)
{
	if(!isdefined(self.text_amount))
		self.text_amount = 1;
	self.text_amount++;
	textelem = createfontstring(font, fontscale);
	textelem setpoint(align, relative, x, y);
	textelem.sort = sort;
	textelem.color = color;
	textelem.alpha = alpha;
	textelem.hidewheninmenu = 1;
	if(self.text_amount > 24)
		textElem.archived = false;
	else
		textElem.archived = true;
	
	textelem settext(text);
	return textelem;
}

createText_user( font, fontscale, horzalign, vertalign, alignx, aligny, x, y, sort, alpha, color, text )
{
	if(!isdefined(self.text_amount))
		self.text_amount = 1;
	self.text_amount++;
	textElem = CreateFontString( font, fontscale );
	textElem.x = x;
    textElem.y = y;
    textElem.alignx = alignx;
    textElem.aligny = aligny;
    textElem.horzalign = horzalign;
    textElem.vertalign = vertalign;
    textElem.sort = sort;
	textElem.color = color;
	textElem.alpha = alpha;
	textElem.hideWhenInMenu = true;
	textElem.archived = false;
	textElem setText(text);
    return textElem;
}

createRectangle_user(horzalign, vertalign, align, aligny, x, y, width, height, sort, color, alpha, shader)
{
	if(!isdefined(self.text_amount))
		self.text_amount = 1;
	self.text_amount++;
	shaderElem = newClientHudElem(self);
	shaderElem.elemType = "bar";
	shaderElem.children = [];
	shaderElem.sort = sort;
	shaderElem.color = color;
	shaderElem.alpha = alpha;
	shaderElem setParent(level.uiParent);
	shaderElem setShader(shader, width, height);
	shaderElem.hideWhenInMenu = true;
    shaderElem.x = x;
    shaderElem.y = y;
    shaderElem.archived = false;
    shaderElem.alignx = align;
    shaderElem.aligny = aligny;
    shaderElem.horzalign = horzalign;
    shaderElem.vertalign = vertalign;
	shaderElem.type = "shader";
	return shaderElem;
}

createRectangle(align, relative, x, y, width, height, sort, color, alpha, shader)
{
	if(!isdefined(self.text_amount))
		self.text_amount = 1;
	self.text_amount++;
	shaderElem = newClientHudElem(self);
	shaderElem.elemType = "bar";
	shaderElem.children = [];
	shaderElem.sort = sort;
	shaderElem.color = color;
	shaderElem.alpha = alpha;
	shaderElem setParent(level.uiParent);
	shaderElem setShader(shader, width, height);
	shaderElem.hideWhenInMenu = true;
    shaderElem.archived = false;
	shaderElem setPoint(align, relative, x, y);
	shaderElem.type = "shader";
	return shaderElem;
}

MonitorPulse() {
	self endon("disconnect");
	for(;;) {
		if (self.CursorMenu.InMenu) {
			option = self.CursorMenu.OptionElements;
			cursor = self.CursorMenu.MainElements["SelectionDot"];
			input = self.CursorMenu.curMenu;
			for(i = 0;i < option.size;i++) {
				if(is_touching(option[i], cursor))
					option[i].color = self.menucolor;
				else
					option[i].color = (1,1,1);
			}
			self waittill("NewOption");
		}
	}
}
