Script.Load("lua/2019/Con_Vars.lua")


local origUpdate = MAC.OnUpdate 

function MAC:OnUpdate(deltaTime)
    origUpdate(self,deltaTime)
    
    if Server then
        if not self.manageMacTime or self.manageMacTime + kManageMacInterval <= Shared.GetTime() then
            if GetIsImaginatorMarineEnabled() and GetConductor():GetIsMacMovementAllowed() then
                self:ManageMacs()
                GetConductor():JustMovedMacSetTimer()
            end
            self.manageMacTime = Shared.GetTime()
        end
    end
        
end


local function ManagePlayerWeld(who, where)
    local player =  GetNearest(who:GetOrigin(), "Marine", 1, function(ent) return ent:GetIsAlive() end)
    if player then
        who:GiveOrder(   kTechId.FollowAndWeld, player:GetId(), player:GetOrigin(), nil, false, false)
        SetDirectorLockedOnEntity(who)
    end
end

local function ManagePowerMac(who, where)
    print("ManagePowerMac")
    local power =  GetNearest(who:GetOrigin(), "Powerpoint", 1, function(ent) return not ent:GetIsBuilt() and not GetIsInSiege(ent) end) //Not in siege and siege not open .. for not just not siege.
    if power then
        print("ManagePowerMac found power")
        who:GiveOrder(kTechId.Move, nil, FindFreeSpace(power:GetOrigin(),4), nil, true, true)
        SetDirectorLockedOnEntity(who)
    end
end


function MAC:ManageMacs()

    if not self:GetHasOrder() then
        local random = math.random(1,2)
        if random == 1 or isSetup then
            ManagePlayerWeld(self, self:GetOrigin())
        else
            ManagePowerMac(self, self:GetOrigin())
        end
    end
    
end

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