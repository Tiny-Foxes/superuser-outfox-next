local st = StepsType and StepsType:Reverse() or {
	StepsType_Dance_Single = 0,
	StepsType_Dance_Double = 1,
	StepsType_Dance_Couple = 2,
	StepsType_Dance_Solo = 3,
	StepsType_Dance_Threepanel = 4,
	StepsType_Dance_Routine = 5,
	StepsType_Pump_Single = 6,
	StepsType_Pump_Halfdouble = 7,
	StepsType_Pump_Double = 8,
	StepsType_Pump_Couple = 9,
	StepsType_Pump_Routine = 10,
	StepsType_Kb7_Single = 11,
	StepsType_Ez2_Single = 12,
	StepsType_Ez2_Double = 13,
	StepsType_Ez2_Real = 14,
	StepsType_Para_Single = 15,
	StepsType_Para_Double = 16,
	StepsType_Para_Eight = 17,
	StepsType_Ds3ddx_Single = 18,
	StepsType_Bm_Single5 = 19,
	StepsType_Bm_Double5 = 20,
	StepsType_Bm_Single7 = 21,
	StepsType_Bm_Double7 = 22,
	StepsType_Maniax_Single = 23,
	StepsType_Maniax_Double = 24,
	StepsType_Techno_Single4 = 25,
	StepsType_Techno_Single5 = 26,
	StepsType_Techno_Single8 = 27,
	StepsType_Techno_Single9 = 28,
	StepsType_Techno_Double4 = 29,
	StepsType_Techno_Double5 = 30,
	StepsType_Techno_Double8 = 31,
	StepsType_Techno_Double9 = 32,
	StepsType_Pnm_Three = 33,
	StepsType_Pnm_Four = 34,
	StepsType_Pnm_Five = 35,
	StepsType_Pnm_Seven = 36,
	StepsType_Pnm_Nine = 37,
	StepsType_Pnm_Nine_Double = 38,
	StepsType_Gddm_Real = 39,
	StepsType_Gddm_New = 40,
	StepsType_Gddm_Old = 41,
	StepsType_Guitar_Five = 42,
	StepsType_Bass_Six = 43,
	StepsType_Guitar_Six = 44,
	StepsType_Guitar_Three = 45,
	StepsType_Bass_Four = 46,
	StepsType_Gh_Solo = 47,
	StepsType_Gh_Solo6 = 48,
	StepsType_Gh_Bass = 49,
	StepsType_Gh_Bass6 = 50,
	StepsType_Gh_Rhythm = 51,
	StepsType_Gh_Rhythm6 = 52,
	StepsType_Taiko = 53,
	StepsType_Lights_Cabinet = 54,
	StepsType_Kickbox_Human = 55,
	StepsType_Kickbox_Arachnid = 58,
	StepsType_Kickbox_Quadarm = 56,
	StepsType_Kickbox_Insect = 57,
}

local game = GAMESTATE:GetCurrentGame():GetName()

local game_remap = {
	['be-mu'] = 'bm',
	['po-mu'] = 'popn',
	['groove'] = 'dance',
}

local function compare(a, b)
	if st[a:GetStepsType()] == st[b:GetStepsType()] then
		if TF_WHEEL.DiffTab[a:GetDifficulty()] == TF_WHEEL.DiffTab[b:GetDifficulty()] then
			return a:GetMeter() < b:GetMeter()
		else
			return TF_WHEEL.DiffTab[a:GetDifficulty()] < TF_WHEEL.DiffTab[b:GetDifficulty()]
		end
	else
		return st[a:GetStepsType()] < st[b:GetStepsType()]
	end
end

return function(Song)
	local diffs
	if GAMESTATE:IsCourseMode() then
		diffs = Song:GetAllTrails()
	else
		diffs = Song:GetAllSteps()
	end
	local compat = {}
	for chart in ivalues(diffs) do
		local match = chart:GetStepsType():lower()
		if match:find((game_remap[game] or game)) then
			if not (
				match:find('double') and
				GAMESTATE:GetNumPlayersEnabled() > 1
			) or not (
				match:find('couple') and
				GAMESTATE:GetNumPlayersEnabled() < 2
			) then
				compat[#compat + 1] = chart
			end
		end
	end
	table.sort(compat, compare)
	return compat
end
