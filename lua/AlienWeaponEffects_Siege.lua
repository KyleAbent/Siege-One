-- ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
--
-- lua\AlienWeaponEffects.lua
--
--    Created by:   Charlie Cleveland (charlie@unknownworlds.com)
--
-- ========= For more information, visit us at http://www.unknownworlds.com =====================

-- Debug with: {player_cinematic = "cinematics/locateorigin.cinematic"},

 
kAlienWeaponEffects =
{
   
    primal_scream =
    {
        {
            --{cinematic = "cinematics/alien/onos/shockwave.cinematic"},
            {sound = "sound/NS2.fev/alien/lerk/taunt", silenceupgrade = true, done = true}, 
        }
    },
    
}

-- "false" means play all effects in each block
GetEffectManager():AddEffectData("AlienWeaponEffects", kAlienWeaponEffects)


