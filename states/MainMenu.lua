local StateManager = require("lib.StateManager")
local Matrix = require("states.Matrix")
local colorize = require("lib.colorize")
local config = require("config")
local menu = {
  {
    id = "play",
    text = "Play",
    action = function()
      return StateManager.switch("Stage1")
    end
  },
  {
    id = "settings",
    text = "Settings",
    action = function()
      return error("TODO")
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
local MainMenu
do
  local _class_0
  local _base_0 = {
    menu = menu,
    active_node = 1,
    matrix = Matrix(),
    enter = function(self) end,
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
    end,
    update = function(self, dt)
      love.graphics.setFont(config.fonts.menu)
      return self.matrix:update(dt)
    end,
    draw = function(self)
      self.matrix:draw()
      local x, y = 30, 30
      for i = 1, #self.menu do
        love.graphics.setNewFont(20)
        colorize((i == self.active_node) and {
          100,
          255,
          100
        } or {
          100,
          100,
          100
        }, function()
          return love.graphics.printf(self.menu[i].text, x, y, 300)
        end)
        y = y + 30
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "MainMenu"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  MainMenu = _class_0
  return _class_0
end
