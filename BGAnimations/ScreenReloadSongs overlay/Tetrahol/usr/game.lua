run '/matrix.lua'
run '/pieces.lua'


Game = {}
Game.__index = Game
setmetatable(Game, Game)


local dir = GetFileDir().. '../usr'

function Game.new(obj)
	obj = obj or {}
	setmetatable(obj, Game)
	obj.mMatrix = Matrix.new()
	obj.mPieces = obj:GetAllPieces()
	obj.mCurPiece = obj:GetRandomPiece()
	obj.mNextPiece = obj:GetRandomPiece()
	obj.mHoldPiece = IPiece.new()
	obj.mTrueHold = false
	obj.mAlreadyHeld = false
	obj.mGameOver = false
	obj.mLinesClear = 0
	obj.mSingle = 0
	obj.mDouble = 0
	obj.mTriple = 0
	obj.mQuad = 0
	return obj
end

function Game:GetRandomPiece()
	if #self.mPieces < 1 then
		self.mPieces = self:GetAllPieces()
	end
	local randIndex = (OFMath.randomint() % #self.mPieces) + 1
	local piece = self.mPieces[randIndex]
	table.remove(self.mPieces, randIndex)
	return piece
end

function Game:GetAllPieces()
	return {
		IPiece.new(),
		OPiece.new(),
		TPiece.new(),
		JPiece.new(),
		LPiece.new(),
		SPiece.new(),
		ZPiece.new(),
	}
end

function Game:IsPieceOutside()
	local cells = self.mCurPiece:GetCellPositions()
	for _, item in pairs(cells) do
		if self.mMatrix:IsCellOutside(item[1], item[2]) then
			return true
		end
	end
	return false
end

function Game:IsPieceColliding()
	local cells = self.mCurPiece:GetCellPositions()
	for _, item in pairs(cells) do
		if not self.mMatrix:IsCellEmpty(item[1], item[2]) then
			return true
		end
	end
	return false
end

function Game:LockToMatrix()
	local cells = self.mCurPiece:GetCellPositions()
	for _, item in pairs(cells) do
		self.mMatrix.mGrid[item[1]][item[2]] = self.mCurPiece.mId
	end
	SOUND:PlayOnce(dir..'/sounds/lock.ogg')
	MESSAGEMAN:Broadcast('PieceLocked')
	self.mCurPiece = self.mNextPiece
	if self:IsPieceColliding() then
		self:Reset()
	end
	self.mNextPiece = self:GetRandomPiece()
	local clearedRows = self.mMatrix:ClearFullRows()
	if clearedRows > 0 then
		SOUND:PlayOnce(dir..'/sounds/clear.ogg')
	end
	if clearedRows == 1 then self.mSingle = self.mSingle + 1
	elseif clearedRows == 2 then self.mDouble = self.mDouble + 1
	elseif clearedRows == 3 then self.mTriple = self.mTriple + 1
	elseif clearedRows == 4 then self.mQuad = self.mQuad + 1
	end
	self.mLinesClear = self.mLinesClear + clearedRows
	self.mAlreadyHeld = false
end

function Game:Reset()
	self.mMatrix:Initialize()
	self.mPieces = self:GetAllPieces()
	self.mCurPiece = self:GetRandomPiece()
	self.mNextPiece = self:GetRandomPiece()
	self.mGameOver = false
	self.mLinesClear = 0
	self.mSingle = 0
	self.mDouble = 0
	self.mTriple = 0
	self.mQuad = 0
end


function Game:MoveLeft()
	self.mCurPiece:Move(0, -1)
	if self:IsPieceOutside() or self:IsPieceColliding() then
		self.mCurPiece:Move(0, 1)
		MESSAGEMAN:Broadcast('BumpLeft')
	end
end

function Game:MoveRight()
	self.mCurPiece:Move(0, 1)
	if self:IsPieceOutside() or self:IsPieceColliding() then
		self.mCurPiece:Move(0, -1)
		MESSAGEMAN:Broadcast('BumpRight')
	end
end

function Game:SoftDrop()
	self.mCurPiece:Move(1, 0)
	if self:IsPieceOutside() or self:IsPieceColliding() then
		self.mCurPiece:Move(-1, 0)
		self:LockToMatrix()
	end
end

function Game:HardDrop()
	local piece = self.mCurPiece
	while not self:IsPieceColliding() and not self:IsPieceOutside() and self.mCurPiece == piece do
		self:SoftDrop()
	end
end

function Game:RotateCW()
	self.mCurPiece:RotateCW()
	if self:IsPieceOutside() or self:IsPieceColliding() then
		self.mCurPiece:RotateCCW()
		MESSAGEMAN:Broadcast('SpinCW')
	else
		SOUND:PlayOnce(dir..'/sounds/rotate.ogg')
	end
end

function Game:RotateCCW()
	self.mCurPiece:RotateCCW()
	if self:IsPieceOutside() or self:IsPieceColliding() then
		self.mCurPiece:RotateCW()
		MESSAGEMAN:Broadcast('SpinCCW')
	else
		SOUND:PlayOnce(dir..'/sounds/rotate.ogg')
	end
end

function Game:HoldPiece()
	if self.mAlreadyHeld then return end
	local pieceToHold = self.mCurPiece
	if self.mTrueHold then
		self.mCurPiece = self.mHoldPiece
	else
		self.mCurPiece = self.mNextPiece
		self.mNextPiece = self:GetRandomPiece()
	end
	self.mHoldPiece = pieceToHold
	self.mCurPiece.mRowOffset = 0
	self.mCurPiece.mColumnOffset = 0
	self.mCurPiece.mRotState = 1
	self.mHoldPiece.mRowOffset = 0
	self.mHoldPiece.mColumnOffset = 0
	self.mHoldPiece.mRotState = 1
	self.mAlreadyHeld = true
	self.mTrueHold = true
end


function Game:HandleInput(event)
	if not self.mGameOver then
		local b = event.GameButton
		if event.PlayerNumber:find('P1') then
			if b == 'MenuLeft' then
				self:MoveLeft()
			elseif b == 'MenuRight' then
				self:MoveRight()
			elseif b == 'MenuDown' then
				self:SoftDrop()
			elseif b == 'MenuUp' then
				self:HardDrop()
			elseif b == 'DeviceButton_z' then
				self:RotateCCW()
			elseif b == 'DeviceButton_x' then
				self:RotateCW()
			elseif b == 'DeviceButton_r' then
				self:Reset()
			elseif b == 'DeviceButton_space' then
				self:HoldPiece()
			end
		elseif event.PlayerNumber:find('P2') then
			if b == 'MenuLeft' then
				self:RotateCCW()
			elseif b == 'MenuDown' then
				self:RotateCW()
			elseif b == 'MenuUp' then
				self:HoldPiece()
			end
		end
	else
		local b = event.GameButton
		if b == 'DeviceButton_r' then
			self:Reset()
		end
	end
end

function Game:Draw()
	self.mMatrix:Draw()
	self.mCurPiece:Draw(1, 1)
	self.mNextPiece:Draw(SCREEN_CENTER_X * 0.5, 64)
	if self.mTrueHold then
		self.mHoldPiece:Draw(-SCREEN_CENTER_X * 0.5, 64)
	end
end
