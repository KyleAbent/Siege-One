Script.Load("lua/StunMixin.lua")

local networkVars = {}
AddMixinNetworkVars(StunMixin, networkVars)

local origCreate = Exo.OnCreate
function  Exo:OnCreate()
    origCreate(self)
end

/*
local function HealSelf(self)

  local toheal = false
                for _, proto in ipairs(GetEntitiesForTeamWithinRange("PrototypeLab", 1, self:GetOrigin(), 4)) do
                    
                    if GetIsUnitActive(proto) then
                        toheal = true
                        break
                    end
                    
                end
          --  Print("toheal is %s", toheal)
    if toheal then
    self:SetArmor(self:GetArmor() + kNanoArmorHealPerSecond, true) 
    end
    
end
*/

local oninit = Exo.OnInitialized
function Exo:OnInitialized()
    oninit(self)
    InitMixin(self, StunMixin)
   --self:SetTechId(kTechId.Exo)
   --self:AddTimedCallback(function() HealSelf(self) return true end, 1) 
end
function Exo:GetIsStunAllowed()
    return not self.timeLastStun or self.timeLastStun + 8 < Shared.GetTime() 
end

function Exo:OnStun()
         if Server then
                local stunwall = CreateEntity(StunWall.kMapName, self:GetOrigin(), 2)    
                StartSoundEffectForPlayer(AlienCommander.kBoneWallSpawnSound, self)
        end
end


Shared.LinkClassToMap("Exo", Exo.kMapName, networkVars)