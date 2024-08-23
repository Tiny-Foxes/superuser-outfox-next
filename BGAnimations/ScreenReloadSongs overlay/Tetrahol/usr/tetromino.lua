run '/t-color.lua'


Tetromino = {}
Tetromino.__index = Tetromino
setmetatable(Tetromino, Tetromino)


function Tetromino.new(obj)
	obj = obj or {}
	setmetatable(obj, Tetromino)
	obj.mCellSize = 36
	obj.mRotState = 1
	obj.mColors = TColor.GetAllColors()
	obj.mStartRow = 0
	obj.mStartColumn = 0
	obj.mRowOffset = 0
	obj.mColumnOffset = 0
	return obj
end

function Tetromino:Move(rows, columns)
	self.mRowOffset = self.mRowOffset + rows
	self.mColumnOffset = self.mColumnOffset + columns
end

function Tetromino:RotateCW()
	self.mRotState = self.mRotState + 1
	if self.mRotState > #self.mCells then
		self.mRotState = 1
	end
end

function Tetromino:RotateCCW()
	self.mRotState = self.mRotState - 1
	if self.mRotState < 1 then
		self.mRotState = #self.mCells
	end
end

function Tetromino:GetCellPositions()
	local res = {}
	for _, item in pairs(self.mCells[self.mRotState]) do
		local newPos = {
			item[1] + self.mStartRow + self.mRowOffset,
			item[2] + self.mStartColumn + self.mColumnOffset
		}
		table.insert(res, newPos)
	end
	return res
end

function Tetromino:Draw(offsetX, offsetY)
	local cells = self:GetCellPositions()
	for _, item in pairs(cells) do
		ActorTable.TCell
			:visible(true)
			:xy(item[2] * self.mCellSize + offsetX, item[1] * self.mCellSize + offsetY)
			:SetSize(self.mCellSize - 1, self.mCellSize - 1)
			:glow(self.mColors[self.mId])
			:Draw()
			:visible(false)
	end
end
