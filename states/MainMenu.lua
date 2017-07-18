local StateManager = require("lib.StateManager")
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
    submenu = { }
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
    enter = function(self)
      return love.graphics.setFont(config.fonts.menu)
    end,
    keypressed = function(self, key_id)
      if key_id == "down" then
        if love.keyboard.isDown("down") then
          self.active_node = self.active_node + 1
          if self.active_node > #self.menu then
            self.active_node = 1
          end
        end
      end
      if key_id == "z" then
        return self.menu[self.active_node].action()
      end
    end,
    update = function(self, dt) end,
    draw = function(self)
      local x, y = 10, 10
      for i = 1, #self.menu do
        love.graphics.setNewFont(20)
        colorize((i == self.active_node) and {
          200,
          250,
          200
        } or {
          200,
          200,
          200
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
