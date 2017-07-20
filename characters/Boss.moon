vector = require "hump.vector"
signal = require "hump.signal"
lovelog = require "lib.lovelog"
config = require "config"
import Bullet, CircleBullet from require "lib.Bullet"
import Mode from require "lib.Modes"
import graphics, keyboard from love
Vector = require "hump.vector"
Basechar = require "lib.Basechar"
HPBar = require "UI.HPBar"
HC = require "HCWorld"

death = Mode{
  id: "death"
  init_func: () =>
    signal.emit("Stage1_end")

  update_func: (dt, tt) =>
    signal.emit("Stage1_end")

}
appear = Mode {
  id: "appear"
  init_func: () =>
    @diff_pos = @spawn_pos - @income_pos
  update_func: (dt, tt) =>
    if tt < 1
      @pos = @income_pos - tt*tt*@diff_pos + tt*2*@diff_pos
    else
      @pos = @spawn_pos
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
    @diff_pos = vector(cx, @pos.y) - @pos
    @income_pos = @pos

  update_func: (dt, tt) =>
    if tt < 1
      cx = config.scene_width/2
      -- print "pos.x", pos.x, "cx", cx, "next mode", @next_mode
      @direction = (@pos.x > cx) and "left" or "right"
      @text = @texts[@direction]
      @pos = @income_pos - tt*tt*@diff_pos + tt*2*@diff_pos
    else
      @pos = vector(config.scene_width/2, @pos.y)
      @circle_bullets_dt += dt
      if @circle_bullets_dt >= 0.15
        @circle_bullets_dt = 0
        @spawnCircleBullets{
          n: 20
          da: @circle_bullets_da
          aspeed: 0
          color: {0, 0, 255}
        }
        @spawnCircleBullets{
          n: 5
          da: -@circle_bullets_da * 1.5
          aspeed: -40
          color: {255, 255, 0}
          rad: 5
        }
        @circle_bullets_da += 1
    if tt > 5
      @mode = "walk"

}
boss_modes = {
  "walk": walk
  "rage": rage
  "appear": appear
  "death": death
  "MAIN": "appear"
}

class Enemy extends Basechar
  new: (args) =>
    @pos = args.income_pos
    @income_pos = args.income_pos
    @spawn_pos = args.pos
    @hitbox_radius = 10
    @width = 70
    @height = 15
    hw, hh = @width/2, @height/2
    @hitbox = HC\polygon @pos.x - hw, @pos.y - hh,
                         @pos.x + hw, @pos.y - hh,
                         @pos.x + hw, @pos.y + hh,
                         @pos.x - hw, @pos.y + hh
    -- @hitbox = HC\circle args.income_pos.x, args.income_pos.y, @hitbox_radius
    @max_hp = 400
    @hp = @max_hp
    @texts = {
      right: "(凸ಠ益ಠ)凸"
      left: "凸(ಠ益ಠ凸)"
    }
    @direction = "right"
    @mode = boss_modes["MAIN"]
    @pmode = "nil"
    @text = [[(凸ಠ益ಠ)凸]]
    @speed = 100
    @rage_speed = 300
    @modes = boss_modes

  update: (dt) =>
    HPBar\update dt
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

  spawnCircleBullets: (args) =>
    for i = 0, args.n-1
      a = i*(math.pi*2)/args.n
      cx, cy, r, a = config.scene_width/2, @pos.y, 1, a + args.da
      CircleBullet{
        center_pos: Vector(cx, cy)
        r_spawn: r
        pos: Vector(cx, cy) + vector.fromPolar(a, r)
        speed: 80
        angle_speed: args.aspeed
        color: args.color
        char: "*"
        type: "evil"
        rad: args.rad
      }

  shoot: =>
    @bullet1 @pos.x, @pos.y + 20

  draw: =>
    super\draw!
    HPBar\draw!
    lovelog.print "Boss's hp: " .. @hp
