Script.Load("lua/Additions/LevelsMixin.lua")
Script.Load("lua/Additions/AvocaMixin.lua")

local networkVars = {}

AddMixinNetworkVars(LevelsMixin, networkVars)
AddMixinNetworkVars(AvocaMixin, networkVars)

local origInit = MAC.OnInitialized
function MAC:OnInitialized()
    origInit(self)
    InitMixin(self, LevelsMixin)
    InitMixin(self, AvocaMixin)
    self.manageMacTime = 0
end

Script.Load("lua/2019/Con_Vars.lua")


local origUpdate = MAC.OnUpdate 

function MAC:OnUpdate(deltaTime)
    origUpdate(self,deltaTime)
    
    if Server then
        if self.manageMacTime + kManageMacInterval <= Shared.GetTime() then
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
        --SetDirectorLockedOnEntity(who)
    end
end

local function ManagePowerMac(who, where)
    print("ManagePowerMac")
    local power =  GetNearest(who:GetOrigin(), "Powerpoint", 1, function(ent) return not ent:GetIsBuilt() and not GetIsInSiege(ent) end) //Not in siege and siege not open .. for not just not siege.
    if power then
        print("ManagePowerMac found power")
        who:GiveOrder(kTechId.Move, nil, FindFreeSpace(power:GetOrigin(),4), nil, true, true)
        --SetDirectorLockedOnEntity(who)
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

Shared.LinkClassToMap("MAC", MAC.kMapName, networkVars)
    
----------------------
Script.Load("lua/ConstructMixin.lua")

class 'MACCredit' (MAC)
MACCredit.kMapName = "maccredit"


local networkVars = {} --fuckbitchz
AddMixinNetworkVars(ConstructMixin, networkVars)

local origmac  = MAC.OnCreate
function MACCredit:OnCreate()


origmac(self)
InitMixin(self, ConstructMixin)

end

function MACCredit:OnConstructionComplete()
local nearestplayer = GetNearest(self:GetOrigin(), "Marine", 1, function(ent) return ent:GetIsAlive() and ent:GetArmorScalar() < 1 end)
  if nearestplayer then
   self:ProcessFollowAndWeldOrder(Shared.GetTime(), nearestplayer, nearestplayer:GetOrigin()) 
   end
 end
 function MACCredit:OnGetMapBlipInfo()
    local success = false
    local blipType = kMinimapBlipType.Undefined
    local blipTeam = -1
    local isAttacked = HasMixin(self, "Combat") and self:GetIsInCombat()
    blipType = kMinimapBlipType.MAC
     blipTeam = self:GetTeamNumber()
    if blipType ~= 0 then
        success = true
    end
    
    return success, blipType, blipTeam, isAttacked, false --isParasited
end
  
    Shared.LinkClassToMap("MACCredit", MACCredit.kMapName, networkVars)