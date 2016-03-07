WonderWarnings = {} -- OH BOI HERE WE GO

include("autorun/config.lua")
include("aowl.lua")
include("ulx.lua")

if aowl then WonderWarnings.LoadAowl()
elseif ulx then WonderWarnings.LoadULX()
else Error("Cannot find supported administration mod!") end

function WonderWarnings.WarnEPOELog( msg )
	if not epoe then
		parse = string.format( "chat.AddText(Color(200, 0, 0), [[Wonderful Warnings: ]], Color(255, 255, 255), [[%s\n]])", msg )
		for _, ply in pairs( player.GetAll() ) do
			if ply:IsAdmin() then
				ply:SendLua(parse)
			end
		end
	else 
		parse = string.format( "epoe.AddText(Color(200, 0, 0), [[Wonderful Warnings: ]], Color(255, 255, 255), [[%s\n]])", msg )
		for _, ply in pairs(player.GetAll()) do
			if ply:IsAdmin() then
				ply:SendLua(parse)
			end
		end
	end
	ServerLog( string.format( "Wonderful Warnings: %s", msg ) )
end

function WonderWarnings.WarningsCheck( ply )
	if ply:GetPData("warnings", 0) == 0 then return end

	local month = ply:GetPData( 'warnings_month', 99 )
	if month == 99 then
		ply:RemovePData( 'warnings_month' )
		ply:RemovePData( 'warnings' )
		ply:RemovePData( 'Warnings' )
		WonderWarnings.WarnEPOELog( "Running cleanup on " ..  ply:Nick() .. "'s warnings. Reason (\"No past month data is available\")." )
	elseif month >= tonumber( os.date( "%m", os.time() ) ) + WonderWarnings.Config.Actions["ClearWarnings"] then
		ply:RemovePData( 'warnings_month' )
		ply:RemovePData( 'warnings' )
		WonderWarnings.WarnEPOELog( "Running cleanup on " ..  ply:Nick() .. "'s warnings. Reason (\"Time Expired\")." )
	end
end

hook.Add("PlayerSpawn", "CheckWonderWarnings", WonderWarnings.WarningsCheck )
hook.Add("AowlInitialized", "LoadWonderWarnings", WonderWarnings.LoadAowl )