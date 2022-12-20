--------Timer GUI---------
ModLoader.SetupFileHook( "lua/Hud/GUIPlayerResource.lua", "lua/doors/gui/GUIPlayerResource_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/Hud/Marine/GUIMarineHUD.lua", "lua/doors/gui/GUIMarineHUD_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/GUIInsight_TopBar.lua", "lua/doors/gui/GUIInsight_TopBar_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/GUIAlienHUD.lua", "lua/doors/gui/GUIAlienHUD_Siege22.lua", "post" )
-----------------------
ModLoader.SetupFileHook( "lua/shine/core/shared/hook.lua", "lua/shine/hook.lua", "post" )

--------Core-----------
ModLoader.SetupFileHook( "lua/Location.lua", "lua/Location_Siege.lua", "post" )
ModLoader.SetupFileHook( "lua/Globals.lua", "lua/Globals_Siege19.lua", "post" ) 
ModLoader.SetupFileHook( "lua/NS2Gamerules.lua", "lua/NS2Gamerules_Siege19.lua", "post" )
ModLoader.SetupFileHook( "lua/TargetCache.lua", "lua/TargetCache_Siege.lua", "post" )
ModLoader.SetupFileHook( "lua/GameInfo.lua", "lua/GameInfo_Siege19.lua", "post" )
ModLoader.SetupFileHook( "lua/Server.lua", "lua/Server_Siege.lua", "post" )

---------------Balance--------------------------
ModLoader.SetupFileHook( "lua/Balance.lua", "lua/Balance_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/BalanceMisc.lua", "lua/BalanceMisc_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/BalanceHealth.lua", "lua/BalanceHealth_Siege22.lua", "post" )

---------------Player------------
ModLoader.SetupFileHook( "lua/Player_Client.lua", "lua/player/Player_Client_Siege19.lua", "post" )

-------------Aliens---------------
ModLoader.SetupFileHook( "lua/Alien.lua", "lua/player/Alien_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/Skulk.lua", "lua/player/Skulk_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/AlienTeam.lua", "lua/AlienTeam_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/Lerk.lua", "lua/player/Lerk_Siege22.lua", "post" )

--Lets be Gutsy with Fade. 
ModLoader.SetupFileHook( "lua/Fade_Client.lua", "lua/player/Fade_Client_Siege_23.lua", "post" )
ModLoader.SetupFileHook( "lua/Fade.lua", "lua/player/Fade_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/Gorge.lua", "lua/player/Gorge_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/EvolutionChamber.lua", "lua/EvolutionChamber_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/CommAbilities/Alien/Contamination.lua", "lua/Modifications/Contamination.lua", "post" )
ModLoader.SetupFileHook( "lua/Alien_Upgrade.lua", "lua/Alien_Upgrade_Siege20.lua", "post" )
ModLoader.SetupFileHook( "lua/GUIAlienBuyMenu.lua", "lua/GUIAlienBuyMenu_Siege20.lua", "post" )--override


-----Marines-----
ModLoader.SetupFileHook( "lua/Marine.lua", "lua/player/Marine_Siege22.lua", "post" )
--ModLoader.SetupFileHook( "lua/MarineCommander.lua", "lua/MarineCommander_Siege19.lua", "post" ) 
ModLoader.SetupFileHook( "lua/MarineTeam.lua", "lua/MarineTeam_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/Exo.lua", "lua/player/Exo_Siege22.lua", "post" )



-------Mixins----
ModLoader.SetupFileHook( "lua/SupplyUserMixin.lua", "lua/Mixins/SupplyUserMixin_Siege.lua", "post" )
ModLoader.SetupFileHook( "lua/MaturityMixin.lua", "lua/Mixins/MaturityMixin_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/RolloutMixin.lua", "lua/Mixins/RollOutMixin_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/LeapMixin.lua", "lua/Mixins/LeapMixin_Siege23.lua", "post" )

ModLoader.SetupFileHook( "lua/InputHandler.lua", "lua/InputHandler_Siege.lua", "post" )
--ModLoader.SetupFileHook( "lua/AlienWeaponEffects.lua", "lua/AlienWeaponEffects_Siege.lua", "post" )
ModLoader.SetupFileHook( "lua/NS2Utility_Server.lua", "lua/NS2Utility_Server_Siege20.lua", "post" )

-------------------------Weapons---------------------
ModLoader.SetupFileHook( "lua/Weapons/Marine/Flamethrower.lua", "lua/Weapons/Marine/Flamethrower_Siege.lua", "post" )
ModLoader.SetupFileHook( "lua/Weapons/Alien/Metabolize.lua", "lua/Weapons/Alien/Metabolize_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/Weapons/Alien/Blink.lua", "lua/Weapons/Alien/Blink_Siege22.lua", "post" )


-------------------------Structures---------------
ModLoader.SetupFileHook( "lua/Clog.lua", "lua/structures/Clog_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/ARC.lua", "lua/structures/ARC_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/MAC.lua", "lua/structures/MAC_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/Armory.lua", "lua/structures/Armory_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/Observatory.lua", "lua/structures/Observatory_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/Sentry.lua", "lua/structures/Sentry_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/SentryBattery.lua", "lua/structures/SentryBattery_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/PhaseGate.lua", "lua/structures/PhaseGate_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/InfantryPortal.lua", "lua/structures/InfantryPortal_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/RoboticsFactory.lua", "lua/structures/RoboticsFactory_Siege22.lua", "post" ) 
ModLoader.SetupFileHook( "lua/Crag.lua", "lua/structures/Crag_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/Whip.lua", "lua/structures/Whip_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/Shift.lua", "lua/structures/Shift_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/Shade.lua", "lua/structures/Shade_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/Hydra.lua", "lua/structures/Hydra_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/Hive.lua", "lua/structures/Hive_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/TunnelEntrance.lua", "lua/structures/TunnelEntrance_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/SentryBattery.lua", "lua/structures/SentryBattery_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/ArmsLab.lua", "lua/structures/ArmsLab_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/PowerPoint.lua", "lua/structures/PowerPoint_Siege22.lua", "post" ) 



-------------------------Commander----------------------
ModLoader.SetupFileHook( "lua/AlienCommander.lua", "lua/AlienCommander_Siege22.lua", "post" )


-------------Tech---------Keep this way on bottum to load last
ModLoader.SetupFileHook( "lua/TechTreeButtons.lua", "lua/TechTreeButtons_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/TechTreeConstants.lua", "lua/TechTreeConstants_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/TechData.lua", "lua/TechData_Siege22.lua", "post" ) 
ModLoader.SetupFileHook( "lua/TechNode.lua", "lua/TechNode_Siege.lua", "post" )


----------AutoComm--------------
ModLoader.SetupFileHook( "lua/bots/CommanderBot.lua", "lua/bots/CommanderBot_Siege21.lua", "post" )
ModLoader.SetupFileHook( "lua/bots/CommanderBrain.lua", "lua/bots/CommanderBrain_Siege21.lua", "post" )
ModLoader.SetupFileHook( "lua/bots/PlayerBrain.lua", "lua/bots/PlayerBrain_Siege21.lua", "post" )
ModLoader.SetupFileHook( "lua/bots/VoteManager.lua", "lua/bots/VoteManager_Siege21.lua", "post" )
ModLoader.SetupFileHook( "lua/VotingAddCommanderBots.lua", "lua/VotingAddCommanderBots_Siege22.lua", "post" )
ModLoader.SetupFileHook( "lua/bots/AlienCommanderBrain.lua", "lua/bots/AlienCommanderBrain_Siege21.lua", "replace" )
ModLoader.SetupFileHook( "lua/bots/MarineCommanderBrain.lua", "lua/bots/MarineCommanderBrain_Siege21.lua", "replace" )
ModLoader.SetupFileHook( "lua/bots/MarineCommanderBrain_Data.lua", "lua/bots/MarineCommanderBrain_Data_Siege21.lua", "replace" )
ModLoader.SetupFileHook( "lua/bots/AlienCommanderBrain_Data.lua", "lua/bots/AlienCommanderBrain_Data_Siege21.lua", "replace" )

--Avoca Spectator Director
ModLoader.SetupFileHook( "lua/Spectator.lua", "lua/Spectator_Avoca.lua", "post" )
