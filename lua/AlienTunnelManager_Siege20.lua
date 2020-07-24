--just to pass index as var so we know which entry goes to which exit

local buttonIndexToNetVarMap = {
    "entryOne",
    "entryTwo",
    "entryThree",
    "entryFour",
    "exitOne",
    "exitTwo",
    "exitThree",
    "exitFour",
}

function AlienTunnelManager:CreateTunnelEntrance(position, techId, otherEntrance)
    if not techId and not otherEntrance then return end

    local techIndex
    if techId then
        techIndex = techId - kTechId.BuildTunnelEntryOne
        local otherIndex

        if techIndex > 7 then return end

        if techIndex < 4 then
            otherIndex = techIndex + 4
        else
            otherIndex = techIndex - 4
        end

        local otherEntranceId = self[buttonIndexToNetVarMap[otherIndex+1]]
        otherEntrance = otherEntranceId ~= 0 and Shared.GetEntity(otherEntranceId)
    else
        local otherId = otherEntrance:GetId()
        local otherIndex = self.tunnelEntIdToIndex[otherId] - 1

        if otherIndex < 4 then
            techIndex = otherIndex + 4
        else
            techIndex = otherIndex - 4
        end
    end

    local newTunnelEntrance = CreateEntity(TunnelEntrance.kMapName, position, self:GetTeamNumber())
    local myIndex = 0
    if techId == kTechId.BuildTunnelEntryOne or techId == kTechId.BuildTunnelExitOne then
        myIndex = 1
    elseif  techId == kTechId.BuildTunnelEntryTwo or techId == kTechId.BuildTunnelExitTwo then
         myIndex = 2
    elseif  techId == kTechId.BuildTunnelEntryThree or techId == kTechId.BuildTunnelExitThree then
         myIndex = 3
    end
          Print("newTunnelEntrance is %s", myIndex)
          newTunnelEntrance:SetIndex(myIndex) -- only line change

    local id = newTunnelEntrance:GetId()
    self[buttonIndexToNetVarMap[techIndex + 1]] = id
    self.tunnelEntIdToIndex[id] = techIndex + 1

    if otherEntrance then
        if otherEntrance:GetTechId() == kTechId.InfestedTunnel then
            newTunnelEntrance:UpgradeToTechId(kTechId.InfestedTunnel)
        end

        --newTunnelEntrance:SetOtherEntrance(otherEntrance)
    end

    return newTunnelEntrance
end