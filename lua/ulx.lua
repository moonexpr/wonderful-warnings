function WonderWarnings.LoadULX()
	function ulx.warn(calling_ply, target_ply, reason)
		if reason == "" or reason == nil then
			reason = "Player Warning (Not Specified)"
		end

		local StatMessage = "notification.AddLegacy( \"" .. WonderWarnings.Config.Actions["AccountMessage"] .. "\", NOTIFY_ERROR, 120 )"
		local KickMessage = "notification.AddLegacy(\"" .. WonderWarnings.Config.Kick["Message"] .. "\", NOTIFY_HINT, 120 )"
		local BanMessage = "notification.AddLegacy(\"" .. WonderWarnings.Config.Ban["Message"] .. "\", NOTIFY_HINT, 120)"
		local iWarnTotal = target_ply:GetPData( 'warnings', 0 ) + 1
		local iWarnKick = WonderWarnings.Config.Kick["Limit"]
		local bWarnKick = WonderWarnings.Config.Actions["Kick"]
		local iWarnBan = WonderWarnings.Config.Ban["Limit"]
		local bWarnBan = WonderWarnings.Config.Actions["Ban"]
		local function KickPlayer(calling_ply, target_ply, reason)		
			target_ply:SetPData( 'warnings_kicked', true )
			target_ply:Kick( string.gsub( string.gsub( WonderWarnings.Config.Kick["DisconnectMessage"], "{#}", iWarnTotal ), "{reason}", reason ) 
		end
		local function BanPlayer(target_ply)
			if WonderWarnings.Config.Ban["Reset"] then
				target_ply:SetPData( 'warnings_kicked', false ) -- Resets the warnings for next time
				target_ply:SetPData( 'warnings', 0 )
			end
			ULib.ban( target_ply, WonderWarnings.Config.Ban["Time"], string.gsub( WonderWarnings.Config.Ban["DisconnectMessage"], "{num}", iWarnBan ) )
		end

		if not target_ply:IsBot() then
			local bKicked = target_ply:GetPData( 'warnings_kicked', false )
			target_ply:SetPData( 'warnings_month', os.date( "%m", os.time() ) )
			target_ply:SetPData( 'warnings', iWarnTotal )
			if WonderWarnings.Config.Actions["NetworkVariable"] then target_ply:SetNWInt( 'warnings', iWarnTotal ) end
			if isstring(WonderWarnings.Config.Actions["AccountMessage"]) then
				target_ply:SendLua( string.gsub( string.gsub( StatMessage, "{#}", iWarnTotal ), "{reason}", reason ) )	
			end
			if iWarnTotal >= iWarnBan and bWarnBan then
				BanPlayer( target_ply )
			elseif iWarnTotal >= iWarnKick and not bKicked and bWarnKick then
				if isstring(WonderWarnings.Config.Kick["Message"]) then
					target_ply:SendLua( string.gsub( BanMessage, "{#}", iWarnBan - iWarnTotal) )
				end
				if not bKicked then
					KickPlayer( calling_ply, target_ply, reason )
				end
			elseif bWarnKick then
				if isstring(WonderWarnings.Config.Kick["Message"]) then
					target_ply:SendLua( string.gsub( KickMessage, "{#}", iWarnKick - iWarnTotal ) )
				end
			end
		end

		ulx.fancyLogAdmin( calling_ply, '#A issued a warning on #T for #s', target_ply, reason )
		
		if WonderWarnings.Config.Actions["Sounds"] then
			target_ply:EmitSound( "buttons/button10.wav", SNDLVL_NORM, 100, 1) 
			for _, fname in pairs(WonderWarnings.Config.Sounds) do
				target_ply:EmitSound( fname, SNDLVL_180dB, 100, 1 )
			end
			for _, ply in pairs(player.GetAll()) do
				if target_ply:GetPos():Distance(ply:GetPos()) > 1500 then
					for _, fname in pairs(WonderWarnings.Config.Sounds) do
						ply:SendLua( [[surface.PlaySound("]] .. fname .. [[")]] )
					end
				end
			end
		end
	end
	local warn = ulx.command("Utility", "ulx warn", ulx.warn, "!warn", true)
	warn:addParam{ type=ULib.cmds.PlayerArg }
	warn:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.takeRestOfLine }
	warn:defaultAccess( ULib.ACCESS_ADMIN )
	warn:help( "Warn a player." )
end