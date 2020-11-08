

local function HealSelf(self)

        self:SetArmor(self:GetArmor() + 10, true) 
        self:SetHealth(self:GetHealth() + 10, true)
    return true
end


local origCreate = MAC.OnCreate 

function MAC:OnCreate()
    origCreate(self)
    self:AddTimedCallback(function() HealSelf(self) return true end, 1) 
    kMACConstructEfficacy = .3 * 2
    MAC.kConstructRate = 0.37 -- 10
    MAC.kWeldRate = 0.45 --* 5
    MAC.kOrderScanRadius = 12
    MAC.kRepairHealthPerSecond = 75 --50 * 5
    --MAC.kHealth = kMACHealth * 5
    --MAC.kArmor = kMACArmor * 5
    MAC.kMoveSpeed = 7
    MAC.kHoverHeight = 0.5
    MAC.kStartDistance = 3
    MAC.kWeldDistance = 2
    MAC.kBuildDistance = 2 
end


function MAC:OnOrderComplete(currentOrder)

if self.autoReturning or currentOrder:GetType() == kTechId.Move then
    if self.autoReturning then
        self.leashedPosition = nil
        self.autoReturning = false
    end
 end   
 
     if currentOrder:GetType() == kTechId.Move then
        if Server then    

            if (   GetIsInSiege(self)    and not GetTimer():GetIsSiegeOpen() ) then
                self:Kill() 
            end


        end
    end
    
end