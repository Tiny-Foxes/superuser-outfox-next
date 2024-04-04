if LoadModule('Konko.Core.lua').SetMeFree and LoadModule('Config.Load.lua')('SuperuserBGMusic', 'Save/OutFoxPrefs.ini') then
	return THEME:GetPathS('', '_space')
end
return THEME:GetPathS('', '_ambient')
