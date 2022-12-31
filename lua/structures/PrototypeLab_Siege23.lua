local origInit = PrototypeLab.OnInitialized
function PrototypeLab:OnInitialized()
    origInit(self)
    if Server then
        GetRoomPower(self):ToggleCountMapName(self:GetMapName(),1)
    end    
end

if Server then
    function PrototypeLab:PreOnKill(attacker, doer, point, direction)
            GetRoomPower(self):ToggleCountMapName(self:GetMapName(),-1) 
    end
end
