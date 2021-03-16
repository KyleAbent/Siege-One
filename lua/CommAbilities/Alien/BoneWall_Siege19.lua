local networkVars =
{

    modelsize = "float (0 to 10 by .1)",
}

local origInit = BoneWall.OnInitialized
function BoneWall:OnInitialized()
   origInit(self)
  self.modelsize = 1 
end

function BoneWall:SetSmaller()
    self.modelsize = 0.5
end

function BoneWall:OnAdjustModelCoords(modelCoords)
    local coords = modelCoords
	local scale = self.modelsize
	local y = scale
	if y < 1 then y = 1 end
        coords.xAxis = coords.xAxis * scale
        coords.yAxis = coords.yAxis * y
        coords.zAxis = coords.zAxis * scale
    return coords
end

Shared.LinkClassToMap("BoneWall", BoneWall.kMapName, networkVars)

