colorize = require "lib.colorize"
signal = require "hump.signal"
config = require "config"
import graphics from love

class HPBar
  percentage = 100
  shift = 100
  update_percentage: (max_hp, hp) =>
    -- print "TEST", max_hp, hp
    percentage = hp*100/max_hp
  draw: =>
    -- love.graphics.getHeight!
    total_width = config.scene_width-shift*2
    hp_width = total_width*percentage/100
    -- print percentage
    colorize {122, 0, 0}, -> graphics.rectangle "fill", shift, 10, total_width, 10
    colorize {200, 0, 0}, -> graphics.rectangle "fill", shift, 10, hp_width, 10
    colorize {255, 0, 0}, -> graphics.rectangle "line", shift, 10, total_width, 10
  signal.register "boss_hp", (...) -> @update_percentage(...)

  update: =>
