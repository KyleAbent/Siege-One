local function GetHasSentryBatteryInRadius(self)
      local backupbattery = GetEntitiesWithinRange("SentryBattery", self:GetOrigin(), 8)
          for index, battery in ipairs(backupbattery) do
            if GetIsUnitActive(battery) then return true end
           end      
 
   return false
end
--This is simple way but I was hoping to use powersource oh well. 
--This one will always look for sentrybattery nearby
--Whereas powersource will look only when necessary. or so I think
--Saving time here.
function PowerConsumerMixin:GetIsPowered() 
    return self.powered or self.powerSurge or GetHasSentryBatteryInRadius(self)
end