/*

local origTryOne = LocationGraph.InitializeLocationCentroids
function LocationGraph:InitializeLocationCentroids()
    self:AddTimedCallback(function() origTryOne(self) print("InitializeLocationCentroids delay") end, 1)
end

local origTryTwo = LocationGraph.InitializeExplorePositions
function LocationGraph:InitializeExplorePositions()
    self:AddTimedCallback(function() origTryTwo(self) print("InitializeExplorePositions delay") end, 2)
end

local origTryThree = LocationGraph.InitializeDirectPaths
function LocationGraph:InitializeDirectPaths()
    self:AddTimedCallback(function() origTryThree(self) print("InitializeDirectPaths delay") end, 3)
end

local  origTryFour = LocationGraph.InitializeDirectPaths
function LocationGraph:InitializeDirectPaths()
    self:AddTimedCallback(function() origTryFour(self) print("InitializeDirectPaths delay") end, 4)
end

local  origTryFive = LocationGraph.InitializeExploreDepths
function LocationGraph:InitializeExploreDepths()
    self:AddTimedCallback(function() origTryFive(self) print("InitializeExploreDepths delay") end, 6)
end

local  origTrySix = LocationGraph.InitializeIncreasingPaths
function LocationGraph:InitializeIncreasingPaths()
    self:AddTimedCallback(function() origTrySix(self) print("InitializeIncreasingPaths delay") end, 7)
end

local origTrySeven = LocationGraph.InitializeTechpointNaturalRTLocations
function LocationGraph:InitializeTechpointNaturalRTLocations()
    self:AddTimedCallback(function() origTrySeven(self) print("InitializeTechpointNaturalRTLocations delay") end, 8)
end

*/