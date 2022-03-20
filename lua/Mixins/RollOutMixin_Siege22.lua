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
function RolloutMixin:Rollout(where)
    print("Rollout hook")
        freeOrigin = FindFreeSpace(where,2,6)
        self:SetOrigin(freeOrigin)
        self:ClearOrders()
        self:SetIgnoreOrders(false)
end




