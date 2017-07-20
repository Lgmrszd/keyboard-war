Vector = require "hump.vector"
HC = require "HCWorld"
colorize = require "lib.colorize"
config = require "config"

class Enemy
  pos: Vector(0, 0)
  width: 35
  height: 15
  text: "x_x"
  hitbox_radius: 3
  color: {50, 150, 50}

  new: =>
    @hitbox = HC\circle @pos.x, @pos.y, @hitbox_radius

  setText: (t) =>
    @text = t

  setPos: (x, y) =>
    @pos = Vector(x, y)

  draw: =>
    if config.debug
      @hitbox\draw!
    topleft = @pos - Vector(@width, 20) / 2
    colorize @color, -> love.graphics.printf @text, topleft.x, topleft.y, @width, "center"
