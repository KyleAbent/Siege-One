

local orig_Onos_UpdateClientEffects = Onos.UpdateClientEffects
function Onos:UpdateClientEffects(deltaTime, isLocal)
orig_Onos_UpdateClientEffects(self, deltaTime, isLocal)

       self:UpdateGhostModel()

end

function Onos:UpdateGhostModel()

--orig_Alien_UpdateGhostModel(self)

 self.currentTechId = nil
 
    self.ghostStructureCoords = nil
    self.ghostStructureValid = false
    self.showGhostModel = false
    
    local weapon = self:GetActiveWeapon()

    if weapon then
       if weapon:isa("GorillaGlue") then
        self.currentTechId = weapon:GetGhostModelTechId()
        self.ghostStructureCoords = weapon:GetGhostModelCoords()
        self.ghostStructureValid = weapon:GetIsPlacementValid()
        self.showGhostModel = weapon:GetShowGhostModel()
         end
    end




end --function

function Onos:GetShowGhostModel()
    return self.showGhostModel
end    

function Onos:GetGhostModelTechId()
    return self.currentTechId
end

function Onos:GetGhostModelCoords()
    return self.ghostStructureCoords
end

function Onos:GetIsPlacementValid()
    return self.ghostStructureValid
end

function Onos:AddGhostGuide(origin, radius)

return

end