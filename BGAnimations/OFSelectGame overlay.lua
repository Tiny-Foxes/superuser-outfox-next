local options = { StartIndex = 1 }

for k in pairs(TF_WHEEL.QuickStyleDB) do
	table.insert(options,
		{k, function(self)
			GAMEMAN:SetGame(k)
		end}
	)
end

return LoadModule('Options.Wheel.lua')(options)
