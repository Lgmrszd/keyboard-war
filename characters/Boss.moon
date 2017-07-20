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

death = Mode{
  id: "walk"
  init_func: () =>
    signal.emit("Stage1_end")
    signal.emit("boss_disappears")

  update_func: (dt, tt) =>
    signal.emit("Stage1_end")

}
appear = Mode {
  id: "appear"
  init_func: () =>
    signal.emit("boss_appears")
  update_func: (dt, tt) =>
    @mode = "walk"

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
  "appear": appear
  "MAIN": "appear"
}

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
    @mode = boss_modes["MAIN"]
    @pmode = "nil"
    @text = [[(凸ಠ益ಠ)凸]]
    @width = 100
    @speed = 100
    @rage_speed = 300
    @modes = boss_modes


  circleBulletsTimer: =>
    if @circle_bullets_dt >= 0.15
      @circle_bullets_dt = 0
      @spawnCircleBullets(20, @circle_bullets_da)
      @circle_bullets_da += 1

  update: (dt) =>
    -- @modes[@mode](@,dt)
    if @mode ~= @pmode
      @modes[@mode]\init(@)
      @pmode = @mode
    @modes[@mode]\update(@,dt)
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
        char: "*"
        type: "evil"
      }

  shoot: =>
    @bullet1 @pos.x, @pos.y + 20

  draw: =>
    super\draw!
    lovelog.print "Boss's hp: " .. @hp
