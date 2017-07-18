local binds
binds = require("config").binds
local keyboard
keyboard = love.keyboard
local reversed_binds = { }
for k, v in pairs(binds) do
  if type(v) == "table" then
    for _, key in pairs(v) do
      reversed_binds[key] = k
    end
  else
    reversed_binds[v] = k
  end
end
local controller = {
  pressed = function(key)
    key = binds[key] or key
    return love.keyboard.isDown(key)
  end,
  getActionByKey = function(key)
    return reversed_binds[key] or key
  end
}
return controller
