------------------------------------------
--
------------------------------------------

Script.Load("lua/bots/CommanderBrain.lua")
Script.Load("lua/bots/AlienCommanderBrain_Data.lua")
Script.Load("lua/bots/BotDebug.lua")

gBotDebug:AddBoolean("kham")

gAlienCommanderBrains = {}

------------------------------------------
--
------------------------------------------
class 'AlienCommanderBrain' (CommanderBrain)

function AlienCommanderBrain:Initialize()

    CommanderBrain.Initialize(self)
    table.insert( gAlienCommanderBrains, self )

    self.structuresInDanger = {}
end

function AlienCommanderBrain:GetExpectedPlayerClass()
    return "AlienCommander"
end

function AlienCommanderBrain:GetExpectedTeamNumber()
    return kAlienTeamType
end

function AlienCommanderBrain:GetActions()
    return kAlienComBrainActions
end

function AlienCommanderBrain:GetSenses()
    return self.senses
end

function AlienCommanderBrain:Update(bot, move)
    PROFILE("AlienCommanderBrain:Update")


end
