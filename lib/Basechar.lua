local Vector = require("hump.vector")
local HC = require("HCWorld")
local colorize = require("lib.colorize")
local config = require("config")
local Enemy
do
  local _class_0
  local _base_0 = {
    pos = Vector(0, 0),
    width = 50,
    height = 20,
    text = "x_x",
    hitbox_radius = 3,
    color = {
      50,
      150,
      50
    },
    setText = function(self, t)
      self.text = t
    end,
    setPos = function(self, x, y)
      self.pos = Vector(x, y)
    end,
    draw = function(self)
      local topleft = self.pos - Vector(self.width, 20) / 2
      if config.debug then
        colorize({
          30,
          30,
          30
        }, function()
          return love.graphics.rectangle("fill", topleft.x, topleft.y, self.width, 20)
        end)
        colorize({
          255,
          0,
          0
        }, function()
          return love.graphics.circle("fill", self.pos.x, self.pos.y, self.hitbox_radius)
        end)
      end
      return colorize(self.color, function()
        return love.graphics.printf(self.text, topleft.x, topleft.y, self.width, "center")
      end)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.hitbox = HC:circle(self.pos.x, self.pos.y, self.hitbox_radius)
    end,
    __base = _base_0,
    __name = "Enemy"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Enemy = _class_0
  return _class_0
end
