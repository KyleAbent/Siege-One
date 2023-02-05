Script.Load("lua/Additions/LevelsMixin.lua")
Script.Load("lua/Additions/AvocaMixin.lua")
Script.Load("lua/2019/Con_Vars.lua")

local networkVars = {}


AddMixinNetworkVars(LevelsMixin, networkVars)
AddMixinNetworkVars(AvocaMixin, networkVars)

local origIinit = Shade.OnInitialized
function Shade:OnInitialized()
    origIinit(self)
    InitMixin(self, AvocaMixin)
    InitMixin(self, LevelsMixin)
    self.manageShadeTime = 0
    if Server then
        GetImaginator().activeShades = GetImaginator().activeShades + 1;  
    end    
end



if Server then

    local origCons = Shade.OnConstructionComplete
    function Shade:OnConstructionComplete()
        origCons(self)
    end

    function Shade:PreOnKill(attacker, doer, point, direction)
            GetImaginator().activeShades  = GetImaginator().activeShades- 1;  
    end
end

function Shade:ManageShades()


    /////////////During Setup/////////////////////////////////////////

    if not GetSiegeDoorOpen() then 

    end
    
    ////////////During Front Open//////////////////////////////////////
    if GetFrontDoorOpen() then //Manage ShadeInk
           //Maybe better to have the origin of scan search for shades within radius
        if GetIsScanWithinRadius(self:GetOrigin()) and GetConductor():GetIsInkAllowed() then
            CreateEntity(ShadeInk.kMapName, self:GetOrigin() + Vector(0, 0.2, 0), 2)
            self:TriggerEffects("shade_ink")
            GetConductor():JustInkedNowSetTimer()
        end
    end


   /////////////////////During Siege////////////////////////////////////////
    if not GetSiegeDoorOpen() then return end//for now just during siege

        local hive = GetRandomHive()
        if self.moving then
            return 
        end
        if not GetIsPointWithinHiveRadius(self:GetOrigin()) then
            local hive = GetRandomHive()
            if hive then
                self:GiveOrder(kTechId.Move, hive:GetId(), FindFreeSpace(hive:GetOrigin(), 4), nil, false, false) 
            end
        end
    
    
end

local origUpdate = Shade.OnUpdate 

function Shade:OnUpdate(deltaTime)
    origUpdate(self,deltaTime)
     if Server then
        if self.manageShadeTime + kManageShadeInterval <= Shared.GetTime() then
            if GetIsImaginatorAlienEnabled() and GetConductor():GetIsShadeMovementAllowed() then
                self:ManageShades()
                 GetConductor():JustMovedShadeSetTimer()
            end
              self.manageShadeTime = Shared.GetTime()
        end
     end
        
end


function Shade:GetCanTeleportOverride()
    if GetIsImaginatorAlienEnabled() then
        return not self:GetIsInCombat()
     else
        return true
    end
end

Shared.LinkClassToMap("Shade", Shade.kMapName, networkVars)


-------------------------
Script.Load("lua/InfestationMixin.lua")

class 'ShadeAvoca' (Shade)
ShadeAvoca.kMapName = "shadeavoca"

local networkVars = {}

AddMixinNetworkVars(LevelsMixin, networkVars)
AddMixinNetworkVars(AvocaMixin, networkVars)
AddMixinNetworkVars(InfestationMixin, networkVars)
function ShadeAvoca:GetInfestationRadius()
    return 1
end

    function ShadeAvoca:OnInitialized()
     Shade.OnInitialized(self)
       InitMixin(self, InfestationMixin)
        InitMixin(self, LevelsMixin)
        InitMixin(self, AvocaMixin)
        self:SetTechId(kTechId.Shade)
    end
    function ShadeAvoca:OnOrderGiven()
   if self:GetInfestationRadius() ~= 0 then self:SetInfestationRadius(0) end
end
        function ShadeAvoca:GetTechId()
         return kTechId.Shade
    end
   function ShadeAvoca:OnGetMapBlipInfo()
    local success = false
    local blipType = kMinimapBlipType.Undefined
    local blipTeam = -1
    local isAttacked = HasMixin(self, "Combat") and self:GetIsInCombat()
    blipType = kMinimapBlipType.Shade
     blipTeam = self:GetTeamNumber()
    if blipType ~= 0 then
        success = true
    end
    
    return success, blipType, blipTeam, isAttacked, false --isParasited
end
    function ShadeAvoca:GetMaxLevel()
    return kAlienDefaultLvl
    end
    function ShadeAvoca:GetAddXPAmount()
    return kAlienDefaultAddXp
    end
    
Shared.LinkClassToMap("ShadeAvoca", ShadeAvoca.kMapName, networkVars)