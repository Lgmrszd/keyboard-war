local vector = require("hump.vector")
local signal = require("hump.signal")
local lovelog = require("lib.lovelog")
local config = require("config")
local Bullet, CircleBullet
do
  local _obj_0 = require("lib.Bullet")
  Bullet, CircleBullet = _obj_0.Bullet, _obj_0.CircleBullet
end
local Mode
Mode = require("lib.Modes").Mode
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
    circleBulletsTimer = function(self)
      if self.circle_bullets_dt >= 0.15 then
        self.circle_bullets_dt = 0
        self:spawnCircleBullets(20, self.circle_bullets_da)
        self.circle_bullets_da = self.circle_bullets_da + 1
      end
    end,
    update = function(self, dt)
      if self.mode ~= self.pmode then
        self.modes[self.mode]:init(self)
        self.pmode = self.mode
      end
      self.modes[self.mode]:update(self, dt)
      self.hitbox:moveTo(self.pos.x, self.pos.y)
      if next(HC:collisions(self.hitbox)) then
        for k, v in pairs(HC:collisions(self.hitbox)) do
          if k.type == "good" then
            self.hp = self.hp - 1
            signal.emit("boss_hp", self.max_hp, self.hp)
            if self.hp == 0 then
              self.mode = "death"
            end
          end
        end
      end
    end,
    bullet1 = function(self, x, y)
      local bullet = Bullet({
        pos = Vector(x, y),
        speed = math.random(30, 200),
        dir = Vector(math.random() - 0.5, math.random()):normalized(),
        char = "9",
        type = "evil"
      })
      bullet.update = function(self, dt)
        self.pos = self.pos + (self.speed * dt * self.dir)
        self.hitbox:moveTo(self.pos.x, self.pos.y)
        if self.pos.y < 0 or self.pos.y > config.scene_height or self.pos.x < 0 or self.pos.x > config.scene_width then
          return self:remove()
        end
      end
    end,
    spawnCircleBullets = function(self, n, da)
      for i = 0, n - 1 do
        local a = i * (math.pi * 2) / n
        local cx, cy, r
        cx, cy, r, a = config.scene_width / 2, self.pos.y, 1, a + da
        CircleBullet({
          center_pos = Vector(cx, cy),
          r_spawn = r,
          pos = Vector(cx, cy) + vector.fromPolar(a, r),
          speed = 80,
          char = "*",
          type = "evil"
        })
      end
    end,
    shoot = function(self)
      return self:bullet1(self.pos.x, self.pos.y + 20)
    end,
    draw = function(self)
      _class_0.__parent.draw(self)
      return lovelog.print("Boss's hp: " .. self.hp)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, args)
      self.pos = args.pos
      self.hitbox_radius = 10
      self.hitbox = HC:circle(args.pos.x, args.pos.y, self.hitbox_radius)
      self.max_hp = 100
      self.hp = self.max_hp
      self.texts = {
        right = "(凸ಠ益ಠ)凸",
        left = "凸(ಠ益ಠ凸)"
      }
      self.direction = "right"
      self.mode = "walk"
      self.pmode = "nil"
      self.text = [[(凸ಠ益ಠ)凸]]
      self.width = 100
      self.speed = 100
      self.rage_speed = 300
      self.modes = args.modes
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
