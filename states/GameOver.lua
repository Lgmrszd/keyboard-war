local config = require("config")
local StateManager = require("lib.StateManager")
local colorize = require("lib.colorize")
local menu = {
  {
    id = "retry",
    text = "Retry",
    action = function()
      return StateManager.switch("Stage1")
    end
  },
  {
    id = "exit",
    text = "Exit",
    action = function()
      return love.event.quit(0)
    end
  }
}
local GameOver
do
  local _class_0
  local _base_0 = {
    menu = menu,
    enter = function(self)
      self.active_node = 1
    end,
    draw = function(self)
      love.graphics.setFont(config.fonts.art_big)
      love.graphics.printf("Game over ლ(ಠ_ಠ ლ)", 30, 50, 300)
      love.graphics.setFont(config.fonts.menu)
      local x, y = 30, 100
      for i = 1, #self.menu do
        colorize((i == self.active_node) and {
          100,
          255,
          100
        } or {
          100,
          100,
          100
        }, function()
          return love.graphics.printf(self.menu[i].text, x, y, 200)
        end)
        y = y + 30
      end
    end,
    update = function(self) end,
    keypressed = function(self, key_id)
      if key_id == "down" then
        self.active_node = self.active_node + 1
        if self.active_node > #self.menu then
          self.active_node = 1
        end
      elseif key_id == "up" then
        self.active_node = self.active_node - 1
        if self.active_node == 0 then
          self.active_node = #self.menu
        end
      elseif key_id == "shoot" then
        return self.menu[self.active_node].action()
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "GameOver"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  GameOver = _class_0
  return _class_0
end
