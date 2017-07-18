local colorize = require("lib.colorize")
local config = require("config")
local graphics
graphics = love.graphics
local HPBar
do
  local _class_0
  local shift
  local _base_0 = {
    draw = function(self)
      return colorize({
        255,
        0,
        0
      }, function()
        return graphics.rectangle("fill", shift, 10, config.scene_width - shift * 2, 10)
      end)
    end,
    update = function(self) end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "HPBar"
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
  shift = 20
  HPBar = _class_0
  return _class_0
end
