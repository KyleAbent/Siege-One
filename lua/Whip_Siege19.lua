
 function Whip:GetCanFireAtTargetActual(target, targetPoint)    

    if target:isa("BreakableDoor") and target.health == 0 then
    return false
    end
    
    return true
    
end

function Whip:GetMatureMaxHealth()
    return kMatureWhipHealth
end

function Whip:GetMatureMaxArmor()
    return kMatureWhipArmor
end    

function Whip:GetUnitNameOverride(viewer)
    

            return string.format( "Siege Whip" )


end

function Whip:OnOverrideOrder(order)
	order:SetType(kTechId.Default)
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







Shared.LinkClassToMap("GorgeWhip", GorgeWhip.kMapName, networkVars)