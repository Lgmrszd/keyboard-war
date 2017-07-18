vector = require "hump.vector"
signal = require "hump.signal"
lovelog = require "lib.lovelog"
colorize = require "lib.colorize"
import Bullet from require "lib.Bullet"
import graphics, keyboard from love
Basechar = require "lib.Basechar"
HC = require "HCWorld"

class player extends Basechar
  -- text: "(･θ･)"
  text: "(=^･ω･^=)"
  width: 70
  speed: 300
  slowspeed: 100
  health: 3 -- lives

  draw: =>
    super\draw!
    if @draw_hitbox
      colorize {255, 0, 0}, -> love.graphics.circle "fill", @pos.x, @pos.y, @hitbox_radius
    lovelog.print "Player hitbox rad: " .. @hitbox_radius

  update: (dt) =>
    vec = vector 0
    if keyboard.isDown "left" then
      vec.x = -1
    elseif keyboard.isDown "right" then
      vec.x = 1

    if keyboard.isDown "down" then
      vec.y = 1
    elseif keyboard.isDown "up" then
      vec.y = -1

    if keyboard.isDown "z" then
      @shoot!

    local speed
    if keyboard.isDown("lshift")
      speed = @slowspeed
      @draw_hitbox = true
    else
      speed = @speed
      @draw_hitbox = false

    @pos = @pos + dt * speed * vec\normalized!
    if @pos.x < 0
      @pos.x = 0
    elseif @pos.x > graphics.getWidth!-200
      @pos.x = graphics.getWidth!-200
    if @pos.y > graphics.getHeight!
      @pos.y = graphics.getHeight!
    elseif @pos.y < 0
      @pos.y = 0
    @hitbox\moveTo @pos.x, @pos.y

    if next(HC\collisions(@hitbox))
      signal.emit "player_meets_bullet"



  shoot: =>
    dist = 20
    if keyboard.isDown("lshift")
      dist = 10
    Bullet{
      pos: @pos + vector(-dist, -10),
      speed: 2000,
      dir: vector 0, -1
    }
    Bullet{
      pos: @pos + vector(dist, -10),
      speed: 2000,
      dir: vector 0, -1
    }
