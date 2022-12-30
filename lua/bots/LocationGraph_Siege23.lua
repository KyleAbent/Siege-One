--Overriding to try and fix server crash
function LocationGraph:Initialize()

    PROFILE("LocationGraph:Initialize")

    -- Location Name (From) -> UnorderedSet of directly connected location names (Destinations)
    self.locationDirectPaths = IterableDict()

    -- Location Name (Source) -> IterableDict (Directly Connected Location -> Gateway point)
    self.locationGateways = IterableDict()

    -- Location Name -> Position of center of location group (location entities of same name)
    self.locationCentroids = IterableDict()

    -- <Start Location>_<Dest Location> -> Distance between gateways
    -- A->B == B->A
    self.locationGatewayDistances = IterableDict()

    -- Location Name -> Position to go to for exploring
    self.locationExplorePositions = IterableDict()

    -- Location Names
    self.techPointLocations = UnorderedSet()

    -- Can also be tech point locations
    self.resourcePointLocations = UnorderedSet()

    -- TechPoint Location Name -> UnorderedSet<Natural RT Locations>
    self.techPointLocationsNaturals = IterableDict()

    -- Location Name -> Table of data for determining "safer" building placements
    self.techPointsSafePlacementData = IterableDict()

    -- Location Name (As Starting Point) -> IterableDict (Location Name -> Depth from starting point)
    self.exploreDepths = IterableDict()

    -- Location Name (From) -> UnorderedSet of increasing paths.
    -- Set key (path): <source>_<dest>
    -- Increasing path is where the dest location has a connection that is also deeper than the dest.
    self.increasingPaths = IterableDict()

    if #GetLocations() > 0 then

            --Siege override here
            GetGamerules():DoDelayedStuff(self)

    else

        Print("Warning: No location entities on map! LocationGraph will be empty, and bots won't work!")

    end

end