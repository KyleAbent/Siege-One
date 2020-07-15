--Kyle 'Avoca' Abent

SentryBattery.kRange = 8
Script.Load("lua/PowerSourceMixin.lua")

local networkVars =
{
}

AddMixinNetworkVars(PowerSourceMixin, networkVars)

local oGCre = SentryBattery.OnCreate
function SentryBattery:OnCreate()
    oGCre(self)
    InitMixin(self, PowerSourceMixin)
end

local ogIn = SentryBattery.OnInitialized
function SentryBattery:OnInitialized()
    ogIn(self)
    InitMixin(self, PowerSourceMixin)
    if Client then
        self:MakeLight()
    end
end

if Client then

    function SentryBattery:MakeLight() --ExoSuit
        self.flashlight = Client.CreateRenderLight()
        
        self.flashlight:SetType(RenderLight.Type_Spot)
        self.flashlight:SetColor(Color(.8, .8, 1))
        self.flashlight:SetInnerCone(math.rad(70))
        self.flashlight:SetOuterCone(math.rad(85))
        self.flashlight:SetIntensity(10)
        self.flashlight:SetRadius(25)
        self.flashlight:SetAtmosphericDensity(0.2)
        --self.flashlight:SetGoboTexture("models/marine/male/flashlight.dds")
        
        self.flashlight:SetIsVisible(true)

        local coords = self:GetCoords()
        coords.origin = coords.origin + coords.zAxis * 0.75 + coords.yAxis * 4

        self.flashlight:SetCoords(coords)
        self.flashlight:SetAngles( Angles(180,88,180) ) --face down shine light
            
        
    end


end


function SentryBattery:OnDestroy()
    ScriptActor.OnDestroy( self )
    
    if self.flashlight then
        Client.DestroyRenderLight(self.flashlight)
        self.flashlight = nil
    end
    
end

function SentryBattery:GetCanPower(consumer)
        return self:GetDistance(ent) <= 8
end

function SentryBattery:OnAdjustModelCoords(modelCoords)

    local result = modelCoords

    if result then
        result.xAxis = result.xAxis * 1.5
        result.yAxis = result.yAxis * 1.5
        --result.zAxis = result.yAxis * 1.5
    end

    return result

end

Shared.LinkClassToMap("SentryBattery", SentryBattery.kMapName, networkVars, true)