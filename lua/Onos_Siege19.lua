if Server then

    function Onos:GetTierFourTechId()
        return kTechId.GorillaGlue
    end

end

if Client then

    function Onos:GetShowGhostModel()
    
        local weapon = self:GetActiveWeapon()
        if weapon and weapon:isa("GorillaGlue") then
            return weapon:GetShowGhostModel()
        end
        
        return false
        
    end
    
    function Onos:GetGhostModelOverride()
    
        local weapon = self:GetActiveWeapon()
        if weapon and weapon:isa("GorillaGlue") and weapon.GetGhostModelName then
            return weapon:GetGhostModelName(self)
        end
        
    end
    
    function Onos:GetGhostModelTechId()
    
        local weapon = self:GetActiveWeapon()
        if weapon and weapon:isa("GorillaGlue") then
            return weapon:GetGhostModelTechId()
        end
        
    end
    
    function Onos:GetGhostModelCoords()
    
        local weapon = self:GetActiveWeapon()
        if weapon and weapon:isa("GorillaGlue") then
            return weapon:GetGhostModelCoords()
        end
        
    end
    
    function Onos:GetLastClickedPosition()
    
        local weapon = self:GetActiveWeapon()
        if weapon and weapon:isa("GorillaGlue") then
            return weapon.lastClickedPosition
        end
        
    end

    function Onos:GetIsPlacementValid()
    
        local weapon = self:GetActiveWeapon()
        if weapon and weapon:isa("GorillaGlue") then
            return weapon:GetIsPlacementValid()
        end
    
    end

    function Onos:GetIgnoreGhostHighlight()
    
        local weapon = self:GetActiveWeapon()
        if weapon and weapon:isa("GorillaGlue") and weapon.GetIgnoreGhostHighlight then
            return weapon:GetIgnoreGhostHighlight()
        end
        
    end  

end

function Onos:GetEngagementPointOverride()
    return self:GetOrigin() + Vector(0, 0.28, 0)
end

