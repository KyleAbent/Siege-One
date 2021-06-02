kMaxEntitiesInRadius = 999
kMaxEntityRadius = 0


--Kyle 'Avoca' Abent
---I really don't wanna do this, but because you removed the support for setcachedtechdata, you leave me no choice. 
--Limits

function GetCheckObsLimit(techId, origin, normal, commander)
    local num = 0
    local inRoom = 0

        
        for index, obs in ientitylist(Shared.GetEntitiesWithClassname("Observatory")) do
                num = num + 1
        end
    
    local location = GetLocationForPoint(origin)
    local locationName = location and location:GetName() or nil
    
    if locationName then
    
        local walls = Shared.GetEntitiesWithClassname("Observatory")
        for b = 0, walls:GetSize() - 1 do
        
            local wall = walls:GetEntityAtIndex(b)
            if wall and wall:GetLocationName() == locationName then
                inRoom = inRoom + 1
            end
            
        end
        
    end
    
    return num < 10 and inRoom < 3
    
end
function GetCheckArmoryLimit(techId, origin, normal, commander)
    local num = 0

        
        for index, obs in ientitylist(Shared.GetEntitiesWithClassname("Armory")) do
                num = num + 1
        end
    
    return num < 10
    
end
function GetCheckRoboLimit(techId, origin, normal, commander)
    local num = 0
    local inRoom = 0

        
        for index, obs in ientitylist(Shared.GetEntitiesWithClassname("RoboticsFactory")) do
                num = num + 1
        end
    local location = GetLocationForPoint(origin)
    local locationName = location and location:GetName() or nil
    
    if locationName then
    
        local walls = Shared.GetEntitiesWithClassname("RoboticsFactory")
        for b = 0, walls:GetSize() - 1 do
        
            local wall = walls:GetEntityAtIndex(b)
            if wall and wall:GetLocationName() == locationName then
                inRoom = inRoom + 1
            end
            
        end
        
    end
    
    return num < 10 and inRoom < 3
    
end
function GetCheckArmsLimit(techId, origin, normal, commander)
    local num = 0

        
        for index, obs in ientitylist(Shared.GetEntitiesWithClassname("ArmsLab")) do
                num = num + 1
        end
    
    return num < 5
    
end
function GetCheckIPLimit(techId, origin, normal, commander)
    local num = 0

        
        for index, obs in ientitylist(Shared.GetEntitiesWithClassname("InfantryPortal")) do
                num = num + 1
        end
    
    return num < 10
    
end
function GetCheckProtoLimit(techId, origin, normal, commander)
    local num = 0

        
        for index, obs in ientitylist(Shared.GetEntitiesWithClassname("PrototypeLab")) do
                num = num + 1
        end
    
    return num < 10
    
end
function GetCheckMedLimit(techId, origin, normal, commander)
    local num = 0

        
        for index, obs in ientitylist(Shared.GetEntitiesWithClassname("MedPack")) do
                num = num + 1
        end
    
    return num < 10
    
end
function GetCheckAmmoLimit(techId, origin, normal, commander)
    local num = 0

        
        for index, obs in ientitylist(Shared.GetEntitiesWithClassname("AmmoPack")) do
                num = num + 1
        end
    
    return num < 10
    
end
function GetCheckCatLimit(techId, origin, normal, commander)
    local num = 0

        
        for index, obs in ientitylist(Shared.GetEntitiesWithClassname("CatPack")) do
                num = num + 1
        end
    
    return num < 10
    
end
function GetCheckCragLimit(techId, origin, normal, commander)
    local num = 0

        
        for index, obs in ientitylist(Shared.GetEntitiesWithClassname("Crag")) do
                num = num + 1
        end
    
    return num < 10
    
end
function GetCheckWhipLimit(techId, origin, normal, commander)
    local num = 0

        
        for index, obs in ientitylist(Shared.GetEntitiesWithClassname("Whip")) do
                num = num + 1
        end
    
    return num < 10
    
end
local origLegal = GetIsBuildLegal
function GetIsBuildLegal(techId, position, angle, snapRadius, player, ignoreEntity, ignoreChecks)
    --Print("A")
    

   
    --prefer a string find?
    local returnOrig = true
    local method = nil
    local doSkip = false
    
    --Skip
    if player:GetTeamNumber() == 2 then
        if techId == kTechId.Crag then
            returnOrig = false
            method = GetCheckCragLimit
            doSkip = true
        elseif techId == kTechId.Whip then
            returnOrig = false
            method = GetCheckWhipLimit
            doSkip = true
        else
            return origLegal(techId, position, angle, snapRadius, player, ignoreEntity, ignoreChecks)
       end
    end
    
    if not doSkip then 
        if techId == kTechId.Observatory then
            returnOrig = false
            method = GetCheckObsLimit
           -- Print("B")
        elseif techId == kTechId.Armory then
            returnOrig = false
            method = GetCheckArmoryLimit
        elseif techId == kTechId.RoboticsFactory then
            returnOrig = false
            method = GetCheckRoboLimit
        elseif techId == kTechId.ArmsLab then
            returnOrig = false
            method = GetCheckArmsLimit
        elseif techId == kTechId.InfantryPortal then
            returnOrig = false
            method = GetCheckIPLimit
        elseif techId == kTechId.PrototypeLab then
            returnOrig = false
            method = GetCheckProtoLimit
        elseif techId == kTechId.MedPack then
            returnOrig = false
            method = GetCheckMedLimit
        elseif techId == kTechId.AmmoPack then
            returnOrig = false
            method = GetCheckAmmoLimit
        elseif techId == kTechId.CatPack then
            returnOrig = false
            method = GetCheckCatLimit
        end
    end
    
    if returnOrig then
        --Print("C")
        return origLegal(techId, position, angle, snapRadius, player, ignoreEntity, ignoreChecks)
    else--Obs
            --Lol look at this line!
         --Print("D")
         local legalBuild, legalPosition, attachEntity, errorString = origLegal(techId, position, angle, snapRadius, player, ignoreEntity, ignoreChecks)
         if legalBuild then
         --Print("E")
            if method then
            --Print("F")
                -- DL: As the normal passed in here isn't used to orient the building - don't bother working it out exactly. Up should be good enough.
                legalBuild = method(techId, legalPosition, Vector(0, 1, 0), player)
               -- Print("G")
                if not legalBuild then
                        errorString = "Limit Reached"
                        --Print("H")
                end
             end
            --BuildUtility_Print("customMethod legal: %s", ToString(legalBuild))
        end
        return legalBuild, legalPosition, attachEntity, errorString
    end
    
    
end