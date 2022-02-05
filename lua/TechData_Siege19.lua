Script.Load("lua/Weapons/Alien/PrimalScream.lua")
Script.Load("lua/Weapons/Alien/AcidRocket.lua")



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
     [kTechDataTooltipInfo] = "On Player Kill: Enzyme and +10% health/energy ", }, --"Non Gorges On Player Kill: Enzyme and +10% health/energy  Gorge:+10%Energy/Enzyme on  ", },
   
        
        
 
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



