run '/tetromino.lua'


IPiece = Tetromino.new()
function IPiece.new(obj)
	obj = obj or Tetromino.new(obj)
	obj.mId = 1
	obj.mCells = {
		{ {1, 0}, {1, 1}, {1, 2}, {1, 3}, },
		{ {0, 2}, {1, 2}, {2, 2}, {3, 2}, },
		{ {2, 0}, {2, 1}, {2, 2}, {2, 3}, },
		{ {0, 1}, {1, 1}, {2, 1}, {3, 1}, },
	}
	obj.mStartRow = 0
	obj.mStartColumn = 3
	return obj
end

OPiece = Tetromino.new()
function OPiece.new(obj)
	obj = obj or Tetromino.new(obj)
	obj.mId = 2
	obj.mCells = {
		{ {0, 0}, {0, 1}, {1, 0}, {1, 1}, },
		{ {0, 0}, {0, 1}, {1, 0}, {1, 1}, },
		{ {0, 0}, {0, 1}, {1, 0}, {1, 1}, },
		{ {0, 0}, {0, 1}, {1, 0}, {1, 1}, },
	}
	obj.mStartRow = 0
	obj.mStartColumn = 4
	return obj
end

TPiece = Tetromino.new()
function TPiece.new(obj)
	obj = obj or Tetromino.new(obj)
	obj.mId = 3
	obj.mCells = {
		{ {0, 1}, {1, 0}, {1, 1}, {1, 2}, },
		{ {0, 1}, {1, 1}, {1, 2}, {2, 1}, },
		{ {1, 0}, {1, 1}, {1, 2}, {2, 1}, },
		{ {0, 1}, {1, 0}, {1, 1}, {2, 1}, },
	}
	obj.mStartRow = 0
	obj.mStartColumn = 3
	return obj
end

JPiece = Tetromino.new()
function JPiece.new(obj)
	obj = obj or Tetromino.new(obj)
	obj.mId = 4
	obj.mCells = {
		{ {0, 0}, {1, 0}, {1, 1}, {1, 2}, },
		{ {0, 1}, {0, 2}, {1, 1}, {2, 1}, },
		{ {1, 0}, {1, 1}, {1, 2}, {2, 2}, },
		{ {0, 1}, {1, 1}, {2, 0}, {2, 1}, },
	}
	obj.mStartRow = 0
	obj.mStartColumn = 3
	return obj
end

LPiece = Tetromino.new()
function LPiece.new(obj)
	obj = obj or Tetromino.new(obj)
	obj.mId = 5
	obj.mCells = {
		{ {0, 2}, {1, 0}, {1, 1}, {1, 2}, },
		{ {0, 1}, {1, 1}, {2, 1}, {2, 2}, },
		{ {1, 0}, {1, 1}, {1, 2}, {2, 0}, },
		{ {0, 0}, {0, 1}, {1, 1}, {2, 1}, },
	}
	obj.mStartRow = 0
	obj.mStartColumn = 3
	return obj
end

SPiece = Tetromino.new()
function SPiece.new(obj)
	obj = obj or Tetromino.new(obj)
	obj.mId = 6
	obj.mCells = {
		{ {0, 1}, {0, 2}, {1, 0}, {1, 1}, },
		{ {0, 1}, {1, 1}, {1, 2}, {2, 2}, },
		{ {1, 1}, {1, 2}, {2, 0}, {2, 1}, },
		{ {0, 0}, {1, 0}, {1, 1}, {2, 1}, },
	}
	obj.mStartRow = 0
	obj.mStartColumn = 3
	return obj
end


ZPiece = Tetromino.new()
function ZPiece.new(obj)
	obj = obj or Tetromino.new(obj)
	obj.mId = 7
	obj.mCells = {
		{ {0, 0}, {0, 1}, {1, 1}, {1, 2}, },
		{ {0, 2}, {1, 1}, {1, 2}, {2, 1}, },
		{ {1, 0}, {1, 1}, {2, 1}, {2, 2}, },
		{ {0, 1}, {1, 0}, {1, 1}, {2, 0}, },
	}
	obj.mStartRow = 0
	obj.mStartColumn = 3
	return obj
end
