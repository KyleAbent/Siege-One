Script.Load("lua/2019/EggBeacon.lua")
Script.Load("lua/2019/StructureBeacon.lua")
Script.Load("lua/2019/AlienTechPoint.lua")
Script.Load("lua/2019/Wall.lua")
Script.Load("lua/2019/ExoWelder.lua")
Script.Load("lua/2019/ExoFlamer.lua")
Script.Load("lua/2019/ExoGrenader.lua")
Script.Load("lua/Weapons/Alien/PrimalScream.lua")
Script.Load("lua/Weapons/Alien/AcidRocket.lua")
Script.Load("lua/Weapons/Alien/GorillaGlue.lua")
//Script.Load("lua/ARC_Siege19.lua")
Script.Load("lua/2019/LoneCyst.lua")
Script.Load("lua/BackupBattery.lua")

local kCachedTechCategories
local kCachedMapNameTechIds
local kCachedTechData


-- Returns true if specified class name is used to attach objects to
function GetIsAttachment(className)
    return (className == "TechPoint") or (className == "ResourcePoint") or (className == "AlienTechPoint")
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

function GetCheckAlienTechPoint(techId, origin, normal, commander)
        
        for index, atp in ientitylist(Shared.GetEntitiesWithClassname("AlienTechPoint")) do
                return false
        end
    
    
    return true //GetFrontDoorOpen <- can aliens really get the 600 res before front door open? nah
end
function GetCheckEggBeacon(techId, origin, normal, commander)
    local num = 0

        
        for index, shell in ientitylist(Shared.GetEntitiesWithClassname("EggBeacon")) do
        
           -- if not spur:isa("StructureBeacon") then 
                num = num + 1
          --  end
            
    end
    
    return num < 1 and not GetWhereIsInSiege(origin) and GetSetupConcluded()
    
end
function GetCheckStructureBeacon(techId, origin, normal, commander)
    local num = 0

        
        for index, shell in ientitylist(Shared.GetEntitiesWithClassname("StructureBeacon")) do
        
           -- if not spur:isa("StructureBeacon") then 
                num = num + 1
          --  end
            
    end
    
    return num < 1 and not GetWhereIsInSiege(origin) and GetSetupConcluded()
    
end
function GetCheckLoneCyst(techId, origin, normal, commander)
    
    return  GetSetupConcluded() and not GetWhereIsInSiege(origin)
    
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


    { [kTechDataId] = kTechId.LerkLift, 
    [kTechDataDisplayName] = "LerkLift", 
    --[kTechDataCostKey] = kLerkLiftResearchCost, 
    --[kTechDataResearchTimeKey] = kLerkLiftResearchTime, 
    [kTechDataTooltipInfo] = "Enables LerkLift for Gorges and Lerks. One gorge per lerk. Both the lerk and gorge may press E on eachother to activate/deactivate." },
     
     
    { [kTechDataId] = kTechId.AdvancedBeacon,   
    [kTechDataBuildTime] = 0.1,   
    [kTechDataCooldown] = kAdvancedBeaconCoolDown,
    [kTechDataDisplayName] = "Advanced Beacon",   
    [kTechDataHotkey] = Move.B, 
    [kTechDataCostKey] = kObservatoryDistressBeaconCost * 2.5, 
    [kTechDataTooltipInfo] = "Teleports Exos and Revives Dead Players. Also shuts down power to this observatory for 15 seconds (cannot be surged)"},

    { [kTechDataId] = kTechId.SiegeBeacon,  
    [kTechDataBuildTime] = 0.1,   
    [kTechDataDisplayName] = "SiegeBeacon", 
    [kTechDataHotkey] = Move.B, 
    [kTechDataCostKey] = kObservatoryDistressBeaconCost * 3.5, 
    [kTechDataTooltipInfo] =  "(Siege must be open for this to work) Once per game, advanced beacon located inside Siege Room rather than closest CC. Choose your timing wisely. Also shuts down power to this observatory for 15 seconds (cannot be surged)"},
    
    
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
    
    { [kTechDataId] = kTechId.LoneCyst, 
    [kTechDataCooldown] = kEggBeaconCoolDown, 
    [kTechDataTooltipInfo] = "A lonely cyst which does not require a parent. Grows by itself overtime. Perfect for stealth. Cannot be placed during Setup or inside Siege. 5 Max on field at once, if you try to place a 6th it will destroy the 1st.", 
    [kTechDataGhostModelClass] = "AlienGhostModel",   
    [kTechDataBuildRequiresMethod] = GetCheckLoneCyst,
    [kTechDataMapName] = LoneCyst.kMapName,        
    [kTechDataDisplayName] = "Lone Cyst",
    [kTechDataCostKey] = 10,   
    [kTechDataRequiresInfestation] = false, 
    [kTechDataHotkey] = Move.C,   
    [kTechDataBuildTime] = 20, 
    [kTechDataModel] = LoneCyst.kModelName,   
    [kTechDataBuildMethodFailedMessage] = "Cannot place during Setup or In Siege",
    [kVisualRange] = 8,
    [kTechDataMaxHealth] = kEggBeaconHealth, 
    [kTechDataMaxArmor] = kEggBeaconArmor},
    
    { [kTechDataId] = kTechId.StructureBeacon, 
    [kTechDataCooldown] = kStructureBeaconCoolDown, 
    [kTechDataTooltipInfo] = "Whips/Crags/Shades/Shifts that are currently standing still(non moving), and further than 12 radius, teleport nearby the placed location. Ignores Crags/Shifts/Shades nearby hive for SiegeWall Defense.", 
    [kTechDataGhostModelClass] = "AlienGhostModel",   
    [kTechDataMapName] = StructureBeacon.kMapName,        
    [kTechDataDisplayName] = "Structure Beacon",  [kTechDataCostKey] = kStructureBeaconCost,   
    [kTechDataRequiresInfestation] = true, [kTechDataHotkey] = Move.C,   
    [kTechDataBuildTime] = kStructureBeaconBuildTime, 
    [kTechDataModel] = StructureBeacon.kModelName,  
    [kTechDataBuildMethodFailedMessage] = "1 at a time not in siege/during setup",
    [kTechDataBuildRequiresMethod] = GetCheckStructureBeacon,
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
    

    { [kTechDataId] = kTechId.DualGrenaderExosuit,    
    [kTechIDShowEnables] = false,     
    [kTechDataDisplayName] = "Dual Exo Grenader", 
    [kTechDataMapName] = "exo",         
   [kTechDataMaxExtents] = Vector(0.55, 1.2, 0.55),
    [kTechDataCostKey] = 30,--kDualExosuitCost - 5, 
    [kTechDataHotkey] = Move.E,
    [kTechDataTooltipInfo] = "Dual Grenaders yo", 
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
    
    { [kTechDataId] = kTechId.GorillaGlue,        
    [kTechDataCategory] = kTechId.Onos,   
    [kTechDataMapName] = GorillaGlue.kMapName,  
    [kTechDataCostKey] = kStabResearchCost,
    [kTechDataResearchTimeKey] = kStabResearchTime, 
    --   [kTechDataDamageType] = kStabDamageType,  
    [kTechDataDisplayName] = "GorillaGlue",
    [kTechDataTooltipInfo] = "Woohoo"},
    
    
    
           { [kTechDataId] = kTechId.Rebirth, 
       [kTechDataCategory] = kTechId.CragHiveTwo,  
        [kTechDataDisplayName] = "Rebirth", 
      [kTechDataSponitorCode] = "A",  
      [kTechDataCostKey] = kRebirthCost, 
     [kTechDataTooltipInfo] = "Replaces death with gestation if cooldown is reached", },

      // Lifeform purchases
        { [kTechDataId] = kTechId.Redemption, 
       [kTechDataCategory] = kTechId.CragHiveTwo,  
        [kTechDataDisplayName] = "Redemption", 
      [kTechDataSponitorCode] = "B",  
      [kTechDataCostKey] = kRedemptionCost, 
     [kTechDataTooltipInfo] = "45 second cooldown, having less than 30% HP will enable a chance to redeem to the alien base hive", },


             { [kTechDataId] = kTechId.ThickenedSkin, 
       [kTechDataCategory] = kTechId.ShiftHiveTwo,  
        [kTechDataDisplayName] = "Thickened Skin", 
      [kTechDataSponitorCode] = "A",  
      [kTechDataCostKey] = kThickenedSkinCost,
     [kTechDataTooltipInfo] = "+10% max hp", },
     
       { [kTechDataId] = kTechId.Hunger, 
       [kTechDataCategory] = kTechId.ShiftHiveTwo,   
        [kTechDataDisplayName] = "Hunger", 
      [kTechDataSponitorCode] = "B",  
      [kTechDataCostKey] = kHungerCost, 
     [kTechDataTooltipInfo] = "On Player Kill: Enzyme and +10% health/energy ", }, --"Non Gorges On Player Kill: Enzyme and +10% health/energy  Gorge:+10%Energy/Enzyme on  ", },
   
        
    
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
        
        -- Beefup research
        {
            [kTechDataId] = kTechId.ArmoryBeefUp,
            [kTechDataCostKey] = 80,
            [kTechDataResearchTimeKey] = 30,
            [kTechDataDisplayName] = "ArmoryBeefUp",
            [kTechDataTooltipInfo] = "At the moment this is purely cosmetic. Simply make it bigger in size to block more area. Nothing else to it than modelsize.",
            [kTechDataResearchName] = "ArmoryBeefUp",
        },
        -- HiveLifeInsurance research
        {
            [kTechDataId] = kTechId.HiveLifeInsurance,
            [kTechDataCostKey] = 400,
            [kTechDataResearchTimeKey] = 30,
            [kTechDataDisplayName] = "HiveLifeInsurance",
            [kTechDataTooltipInfo] = "30% Chance Upon Research complete to be Success or Fail. If fail then tres wasted. Otherwise will prevent the death of the hive for one time. OnKill will boost its HP instead of dying. ",
            [kTechDataResearchName] = "HiveLifeInsurance",
        },
        
     { [kTechDataId] = kTechId.AlienTechPoint,  
        [kTechDataMapName] = AlienTechPoint.kMapName, 
        [kTechDataDisplayName] = "AlienTechPoint", 
        [kTechIDShowEnables] = false, 
        [kTechDataTooltipInfo] =  "Create your own AlienTechPoint", 
        [kTechDataModel] = AlienTechPoint.kModelName, 
        [kTechDataBuildTime] = kWallBuildTime,
        [kTechDataMaxHealth] = 4000,
        [kTechDataMaxArmor] = 0,
        [kTechDataBuildRequiresMethod] = GetCheckAlienTechPoint,
        [kTechDataBuildMethodFailedMessage] = "Limitreached", 
        [kTechDataCostKey] = 600, 
        [kTechDataSpecifyOrientation] = true,
        [kTechDataPointValue] = 20,
        [kTechDataMaxHealth] = 2000, 
        [kTechDataMaxArmor] = 1000,
        [kTechDataSupply] = 0},
        
        {
            [kTechDataId] = kTechId.CystMenu,
            [kTechDataDisplayName] = "CystMenu",
            [kTechDataTooltipInfo] = "CystMenu",
        },
        
        {
            [kTechDataId] = kTechId.DoubleCystHP,
           -- [kTechDataBioMass] = kHiveBiomass,
            [kTechDataCostKey] = 50,
            [kTechDataResearchTimeKey] = kBioMassOneTime,
            [kTechDataDisplayName] = "DoubleCystHP",
            [kTechDataTooltipInfo] = "DoubleCystHP",
        },
        
        {
            [kTechDataId] = kTechId.TripleCystHP,
            --[kTechDataBioMass] = kHiveBiomass,
            [kTechDataCostKey] = 60,
            [kTechDataResearchTimeKey] = kBioMassOneTime,
            [kTechDataDisplayName] = "TripleCystHP",
            [kTechDataTooltipInfo] = "TripleCystHP",
        },
        
        {
            [kTechDataId] = kTechId.QuadrupleCystHP,
            --[kTechDataBioMass] = kHiveBiomass,
            [kTechDataCostKey] = 70,
            [kTechDataResearchTimeKey] = kBioMassOneTime,
            [kTechDataDisplayName] = "QuadrupleCystHP",
            [kTechDataTooltipInfo] = "QuadrupleCystHP",
        },
        
        {
            [kTechDataId] = kTechId.DoubleCystArmor,
            --[kTechDataBioMass] = kHiveBiomass,
            [kTechDataCostKey] = 50,
            [kTechDataResearchTimeKey] = kBioMassOneTime,
            [kTechDataDisplayName] = "DoubleCystArmor",
            [kTechDataTooltipInfo] = "DoubleCystArmor",
        },
        
        {
            [kTechDataId] = kTechId.TripleCystArmor,
           -- [kTechDataBioMass] = kHiveBiomass,
            [kTechDataCostKey] = 60,
            [kTechDataResearchTimeKey] = kBioMassOneTime,
            [kTechDataDisplayName] = "TripleCystArmor",
            [kTechDataTooltipInfo] = "TripleCystArmor",
        },
        
        {
            [kTechDataId] = kTechId.QuadrupleCystArmor,
           -- [kTechDataBioMass] = kHiveBiomass,
            [kTechDataCostKey] = 70,
            [kTechDataResearchTimeKey] = kBioMassOneTime,
            [kTechDataDisplayName] = "QuadrupleCystArmor",
            [kTechDataTooltipInfo] = "QuadrupleCystArmor",
        },
        
        {
            [kTechDataId] = kTechId.AlienTechPointHive,
            [kTechDataCooldown] = 0,
            [kTechDataDisplayName] = "AlienTechPointHive",
            [kTechDataCostKey] = 40,
            [kTechDataTooltipInfo] = "AlienTechPointHive",
            --[kTechDataOneAtATime] = true,
        },
        
        { [kTechDataId] = kTechId.JumpPack,
        [kTechDataCostKey] = kJumpPackCost,
        [kTechDataDisplayName] = "Jump Pack", 
        [kTechDataHotkey] = Move.Z, 
        [kTechDataTooltipInfo] = "Mimics the NS1/HL1 JumpPack (With Attempted Balance Modifications WIP) - Press DUCK + Jump @ the same time to become overpowered for the alien team."},

        
 
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



