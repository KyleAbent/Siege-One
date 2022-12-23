Marine.kRunInfestationMaxSpeed = 2 --5

local origMaxSpeed = Marine.GetMaxSpeed
function Marine:GetMaxSpeed(possible)
    orig = origMaxSpeed(self,possible)
    if self:GetGameEffectMask(kGameEffect.OnInfestation) then
        orig = orig/2
    end
    if not self:GetIsParasited() then
        orig = orig * 1.10
    end
    return orig
end


----------------------
--Error fix for MarineVariantMixin :l LayStructureWeapon cheap fix
----------------------
kBmacMaterialViewIndices = --Zero-based indices (shared view model for all bmacs)
{
    ["Axe"] = 1,
    ["Pistol"] = 2,
    ["Rifle"] = 2,
    ["Builder"] = 2,
    ["Welder"] = 2,
    ["LayStructures"] = 2,
    ["Shotgun"] = 4,
    ["Flamethrower"] = 2,
    ["GrenadeLauncher"] = 3,
    ["HeavyMachineGun"] = 2,
    ["LayMines"] = 2,
    ["GasGrenadeThrower"] = 1,
    ["ClusterGrenadeThrower"] = 1,
    ["PulseGrenadeThrower"] = 1,
}
--------------------------------
function GetMaterialIndexPerWeapon( wepClass )
    assert(wepClass)
    assert(kBmacMaterialViewIndices[wepClass])
    return kBmacMaterialViewIndices[wepClass]
end

function Marine:GetHasLayStructure()
        local weapon = self:GetWeaponInHUDSlot(5)
        local builder = false
    if (weapon) then
            builder = true
    end
    
    return builder
end

function Marine:GiveLayStructure(techid, mapname)
  --  if not self:GetHasLayStructure() then
           local laystructure = self:GiveItem(LayStructures.kMapName)
           self:SetActiveWeapon(LayStructures.kMapName)
           laystructure:SetTechId(techid)
           laystructure:SetMapName(mapname)
  -- else
   --  self:TellMarine(self)
  -- end
end


if Client then



local orig_Marine_UpdateGhostModel = Marine.UpdateGhostModel
function Marine:UpdateGhostModel()

orig_Marine_UpdateGhostModel(self)

 self.currentTechId = nil
 
    self.ghostStructureCoords = nil
    self.ghostStructureValid = false
    self.showGhostModel = false
    
    local weapon = self:GetActiveWeapon()

    if weapon then
       if weapon:isa("LayStructures") then
        self.currentTechId = weapon:GetDropStructureId()
        self.ghostStructureCoords = weapon:GetGhostModelCoords()
        self.ghostStructureValid = weapon:GetIsPlacementValid()
        self.showGhostModel = weapon:GetShowGhostModel()
        elseif weapon:isa("LayMines") then
        self.currentTechId = kTechId.Mine
        self.ghostStructureCoords = weapon:GetGhostModelCoords()
        self.ghostStructureValid = weapon:GetIsPlacementValid()
        self.showGhostModel = weapon:GetShowGhostModel()
         end
    end




end --function


    function Marine:AddGhostGuide(origin, radius)

    return

    end

end -- client


if Server then

    local origderp = Marine.CopyPlayerDataFrom
    function Marine:CopyPlayerDataFrom(player)
        origderp(self, player)
        /*
        if player.GetHasLayStructure and player:GetHasLayStructure() then 
            local weapon = player:GetWeaponInHUDSlot(5)
            local builder = false
            if (weapon) then
                    self:GiveLayStructure(weapon:GetDropStructureId(), weapon:GetDropStructureMapName())
            end
        end
        */
    end    
        
end--Server


