local vector = require("hump.vector")
local signal = require("hump.signal")
local lovelog = require("lib.lovelog")
local config = require("config")
local Bullet
Bullet = require("lib.Bullet").Bullet
local graphics, keyboard
do
  local _obj_0 = love
  graphics, keyboard = _obj_0.graphics, _obj_0.keyboard
end
local Vector = require("hump.vector")
local Basechar = require("lib.Basechar")
local HC = require("HCWorld")
local Enemy
do
  local _class_0
  local _parent_0 = Basechar
  local _base_0 = {
    update = function(self, dt)
      local vec = vector(0)
      if math.random() > 0.99 then
        self.mode = (self.mode == "right") and "left" or "right"
        self.text = self.texts[self.mode]
      end
      if math.random() > 0.6 then
        self:shoot()
      end
      if self.mode == "left" then
        vec.x = -1
      else
        vec.x = 1
      end
      self.pos = self.pos + dt * self.speed * vec:normalized()
      if self.pos.x < 0 then
        self.pos.x = 0
        self.mode = 'right'
      elseif self.pos.x > config.scene_width then
        self.pos.x = config.scene_width
        self.mode = 'left'
      end
      if next(HC:collisions(self.hitbox)) then
        for k, v in pairs(HC:collisions(self.hitbox)) do
          if k.type == "good" then
            self.hp = self.hp - 1
            signal.emit("boss_hp", self.max_hp, self.hp)
          end
        end
      end
      return self.hitbox:moveTo(self.pos.x, self.pos.y)
    end,
    shoot = function(self)
      return Bullet({
        pos = self.pos - Vector(0, 20),
        speed = math.random(30, 200),
        dir = Vector(math.random() - 0.5, math.random()):normalized(),
        char = "9",
        type = "evil"
      })
    end,
    draw = function(self)
      _class_0.__parent.draw(self)
      return lovelog.print("Boss's hp: " .. self.hp)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, pos)
      self.hitbox_radius = 10
      self.hitbox = HC:circle(self.pos.x, self.pos.y, self.hitbox_radius)
      self.pos = pos or self.pos
      self.max_hp = 100
      self.hp = self.max_hp
      self.texts = {
        right = "(凸ಠ益ಠ)凸",
        left = "凸(ಠ益ಠ凸)"
      }
      self.mode = "right"
      self.text = [[(凸ಠ益ಠ)凸]]
      self.width = 100
      self.speed = 100
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
