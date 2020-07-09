--Avoca -- Add T4 
if Server then

    local function UnlockAbility(forAlien, techId)

        local mapName = LookupTechData(techId, kTechDataMapName)
        if mapName and forAlien:GetIsAlive() then
        
            local activeWeapon = forAlien:GetActiveWeapon()

            local tierWeapon = forAlien:GetWeapon(mapName)
            if not tierWeapon then
            
                forAlien:GiveItem(mapName)
                
                if activeWeapon then
                    forAlien:SetActiveWeapon(activeWeapon:GetMapName())
                end
                
            end
        
        end

    end

    local function LockAbility(forAlien, techId)

        local mapName = LookupTechData(techId, kTechDataMapName)    
        if mapName and forAlien:GetIsAlive() then
        
            local tierWeapon = forAlien:GetWeapon(mapName)
            local activeWeapon = forAlien:GetActiveWeapon()
            local activeWeaponMapName
            
            if activeWeapon ~= nil then
                activeWeaponMapName = activeWeapon:GetMapName()
            end
            
            if tierWeapon then
                forAlien:RemoveWeapon(tierWeapon)
            end
            
            if activeWeaponMapName == mapName then
                forAlien:SwitchWeapon(1)
            end
            
        end    
        
    end


    local orig = UpdateAbilityAvailability

    function UpdateAbilityAvailability(forAlien, tierOneTechId, tierTwoTechId, tierThreeTechId)

            orig(forAlien, tierOneTechId, tierTwoTechId, tierThreeTechId)
            if forAlien.GetTierFourTechId then 
                local hasThreeHivesNow = GetGamerules():GetAllTech() or (GetIsTechUnlocked(forAlien, forAlien:GetTierFourTechId() )) --hardcoding it for now 
                
                if hasThreeHivesNow then
                    UnlockAbility(forAlien, forAlien:GetTierFourTechId()) 
                else
                    LockAbility(forAlien, forAlien:GetTierFourTechId()) 
                end
            end
            

    end

end