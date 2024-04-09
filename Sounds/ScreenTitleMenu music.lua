if LoadModule('Config.Load.lua')('SuperuserBGMusic', 'Save/OutFoxPrefs.ini') then
	if LoadModule('Konko.Core.lua').SetMeFree then
		return THEME:GetPathS('', '_space')
	else
		return THEME:GetPathS('', '_main')
	end
end
return THEME:GetPathS('', '_silent')
