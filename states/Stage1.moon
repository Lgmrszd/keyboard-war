SceneManager = require "lib.SceneManager"
signal = require "hump.signal"
vector = require "hump.vector"
lovelog = require "lib.lovelog"
config = require "config"
import Mode from require "lib.Modes"

class Stage1
  -- canvas = love.graphics.newCanvas love.graphics.getWidth! - 200, love.graphics.getHeight!
  enemy = nil
  death = Mode{
    id: "walk"
    init_func: () =>
      signal.emit("Stage1_end")

    update_func: (dt, tt) =>
      signal.emit("Stage1_end")

  }
  walk = Mode{
    id: "walk"
    init_func: () =>

    update_func: (dt, tt) =>
      vec = vector 0
      if math.random! > 0.99
        @direction = (@direction == "right") and "left" or "right"
        @text = @texts[@direction]
      if math.random! > 0.96
        @shoot!
      if @direction == "left" then
        vec.x = -1
      else
        vec.x = 1
      @pos = @pos + dt * @speed * vec\normalized!
      if @pos.x < 0
        @pos.x = 0
        @direction = "right"
      elseif @pos.x > config.scene_width
        @pos.x = config.scene_width
        @direction = "left"
      print "total time", tt
      if tt > 5
        @mode = "rage"

  }
  rage = Mode{
    id: "rage"
    init_func: () =>
      @circle_bullets_dt = 0
      @circle_bullets_da = 0
      --@pos.x = 0
      cx = config.scene_width/2
      @rage_speed = (cx - @pos.x)/0.5

    update_func: (dt, tt) =>
      @circle_bullets_dt += dt
      if tt < 0.5
        cx = config.scene_width/2
        -- print "pos.x", pos.x, "cx", cx, "next mode", @next_mode
        @direction = (@pos.x > cx) and "left" or "right"
        vec = vector 0
        vec.x = 1
        @pos = @pos + dt * @rage_speed * vec\normalized!
      else
        if @circle_bullets_dt >= 0.15
          @circle_bullets_dt = 0
          @spawnCircleBullets(20, @circle_bullets_da)
          @circle_bullets_da += 1
      if tt > 5
        @mode = "walk"

  }
  boss_modes = {
    "walk": walk
    "rage": rage
  }
  enter: =>
    love.graphics.setFont config.fonts.art
    SceneManager\spawnPlayer vector(0.5, 0.9)
    SceneManager\spawnBoss {
      pos: vector(0.5, 0.05)
      modes: boss_modes
    }

  update: (dt) =>
    SceneManager\update dt

  draw: =>
    lovelog.reset!
    SceneManager\draw!
    lovelog.print "FPS: " .. love.timer.getFPS!
    -- love.graphics.print
