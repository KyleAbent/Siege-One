-- ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
--
-- lua\Fade_Client.lua
--
--    Created by:   Andreas Urwalek (andi@unknownworlds.com)
--
-- ========= For more information, visit us at http://www.unknownworlds.com =====================

--PrecacheAsset("cinematics/vfx_materials/fade_blink.surface_shader")
--local kFadeBlinkMaterial = PrecacheAsset("cinematics/vfx_materials/fade_blink.material") 

local kFadeCameraYOffset = 0.6

/*

local kFadeTrailDark = {
    PrecacheAsset("cinematics/alien/fade/trail_dark_1.cinematic"),
    PrecacheAsset("cinematics/alien/fade/trail_dark_2.cinematic"),
}

local kFadeTrailGlow = {
    PrecacheAsset("cinematics/alien/fade/trail_glow_1.cinematic"),
    PrecacheAsset("cinematics/alien/fade/trail_glow_2.cinematic"),
}

*/

function Fade:OnFilteredCinematicOptionChanged()
    --self:DestroyTrailCinematic()
    --self:CreateTrailCinematic()
end

function Fade:GetHealthbarOffset()
    return 0.9
end

function Fade:UpdateClientEffects(deltaTime, isLocal)
    
    Alien.UpdateClientEffects(self, deltaTime, isLocal)

    --if not self.trailCinematic then
       -- self:CreateTrailCinematic()
    --end
    
    local showTrail = false --(self:GetIsBlinking() or self:GetIsShadowStepping()) and (not isLocal or self:GetIsThirdPerson())
    
    --self.trailCinematic:SetIsVisible(showTrail)
    --self.scanTrailCinematic:SetIsVisible(showTrail and self.isScanned)
    
    if self:GetIsAlive() then
    
        --if self:GetIsShadowStepping() then
            --self.blinkDissolve = 1    
        --elseif self:GetIsBlinking() then
        if self:GetIsBlinking() then
            --self.blinkDissolve = 0.6
            self.wasBlinking = true
        else
        
            if self.wasBlinking then
                self.wasBlinking = false
                --self.blinkDissolve = 1
            end    
        
            --self.blinkDissolve = math.max(0, self.blinkDissolve - deltaTime)
        end
    
    else
        --self.blinkDissolve = 0
    end  
    
    self:UpdateBlinkSounds(isLocal)
    
end

function Fade:UpdateBlinkSounds(isLocal)

    local playSoundLocal = self:GetIsBlinking() and not GetHasSilenceUpgrade(self) and isLocal

    if playSoundLocal and not self.blinkSoundPlaying then
        self:TriggerEffects("blink_loop_start")
        self.blinkSoundPlaying = true
    elseif not playSoundLocal and self.blinkSoundPlaying then
        self:TriggerEffects("blink_loop_end")
        self.blinkSoundPlaying = false
    end

    if not isLocal then

        if self:GetIsBlinking() and not self.blinkWorldSoundPlaying then
            self:TriggerEffects("blink_world_loop_start")
            self.blinkWorldSoundPlaying = true
        elseif not self:GetIsBlinking() and self.blinkWorldSoundPlaying then
            self:TriggerEffects("blink_world_loop_end")
            self.blinkWorldSoundPlaying = false
        end

    end

end

function Fade:OnUpdateRender()
    
    PROFILE("Fade:OnUpdateRender")

    Alien.OnUpdateRender(self)
/*
    local model = self:GetRenderModel()
    if model and self.blinkDissolve then
    
        if not self.blinkMaterial then
            self.blinkMaterial = AddMaterial(model, kFadeBlinkMaterial)
        end
        
        self.blinkMaterial:SetParameter("blinkAmount", self.blinkDissolve)  
        
    end
*/
    --self:SetOpacity((self:GetIsBlinking()) and 0 or 1, "blinkAmount")

end  

function Fade:CreateTrailCinematic()


end

function Fade:DestroyTrailCinematic()

end