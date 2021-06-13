local networkVars = {

isBeefy = "boolean", 
  
 }
 
local ogCreate = Armory.OnCreate
 
function Armory:OnCreate()
    ogCreate(self)
     self.isBeefy = false

end

if Server then
    local ogResearch = Armory.OnResearchComplete
    function Armory:OnResearchComplete(researchId)
         ogResearch(self, researchId)
         if researchId == kTechId.ArmoryBeefUp then
            self.isBeefy = true
         end

    end
end


function Armory:OnAdjustModelCoords(modelCoords)
    local scale = 1
    if self.isBeefy then
        scale = 1.5
     end
    modelCoords.xAxis = modelCoords.xAxis * scale
    modelCoords.yAxis = modelCoords.yAxis * scale
    modelCoords.zAxis = modelCoords.zAxis * scale

    return modelCoords
end


local origButtons = Armory.GetTechButtons
function Armory:GetTechButtons(techId)

    local techButtons = origButtons(self, techId)
    if not self.isBeefy then
        techButtons[4] = kTechId.ArmoryBeefUp
    end
    
    return techButtons
    
    
end

function Armory:OnPowerOn()
	GetRoomPower(self):ToggleCountMapName(self:GetMapName(),1)
end

function Armory:OnPowerOff()
	 GetRoomPower(self):ToggleCountMapName(self:GetMapName(),-1)
end

 function Armory:PreOnKill(attacker, doer, point, direction)
	  if self:GetIsPowered() then
	    GetRoomPower(self):ToggleCountMapName(self:GetMapName(),-1) 
	  end
end

Shared.LinkClassToMap("Armory", Armory.kMapName, networkVars, true)
