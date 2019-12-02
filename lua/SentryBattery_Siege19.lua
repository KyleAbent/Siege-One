PrecacheAsset("cinematics/vfx_materials/ghoststructure.surface_shader")
local kGhoststructureMaterial = PrecacheAsset("cinematics/vfx_materials/ghoststructure.material")

local kFlaresAttachpoint = "Exosuit_UpprTorso"
local kFlareCinematic = PrecacheAsset("cinematics/marine/exo/lens_flare.cinematic")

local networkVars =
{
 canBackup = "boolean",
 isIndestruct = "boolean"
}

local orig = SentryBattery.OnCreate
function SentryBattery:OnCreate()

    orig(self)
    self.isIndestruct = false
    self.canBackup = false
	if Server then 
	self:AddTimedCallback(SentryBattery.PowerTimer, 8)
	end
    
end
local origI = SentryBattery.OnInitialized
function SentryBattery:OnInitialized()

    origI(self)
    if Client then
    
        self:MakeFlashlight()
        
    end
    
end
--local origbuttons = SentryBattery.GetTechButtons
function SentryBattery:GetTechButtons(techId)
local table = {}

--table = origbuttons(self, techId)

 if not self.canBackup then
 table[1] = kTechId.BackupBattery
 end

 
 return table

end
function SentryBattery:PowerTimer()
   self.isIndestruct = self.canBackup and GetIsRoomPowerUp(self)
   return true
end
function SentryBattery:OnConstructionComplete(builder)
   --if GetIsRoomPowerUp(self) and self.canBackup then  self.isIndestruct = true end
end
function SentryBattery:OnPowerOn()
 self.isIndestruct = self.canBackup
end
function SentryBattery:OnPowerOff()
--Print("power off")
 self.isIndestruct = false
end
function SentryBattery:ModifyDamageTaken(damageTable, attacker, doer, damageType, hitPoint)

 
    if doer ~= nil and  self.isIndestruct then
        damageTable.damage = 0
    end

end


function SentryBattery:GetUnitNameOverride(viewer)

    local unitName = GetDisplayName(self)
    if  self.isIndestruct  then
        unitName = unitName .. " (" .. Locale.ResolveString("INDESTRUCTABLE") .. ")"
    end

    return unitName
    
end    


if Client then

    function SentryBattery:OnUpdateRender()
          local showMaterial = self.isIndestruct
    
        local model = self:GetRenderModel()
        if model then

            model:SetMaterialParameter("glowIntensity", 4)

            if showMaterial then
                
                if not self.hallucinationMaterial then
                    self.hallucinationMaterial = AddMaterial(model, kGhoststructureMaterial)
                end
                
                self:SetOpacity(0, "hallucination")
            
            else
            
                if self.hallucinationMaterial then
                    RemoveMaterial(model, self.hallucinationMaterial)
                    self.hallucinationMaterial = nil
                end//
                
                self:SetOpacity(1, "hallucination")
            
            end //showma
            
        end//omodel
end //up render
end -- client


if Client then
    function SentryBattery:MakeFlashlight()
    
        self.flashlight = Client.CreateRenderLight()
        
        self.flashlight:SetType(RenderLight.Type_Spot)
        self.flashlight:SetColor(Color(.8, .8, 1))
        self.flashlight:SetInnerCone(math.rad(30))
        self.flashlight:SetOuterCone(math.rad(45))
        self.flashlight:SetIntensity(10)
        self.flashlight:SetRadius(25)
        self.flashlight:SetAtmosphericDensity(0.2)
        --self.flashlight:SetGoboTexture("models/marine/male/flashlight.dds")
        
        self.flashlight:SetIsVisible(false)
        
        self.flares = Client.CreateCinematic(RenderScene.Zone_Default)
        self.flares:SetCinematic(kFlareCinematic)
        self.flares:SetRepeatStyle(Cinematic.Repeat_Endless)
        self.flares:SetParent(self)
        self.flares:SetCoords(Coords.GetIdentity())
        self.flares:SetAttachPoint(self:GetAttachPointIndex(kFlaresAttachpoint))
		
        self.flares:SetIsVisible(false)
        
    end

    function SentryBattery:OnUpdate()
        
        local flashLightVisible = self.canBackup and self:GetIsVisible() and self:GetIsAlive()
        
        -- Synchronize the state of the light representing the flash light.
        self.flashlight:SetIsVisible(flashLightVisible)
        self.flares:SetIsVisible(flashLightVisible)
        
        if self.canBackup then
        
            local coords = self:GetCoords()
            coords.origin = coords.origin + coords.zAxis * 0.75 + coords.yAxis * 1.5
            
            self.flashlight:SetCoords(coords)
            
        end
    end
end
    
function SentryBattery:OnDestroy()
    ScriptActor.OnDestroy( self )
    
    if self.flashlight then
        Client.DestroyRenderLight(self.flashlight)
        self.flashlight = nil
    end
    
    if self.flares then
        Client.DestroyCinematic(self.flares)
        self.flares = nil
    end
end


if Server then
    function SentryBattery:OnResearchComplete(researchId)

    if researchId == kTechId.BackupBattery then
      self.canBackup = true
      self.isIndestruct = self:GetIsPowered()
    end
    end
end
Shared.LinkClassToMap("SentryBattery", SentryBattery.kMapName, networkVars)


