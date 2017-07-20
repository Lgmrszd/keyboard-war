local HC = require("HCWorld")
local Bullet
do
  local _class_0
  local _base_0 = {
    update = function(self, dt) end,
    draw = function(self, dt) end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, args)
      self.pos = args.pos
      self.rad = 30
      self.char = args.char or "*"
      self.hitbox = HC:circle(self.pos.x, self.pos.y, self.rad)
    end,
    __base = _base_0,
    __name = "Bullet"
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
  local _ = {
    Bullet = Bullet
  }
  Bullet = _class_0
  return _class_0
end
