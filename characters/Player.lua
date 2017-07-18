local Vector = require("hump.vector")
local signal = require("hump.signal")
local lovelog = require("lib.lovelog")
local colorize = require("lib.colorize")
local config = require("config")
local Bullet
Bullet = require("lib.Bullet").Bullet
local graphics
graphics = love.graphics
local Controller = require("lib.Controller")
local Basechar = require("lib.Basechar")
local HC = require("HCWorld")
local Player
do
  local _class_0
  local _parent_0 = Basechar
  local _base_0 = {
    text = "(=^･ω･^=)",
    width = 70,
    speed = 300,
    slowspeed = 100,
    health = 3,
    keys_locked = true,
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
      lovelog.print("Player hitbox rad: " .. self.hitbox_radius)
      lovelog.print("Player health: " .. self.health)
      return lovelog.print("Player x: " .. self.pos.x)
    end,
    update = function(self, dt)
      print(self.keys_locked)
      if self.keys_locked then
        return 
      end
      local vec = Vector(0)
      if Controller.pressed("left") then
        vec.x = -1
      elseif Controller.pressed("right") then
        vec.x = 1
      end
      if Controller.pressed("down") then
        vec.y = 1
      elseif Controller.pressed("up") then
        vec.y = -1
      end
      if Controller.pressed("shoot") then
        self:shoot()
      end
      local speed
      if Controller.pressed("slowdown") then
        speed = self.slowspeed
        self.draw_hitbox = true
      else
        speed = self.speed
        self.draw_hitbox = false
      end
      self.pos = self.pos + dt * speed * vec:normalized()
      if self.pos.x < 0 then
        self.pos.x = 0
      elseif self.pos.x > config.scene_width then
        self.pos.x = config.scene_width
      end
      if self.pos.y > graphics.getHeight() then
        self.pos.y = graphics.getHeight()
      elseif self.pos.y < 0 then
        self.pos.y = 0
      end
      self.hitbox:moveTo(self.pos.x, self.pos.y)
      if next(HC:collisions(self.hitbox)) then
        for k, v in pairs(HC:collisions(self.hitbox)) do
          if k.type == "evil" then
            signal.emit("player_meets_bullet")
            return 
          end
        end
      end
    end,
    shoot = function(self)
      local dist = 20
      if Controller.pressed("lshift") then
        dist = 10
      end
      Bullet({
        pos = self.pos + Vector(-dist, -10),
        speed = 2000,
        dir = Vector(0, -1),
        type = "good"
      })
      return Bullet({
        pos = self.pos + Vector(dist, -10),
        speed = 2000,
        dir = Vector(0, -1),
        type = "good"
      })
    end,
    keyreleased = function(self, key)
      self.keys_locked = false
    end,
    keypressed = function(self, key) end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Player",
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
  Player = _class_0
  return _class_0
end
