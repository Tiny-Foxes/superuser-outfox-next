local dir = THEME:GetPathG('', 'mascots')..'/'
local mascots = {
	Choices = FILEMAN:GetDirListing(dir, false, false),
	Values = FILEMAN:GetDirListing(dir, false, true),
}

for i, v in ipairs(mascots.Choices) do
	mascots.Choices[i] = v:gsub('%.(.+)', '')
end

table.insert(mascots.Choices, 'Random')
table.insert(mascots.Values, 'Random')

return mascots
