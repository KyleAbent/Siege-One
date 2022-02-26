/*--this entire file is not necessary, we want to remove all its content from functioning
print("REPLACED")
RolloutMixin = CreateMixin(RolloutMixin)
RolloutMixin.type = "Rollout"

RolloutMixin.expectedMixins =
{

}

function RolloutMixin:__initmixin()
    print("calling replaced")
end
*/

--hack it
origRollOut = RolloutMixin.Rollout
function RolloutMixin:Rollout(factory, factoryRolloutLength)
    print("Rollout hook")
    --orig formula from hooked file
    local rearEndSize = math.abs(self:GetModelExtents().z)
    local rolloutLength = factoryRolloutLength + rearEndSize
    local rearEndSize = math.abs(self:GetModelExtents().z)
    local rolloutLength = factoryRolloutLength + rearEndSize
    local direction = Vector(factory:GetAngles():GetCoords().zAxis)    
    local rolloutPoint = factory:GetOrigin() + direction * rolloutLength
    self.rolloutTargetPoint = rolloutPoint
        --get to the point
        --self:SetIgnoreOrders(false)
        --self:ClearOrders()
        freeOrigin = FindFreeSpace(self.rolloutTargetPoint,2,6)
        self:SetOrigin(freeOrigin)
        factory:CompleteRollout(self)
    --self.rolloutSourceFactory:CompleteRollout(self)
end




