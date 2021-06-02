


local orig = Hive.OnCreate
function Hive:OnCreate()
orig(self)
    /*
    if Server then
    self.bioMassLevel = 4
    end
    */
end



if Server then

-- overwrite get rid of scale with player count

function Hive:UpdateSpawnEgg()

    local success = false
    local egg

    local eggCount = self:GetNumEggs()
    if eggCount < kAlienEggsPerHive then

        egg = self:SpawnEgg()
        success = egg ~= nil

    end

    return success, egg

end

function Hive:HatchEggs() --overwrite get rid of scaleplayer
    local amountEggsForHatch = kEggsPerHatch
    local eggCount = 0
    for i = 1, amountEggsForHatch do
        local egg = self:SpawnEgg(true)
        if egg then eggCount = eggCount + 1 end
    end

    if eggCount > 0 then
        self:TriggerEffects("hatch")
        return true
    end

    return false
end

function Hive:GetNumEggs() --Well all 3 hives in same location, and if each hive is suppose to have X eggs then assign them the hive id via egg

    local numEggs = 0
    local eggs = GetEntitiesForTeam("Egg", self:GetTeamNumber())

    for index, egg in ipairs(eggs) do

        if self == egg:GetHive() and egg:GetIsAlive() and egg:GetIsFree() and not egg.manuallySpawned then
            numEggs = numEggs + 1
        end

    end

    return numEggs

end

    /*
    local orig = Hive.OnConstructionComplete
    function Hive:OnConstructionComplete()
        orig(self)
        self.bioMassLevel = 4
    end
    */
    

end --server


