local binds
binds = require("config").binds
local keyboard
keyboard = love.keyboard
local reversed_binds = { }
for k, v in pairs(binds) do
  reversed_binds[v] = k
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
