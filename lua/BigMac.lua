--Kyle 'Avoca' Abent
Script.Load("lua/MAC.lua")
Script.Load("lua/ConstructMixin.lua")
Script.Load("lua/GhostStructureMixin.lua")
--Script.Load("lua/RecycleMixin.lua")
--Script.Load("lua/ResearchMixin.lua")


class 'BigMac' (MAC)

BigMac.kMapName = "bigmac"


MAC.kConstructRate = 0
MAC.kWeldRate = 0
MAC.kOrderScanRadius = 0
MAC.kRepairHealthPerSecond = 0
MAC.kMoveSpeed = 0
MAC.kInfestationMoveSpeed = 0
MAC.kHoverHeight = 0
MAC.kStartDistance = 0
MAC.kWeldDistance = 0
MAC.kBuildDistance = 0    // Distance at which bot can start building a structure. 

local networkVars =
{
}

AddMixinNetworkVars(ConstructMixin, networkVars)
AddMixinNetworkVars(ResearchMixin, networkVars)
AddMixinNetworkVars(RecycleMixin, networkVars)
AddMixinNetworkVars(GhostStructureMixin, networkVars)

function BigMac:OnCreate()
MAC.OnCreate(self)
InitMixin(self, ConstructMixin)
InitMixin(self, GhostStructureMixin)
InitMixin(self, ResearchMixin)
InitMixin(self, RecycleMixin)

end


function GetMacGhostGuides(commander)

    local RoboticsFactories = GetEntitiesForTeam("RoboticsFactory", commander:GetTeamNumber())
    local attachRange = 8 --LookupTechData(kTechId.BigMac, kStructureAttachRange, 1)
    local result = { }
    
    for _, RoboticsFactory in ipairs(RoboticsFactories) do
        if RoboticsFactory:GetIsBuilt() then --and same location?
            result[RoboticsFactory] = attachRange
        end
    end
    
    return result

end

function GetCheckMacLimit(techId, origin, normal, commander)
    local macs = 0
        for index, mac in ientitylist(Shared.GetEntitiesWithClassname("MAC")) do
                macs = macs + 1 
         end
    return  macs < 1
    
end

function GetMacGhostGuides(commander)

    local RoboticsFactories = GetEntitiesForTeam("RoboticsFactory", commander:GetTeamNumber())
    local attachRange = LookupTechData(kTechId.BigMac, kStructureAttachRange, 1)
    local result = { }
    
    for _, RoboticsFactory in ipairs(RoboticsFactories) do
        if RoboticsFactory:GetIsBuilt() then
            result[RoboticsFactory] = attachRange -- same location?
        end
    end
    
    return resultd

end

function BigMac:OnConstructionComplete()
MAC.kConstructRate = 0.4 * 5
MAC.kWeldRate = 0.5 * 5
MAC.kOrderScanRadius = 12
MAC.kRepairHealthPerSecond = 50 * 5
MAC.kHealth = kMACHealth * 5
MAC.kArmor = kMACArmor * 5
MAC.kMoveSpeed = 6
MAC.kHoverHeight = 0.5
MAC.kStartDistance = 3
MAC.kWeldDistance = 2
MAC.kBuildDistance = 2 
end


local origB = MAC.GetTechButtons
function BigMac:GetTechButtons(techId)
    local btn = origB(self, techId)
    btn[8] = kTechId.Recycle
    return btn  
end



function BigMac:OnGetMapBlipInfo()

    local success = false
    local blipType = kMinimapBlipType.MAC
    local blipTeam = -1
    local isAttacked = HasMixin(self, "Combat") and self:GetIsInCombat()
    local isParasited = HasMixin(self, "ParasiteAble") and self:GetIsParasited()
    
    
        blipType = kMinimapBlipType.Door
        blipTeam = self:GetTeamNumber()
    
    return blipType, blipTeam, isAttacked, isParasited
end


Shared.LinkClassToMap("BigMac", BigMac.kMapName, networkVars)