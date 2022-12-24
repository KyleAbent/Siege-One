Script.Load("lua/Additions/LevelsMixin.lua")
Script.Load("lua/Additions/AvocaMixin.lua")
Script.Load("lua/2019/Con_Vars.lua")


local networkVars = {}


AddMixinNetworkVars(LevelsMixin, networkVars)
AddMixinNetworkVars(AvocaMixin, networkVars)

local origIinit = Shift.OnInitialized
function Shift:OnInitialized()
    origIinit(self)
    InitMixin(self, AvocaMixin)
    InitMixin(self, LevelsMixin)
    self.manageShiftsTime = 0
end


if Server then 

    function Shift:OnConstructionComplete()
        GetImaginator().activeShifts = GetImaginator().activeShifts + 1;  
    end


    function Shift:PreOnKill(attacker, doer, point, direction)

        if self:GetIsBuilt() then
            GetImaginator().activeShifts  = GetImaginator().activeShifts- 1;  
        end
    end

    function Shift:OnOrderComplete(currentOrder)
        if currentOrder == kTechId.Move then 
            doChain(self)
        end
    end

end


function Shift:GetCanTeleportOverride()
    if GetIsImaginatorAlienEnabled() then
        return not self:GetIsInCombat()
     else
        return true
    end
end

function Shift:ManageShifts()

    if self:GetCanTeleport() then
        local destination = findDestinationForAlienConst(self)
        if destination then
            self:TriggerTeleport(5, self:GetId(), FindFreeSpace(destination:GetOrigin(), 4), 0)
            local notNearCyst = #GetEntitiesWithinRange("LoneCyst",self:GetOrigin(), kCystRedeployRange-1) == 0
            if notNearCyst then
                --local csyt = CreateEntity(LoneCyst.kMapName, FindFreeSpace(entity:GetOrigin(), 1, kCystRedeployRange),2)
                CreateEntity(LoneCyst.kMapName, FindFreeSpace(self:GetOrigin(), 1, kCystRedeployRange),2)
            end
            return
        end
    end
    
end

local origUpdate = Shift.OnUpdate 

function Shift:OnUpdate(deltaTime)
    origUpdate(self,deltaTime)
     if Server then
        if self.manageShiftsTime + kManageShiftsInterval <= Shared.GetTime() then
            if GetIsImaginatorAlienEnabled() and GetConductor():GetIsShiftMovementAllowed() then
                self:ManageShifts()
                 GetConductor():JustMovedShiftSetTimer()
            end
            self.manageShiftsTime = Shared.GetTime()
        end
     end
        
end

Shared.LinkClassToMap("Shift", Shift.kMapName, networkVars)


--------------------
Script.Load("lua/InfestationMixin.lua")

class 'ShiftAvoca' (Shift)
ShiftAvoca.kMapName = "shiftavoca"

local networkVars = {}

AddMixinNetworkVars(LevelsMixin, networkVars)
AddMixinNetworkVars(AvocaMixin, networkVars)
AddMixinNetworkVars(InfestationMixin, networkVars)
function ShiftAvoca:GetInfestationRadius()
    return 1
end
    function ShiftAvoca:OnInitialized()
     Shift.OnInitialized(self)
       InitMixin(self, InfestationMixin)
         InitMixin(self, LevelsMixin)
        InitMixin(self, AvocaMixin)
        self:SetTechId(kTechId.Shift)
    end
    function ShiftAvoca:OnOrderGiven()
   if self:GetInfestationRadius() ~= 0 then self:SetInfestationRadius(0) end
end
        function ShiftAvoca:GetTechId()
         return kTechId.Shift
    end
   function ShiftAvoca:OnGetMapBlipInfo()
    local success = false
    local blipType = kMinimapBlipType.Undefined
    local blipTeam = -1
    local isAttacked = HasMixin(self, "Combat") and self:GetIsInCombat()
    blipType = kMinimapBlipType.Shift
     blipTeam = self:GetTeamNumber()
    if blipType ~= 0 then
        success = true
    end
    
    return success, blipType, blipTeam, isAttacked, false --isParasited
end
    function ShiftAvoca:GetMaxLevel()
    return kAlienDefaultLvl
    end
    function ShiftAvoca:GetAddXPAmount()
    return kAlienDefaultAddXp
    end

Shared.LinkClassToMap("ShiftAvoca", ShiftAvoca.kMapName, networkVars)