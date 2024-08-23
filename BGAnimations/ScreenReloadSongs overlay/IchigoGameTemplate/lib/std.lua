-- std.lua

-- Standard Library for Ichigo Template
-- written by Sudospective
-- stripped down for Ichigo Game

local ichi = ...

-- check for alpha v
function ichi.go()
  return tonumber(ProductVersion():sub(1, ProductVersion():find("%-") - 1)) >= 0.5
end

-- create an actor
function ichi.actor(t)
  table.insert(ichi.Actors, Def[t.Type](t))
  return ichi.actor
end

-- create a loop
function ichi.loop(t)
  if type(t[1]) == "number" then
    t.step = t.step or 1
    for i = t[1], t[1] + t[2] - t.step, t.step do
      t[3](i)
    end
  elseif type(t[1]) == "table" then
    for k, v in pairs(t[1]) do
      t[2](k, v)
    end
  end
  return ichi.loop
end
