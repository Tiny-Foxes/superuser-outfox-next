run '/game.lua'


local deltaTime = 0
local game = Game.new()
local timeToTrigger = 1.5

local rotAmp = 0
local fovAmp = 1
local fishAmp = 0

local function eventTriggered(interval)
	local curTime = GetTimeSinceStart()
	if curTime - deltaTime >= interval then
		deltaTime = curTime
		return true
	end
	return false
end


local function init()

	local r = SCREEN_HEIGHT / 720

	ActorTable.MatrixBoard
		:basezoom(r)
		:xy(-180 * r, -360 * r)
	for i = 1, ActorTable.MatrixBoard:GetNumWrapperStates() do
		ActorTable.MatrixBoard:RemoveWrapperState(i)
	end
	local wrapper = ActorTable.MatrixBoard:AddWrapperState()
	wrapper
		:bob()
		:effectmagnitude(0, 3, 0)
		:effectperiod(5)
		:Center()
		:fov(45)
		:basezoom(0.9)
		:zoom(0)
		:easeoutquint(3)
		:zoom(1)

	ActorTable.ScreenSprite:basezoom(SCREEN_HEIGHT / DISPLAY:GetDisplayHeight())
end

local function update()
	
	if eventTriggered(timeToTrigger) then
		game:SoftDrop()
	end

	ActorTable.Quads:settext('Quads\n'..(game.mQuad))
	ActorTable.Triples:settext('Triples\n'..(game.mTriple))
	ActorTable.Doubles:settext('Doubles\n'..(game.mDouble))
	ActorTable.Singles:settext('Singles\n'..(game.mSingle))
	ActorTable.LinesCleared:settext('Total Lines Cleared\n' .. (game.mLinesClear))

	-- its called tetrahol now fucking DRINK
	if not game.mGameOver then

		ActorTable.MatrixBoard:GetWrapperState(1)
			:fov(45 * fovAmp)
			:rotationx(math.cos(GetTimeSinceStart() * 0.1) * rotAmp)
			:rotationy(math.sin(GetTimeSinceStart() * 0.1) * rotAmp)
			:zoom(1 - (rotAmp * 0.0125))

		ActorTable.ScreenSprite:GetShader():uniform1f('amount', fishAmp)

		rotAmp = math.min(rotAmp + 0.001, 30)
		fovAmp = math.min(fovAmp + 0.00005, 3)
		fishAmp = math.max(fishAmp - 0.000025, -0.65)
	
	else

		ActorTable.MatrixBoard:GetWrapperState(1)
			:fov(45)
			:rotationx(0)
			:rotationy(0)
			:zoom(1)

		ActorTable.ScreenSprite:GetShader():uniform1f('amount', 0)

	end

end

local function input(event)

	if not event.PlayerNumber then
		event.PlayerNumber = PlayerNumber[1]
		event.GameButton = event.DeviceInput.button
	end

	game:HandleInput(event)

end

local function draw()

	game:Draw()

end


actor {
	Name = 'GameLoop',
	Type = 'Actor',
	OnCommand = function(self)
		self:queuecommand('Ready')
	end,
	ReadyCommand = function(self)
		init()
		SCREENMAN:GetTopScreen():AddInputCallback(function(event)
			if not event.type:find('Release') then
				input(event)
			end
		end)
		self:queuecommand('Update')
	end,
	UpdateCommand = function(self)
		update()
		self:sleep(OFMath.oneoverx(60)):queuecommand('Update')
	end,
}

actor {
	Name = 'Music',
	Type = 'Sound',
	OnCommand = function(self)
		self:stop()
		self:load(USR_ROOT..'/sounds/music (loop).ogg')
		self:play()
	end,
	GameOverMessageCommand = function(self)
		self:stop()
		self:load(USR_ROOT..'/sounds/glass.ogg')
		self:play()
	end,
	ResetGameMessageCommand = function(self)
		self:stop()
		self:load(USR_ROOT..'/sounds/music (loop).ogg')
		self:play()
	end,
}


actor {
	Name = 'BGCover',
	Type = 'Quad',
	Frag = USR_ROOT..'/shaders/breathing-colors.frag',
	InitCommand = function(self)
		self:FullScreen():diffuse(0, 0, 0, 1):glow(0, 0, 0, 0.9)
	end,
}

actor {
	Name = 'MatrixBoard',
	Type = 'ActorFrame',
	OnCommand = function(self)
		self:SetDrawFunction(draw)
	end,
	BumpLeftMessageCommand = function(self)
		self
			:finishtweening()
			:addx(-10)
			:easeoutcircle(0.25)
			:addx(10)
	end,
	BumpRightMessageCommand = function(self)
		self
			:finishtweening()
			:addx(10)
			:easeoutcircle(0.25)
			:addx(-10)
	end,
	SpinCWMessageCommand = function(self)
		self:GetWrapperState(1)
			:finishtweening()
			:addrotationz(5)
			:easeoutcircle(0.25)
			:addrotationz(-5)
	end,
	SpinCCWMessageCommand = function(self)
		self:GetWrapperState(1)
			:finishtweening()
			:addrotationz(-5)
			:easeoutcircle(0.25)
			:addrotationz(5)
	end,
	PieceLockedMessageCommand = function(self)
		self
			:finishtweening()
			:addy(10)
			:easeoutcircle(0.25)
			:addy(-10)
	end,
	ShortenDropTimeMessageCommand = function(self)
		timeToTrigger = timeToTrigger * 0.85
	end,
	GameOverMessageCommand = function(self)
		timeToTrigger = 9e9
		self
			:vibrate()
			:sleep(0.05)
			:queuecommand('Unvibrate')
		self:GetWrapperState(1)
			:easeoutelastic(0.25)
			:fov(45)
			:rotationx(0)
			:rotationy(0)
			:zoom(1)
			:easeinquint(1)
			:y(SCREEN_HEIGHT * 2)
			:rotationz(30)
	end,
	UnvibrateCommand = function(self)
		self:stopeffect()
	end,
	ResetGameMessageCommand = function(self)
		timeToTrigger = 1.5
		self:GetWrapperState(1)
			:finishtweening()
			:y(SCREEN_CENTER_Y)
			:rotationz(0)
			:zoom(0)
			:easeoutquint(3)
			:zoom(1)
	end,
}


actor {
	Name = 'ScreenAST',
	Type = 'ActorScreenTexture',
	InitCommand = function(self)
		self
			:SetSize(SCREEN_WIDTH, SCREEN_HEIGHT)
			:EnablePreserveTexture(false)
			:EnableAlphaBuffer(true)
			:EnableDepthBuffer(false)
			:SetTextureFiltering(true)
			:Create()
	end,
}

actor {
	Name = 'ScreenSprite',
	Type = 'Sprite',
	Frag = USR_ROOT..'/shaders/fisheye.frag',
	OnCommand = function(self)
		self:Center():SetSize(SCREEN_WIDTH, SCREEN_HEIGHT):SetTexture(ActorTable.ScreenAST:GetTexture())
	end,
}


actor {
	Name = 'Controls',
	Type = 'BitmapText',
	Font = 'Common Normal',
	Text = 'Controls\n\nP1 &LEFT;/&RIGHT; - Move Piece\nP1 &DOWN; - Soft Drop\nP1 &UP; - Hard Drop\nP2 &DOWN; or X - Rotate CW\nP2 &LEFT; or Z - Rotate CCW\nP2 &UP; or Space - Hold',
	InitCommand = function(self)
		self:xy(SCREEN_WIDTH * 0.25, SCREEN_HEIGHT * 0.7):diffusealpha(0)
	end,
	OnCommand = function(self)
		self:sleep(1):linear(1):diffusealpha(1)
	end,
	GameOverMessageCommand = function(self)
		self:diffusealpha(0)
	end,
}


actor {
	Name = 'Quads',
	Type = 'BitmapText',
	Font = 'Common Normal',
	Text = 'Quads\n0',
	InitCommand = function(self)
		self:xy(SCREEN_CENTER_X * 1.5, SCREEN_CENTER_Y * 1.5 - (64 * 4)):diffusealpha(0)
	end,
	OnCommand = function(self)
		self:sleep(1.6):linear(1):diffusealpha(1)
	end,
}

actor {
	Name = 'Triples',
	Type = 'BitmapText',
	Font = 'Common Normal',
	Text = 'Triples\n0',
	InitCommand = function(self)
		self:xy(SCREEN_CENTER_X * 1.5, SCREEN_CENTER_Y * 1.5 - (64 * 3)):diffusealpha(0)
	end,
	OnCommand = function(self)
		self:sleep(1.7):linear(1):diffusealpha(1)
	end,
}

actor {
	Name = 'Doubles',
	Type = 'BitmapText',
	Font = 'Common Normal',
	Text = 'Doubles\n0',
	InitCommand = function(self)
		self:xy(SCREEN_CENTER_X * 1.5, SCREEN_CENTER_Y * 1.5 - (64 * 2)):diffusealpha(0)
	end,
	OnCommand = function(self)
		self:sleep(1.8):linear(1):diffusealpha(1)
	end,
}

actor {
	Name = 'Singles',
	Type = 'BitmapText',
	Font = 'Common Normal',
	Text = 'Singles\n0',
	InitCommand = function(self)
		self:xy(SCREEN_CENTER_X * 1.5, SCREEN_CENTER_Y * 1.5 - (64 * 1)):diffusealpha(0)
	end,
	OnCommand = function(self)
		self:sleep(1.9):linear(1):diffusealpha(1)
	end,
}

actor {
	Name = 'LinesCleared',
	Type = 'BitmapText',
	Font = 'Common Normal',
	Text = 'Lines Cleared\n0',
	InitCommand = function(self)
		self:xy(SCREEN_CENTER_X * 1.5, SCREEN_CENTER_Y * 1.5):diffusealpha(0)
	end,
	OnCommand = function(self)
		self:sleep(2):linear(1):diffusealpha(1)
	end,
}


actor {
	Name = 'SpeedUpText',
	Type = 'BitmapText',
	Font = 'Common Large',
	Text = 'SPEED UP',
	InitCommand = function(self)
		self:Center():diffuse(0, 255, 0, 0)
	end,
	ShortenDropTimeMessageCommand = function(self)
		self
			:finishtweening()
			:diffusealpha(1)
			:zoom(1)
			:linear(1)
			:diffusealpha(0)
			:zoom(1.5)
	end,
}

actor {
	Name = 'GameOverText',
	Type = 'BitmapText',
	Font = 'Common Large',
	Text = 'GAME OVER',
	InitCommand = function(self)
		self:Center():diffusealpha(0)
	end,
	GameOverMessageCommand = function(self)
		self:diffusealpha(1):vibrate():sleep(0.1):queuecommand('Unvibrate'):sleep(3):queuecommand('Quit')
	end,
	UnvibrateCommand = function(self)
		self:stopeffect()
	end,
	ResetGameMessageCommand = function(self)
		self:diffusealpha(0)
	end,
	QuitCommand = function(self)
		for _, plr in ipairs(GAMESTATE:GetEnabledPlayers()) do
			STATSMAN:GetCurStageStats():GetPlayerStageStats(plr)
				:SetDancePoints(game.mLinesClear, 150)
				:SetTapNoteScores('TapNoteScore_W1', game.mQuad)
				:SetTapNoteScores('TapNoteScore_W2', game.mTriple)
				:SetTapNoteScores('TapNoteScore_W3', game.mDouble)
				:SetTapNoteScores('TapNoteScore_W4', game.mSingle)
				:SetTapNoteScores('TapNoteScore_Miss', 150 - game.mLinesClear)
		end
		SCREENMAN:GetTopScreen():PostScreenMessage('SM_NotesEnded', 0)
	end,
}
