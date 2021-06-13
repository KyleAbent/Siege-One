function PhaseGate:OnPowerOn()
	 GetRoomPower(self):ToggleCountMapName(self:GetMapName(), 1)
end

function PhaseGate:OnPowerOff()
	 GetRoomPower(self):ToggleCountMapName(self:GetMapName(),-1)
end

 function PhaseGate:PreOnKill(attacker, doer, point, direction)
      
	  if self:GetIsPowered() then
	    GetRoomPower(self):ToggleCountMapName(self:GetMapName(),-1)
	  end
end