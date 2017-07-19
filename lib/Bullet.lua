local lovelog = require("lib.lovelog")
local vector = require("hump.vector")
local colorize = require("lib.colorize")
local signal = require("hump.signal")
local config = require("config")
local HC = require("HCWorld")
local graphics
graphics = love.graphics
local BulletManager = {
  size = 0,
  last = 0,
  bullets = { },
  addBullet = function(self, b)
    self.size = self.size + 1
    self.bullets[b] = true
  end,
  removeBullet = function(self, b)
    self.bullets[b] = nil
    self.size = self.size - 1
  end,
  update = function(self, dt)
    for b, _ in pairs(self.bullets) do
      b:update(dt)
    end
  end,
  draw = function(self)
    lovelog.print("Bullet count: " .. self.size)
    for b, _ in pairs(self.bullets) do
      b:draw()
    end
  end,
  removeAllBullets = function(self)
    for b, _ in pairs(self.bullets) do
      b:remove()
    end
  end
}
signal.register("player_meets_bullet", function()
  return BulletManager:removeAllBullets()
end)
local Bullet
do
  local _class_0
  local _base_0 = {
    update = function(self, dt)
      self.pos = self.pos + (self.speed * dt * self.dir)
      self.hitbox:moveTo(self.pos.x, self.pos.y)
      if self.pos.y < 0 or self.pos.y > love.graphics.getHeight() or self.pos.x < 0 or self.pos.x > config.scene_width then
        return self:remove()
      end
    end,
    draw = function(self)
      return colorize({
        20,
        20,
        200
      }, function()
        return graphics.circle("fill", self.pos.x, self.pos.y, self.rad)
      end)
    end,
    remove = function(self)
      HC:remove(self.hitbox)
      return BulletManager:removeBullet(self)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, args)
      self.pos = args.pos
      self.rad = args.rad or 3
      self.speed = args.speed or 0
      self.dir = args.dir or vector(0, 0)
      self.char = args.char or "*"
      self.hitbox = HC:circle(self.pos.x, self.pos.y, self.rad)
      self.hitbox.type = args.type or "evil"
      return BulletManager:addBullet(self)
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
  Bullet = _class_0
end
local CircleBullet
do
  local _class_0
  local _parent_0 = Bullet
  local _base_0 = {
    update = function(self, dt)
      self.r_vector = self.r_vector:rotated((self.r_spawn / self.r_vector:toPolar()["y"]) * self.anglespeed * dt)
      self.r_vector = self.r_vector + (self.r_vector:normalized() * self.speed * dt)
      self.speed = self.speed + self.ac
      self.pos = self.center_pos + self.r_vector
      self.hitbox:moveTo(self.pos.x, self.pos.y)
      local scene_corner = vector(0, config.scene_height)
      local dr = scene_corner - self.center_pos
      if dr:toPolar()["y"] < self.r_vector:toPolar()["y"] then
        return self:remove()
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, args)
      _class_0.__parent.__init(self, args)
      self.center_pos = args.center_pos
      self.r_vector = args.center_pos - args.pos
      self.anglespeed = args.anglespeed or 1
      self.r_spawn = args.r_spawn
      self.ac = args.ac or 2
      self.pos = self.center_pos + self.r_vector
    end,
    __base = _base_0,
    __name = "CircleBullet",
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
  CircleBullet = _class_0
end
return {
  CircleBullet = CircleBullet,
  Bullet = Bullet,
  BulletManager = BulletManager
}
