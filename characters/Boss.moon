vector = require "hump.vector"
signal = require "hump.signal"
lovelog = require "lib.lovelog"
config = require "config"
import Bullet from require "lib.Bullet"
import graphics, keyboard from love
Vector = require "hump.vector"
Basechar = require "lib.Basechar"
HC = require "HCWorld"

class Enemy extends Basechar
  new: (pos) =>
    @hitbox_radius = 10
    @hitbox = HC\circle @pos.x, @pos.y, @hitbox_radius
    @pos = pos or @pos
    @max_hp = 100
    @hp = @max_hp
    @texts = {
      right: "(凸ಠ益ಠ)凸"
      left: "凸(ಠ益ಠ凸)"
    }
    @mode = "right"
    @text = [[(凸ಠ益ಠ)凸]]
    @width = 100
    @speed = 100

  update: (dt) =>
    -- super\update dt
    vec = vector 0
    if math.random! > 0.99
      @mode = (@mode == "right") and "left" or "right"
      @text = @texts[@mode]
    if math.random! > 0.6
      @shoot!
    if @mode == "left" then
      vec.x = -1
    else
      vec.x = 1
    @pos = @pos + dt * @speed * vec\normalized!
    if @pos.x < 0
      @pos.x = 0
      @mode = 'right'
    elseif @pos.x > config.scene_width
      @pos.x = config.scene_width
      @mode = 'left'
    if next(HC\collisions(@hitbox))
      for k, v in pairs HC\collisions(@hitbox)
        if k.type == "good"
          @hp -= 1
          signal.emit("boss_hp", @max_hp, @hp)
    @hitbox\moveTo @pos.x, @pos.y

  shoot: =>
    Bullet{
      pos: @pos - Vector(0, 20)
      speed: math.random(30, 200)
      dir: Vector(math.random! - 0.5, math.random!)\normalized!
      char: "9"
      type: "evil"
    }
  draw: =>
    super\draw!
    lovelog.print "Boss's hp: " .. @hp
