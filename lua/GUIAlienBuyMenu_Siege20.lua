
local function CreateSlot(self, category)

    local graphic = GUIManager:CreateGraphicItem()
    graphic:SetSize(Vector(GUIAlienBuyMenu.kSlotSize, GUIAlienBuyMenu.kSlotSize, 0))
    graphic:SetTexture(GUIAlienBuyMenu.kSlotTexture)
    graphic:SetLayer(kGUILayerPlayerHUDForeground3)
    graphic:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.background:AddChild(graphic)
    
    table.insert(self.slots, { Graphic = graphic, Category = category } )


end

--override
function GUIAlienBuyMenu:_InitializeSlots()

    self.slots = {}
    CreateSlot(self, kTechId.ShiftHiveTwo)
    CreateSlot(self, kTechId.CragHiveTwo)
    CreateSlot(self, kTechId.CragHive)
    CreateSlot(self, kTechId.ShadeHive)
    CreateSlot(self, kTechId.ShiftHive)
    
    local anglePerSlot = (math.pi) / (#self.slots-1)
    
    for i = 1, #self.slots do
    
        local angle = (i-1) * anglePerSlot + math.pi * 0.05 //herp
        local distance = GUIAlienBuyMenu.kSlotDistance
        
        self.slots[i].Graphic:SetPosition( Vector( math.cos(angle) * distance - GUIAlienBuyMenu.kSlotSize * .5, math.sin(angle) * distance - GUIAlienBuyMenu.kSlotSize * .5, 0) )
        self.slots[i].Angle = angle
    
    end
    

end