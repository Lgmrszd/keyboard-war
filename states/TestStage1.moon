SceneManager = require "lib.SceneManager"
Vector = require "hump.vector"
import Bullet from require "lib.Bullet"
lovelog = require "lib.lovelog"
config = require "config"

class Stage1
  -- canvas = love.graphics.newCanvas love.graphics.getWidth! - 200, love.graphics.getHeight!
  enemy = nil

  enter: =>
    love.graphics.setFont config.fonts.art
    SceneManager\spawnPlayer Vector(0.5, 0.9)
    SceneManager\spawnEnemy{
      pos: Vector(0.5, 0.5)
      move: (dt) =>
        @pos = @pos + 200 * Vector(1, 1) * dt
      shoot: =>
        Bullet{
          pos: @pos + Vector(0, 10)
          speed: math.random(50, 100)
          dir: Vector(0.2*(math.random!-0.5), math.random!)\normalized!
          char: "*"
        }
    }
    -- SceneManager\spawnBoss Vector(0.5, 0.05)

  update: (dt) =>
    SceneManager\update dt

  draw: =>
    lovelog.reset!
    SceneManager\draw!
    lovelog.print "FPS: " .. love.timer.getFPS!
    -- love.graphics.print
