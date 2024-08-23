local ichi = ...


local USR_ROOT = GetFileDir()..'../usr'

ichi.ichi = ichi
ichi.ActorTable = {}
ichi.Module = {}
ichi.USR_ROOT = USR_ROOT

function ichi.run(path, ...)
	return ichi(loadfile(USR_ROOT..path))(...)
end

function ichi.actor(t)
	table.insert(ichi.ActorTable, t)
end

function ichi.ni(f)
	local env = {}
	setmetatable(env, {__index = ichi})
	env.ichi = ichi
	setfenv(f, env)
	return f()
end
