local SceneManager = require("lib.SceneManager")
local vector = require("hump.vector")
local lovelog = require("lib.lovelog")
local config = require("config")
local Mode
Mode = require("lib.Modes").Mode
local Stage1
do
  local _class_0
  local enemy, walk, rage, boss_modes
  local _base_0 = {
    enter = function(self)
      love.graphics.setFont(config.fonts.art)
      SceneManager:spawnPlayer(vector(0.5, 0.9))
      return SceneManager:spawnBoss({
        pos = vector(0.5, 0.05),
        modes = boss_modes
      })
    end,
    update = function(self, dt)
      return SceneManager:update(dt)
    end,
    draw = function(self)
      lovelog.reset()
      SceneManager:draw()
      return lovelog.print("FPS: " .. love.timer.getFPS())
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "Stage1"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  enemy = nil
  walk = Mode({
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
  rage = Mode({
    id = "rage",
    init_func = function(self)
      self.circle_bullets_dt = 0
      self.circle_bullets_da = 0
      local cx = config.scene_width / 2
      self.rage_speed = (cx - self.pos.x) / 0.5
    end,
    update_func = function(self, dt, tt)
      self.circle_bullets_dt = self.circle_bullets_dt + dt
      if tt < 0.5 then
        local cx = config.scene_width / 2
        self.direction = (self.pos.x > cx) and "left" or "right"
        local vec = vector(0)
        vec.x = 1
        self.pos = self.pos + dt * self.rage_speed * vec:normalized()
      else
        if self.circle_bullets_dt >= 0.15 then
          self.circle_bullets_dt = 0
          self:spawnCircleBullets(20, self.circle_bullets_da)
          self.circle_bullets_da = self.circle_bullets_da + 1
        end
      end
      if tt > 5 then
        self.mode = "walk"
      end
    end
  })
  boss_modes = {
    ["walk"] = walk,
    ["rage"] = rage
  }
  Stage1 = _class_0
  return _class_0
end
