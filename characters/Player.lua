local vector = require("hump.vector")
local signal = require("hump.signal")
local lovelog = require("lib.lovelog")
local colorize = require("lib.colorize")
local Bullet
Bullet = require("lib.Bullet").Bullet
local graphics, keyboard
do
  local _obj_0 = love
  graphics, keyboard = _obj_0.graphics, _obj_0.keyboard
end
local Basechar = require("lib.Basechar")
local HC = require("HCWorld")
local player
do
  local _class_0
  local _parent_0 = Basechar
  local _base_0 = {
    text = "(=^･ω･^=)",
    width = 70,
    speed = 300,
    slowspeed = 100,
    health = 3,
    draw = function(self)
      _class_0.__parent.draw(self)
      if self.draw_hitbox then
        colorize({
          255,
          0,
          0
        }, function()
          return love.graphics.circle("fill", self.pos.x, self.pos.y, self.hitbox_radius)
        end)
      end
      return lovelog.print("Player hitbox rad: " .. self.hitbox_radius)
    end,
    update = function(self, dt)
      local vec = vector(0)
      if keyboard.isDown("left") then
        vec.x = -1
      elseif keyboard.isDown("right") then
        vec.x = 1
      end
      if keyboard.isDown("down") then
        vec.y = 1
      elseif keyboard.isDown("up") then
        vec.y = -1
      end
      if keyboard.isDown("z") then
        self:shoot()
      end
      local speed
      if keyboard.isDown("lshift") then
        speed = self.slowspeed
        self.draw_hitbox = true
      else
        speed = self.speed
        self.draw_hitbox = false
      end
      self.pos = self.pos + dt * speed * vec:normalized()
      if self.pos.x < 0 then
        self.pos.x = 0
      elseif self.pos.x > graphics.getWidth() - 200 then
        self.pos.x = graphics.getWidth() - 200
      end
      if self.pos.y > graphics.getHeight() then
        self.pos.y = graphics.getHeight()
      elseif self.pos.y < 0 then
        self.pos.y = 0
      end
      self.hitbox:moveTo(self.pos.x, self.pos.y)
      if next(HC:collisions(self.hitbox)) then
        return signal.emit("player_meets_bullet")
      end
    end,
    shoot = function(self)
      local dist = 20
      if keyboard.isDown("lshift") then
        dist = 10
      end
      Bullet({
        pos = self.pos + vector(-dist, -10),
        speed = 2000,
        dir = vector(0, -1)
      })
      return Bullet({
        pos = self.pos + vector(dist, -10),
        speed = 2000,
        dir = vector(0, -1)
      })
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "player",
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
  player = _class_0
  return _class_0
end
