GUICommanderLogout.kPersonalTimeIcon = { Width = 0, Height = 0, X = 0, Y = 0 }
GUICommanderLogout.kPersonalTimeIcon.Width = 32
GUICommanderLogout.kPersonalTimeIcon.Height = 64

--GUICommanderLogout.kPersonalTimeIconSize = Vector(GUICommanderLogout.kPersonalResourceIcon.Width, GUICommanderLogout.kPersonalResourceIcon.Height, 0)
--GUICommanderLogout.kPersonalTimeIconSizeBig = Vector(GUICommanderLogout.kPersonalResourceIcon.Width, GUICommanderLogout.kPersonalResourceIcon.Height, 0) * 1.1


GUICommanderLogout.kPersonalTimeIconPos = Vector(30,-4,0)
GUICommanderLogout.kPersonalTimeTextPos = Vector(100,4,0)
GUICommanderLogout.kTimeDescriptionPos = Vector(110,4,0)
GUICommanderLogout.kTimeGainedTextPos = Vector(90,-6,0)

GUICommanderLogout.kFontSizePersonalTime = 20
GUICommanderLogout.kFontSizePersonalTimeBig = 20


GUICommanderLogout.kFrontTimeBackgroundSize = Vector(280, 58, 0)
GUICommanderLogout.kFrontTimeBackgroundPos = Vector(-120, -265, 0) -- -100

GUICommanderLogout.kSideTimeBackgroundSize = Vector(280, 58, 0)
GUICommanderLogout.kSideTimeBackgroundPos = Vector(-120, -200, 0) -- -100


GUICommanderLogout.kSiegeTimeBackgroundSize = Vector(280, 58, 0)
GUICommanderLogout.kSiegeTimeBackgroundPos = Vector(-120, -135, 0) -- -100


GUICommanderLogout.kPowerBackgroundSize = Vector(280, 58, 0)
GUICommanderLogout.kPowerBackgroundPos = Vector(-120, -75, 0) -- -100

GUICommanderLogout.kTextFontName = Fonts.kAgencyFB_Small


local origInit = GUICommanderLogout.Initialize

function GUICommanderLogout:Initialize()
    origInit(self)
    
    
    self.frame = GUIManager:CreateGraphicItem()
  --  self.frame:SetIsScaling(false)
    self.frame:SetSize(Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0))
    self.frame:SetPosition(Vector(0, 0, 0))
    self.frame:SetIsVisible(true)
    self.frame:SetLayer(kGUILayerPlayerHUDBackground)
    self.frame:SetColor(Color(1, 1, 1, 0))
    
    local style = kGUILayerPlayerHUDForeground1
    --self.frame = CreateAvocaDisplay(self, kGUILayerPlayerHUDForeground3, self.doorTimersBackground, style, kTeam2Index)
    
    
    self.frontBackground = GUIManager:CreateGraphicItem()
    self.frontBackground:SetAnchor(GUIItem.Right, GUIItem.Center)
    --self.frontBackground:SetTexture(kBackgroundTextures[style.textureSet])
    self.frame:AddChild(self.frontBackground)
    self.frontBackground:SetPosition(GUIPlayerResource.kFrontTimeBackgroundPos) 
    
    self.siegeBackground = GUIManager:CreateGraphicItem()
    self.siegeBackground:SetAnchor(GUIItem.Right, GUIItem.Center)
    --self.siegeBackground:SetTexture(kBackgroundTextures[style.textureSet])
    self.frame:AddChild(self.siegeBackground)
    self.siegeBackground:SetPosition(GUIPlayerResource.kSiegeTimeBackgroundPos)
    
    self.sideBackground = GUIManager:CreateGraphicItem()
    self.sideBackground:SetAnchor(GUIItem.Right, GUIItem.Center)
    --self.sideBackground:SetTexture(kBackgroundTextures[style.textureSet])
    self.sideBackground:SetPosition(GUIPlayerResource.kSideTimeBackgroundPos)
    self.frame:AddChild(self.sideBackground)
    
    self.powerBackground =  GUIManager:CreateGraphicItem()
    self.powerBackground:SetAnchor(GUIItem.Right, GUIItem.Center)
    --self.powerBackground:SetTexture(kBackgroundTextures[style.textureSet])
     self.powerBackground:SetPosition(GUIPlayerResource.kPowerBackgroundPos)
    self.frame:AddChild(self.powerBackground)
    
    self.frontDoor = GUIManager:CreateTextItem()
    self.frontDoor:SetAnchor(GUIItem.Left, GUIItem.Center)
    self.frontDoor:SetTextAlignmentX(GUIItem.Align_Max)
    self.frontDoor:SetTextAlignmentY(GUIItem.Align_Center)
    --self.frontDoor:SetColor(style.textColor)
    self.frontDoor:SetFontIsBold(true)
    self.frontDoor:SetFontName(GUICommanderLogout.kTextFontName)
    self.frontBackground:AddChild(self.frontDoor)
    
    self.siegeDoor = GUIManager:CreateTextItem()
    self.siegeDoor:SetAnchor(GUIItem.Left, GUIItem.Center)
    self.siegeDoor:SetTextAlignmentX(GUIItem.Align_Max)
    self.siegeDoor:SetTextAlignmentY(GUIItem.Align_Center)
    --self.siegeDoor:SetColor(style.textColor)
    self.siegeDoor:SetFontIsBold(true)
    self.siegeDoor:SetFontName(GUICommanderLogout.kTextFontName)
    self.siegeBackground:AddChild(self.siegeDoor)
    
    self.sideDoor = GUIManager:CreateTextItem()
    self.sideDoor:SetAnchor(GUIItem.Left, GUIItem.Center)
    self.sideDoor:SetTextAlignmentX(GUIItem.Align_Max)
    self.sideDoor:SetTextAlignmentY(GUIItem.Align_Center)
    --self.sideDoor:SetColor(style.textColor)
    self.sideDoor:SetFontIsBold(true)
    self.sideDoor:SetFontName(GUICommanderLogout.kTextFontName)
    self.sideBackground:AddChild(self.sideDoor)
    
    self.powerTxt = GUIManager:CreateTextItem()
    self.powerTxt:SetAnchor(GUIItem.Left, GUIItem.Center)
    self.powerTxt:SetTextAlignmentX(GUIItem.Align_Max)
    self.powerTxt:SetTextAlignmentY(GUIItem.Align_Center)
    --self.powerTxt:SetColor(style.textColor)
    self.powerTxt:SetFontIsBold(true)
    self.powerTxt:SetFontName(GUICommanderLogout.kTextFontName)
    self.powerBackground:AddChild(self.powerTxt)
    
    
end


local onUpdate = GUICommanderLogout.Update

function GUICommanderLogout:Update(deltaTime)
    onUpdate(self, deltaTime)
    Print("uhh")
    
 --origUpdate(self, _, parameters)
     local activePower = PlayerUI_GetActivePower()
     local gLength =  PlayerUI_GetGameLengthTime()
     local fLength = PlayerUI_GetFrontLength()
     local sLength = PlayerUI_GetSiegeLength()
     local ssLength = PlayerUI_GetSideLength()
     local initial = PlayerUI_GetInitialSiegeLength()

     --for i = 1, #parameters do
     --   local p = parameters[i]
     --   Print(p)
     --end
     
        local frontRemain = Clamp(fLength - gLength, 0, fLength)
        local Frontminutes = math.floor( frontRemain / 60 )
        local Frontseconds = math.floor( frontRemain - Frontminutes * 60 )


        local siegeRemain = Clamp(sLength - gLength, 0, sLength)
        local Siegeminutes = math.floor( siegeRemain / 60 )
        local Siegeseconds = math.floor( siegeRemain - Siegeminutes * 60 )
        
        
    --if minutes > 0
    --if seconds > 0
    --if seconds == 0
    --if Frontminutes > 0 then
        --self.frontDoor:SetText(string.format("Front: %s minutes and %s seconds", Frontminutes, Frontseconds))
    --elseif Frontseconds > 0 then
        --self.frontDoor:SetText(string.format("Front: %s seconds", Frontseconds))
    if frontRemain > 0 then     
        self.frontDoor:SetText(string.format("Front: %s:%s", Frontminutes, Frontseconds))
    else
        self.frontDoor:SetText(string.format("Front: OPEN"))
    end
    
    --if Siegeminutes > 0 then
        --self.siegeDoor:SetText(string.format("Siege: %s minutes and %s seconds", Siegeminutes, Siegeseconds))
    --elseif Siegeseconds > 0 then
        --self.siegeDoor:SetText(string.format("Siege: %s seconds", Siegeseconds))
    if siegeRemain > 0 then
        self.siegeDoor:SetText(string.format("Siege: %s:%s", Siegeminutes, Siegeseconds))
    else 
        self.siegeDoor:SetText(string.format("Siege: OPEN"))
    end
    
    if ssLength > 0 then
        local sideRemain = Clamp(ssLength - gLength, 0, ssLength)
        local Sideminutes = math.floor( sideRemain / 60 )
        local Sideseconds = math.floor( sideRemain - Sideminutes * 60 )
        --self.sideDoor:SetVisible(true)
        self.sideDoor:SetText(string.format("Side: %s:%s", Sideminutes, Sideseconds))
    else
        --self.sideDoor:SetVisible(false)
        self.sideDoor:SetText(string.format("Side: OPEN"))
    --fallacy
    end
    
    if siegeRemain == 0 then
        self.powerTxt:SetText(string.format("**"))
    else
    
         if frontRemain > 0 then
            self.powerTxt:SetText(string.format("Dynamic: **"))
         else
            local bonus = ( sLength + (activePower) ) 
            local howMuchBonus = 0
            if activePower == 0 then
                self.powerTxt:SetText(string.format("Draw"))
            elseif  bonus > initial then --initial then
                howMuchBonus = sLength - initial --bonus - initial
                self.powerTxt:SetText(string.format("Add: %s", howMuchBonus))
            else
                howMuchBonus = initial - sLength
                self.powerTxt:SetText(string.format("Deduct: %s", howMuchBonus * -1))
            end
        end
        
    end
    
    
end

local original = GUICommanderLogout.Uninitialize
function GUICommanderLogout:Uninitialize()
    original(self)
     GUI.DestroyItem(self.frame)

end
