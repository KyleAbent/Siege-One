
--@Overide
local gMarineMenuButtons =
{

    [kTechId.BuildMenu] = { kTechId.CommandStation, kTechId.Extractor, kTechId.InfantryPortal, kTechId.Armory,
                            kTechId.RoboticsFactory, kTechId.ArmsLab, kTechId.Wall, kTechId.None },
                            
    [kTechId.AdvancedMenu] = { kTechId.Observatory, kTechId.PhaseGate, kTechId.PrototypeLab, kTechId.BackupBattery, 
                               kTechId.None, kTechId.None, kTechId.None, kTechId.None },

    [kTechId.AssistMenu] = { kTechId.AmmoPack, kTechId.MedPack, kTechId.NanoShield, kTechId.Scan,
                             kTechId.PowerSurge, kTechId.CatPack, kTechId.WeaponsMenu, kTechId.None, },
                             
    [kTechId.WeaponsMenu] = { kTechId.DropShotgun, kTechId.DropGrenadeLauncher, kTechId.DropFlamethrower, kTechId.DropWelder,
                              kTechId.DropMines, kTechId.DropJetpack, kTechId.DropHeavyMachineGun, kTechId.AssistMenu}


}
--@Overide
local gMarineMenuIds = {}
do
    for menuId, _ in pairs(gMarineMenuButtons) do
        gMarineMenuIds[#gMarineMenuIds+1] = menuId
    end
end


--@Overide

function MarineCommander:GetButtonTable()
    return gMarineMenuButtons
end

function MarineCommander:GetQuickMenuTechButtons(techId)

    -- Top row always for quick access
    local marineTechButtons = { kTechId.BuildMenu, kTechId.AdvancedMenu, kTechId.AssistMenu, kTechId.RootMenu }
    local menuButtons = gMarineMenuButtons[techId]    
    
    if not menuButtons then
        menuButtons = {kTechId.None, kTechId.None, kTechId.None, kTechId.None, kTechId.None, kTechId.None, kTechId.None, kTechId.None }
    end

    table.copy(menuButtons, marineTechButtons, true)        

    -- Return buttons and true/false if we are in a quick-access menu
    return marineTechButtons
    
end
