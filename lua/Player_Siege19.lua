function Player:GetFrontTime()
    --Print("uhh")
    Print("kReduceDoorTimeBy is %s", kReduceDoorTimeBy)
    return kFrontTime - kReduceDoorTimeBy
end
