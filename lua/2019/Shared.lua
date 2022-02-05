Script.Load("lua/doors/Doors.lua")
Script.Load("lua/doors/BreakableDoor.lua")
Script.Load("lua/doors/timer.lua")
Script.Load("lua/2019/Functions19.lua")
Script.Load("lua/2019/AntiExploit.lua")
Script.Load("lua/2019/EEM/PushTrigger.lua")
Script.Load("lua/2019/EEM/LogicBreakable.lua")
Script.Load("lua/2019/EEM/LogicMixin.lua")
Script.Load("lua/2019/EEM/PushTrigger.lua")
Script.Load("lua/2019/EEM/ScaledModelMixin.lua")
--Script.Load("lua/Weapons/Marine/ExoGrenade.lua")
Script.Load("lua/Additions/LayStructures.lua")
Script.Load("lua/Modifications/Modifications.lua")
kAlienDefaultLvl = 25
kAlienDefaultAddXp = 0.25

function LoadPathing(mapName, groupName, values)


     if mapName == "tech_point" or mapName == "nav_point" then
        Pathing.AddFillPoint(values.origin) 
    end


end
Event.Hook("MapLoadEntity", LoadPathing)