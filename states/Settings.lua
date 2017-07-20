local config = require("config")
local settings
settings = config.settings
local StateManager = require("lib.StateManager")
local colorize = require("lib.colorize")
local menu = {
  {
    id = "gfx",
    keypressed = function(self, key)
      settings.graphics = not settings.graphics
    end,
    getText = function(self)
      return "Graphics: " .. (settings.graphics and "on" or "off")
    end
  },
  {
    id = "back",
    text = "Back",
    keypressed = function(self, key)
      if key == "shoot" then
        return StateManager.switch("MainMenu")
      end
    end
  }
}
local Settings
do
  local _class_0
  local _base_0 = {
    menu = menu,
    active_node = 1,
    draw = function(self)
      love.graphics.setFont(config.fonts.menu)
      local x, y = 30, 30
      for i, v in ipairs(menu) do
        colorize((i == self.active_node) and {
          100,
          255,
          100
        } or {
          100,
          100,
          100
        }, function()
          return love.graphics.printf(v.text or v:getText(), x, y, 300)
        end)
        y = y + 30
      end
    end,
    keypressed = function(self, key)
      if key == "down" then
        self.active_node = self.active_node + 1
        if self.active_node > #self.menu then
          self.active_node = 1
        end
      elseif key == "up" then
        self.active_node = self.active_node - 1
        if self.active_node == 0 then
          self.active_node = #self.menu
        end
      elseif self.menu[self.active_node].keypressed then
        return self.menu[self.active_node]:keypressed(key)
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "Settings"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Settings = _class_0
  return _class_0
end
