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
      colorize({
        20,
        20,
        200
      }, function()
        return graphics.circle("fill", self.pos.x, self.pos.y, self.rad)
      end)
      return graphics.printf(self.char, self.pos.x - self.rad, self.pos.y - self.rad, 2 * self.rad, "center")
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
return {
  Bullet = Bullet,
  BulletManager = BulletManager
}
