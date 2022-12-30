if Server then

    function Gamerules:DoDelayedStuff(who)
        print("Noice")
        self:AddTimedCallback(function() who:InitializeLocationCentroids() print("InitializeLocationCentroids delay") end, 1)
        self:AddTimedCallback(function() who:InitializeExplorePositions() print("InitializeExplorePositions delay") end, 2)
        self:AddTimedCallback(function() who:InitializeDirectPaths() print("InitializeDirectPaths delay") end, 3)
        self:AddTimedCallback(function() who:InitializeGatewayDistances() print("InitializeGatewayDistances delay") end, 4)
        self:AddTimedCallback(function() who:InitializeExploreDepths() print("InitializeExploreDepths delay") end, 5)
        self:AddTimedCallback(function() who:InitializeIncreasingPaths() print("InitializeIncreasingPaths delay") end, 6)
        self:AddTimedCallback(function() who:InitializeTechpointNaturalRTLocations() print("InitializeTechpointNaturalRTLocations delay") end, 7)
    end


end