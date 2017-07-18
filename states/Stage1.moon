Player = require "characters.Player"
colorize = require "lib.colorize"
Vector = require "hump.vector"
lovelog = require "lib.lovelog"
StatsPanel = require "UI.StatsPanel"
HPBar = require "UI.HPBar"
Boss = require "characters.Boss"
import BulletManager, Bullet from require "lib.Bullet"
config = require "config"

class Stage1
  -- canvas = love.graphics.newCanvas love.graphics.getWidth! - 200, love.graphics.getHeight!
  canvas = love.graphics.newCanvas config.scene_width, love.graphics.getHeight!
  player = nil
  enemy = nil
  enter: =>
    player = Player!
    enemy = Boss Vector(300, 50)
    Bullet{
      pos: Vector(500, 500),
      char: "0"
    }
    player\setPos(love.graphics.getWidth!/2, love.graphics.getHeight! - 20)

  update: (dt) =>
    BulletManager\update dt
    player\update dt
    enemy\update dt
    StatsPanel\update dt
    HPBar\update dt

  draw: =>
    love.graphics.setCanvas canvas
    colorize {10, 10, 10}, -> love.graphics.rectangle "fill", 0, 0, canvas\getWidth!, canvas\getHeight!
    lovelog.reset!
    lovelog.print "FPS: " .. love.timer.getFPS!
    enemy\draw!
    player\draw!
    BulletManager\draw!
    HPBar\draw!
    love.graphics.setCanvas!
    love.graphics.draw canvas
    StatsPanel\draw!
    -- love.graphics.print
