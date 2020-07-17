Script.Load("lua/2019/EggBeacon.lua")
Script.Load("lua/2019/StructureBeacon.lua")
Script.Load("lua/2019/Wall.lua")
Script.Load("lua/2019/ExoWelder.lua")
Script.Load("lua/2019/ExoFlamer.lua")
Script.Load("lua/Weapons/Alien/PrimalScream.lua")
Script.Load("lua/Weapons/Alien/AcidRocket.lua")
Script.Load("lua/BigMac.lua")
Script.Load("lua/BackupBattery.lua")

local kCachedTechCategories
local kCachedMapNameTechIds
local kCachedTechData


function GetCheckObsLimit(techId, origin, normal, commander)
    local num = 0

        
        for index, obs in ientitylist(Shared.GetEntitiesWithClassname("Observatory")) do
                num = num + 1
        end
    
    return num < 10
    
end


-- Remap techdata for faster lookups
function BuildTechDataCache()
    kCachedTechData = {}
    kCachedMapNameTechIds = {}
    kCachedTechCategories = {}

    if kTechData == nil then
        kTechData = BuildTechData()
    end

    for i = 1, #kTechData do
        local data = kTechData[i]
        local techId = data[kTechDataId]
        if techId then
            kCachedTechData[techId] = data

            local mapName = data[kTechDataMapName]
            -- same mapname is sometimes used twice, e.g. for weapon and dropweapon tech
            if mapName and not kCachedMapNameTechIds[mapName] then
                kCachedMapNameTechIds[mapName] = techId
            end

            local category = data[kTechDataCategory]
            if category ~= nil then
                local t = kCachedTechCategories[category] or {}
                table.insert(t, techId)
                kCachedTechCategories[category] = t
            end
        end
    end
end

-- Deprecated
-- No, NOT deprecated.  Beige needs it for tutorials! :( --all this just to set CC anywhere haha. Set cached. redic.
function SetCachedTechData(techId, fieldName, data, force)

    if kCachedTechData == nil then
        BuildTechDataCache()
    end
    
    assert(kCachedTechData)
    local techData = kCachedTechData[techId]
    
    -- Cannot be used to create a new techData entry -- would screw up the enumeration otherwise.
    assert(techData ~= nil)
    
    techData[fieldName] = data
    return true
    
end

function LookupTechId(mapName)

    -- Initialize table if necessary
    if kTechData == nil then
        kTechData = BuildTechData()
    end

    if kCachedMapNameTechIds == nil then
        BuildTechDataCache()
    end
    
    return kCachedMapNameTechIds[mapName] or kTechId.None

end

function GetCachedTechData(techId, fieldName)

    if kCachedTechData == nil then
        BuildTechDataCache()
    end
    
    local entry = kCachedTechData[techId]
    return entry and entry[fieldName]

end

function GetTechForCategory(techId)

    if kCachedTechCategories == nil then
        BuildTechDataCache()
    end
    
    return kCachedTechCategories[techId] or {}

end


function GetCheckEggBeacon(techId, origin, normal, commander)
    local num = 0

        
        for index, shell in ientitylist(Shared.GetEntitiesWithClassname("EggBeacon")) do
        
           -- if not spur:isa("StructureBeacon") then 
                num = num + 1
          --  end
            
    end
    
    return num < 1 and not GetWhereIsInSiege(origin)
    
end

function GetWallInRoom(origin)

    local location = GetLocationForPoint(origin)
    local locationName = location and location:GetName() or nil
    
    if locationName then
    
        local walls = Shared.GetEntitiesWithClassname("Wall")
        for b = 0, walls:GetSize() - 1 do
        
            local wall = walls:GetEntityAtIndex(b)
            if wall and wall:GetLocationName() == locationName then
                return wall
            end
            
        end
        
    end
    
    return nil
    
end

function GetCheckMarineWall(techId, origin, normal, commander)

    local wall = GetWallInRoom(origin)
    if wall then
        return false
    else
        return true
    end       
end

local kSiege_TechData =
{  


    { [kTechDataId] = kTechId.EggBeacon, 
    [kTechDataCooldown] = kEggBeaconCoolDown, 
    [kTechDataTooltipInfo] = "Eggs Spawn approximately at the placed Egg Beacon. Be careful as infestation is required.", 
    [kTechDataGhostModelClass] = "AlienGhostModel",   
    [kTechDataBuildRequiresMethod] = GetCheckEggBeacon,
    [kTechDataMapName] = EggBeacon.kMapName,        
    [kTechDataDisplayName] = "Egg Beacon",
    [kTechDataCostKey] = kEggBeaconCost,   
    [kTechDataRequiresInfestation] = true, 
    [kTechDataHotkey] = Move.C,   
    [kTechDataBuildTime] = kEggBeaconBuildTime, 
    [kTechDataModel] = EggBeacon.kModelName,   
    [kTechDataBuildMethodFailedMessage] = "1 at a time not in siege",
    [kVisualRange] = 8,
    [kTechDataMaxHealth] = kEggBeaconHealth, [kTechDataMaxArmor] = kEggBeaconArmor},
    
    { [kTechDataId] = kTechId.StructureBeacon, 
    [kTechDataCooldown] = kStructureBeaconCoolDown, 
    [kTechDataTooltipInfo] = "Structures move approximately at the placed location", 
    [kTechDataGhostModelClass] = "AlienGhostModel",   
    [kTechDataMapName] = StructureBeacon.kMapName,        
    [kTechDataDisplayName] = "Structure Beacon",  [kTechDataCostKey] = kStructureBeaconCost,   
    [kTechDataRequiresInfestation] = true, [kTechDataHotkey] = Move.C,   
    [kTechDataBuildTime] = kStructureBeaconBuildTime, 
    [kTechDataModel] = StructureBeacon.kModelName,  
    [kTechDataBuildMethodFailedMessage] = "1 at a time not in siege",
    [kVisualRange] = 8,
    [kTechDataMaxHealth] = kStructureBeaconHealth, [kTechDataMaxArmor] = kStructureBeaconArmor},
    
    
    { [kTechDataId] = kTechId.Wall,  
    [kTechDataMapName] = Wall.kMapName, 
    [kTechDataDisplayName] = "Wall", 
    [kTechIDShowEnables] = false, 
    [kTechDataTooltipInfo] =  "Create your own obstacle with a wall rather than a armory or proto!", 
    [kTechDataModel] = Wall.kModelName, 
    [kTechDataBuildTime] = kWallBuildTime,
    [kTechDataMaxHealth] = kMarineWallHealth,
    [kTechDataMaxArmor] = 0,
    [kTechDataBuildRequiresMethod] = GetCheckMarineWall,
    [kTechDataBuildMethodFailedMessage] = "Limit per room reached", 
    [kTechDataCostKey] = kWallTresCost, 
    [kTechDataSpecifyOrientation] = true,
    [kTechDataPointValue] = 3,
    [kTechDataSupply] = 0},
    
    { [kTechDataId] = kTechId.DualWelderExosuit,    
    [kTechIDShowEnables] = false,     
    [kTechDataDisplayName] = "Dual Exo Welders", 
    [kTechDataMapName] = "exo",         
    [kTechDataCostKey] = kDualExosuitCost - 10, 
    [kTechDataHotkey] = Move.E,
    [kTechDataMaxExtents] = Vector(0.55, 1.2, 0.55),
    [kTechDataTooltipInfo] = "Dual Welders yo", 
    [kTechDataSpawnHeightOffset] = kCommanderEquipmentDropSpawnHeight},


    { [kTechDataId] = kTechId.DualFlamerExosuit,    
    [kTechIDShowEnables] = false,     
    [kTechDataDisplayName] = "Dual Exo Flamer", 
    [kTechDataMapName] = "exo",         
   [kTechDataMaxExtents] = Vector(0.55, 1.2, 0.55),
    [kTechDataCostKey] = kDualExosuitCost - 5, 
    [kTechDataHotkey] = Move.E,
    [kTechDataTooltipInfo] = "Dual Flamers yo", 
    [kTechDataSpawnHeightOffset] = kCommanderEquipmentDropSpawnHeight},
    
    --Thanks dragon ns2c
    { [kTechDataId] = kTechId.PrimalScream,  
    [kTechDataCategory] = kTechId.Lerk,
    [kTechDataDisplayName] = "Primal Scream",
    [kTechDataMapName] =  Primal.kMapName,
    --[kTechDataCostKey] = kPrimalScreamCostKey, 
    -- [kTechDataResearchTimeKey] = kPrimalScreamTimeKey, 
    [kTechDataTooltipInfo] = "+Energy to teammates, enzyme cloud"},
 
    
    { [kTechDataId] = kTechId.AcidRocket,        
    [kTechDataCategory] = kTechId.Fade,   
    [kTechDataMapName] = AcidRocket.kMapName,  
    [kTechDataCostKey] = kStabResearchCost,
    [kTechDataResearchTimeKey] = kStabResearchTime, 
    [kTechDataDamageType] = kAcidRocketDamageType,  
    [kTechDataDisplayName] = "AcidRocket",
    [kTechDataTooltipInfo] = "Ranged Projectile dealing damage only to armor and structures"},
    
    {
    [kTechDataId] = kTechId.BigMac,
   -- [kTechDataSupply] = kMACSupply,
    [kTechDataHint] = "Comes with Fries",
    [kTechDataMapName] = BigMac.kMapName,
    [kTechDataDisplayName] = "Big Mac",
    [kTechDataMaxHealth] = kMACHealth, --come back to these
    [kTechDataMaxArmor] = kMACArmor,
    [kTechDataCostKey] = 15,
    --[kTechDataResearchTimeKey] = kMACBuildTime,
    [kTechDataModel] = MAC.kModelName,
    [kTechDataDamageType] = kMACAttackDamageType,
    [kTechDataInitialEnergy] = kMACInitialEnergy,
    [kTechDataMaxEnergy] = kMACMaxEnergy,
    [kTechDataMenuPriority] = 2,
    [kTechDataPointValue] = kMACPointValue * 1.3,
    [kTechDataHotkey] = Move.M,
    [kTechDataTooltipInfo] = "One Mac, make it Big",
     [kTechDataBuildTime] = 8,
     [kTechDataGhostModelClass] = "MarineGhostModel", 
     [kStructureAttachRange] = 8,
     [kStructureBuildNearClass] = "RoboticsFactory",
      [kStructureAttachId] = kTechId.RoboticsFactory,
     -- [kTechDataGhostGuidesMethod] = GetMacGhostGuides, -- ahh
      [kTechDataBuildMethodFailedMessage] = "Testing 1 GIANT Mac as powerful as 5",
    [kTechDataBuildRequiresMethod] = GetCheckMacLimit,
    },
    
    
        {
            [kTechDataId] = kTechId.BackupBattery,
            [kTechDataSupply] = 0,
            [kTechDataBuildRequiresMethod] = GetRoomHasNoBackupBattery,
            [kTechDataBuildMethodFailedMessage] = "COMMANDERERROR_ONLY_ONE_BATTERY_PER_ROOM",
            [kTechDataHint] = "Backup Power",
            [kTechDataGhostModelClass] = "MarineGhostModel",
            [kTechDataMapName] = BackupBattery.kMapName,
            [kTechDataDisplayName] = "Backup Battery",
            [kTechDataCostKey] = kSentryBatteryCost,
            [kTechDataPointValue] = kSentryBatteryPointValue,
            [kTechDataModel] = BackupBattery.kModelName,
            [kTechDataEngagementDistance] = 2,
            [kTechDataBuildTime] = kSentryBatteryBuildTime, --adjusted
            [kTechDataMaxHealth] = kSentryBatteryHealth, --adjusted
            [kTechDataMaxArmor] = kSentryBatteryArmor, --adjusted
            [kTechDataTooltipInfo] = "Provides power when PowerPoint is down",
            [kTechDataHotkey] = Move.S,
            [kTechDataNotOnInfestation] = kPreventMarineStructuresOnInfestation,
            [kVisualRange] = 8,
            [kTechDataObstacleRadius] = 0.25,
            [kTechDataSpecifyOrientation] = true,
        },
 
  }
    
    
local buildTechData = BuildTechData
function BuildTechData()

    local defaultTechData = buildTechData()
    local moddedTechData = {}
    local usedTechIds = {}
    
    for i = 1, #kSiege_TechData do
        local techEntry = kSiege_TechData[i]
        table.insert(moddedTechData, techEntry)
        table.insert(usedTechIds, techEntry[kTechDataId])
    end
    
    for i = 1, #defaultTechData do
        local techEntry = defaultTechData[i]
        if not table.contains(usedTechIds, techEntry[kTechDataId]) then
            table.insert(moddedTechData, techEntry)
        end
    end
    
    return moddedTechData

end



