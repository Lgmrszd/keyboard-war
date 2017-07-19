vector = require "hump.vector"
signal = require "hump.signal"
lovelog = require "lib.lovelog"
config = require "config"
import Bullet, CircleBullet from require "lib.Bullet"
import Mode from require "lib.Modes"
import graphics, keyboard from love
Vector = require "hump.vector"
Basechar = require "lib.Basechar"
HC = require "HCWorld"


class Enemy extends Basechar
  new: (args) =>
    @pos = args.pos
    @hitbox_radius = 10
    @hitbox = HC\circle args.pos.x, args.pos.y, @hitbox_radius
    @max_hp = 100
    @hp = @max_hp
    @texts = {
      right: "(凸ಠ益ಠ)凸"
      left: "凸(ಠ益ಠ凸)"
    }
    @direction = "right"
    @mode = "initiate"
    @text = [[(凸ಠ益ಠ)凸]]
    @width = 100
    @speed = 100
    @rage_speed = 300
    @mode_dt = 0
    @modes2 = {

    }
    @modes = {
      "initiate": (dt) =>
        @mode_dt = 0
        @mode = "walk"
      "walk": (dt) =>
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
        @mode_dt += dt
        if @mode_dt > 5
          @mode_dt = 0
          @mode = "rage"
          @circle_bullets_dt = 0
          @circle_bullets_da = 0
          -- TODO: fix "goto_center"
          @next_mode = "rage"
          @mode = "goto_center"
      "goto_center": (dt) =>
        cx = config.scene_width/2
        -- print "pos.x", pos.x, "cx", cx, "next mode", @next_mode
        @direction = (pos.x > cx) and "left" or "right"
        vec = vector 0
        if @direction == "left" then
          vec.x = -1
        else
          vec.x = 1
        @pos = @pos + dt * @rage_speed * vec\normalized!
        if (@pos.x < (cx + 1)) and (@pos.x > (cx - 1))
          @pos.x = cx
          @mode = @next_mode

      "rage": (dt) =>
        @circle_bullets_dt += dt
        @circleBulletsTimer!
        @mode_dt += dt
        if @mode_dt > 5
          @circle_bullets_dt = 0
          @circle_bullets_da = 0
          @mode_dt = 0
          @mode = "walk"
          -- TODO: fix "goto_center"
          @next_mode = "walk"
          @mode = "goto_center"

      "death": (dt) =>
        signal.emit("Stage1_end")

    }

  circleBulletsTimer: =>
    print @circle_bullets_dt
    if @circle_bullets_dt >= 0.15
      @circle_bullets_dt = 0
      @spawnCircleBullets(20, @circle_bullets_da)
      @circle_bullets_da += 1

  update: (dt) =>
    @modes[@mode](@,dt)
    @hitbox\moveTo @pos.x, @pos.y
    if next(HC\collisions(@hitbox))
      for k, v in pairs HC\collisions(@hitbox)
        if k.type == "good"
          @hp -= 1
          signal.emit("boss_hp", @max_hp, @hp)
          if @hp == 0
            @mode = "death"

  bullet1: (x, y) =>
    bullet = Bullet{
      pos: Vector(x, y)
      speed: math.random(30, 200)
      dir: Vector(math.random! - 0.5, math.random!)\normalized!
      char: "9"
      type: "evil"
    }
    bullet.update = (dt) =>
      @pos += @speed * dt * @dir
      @hitbox\moveTo @pos.x, @pos.y
      if @pos.y < 0 or @pos.y > config.scene_height or @pos.x < 0 or @pos.x > config.scene_width
        @remove!





  spawnCircleBullets: (n, da) =>
    for i = 0, n-1
      a = i*(math.pi*2)/n
      cx, cy, r, a = config.scene_width/2, @pos.y, 1, a + da
      CircleBullet{
        center_pos: Vector(cx, cy)
        r_spawn: r
        pos: Vector(cx, cy) + vector.fromPolar(a, r)
        speed: 80
        --r_vector: vector.fromPolar(a, r)
        -- dir: Vector(math.random! - 0.5, math.random!)\normalized!
        char: "*"
        type: "evil"
      }

  shoot: =>
    @bullet1 @pos.x, @pos.y + 20

  draw: =>
    super\draw!
    lovelog.print "Boss's hp: " .. @hp
