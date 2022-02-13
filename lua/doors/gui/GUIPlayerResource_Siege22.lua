--Kyle 'Avoca' Abent
GUIPlayerResource.kPersonalTimeIcon = { Width = 0, Height = 0, X = 0, Y = 0 }
GUIPlayerResource.kPersonalTimeIcon.Width = 32
GUIPlayerResource.kPersonalTimeIcon.Height = 64

GUIPlayerResource.kPersonalTimeIconSize = Vector(GUIPlayerResource.kPersonalResourceIcon.Width, GUIPlayerResource.kPersonalResourceIcon.Height, 0)
GUIPlayerResource.kPersonalTimeIconSizeBig = Vector(GUIPlayerResource.kPersonalResourceIcon.Width, GUIPlayerResource.kPersonalResourceIcon.Height, 0) * 1.1


GUIPlayerResource.kPersonalTimeIconPos = Vector(30,-4,0)
GUIPlayerResource.kPersonalTimeTextPos = Vector(100,4,0)
GUIPlayerResource.kTimeDescriptionPos = Vector(110,4,0)
GUIPlayerResource.kTimeGainedTextPos = Vector(90,-6,0)

GUIPlayerResource.kFontSizePersonalTime = 20
GUIPlayerResource.kFontSizePersonalTimeBig = 20


GUIPlayerResource.kFrontTimeBackgroundSize = Vector(180, 58, 0)
GUIPlayerResource.kFrontTimeBackgroundPos = Vector(-350, -175, 0)

GUIPlayerResource.kSideTimeBackgroundSize = Vector(180, 58, 0)
GUIPlayerResource.kSideTimeBackgroundPos = Vector(-150, -175, 0)


GUIPlayerResource.kSiegeTimeBackgroundSize = Vector(180, 58, 0)
GUIPlayerResource.kSiegeTimeBackgroundPos = Vector(50, -175, 0)

/*
GUIPlayerResource.kPowerBackgroundSize = Vector(180, 58, 0)
GUIPlayerResource.kPowerBackgroundPos = Vector(250, -175, 0)
*/

local kBackgroundTextures = { alien = PrecacheAsset("ui/alien_HUD_presbg.dds"), marine = PrecacheAsset("ui/marine_HUD_presbg.dds") }

local pos = Vector(100,4,0)
local posTwo = Vector(100,4,0)

GUIPlayerResource.kTextFontName = Fonts.kAgencyFB_Small

local originit = GUIPlayerResource.Initialize
function GUIPlayerResource:Initialize(style, teamNumber)

    originit(self, style, teamNumber)
    
    self.frontBackground = self.script:CreateAnimatedGraphicItem()
    self.frontBackground:SetAnchor(GUIItem.Center, GUIItem.Bottom)
    self.frontBackground:SetTexture(kBackgroundTextures[style.textureSet])
    self.frontBackground:AddAsChildTo(self.frame)
    
    self.siegeBackground = self.script:CreateAnimatedGraphicItem()
    self.siegeBackground:SetAnchor(GUIItem.Center, GUIItem.Bottom)
    self.siegeBackground:SetTexture(kBackgroundTextures[style.textureSet])
    self.siegeBackground:AddAsChildTo(self.frame)
    
    self.sideBackground = self.script:CreateAnimatedGraphicItem()
    self.sideBackground:SetAnchor(GUIItem.Center, GUIItem.Bottom)
    self.sideBackground:SetTexture(kBackgroundTextures[style.textureSet])
    self.sideBackground:AddAsChildTo(self.frame)
    
    /*
    self.powerBackground = self.script:CreateAnimatedGraphicItem()
    self.powerBackground:SetAnchor(GUIItem.Center, GUIItem.Bottom)
    self.powerBackground:SetTexture(kBackgroundTextures[style.textureSet])
    self.powerBackground:AddAsChildTo(self.frame)
    */
    
    self.frontDoor = self.script:CreateAnimatedTextItem()
    self.frontDoor:SetAnchor(GUIItem.Left, GUIItem.Center)
    self.frontDoor:SetTextAlignmentX(GUIItem.Align_Max)
    self.frontDoor:SetTextAlignmentY(GUIItem.Align_Center)
    self.frontDoor:SetColor(style.textColor)
    self.frontDoor:SetFontIsBold(true)
    self.frontDoor:SetFontName(GUIPlayerResource.kTextFontName)
    self.frontBackground:AddChild(self.frontDoor)
    
    self.siegeDoor = self.script:CreateAnimatedTextItem()
    self.siegeDoor:SetAnchor(GUIItem.Left, GUIItem.Center)
    self.siegeDoor:SetTextAlignmentX(GUIItem.Align_Max)
    self.siegeDoor:SetTextAlignmentY(GUIItem.Align_Center)
    self.siegeDoor:SetColor(style.textColor)
    self.siegeDoor:SetFontIsBold(true)
    self.siegeDoor:SetFontName(GUIPlayerResource.kTextFontName)
    self.siegeBackground:AddChild(self.siegeDoor)
    
    self.sideDoor = self.script:CreateAnimatedTextItem()
    self.sideDoor:SetAnchor(GUIItem.Left, GUIItem.Center)
    self.sideDoor:SetTextAlignmentX(GUIItem.Align_Max)
    self.sideDoor:SetTextAlignmentY(GUIItem.Align_Center)
    self.sideDoor:SetColor(style.textColor)
    self.sideDoor:SetFontIsBold(true)
    self.sideDoor:SetFontName(GUIPlayerResource.kTextFontName)
    self.sideBackground:AddChild(self.sideDoor)
    
    /*
    self.powerTxt = self.script:CreateAnimatedTextItem()
    self.powerTxt:SetAnchor(GUIItem.Left, GUIItem.Center)
    self.powerTxt:SetTextAlignmentX(GUIItem.Align_Max)
    self.powerTxt:SetTextAlignmentY(GUIItem.Align_Center)
    self.powerTxt:SetColor(style.textColor)
    self.powerTxt:SetFontIsBold(true)
    self.powerTxt:SetFontName(GUIPlayerResource.kTextFontName)
    self.powerBackground:AddChild(self.powerTxt)
    */

end

local origreset = GUIPlayerResource.Reset

function GUIPlayerResource:Reset(scale)
    origreset(self, scale)
    
    self.scale = scale

    self.frontBackground:SetUniformScale(self.scale)
    self.frontBackground:SetPosition(GUIPlayerResource.kFrontTimeBackgroundPos) 
    self.frontBackground:SetSize(GUIPlayerResource.kFrontTimeBackgroundSize)
    
    self.siegeBackground:SetUniformScale(self.scale)
    self.siegeBackground:SetPosition(GUIPlayerResource.kSiegeTimeBackgroundPos)
    self.siegeBackground:SetSize(GUIPlayerResource.kSiegeTimeBackgroundSize)
    
    self.sideBackground:SetUniformScale(self.scale)
    self.sideBackground:SetPosition(GUIPlayerResource.kSideTimeBackgroundPos)
    self.sideBackground:SetSize(GUIPlayerResource.kSideTimeBackgroundSize)
    
    /*
    self.powerBackground:SetUniformScale(self.scale)
    self.powerBackground:SetPosition(GUIPlayerResource.kPowerBackgroundPos)
    self.powerBackground:SetSize(GUIPlayerResource.kPowerBackgroundSize)
    */
    
    self.frontDoor:SetScale(Vector(1,1,1) * self.scale * 1.0)
    self.frontDoor:SetFontSize(GUIPlayerResource.kFontSizePersonal)
    self.frontDoor:SetPosition(pos)
    self.frontDoor:SetFontName(GUIPlayerResource.kTextFontName)
    GUIMakeFontScale(self.frontDoor)
    
    self.siegeDoor:SetScale(Vector(1,1,1) * self.scale * 1.0)
    self.siegeDoor:SetFontSize(GUIPlayerResource.kFontSizePersonal)
    self.siegeDoor:SetPosition(posTwo)
    self.siegeDoor:SetFontName(GUIPlayerResource.kTextFontName)
    GUIMakeFontScale(self.siegeDoor)
    
    self.sideDoor:SetScale(Vector(1,1,1) * self.scale * 1.0)
    self.sideDoor:SetFontSize(GUIPlayerResource.kFontSizePersonal)
    self.sideDoor:SetPosition(posTwo)
    self.sideDoor:SetFontName(GUIPlayerResource.kTextFontName)
    GUIMakeFontScale(self.sideDoor)
    
    /*
    self.powerTxt:SetScale(Vector(1,1,1) * self.scale * 1.0)
    self.powerTxt:SetFontSize(GUIPlayerResource.kFontSizePersonal)
    self.powerTxt:SetPosition(posTwo)
    self.powerTxt:SetFontName(GUIPlayerResource.kTextFontName)
    GUIMakeFontScale(self.powerTxt)
    */
    
end

--local origUpdate = GUIPlayerResource.Update
function GUIPlayerResource:UpdateFrontSiege(_, parameters)
     local activePower, gLength, fLength, sLength, ssLength, adjustment = parameters[1],  parameters[2], parameters[3], parameters[4],  parameters[5], parameters[6]
     
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