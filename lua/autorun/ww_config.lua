WonderWarnings.Config = {
	Actions = {
		["Kick"] = true,
		["Ban"] = false,
		["Sounds"] = true,
		["NetworkVariable"] = true, -- leave as true if you don't know.
		["ClearWarnings"] = 1, -- Months after to clear warnings (use a really big number if you want it disabled)
		["AccountMessage"] = "Issued Warning #{#}: {reason}", -- Can be disabled using true/false (Available Variables: {#}, {reason})
	},

	Kick = {
		["Limit"] = 3,
		["Message"] = "You have {#} more warnings before getting disconnected", -- Available Variables: {#}
		["DisconnectMessage"] = "Too many warnings, Take 10 deep breaths before re-entry!", -- Available Variables: {#}, {reason}
	},

	Ban = {
		["Limit"] = 6,
		["Message"] = "You have {#} more warnings before getting banished.", -- Available Variables: {#}
		["Time"] = 2880, -- 48 Hours -or- 2 Days
		["DisconnectMessage"] = "exceeded maximum warnings ({#} warnings)", -- Available Variables: {#}, {reason}
		["Reset"] = true,
	},

	Sounds = {
		"ambient/alarms/apc_alarm_pass1.wav",
		"npc/overwatch/cityvoice/f_trainstation_offworldrelocation_spkr.wav",
		--"http://movie-sounds.org/download#L3F1b3Rlcy9saWFyL1N0b3AtYnJlYWtpbmctdGhlLWxhdy1hc3Nob2xlIS5tcDM="
	}
}
