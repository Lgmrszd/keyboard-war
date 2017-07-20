-- lovelog = require "lib.lovelog"
-- vector = require "hump.vector"
-- colorize = require "lib.colorize"
-- signal = require "hump.signal"
--config = require "config"
HC = require "HCWorld"

class Bullet
  new: (args) =>
    @pos = args.pos
    @rad = 30
    @char = args.char or "*"
    @hitbox = HC\circle(@pos.x, @pos.y, @rad)

  update: (dt) =>

  draw: (dt) =>

  {
    :Bullet
  }
