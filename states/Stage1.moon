SceneManager = require "lib.SceneManager"
Vector = require "hump.vector"
lovelog = require "lib.lovelog"
config = require "config"

class Stage1
  -- canvas = love.graphics.newCanvas love.graphics.getWidth! - 200, love.graphics.getHeight!
  enemy = nil

  enter: =>
    love.graphics.setFont config.fonts.art
    SceneManager\spawnPlayer Vector(0.5, 0.9)
    SceneManager\spawnBoss Vector(0.5, 0.05)

  update: (dt) =>
    SceneManager\update dt

  draw: =>
    lovelog.reset!
    SceneManager\draw!
    lovelog.print "FPS: " .. love.timer.getFPS!
    -- love.graphics.print
