colorize = require "lib.colorize"
config = require "config"
import graphics from love

class HPBar
  shift = 20
  draw: =>
    -- love.graphics.getHeight!
    colorize {255, 0, 0}, -> graphics.rectangle "fill", shift, 10, config.scene_width-shift*2, 10
  update: =>
