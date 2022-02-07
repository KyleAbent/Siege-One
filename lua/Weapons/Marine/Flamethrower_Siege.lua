--Override to add additional coverage
function Flamethrower:BurnSporesAndUmbra(startPoint, endPoint)

    local toTarget = endPoint - startPoint
    local length = toTarget:GetLength()
    toTarget:Normalize()

    local stepLength = 2
    for i = 1, 5 do

        -- stop when target has reached, any spores would be behind
        if length < i * stepLength then
            break
        end

        local checkAtPoint = startPoint + toTarget * i * stepLength
        local spores = GetEntitiesWithinRange("SporeCloud", checkAtPoint, kSporesDustCloudRadius)

        local clouds = GetEntitiesWithinRange("CragUmbra", checkAtPoint, CragUmbra.kRadius)
        table.copy(GetEntitiesWithinRange("StormCloud", checkAtPoint, StormCloud.kRadius), clouds, true)
        table.copy(GetEntitiesWithinRange("MucousMembrane", checkAtPoint, MucousMembrane.kRadius), clouds, true)
        table.copy(GetEntitiesWithinRange("EnzymeCloud", checkAtPoint, EnzymeCloud.kRadius), clouds, true)

        local bombs = GetEntitiesWithinRange("Bomb", checkAtPoint, 1.6)
        table.copy(GetEntitiesWithinRange("WhipBomb", checkAtPoint, 1.6), bombs, true)
        table.copy(GetEntitiesWithinRange("LerkBomb", checkAtPoint, 1.6), bombs, true)
        table.copy(GetEntitiesWithinRange("Rocket", checkAtPoint, 1.6), bombs, true)

        local burnSpent = false

        for i = 1, #bombs do
            local bomb = bombs[i]
            bomb:TriggerEffects("burn_bomb", { effecthostcoords = Coords.GetTranslation(bomb:GetOrigin()) } )
            DestroyEntity(bomb)
            burnSpent = true
        end

        for i = 1, #spores do
            local spore = spores[i]
            self:TriggerEffects("burn_spore", { effecthostcoords = Coords.GetTranslation(spore:GetOrigin()) } )
            DestroyEntity(spore)
            burnSpent = true
        end

        for i = 1, #clouds do
            local cloud = clouds[i]
            self:TriggerEffects("burn_umbra", { effecthostcoords = Coords.GetTranslation(cloud:GetOrigin()) } )
            DestroyEntity(cloud)
            burnSpent = true
        end

        if burnSpent then
            break
        end


    end

end