
 function Whip:GetCanFireAtTargetActual(target, targetPoint)    

    if target:isa("BreakableDoor") and target.health == 0 then
    return false
    end
    
    return true
    
end


--Copying from gorgetunnel mod

-- CQ: EyePos seems to be somewhat hackish; used in several places but not owned anywhere... predates Mixins
function Whip:GetEyePos()
    return self:GetOrigin() + self:GetCoords().yAxis * 1.8 -- Vector(0, 1.8, 0)
end

Script.Load("lua/DigestMixin.lua")

class 'GorgeWhip' (Whip)

GorgeWhip.kMapName = "gorgewhip"
GorgeWhip.kMaxUseableRange = 6.5
local kDigestDuration = 1.5

local networkVars =
{
    ownerId = "entityid"
}

function GorgeWhip:OnCreate()
	Whip.OnCreate(self)	
    InitMixin(self, DigestMixin)
end

function GorgeWhip:GetUseMaxRange()
    return self.kMaxUseableRange
end

function GorgeWhip:GetMapBlipType()
    return kMinimapBlipType.Whip
end

function GorgeWhip:GetUnitNameOverride(viewer)
    
    local unitName = GetDisplayName(self)
    
    if not GetAreEnemies(self, viewer) and self.ownerId then
        local ownerName
        for _, playerInfo in ientitylist(Shared.GetEntitiesWithClassname("PlayerInfoEntity")) do
            if playerInfo.playerId == self.ownerId then
                ownerName = playerInfo.playerName
                break
            end
        end
        if ownerName then
            
            local lastLetter = ownerName:sub(-1)
            if lastLetter == "s" or lastLetter == "S" then
                return string.format( "%s' Whip", ownerName )
            else
                return string.format( "%s's Whip", ownerName )
            end
        end
    
    end
    
    return unitName

end

function GorgeWhip:GetTechButtons(techId)
    local techButtons = { kTechId.Slap, kTechId.None, kTechId.None, kTechId.None,
                        kTechId.None, kTechId.None, kTechId.None, kTechId.None }

    if self:GetIsMature() then
        techButtons[1] = kTechId.WhipBombard
    end
    
    return techButtons
    
end

if not Server then
    function GorgeWhip:GetOwner()
        return self.ownerId ~= nil and Shared.GetEntity(self.ownerId)
    end
end

-- CQ: Predates Mixins, somewhat hackish
function GorgeWhip:GetCanBeUsed(player, useSuccessTable)
    useSuccessTable.useSuccess = useSuccessTable.useSuccess and self:GetCanDigest(player)
end

function GorgeWhip:GetCanBeUsedConstructed()
    return true
end

function GorgeWhip:GetCanTeleportOverride()
    return false
end

function GorgeWhip:GetCanConsumeOverride()
    return false
end

function GorgeWhip:GetCanReposition()
    return false
end

function GorgeWhip:GetCanDigest(player)
    return player == self:GetOwner() and player:isa("Gorge") and (not HasMixin(self, "Live") or self:GetIsAlive())
end

function GorgeWhip:GetDigestDuration()
    return kDigestDuration
end

function GorgeWhip:OnOverrideOrder(order)
	order:SetType(kTechId.Default)
end

function GorgeWhip:OnDestroy()
    AlienStructure.OnDestroy(self)
    if Server then
		local team = self:GetTeam()
        if team then
            team:UpdateClientOwnedStructures(self:GetId())
        end	

		local player = self:GetOwner()
		if player then
			if (self.consumed) then
				player:AddResources(kGorgeWhipCostDigest)
			else
				player:AddResources(kGorgeWhipCostKill)
			end
		end

    end
end






if Server then


    local kSlapAfterBombardTimeout = Shared.GetAnimationLength(Whip.kModelName, "attack")
    local kSlapAnimationHitTagAt      = kSlapAfterBombardTimeout / 2.5

    --More Damage
    function GorgeWhip:SlapTarget(target)
        self:FaceTarget(target)
        -- where we hit
        local now = Shared.GetTime()
        local targetPoint = target:GetEngagementPoint()
        local attackOrigin = self:GetEyePos()
        local hitDirection = targetPoint - attackOrigin
        hitDirection:Normalize()
        -- fudge a bit - put the point of attack 0.5m short of the target
        local hitPosition = targetPoint - hitDirection * 0.5

        self:DoDamage(Whip.kDamage * 2.5, target, hitPosition, hitDirection, nil, true)
        self:TriggerEffects("whip_attack")

        local nextSlapStartTime    = now + (kSlapAfterBombardTimeout - kSlapAnimationHitTagAt)
        local nextBombardStartTime = now + (kSlapAfterBombardTimeout - kSlapAnimationHitTagAt)

        self.nextSlapStartTime    = math.max(nextSlapStartTime,    self.nextSlapStartTime)
        self.nextBombardStartTime = math.max(nextBombardStartTime, self.nextBombardStartTime)
    end


end


function GorgeWhip:GetMaxHealth()
    return kWhipHealth * 2.5
end



Shared.LinkClassToMap("GorgeWhip", GorgeWhip.kMapName, networkVars)