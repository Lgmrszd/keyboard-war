import Bullet from require "lib.Bullet"
Vector = require "hump.vector"
Basechar = require "lib.Basechar"

class Enemy extends Basechar
  new: (pos) =>
    @pos = pos or @pos

  update: (dt) =>
    -- super\update dt
    if math.random! > 0.99
      @shoot!

  shoot: =>
    Bullet{
      pos: @pos - Vector(0, 20)
      speed: math.random(1, 100)
      dir: Vector(math.random!*2 - 1, math.random!)\normalized!
      char: "9"
    }
