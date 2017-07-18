local lovelog = require("lib.lovelog")
local config = require("config")
local SceneManager = require("lib.SceneManager")
local Stage1
do
  local _class_0
  local enemy
  local _base_0 = {
    enter = function(self)
      love.graphics.setFont(config.fonts.art)
      SceneManager:spawnPlayer()
      return SceneManager:spawnBoss()
    end,
    update = function(self, dt)
      return SceneManager:update(dt)
    end,
    draw = function(self)
      lovelog.reset()
      SceneManager:draw()
      return lovelog.print("FPS: " .. love.timer.getFPS())
    end,
    keypressed = function(self, key)
      return SceneManager:keypressed(key)
    end,
    keyreleased = function(self, key)
      return SceneManager:keyreleased(key)
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
