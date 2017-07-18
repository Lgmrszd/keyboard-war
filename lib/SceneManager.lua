local BulletManager, Bullet
do
  local _obj_0 = require("lib.Bullet")
  BulletManager, Bullet = _obj_0.BulletManager, _obj_0.Bullet
end
local Vector = require("hump.vector")
local Boss = require("characters.Boss")
local SimpleEnemy = require("characters.SimpleEnemy")
local Player = require("characters.Player")
local HPBar = require("UI.HPBar")
local StatsPanel = require("UI.StatsPanel")
local colorize = require("lib.colorize")
local config = require("config")
local enemies = { }
local player
local SceneManager = {
  canvas = love.graphics.newCanvas(config.scene_width, love.graphics.getHeight()),
  addEnemy = function(self, e)
    enemies[e] = true
  end,
  spawnPlayer = function(self)
    player = Player()
    return player:setPos(love.graphics.getWidth() / 2, love.graphics.getHeight() - 20)
  end,
  spawnBoss = function(self)
    local boss = Boss(Vector(300, 50))
    enemies[boss] = true
  end,
  spawnEnemy = function(self)
    enemies[SimpleEnemy(Vector(300, 50))] = true
  end,
  setPlayer = function(self, p)
    player = p
  end,
  clear = function(self)
    enemies = { }
  end,
  update = function(self, dt)
    for enemy, _ in pairs(enemies) do
      enemy:update(dt)
    end
    player:update(dt)
    BulletManager:update(dt)
    HPBar:update(dt)
    return StatsPanel:update(dt)
  end,
  draw = function(self)
    love.graphics.setCanvas(self.canvas)
    colorize({
      10,
      10,
      10
    }, function()
      return love.graphics.rectangle("fill", 0, 0, self.canvas:getWidth(), self.canvas:getHeight())
    end)
    HPBar:draw()
    for enemy, _ in pairs(enemies) do
      enemy:draw()
    end
    player:draw()
    BulletManager:draw()
    love.graphics.setCanvas()
    love.graphics.draw(self.canvas)
    return StatsPanel:draw()
  end,
  keyreleased = function(self, key)
    return player and player:keyreleased(key)
  end,
  keypressed = function(self, key)
    return player and player:keypressed(key)
  end
}
return SceneManager
