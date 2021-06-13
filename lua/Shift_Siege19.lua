Script.Load("lua/2019/Con_Vars.lua")

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
            local notNearCyst = #GetEntitiesWithinRange("Cyst",self:GetOrigin(), kCystRedeployRange-1) == 0
            if notNearCyst then
                local csyt = CreateEntity(LoneCyst.kMapName, FindFreeSpace(entity:GetOrigin(), 1, kCystRedeployRange),2)
            end
            return
        end
    end
    
end

local origUpdate = Shift.OnUpdate 

function Shift:OnUpdate(deltaTime)
    origUpdate(self,deltaTime)
     if Server then
        if not self.manageShiftsTime or self.manageShiftsTime + kManageShiftsInterval <= Shared.GetTime() then
            if GetIsImaginatorAlienEnabled() and GetConductor():GetIsShiftMovementAllowed() then
                self:ManageShifts()
                 GetConductor():JustMovedShiftSetTimer()
            end
            self.manageShiftsTime = Shared.GetTime()
        end
     end
        
end