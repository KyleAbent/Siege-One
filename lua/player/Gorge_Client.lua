Gorge.kCameraRollSpeedModifier = 0.5
Gorge.kCameraRollTiltModifier = 0.05

Gorge.kViewModelRollSpeedModifier = 7
Gorge.kViewModelRollTiltModifier = 0.15

function Gorge:GetHealthbarOffset()
    return 0.7
end

function Gorge:GetHeadAttachpointName()
    return "Bone_Tongue"
end

// Tilt the camera based on the wall the Gorge is attached to.
function Gorge:PlayerCameraCoordsAdjustment(cameraCoords)

    if self.currentCameraRoll ~= 0 then

        local viewModelTiltAngles = Angles()
        viewModelTiltAngles:BuildFromCoords(cameraCoords)
        
        if self.currentCameraRoll then
            viewModelTiltAngles.roll = viewModelTiltAngles.roll + self.currentCameraRoll
        end
        
        local viewModelTiltCoords = viewModelTiltAngles:GetCoords()
        viewModelTiltCoords.origin = cameraCoords.origin
        
        return viewModelTiltCoords
        
    end
    
    return cameraCoords

end

local function UpdateCameraTilt(self, deltaTime)

    if self.currentCameraRoll == nil then
        self.currentCameraRoll = 0
    end
    if self.goalCameraRoll == nil then
        self.goalCameraRoll = 0
    end
    if self.currentViewModelRoll == nil then
        self.currentViewModelRoll = 0
    end
    
    // Don't rotate if too close to upside down (on ceiling).
    if not Client.GetOptionBoolean("CameraAnimation", false) or math.abs(self.wallWalkingNormalGoal:DotProduct(Vector.yAxis)) > 0.9 then
        self.goalCameraRoll = 0
    else
    
        local wallWalkingNormalCoords = Coords.GetLookIn( Vector.origin, self:GetViewCoords().zAxis, self.wallWalkingNormalGoal )
        local wallWalkingRoll = Angles()
        wallWalkingRoll:BuildFromCoords(wallWalkingNormalCoords)
        self.goalCameraRoll = wallWalkingRoll.roll
        
    end 
    
    self.currentCameraRoll = LerpGeneric(self.currentCameraRoll, self.goalCameraRoll * Gorge.kCameraRollTiltModifier, math.min(1, deltaTime * Gorge.kCameraRollSpeedModifier))
    self.currentViewModelRoll = LerpGeneric(self.currentViewModelRoll, self.goalCameraRoll, math.min(1, deltaTime * Gorge.kViewModelRollSpeedModifier))

end

function Gorge:OnProcessIntermediate(input)

    Alien.OnProcessIntermediate(self, input)
    UpdateCameraTilt(self, input.time)

end

function Gorge:OnProcessSpectate(deltaTime)

    Alien.OnProcessSpectate(self, deltaTime)
    UpdateCameraTilt(self, deltaTime)

end


function Gorge:GetSpeedDebugSpecial()
    return 0
end

function Gorge:ModifyViewModelCoords(viewModelCoords)

    if self.currentViewModelRoll ~= 0 then

        local roll = self.currentViewModelRoll and self.currentViewModelRoll * Gorge.kViewModelRollTiltModifier or 0
        local rotationCoords = Angles(0, 0, roll):GetCoords()
        
        return viewModelCoords * rotationCoords
    
    end
    
    return viewModelCoords

end

    
function Gorge:GetShowGhostModel()
    
        local weapon = self:GetActiveWeapon()
        if weapon and weapon:isa("DropStructureAbility") then
            return weapon:GetShowGhostModel()
        else
            return Alien.GetShowGhostModel(self)    
        end
        
        return false
        
    end
    
    function Gorge:GetGhostModelOverride()
    
        local weapon = self:GetActiveWeapon()
        if weapon and weapon:isa("DropStructureAbility") and weapon.GetGhostModelName then
            return weapon:GetGhostModelName(self)
        end
        
    end
    
    function Gorge:GetGhostModelTechId()
    
        local weapon = self:GetActiveWeapon()
        if weapon then
            if weapon:isa("DropStructureAbility") then
                return weapon:GetGhostModelTechId()
            else
                return Alien.GetGhostModelTechId(self)
            end    
        end
        
    end
    
    function Gorge:GetGhostModelCoords()
    
        local weapon = self:GetActiveWeapon()
        if weapon then
            if weapon:isa("DropStructureAbility") then
                return weapon:GetGhostModelCoords()
            else 
                return Alien.GetGhostModelCoords(self)
            end    
        end
        
    end
    
    function Gorge:GetLastClickedPosition()
    
        local weapon = self:GetActiveWeapon()
        if weapon and weapon:isa("DropStructureAbility") then
            return weapon.lastClickedPosition
        end
        
    end

    function Gorge:GetIsPlacementValid()
    
        local weapon = self:GetActiveWeapon()
        if weapon and weapon:isa("DropStructureAbility") then
            return weapon:GetIsPlacementValid()
        else
            return Alien.GetIsPlacementValid(self)    
        end
    
    end

    function Gorge:GetIgnoreGhostHighlight()
    
        local weapon = self:GetActiveWeapon()
        if weapon and weapon:isa("DropStructureAbility") and weapon.GetIgnoreGhostHighlight then
            return weapon:GetIgnoreGhostHighlight()
        end
        
    end  