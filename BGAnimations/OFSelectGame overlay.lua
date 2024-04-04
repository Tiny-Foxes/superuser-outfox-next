local options = { StartIndex = 1 }

for game in ivalues(TF_WHEEL.GameDB) do
	table.insert(options,
		{game, function(self)
			GAMEMAN:SetGame(game)
		end}
	)
end

return LoadModule('Options.Wheel.lua')(options)
