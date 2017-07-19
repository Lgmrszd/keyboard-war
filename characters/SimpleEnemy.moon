import Bullet from require "lib.Bullet"
Vector = require "hump.vector"
Basechar = require "lib.Basechar"
signal = require "hump.signal"
HC = require "HCWorld"

class Enemy extends Basechar
  new: (pos) =>
    @pos = pos or @pos
    @height = 15
    @width = 30
    hw, hh = @width/2, @height/2
    @hitbox = HC\polygon @pos.x - hw, @pos.y - hh,
                         @pos.x + hw, @pos.y - hh,
                         @pos.x + hw, @pos.y + hh,
                         @pos.x - hw, @pos.y + hh,

  update: (dt) =>
    -- super\update dt
    if math.random! > 0.99
      @shoot!
    if next(HC\collisions(@hitbox))
      for k, v in pairs HC\collisions(@hitbox)
        if k.type == "good"
          -- error @hitbox
          signal.emit "dead", @

  shoot: =>
    Bullet{
      pos: @pos - Vector(0, 20)
      speed: math.random(1, 100)
      dir: Vector(math.random!*2 - 1, math.random!)\normalized!
      char: "*"
    }
