local lovelog = require("lib.lovelog")
local vector = require("hump.vector")
local colorize = require("lib.colorize")
local signal = require("hump.signal")
local config = require("config")
local HC = require("HCWorld")
local graphics
graphics = love.graphics
local Mode
do
  local _class_0
  local _base_0 = {
    update = function(self, boss, dt)
      self.total_time = self.total_time + dt
      return self.update_func(boss, dt, self.total_time)
    end,
    init = function(self, boss)
      self.total_time = 0
      return self.init_func(boss)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, args)
      self.id = args.id
      self.update_func = args.update_func
      self.init_func = args.init_func
      self.finished = false
      self.total_time = 0
    end,
    __base = _base_0,
    __name = "Mode"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Mode = _class_0
end
return {
  Mode = Mode
}
