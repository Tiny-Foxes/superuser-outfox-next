if LoadModule('Config.Load.lua')('SuperuserBGMusic', 'Save/OutFoxPrefs.ini') then
  return THEME:GetPathS('', '_main')
else
  return THEME:GetPathS('', '_silent')
end
