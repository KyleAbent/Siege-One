
local origCreate = MAC.OnCreate 

function MAC:OnCreate()
    origCreate(self)
    MAC.kConstructRate = 0
    MAC.kWeldRate = 0
    MAC.kOrderScanRadius = 0
    MAC.kRepairHealthPerSecond = 0
    MAC.kMoveSpeed = 0
    MAC.kInfestationMoveSpeed = 0
    MAC.kHoverHeight = 0
    MAC.kStartDistance = 0
    MAC.kWeldDistance = 0
    MAC.kBuildDistance = 0    // Distance at which bot can start building a structure.
end

function MAC:AdjustValues()
    kMACConstructEfficacy = .3 * 5
    MAC.kConstructRate = 0.4 -- 10
    MAC.kWeldRate = 0.5 --* 5
    MAC.kOrderScanRadius = 12
    MAC.kRepairHealthPerSecond = 150 --50 * 5
    --MAC.kHealth = kMACHealth * 5
    --MAC.kArmor = kMACArmor * 5
    MAC.kMoveSpeed = 6
    MAC.kHoverHeight = 0.5
    MAC.kStartDistance = 3
    MAC.kWeldDistance = 2
    MAC.kBuildDistance = 2 
end