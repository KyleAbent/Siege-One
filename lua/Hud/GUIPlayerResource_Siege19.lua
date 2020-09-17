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


GUIPlayerResource.kFrontTimeBackgroundSize = Vector(280, 58, 0)
GUIPlayerResource.kFrontTimeBackgroundPos = Vector(-300, -75, 0) -- -100

GUIPlayerResource.kSiegeTimeBackgroundSize = Vector(280, 58, 0)
GUIPlayerResource.kSiegeTimeBackgroundPos = Vector(-300, -10, 0) -- -100

--GUIPlayerResource.kPersonalTextPos = Vector(0.4,0.75,0)--100, 4, 0

local kBackgroundTextures = { alien = PrecacheAsset("ui/alien_HUD_presbg.dds"), marine = PrecacheAsset("ui/marine_HUD_presbg.dds") }

local pos = Vector(300,4,0)
local posTwo = Vector(300,4,0)

GUIPlayerResource.kTextFontName = Fonts.kAgencyFB_Small

local originit = GUIPlayerResource.Initialize
function GUIPlayerResource:Initialize(style, teamNumber)

    originit(self, style, teamNumber)
    
    self.frontBackground = self.script:CreateAnimatedGraphicItem()
    self.frontBackground:SetAnchor(GUIItem.Right, GUIItem.Center)
    self.frontBackground:SetTexture(kBackgroundTextures[style.textureSet])
    self.frontBackground:AddAsChildTo(self.frame)
    
    self.siegeBackground = self.script:CreateAnimatedGraphicItem()
    self.siegeBackground:SetAnchor(GUIItem.Right, GUIItem.Center)
    self.siegeBackground:SetTexture(kBackgroundTextures[style.textureSet])
    self.siegeBackground:AddAsChildTo(self.frame)
    
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
    
end

--local origUpdate = GUIPlayerResource.Update
function GUIPlayerResource:UpdateFrontSiege(_, parameters)

    --origUpdate(self, _, parameters)
     local gStart, gLength, fLength, sLength, ssLength = parameters[1],  parameters[2], parameters[3], parameters[4],  parameters[5]
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
    if Frontminutes > 0 then
        self.frontDoor:SetText(string.format("Front: %s minutes and %s seconds", Frontminutes, Frontseconds))
    elseif Frontseconds > 0 then
        self.frontDoor:SetText(string.format("Front: %s seconds", Frontseconds))
    else
        self.frontDoor:SetText(string.format("Front: OPEN"))
    end
    
    if Siegeminutes > 0 then
        self.siegeDoor:SetText(string.format("Siege: %s minutes and %s seconds", Siegeminutes, Siegeseconds))
    elseif Siegeseconds > 0 then
        self.siegeDoor:SetText(string.format("Siege: %s seconds", Siegeseconds))
    else 
        self.siegeDoor:SetText(string.format("Siege: OPEN"))
    end
    
    
    
end