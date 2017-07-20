local colorize = require("lib.colorize")
local signal = require("hump.signal")
local config = require("config")
local graphics
graphics = love.graphics
local HPBar
do
  local _class_0
  local hidden, percentage, shift
  local _base_0 = {
    update_percentage = function(self, max_hp, hp)
      percentage = math.max(0, hp * 100 / max_hp)
    end,
    draw = function(self)
      if not hidden then
        local total_width = config.scene_width - shift * 2
        local hp_width = total_width * percentage / 100
        colorize({
          122,
          0,
          0
        }, function()
          return graphics.rectangle("fill", shift, 10, total_width, 10)
        end)
        colorize({
          200,
          0,
          0
        }, function()
          return graphics.rectangle("fill", shift, 10, hp_width, 10)
        end)
        return colorize({
          255,
          0,
          0
        }, function()
          return graphics.rectangle("line", shift, 10, total_width, 10)
        end)
      end
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
  hidden = true
  percentage = 100
  shift = 100
  signal.register("boss_hp", function(...)
    return self:update_percentage(...)
  end)
  signal.register("boss_appears", function()
    hidden = false
  end)
  signal.register("boss_disappears", function()
    hidden = true
  end)
  HPBar = _class_0
  return _class_0
end
