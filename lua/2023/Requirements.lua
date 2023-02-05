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


//Yes, it doesn't make sense. Why can't powerpoints be reference?
//I had to add in location network var
//this logic is backwards but it works lol
function GetRoomPowerDisabled(techId, origin, normal, commander)
    local location = GetLocationForPoint(origin)
    if not location then
        //print("did not find location")
        return false
    end    
    local locationName = location.name
    //Print("location name is %s",locationName)
    local isPowered = false
            isPowered = location.isPowered
            //Print("Found powerpoint for location, isPowered is %s", isPowered)
            //Print("Location %s isPowered is %s", location.name, isPowered)
    
    
    //print("for loop oveR")
    
    //print("A")
    if not isPowered then
        //print("is powered")
        return false
    //elseif not powerpoint then
    else
        //print("did not find powerpoint")
        return true
    end
    //print("B")
    
    //print("C")
    //if powerpoint:GetIsDisabled() then//powerNode:GetIsPowering()
        //print("D")
        return false
    //end    
    //print("E`")
    
    
    //return false

    
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






-----------
SetCachedTechData(kTechId.Crag, kTechDataBuildMethodFailedMessage, "Room Power must be Disabled")
SetCachedTechData(kTechId.Whip, kTechDataBuildMethodFailedMessage, "Room Power must be Disabled")
SetCachedTechData(kTechId.Shift, kTechDataBuildMethodFailedMessage, "Room Power must be Disabled")
SetCachedTechData(kTechId.Shade, kTechDataBuildMethodFailedMessage, "Room Power must be Disabled")
SetCachedTechData(kTechId.Egg, kTechDataBuildMethodFailedMessage, "Room Power must be Disabled")



SetCachedTechData(kTechId.TeleportHydra, kTechDataBuildMethodFailedMessage, "Room Power must be Disabled")
SetCachedTechData(kTechId.TeleportWhip, kTechDataBuildMethodFailedMessage, "Room Power must be Disabled")
SetCachedTechData(kTechId.TeleportTunnel, kTechDataBuildMethodFailedMessage, "Room Power must be Disabled")
SetCachedTechData(kTechId.TeleportCrag, kTechDataBuildMethodFailedMessage, "Room Power must be Disabled")
SetCachedTechData(kTechId.TeleportShade, kTechDataBuildMethodFailedMessage, "Room Power must be Disabled")
SetCachedTechData(kTechId.TeleportShift, kTechDataBuildMethodFailedMessage, "Room Power must be Disabled")
SetCachedTechData(kTechId.TeleportVeil, kTechDataBuildMethodFailedMessage, "Room Power must be Disabled")
SetCachedTechData(kTechId.TeleportShift, kTechDataBuildMethodFailedMessage, "Room Power must be Disabled")
SetCachedTechData(kTechId.TeleportSpur, kTechDataBuildMethodFailedMessage, "Room Power must be Disabled")
SetCachedTechData(kTechId.TeleportShell, kTechDataBuildMethodFailedMessage, "Room Power must be Disabled")
SetCachedTechData(kTechId.TeleportEgg, kTechDataBuildMethodFailedMessage, "Room Power must be Disabled")


SetCachedTechData(kTechId.NutrientMist, kTechDataBuildMethodFailedMessage, "Room Power must be Disabled")


SetCachedTechData(kTechId.BoneWall, kTechDataBuildMethodFailedMessage, "Room Power must be Disabled")
SetCachedTechData(kTechId.Rupture, kTechDataBuildMethodFailedMessage, "Room Power must be Disabled")

SetCachedTechData(kTechId.Veil, kTechDataBuildMethodFailedMessage, "Room Power must be Disabled")
SetCachedTechData(kTechId.Shell, kTechDataBuildMethodFailedMessage, "Room Power must be Disabled")
SetCachedTechData(kTechId.Spur, kTechDataBuildMethodFailedMessage, "Room Power must be Disabled")

SetCachedTechData(kTechId.DrifterEgg, kTechDataBuildMethodFailedMessage, "Room Power must be Disabled")




