-- ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
--
-- lua\Weapons\Flamethrower_Client.lua
--
--    Created by:   Charlie Cleveland (charlie@unknownworlds.com) 
--
-- ========= For more information, visit us at http:--www.unknownworlds.com =====================


local kImpactEffectRate = 0.3
local kSmokeEffectRate = 1.5
local kPilotEffectRate = 0.3



local function UpdateSound(self)

    -- Only update when held in inventory
    if self.loopingSoundEntId ~= Entity.invalidId and self:GetParent() ~= nil then
    
        local player = Client.GetLocalPlayer()
        local viewAngles = player:GetViewAngles()
        local yaw = viewAngles.yaw

        local soundEnt = Shared.GetEntity(self.loopingSoundEntId)
        if soundEnt then

            if soundEnt:GetIsPlaying() and self.lastYaw ~= nil then
            
                -- 180 degree rotation = param of 1
                local rotateParam = math.abs((yaw - self.lastYaw) / math.pi)
                
                -- Use the maximum rotation we've set in the past short interval
                if not self.maxRotate or (rotateParam > self.maxRotate) then
                
                    self.maxRotate = rotateParam
                    self.timeOfMaxRotate = Shared.GetTime()
                    
                end
                
                if self.timeOfMaxRotate ~= nil and Shared.GetTime() > self.timeOfMaxRotate + .75 then
                
                    self.maxRotate = nil
                    self.timeOfMaxRotate = nil
                    
                end
                
                if self.maxRotate ~= nil then
                    rotateParam = math.max(rotateParam, self.maxRotate)
                end
                
                soundEnt:SetParameter("rotate", rotateParam, 1)
                
            end
            
        else
            //Print("Flamethrower:OnUpdate(): Couldn't find sound ent on client")
        end
            
        self.lastYaw = yaw
        
    end
    
end

function ExoGrenader:OnUpdate(deltaTime)

    Entity.OnUpdate(self, deltaTime)
    
    UpdateSound(self)
    
end

function ExoGrenader:ProcessMoveOnWeapon(input)

   Entity.ProcessMoveOnWeapon(self, input)
    
    UpdateSound(self)
    
end

function ExoGrenader:OnProcessSpectate(deltaTime)

    Entity.OnProcessSpectate(self, deltaTime)
    
    UpdateSound(self)

end



local kEffectType = enum({'FirstPerson', 'ThirdPerson', 'None'})

function ExoGrenader:OnUpdateRender()
    -- Entity.OnUpdateRender(self)
    local parent = self:GetParent()
    local localPlayer = Client.GetLocalPlayer()
    
    if parent and parent:GetIsLocalPlayer() then
        local viewModel = parent:GetViewModelEntity()
        if viewModel and viewModel:GetRenderModel() then
            viewModel:InstanceMaterials()
            viewModel:GetRenderModel():SetMaterialParameter("heatAmount" .. self:GetExoWeaponSlotName(), self.heatAmount)
        end
        local heatDisplayUI = self.heatDisplayUI
        if not heatDisplayUI then
            heatDisplayUI = Client.CreateGUIView(242, 720)
            heatDisplayUI:Load("lua/ModularExo_GUI" .. self:GetExoWeaponSlotName():gsub("^%l", string.upper) .. "FlamerDisplay.lua")
            heatDisplayUI:SetTargetTexture("*exo_railgun_" .. self:GetExoWeaponSlotName())
            self.heatDisplayUI = heatDisplayUI
        end
        heatDisplayUI:SetGlobal("heatAmount" .. self:GetExoWeaponSlotName(), self.heatAmount)
    else
        if self.heatDisplayUI then
            Client.DestroyGUIView(self.heatDisplayUI)
            self.heatDisplayUI = nil
        end
    end
end





