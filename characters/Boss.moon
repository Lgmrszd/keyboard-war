import Bullet from require "lib.Bullet"
Vector = require "hump.vector"
Basechar = require "lib.Basechar"
HC = require "HCWorld"

class Enemy extends Basechar
  new: (pos) =>
    @hitbox_radius = 10
    @hitbox = HC\circle @pos.x, @pos.y, @hitbox_radius
    @pos = pos or @pos
    @texts = {
      right: "(凸ಠ益ಠ)凸"
      left: "凸(ಠ益ಠ凸)"
    }
    @mode = "right"
    @text = [[(凸ಠ益ಠ)凸]]
    @width = 100

  update: (dt) =>
    -- super\update dt
    if math.random! > 0.99
      @mode = (@mode == "right") and "left" or "right"
      @text = @texts[@mode]
    if math.random! > 0.6
      @shoot!
    @hitbox\moveTo @pos.x, @pos.y

  shoot: =>
    Bullet{
      pos: @pos - Vector(0, 20)
      speed: math.random(30, 200)
      dir: Vector(math.random! - 0.5, math.random!)\normalized!
      char: "9"
    }
