import Bullet from require "lib.Bullet"
Vector = require "hump.vector"
Basechar = require "lib.Basechar"
signal = require "hump.signal"
HC = require "HCWorld"

class Enemy extends Basechar
  new: (arg) =>
    for k, v in pairs arg
      @[k] = v
    @height = @height or 15
    @width = @width or 30
    hw, hh = @width/2, @height/2
    @hitbox = HC\polygon @pos.x - hw, @pos.y - hh,
                         @pos.x + hw, @pos.y - hh,
                         @pos.x + hw, @pos.y + hh,
                         @pos.x - hw, @pos.y + hh,

  update: (dt) =>
    -- super\update dt
    if @move
      @move dt
    @hitbox\moveTo @pos.x, @pos.y
    if @shoot
      @shoot dt
    if next(HC\collisions(@hitbox))
      for k, v in pairs HC\collisions(@hitbox)
        if k.type == "good"
          -- error @hitbox
          signal.emit "dead", @
