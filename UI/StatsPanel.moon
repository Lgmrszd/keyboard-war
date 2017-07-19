colorize = require "lib.colorize"
config = require "config"
signal = require "hump.signal"
import graphics from love

StatsPanel =
  canvas: love.graphics.newCanvas config.panel_width, config.scene_height
  lives: 3
  bombs: 3

  draw: =>
    love.graphics.setCanvas @canvas
    colorize {20, 0, 20}, -> graphics.rectangle "fill", 0, 0, @canvas\getWidth!, @canvas\getHeight!
    graphics.printf "Lives: " .. @lives, 10, 10, 100
    graphics.printf "Bombs: " .. @bombs, 10, 30, 100
    graphics.setCanvas!
    graphics.draw @canvas, config.scene_width, 0

  update: (dt) =>

signal.register "bomb_exploded", (arg) ->
  StatsPanel.bombs = arg.bombs

signal.register "player_meets_bullet", (arg) ->
  StatsPanel.lives = arg.lives
  StatsPanel.bombs = arg.bombs

return StatsPanel
