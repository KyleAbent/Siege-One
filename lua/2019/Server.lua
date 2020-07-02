Script.Load("lua/2019/Shared.lua")

function LoadPathing(mapName, groupName, values)


    if mapName == "nav_point" then
        Pathing.AddFillPoint(values.origin) 
    end


end
Event.Hook("MapLoadEntity", LoadPathing)