TColor = {}
TColor.__index = TColor
setmetatable(TColor, TColor)


TColor.None = color('#303030A0')
TColor.I = color('#00FFFFA0')
TColor.O = color('#FFFF00A0')
TColor.T = color('#FF00FFA0')
TColor.J = color('#0000FFA0')
TColor.L = color('#FF8000A0')
TColor.S = color('#00FF00A0')
TColor.Z = color('#FF0000A0')

function TColor.GetAllColors()
	return {
		[0] = TColor.None,
		[1] = TColor.I,
		[2] = TColor.O,
		[3] = TColor.T,
		[4] = TColor.J,
		[5] = TColor.L,
		[6] = TColor.S,
		[7] = TColor.Z
	}
end


actor {
	Name = 'TCell', -- it will kill you
	Type = 'Quad',
	Frag = USR_ROOT..'/shaders/breathing-colors.frag',
	OnCommand = function(self)
		self:SetSize(30, 30):align(0, 0):visible(false)
			:bob():effectmagnitude(0, 0, 1)
	end,
}
