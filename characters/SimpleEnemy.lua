local Bullet
Bullet = require("lib.Bullet").Bullet
local Vector = require("hump.vector")
local Basechar = require("lib.Basechar")
local Enemy
do
  local _class_0
  local _parent_0 = Basechar
  local _base_0 = {
    update = function(self, dt)
      if math.random() > 0.99 then
        return self:shoot()
      end
    end,
    shoot = function(self)
      return Bullet({
        pos = self.pos - Vector(0, 20),
        speed = math.random(1, 100),
        dir = Vector(math.random() * 2 - 1, math.random()):normalized(),
        char = "9"
      })
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, pos)
      self.pos = pos or self.pos
    end,
    __base = _base_0,
    __name = "Enemy",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Enemy = _class_0
  return _class_0
end
