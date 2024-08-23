local ichi = setmetatable({}, {
  __index = _ENV,
  __call = function(self, f)
    setfenv(f or 2, self)
    return f
  end,
})
ichi.ichi = ichi

-- constants
ichi.SCX = SCREEN_CENTER_X
ichi.SCY = SCREEN_CENTER_Y
ichi.SW = SCREEN_WIDTH
ichi.SH = SCREEN_HEIGHT
ichi.SL = SCREEN_LEFT
ichi.SR = SCREEN_RIGHT
ichi.ST = SCREEN_TOP
ichi.SB = SCREEN_BOTTOM
ichi.DW = DISPLAY:GetDisplayWidth()
ichi.DH = DISPLAY:GetDisplayHeight()
ichi.GAME_ROOT = GetFileDir()
ichi.SRC_ROOT = ichi.GAME_ROOT.."src"
ichi.__version = "1.0"

-- variables
ichi.Actors = Def.ActorFrame {}

-- run a file from /src
local funcs = {
  init = {},
  ready = {},
  update = {},
  input = {},
  draw = {},
}
function ichi.run(path)
  local data = assert(loadfile(ichi.GAME_ROOT.."src/"..path))
  ichi(data)()
  local i = {}
  for name in pairs(funcs) do
    i[name] = ichi[name]
    if i[name] then
      table.insert(funcs[name], i[name])
      ichi[name] = nil
    end
  end
end
-- include a file from /include
function ichi.include(name)
  local data = assert(loadfile(ichi.GAME_ROOT.."include/"..name..".lua"))
  ichi(data)()
end

local function config(key, file, cat)
  if not FILEMAN:DoesFileExist(file) then return end
  local container = {}
  local configfile = RageFileUtil.CreateRageFile()
  configfile:Open(file, 1)
  local configcontent = configfile:Read()
  configfile:Close()
  configfile:destroy()
  configcontent = configcontent:gsub("\r\n", "\n")
  local caty = true
  for line in string.gmatch(configcontent.."\n", "(.-)\n") do
    for con in string.gmatch(line, "%[(.-)%]") do
      if con == cat or cat == nil then caty = true else caty = false end
    end
    for keyval, val in string.gmatch(line, "(.-)=(.+)") do
      if key == keyval and caty then
        if val == "true" then return true end
        if val == "false" then return false end
        return val
      end
    end
  end
end

local settings = {}
function ichi.setting(name)
  if not settings[name] then
    local value = config(name, ichi.GAME_ROOT.."settings.ini")
    if value == nil then
      error("No value for setting \""..name.."\".")
      return
    end
    value = tonumber(value) or tobool(value) or value
    settings[name] = value
  end
  return settings[name]
end

-- grab from settings
ichi.IH = ichi.setting "IntendedHeight"

local LIBS = FILEMAN:GetDirListing(ichi.GAME_ROOT.."lib/", false, true)
local LibActors = Def.ActorFrame {}
for k, v in pairs(LIBS) do
  if v:find("%.lua") and not v:find("%.disabled") then
    table.insert(LibActors, assert(loadfile(v))(ichi) or nil)
  end
end

ichi.run("main.lua")
for _, func in ipairs(funcs.init) do func() end

return Def.ActorFrame {
  FOV = 120, -- the fov of one human eye
  InitCommand = function(self)
    ichi.Actors.Frame = self
    self:Center()
  end,
  OnCommand = function(self)
    ichi.Actors.Screen = SCREENMAN:GetTopScreen()
    for _, func in ipairs(funcs.ready) do func() end
    for _, func in ipairs(funcs.input) do
      SCREENMAN:GetTopScreen():AddInputCallback(func)
    end
  end,
  OffCommand = function(self)
    for _, func in ipairs(funcs.input) do
      SCREENMAN:GetTopScreen():RemoveInputCallback(func)
    end
  end,
  Def.Actor {
    Name = "Newsboy",
    OnCommand = function(self)
      self.StartTime = GetTimeSinceStart()
      self:sleep(self:GetEffectDelta()):queuecommand("Update")
    end,
    UpdateCommand = function(self, params)
      params = params or {}
      params.dt = params.dt or self:GetEffectDelta()
      params.time = GetTimeSinceStart() - self.StartTime
      for _, func in ipairs(funcs.update) do func(params) end
      self:sleep(params.dt):queuecommand("Update")
    end,
  },
  Def.ActorFrame {
    Name = "CenterWrapper",
    InitCommand = function(self)
      self:xy(-ichi.SCX, -ichi.SCY)
    end,
    LibActors,
    ichi.Actors,
    Def.ActorFrame {
      Name = "Picasso",
      OnCommand = function(self)
        if #funcs.draw > 0 then
          self:SetDrawFunction(function()
            for _, func in ipairs(funcs.draw) do func() end
          end)
        end
      end,
    },
  },
}
