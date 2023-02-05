SetCachedTechData(kTechId.Crag, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.Whip, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.Shift, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.Shade, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.Harvester, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.DrifterEgg, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.Egg, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.GorgeEgg, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.LerkEgg, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.FadeEgg, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.OnosEgg, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.NutrientMist, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.BoneWall, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.Rupture, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.Veil, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.Shell, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.Spur, kTechDataRequiresInfestation, false)

SetCachedTechData(kTechId.TeleportHydra, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.TeleportWhip, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.TeleportTunnel, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.TeleportCrag, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.TeleportShade, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.TeleportShift, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.TeleportVeil, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.TeleportShift, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.TeleportSpur, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.TeleportShell, kTechDataRequiresInfestation, false)
SetCachedTechData(kTechId.TeleportEgg, kTechDataRequiresInfestation, false)




//////Come back here!
function GetRoomPowerDisabled(techId, origin, normal, commander)
    local location = GetLocationForPoint(origin)
    local powerpoint = GetPowerPointForLocation(location.name)
    
    print("A")
    if not powerpoint then
        return false
    end
    print("B")
    
    print("C")
    if powerpoint:GetIsBuilt() and powerpoint:GetIsDisabled() then
    print("D")
        return true
    end    
    print("E`")
    
    
    return false

    
end


SetCachedTechData(kTechId.Crag, kTechDataBuildRequiresMethod, GetRoomPowerDisabled)
SetCachedTechData(kTechId.Whip, kTechDataBuildRequiresMethod, GetRoomPowerDisabled)
SetCachedTechData(kTechId.Shift, kTechDataBuildRequiresMethod, GetRoomPowerDisabled)
SetCachedTechData(kTechId.Shade, kTechDataBuildRequiresMethod, GetRoomPowerDisabled)
SetCachedTechData(kTechId.Egg, kTechDataBuildRequiresMethod, GetRoomPowerDisabled)



SetCachedTechData(kTechId.TeleportHydra, kTechDataBuildRequiresMethod, GetRoomPowerDisabled)
SetCachedTechData(kTechId.TeleportWhip, kTechDataBuildRequiresMethod, GetRoomPowerDisabled)
SetCachedTechData(kTechId.TeleportTunnel, kTechDataBuildRequiresMethod, GetRoomPowerDisabled)
SetCachedTechData(kTechId.TeleportCrag, kTechDataBuildRequiresMethod, GetRoomPowerDisabled)
SetCachedTechData(kTechId.TeleportShade, kTechDataBuildRequiresMethod, GetRoomPowerDisabled)
SetCachedTechData(kTechId.TeleportShift, kTechDataBuildRequiresMethod, GetRoomPowerDisabled)
SetCachedTechData(kTechId.TeleportVeil, kTechDataBuildRequiresMethod, GetRoomPowerDisabled)
SetCachedTechData(kTechId.TeleportShift, kTechDataBuildRequiresMethod, GetRoomPowerDisabled)
SetCachedTechData(kTechId.TeleportSpur, kTechDataBuildRequiresMethod, GetRoomPowerDisabled)
SetCachedTechData(kTechId.TeleportShell, kTechDataBuildRequiresMethod, GetRoomPowerDisabled)
SetCachedTechData(kTechId.TeleportEgg, kTechDataBuildRequiresMethod, GetRoomPowerDisabled)


SetCachedTechData(kTechId.NutrientMist, kTechDataBuildRequiresMethod, GetRoomPowerDisabled)


SetCachedTechData(kTechId.BoneWall, kTechDataBuildRequiresMethod, GetRoomPowerDisabled)
SetCachedTechData(kTechId.Rupture, kTechDataBuildRequiresMethod, GetRoomPowerDisabled)

SetCachedTechData(kTechId.Veil, kTechDataBuildRequiresMethod, GetRoomPowerDisabled)
SetCachedTechData(kTechId.Shell, kTechDataBuildRequiresMethod, GetRoomPowerDisabled)
SetCachedTechData(kTechId.Spur, kTechDataBuildRequiresMethod, GetRoomPowerDisabled)

SetCachedTechData(kTechId.DrifterEgg, kTechDataBuildRequiresMethod, GetRoomPowerDisabled)



