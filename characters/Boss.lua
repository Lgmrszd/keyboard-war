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
local death = Mode({
  id = "walk",
  init_func = function(self)
    signal.emit("Stage1_end")
    return signal.emit("boss_disappears")
  end,
  update_func = function(self, dt, tt)
    return signal.emit("Stage1_end")
  end
})
local appear = Mode({
  id = "appear",
  init_func = function(self)
    signal.emit("boss_appears")
    self.diff_pos = self.spawn_pos - self.income_pos
  end,
  update_func = function(self, dt, tt)
    if tt < 1 then
      self.pos = self.income_pos - tt * tt * self.diff_pos + tt * 2 * self.diff_pos
    else
      self.pos = self.spawn_pos
      self.mode = "walk"
    end
  end
})
local walk = Mode({
  id = "walk",
  init_func = function(self) end,
  update_func = function(self, dt, tt)
    local vec = vector(0)
    if math.random() > 0.99 then
      self.direction = (self.direction == "right") and "left" or "right"
      self.text = self.texts[self.direction]
    end
    if math.random() > 0.96 then
      self:shoot()
    end
    if self.direction == "left" then
      vec.x = -1
    else
      vec.x = 1
    end
    self.pos = self.pos + dt * self.speed * vec:normalized()
    if self.pos.x < 0 then
      self.pos.x = 0
      self.direction = "right"
    elseif self.pos.x > config.scene_width then
      self.pos.x = config.scene_width
      self.direction = "left"
    end
    print("total time", tt)
    if tt > 5 then
      self.mode = "rage"
    end
  end
})
local rage = Mode({
  id = "rage",
  init_func = function(self)
    self.circle_bullets_dt = 0
    self.circle_bullets_da = 0
    local cx = config.scene_width / 2
    self.rage_speed = (cx - self.pos.x) / 0.5
    self.diff_pos = vector(cx, self.pos.y) - self.pos
    self.income_pos = self.pos
  end,
  update_func = function(self, dt, tt)
    if tt < 1 then
      local cx = config.scene_width / 2
      self.direction = (self.pos.x > cx) and "left" or "right"
      self.text = self.texts[self.direction]
      self.pos = self.income_pos - tt * tt * self.diff_pos + tt * 2 * self.diff_pos
    else
      self.pos = vector(config.scene_width / 2, self.pos.y)
      self.circle_bullets_dt = self.circle_bullets_dt + dt
      if self.circle_bullets_dt >= 0.15 then
        self.circle_bullets_dt = 0
        self:spawnCircleBullets({
          n = 20,
          da = self.circle_bullets_da,
          aspeed = 0,
          color = {
            0,
            0,
            255
          }
        })
        self:spawnCircleBullets({
          n = 5,
          da = -self.circle_bullets_da * 1.5,
          aspeed = -40,
          color = {
            255,
            255,
            0
          },
          rad = 5
        })
        self.circle_bullets_da = self.circle_bullets_da + 1
      end
    end
    if tt > 5 then
      self.mode = "walk"
    end
  end
})
local boss_modes = {
  ["walk"] = walk,
  ["rage"] = rage,
  ["appear"] = appear,
  ["death"] = death,
  ["MAIN"] = "appear"
}
local Enemy
do
  local _class_0
  local _parent_0 = Basechar
  local _base_0 = {
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
    spawnCircleBullets = function(self, args)
      for i = 0, args.n - 1 do
        local a = i * (math.pi * 2) / args.n
        local cx, cy, r
        cx, cy, r, a = config.scene_width / 2, self.pos.y, 1, a + args.da
        CircleBullet({
          center_pos = Vector(cx, cy),
          r_spawn = r,
          pos = Vector(cx, cy) + vector.fromPolar(a, r),
          speed = 80,
          angle_speed = args.aspeed,
          color = args.color,
          char = "*",
          type = "evil",
          rad = args.rad
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
      self.pos = args.income_pos
      self.income_pos = args.income_pos
      self.spawn_pos = args.pos
      self.hitbox_radius = 10
      self.width = 70
      self.height = 15
      local hw, hh = self.width / 2, self.height / 2
      self.hitbox = HC:polygon(self.pos.x - hw, self.pos.y - hh, self.pos.x + hw, self.pos.y - hh, self.pos.x + hw, self.pos.y + hh, self.pos.x - hw, self.pos.y + hh)
      self.max_hp = 400
      self.hp = self.max_hp
      self.texts = {
        right = "(凸ಠ益ಠ)凸",
        left = "凸(ಠ益ಠ凸)"
      }
      self.direction = "right"
      self.mode = boss_modes["MAIN"]
      self.pmode = "nil"
      self.text = [[(凸ಠ益ಠ)凸]]
      self.speed = 100
      self.rage_speed = 300
      self.modes = boss_modes
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
