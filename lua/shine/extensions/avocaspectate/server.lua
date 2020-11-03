--Kyle 'Avoca' Abent
local Shine = Shine
local Plugin = Plugin

Plugin.Version = "1.0"

function Plugin:Initialise()
self.Enabled = true
self:CreateCommands()
return true
end

function Plugin:CreateCommands()

local function Direct( Client )
   local controlling = Client:GetControllingPlayer()
   if controlling:GetTeamNumber() == kSpectatorIndex then //getteamnumbeR? bleh
        //controlling:ReplaceRespawnPlayer(AvocaSpectator.kMapName, 3)
        controlling:ToggleDirectorOn()
        self:NotifySpectator(Client, "This is simple version just to get the functionality working.", true )
        self:NotifySpectator(Client, "It can be tuned with more angles. With menu options to disable/enable settings, change intervals, whatever..", true )
        self:NotifySpectator(Client, "For now this should help slightly with the idea of AFKING with great footage to watch in the meantime, maybe.", true )
        self:NotifySpectator(Client, "Known issue: Camera might hang if target is on complete other side of map? ", true )

   end
end

local DirectCommand = self:BindCommand( "sh_direct", "direct", Direct)

local function DirectOff( Client )
   local controlling = Client:GetControllingPlayer()
   if controlling:GetTeamNumber() == kSpectatorIndex then //getteamnumbeR? bleh
        //Shared.ConsoleCommand( string.format("sh_setteam %s 0", Client:GetUserId() ) )
        controlling:ToggleDirectorOff()
        self:NotifySpectator(Client, "Director Disabled", true )
   end
end

local DirectCommand = self:BindCommand( "sh_directoff", "directoff", DirectOff)



end





function Plugin:JoinTeam(gamerules, player, newteam, force, ShineForce)
    //Print("JoinTeam newteam is %s", newteam)
    if  newteam == kSpectatorIndex then 
        self:NotifySpectator(player:GetClient(), "Interested in some sweet camera angles? Open your menu and click on Direct (must be free camera mode or overhead , not first person)", true )
    end 
end


function Plugin:NotifySpectator( Player, String, Format, ... )
    Shine:NotifyDualColour( Player, 255, 165, 0,  "[Director]",  0, 255, 0, String, Format, ... )
end


