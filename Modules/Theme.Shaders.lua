return function()
	
	local shaderlist = FILEMAN:GetDirListing(THEME:GetCurrentThemeDirectory()..'Shaders/', false, false)
	local shaders = {}

	for _, v in pairs(shaderlist) do
		shaders[v:match('%w+')] = '/'..THEME:GetCurrentThemeDirectory()..'Shaders/'..v
	end

	return shaders

end
