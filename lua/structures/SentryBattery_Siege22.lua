local ogIn = SentryBattery.OnInitialized
function SentryBattery:OnInitialized()
    ogIn(self)
    --InitMixin(self, PowerSourceMixin)
    if Server then
        GetRoomPower(self):ToggleCountMapName(self:GetMapName(),1)
    end
    --if Client then
     --   self:MakeLight()
    --end
end

if Server then
     function SentryBattery:PreOnKill(attacker, doer, point, direction)
            GetRoomPower(self):ToggleCountMapName(self:GetMapName(),-1)
    end
end