SceneManager = require "lib.SceneManager"
Vector = require "hump.vector"
import Bullet from require "lib.Bullet"
lovelog = require "lib.lovelog"
config = require "config"

enemies = {
  simple1: {
    pos: Vector(5, 10) -- Too bad we have to use px coords atm. FIXME
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
  simple2: {
    pos: Vector(595, 10) -- FIXME
    move: (dt) =>
      @pos = @pos + 200 * Vector(-1, 1) * dt
    shoot: =>
      Bullet{
        pos: @pos + Vector(0, 10)
        speed: math.random(50, 100)
        dir: Vector(0.2*(math.random!-0.5), math.random!)\normalized!
        char: "*"
      }
  }
}

class Stage1
  -- canvas = love.graphics.newCanvas love.graphics.getWidth! - 200, love.graphics.getHeight!
  enemy = nil

  enter: =>
    @time = 0
    love.graphics.setFont config.fonts.art
    SceneManager\spawnPlayer Vector(0.5, 0.9)
    SceneManager\spawnEnemy enemies.simple1
    SceneManager\spawnEnemy enemies.simple2
    -- SceneManager\spawnBoss Vector(0.5, 0.05)

  update: (dt) =>
    SceneManager\update dt
    @time += dt
    if @time > 3 and (not @spawned)
      @spawned = true
      SceneManager\spawnEnemy enemies.simple1
      SceneManager\spawnEnemy enemies.simple2

  draw: =>
    lovelog.reset!
    SceneManager\draw!
    lovelog.print "FPS: " .. love.timer.getFPS!
    -- love.graphics.print
