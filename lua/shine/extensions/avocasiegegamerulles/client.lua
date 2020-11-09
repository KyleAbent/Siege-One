local Shine = Shine

local Plugin = Plugin

function Plugin:Initialise()
self.Enabled = true
return true
end




Shine.VoteMenu:AddPage ("DoColor", function( self )
    local player = Client.GetLocalPlayer()
    if player:GetTeamNumber() == 2 and player:isa("Gorge") then 
        self:AddSideButton( "1", function()  Shared.ConsoleCommand ("sh_tunnelcolor 1")    end)
        self:AddSideButton( "2", function()  Shared.ConsoleCommand ("sh_tunnelcolor 2")    end)
        self:AddSideButton( "3", function()  Shared.ConsoleCommand ("sh_tunnelcolor 3")    end)
        self:AddSideButton( "4", function()  Shared.ConsoleCommand ("sh_tunnelcolor 4")    end)
        self:AddSideButton( "5", function()  Shared.ConsoleCommand ("sh_tunnelcolor 5")    end)
        self:AddSideButton( "6", function()  Shared.ConsoleCommand ("sh_tunnelcolor 6")    end)
        self:AddSideButton( "7", function()  Shared.ConsoleCommand ("sh_tunnelcolor 7")    end)
        self:AddSideButton( "8", function()  Shared.ConsoleCommand ("sh_tunnelcolor 8")    end)
        self:AddSideButton( "9", function()  Shared.ConsoleCommand ("sh_tunnelcolor 9")    end)
        self:AddSideButton( "10", function()  Shared.ConsoleCommand ("sh_tunnelcolor 10")    end)
        self:AddSideButton( "11", function()  Shared.ConsoleCommand ("sh_tunnelcolor 11")    end)
    end
    self:AddBottomButton( "Back", function()self:SetPage("Main")end)
end)


Shine.VoteMenu:EditPage( "Main", function( self ) 
local player = Client.GetLocalPlayer()
    if player:GetTeamNumber() == 2 and player:isa("Gorge") then 
        self:AddSideButton( "TunnelColor", function() self:SetPage( "DoColor" ) end)
    end
end)