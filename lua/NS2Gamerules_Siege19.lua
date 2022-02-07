function NS2Gamerules:DisplayFront()

end

function NS2Gamerules:DisplaySiege()

end

function NS2Gamerules:DisplaySide()

end

if Server then

    local origPostLoad = NS2Gamerules.OnMapPostLoad
    function NS2Gamerules:OnMapPostLoad()
        origPostLoad(self)
        Server.CreateEntity(Timer.kMapName)
        Print("Timer Created")
    end

end

