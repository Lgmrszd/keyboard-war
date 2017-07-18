colorize = require "lib.colorize"
config = require "config"
import graphics from love

class StatsPanel
  canvas = love.graphics.newCanvas 200, love.graphics.getHeight!
  draw: =>
    love.graphics.setCanvas canvas
    colorize {20, 0, 20}, -> graphics.rectangle "fill", 0, 0, canvas\getWidth!, canvas\getHeight!
    graphics.printf "WHAT", 10, 10, 100
    graphics.setCanvas!
    graphics.draw canvas, config.scene_width, 0

  update: (dt) =>
