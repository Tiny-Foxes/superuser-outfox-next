local options = { StartIndex = 1 }

local unsupported = {
	rb = true,
}

for game in ivalues(GAMEMAN:GetEnabledGames()) do
	if game ~= "SelectGameMode" or unsupported[game] then
		table.insert(options,
			{game, function(self)
				GAMEMAN:SetGame(game)
			end}
		)
	end
end

return LoadModule('Options.Wheel.lua')(options)
