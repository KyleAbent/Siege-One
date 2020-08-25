Script.Load("lua/ARC.lua")
Script.Load("lua/ConstructMixin.lua")
Script.Load("lua/GhostStructureMixin.lua")


class 'DropARC' (ARC)

DropARC.kMapName = "droparc"


local networkVars =
{
}

AddMixinNetworkVars(ConstructMixin, networkVars)
AddMixinNetworkVars(ResearchMixin, networkVars)
AddMixinNetworkVars(RecycleMixin, networkVars)
AddMixinNetworkVars(GhostStructureMixin, networkVars)

function DropARC:OnCreate()
ARC.OnCreate(self)
InitMixin(self, ConstructMixin)
InitMixin(self, GhostStructureMixin)
InitMixin(self, ResearchMixin)
InitMixin(self, RecycleMixin) 
end



function GetCheckArcLimit(techId, origin, normal, commander)
    local arcs = 0
        for index, arc in ientitylist(Shared.GetEntitiesWithClassname("ARC")) do
                arcs = arcs + 1 
         end
    return  arcs < 12--kArcLimit
    
end

function GetArcGhostGuides(commander)

    local RoboticsFactories = GetEntitiesForTeam("ARCRoboticsFactory", commander:GetTeamNumber())
    local attachRange = LookupTechData(kTechId.BigMac, kStructureAttachRange, 1)
    local result = { }
    
    for _, RoboticsFactory in ipairs(RoboticsFactories) do
        if RoboticsFactory:GetIsBuilt() then
            result[RoboticsFactory] = attachRange -- same location?
        end
    end
    
    return resultd

end

function DropARC:OnConstructionComplete()
    --give order deploy
     self:SetMode(ARC.kMode.Stationary)
     self:GiveOrder(kTechId.ARCDeploy, self:GetId(), self:GetOrigin(), nil, true, true)
end


local origB = DropARC.GetTechButtons
function DropARC:GetTechButtons(techId)
    local btn = origB(self, techId)
    btn[1] = kTechId.Attack
    btn[2] = kTechId.None
    btn[3] = kTechId.None
    btn[5] = kTechId.None
    btn[6] = kTechId.None
    btn[8] = kTechId.Recycle
    return btn  
end



/*
local origCanFire = ARC.GetCanFireAtTarget
function ARC:GetCanFireAtTarget(target, targetPoint) 

    if not GetSetupConcluded() then
        return false
    else
        return origCanFire(self,target,targetPoint)
    end
    
end
 */



function DropARC:OnOverrideOrder(order)
    local orderType = order:GetType()
    if orderType == kTechId.Default then
        if self.deployMode == ARC.kDeployMode.Deployed then
            order:SetType(kTechId.Attack)
        else
            notifycommander(self,kTechId.DropArc,kTechId.Move)
            order:SetType(kTechId.Default)
        end
    elseif orderType == kTechId.ARCUndeploy or orderType == kTechId.Move or orderType == kTechId.Stop then
            notifycommander(self,kTechId.DropArc,orderType)
            order:SetType(kTechId.Default)
    end
end


function DropARC:GetMapBlipType()
    return kMinimapBlipType.ARC
end

function DropARC:OnGetMapBlipInfo()

    local success = false
    local blipType = kMinimapBlipType.ARC
    local blipTeam = self:GetTeamNumber()
    local isAttacked = HasMixin(self, "Combat") and self:GetIsInCombat()
    local isParasited = HasMixin(self, "ParasiteAble") and self:GetIsParasited()
    
    
        --blipType = kMinimapBlipType.ARC
        --blipTeam = self:GetTeamNumber()
    
    return true, blipType, blipTeam, isAttacked, isParasited
end

Shared.LinkClassToMap("DropARC", DropARC.kMapName, networkVars, true)



if Server then
local origrules = ARC.AcquireTarget
    function ARC:AcquireTarget() 
        local canfire = GetSetupConcluded()
        --Print("Arc can fire is %s", canfire)
            if not canfire then
                return 
            end
            
        return origrules(self)
    end
 end
