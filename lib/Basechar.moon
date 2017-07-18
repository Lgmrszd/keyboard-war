Vector = require "hump.vector"
HC = require "HCWorld"
colorize = require "lib.colorize"
config = require "config"

class Enemy
  pos: Vector(0, 0)
  width: 50
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
    topleft = @pos - Vector(@width, 20) / 2
    if config.debug
      colorize {30, 30, 30}, -> love.graphics.rectangle "fill", topleft.x, topleft.y, @width, 20
      colorize {255, 0, 0}, -> love.graphics.circle "fill", @pos.x, @pos.y, @hitbox_radius
    colorize @color, -> love.graphics.printf @text, topleft.x, topleft.y, @width, "center"
