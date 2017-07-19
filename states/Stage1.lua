local SceneManager = require("lib.SceneManager")
local Vector = require("hump.vector")
local lovelog = require("lib.lovelog")
local config = require("config")
local Stage1
do
  local _class_0
  local enemy, boss_modes
  local _base_0 = {
    enter = function(self)
      love.graphics.setFont(config.fonts.art)
      SceneManager:spawnPlayer(Vector(0.5, 0.9))
      SceneManager:spawnBoss({
        pos = Vector(0.5, 0.05),
        modes = boss_modes
      })
      return print("player", SceneManager.player)
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
  boss_modes = { }
  Stage1 = _class_0
  return _class_0
end
