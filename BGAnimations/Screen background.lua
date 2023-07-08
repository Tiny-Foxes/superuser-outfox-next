local scx, scy = SCREEN_CENTER_X, SCREEN_CENTER_Y
local sw, sh = SCREEN_WIDTH, SCREEN_HEIGHT
local scale = sh / 480

local ThemeColor = LoadModule('Theme.Colors.lua')

local ast = Def.ActorScreenTexture {}

return Def.ActorFrame {
	-- Starfield
	Def.Sprite {
		Texture = THEME:GetPathG('ScreenWithMenuElements', 'nebula'),
		OnCommand = function(self)
			self
				:Center()
				:zoom((sh / 1080) * 1.1)
		end,
	},
	Def.Quad {
		InitCommand = function(self)
			self:FullScreen():blend('BlendMode_Add')
		end,
		OnCommand = function(self)
			self:luaeffect('Update')
		end,
		UpdateCommand = function(self)
			self:aux(self:getaux() + self:GetEffectDelta())
			self:GetShader():uniform1f('realtime', self:getaux())
		end,
		Frag = _SUPERUSER.GetShaders().vdrop,
	},
	-- Tint
	Def.Quad {
		OnCommand = function(self)
			self
				:FullScreen()
				:diffuse(ThemeColor.Primary)
				:diffusebottomedge(ThemeColor.Secondary)
				:diffusealpha(0.15)
		end,
		ThemeColorChangedMessageCommand = function(self, color)
			self
				:stoptweening()
				:linear(0.25)
				:diffuse(color.Primary)
				:diffusebottomedge(color.Secondary)
				:diffusealpha(0.15)
		end,
	},
	-- Dimmer
	Def.Quad {
		OnCommand = function(self)
			local a = LoadModule('Config.Load.lua')('SuperuserBGBrightness', 'Save/OutFoxPrefs.ini') or 1
			self
				:FullScreen()
				:diffuse(0, 0, 0, 1 - a)
		end,
		ThemeColorChangedMessageCommand = function(self)
			local a = LoadModule('Config.Load.lua')('SuperuserBGBrightness', 'Save/OutFoxPrefs.ini') or 1
			self
				:stoptweening()
				:linear(0.25)
				:diffuse(0, 0, 0, 1 - a)
		end,
	},
}
