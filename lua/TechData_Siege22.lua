Script.Load("lua/2019/EggBeacon.lua")
Script.Load("lua/2019/StructureBeacon.lua")
Script.Load("lua/2019/LoneCyst.lua")
Script.Load("lua/Weapons/Alien/PrimalScream.lua")
Script.Load("lua/Weapons/Alien/AcidRocket.lua")
Script.Load("lua/2019/AlienTechPoint.lua")



local kCachedTechCategories
local kCachedMapNameTechIds
local kCachedTechData


function GetCheckAlienTechPoint(techId, origin, normal, commander)
        
        for index, atp in ientitylist(Shared.GetEntitiesWithClassname("AlienTechPoint")) do
                return false
        end
    
    
    return GetFrontDoorOpen()
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



local kSiege_TechData =
{  


   
    
    --Thanks dragon ns2c
    { [kTechDataId] = kTechId.PrimalScream,  
    [kTechDataCategory] = kTechId.Lerk,
    [kTechDataDisplayName] = "Primal Scream",
    [kTechDataMapName] =  Primal.kMapName,
    --[kTechDataCostKey] = kPrimalScreamCostKey, 
    -- [kTechDataResearchTimeKey] = kPrimalScreamTimeKey, 
    [kTechDataTooltipInfo] = "+Energy to teammates, enzyme cloud"},
    
    
    {
        [kTechDataId] = kTechId.CystMenu,
        [kTechDataDisplayName] = "CystMenu",
        [kTechDataTooltipInfo] = "CystMenu",
    },

    {
        [kTechDataId] = kTechId.CragMenu,
        [kTechDataDisplayName] = "CragMenu",
        [kTechDataTooltipInfo] = "CragMenu",
    },

    {
        [kTechDataId] = kTechId.WhipMenu,
        [kTechDataDisplayName] = "WhipMenu",
        [kTechDataTooltipInfo] = "WhipMenu",
    },


    {
        [kTechDataId] = kTechId.ShiftMenu,
        [kTechDataDisplayName] = "ShiftMenu",
        [kTechDataTooltipInfo] = "ShiftMenu",
    },

    {
        [kTechDataId] = kTechId.ShadeMenu,
        [kTechDataDisplayName] = "ShadeMenu",
        [kTechDataTooltipInfo] = "ShadeMenu",
    },
    
    
    
    
 
    --Thanks dragon ns2c
    { [kTechDataId] = kTechId.AcidRocket,        
    [kTechDataCategory] = kTechId.Fade,   
    [kTechDataMapName] = AcidRocket.kMapName,  
    [kTechDataCostKey] = kStabResearchCost,
    [kTechDataResearchTimeKey] = kStabResearchTime, 
    [kTechDataDamageType] = kAcidRocketDamageType,  
    [kTechDataDisplayName] = "AcidRocket",
    [kTechDataTooltipInfo] = "Ranged Projectile dealing damage only to armor and structures"},
    
    
    
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
     [kTechDataTooltipInfo] = "Player (or Construct/MAC/ARC if Gorge) Kill: Enzyme and +10% health/energy.", }, --"Non Gorges On Player Kill: Enzyme and +10% health/energy  Gorge:+10%Energy/Enzyme on  ", },
   
        
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
     [kTechDataSupply] = kLoneCystSupply,
    [kTechDataMaxArmor] = kEggBeaconArmor},
    
    
    { [kTechDataId] = kTechId.StructureBeacon, 
    [kTechDataCooldown] = kStructureBeaconCoolDown, 
    [kTechDataTooltipInfo] = "When Built: Telepports the following structures nearby: Whips/Crags/Shades/Shifts that are not moving, and further than 12 radius, and not near a Hive", 
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
        
        {[kTechDataId] = kTechId.AlienTechPointHive,
            [kTechDataCooldown] = 0,
            [kTechDataDisplayName] = "AlienTechPointHive",
            [kTechDataCostKey] = 40,
            [kTechDataTooltipInfo] = "AlienTechPointHive",},
        
        
        {[kTechDataId] = kTechId.CragStackOne,
            [kTechDataCostKey] = 10,
            [kTechDataResearchTimeKey] = 30,
            [kTechDataDisplayName] = "Crag Stack One",
            [kTechDataTooltipInfo] = "Requires +1 Crag Nearby for +10% Heal Bonus",
            [kTechDataResearchName] = "Crag Stack One"},

 
            {[kTechDataId] = kTechId.CragStackTwo,
            [kTechDataCostKey] = 10,
            [kTechDataResearchTimeKey] = 30,
            [kTechDataDisplayName] = "Crag Stack Two",
            [kTechDataTooltipInfo] = "Requires +2 Crag Nearby for +20% Heal Bonus",
            [kTechDataResearchName] = "Crag Stack Two"},
        
        
            {[kTechDataId] = kTechId.CragStackThree,
            [kTechDataCostKey] = 10,
            [kTechDataResearchTimeKey] = 30,
            [kTechDataDisplayName] = "Crag Stack Three",
            [kTechDataTooltipInfo] = "Requires +3 Crag Nearby for +30% Heal Bonus",
            [kTechDataResearchName] = "Crag Stack Three"},
        
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
    
   
  { [kTechDataId] = kTechId.AdvancedBeacon,   
    [kTechDataBuildTime] = 0.1,   
    [kTechDataCooldown] = kAdvancedBeaconCoolDown,
    [kTechDataDisplayName] = "Advanced Beacon",   
    [kTechDataHotkey] = Move.B, 
    [kTechDataCostKey] = kObservatoryDistressBeaconCost * 2.5, 
    [kTechDataTooltipInfo] = "Teleports Exos and Revives Dead Players. Also shuts down power to this observatory for 15 seconds (cannot be surged)"},
   
    
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



