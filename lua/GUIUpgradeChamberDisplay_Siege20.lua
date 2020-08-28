-- first entry is tech id to use if the player has none of the upgrades in the list
local kIndexToUpgrades =
{
    {kTechId.CragHiveTwo,  kTechId.Redemption, kTechId.Rebirth},
    {kTechId.ShiftHiveTwo,  kTechId.ThickenedSkin, kTechId.Hunger},
    { kTechId.Shell, kTechId.Vampirism, kTechId.Carapace, kTechId.Regeneration },
    { kTechId.Spur, kTechId.Crush, kTechId.Celerity, kTechId.Adrenaline },
    { kTechId.Veil, kTechId.Camouflage, kTechId.Aura, kTechId.Focus },
}
local kUpgradeLevelFunc =
{
    "GetShellLevel",
    "GetSpurLevel",
    "GetVeilLevel"
}
local kIconColor = Color( 1, 190/255, 50/255, 1 ) --kIconColors[kAlienTeamType]

local function GetTechIdToUse(playerUpgrades, categoryUpgrades)

    for i = 1, #categoryUpgrades do
    
        if table.icontains(playerUpgrades, categoryUpgrades[i]) then
            return categoryUpgrades[i], true
        end
    
    end
    
    return categoryUpgrades[1], false

end
--override
function GUIUpgradeChamberDisplay:Update(deltaTime)
    PROFILE("GUIUpgradeChamberDisplay:Update")
    local player = Client.GetLocalPlayer()
    if player then

        local upgrades = player:GetUpgrades()

        for i = 1, 3 do
        
            local category = self.upgradeIcons[i]
            local levelFuncName = kUpgradeLevelFunc[i]
            local playerUpgradeLevel, teamUpgradeLevel = player[levelFuncName](player)
            local techId, upgraded = GetTechIdToUse(upgrades, kIndexToUpgrades[i])    
            local alpha = (upgraded or player:isa("Commander")) and 1 or (0.25 + (1 + math.sin(Shared.GetTime() * 5)) * 0.5) * 0.75
            
            for upgradeLevel = 1, 3 do
            
                if teamUpgradeLevel == 0 then
                
                    self.upgradeIcons[i][upgradeLevel]:SetIsVisible(false)
                    break
                
                else
                    local color = Color(kIconColor.r, kIconColor.g, kIconColor.b, alpha)
                    if teamUpgradeLevel < upgradeLevel then
                        
                        color.r = 0
                        color.g = 0
                        color.b = 0
                        color.a = 1
                        
                    elseif playerUpgradeLevel < upgradeLevel then
                        color.a = 0.5
                        if upgradeLevel - playerUpgradeLevel == 1 then
                            color.a = (0.5 + (1 + math.sin(Shared.GetTime() * 5)) * 0.5) * 0.5
                        end
                    end
                
                    self.upgradeIcons[i][upgradeLevel]:SetTexturePixelCoordinates(GUIUnpackCoords(GetTextureCoordinatesForIcon(techId)))
                    self.upgradeIcons[i][upgradeLevel]:SetColor(color)
                    self.upgradeIcons[i][upgradeLevel]:SetIsVisible(true)
                    
                end    
                
            end
            
        end
    
    end

end