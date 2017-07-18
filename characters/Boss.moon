vector = require "hump.vector"
lovelog = require "lib.lovelog"
import Bullet from require "lib.Bullet"
import graphics, keyboard from love
Vector = require "hump.vector"
Basechar = require "lib.Basechar"
HC = require "HCWorld"
MaxHp = 200

class Enemy extends Basechar
  new: (pos) =>
    @hitbox_radius = 10
    @hitbox = HC\circle @pos.x, @pos.y, @hitbox_radius
    @pos = pos or @pos
    @hp = MaxHp
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
    elseif @pos.x > graphics.getWidth!-200
      @pos.x = graphics.getWidth!-200
      @mode = 'left'

    @hitbox\moveTo @pos.x, @pos.y

  shoot: =>
    Bullet{
      pos: @pos - Vector(0, 20)
      speed: math.random(30, 200)
      dir: Vector(math.random! - 0.5, math.random!)\normalized!
      char: "9"
    }
  draw: =>
    super\draw!
    lovelog.print "HOLY SHIT THAT'S DEBUG"
