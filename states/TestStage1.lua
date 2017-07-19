local SceneManager = require("lib.SceneManager")
local Vector = require("hump.vector")
local Bullet
Bullet = require("lib.Bullet").Bullet
local lovelog = require("lib.lovelog")
local config = require("config")
local Stage1
do
  local _class_0
  local enemy
  local _base_0 = {
    enter = function(self)
      love.graphics.setFont(config.fonts.art)
      SceneManager:spawnPlayer(Vector(0.5, 0.9))
      return SceneManager:spawnEnemy({
        pos = Vector(0.5, 0.5),
        move = function(self, dt)
          self.pos = self.pos + 200 * Vector(1, 1) * dt
        end,
        shoot = function(self)
          return Bullet({
            pos = self.pos + Vector(0, 10),
            speed = math.random(50, 100),
            dir = Vector(0.2 * (math.random() - 0.5), math.random()):normalized(),
            char = "*"
          })
        end
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
  Stage1 = _class_0
  return _class_0
end
