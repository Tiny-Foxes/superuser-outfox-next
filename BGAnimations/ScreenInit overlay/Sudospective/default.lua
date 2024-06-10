local taglines = {
	'gimme a kiss bb',
	'IT\'S SO REAL',
	'drink water',
	'LET\'S GOOOOOOOO!',
	'You can wish for a bicycle if you want to.',
	'Florida Man Arrested For Eating Paint',
	'I definitely don\'t have the launch codes.',
	'No, I won\'t teach you how to hack your school\'s Wi-Fi.',
	'play tunic NOW',
	'A chicken nugget, just for you!',
	--'🐱',
}
local idx = math.random(1, #taglines)
local line = taglines[idx]

--line = taglines[#taglines]

return Def.ActorFrame {
	OnCommand = function(self)
		self:Center():basezoom(SCREEN_HEIGHT / 720):zoom(1.05)
	end,
	Def.Sound {
		File = 'nyoron.ogg',
		OnCommand = function(self)
			self
				:sleep(0.25)
				:queuecommand('Play')
		end,
		PlayCommand = function(self)
			self:play()
		end,
	},
	Def.Sprite {
		Texture = 'bg.png',
		OnCommand = function(self)
			self:zoom(SCREEN_HEIGHT / 480)
		end,
	},
	Def.Sprite {
		Texture = 'banner.png',
		OnCommand = function(self)
			self
				:wag()
				:effectmagnitude(0, 0, 2)
				:zoom(0)
				:sleep(0.5)
				:easeoutback(0.25)
				:zoom(0.5)
				:sleep(2)
				:easeinback(0.25)
				:zoom(0)
		end,
	},
	Def.Text {
		Font = THEME:GetPathF('', 'SudoFont.ttf'),
		Fallback = THEME:GetPathF('', 'NotoSans-Regular.ttf'),
		Size = 48,
		Text = line,
		StrokeSize = 2,
		InitCommand = function(self)
			self:MainActor()
				:diffuse(color('#5E3F66'))
			self:StrokeActor()
				:diffuse(1, 1, 1, 1)

			self
				:Regen()
				:y(SCREEN_CENTER_Y - 150)
				:diffusealpha(0)
				:sleep(1.5)
				:linear(0.25)
				:diffusealpha(1)
				:sleep(1)
				:linear(0.25)
				:diffusealpha(0)
		end,
	},
	Def.Quad {
		InitCommand = function(self)
			self
				:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT)
				:diffuse(0, 0, 0, 1)
				:linear(0.25)
				:diffusealpha(0)
				:sleep(3)
				:linear(0.25)
				:diffusealpha(1)
				:sleep(1)
				:queuemessage('EndInit')
		end,
	},
}
