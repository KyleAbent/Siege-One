GUIInsight_TopBar.kPersonalTimeIcon = { Width = 0, Height = 0, X = 0, Y = 0 }
GUIInsight_TopBar.kPersonalTimeIcon.Width = 32
GUIInsight_TopBar.kPersonalTimeIcon.Height = 64

--GUIInsight_TopBar.kPersonalTimeIconSize = Vector(GUIInsight_TopBar.kPersonalResourceIcon.Width, GUIInsight_TopBar.kPersonalResourceIcon.Height, 0)
--GUIInsight_TopBar.kPersonalTimeIconSizeBig = Vector(GUIInsight_TopBar.kPersonalResourceIcon.Width, GUIInsight_TopBar.kPersonalResourceIcon.Height, 0) * 1.1


GUIInsight_TopBar.kPersonalTimeIconPos = Vector(30,-4,0)
GUIInsight_TopBar.kPersonalTimeTextPos = Vector(100,4,0)
GUIInsight_TopBar.kTimeDescriptionPos = Vector(110,4,0)
GUIInsight_TopBar.kTimeGainedTextPos = Vector(90,-6,0)

GUIInsight_TopBar.kFontSizePersonalTime = 20
GUIInsight_TopBar.kFontSizePersonalTimeBig = 20


GUIInsight_TopBar.kFrontTimeBackgroundSize = Vector(180, 58, 0)
GUIInsight_TopBar.kFrontTimeBackgroundPos = Vector(-300, -175, 0) 

GUIInsight_TopBar.kSideTimeBackgroundSize = Vector(180, 58, 0)
GUIInsight_TopBar.kSideTimeBackgroundPos = Vector(-100, -175, 0)


GUIInsight_TopBar.kSiegeTimeBackgroundSize = Vector(180, 58, 0)
GUIInsight_TopBar.kSiegeTimeBackgroundPos = Vector(100, -175, 0)

/*
GUIInsight_TopBar.kPowerBackgroundSize = Vector(180, 58, 0)
GUIInsight_TopBar.kPowerBackgroundPos = Vector(300, -175, 0) 
*/

GUIInsight_TopBar.kTextFontName = Fonts.kAgencyFB_Small



local function CreateAvocaDisplay(scriptHandle, hudLayer, frame, style, teamNum)

    local playerResource = GUIInsight_TopBar()
    playerResource.script = scriptHandle
    playerResource.hudLayer = hudLayer
    playerResource.frame = frame
    playerResource:Initialize(style, teamNum)
    
    return playerResource
    
end


local origInit = GUIInsight_TopBar.Initialize

function GUIInsight_TopBar:Initialize()
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
    self.frontBackground:SetAnchor(GUIItem.Center, GUIItem.Bottom)
    --self.frontBackground:SetTexture(kBackgroundTextures[style.textureSet])
    self.frontBackground:SetPosition(GUIInsight_TopBar.kFrontTimeBackgroundPos) 
    self.frame:AddChild(self.frontBackground)
    
    self.siegeBackground = GUIManager:CreateGraphicItem()
    self.siegeBackground:SetAnchor(GUIItem.Center, GUIItem.Bottom)
    --self.siegeBackground:SetTexture(kBackgroundTextures[style.textureSet])
    self.siegeBackground:SetPosition(GUIInsight_TopBar.kSiegeTimeBackgroundPos)
    self.frame:AddChild(self.siegeBackground)
    
    self.sideBackground = GUIManager:CreateGraphicItem()
    self.sideBackground:SetAnchor(GUIItem.Center, GUIItem.Bottom)
    --self.sideBackground:SetTexture(kBackgroundTextures[style.textureSet])
    self.sideBackground:SetPosition(GUIInsight_TopBar.kSideTimeBackgroundPos)
    self.frame:AddChild(self.sideBackground)
    
    /*
    self.powerBackground =  GUIManager:CreateGraphicItem()
    self.powerBackground:SetAnchor(GUIItem.Center, GUIItem.Bottom)
    --self.powerBackground:SetTexture(kBackgroundTextures[style.textureSet])
     self.powerBackground:SetPosition(GUIInsight_TopBar.kPowerBackgroundPos)
    self.frame:AddChild(self.powerBackground)
    */
    
    self.frontDoor = GUIManager:CreateTextItem()
    self.frontDoor:SetAnchor(GUIItem.Left, GUIItem.Center)
    self.frontDoor:SetTextAlignmentX(GUIItem.Align_Max)
    self.frontDoor:SetTextAlignmentY(GUIItem.Align_Center)
    --self.frontDoor:SetColor(style.textColor)
    self.frontDoor:SetFontIsBold(true)
    self.frontDoor:SetFontName(GUIInsight_TopBar.kTextFontName)
    self.frontBackground:AddChild(self.frontDoor)
    
    self.siegeDoor = GUIManager:CreateTextItem()
    self.siegeDoor:SetAnchor(GUIItem.Left, GUIItem.Center)
    self.siegeDoor:SetTextAlignmentX(GUIItem.Align_Max)
    self.siegeDoor:SetTextAlignmentY(GUIItem.Align_Center)
    --self.siegeDoor:SetColor(style.textColor)
    self.siegeDoor:SetFontIsBold(true)
    self.siegeDoor:SetFontName(GUIInsight_TopBar.kTextFontName)
    GUIMakeFontScale(self.siegeDoor)
    self.siegeBackground:AddChild(self.siegeDoor)
    
    self.sideDoor = GUIManager:CreateTextItem()
    self.sideDoor:SetAnchor(GUIItem.Left, GUIItem.Center)
    self.sideDoor:SetTextAlignmentX(GUIItem.Align_Max)
    self.sideDoor:SetTextAlignmentY(GUIItem.Align_Center)
    --self.sideDoor:SetColor(style.textColor)
    self.sideDoor:SetFontIsBold(true)
    self.sideDoor:SetFontName(GUIInsight_TopBar.kTextFontName)
    self.sideBackground:AddChild(self.sideDoor)
    
    /*
    self.powerTxt = GUIManager:CreateTextItem()
    self.powerTxt:SetAnchor(GUIItem.Left, GUIItem.Center)
    self.powerTxt:SetTextAlignmentX(GUIItem.Align_Max)
    self.powerTxt:SetTextAlignmentY(GUIItem.Align_Center)
    --self.powerTxt:SetColor(style.textColor)
    self.powerTxt:SetFontIsBold(true)
    self.powerTxt:SetFontName(GUIInsight_TopBar.kTextFontName)
    self.powerBackground:AddChild(self.powerTxt)
    */
    
    
end


local onUpdate = GUIInsight_TopBar.Update

function GUIInsight_TopBar:Update(deltaTime)
    onUpdate(self, deltaTime)
    
      --Print("uhh")
     local gLength =  PlayerUI_GetGameLengthTime()
     local fLength = PlayerUI_GetFrontLength()
     local sLength = PlayerUI_GetSiegeLength()
     local ssLength = PlayerUI_GetSideLength()
     --local adjustment = PlayerUI_GetDynamicLength()
     
        local frontRemain = Clamp(fLength - gLength, 0, fLength)
        local Frontminutes = math.floor( frontRemain / 60 )
        local Frontseconds = math.floor( frontRemain - Frontminutes * 60 )

    if frontRemain > 0 then     
        self.frontDoor:SetText(string.format("Front: %s:%s", Frontminutes, Frontseconds))
    else
        self.frontDoor:SetText(string.format("Front: OPEN"))
    end

    local siegeRemain = Clamp(sLength - gLength, 0, sLength)
    local Siegeminutes = math.floor( siegeRemain / 60 )
    local Siegeseconds = math.floor( siegeRemain - Siegeminutes * 60 )
        
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
    
    /*
    local isNegative = false
        if adjustment < 0 then
            isNegative = true
            adjustment = adjustment * -1
        end
            
    local adjMi = math.floor( adjustment / 60 )
    local adjSe = math.floor( adjustment - adjMi * 60 )
    
    
    if siegeRemain == 0 then
        self.powerTxt:SetText(string.format("**"))
    else  
        if isNegative then
            self.powerTxt:SetText(string.format("Adj: -%s:%s", adjMi, adjSe))
        else
            self.powerTxt:SetText(string.format("Adj: %s:%s", adjMi, adjSe))
        end
    end
    */
    
end

local original = GUIInsight_TopBar.Uninitialize
function GUIInsight_TopBar:Uninitialize()
    original(self)
     GUI.DestroyItem(self.frame)

end
