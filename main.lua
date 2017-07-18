local StateManager = require("lib.StateManager")
local Controller = require("lib.Controller")
local lovelog = require("lib.lovelog")
love.load = function()
  math.randomseed(os.time())
  if arg[#arg] == "-debug" then
    require("mobdebug").start()
  end
  return StateManager.switch("MainMenu")
end
love.keypressed = function(kid)
  if kid == "f1" then
    lovelog.toggle()
  end
  local state = StateManager.getState()
  if state.keypressed then
    return state:keypressed(Controller.getActionByKey(kid))
  end
end
