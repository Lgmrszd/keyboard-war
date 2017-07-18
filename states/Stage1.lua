local Player = require("characters.Player")
local colorize = require("lib.colorize")
local Vector = require("hump.vector")
local lovelog = require("lib.lovelog")
local StatsPanel = require("UI.StatsPanel")
local HPBar = require("UI.HPBar")
local Boss = require("characters.Boss")
local BulletManager, Bullet
do
  local _obj_0 = require("lib.Bullet")
  BulletManager, Bullet = _obj_0.BulletManager, _obj_0.Bullet
end
local config = require("config")
local Stage1
do
  local _class_0
  local canvas, player, enemy
  local _base_0 = {
    enter = function(self)
      love.graphics.setFont(config.fonts.art)
      player = Player()
      enemy = Boss(Vector(300, 50))
      Bullet({
        pos = Vector(500, 500),
        char = "0"
      })
      return player:setPos(love.graphics.getWidth() / 2, love.graphics.getHeight() - 20)
    end,
    update = function(self, dt)
      BulletManager:update(dt)
      player:update(dt)
      enemy:update(dt)
      StatsPanel:update(dt)
      return HPBar:update(dt)
    end,
    draw = function(self)
      love.graphics.setCanvas(canvas)
      colorize({
        10,
        10,
        10
      }, function()
        return love.graphics.rectangle("fill", 0, 0, canvas:getWidth(), canvas:getHeight())
      end)
      lovelog.reset()
      lovelog.print("FPS: " .. love.timer.getFPS())
      enemy:draw()
      player:draw()
      BulletManager:draw()
      HPBar:draw()
      love.graphics.setCanvas()
      love.graphics.draw(canvas)
      return StatsPanel:draw()
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
  canvas = love.graphics.newCanvas(config.scene_width, love.graphics.getHeight())
  player = nil
  enemy = nil
  Stage1 = _class_0
  return _class_0
end
