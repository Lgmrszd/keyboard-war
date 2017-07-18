local Bullet
Bullet = require("lib.Bullet").Bullet
local Vector = require("hump.vector")
local Basechar = require("lib.Basechar")
local HC = require("HCWorld")
local Enemy
do
  local _class_0
  local _parent_0 = Basechar
  local _base_0 = {
    update = function(self, dt)
      if math.random() > 0.99 then
        self.mode = (self.mode == "right") and "left" or "right"
        self.text = self.texts[self.mode]
      end
      if math.random() > 0.6 then
        self:shoot()
      end
      return self.hitbox:moveTo(self.pos.x, self.pos.y)
    end,
    shoot = function(self)
      return Bullet({
        pos = self.pos - Vector(0, 20),
        speed = math.random(30, 200),
        dir = Vector(math.random() - 0.5, math.random()):normalized(),
        char = "9"
      })
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, pos)
      self.hitbox_radius = 10
      self.hitbox = HC:circle(self.pos.x, self.pos.y, self.hitbox_radius)
      self.pos = pos or self.pos
      self.texts = {
        right = "(凸ಠ益ಠ)凸",
        left = "凸(ಠ益ಠ凸)"
      }
      self.mode = "right"
      self.text = [[(凸ಠ益ಠ)凸]]
      self.width = 100
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
