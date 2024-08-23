local ichi = {}
setmetatable(ichi, {
	__index = _G,
	__call = function(self, f)
		setfenv(f or 2, self)
		return f
	end,
})

loadfile(GetFileDir()..'../lib/std.lua')(ichi)

ichi.run '/main.lua'

return Def.ActorFrame {
	OnCommand = function(self)
		for _, v in pairs(self:GetChildren()) do
			ichi.ActorTable[v:GetName()] = v
		end
	end,
	Def.Actor {
		Name = 'Sleepyhead',
		InitCommand = function(self) self:sleep(9e9) end
	},
	table.unpack(ichi.ActorTable)
}