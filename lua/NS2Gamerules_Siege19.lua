function NS2Gamerules:DisplayFront()

end

function NS2Gamerules:DisplaySiege()

end

if Server then

    local origCanJoin = NS2Gamerules.GetCanJoinTeamNumber
    function NS2Gamerules:GetCanJoinTeamNumber(player, teamNumber)
            --Print("teamNumber is %s", ToString(teamNumber) )
            if teamNumber == 2 then
                --Print("A")
                local marineCount = GetGamerules():GetTeam1():GetNumPlayers()
                local alienCount = GetGamerules():GetTeam2():GetNumPlayers()
                if alienCount > marineCount then-- alien count
                --Print("B")
                local difference = math.abs(alienCount - marineCount)
                    if  difference < 4 then
                        --Print("C")
                        local client = player:GetClient()
                        if not client:GetIsVirtual() then
                            --self:NotifyOne(client, "Alien Team Greter Size than Marine team by %s, allowing a size of %s more aliens than marines", true, difference, math.abs(difference - 4) )
                        end
                        return true --kTeam2Index -- Allow Alien Stack lol
                    end
                end
            end
            
            return origCanJoin(self, player, teamNumber)
    end

end

/*
--this is why the mod is ns2_  and ns1_ because we rely on the gamerules provided
local origupdate = NS2Gamerules.OnUpdate
function NS2Gamerules:OnUpdate(deltatime)
       origupdate(self,deltatime)
      local timer = GetTimer()
	  if timer ~= nil then
	     timer:gamerulesUpdate(deltatime)
	  end  
end
*/