local Bullet
Bullet = require("lib.Bullet").Bullet
local Vector = require("hump.vector")
local Basechar = require("lib.Basechar")
local signal = require("hump.signal")
local HC = require("HCWorld")
local Enemy
do
  local _class_0
  local _parent_0 = Basechar
  local _base_0 = {
    update = function(self, dt)
      if self.move then
        self:move(dt)
      end
      self.hitbox:moveTo(self.pos.x, self.pos.y)
      if self.shoot then
        self:shoot(dt)
      end
      if next(HC:collisions(self.hitbox)) then
        for k, v in pairs(HC:collisions(self.hitbox)) do
          if k.type == "good" then
            signal.emit("dead", self)
          end
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, arg)
      self.pos = arg.pos or self.pos
      self.move = arg.move
      self.shoot = arg.shoot
      self.height = 15
      self.width = 30
      local hw, hh = self.width / 2, self.height / 2
      self.hitbox = HC:polygon(self.pos.x - hw, self.pos.y - hh, self.pos.x + hw, self.pos.y - hh, self.pos.x + hw, self.pos.y + hh, self.pos.x - hw, self.pos.y + hh)
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
