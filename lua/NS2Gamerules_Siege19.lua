function NS2Gamerules:DisplayFront()

end

function NS2Gamerules:DisplaySiege()

end

function NS2Gamerules:DisplaySide()

end

if Server then

    --local origPostLoad = NS2Gamerules.OnMapPostLoad
    function NS2Gamerules:OnMapPostLoad()
        --origPostLoad(self)
        --Override to fix bugs?
        Gamerules.OnMapPostLoad(self)
        
        -- Now allow script actors to hook post load
        local allScriptActors = Shared.GetEntitiesWithClassname("ScriptActor")
        for _, scriptActor in ientitylist(allScriptActors) do
            scriptActor:OnMapPostLoad()
        end

        -- Initialize Location Graph for AI
        --GetLocationGraph() 
        self:AddTimedCallback(function() GetLocationGraph() print("GetLocationgraph delay") end, 1)
        Server.CreateEntity(Timer.kMapName)
        Print("Timer Created")
    end

end

