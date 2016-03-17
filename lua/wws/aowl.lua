function WonderWarnings.LoadAowl()
	aowl.AddCommand("warn",
	function(calling_ply, target_ply, reason)
		local target_ply_old = target_ply
		target_ply = easylua.FindEntity( target_ply )

		if not target_ply or not IsValid(target_ply) or not target_ply:IsPlayer() then
			calling_ply:PrintMessage( HUD_PRINTTALK, string.format( "Cannot find player in argument #2 (#s)", target_ply_old ) )
			return
		end

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
		local function KickPlayer( alling_ply, target_ply, reason )	
			target_ply:SetPData( 'warnings_kicked', true )
			target_ply:Kick( string.gsub( string.gsub( WonderWarnings.Config.Kick["DisconnectMessage"], "{#}", iWarnTotal ), "{reason}", reason ) )
		end
		local function BanPlayer( target_ply, reason )
			target_ply:ResetWarnings()
			-- target_ply:Ban( target_ply, 2880 )
			-- I don't know if you have banni or not.
			-- Come up with your own damn banning system
			target_ply:Kick( string.gsub( string.gsub( WonderWarnings.Config.Ban["DisconnectMessage"], "{#}", iWarnBan ), "{reason}", reason ) )
		end

		if not target_ply:IsBot() then	
			local bKicked = target_ply:GetPData( 'warnings_kicked', false )
			target_ply:AddWarning( iWarnTotal )
			if WonderWarnings.Config.Actions["NetworkVariable"] then target_ply:SetNWInt( 'warnings', iWarnTotal ) end
			if isstring(WonderWarnings.Config.Actions["AccountMessage"]) then
				target_ply:SendLua( string.gsub( string.gsub( StatMessage, "{#}", iWarnTotal ), "{reason}", reason ) )	
			end
			if iWarnTotal >= iWarnBan and bWarnBan then
				BanPlayer( target_ply, reason )
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

		PrintMessage( '#A issued a warning on #T for #s', calling_ply:Nick(), target_ply:Nick(), reason )

		if WonderWarnings.Config.Actions["Sounds"] then
			target_ply:EmitSound( "buttons/button10.wav", SNDLVL_NORM, 100, 1) 
			for _, fname in pairs(WonderWarnings.Config.Sounds) do
				if string.find(fname, "http") ~= 1 then
					target_ply:EmitSound( fname, SNDLVL_180dB, 100, 1 )
				end
			end
			for _, ply in pairs(player.GetAll()) do
				if target_ply:GetPos():Distance(ply:GetPos()) > 1500 then
					for _, fname in pairs(WonderWarnings.Config.Sounds) do
						if string.find(fname, "http") == 1 then
							ply:SendLua( [[
								sound.PlayURL("]] .. fname .. [[", "mono", function() end)
							]] )
						end
						ply:SendLua( [[surface.PlaySound("]] .. fname .. [[")]] )
					end
				end
			end
		end
	end,
	"developers")
end