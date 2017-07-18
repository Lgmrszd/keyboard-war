local colorize = require("lib.colorize")
local graphics
graphics = love.graphics
local StatsPanel
do
  local _class_0
  local canvas
  local _base_0 = {
    draw = function(self)
      love.graphics.setCanvas(canvas)
      colorize({
        20,
        0,
        20
      }, function()
        return graphics.rectangle("fill", 0, 0, canvas:getWidth(), canvas:getHeight())
      end)
      graphics.printf("WHAT", 10, 10, 100)
      graphics.setCanvas()
      return graphics.draw(canvas, love.graphics.getWidth() - 200, 0)
    end,
    update = function(self, dt) end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "StatsPanel"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  canvas = love.graphics.newCanvas(200, love.graphics.getHeight())
  StatsPanel = _class_0
  return _class_0
end
