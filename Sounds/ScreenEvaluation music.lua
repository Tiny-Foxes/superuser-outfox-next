if LoadModule('Config.Load.lua')('SuperuserBGMusic', 'Save/OutFoxPrefs.ini') then
	return THEME:GetPathS('', '_main')
end
return THEME:GetPathS('', '_silent')
