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
      if math.random! > 0.9
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
      if math.random! > 0.9
        Bullet{
          pos: @pos + Vector(0, 10)
          speed: math.random(50, 100)
          dir: Vector(0.2*(math.random!-0.5), math.random!)\normalized!
          char: "*"
        }
  }
  challenging1: {
    pos: Vector(5, 10) -- Too bad we have to use px coords atm. FIXME
    text: "(・`ω´・)"
    width: 60
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
  challenging2: {
    pos: Vector(595, 10) -- FIXME
    text: "(・`ω´・)"
    width: 60
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
--(╬`益´)
events = {
  {
    time: 0, action: ->
      SceneManager\spawnEnemy enemies.simple1
      SceneManager\spawnEnemy enemies.simple2
  }
  {
    time: 2, action: ->
      SceneManager\spawnEnemy enemies.challenging1
      SceneManager\spawnEnemy enemies.challenging2
  }
  {
    time: 3, action: ->
      SceneManager\spawnEnemy {
        pos: Vector(0, 30), text: "(╬`益´)", width: 60
        move: (dt) =>
          @pos = @pos + 500 * Vector(1, 0) * dt
        shoot: =>
          for i = 1, 3 do
            Bullet{
              pos: @pos + Vector(0, 20 * i)
              speed: 400 --math.random(50, 100)
              dir: Vector(0, 1)
              char: "*"
            }
      }
      SceneManager\spawnEnemy {
        pos: Vector(570, 30), text: "(`益´╬)", width: 60
        move: (dt) =>
          @pos = @pos + 500 * Vector(-1, 0) * dt
        shoot: =>
          for i = 1, 3 do
            Bullet{
              pos: @pos + Vector(0, 20 * i)
              speed: 400 --math.random(50, 100)
              dir: Vector(0, 1)
              char: "*"
            }
      }

  }
  {
    time: 10
    action: ->
      SceneManager\spawnBoss {
        pos: Vector(0.5, 0.05)
        income_pos: Vector(0.5, -0.05)
      }
  }
}

class Stage1
  -- canvas = love.graphics.newCanvas love.graphics.getWidth! - 200, love.graphics.getHeight!
  enemy = nil
  events: events

  enter: =>
    @time = 0
    @current_event = 1
    love.graphics.setFont config.fonts.art
    SceneManager\spawnPlayer Vector(0.5, 0.9)

    -- SceneManager\spawnBoss Vector(0.5, 0.05)

  update: (dt) =>
    SceneManager\update dt
    @time += dt
    event = @events[@current_event]
    if event and @time >= event.time
      @current_event += 1
      event.action!


  draw: =>
    lovelog.reset!
    SceneManager\draw!
    lovelog.print "FPS: " .. love.timer.getFPS!
    -- love.graphics.print
