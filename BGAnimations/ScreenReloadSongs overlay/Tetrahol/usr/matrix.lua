run '/t-color.lua'


Matrix = {}
Matrix.__index = Matrix
setmetatable(Matrix, Matrix)


function Matrix.new(obj)
	obj = obj or {}
	setmetatable(obj, Matrix)
	obj.mWidth = 10
	obj.mHeight = 20
	obj.mCellSize = 36
	obj.mGrid = {}
	obj:Initialize()
	obj.mColors = TColor.GetAllColors()
	obj.mLinesClear = 0
	return obj
end

function Matrix:Initialize()
	self.mLinesClear = 0
	for i = 0, self.mHeight - 1 do
		self.mGrid[i] = {}
		for j = 0, self.mWidth - 1 do
			self.mGrid[i][j] = 0;
		end
	end
end

function Matrix:IsCellOutside(row, column)
	return not (
		row >= 0 and
		row < self.mHeight and
		column >= 0 and
		column < self.mWidth
	)
end

function Matrix:IsCellEmpty(row, column)
	return self.mGrid[row][column] == 0
end

function Matrix:IsRowFull(row)
	for i = 0, self.mWidth - 1 do
		if self.mGrid[row][i] == 0 then
			return false
		end
	end
	return true
end

function Matrix:ClearRow(row)
	for i = 0, self.mWidth - 1 do
		self.mGrid[row][i] = 0
	end
end

function Matrix:MoveRowDown(row, numRows)
	for i = 0, self.mWidth - 1 do
		self.mGrid[row + numRows][i] = self.mGrid[row][i]
		self.mGrid[row][i] = 0
	end
end

function Matrix:ClearFullRows()
	local completed = 0
	for i = self.mHeight - 1, 0, -1 do
		if self:IsRowFull(i) then
			self:ClearRow(i)
			completed = completed + 1
			self.mLinesClear = self.mLinesClear + 1
			if self.mLinesClear % 30 == 0 and self.mLinesClear > 0 then
				MESSAGEMAN:Broadcast('ShortenDropTime') -- icky escape hatch
			end
		elseif completed > 0 then
			self:MoveRowDown(i, completed)
		end
	end
	return completed
end

function Matrix:Draw()
	for i = 0, self.mHeight - 1 do
		for j = 0, self.mWidth - 1 do
			local cellValue = self.mGrid[i][j]
			ActorTable.TCell
				:visible(true)
				:xy(j * self.mCellSize + 1, i * self.mCellSize + 1)
				:SetSize(self.mCellSize - 1, self.mCellSize - 1)
				:glow(self.mColors[cellValue])
				:Draw()
				:visible(false)
		end
	end
end
