//class 'KingCyst' (Cyst)

local networkVars = {

    isKing = "boolean", 
    healingActive = "boolean",
  
 }
 
local orig = Cyst.OnCreate
function Cyst:OnCreate()
   orig(self)
   self.isKing = false
   self.healingActive = false
   if Server then
    self.timeOfLastHeal = 0
   end
end
local origInit = Cyst.OnInitialized
function Cyst:OnInitialized()
   origInit(self)
   if Server then//if built? bleh
    self:AdjustMaxHPOnTier()
   end
end
function Cyst:AdjustMaxHPOnTier()
        
        if GetHasTech(self, kTechId.QuadrupleCystHP) then
            self:AdjustMaxHealth(4 * kMatureCystHealth)
        elseif GetHasTech(self, kTechId.TripleCystHP) then
            self:AdjustMaxHealth(3 * kMatureCystHealth)
        elseif GetHasTech(self, kTechId.DoubleCystHP) then
            self:AdjustMaxHealth(2 * kMatureCystHealth)
        end
        
        if GetHasTech(self, kTechId.QuadrupleCystArmor) then
            self:AdjustMaxArmor(4 * 50)
        elseif GetHasTech(self, kTechId.TripleCystArmor) then
            self:AdjustMaxArmor(3 * 50)
        elseif GetHasTech(self, kTechId.DoubleCystArmor) then
            self:AdjustMaxArmor(2 * 50)
        else
            self:AdjustMaxArmor(50)
        end
        
        return false
end
function Cyst:GetCanSleep()
    return not self.healingActive 
end    
function Cyst:TimeUp()
    self.isKing = false
end

function Cyst:Throne()
    self.isKing = true
    if Server then
        self:AddTimedCallback( self.TimeUp, 29 )
     end
end


function Cyst:OnAdjustModelCoords(modelCoords)
    local num = 1
    if self.isKing then
        num = 4
     end
    modelCoords.xAxis = modelCoords.xAxis * num
    modelCoords.yAxis = modelCoords.yAxis * num
    modelCoords.zAxis = modelCoords.zAxis * num

    return modelCoords
end

function Cyst:UpdateHealing()    
    if not self:GetIsOnFire() and ( self.timeOfLastHeal == 0 or (Shared.GetTime() > self.timeOfLastHeal + 2) ) then    
        self:PerformHealing()
    end
end
function Cyst:GetHealTargets()

    local targets = {}

    for _, healable in ipairs(GetEntitiesWithMixinForTeamWithinRange("Live", self:GetTeamNumber(), self:GetOrigin(), 14)) do
        if healable:GetIsAlive() then
            table.insert(targets, healable)
        end
    end

    return targets

end
function Cyst:PerformHealing()

    PROFILE("Cyst:PerformHealing")

    local targets = self:GetHealTargets()

    local totalHealed = 0
    for _, target in ipairs(targets) do
        totalHealed = totalHealed + self:TryHeal(target)
    end

    if #targets > 0 and totalHealed > 0 then
        self.timeOfLastHeal = Shared.GetTime()
    end

    if totalHealed == 0 then
        self.timeOfLastHeal = 0
    end

end
function Cyst:TryHeal(target)
    //3x Stronger than Single Crag 
    local unclampedHeal = target:GetMaxHealth() * (0.042 * 3)
    local heal = Clamp(unclampedHeal, 7*3, 42*3)
    
    
    if target:GetHealthScalar() ~= 1 then
    
        local amountHealed = target:AddHealth(heal, false, false, false, self)
        //target.timeLastCragHeal = Shared.GetTime()
        return amountHealed
        
    else
        return 0
    end
    
end
if Client then

local origUpdate = Cyst.OnUpdate

function Cyst:OnUpdate(deltaTime)
    origUpdate(self,deltaTime)
    if self.isKing then
        if self.healingActive then
            if not self.lastHealEffect or self.lastHealEffect + 1 < Shared.GetTime() then

                local localPlayer = Client.GetLocalPlayer()
                local showHeal = not HasMixin(self, "Cloakable") or not self:GetIsCloaked() or not GetAreEnemies(self, localPlayer)

                if showHeal then

                    if self.healingActive then
                        self:TriggerEffects("crag_heal")
                    end

                end

            self.lastHealEffect = Shared.GetTime()

            end
        end
    end
end

end
if Server then

    local origKill = Cyst.OnKill
    function Cyst:OnKill()
        if self.isKing then
            GetTimer():OldKingCystDied()
        end
        origKill(self)
    end
local origUpdate = Cyst.OnUpdate

function Cyst:OnUpdate(deltaTime)
    origUpdate(self,deltaTime)
    if self.isKing then
        if GetIsUnitActive(self) then
            self:UpdateHealing()
            self.healingActive = Shared.GetTime() < self.timeOfLastHeal + 2 and self.timeOfLastHeal > 0
        end
    end
end

end

Shared.LinkClassToMap("Cyst", Cyst.kMapName, networkVars, true)