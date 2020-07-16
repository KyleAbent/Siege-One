Script.Load("lua/2019/ExoWelder.lua")
Script.Load("lua/2019/ExoFlamer.lua")

local networkVars = {   


  --isLockedEjecting = "private boolean",

  --  wallboots = "private boolean",
  --  wallWalking = "compensated boolean",
  --  timeLastWallWalkCheck = "private compensated time",

 }
  /*
local kNormalWallWalkFeelerSize = 0.25
local kNormalWallWalkRange = 0.3
local kJumpWallRange = 0.4
local kJumpWallFeelerSize = 0.1
local kWallJumpInterval = 0.4
local kWallJumpForce = 5.2 // scales down the faster you are
local kMinWallJumpForce = 0.1
local kVerticalWallJumpForce = 4.3
*/

AddMixinNetworkVars(StunMixin, networkVars)
AddMixinNetworkVars(PhaseGateUserMixin, networkVars)
AddMixinNetworkVars(LadderMoveMixin, networkVars)

local kDualWelderModelName = PrecacheAsset("models/marine/exosuit/exosuit_rr.model")
local kDualWelderAnimationGraph = PrecacheAsset("models/marine/exosuit/exosuit_rr.animation_graph")

local kHoloMarineMaterialname = PrecacheAsset("cinematics/vfx_materials/marine_ip_spawn.material")


local function HealSelf(self)


    self:SetArmor(self:GetArmor() + 3, true) 
    return self.layout == "WelderWelder"
end

local origcreate = Exo.OnCreate
function Exo:OnCreate()
    origcreate(self)
    self:AddTimedCallback(function() HealSelf(self) return true end, 1) 
end


local oninit = Exo.OnInitialized
function Exo:OnInitialized()

oninit(self)
    InitMixin(self, StunMixin)
   self:SetTechId(kTechId.Exo)
end
local origmodel = Exo.InitExoModel

function Exo:InitExoModel()

    local hasWelders = false
    local modelName = kDualWelderModelName
    local graphName = kDualWelderAnimationGraph
    
  if self.layout == "WelderWelder" or self.layout == "FlamerFlamer" then
         modelName = kDualWelderModelName
        graphName = kDualWelderAnimationGraph
        self.hasDualGuns = true
        hasWelders = true
        self:SetModel(modelName, graphName)
    end
    
    
    if hasWelders then 
    else
    origmodel(self)
    end
end
local origweapons = Exo.InitWeapons
function Exo:InitWeapons()
     
    local weaponHolder = self:GetWeapon(ExoWeaponHolder.kMapName)
    if not weaponHolder then
        weaponHolder = self:GiveItem(ExoWeaponHolder.kMapName, false)   
    end    
    
  
        if self.layout == "WelderWelder" then
        weaponHolder:SetWelderWeapons()
        self:SetHUDSlotActive(1)
        return
        elseif self.layout == "FlamerFlamer" then
        weaponHolder:SetFlamerWeapons()
        self:SetHUDSlotActive(1)
        return
        end
        
        

        origweapons(self)

    
end

function Exo:GetCanControl()
    return not self.isLockedEjecting and not self.isMoveBlocked and self:GetIsAlive() and  not self.countingDown and not self.concedeSequenceActive
end



Shared.LinkClassToMap("Exo", Exo.kMapName, networkVars)