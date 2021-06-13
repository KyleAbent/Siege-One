--Kyle 'Avoca' Abent

SentryBattery.kRange = 8
--Script.Load("lua/EntityChangeMixin.lua")--needed for powersource -- to not bug out haha
--Script.Load("lua/PowerSourceMixin.lua")
--Script.Load("lua/PowerConsumerMixin.lua")-- Contradiction!!! 

/*
local networkVars =
{
}

AddMixinNetworkVars(PowerSourceMixin, networkVars)
AddMixinNetworkVars(PowerConsumerMixin, networkVars)--What will happen?!?!?

local oGCre = SentryBattery.OnCreate
function SentryBattery:OnCreate()
    oGCre(self)
     InitMixin(self, EntityChangeMixin)--yes order moatters
    InitMixin(self, PowerSourceMixin)
    InitMixin(self, PowerConsumerMixin)--Oh my goodness!!!
end
*/
local ogIn = SentryBattery.OnInitialized
function SentryBattery:OnInitialized()
    ogIn(self)
    --InitMixin(self, PowerSourceMixin)
    if Server then
        GetRoomPower(self):ToggleCountMapName(self:GetMapName(),1)
    end
    if Client then
        self:MakeLight()
    end
end

 function SentryBattery:PreOnKill(attacker, doer, point, direction)
	    GetRoomPower(self):ToggleCountMapName(self:GetMapName(),-1)
end

if Client then

    function SentryBattery:MakeLight() --ExoSuit
        self.flashlight = Client.CreateRenderLight()
        self.flashlight:SetType(RenderLight.Type_Point)
        self.flashlight:SetCastsShadows(false)
        self.flashlight:SetSpecular(true)
        self.flashlight:SetRadius(64)
        self.flashlight:SetIntensity(15)
        self.flashlight:SetColor(Color(0, .2, 0.9))
        
        self.flashlight:SetIsVisible(true) -- will have to make this oncons

        local coords = self:GetCoords()
        coords.origin = coords.origin + coords.zAxis * 0.75 + coords.yAxis * 4

        self.flashlight:SetCoords(coords)
       -- self.flashlight:SetAngles( Angles(180,88,180) ) --face down shine light
            
        
    end


end


function SentryBattery:GetUnitNameOverride(viewer)

    return "BackupBattery"
    
end


/*
local function doCleanup(self)
        Print("DO CLEANUP")
        local powerConsumerIds = self:GetPowerConsumers()
        
        for _, powerConsumerId in ipairs(powerConsumerIds) do
            local powerConsumer = Shared.GetEntity(powerConsumerId)
            PowerConsumerMixin.OnInitialized(powerConsumer)
        end
end
function SentryBattery:OnDestroy()
    ScriptActor.OnDestroy( self )
    if Server then
        PowerSourceMixin.OnDestroy(self)
        doCleanup(self)
        
    elseif Client then
        if self.flashlight then
            Client.DestroyRenderLight(self.flashlight)
            self.flashlight = nil
        end
    end
    
end

function SentryBattery:GetCanPower(consumer)
            --AS long as I am not the receiver of giving power.
        --return not consumer:GetIsPowered() and consumer ~= self and self:GetDistance(consumer) <= 8 and not self:GetIsPowered() --hahahahah
                --what will happen if battery is placed then power goes up?
                --not consumer get location powerpooint is built? ugh.
      return consumer ~= self and self:GetDistance(consumer) <= 8 
end

-- used for manually triggering power change
function SentryBattery:OnConstructionComplete()
        
        if not self:GetIsPowered() then
            self:SetPoweringState(true)
        end
        
        --interesting huh?
    
end




if Server then


    function SentryBattery:OnPowerOff()
            self:SetPoweringState(true)--hahahaha
            PowerSourceMixin.OnReset(self)
        
    end

    function SentryBattery:OnPowerOn()
            self:SetPoweringState(false)--Only as a backup!!!
        
    end
    function SentryBattery:OnRecycled()
        --DUnno why it's bugging out turning off power. Or power staying on.
            self:SendEntityChanged(nil)
            self:SetPoweringState(false)
    end
end


*/

/*
function SentryBattery:OnAdjustModelCoords(modelCoords)

    local result = modelCoords

    if result then
        result.xAxis = result.xAxis * 1.5
        result.yAxis = result.yAxis * 1.5
        --result.zAxis = result.yAxis * 1.5
    end

    return result

end
*/


--Shared.LinkClassToMap("SentryBattery", SentryBattery.kMapName, networkVars, true)