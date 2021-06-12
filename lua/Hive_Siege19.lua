local networkVars = {

isInsured = "boolean", 
  
 }


local orig = Hive.OnCreate
function Hive:OnCreate()
orig(self)
    self.isInsured = false
end

local origButtons = Hive.GetTechButtons
function Hive:GetTechButtons(techId)

    local techButtons = origButtons(self, techId)
    local attached = self:GetAttached()
    if not self.isInsured and (attached and not attached:isa("AlienTechPoint") )then //AlienTechPoint can die. no insurance here.
        techButtons[3] = kTechId.HiveLifeInsurance
    end
    
    return techButtons
    
    
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

function Hive:Insure(who)
    self.isInsured = true
end

function Hive:NotInsure(who)
    self.isInsured = false
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

    local ogResearch = Hive.OnResearchComplete
    function Hive:OnResearchComplete(researchId)
         
         --Prevent two hives from having the same type
         if  researchId ==  kTechId.UpgradeToCragHive then
            if GetHasHiveType(kTechId.CragHive) then
                self:SetTechId(kTechId.Hive) 
                return 
            end
         elseif researchId == kTechId.UpgradeToShiftHive then
            if GetHasHiveType(kTechId.ShiftHive) then 
                self:SetTechId(kTechId.Hive) 
                return 
            end
         elseif researchId == kTechId.UpgradeToShadeHive then
            if GetHasHiveType(kTechId.ShadeHive) then 
                self:SetTechId(kTechId.Hive) 
                return 
            end
         end
         ogResearch(self, researchId)
         
         
         if researchId == kTechId.HiveLifeInsurance then
            if math.random(1,100) <= 30 then
               self:Insure(self)
            else
                self:NotInsure(self)
            end
         end

    end
    /*
    local orig = Hive.OnConstructionComplete
    function Hive:OnConstructionComplete()
        orig(self)
        self.bioMassLevel = 4
    end
    */
    

end --server

function Hive:TriggerInsurance(who)
    self.isInsured = false
    self:AddHealth(self:GetMaxHealth() * .45)
    self:AddArmor(self:GetMaxArmor() * .5)
end

function Hive:GetCanDieOverride()
    if self.isInsured then
        self:TriggerInsurance(self)
    else
        return not self.isInsured
    end
end

if Server then
    //local origKill = LiveMixin.OnKill 
    function Hive:OnKill(attacker, doer, point, direction) 
        if  self.isInsured then
                if attacker and attacker:isa("Player")  then //or attack parent is a player? bleh
                    local points = self:GetPointValue()
                        attacker:AddScore(points)
                end 
            self:TriggerInsurance(self)
            return
        else
            //origKill(self,attacker, doer, point, direction)
            //LiveMixin.OnKill(self, attacker, doer, point, direction) 
            CommandStructure.OnKill(self, attacker, doer, point, direction)
        end
    end
 end

Shared.LinkClassToMap("Hive", Hive.kMapName, networkVars, true)