Script.Load("lua/2019/Shared.lua")

function LoadPathing(mapName, groupName, values)


    if mapName == "tech_point" or mapName == "nav_point" then
        Pathing.AddFillPoint(values.origin) 
    end


end
Event.Hook("MapLoadEntity", LoadPathing)