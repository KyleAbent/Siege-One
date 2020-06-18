--https://github.com/ailmanki/Woozas-Haggis/blob/master/output/lua/shine/hook.lua
-- Set of known compatible/incompatible plugins for your gamemode (any not in this table will use their default behaviour).
local CompatiblePlugins = {
	voterandom = true,
	votesurrender = true,
	pregame = true
}
Shine.Hook.Add( "CanPluginLoad", "MyGamemodeCheck", function( Plugin, GamemodeName )
	return CompatiblePlugins[ Plugin:GetName() ]
end )