#include codescripts/struct;
#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zombies/_zm_melee_weapon;
#include maps/mp/_zm_transit_bus;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/gametypes_zm/_globallogic;
#include maps/mp/gametypes_zm/_weapons;
#include maps/mp/zombies/_zm_powerups;
#include maps/mp/zombies/_zm_buildables;
#include maps/mp/zombies/_zm_equipment;
#include maps/mp/zombies/_zm_pers_upgrades_functions;
#include maps/mp/zombies/_zm_game_module;
#include maps/mp/zombies/_zm_score;
#include maps/mp/zombies/_zm_stats;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/zombies/_zm_weap_cymbal_monkey;
#include maps/mp/zombies/_zm_weapons;
#include maps/mp/gametypes_zm/_spawning;
#include maps/mp/zombies/_zm_spawner;
#include maps/mp/zombies/_zm;
#include maps/mp/zombies/_zm_perks;
#include maps/mp/zombies/_zm_zonemgr;
#include maps/mp/zombies/_zm_magicbox;
#include maps/mp/zombies/_zm_weap_claymore;
#include maps/mp/zombies/_zm_ai_avogadro;
#include maps/mp/zombies/_zm_audio;
#include maps/mp/zombies/_zm_power;
#include maps/mp/zombies/_zm_laststand;
#include maps/mp/zombies/_zm_devgui;
#include maps/mp/zombies/_zm_weap_jetgun;
#include maps/mp/zombies/_zm_ai_dogs;
#include maps/mp/zombies/_zm_blockers;
#include maps/mp/zombies/_zm_weap_riotshield;

main()
{
    if(getdvar( "mapname" ) == "zm_transit" && getdvar ( "g_gametype")  == "zclassic")
    {  
        register_player_damage_callback( ::playerdamagelastcheck );
    }
}

init()
{
	if(getdvar( "mapname" ) == "zm_nuked")
	{	
        register_player_damage_callback( ::playerdamagelastcheck );
        precacheshaders = array("hud_icon_sticky_grenade","specialty_doubletap_zombies","killiconheadshot","specialty_additionalprimaryweapon_zombies","menu_mp_lobby_icon_customgamemode","specialty_divetonuke_zombies","zombies_rank_1","zombies_rank_3","zombies_rank_2","zombies_rank_4","zombies_rank_5","menu_lobby_icon_facebook","menu_mp_weapons_1911","hud_icon_colt","waypoint_revive","hud_grenadeicon","damage_feedback","menu_lobby_icon_twitter","specialty_doubletap_zombies");
        foreach(shader in precacheshaders)
        {
            precacheshader(shader);
        }
        precachemodel("zombie_vending_jugg_on");
    }
    if(getdvar( "mapname" ) == "zm_transit" && getdvar ( "g_gametype")  == "zclassic")
    {  
		precachemodel("zombie_vending_tombstone");
		precacheshaders = array("specialty_quickrevive_zombies","specialty_juggernaut_zombies","hud_icon_sticky_grenade","specialty_doubletap_zombies","killiconheadshot","specialty_additionalprimaryweapon_zombies","menu_mp_lobby_icon_customgamemode","specialty_divetonuke_zombies","zombies_rank_1","zombies_rank_3","zombies_rank_2","zombies_rank_4","zombies_rank_5","menu_lobby_icon_facebook","menu_mp_weapons_1911","hud_icon_colt","waypoint_revive","hud_grenadeicon","damage_feedback","menu_lobby_icon_twitter","specialty_doubletap_zombies");
   	 	foreach(shader in precacheshaders)
   		{
        	precacheshader(shader);
    	}
    }
    setDvar( "scr_screecher_ignore_player", 1 );
    level.get_player_weapon_limit = ::custom_get_player_weapon_limit;
    level thread onPlayerConnect();
    flag_wait("initial_blackscreen_passed");
    level thread ReapersWonderfizzSettings();
    level.effect_WebFX = loadfx("misc/fx_zombie_powerup_solo_grab");
}

ReapersWonderfizzSettings()
{
	level.WunderfizzCost = 1500; //Sets The Cost of the Wunderfizz
	level.WunderfizzCustomOrigin = undefined; //If you wanna spawn the Wunderfizz at a other location
	level.WunderFizzMaxUsage = 8; //Max Usage of Wunderfizz (gets ignored if theres no other Location)
	level.WunderFizzMinUsage = 4; //Min Usage of Wunderfizz (gets ignored if theres no other Location)
	level.WunderFizzChangingTime = 20; //Seconds Until Wunderfizz is Ready
	level.WunderFizzChangingWait = 0.5; //Time until a New Perk Model is Shown
	level.WunderFizzGrabTime = 5; //Time to Grab The Perk
	level.perk_purchase_limit = 20; //Perk Limit
	//Main Stuff
	level thread WunderfizzLocations();
	level thread WunderfizzMain();
	level thread WatchForMove();
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        if(isDefined(level.player_out_of_playable_area_monitor) && level.player_out_of_playable_area_monitor)
			level.player_out_of_playable_area_monitor = 0;
		if(isDefined(level.player_too_many_weapons_monitor) && level.player_too_many_weapons_monitor)
			level.player_too_many_weapons_monitor = 0;
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
	level endon("game_ended");
	self.initial_spawn = 0;
    for(;;)
    {
        self waittill("spawned_player");
		if(self.initial_spawn == 0)
		{
			self.initial_spawn = 1;
			self.dying_wish_on_cooldown = 0;
    		self.perk_reminder = 0;
   			self.perk_count = 0;
    		self.num_perks = 0;
    		self thread removeperkshader();
    		self thread perkboughtcheck();
			self.perkarray = [];
			flag_wait("initial_blackscreen_passed");
			wait 2;
			self.score = 1000000;
		}
    }
}

WatchForMove()
{
	level endon("game_ended");
	while(1)
	{
		level waittill("spawn_new_fizz");
		level thread WunderfizzLocations();
		wait 1;
		level thread WunderfizzMain();
	}
}

vector_scal( vec, scale )
{
	vec = ( vec[ 0] * scale, vec[ 1] * scale, vec[ 2] * scale );
	return vec;
}

WunderfizzMain()
{
	level endon("spawn_new_fizz");
	wunderfizz_uses = 0;
	wunderfizz_moves_at = randomintrange(level.WunderFizzMinUsage, level.WunderFizzMaxUsage);
	level.wunderfizzinuse = 0;
	level.WunderfizzModel = spawn( "script_model", level.WunderfizzFirstOrigin);
	level.WunderfizzModel.angles = level.WunderfizzFirstAngles;
	level.WunderfizzModel setmodel("zombie_vending_tombstone");
	level.WunderfizzTrigger = spawn( "trigger_radius", level.WunderfizzFirstOrigin, 1, 50, 50 );
    level.WunderfizzTrigger SetCursorHint( "HINT_NOICON" );
    level.WunderfizzTrigger SetHintString("Hold ^3&&1^7 to buy a random Perk-a-Cola [Cost: ^3" + level.WunderfizzCost + "^7]");
    FX_TAG = spawn( "script_model", level.WunderfizzFirstOrigin);
	FX_TAG setmodel("tag_origin");
	FX_TAG.angles = (270,0,0);
    realfx = playfxontag( level._effect[ "lght_marker" ], FX_TAG, "tag_origin" );
    Collision = spawn( "script_model", level.WunderfizzFirstOrigin);
	Collision.angles = level.WunderfizzFirstAngles;
	Collision setmodel("zm_collision_perks1");
	while(1)
	{
		level.WunderfizzTrigger waittill("trigger", who);
		whichperks = who thread IncludedPerks();
		if(who UseButtonPressed() && who.score >= cost && who.isDrinkingPerk == 0)
		{
			if(who.num_perks < level.perk_purchase_limit)
			{
				if(who.num_perks < whichperks.size)
				{
					if(level.wunderfizzinuse == 0)
					{
						wunderfizz_uses += 1;
						level.wunderfizzinuse = 1;
						level.WunderfizzTrigger setinvisibletoall();
						who playsound("zmb_cha_ching");
						who.score -= level.WunderfizzCost;
						level.WunderfizzModel moveto(level.WunderfizzModel.origin + (0,0,70), level.WunderFizzChangingTime);
						for(i = 0;i < level.WunderFizzChangingTime;i++)
						{
							perk = random(whichperks);
							newmodel = getPerkModel(perk);
							level.WunderfizzModel setmodel(newmodel);
							playfx(level.effect_WebFX, level.WunderfizzModel.origin + (0,0,40));
							wait level.WunderFizzChangingWait / 2;
						}
						level.WunderfizzModel moveto(level.WunderfizzFirstOrigin, 0.1);
						if(wunderfizz_moves_at == wunderfizz_uses)
						{
							level.lastwunderfizzorigin = level.WunderfizzFirstOrigin;
							level.WunderfizzTrigger delete();
							level.WunderfizzModel moveto(level.WunderfizzModel.origin + (0,0,400), level.WunderFizzChangingTime);
							playfx(level._effect[ "poltergeist" ], level.WunderfizzFirstOrigin );
							Collision delete();
							FX_TAG delete();
							realfx delete();
							wait 1;
							level.WunderfizzModel delete();
							wait 10;
							level notify("spawn_new_fizz");
						}
						wait 0.1;
						playfx(level._effect[ "poltergeist" ], level.WunderfizzFirstOrigin );
						level.WunderfizzTrigger SetHintString("Hold ^3&&1^7 to Drink " + getPerkName(perk));
						fxlight = getPerkLight(perk);
						fx = SpawnFX(level._effect[fxlight], level.WunderfizzFirstOrigin, AnglesToForward(level.WunderfizzModel.angles),AnglesToUp(level.WunderfizzModel.angles));
						TriggerFX(fx);
						level.WunderfizzTrigger setvisibletoplayer( who );
						who thread GrabPerk(perk);
						level.WunderfizzModel thread GrabPerkTimer();
						level waittill_any("UserGrabbedPerk", "ResetWunderfizz");
						fx delete();
						level.WunderfizzModel setmodel("zombie_vending_tombstone");
						level.WunderfizzTrigger setinvisibletoall();
						wait 1.5;
						level.WunderfizzTrigger SetHintString("Hold ^3&&1^7 to buy a random Perk-a-Cola [Cost: ^3" + level.WunderfizzCost + "^7]");
						level.wunderfizzinuse = 0;
						level.WunderfizzTrigger setvisibletoall();
					}
				}
				else
				{
					level.WunderfizzTrigger SetHintString("You already Got All Perks!!");
				}
			}	
			else
			{
				level.WunderfizzTrigger SetHintString("You Cant Hold More then ^3" + level.perk_purchase_limit + "^7 Perks!");
			}
		}
		else
		{
			who maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "no_money_box", undefined, 0 );
		}
	}
}

getPerkLight(perk)
{
	if(level.script == "zm_transit")
	{
		return "tombstone_light";
	}
	if(level.script == "zm_prison")
	{
		return "electriccherry";
	}
	if(level.script == "zm_nuked")
	{
		return "sleight_light";
	}
	if(level.script == "zm_buried")
	{
		return "vulture_light";
	}
	if(level.script == "zm_highrise")
	{
		return "additionalprimaryweapon_light";
	}
}

getPerkName(perk)
{
	if(perk == "specialty_armorvest")
		return "Juggernog";
	if(perk == "specialty_rof")
		return "Double Tap II";
	if(perk == "specialty_longersprint")
		return "Stamin-Up";
	if(perk == "specialty_fastreload")
		return "Speed Cola";
	if(perk == "specialty_additionalprimaryweapon")
		return "Mule Kick";
	if(perk == "specialty_quickrevive")
		return "Quick Revive";
	if(perk == "specialty_finalstand")
		return "Who's Who";
	if(perk == "specialty_grenadepulldeath")
		return "Electric Cherry";
	if(perk == "specialty_flakjacket")
		return "PhD Flopper";
	if(perk == "specialty_deadshot")
		return "Deadshot Daiquiri";
	if(perk == "specialty_scavenger")
		return "Tombstone Soda";
	if(perk == "specialty_nomotionsensor")
		return "Vulture's Aid";
    //bellow this line are all custom perks
	if(perk == "Downers_Delight")
		return "Downers Delight";
	if(perk == "PHD_FLOPPER")
		return "PhD Flopper";
	if(perk == "MULE")
		return "Mule Kick";
	if(perk == "ELECTRIC_CHERRY")
		return "Electric Cherry";
	if(perk == "WIDOWS_WINE")
		return "Windows Wine";
	if(perk == "Ethereal_Razor")
		return "Ethereal Razor";
	if(perk == "Ammo_Regen")
		return "Ammo Regen";
	if(perk == "Dying_Wish")
		return "Diyng Wish";
	if(perk == "deadshot")
		return "Deadshot";
	if(perk == "Burn_Heart")
		return "Burn Heart";
	if(perk == "Victorious_Tortoise")
		return "Victorious Tortoise";
}

GrabPerkTimer()
{
	level endon("UserGrabbedPerk");
	for(i = 0;i < level.WunderFizzGrabTime;i++)
	{
		wait 1;
	}
	level notify("ResetWunderfizz");
}

GrabPerk(perk)
{
	level endon("ResetWunderfizz");
	while(1)
	{
		level.WunderfizzTrigger waittill("trigger", self);
		if(self usebuttonpressed())
		{
			if(perk == "specialty_armorvest" || perk == "specialty_rof" || perk == "specialty_longersprint" || perk == "specialty_fastreload" || perk == "specialty_additionalprimaryweapon" || perk == "specialty_quickrevive" || perk == "specialty_finalstand" || perk == "specialty_grenadepulldeath" || perk == "specialty_flakjacket" || perk == "specialty_deadshot" || perk == "specialty_scavenger" || perk == "specialty_nomotionsensor")
			{
       			self thread DoGivePerk(perk);
    		} 
    		else 
    		{
        		self thread drawshader_and_shadermove(perk, 1, 1);
    		}
			level notify("UserGrabbedPerk");
			level notify("ResetWunderfizz");
		}
	}
}

doGivePerk(perk)
{
	self endon("disconnect");
    self endon("death");
    level endon("game_ended");
    self endon("perk_abort_drinking");
	if(!(self hasPerk(perk) || ( self maps/mp/zombies/_zm_perks::has_perk_paused( perk ) ) ) )
	{
		self.isDrinkingPerk = 1;
		gun = self maps/mp/zombies/_zm_perks::perk_give_bottle_begin(perk);
        evt = self waittill_any_return("fake_death", "death", "player_downed", "weapon_change_complete");
        if (evt == "weapon_change_complete")
        self thread maps/mp/zombies/_zm_perks::wait_give_perk(perk, 1);
       	self maps/mp/zombies/_zm_perks::perk_give_bottle_end(gun, perk);
       	self.isDrinkingPerk = 0;
    	if (self maps/mp/zombies/_zm_laststand::player_is_in_laststand() || isDefined(self.intermission) && self.intermission)
        	return;
    	self notify("burp");
	}
}

hascustomperk(perk)
{
	for(i = 0; i < self.perkarray.size; i++)
	{
		if(self.perkarray[i].name == perk)
		{
			return 1;
		}
	}
	return 0;
}

getPerkModel( perk )
{
	if ( perk == "specialty_armorvest" )
	{
		if( level.script == "zm_prison" )
		{
			return "p6_zm_al_vending_jugg_on";
		}
		else
		{
			return "zombie_vending_jugg_on";
		}	
	}
	if(	perk == "specialty_nomotionsensor"	)
	{
		return "p6_zm_vending_vultureaid_on";
	}
	if(	perk == "specialty_rof"	)
	{
		if(	level.script == "zm_prison"	)
		{
			return "p6_zm_al_vending_doubletap2_on";
		}
		else
		{
			return "zombie_vending_doubletap2_on";
		}
	}
	if(	perk == "specialty_longersprint"	)
	{
		return "zombie_vending_marathon_on";
	}
	if	( perk == "specialty_fastreload" )
	{
		if( level.script == "zm_prison" )
		{
			return "p6_zm_al_vending_sleight_on";
		}	
		else
		{
			return "zombie_vending_sleight_on";
		}
	}
	if( perk == "specialty_quickrevive" )
	{
		return "zombie_vending_revive_on";	
	}
	if( perk == "specialty_scavenger" )
	{
		return "zombie_vending_tombstone_on";
	}
	if( perk == "specialty_finalstand" )
	{
		return "p6_zm_vending_chugabud_on";
	}	
	if( perk == "specialty_grenadepulldeath" )
	{
		return "p6_zm_vending_electric_cherry_on";
	}
	if( perk == "specialty_additionalprimaryweapon" )
	{
		return "zombie_vending_three_gun_on";
	}    
	if( perk == "specialty_deadshot" )
	{
		if( level.script == "zm_prison" )
		{
			return "p6_zm_al_vending_ads_on";
		}
		else
		{
			return "zombie_vending_ads_on";
		}
	}
	if( perk == "Downers_Delight" ) 
	{
		if( level.script == "zm_transit" ) 
		{
			return "zombie_vending_tombstone_on";
		}
		if( level.script == "zm_nuked" )
		{
			return "zombie_vending_jugg_on";
		}	
		if( level.script == "zm_highrise" )
		{
			return "p6_zm_vending_chugabud_on";
		}	
		if( level.script == "zm_buried" )
		{
			return "p6_zm_vending_vultureaid_on";
		}	
	}
	if( perk == "Victorious_Tortoise" ) 
	{
		if( level.script == "zm_transit" ) 
		{
			return "zombie_vending_tombstone_on";
		}
		if( level.script == "zm_nuked" )
		{
			return "zombie_vending_jugg_on";
		}	
		if( level.script == "zm_highrise" )
		{
			return "p6_zm_vending_chugabud_on";
		}	
		if( level.script == "zm_buried" )
		{
			return "p6_zm_vending_vultureaid_on";
		}	
	}
	if( perk == "Burn_Heart" ) 
	{
		if( level.script == "zm_transit" ) 
		{
			return "zombie_vending_tombstone_on";
		}
		if( level.script == "zm_nuked" )
		{
			return "zombie_vending_jugg_on";
		}	
		if( level.script == "zm_highrise" )
		{
			return "p6_zm_vending_chugabud_on";
		}	
		if( level.script == "zm_buried" )
		{
			return "p6_zm_vending_vultureaid_on";
		}	
	}
	if( perk == "PHD_FLOPPER" )  //this perk is not on Origins
	{
		if( level.script == "zm_transit" )
		{
			return "zombie_vending_tombstone_on";
		}	
		if( level.script == "zm_nuked" )
		{
			return "zombie_vending_jugg_on";
		}	
		if( level.script == "zm_highrise" )
		{
			return "zombie_vending_nuke_on";
		}	
		if( level.script == "zm_prison" )
		{
			return "p6_zm_al_vending_nuke_on";
		}	
		if( level.script == "zm_buried" )
		{
			return "p6_zm_vending_vultureaid_on";
		}	
	}
	if( perk == "MULE" )  //this perk is not on Origins, Buried, Die Rise
	{
		if(level.script == "zm_transit" ) //typo fix
		{
			return "zombie_vending_tombstone_on";
		}	
		if( level.script == "zm_nuked" )
		{
			return "zombie_vending_jugg_on";
		}	
		if( level.script == "zm_prison" )
		{
			return "p6_zm_al_vending_three_gun_on";
		}	
	}
	if( perk == "ELECTRIC_CHERRY" )  //this perk is not on MOTD, Origins
	{
		if( level.script == "zm_transit" ) //typo fix
		{
			return "zombie_vending_tombstone_on";
		}	
		if( level.script == "zm_nuked" )
		{
			return "zombie_vending_jugg_on";
		}
		if( level.script == "zm_highrise" )
		{
			return "p6_zm_vending_chugabud";
		}	
		if( level.script == "zm_buried" )
		{
			return "p6_zm_vending_vultureaid_on";
		}	
	}
	if( perk == "WIDOWS_WINE" )
	{
		if( level.script == "zm_transit" ) //typo fix
		{
			return "zombie_vending_tombstone_on";
		}	
		if( level.script == "zm_nuked" )
		{
			return "zombie_vending_jugg_on";
		}	
		if( level.script == "zm_highrise" )
		{
			return "p6_zm_vending_chugabud_on";
		}	
		if( level.script == "zm_prison" )
		{
			return "p6_zm_al_vending_ads_on";
		}	
		if( level.script == "zm_buried" )
		{
			return "p6_zm_vending_vultureaid_on";
		}	
	}
	if( perk == "Ethereal_Razor" )
	{
		if(level.script == "zm_transit") //typo fix
		{
			return "zombie_vending_tombstone_on";
		}
		if( level.script == "zm_nuked" )
		{
			return "zombie_vending_jugg_on";
		}
		if( level.script == "zm_highrise" )
		{
			return "p6_zm_vending_chugabud_on";
		}
		if( level.script == "zm_prison" )
		{
			return "p6_zm_al_vending_ads_on";
		}
		if( level.script == "zm_buried" ) 
		{
			return "p6_zm_vending_vultureaid_on";
		}
	}
	if( perk == "Ammo_Regen" )
	{
		if( level.script == "zm_transit" ) //typo fix
		{
			return "zombie_vending_tombstone_on";
		}	
		if( level.script == "zm_nuked" )
		{
			return "zombie_vending_jugg_on";
		}	
		if( level.script == "zm_highrise" )
		{
			return "p6_zm_vending_chugabud_on";
		}	
		if( level.script == "zm_prison" )
		{
			return "p6_zm_al_vending_ads_on";
		}	
		if( level.script == "zm_buried" )
		{
			return "p6_zm_vending_vultureaid_on";
		}	
	}
	if( perk == "Dying_Wish" )
	{
		if( level.script == "zm_transit" ) 
		{
			return "zombie_vending_tombstone_on";	
		}	
		if( level.script == "zm_nuked" )
		{
			return "zombie_vending_jugg_on";
		}	
		if( level.script == "zm_highrise" )
		{
			return "p6_zm_vending_chugabud_on";
		}	
		if( level.script == "zm_prison" )
		{
			return "p6_zm_al_vending_ads_on";
		}	
		if( level.script == "zm_buried" )
		{
			return "p6_zm_vending_vultureaid_on";
		}	
	}
	if(perk == "deadshot" ) 
	{
		if( level.script == "zm_transit" ) 
		{
			return "zombie_vending_tombstone_on";
		}	
		if( level.script == "zm_nuked" )
		{
			return "zombie_vending_jugg_on";
		}	
		if( level.script == "zm_highrise" )
		{
			return "p6_zm_vending_chugabud_on";
		}	
		if( level.script == "zm_buried" )
		{
			return "p6_zm_vending_vultureaid_on";
		}
	}
}

IncludedPerks()
{
	perks = [];
	if(!self hasperk("specialty_armorvest"))
	{
    	perks[perks.size] = "specialty_armorvest";
	}
	if(!self hasperk("specialty_fastreload"))
	{
		perks[perks.size] = "specialty_fastreload";
	}
	if(!self hasperk("specialty_rof"))
	{
    	perks[perks.size] = "specialty_rof";
	}
	if(!self hascustomperk("WIDOWS_WINE"))
	{
        perks[perks.size] = "WIDOWS_WINE";
    }
    if(!self hascustomperk("Ethereal_Razor"))
	{
        perks[perks.size] = "Ethereal_Razor";
    }
	if(!self hascustomperk("Ammo_Regen"))
	{
        perks[perks.size] = "Ammo_Regen";
    }
	if(!self hascustomperk("Dying_Wish"))
	{
        perks[perks.size] = "Dying_Wish";
    }
	if(level.script == "zm_transit" )
	{
		if(!self hascustomperk("Burn_Heart"))
        {
            perks[perks.size] = "Burn_Heart";
        }
		if(!self hasperk("specialty_quickrevive"))
		{
			perks[perks.size] = "specialty_quickrevive";
		}
		if(!self hasperk("specialty_scavenger"))
    	{
			perks[perks.size] = "specialty_scavenger";
		}
		if(!self hasperk("specialty_longersprint"))
		{
			perks[perks.size] = "specialty_longersprint";
        }
		if(!self hascustomperk("Downers_Delight"))
	    {
    	    perks[perks.size] = "Downers_Delight";
        }
        if(!self hascustomperk("PHD_FLOPPER"))
	    {
            perks[perks.size] = "PHD_FLOPPER";
        }
        if(!self hascustomperk("MULE")) 
	    {
            perks[perks.size] = "MULE";
        }
        if(!self hascustomperk("ELECTRIC_CHERRY"))
	    {
            perks[perks.size] = "ELECTRIC_CHERRY";
        }
		if(!self hascustomperk("deadshot"))
	    {
            perks[perks.size] = "deadshot";
        }
	}
	if(level.script == "zm_prison" )
	{
		if(!self hasperk("specialty_grenadepulldeath"))
		{
        	perks[perks.size] = "specialty_grenadepulldeath";
		}
		if(!self hasperk("specialty_deadshot"))
        {
			perks[perks.size] = "specialty_deadshot";
		}
        if(!self hascustomperk("PHD_FLOPPER")) 
	    {
            perks[perks.size] = "PHD_FLOPPER";
        }
        if(!self hascustomperk("MULE")) 
	    {
            perks[perks.size] = "MULE";
        }
	}
	if(level.script == "zm_nuked" )
	{
		if(!self hasperk("specialty_quickrevive"))
		{
			perks[perks.size] = "specialty_quickrevive";
		}
		if(!self hascustomperk("Downers_Delight")) 
	    {
    	    perks[perks.size] = "Downers_Delight";
        }
        if(!self hascustomperk("PHD_FLOPPER")) 
	    {
            perks[perks.size] = "PHD_FLOPPER";
        }
        if(!self hascustomperk("MULE")) 
	    {
            perks[perks.size] = "MULE";
        }
        if(!self hascustomperk("ELECTRIC_CHERRY"))
	    {
            perks[perks.size] = "ELECTRIC_CHERRY";
        }
		if(!self hascustomperk("deadshot"))
	    {
            perks[perks.size] = "deadshot";
        }
	}
	if(level.script == "zm_tomb" )
	{
		if(!self hasperk("specialty_deadshot"))
		{
			perks[perks.size] = "specialty_deadshot";
		}
		if(!self hasperk("specialty_grenadepulldeath"))
		{
    		perks[perks.size] = "specialty_grenadepulldeath";
		}
		if(!self hasperk("specialty_flakjacket"))
    	{
			perks[perks.size] = "specialty_flakjacket";
		}
		if(!self hasperk("specialty_quickrevive"))
        {
			perks[perks.size] = "specialty_quickrevive";
		}
		if(!self hasperk("specialty_additionalprimaryweapon"))
		{
			perks[perks.size] = "specialty_additionalprimaryweapon";
		}
		if(!self hasperk("specialty_longersprint"))
		{
			perks[perks.size] = "specialty_longersprint";
		}
		if(!self hascustomperk("Downers_Delight")) 
	    {
    	    perks[perks.size] = "Downers_Delight";
        }
	}
	if(level.script == "zm_buried" )
	{
		if(!self hasperk("specialty_nomotionsensor"))
    	{
			perks[perks.size] = "specialty_nomotionsensor";
		}
		if(!self hasperk("specialty_additionalprimaryweapon"))
		{
			perks[perks.size] = "specialty_additionalprimaryweapon";
		}
		if(!self hasperk("specialty_quickrevive"))
    	{
			perks[perks.size] = "specialty_quickrevive";
		}
		if(!self hasperk("specialty_longersprint"))
		{
			perks[perks.size] = "specialty_longersprint";
		}
		if(!self hascustomperk("Downers_Delight")) 
	    {
    	    perks[perks.size] = "Downers_Delight";
        }
        if(!self hascustomperk("PHD_FLOPPER"))
	    {
            perks[perks.size] = "PHD_FLOPPER";
        }
        if(!self hascustomperk("ELECTRIC_CHERRY"))
	    {
            perks[perks.size] = "ELECTRIC_CHERRY";
        }
		if(!self hascustomperk("deadshot"))
	    {
            perks[perks.size] = "deadshot";
        }
	}
	if(level.script == "zm_highrise" )
	{
		if(!self hasperk("specialty_quickrevive"))
		{
			perks[perks.size] = "specialty_quickrevive";
		}
		if(!self hasperk("specialty_finalstand"))
    	{
			perks[perks.size] = "specialty_finalstand";
		}
		if(!self hasperk("specialty_additionalprimaryweapon"))
	    {
			perks[perks.size] = "specialty_additionalprimaryweapon";
		}
		if(!self hascustomperk("Downers_Delight")) 
	    {
    	    perks[perks.size] = "Downers_Delight";
        }
        if(!self hascustomperk("PHD_FLOPPER"))
	    {
            perks[perks.size] = "PHD_FLOPPER";
        }
        if(!self hascustomperk("ELECTRIC_CHERRY"))
	    {
            perks[perks.size] = "ELECTRIC_CHERRY";
        }
		if(!self hascustomperk("deadshot")) 
	    {
            perks[perks.size] = "deadshot";
        }
    }
    if(level.script == "zm_transit" || level.script == "zm_tomb" || level.script == "zm_prison")
    {
        if(!self hascustomperk("Victorious_Tortoise"))
        {
            perks[perks.size] = "Victorious_Tortoise";
        }
    }
	return perks;
}

removeperkshader()
{
    for(;;)
    {
        self waittill_any_return( "fake_death", "player_downed", "player_revived", "spawned_player", "disconnect", "death" );
        self.num_perks = 0;
        self.perk_reminder = 0;
        self.perk_count = 0;
        self.dying_wish_on_cooldown = 0;
        self removeallcustomshader();
        self.perkarray = [];
        self notify( "stopcustomperk" );
        self.bleedout_time = 30;
        self.ignore_lava_damage = 0;
    }
}

removeallcustomshader()
{
    for(i = 0; i < self.perkarray.size; i++)
    {
        self.perkarray[i] destroy();
    }
}

perkboughtcheck()
{
    self endon("death");
    self endon("disconnect");
    for(;;)
    {
        self.perk_reminder = self.num_perks;
        self waittill("perk_acquired");
        n = 1;
        if(!(self.num_perks > self.perk_reminder))
        {
            n = (self.num_perks - self.perk_reminder);
            self.num_perks = (self.perk_reminder + n);
        }
        self.perk_reminder = self.num_perks;
        self.perk_count += n;
        self drawshader_and_shadermove("none", 0, 0);
    }
}

WunderfizzLocations()
{
	if(isdefined(level.WunderfizzCustomOrigin))
	{
		selected_Origin = (level.WunderfizzCustomOrigin);
	}
	else{
		selected_Origin = [];
		selected_Origin_Angles = [];
		if(level.script == "zm_transit")
		{
			selected_Origin[0] = (-10805.7, -1994.16, 196.125);
			selected_Origin_Angles[0] = (0,-90,0);
			selected_Origin[1] = (-11824,-1495,228);
			selected_Origin_Angles[1] = (0,90,0);
			selected_Origin[2] = (-5696.65, -7803.64, 227.079);
			selected_Origin_Angles[2] = (0,0,0);
			selected_Origin[3] = (5022.64, 6597.91, -15.7449);
			selected_Origin_Angles[3] = (0,90,0);
			selected_Origin[4] = (-7103,4952,-56);
			selected_Origin_Angles[4] = (0,0,0);
			selected_Origin[5] = (-5043,-7772,-61);
			selected_Origin_Angles[5] = (0,180,0);
			selected_Origin[6] = (8371,-5408,264);
			selected_Origin_Angles[6] = (0,180,0);
			selected_Origin[7] = (11168,8120,-576);
			selected_Origin_Angles[7] = (0,0,0);
			selected_Origin[8] = (1823,114,88);
			selected_Origin_Angles[8] = (0,90,0);
		}
		if(level.script == "zm_prison")
		{
			selected_Origin[0] = (-377, -3903, -8448);
			selected_Origin_Angles[0] = (0,270, 0);
			selected_Origin[1] = (-843, 5585, -72);
			selected_Origin_Angles[1] = (0,13,0);
			selected_Origin[2] = (-1056, 8673, 1336);
			selected_Origin_Angles[2] = (0,90,0);
			selected_Origin[3] = (2795, 9270, 1336);
			selected_Origin_Angles[3] = (0,180,0);
			selected_Origin[4] = (2724, 9563, 1708);
			selected_Origin_Angles[4] = (0,90,0);
			selected_Origin[5] = (2046, 10332.9, 1336);
			selected_Origin_Angles[5] = (0,180,0);
		}
		if(level.script == "zm_tomb")
		{
			selected_Origin[0] = (2468, 4459, -316);
			selected_Origin_Angles[0] = (0,-180,0);
		}
		if(level.script == "zm_buried")
		{
			selected_Origin[0] = (6862, 846, 108);
			selected_Origin_Angles[0] = (0,49,0);
			selected_Origin[1] = (4910, 725, 2);
			selected_Origin_Angles[1] = (0,0,0);
			selected_Origin[2] = (1521, 1366, -14);
			selected_Origin_Angles[2] = (0,342,0);
			selected_Origin[3] = (-58, -1512, 168);
			selected_Origin_Angles[3] = (0,180,0);
			selected_Origin[4] = (-374,-1103,8);
			selected_Origin_Angles[4] = (0,270,0);
			selected_Origin[5] = (146,138,10);
			selected_Origin_Angles[5] = (0,270,0);
		}
		if(level.script == "zm_highrise")
		{
			selected_Origin[0] = (1482, 1060, 3395);
			selected_Origin_Angles[0] = (0,180,0);
			selected_Origin[1] = (2964, 2698, 2905);
			selected_Origin_Angles[1] = (349,0,0);
			selected_Origin[2] = (2608, 275, 1296);
			selected_Origin_Angles[2] = (0,60,0);
			selected_Origin[3] = (1809, 1459, 3040);
			selected_Origin_Angles[3] = (0,0,0);
			selected_Origin[4] = (1648, -635, 2880);
			selected_Origin_Angles[4] = (0,150,0);
		}
		if(level.script == "zm_nuked")
		{
			selected_Origin[0] = (660.768, 426.494, -57.6012);
			selected_Origin_Angles[0] = (0,200,0);
			selected_Origin[1] = (716, 21, -57);
			selected_Origin_Angles[1] = (0,192,0);
			selected_Origin[2] = (-649, 281, -56);
			selected_Origin_Angles[2] = (0,162,0);
			selected_Origin[3] = (-915, 286, 56);
			selected_Origin_Angles[3] = (0,66,0);
		}
		if ( getDvar( "ui_zm_mapstartlocation" ) == "bus depot" )
		{
			selected_Origin[0] = (-7103,4952,-56);
			selected_Origin_Angles[0] = (0,0,0);
		}
		//DISABLED Cause I have no location yet
		/*if ( getDvar( "ui_zm_mapstartlocation" ) == "town" )
		{
			selected_Origin[0] = (0,0,0);
			selected_Origin_Angles[0] = (0,0,0);
		}*/
		if ( getDvar( "ui_zm_mapstartlocation" ) == "farm" )
		{
			selected_Origin[0] = (8371,-5408,264);
			selected_Origin_Angles[0] = (0,180,0);
		}
		Num = randomintrange(0,selected_Origin.size);
		level.WunderfizzFirstOrigin = (selected_Origin[Num]);
		level.WunderfizzFirstAngles = (selected_Origin_Angles[Num]);
		if(isdefined(level.lastwunderfizzorigin) && level.lastwunderfizzorigin == level.WunderfizzFirstOrigin)
		{
			selected_Origin = array_randomize( selected_Origin );
			for(i = 0;i < selected_Origin.size;i++)
			{
				if(selected_Origin[i] != level.lastwunderfizzorigin)
				{
					level.WunderfizzFirstOrigin = selected_Origin[i];
					level.WunderfizzFirstAngles = selected_Origin_Angles[i];
				}
			}
		}
	}
}

drawshader_and_shadermove(perk, custom, print)
{
    if(custom)
    {
        self allowProne(false);
        self allowSprint(false);
        self disableoffhandweapons();
        self disableweaponcycling();
        weapona = self getcurrentweapon();
        weaponb = "zombie_perk_bottle_jugg";
        self giveweapon( weaponb );
        self switchtoweapon( weaponb );
        self waittill( "weapon_change_complete" );
        self enableoffhandweapons();
        self enableweaponcycling();
        self takeweapon( weaponb );
        self switchtoweapon( weapona );
        self maps/mp/zombies/_zm_audio::playerexert( "burp" );
        self setblur( 4, 0.1 );
        wait 0.1;
        self setblur( 0, 0.1 );
        self allowProne(true);
        self allowSprint(true);
    }
    for(i = 0; i < self.perkarray.size; i++)
	{
    	self.perkarray[i].x = self.perkarray[i].x + 30;
	}
        if(perk == "Downers_Delight")
        {
            self.perk1back = self drawshader( "specialty_doubletap_zombies", 24, 24, ( 0, 0, 0 ), 100, 0, 0 );  
            self.perk1front = self drawshader( "waypoint_revive", 23, 23, ( 0, 1, 1 ), 100, 0, 1 ); 
            self.perk1front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk1front;
			self.perk1back.name = perk;
			self.perkarray[self.perkarray.size] = self.perk1back;
			self.num_perks++;
			self thread DDown();
			if(print)
			{
				self iprintln("^9Downer's Delight");
				wait 0.2;
				self iprintln("This Perk will increase players bleedout time by 10 seconds and current weapons is used in laststand.");
			}
		}
        if(perk == "MULE")
        {   
            self.perk2back = self drawshader( "specialty_doubletap_zombies", 24, 24, ( 0, 0, 0 ), 100, 0, 0 );
            self.perk2front = self drawshader( "menu_mp_weapons_1911", 22, 22, ( 0, 1, 0 ), 100, 0, 1 );
            self.perk2front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk2front;
			self.perk2back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk2back;
			self.num_perks++;
			if(print)
			{
				self iprintln("^9Mule Kick");
				wait 0.2;
				self iprintln("This Perk enables additional primary weapon slot for player. ");
			}
		}
        if(perk == "PHD_FLOPPER")
        {    
            self.perk3back = self drawshader( "specialty_doubletap_zombies", 24, 24, ( 0, 0, 0 ), 100, 0, 0 );
            self.perk3front = self drawshader( "hud_icon_sticky_grenade", 23, 23, (1, 0, 1 ), 100, 0, 1);
            self.perk3front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk3front;
			self.perk3back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk3back;
			self.num_perks++;
			if(print)
			{
				self iprintln("^9PhD Flopper");
				wait 0.2;
				self iprintln("This Perk removes explosion and fall damage also player creates explosion when dive to prone.");
			}
		}
        if(perk == "ELECTRIC_CHERRY")
        {    
            self.perk5back = self drawshader( "specialty_doubletap_zombies", 24, 24, ( 0, 0, 200 ), 100, 0, 0 );
            self.perk5front = self drawshader( "zombies_rank_5", 23, 23, ( 1, 1, 1 ), 100, 0, 1 );
            self.perk5front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk5front;
			self.perk5back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk5back;
			self.num_perks++;
			self thread start_ec();
			if(print)
			{
				self iprintln("^9Electric Cherry");
				wait 0.2;
				self iprintln("This Perk creates an electric shockwave around the player whenever they reload.");
        	}
		}	
        if(perk == "WIDOWS_WINE")
        {    
            self.perk6back = self drawshader( "specialty_doubletap_zombies", 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk6front = self drawshader( "zombies_rank_3", 23, 23, ( 1, 1, 1 ), 100, 0, 1 );
            self.perk6front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk6front;
			self.perk6back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk6back;
			self.num_perks++;
			self takeweapon( self get_player_lethal_grenade() );
			self set_player_lethal_grenade( "sticky_grenade_zm" );
			self giveweapon("sticky_grenade_zm");
        	self thread ww_nades();
			if(print)
			{
				self iprintln("^9Widow's Wine");
				wait 0.2;
				self iprintln("This Perk damages zombies around the player when player is hit and grenades are upgraded.");
        	}
		}
        if(perk == "Ethereal_Razor")
        {    
            self.perk7back = self drawshader( "specialty_doubletap_zombies", 24, 24, ( 200, 0, 0 ), 100, 0 );
            self.perk7front = self drawshader( "zombies_rank_4", 23, 23, ( 1, 1, 1 ), 100, 0, 1);
			self.perk7front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk7front;
			self.perk7back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk7back;
			self.num_perks++;
            self thread start_er();
			if(print)
			{
				self iprintln("^9Ethereal Razor");
				wait 0.2;
				self iprintln("This Perk deals extra damage when player using melee attacks and restores a small amount of health.");
        	}
		}
		if(perk == "Ammo_Regen")
        {
            self.perk8back = self drawshader( "specialty_doubletap_zombies", 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk8front = self drawshader( "menu_mp_lobby_icon_customgamemode", 23, 23, ( 1, 1, 1 ), 100, 0, 1);
            self.perk8front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk8front;
			self.perk8back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk8back;
			self.num_perks++;
			self thread ammoregen();
            self thread grenadesregen();
			if(print)
			{
				self iprintln("^9Ammo Regen");
				wait 0.2;
				self iprintln("This Perk will slowly regenerades players ammonation and grenades.");			
			}
		}
        if(perk == "Dying_Wish")
        {
            self.perk10back = self drawshader( "specialty_doubletap_zombies", 24, 24, ( 200, 0, 0 ), 100, 0 );
            self.perk10front = self drawshader( "zombies_rank_5", 23, 23, ( 1, 1, 1 ), 100, 0, 1);
            self.perk10front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk10front;
			self.perk10back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk10back;
			self.num_perks++;
            self thread dying_wish_checker();
			if(print)
			{
				self iprintln("^9Dying Wish");
				wait 0.2;
				self iprintln("This Perk allow player to go berserker mode for 9 seconds instead of laststand.");
				wait 0.1;
				self iprintln(" (cooldown 5mins and it's increased 30sec every time perk is used. - max 10mins) ");
			}
		}
        if(perk == "deadshot")
        {
            self.perk11back = self drawshader( "specialty_doubletap_zombies", 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk11front = self drawshader( "killiconheadshot", 23, 23, ( 1, 1, 1 ), 100, 0, 1);
            self.perk11front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk11front;
			self.perk11back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk11back;
			self.num_perks++;

            self thread AimAssist();
			if(print)
			{
				self iprintln("^9Deadshot");
				wait 0.2;
				self iprintln("This Perk aims automatically enemys head instead of body.");
        	}
		}
		if(perk == "Victorious_Tortoise")
        {
            self.perk12back = self drawshader( "specialty_marathon_zombies", 24, 24, ( 0, 1, 0 ), 100, 0 );
            self.perk12front = self drawshader( "zombies_rank_2", 23, 23, ( 1, 1, 1 ), 100, 0, 1);
            self.perk12front.name = perk;
            self.perkarray[self.perkarray.size] = self.perk12front;
            self.perk12back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk12back;
            self.num_perks++;
            if(print)
            {
                self iprintln("^9Victorious Tortoise");
                wait 0.2;
                self iprintln("This Perk allows shield block damage from all directions when in use.");
            }
        }
        if(perk == "Burn_Heart")
        {
            self.perk13back = self drawshader( "specialty_marathon_zombies", 24, 24, ( 1, 0, 0 ), 100, 0 );
            self.perk13front = self drawshader( "faction_cdc", 23, 23, ( 1, 1, 1 ), 100, 0, 1);
            self.perk13front.name = perk;
            self.perkarray[self.perkarray.size] = self.perk13front;
            self.perk13back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk13back;
            self.num_perks++;
            self.ignore_lava_damage = 1;
            if(print)
            {
                self iprintln("^9Burn Heart");
                wait 0.2;
                self iprintln("This Perk removes lava damage.");
            }
        }
    
}

DDown() 
{
	self endon( "disconnect" );
	level endon( "end_game" );
	self endon( "stopcustomperk" );
	for(;;)
	{
		self waittill("player_downed");
		self playsound( "zmb_phdflop_explo" );
		playfx(loadfx("explosions/fx_default_explosion"), self.origin, anglestoforward( ( 0, 45, 55  ) ) );
		RadiusDamage(self.origin, 100, 200, 100, self);
		wait 0.1;
	}
}

drawshader( shader, width, height, color, alpha, sort, foreground )
{
	if ( !isDefined( self.perks_active ) )
	{
		self.perks_active = [];
	}
	hud = create_simple_hud( self );
	hud setshader( shader, width, height );
	hud.color = color;
	hud.alpha = alpha;
	hud.sort = sort;
    hud.foreground = foreground;
    hud.hidewheninmenu = 1;
    hud.horzAlign = "user_left";
    hud.vertAlign = "user_center";
    hud.x = 5.5 + (self.perks_active.size * 30);
    hud.y = 146.5;
	return hud;
}

start_ec()
{
	level endon("end_game");
	self endon("disconnect");
	self endon("stopcustomperk");
	for(;;)
    {
		self waittill( "reload_start" );
        playfxontag( level._effect[ "poltergeist"], self, "J_SpineUpper" );
        self playsound( "zmb_turbine_explo" );
		self EnableInvulnerability();
		RadiusDamage(self.origin, 90, 220, 120, self);
		self DisableInvulnerability();
		wait 1;
    }
}

custom_get_player_weapon_limit( player )
{
    weapon_limit = 2;
    if ( player hascustomperk("MULE") )
    {
        weapon_limit = 3;
    } 
	else 
	{
		weapons = self getWeaponsListPrimaries();
		if(weapons.size > 2)
		{
			self takeWeapon(weapons[2]);
		}
	}
    return weapon_limit;
}

start_er()
{
    level endon("end_game");
    self endon("disconnect");
    self endon("stopcustomperk");
    for(;;)
    {
        if (self hascustomperk("Ethereal_Razor") && self ismeleeing())
        {
            foreach(zombie in getAiArray(level.zombie_team))
			{
                if( distance( self.origin, zombie.origin ) <= 100 )
				{
					if(self is_insta_kill_active())
					{
						zombie doDamage(zombie.health + 666, (0, 0, 0));
					}
                    zombie dodamage(500, (0, 0, 0));
                    if(zombie.health <= 0)
					{
                        self maps/mp/zombies/_zm_score::add_to_player_score( 100 );
						self.kills++;
					} 
					else 
					{
                        self maps/mp/zombies/_zm_score::add_to_player_score( 10 );
                    }
                } 
            }
            self.health += 10;
            if(self.health > self.maxhealth)
			{
                self.health = self.maxhealth;
            }
            while(self ismeleeing())
			{
                wait 0.1;
            }
        }
        wait 0.05;
    }
}

dying_wish_checker()
{
    level endon("end_game");
    self endon("disconnect");
    self endon( "stopcustomperk" );
    self.dying_wish_uses = 0;
    for(;;)
	{
        self.dying_wish_on_cooldown = 0;
        self.perk10back.alpha = 1;
        self.perk10front.alpha = 1;
        self waittill("dying_wish_charge");
        self.perk10back.alpha = 0.3;
        self.perk10front.alpha = 0.4;
        self.dying_wish_uses++;
        self.dying_wish_on_cooldown = 1;
        delay = 300 + (self.dying_wish_uses * 30);
        if(delay >= 600)
        delay = 600;
        wait delay;
    }
}

dying_wish_effect()
{
    self enableInvulnerability();
    self.ignoreme = 1;
    self useServerVisionSet(1);
    self setvisionsetforplayer( "zombie_death", 0 );
    self freezeControls(1);
    wait 1;
    self freezeControls(0);
    wait 8;
	self.health = 1;
    self disableInvulnerability();
    self.ignoreme = 0;
    self useServerVisionSet(0);
    self setvisionsetforplayer("remote_mortar_enhanced", 0);
}

ammoregen()
{
	self endon( "disconnect" );
	level endon( "end_game" );
	self endon( "stopcustomperk" );
	for(;;)
	{
		if(!self GetCurrentWeapon() == "claymore_zm" ) 
		{
			stockcount = self getweaponammostock( self GetCurrentWeapon() );
			self setWeaponAmmostock( self GetCurrentWeapon(), stockcount + 1 );
			wait 2;
		}
		wait 0.1;
	}
}

grenadesregen()
{
	self endon( "disconnect" );
	level endon( "end_game" );
	self endon( "stopcustomperk" );
	for(;;)
	{
		grenades = self get_player_lethal_grenade();
        grenade_count = self getweaponammoclip(grenades);
        if(grenade_count < 4)
		{
        	self setweaponammoclip(grenades, (grenade_count + 1));
		}
		tactical_grenades = self get_player_tactical_grenade();
        tactical_grenade_count = self getweaponammoclip(tactical_grenades);
        if(tactical_grenade_count < 3 )
		{
        	self setweaponammoclip(tactical_grenades, (tactical_grenade_count + 1));
		}
		wait 300;
	}
}

object_touching_lava()
{
	if ( !isDefined( level.lava ) )
	{
		level.lava = getentarray( "lava_damage", "targetname" );
	}
	if ( !isDefined( level.lava ) || level.lava.size < 1 )
	{
		return 0;
	}
	if ( isDefined( self.lasttouching ) && self istouching( self.lasttouching ) )
	{
		return 1;
	}
	i = 0;
	while ( i < level.lava.size )
	{
		if ( distancesquared( self.origin, level.lava[ i ].origin ) < 2250000 )
		{
			if ( isDefined( level.lava[ i ].target ) )
			{
				if ( self istouching( level.lava[ i ].volume ) )
				{
					if ( isDefined( level.lava[ i ].script_float ) && level.lava[ i ].script_float <= 0.1 )
					{
						return 0;
					}
					self.lasttouching = level.lava[ i ].volume;
					return 1;
				}
			}
			else
			{
				if ( self istouching( level.lava[ i ] ) )
				{
					self.lasttouching = level.lava[ i ];
					return 1;
				}
			}
		}
		i++;
	}
	self.lasttouching = undefined;
	return 0;
}


AimAssist()
{
	self endon("disconnect");
    self endon("stopcustomperk");
	self thread is_player_aiming();
	for(;;)
	{
		view_pos = self GetWeaponMuzzlePoint();
		zombies = get_array_of_closest( view_pos, getaiarray( level.zombie_team ), undefined, undefined, undefined );
		range_squared = 300 * 300;
		for ( i = 0; i < zombies.size; i++ )
		{
			if ( !IsDefined( zombies[i] ) || !IsAlive( zombies[i] ) )
			{
				continue;
			}
			enemy_origin = zombies[i].origin;
			test_range_squared = DistanceSquared( view_pos, enemy_origin );
			if ( test_range_squared < range_squared )
			{
				if(zombies[i] player_can_see_me(self))
				{
					if(self adsButtonPressed() && !self IsReloading() && !self.isAiming )
					{
						self setPlayerAngles(vectorToAngles((zombies[i] getTagOrigin("j_head")) - (self getEye())));
						while(self adsButtonPressed())
						{
							wait .05;	
						}
						break;
					}
				}
			}
		}
		wait .05;
	}
}

player_can_see_me( player )
{
    playerangles = player getplayerangles();
    playerforwardvec = anglesToForward( playerangles );
    playerunitforwardvec = vectornormalize( playerforwardvec );
    banzaipos = self.origin;
    playerpos = player getorigin();
    playertobanzaivec = banzaipos - playerpos;
    playertobanzaiunitvec = vectornormalize( playertobanzaivec );
    forwarddotbanzai = vectordot( playerunitforwardvec, playertobanzaiunitvec );
    if ( forwarddotbanzai >= 1 )
    {
        anglefromcenter = 0;
    }
    else if ( forwarddotbanzai <= -1 )
    {
        anglefromcenter = 180;
    }
    else
    {
        anglefromcenter = acos( forwarddotbanzai );
    }
    playerfov = getDvarFloat( "cg_fov" );
    banzaivsplayerfovbuffer = getDvarFloat( "g_banzai_player_fov_buffer" );
    if ( banzaivsplayerfovbuffer <= 0 )
    {
        banzaivsplayerfovbuffer = 0.2;
    }
    playercanseeme = anglefromcenter <= ( ( playerfov * 0.5 ) * ( 1 - banzaivsplayerfovbuffer ) );
    return playercanseeme;
}

is_player_aiming()
{
    self endon("stopcustomperk");
	self.isAiming = 0;
	for(;;)
	{
		aiming = 0;
		self.isAiming = 0;
		while(self adsbuttonpressed())
		{
			aiming++;
			if(aiming > 1)
			{
				self.isAiming = 1;
			}
			wait .05;
		}
		wait .05;
	}
}

ww_points( player )
{
    for(i = 0; i < 3; i++)
    {
		self maps/mp/zombies/_zm_utility::set_zombie_run_cycle("walk");
        player maps/mp/zombies/_zm_score::add_to_player_score( 10 );
        PlayFXOnTag(level.effect_WebFX,self,"j_spineupper");
        self doDamage(250, (0, 0, 0));
        wait 1;
    }
}

ww_nade_explosion()
{
    wait 2;
    if( self object_touching_lava())
	{
        self delete();
        return 0;
    }
	zombies = getAiArray(level.zombie_team);
	foreach(zombie in zombies)
	{
        if( distance( zombie.origin, self.origin ) < 250 )
		{
            zombie thread ww_points( self );
        }
    }
    self delete();
}

ww_nades()
{
    level endon("end_game");
    self endon("disconnect");
    self endon("stopcustomperk");
    for(;;)
	{
        self waittill( "grenade_fire", grenade, weapname );
        if( weapname == "sticky_grenade_zm" )
		{
            ww_nade = spawnsm( grenade.origin, "zombie_bomb" );
            ww_nade hide();
            ww_nade linkto( grenade );
            ww_nade thread ww_nade_explosion();
        }
    }
}

spawnsm( origin, model, angles )
{
    ent = spawn( "script_model", origin );
    ent setmodel( model );
    if( IsDefined( angles ) )
    {
        ent.angles = angles;
    }
    return ent;
}

playerdamagelastcheck( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime )
{
	if( isDefined( eAttacker.is_zombie ) && eAttacker.is_zombie && self hascustomperk("Victorious_Tortoise") )
    {
        if(self getcurrentweapon() == "riotshield_zm" || self getcurrentweapon() == "alcatraz_shield_zm" || self getcurrentweapon() == "tomb_shield_zm")
        {
            shield_hp = 1500;
            if ( !isDefined( self.shielddamagetaken ) )
            {
                self.shielddamagetaken = 0;
            }
            self.shielddamagetaken += idamage;
            if ( self.shielddamagetaken >= shield_hp )
            {
                if ( isDefined( self.stub ) )
                {
                    thread maps/mp/zombies/_zm_unitrigger::unregister_unitrigger( self.stub );
                }
                playsoundatposition( "wpn_riotshield_zm_destroy", self.origin );
                self notify("destroy_riotshield");
                if(getdvar( "mapname" ) == "zm_prison")
                {
                    self maps/mp/zombies/_zm_equipment::equipment_take( "alcatraz_shield_zm" );
                }
                if(getdvar( "mapname" ) == "zm_tomb")
                {
                    self maps/mp/zombies/_zm_equipment::equipment_take( "tomb_shield_zm" );
                }
                if(getdvar( "mapname" ) == "zm_transit")
                {
                    self maps/mp/zombies/_zm_equipment::equipment_take( "riotshield_zm" );
                }
                maps/mp/zombies/_zm_equipment::equipment_disappear_fx( self.origin, level._riotshield_dissapear_fx );
                self enableInvulnerability();
                wait 1;
                self disableInvulnerability();
            }
            else
            {
                self deployed_set_shield_health( self.shielddamagetaken, damagemax );
            }
            return 0;
        }
    }
    if(self hascustomperk("WIDOWS_WINE"))
	{
          if(isDefined( eAttacker.is_zombie ) && eattacker.is_zombie )
		  {
            grenades = self get_player_lethal_grenade();
            grenade_count = self getweaponammoclip(grenades);
            if(grenade_count > 0)
			{
                self setweaponammoclip(grenades, (grenade_count - 1));
                foreach(zombie in getAiArray(level.zombie_team))
				{
                    if(distance(zombie.origin, self.origin) < 150)
					{
                        zombie thread ww_points( self );
                        self PlaySound("zmb_elec_jib_zombie");
                    }
                }
            }
        }
    }
	if(self hascustomperk("PHD_FLOPPER"))
	{
		if( smeansofdeath == "MOD_FALLING" )
		{
			if(isDefined( self.divetoprone ) && self.divetoprone == 1 )
			{
				radiusdamage( self.origin, 300, 5000, 1000, self, "MOD_GRENADE_SPLASH" );
				playfx(loadfx("explosions/fx_default_explosion"), self.origin, anglestoforward( ( 0, 45, 55  ) ) ); 
				self playsound( "zmb_phdflop_explo" );
			}
			return 0;
		}
		if(smeansofdeath == "MOD_GRENADE" || smeansofdeath == "MOD_GRENADE_SPLASH" || eattacker == self && !smeansofdeath == "MOD_UNKNOWN")
		{
			return 0;
		}
	}
	if(idamage > self.health && !self.dying_wish_on_cooldown && self hascustomperk("Dying_Wish") )
	{
        self notify("dying_wish_charge");
        self thread dying_wish_effect();
        return 0;
	}
	else
	{
		return idamage;
	}
}

deployed_set_shield_health( damage, max_damage )
{
	
}



