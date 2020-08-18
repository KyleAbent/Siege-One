




//local kBlipSizeType = enum( { 'Normal', 'TechPoint', 'Infestation', 'Scan', 'Egg', 'Worker', 'EtherealGate', 'HighlightWorld', 'Waypoint', 'BoneWall', 'UnpoweredPowerPoint' } )
//local kBlipInfo = {}
//local kBackgroundBlipsLayer = 1
//kBlipInfo[kMinimapBlipType.HighlightWorld] = { kBlipColorType.HighlightWorld, kBlipSizeType.HighlightWorld, 0 }
-- No way to match pairs

/*


    local hook = GUIMinimap.InitMinimapIcon
    function GUIMinimap:InitMinimapIcon(item, blipType, blipTeam, color)
        local orig = hook(self,item,blipType, blipTeam)
        local blipInfo = self.blipInfoTable[blipType]
        if blipInfo[1][1] == 64 then
            --Print("%s, %s, %s, %s, %s,", ToString(orig), ToString(blipInfo), ToString(item), blipType,blipTeam)
            --Print("color is %s", color)
            if blipInfo[1][2] == 224  then
                --if color and item.blipColor ~= color then --if not color matching ? --another param saying it's built and colored so don't change it back lol
                    --orig.prevColor = orig.blipColor
                    --orig.blipColor = item.color
                    --Print("orig.blipColor %s", orig.blipColor)
                    --Print("Changing Color of %s %s", 64, 224)
                --elseif orig.prevColor and orig.blipColor ~= orig.prevColor then //Color(1, 138/255, 0, 1)
               // if orig.prevColor and orig.blipColor ~= orig.prevColor then
                //    Print("prev color is %s", ToString(orig.prevColor) )
                 //   orig.blipColor = orig.prevColor
               // end
                //orig.blipSize = kMinimapBlipType.HighlightWorld
            end
        end
        
       -- item.prevColor = orig.blipColor
        return orig
    end
  */  
  
    function GUIMinimap:MatchPairingTunnels(item, blipType, blipTeam, color)
        --Print("[A]color is %s",color)
        --if not item.prevColor or item.prevColor ~= color then
        --    item.prevColor = color
        --end
        item.blipColor = color
        --should only do once? to set prev?
        
       -- self:InitMinimapIcon(item, blipType, blipTeam, color)
    end
  













------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------









/*
function GUIMinimap:UpdateStaticIcon(entityId)
    PROFILE("GUIMinimap:UpdateStaticIcon")

    local icon = entityId and self.iconMap:Get(entityId)
    if icon then
        local entity = Shared.GetEntity(entityId)
        if not entity then
            icon:SetIsVisible(false)
        else
        local owner = entity.ownerEntityId and Shared.GetEntity(entity.ownerEntityId)
        if owner then
            if owner:isa("TunnelEntrance") then
                icon.resetMinimapItem = true
                icon:SetColor(owner:GetMiniMapColors())
                Print("isa tunnel")
            end
        end
            --Print("%s",ToString(entity:GetClassName()) )
            entity:UpdateMinimapItem(self, icon)
        end
    end
end  

*/
    
    
    local function DrawLocalBlip(self, blipData)

    local icon = blipData.icon
    if icon.resetMinimapItem then
        self:InitMinimapIcon(icon, blipData.blipType, blipData.blipTeam)
    end

    self:UpdateBlipPosition(icon, blipData.position)

end

function GUIMinimap:DrawLocalBlips()
    PROFILE("GUIMinimap:DrawLocalBlips")

    for _, blipData in self.localBlipData:Iterate() do
        DrawLocalBlip(self, blipData)
    end

end




  /*
  
  
local function CreateIcon(self,isTunnel)

    local icon = table.remove(self.freeIcons)

    -- Expensive!!! Avoid at any cost
    if not icon then
        icon = GUIManager:CreateGraphicItem()
        icon:SetAnchor(GUIItem.Middle, GUIItem.Center)
        icon:SetIsVisible(false)
        if isTunnel then
            icon.blipColor = ColorIntToColor(0xDA2BFD)
        end
        self.minimap:AddChild(icon)
    end

    -- will cause it to initialize on next call to update.
    icon.resetMinimapItem = true
    return icon

end

local function CreateIconForEntity(self,isTunnel)
    local icon = CreateIcon(self,isTunnel)

    icon.version = 0 -- track last update time
    return icon
end


    local orig = GUIMinimap.UpdateBlipActivity
    GUIMinimap.kXZVector = Vector(1,0,1)
    function GUIMinimap:UpdateBlipActivity()
    --orig(self)

    local now = Shared.GetTime()
    local invalidId = Entity.invalidId


    for _, entity in ientitylist(Shared.GetEntitiesWithTag("MinimapMappable")) do
        local id = entity:GetId()
        local addBlip = id ~= invalidId -- don't add/update blips for invalid ids
-----------------------------------------------------------------------------------------------------------
        local isTunnel = false
        local owner = entity.ownerEntityId and Shared.GetEntity(entity.ownerEntityId)
        if owner then
            if owner:isa("TunnelEntrance") then
                --Print("Owner is a tunnel entrance")
                isTunnel = true
            end
        end
----------------------------------------------------------------------------------------------------------------        
        -- don't add/update blips outside the update radius; saves CPU for marine HUD
        if addBlip and (self.updateRadius > 0 or isTunnel) then
            local diff = (self.playerOrigin - entity:GetMapBlipOrigin()) * self.kXZVector
            addBlip = (diff:GetLengthSquared() < self.updateRadiusSquared) or isTunnel-------------------------------------
        end
        if isTunnel then
            Print("addBlip is %s", addBlip)
        end
        if addBlip then
            local icon = self.iconMap:Get(id)
            if not icon then
                icon = CreateIconForEntity(self,isTunnel)
                self.iconMap:Insert(id, icon)
            end

            local activity = entity:UpdateMinimapActivity(self, icon)
            if activity or isTunnel then
                local data = self.staticBlipData[activity]
                table.insert(data.blipIds, id)
                data.count = data.count + 1
                icon.version = now
            end
        end
    end

    -- clear out any icons no longer in use
    for id, icon in self.iconMap:IterateBackwards() do
        if icon.version < now then
            self:RemoveEntityIcon(id)
        end
    end

    -- Log("ActivityUpdate, data %s, numIcons %s, numFreeIcons %s", self.staticBlipData, table.countkeys(self.iconMap), #self.freeIcons)
    
    end
    
    
    */
    