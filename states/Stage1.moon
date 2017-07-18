lovelog = require "lib.lovelog"
config = require "config"
SceneManager = require "lib.SceneManager"

class Stage1
  -- canvas = love.graphics.newCanvas love.graphics.getWidth! - 200, love.graphics.getHeight!
  enemy = nil

  enter: =>
    love.graphics.setFont config.fonts.art
    SceneManager\spawnPlayer!
    SceneManager\spawnBoss!

  update: (dt) =>
    SceneManager\update dt

  draw: =>
    lovelog.reset!
    SceneManager\draw!
    lovelog.print "FPS: " .. love.timer.getFPS!
    -- love.graphics.print
