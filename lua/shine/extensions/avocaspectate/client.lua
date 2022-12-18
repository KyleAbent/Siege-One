/*
local Shine = Shine

local Plugin = Plugin

function Plugin:Initialise()
self.Enabled = true
return true
end


Shine.VoteMenu:AddPage ("DoDirect", function( self )
    local player = Client.GetLocalPlayer()
     self:AddSideButton( "DoDirect", function()  Shared.ConsoleCommand ("sh_direct")    end)
     self:AddSideButton( "DontDirect", function()  Shared.ConsoleCommand ("sh_directoff")    end)
    self:AddBottomButton( "Back", function()self:SetPage("Main")end)
end)


Shine.VoteMenu:EditPage( "Main", function( self ) 
local player = Client.GetLocalPlayer()
    if player:GetTeamNumber() == 3 then 
        self:AddSideButton( "Direct", function() self:SetPage( "DoDirect" ) end)
    end
end)
*/