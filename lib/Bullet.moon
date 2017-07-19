lovelog = require "lib.lovelog"
vector = require "hump.vector"
colorize = require "lib.colorize"
signal = require "hump.signal"
config = require "config"
HC = require "HCWorld"
import graphics from love

BulletManager =
  size: 0
  last: 0
  bullets: {}
  addBullet: (b) =>
    @size += 1
    @bullets[b] = true

  removeBullet: (b) =>
    @bullets[b] = nil
    @size -= 1

  update: (dt) =>
    for b, _ in pairs @bullets
      b\update dt

  draw: () =>
    lovelog.print "Bullet count: " .. @size
    for b, _ in pairs @bullets
      b\draw!

  removeAllBullets: =>
    for b, _ in pairs(@bullets)
      b\remove!

signal.register "player_meets_bullet", ->
  BulletManager\removeAllBullets!

class Bullet
  new: (args) =>
    @pos = args.pos
    @rad = args.rad or 3
    @speed = args.speed or 0
    @dir = args.dir or vector(0, 0)
    @char = args.char or "*"
    @hitbox = HC\circle(@pos.x, @pos.y, @rad)
    @hitbox.type = args.type or "evil"

    BulletManager\addBullet @


  update: (dt) =>
    @pos += @speed * dt * @dir
    @hitbox\moveTo @pos.x, @pos.y
    if @pos.y < 0 or @pos.y > love.graphics.getHeight! or @pos.x < 0 or @pos.x > config.scene_width
      @remove!

  draw: =>
    colorize {20, 20, 200}, -> graphics.circle "fill", @pos.x, @pos.y, @rad
    -- graphics.printf s@char, @pos.x - @rad, @pos.y - @rad, 2 * @rad, "center"

  remove: =>
    HC\remove @hitbox
    BulletManager\removeBullet @


class CircleBullet extends Bullet
  new: (args) =>
    super\__init(args)
    @center_pos = args.center_pos
    @r_vector = args.r_vector
    @anglespeed = args.anglespeed or 1
    @r_spawn = args.r_spawn
    @ac = args.ac or 2

  update: (dt) =>
    print "radius ", (@r_spawn / @r_vector\toPolar!["y"])
    @r_vector = @r_vector\rotated((@r_spawn / @r_vector\toPolar!["y"]) * @anglespeed * dt)
    @angle = @r_vector\toPolar!["x"]
    @r_vector += @r_vector\normalized! * @speed * dt
    @speed += @ac
    @pos = @center_pos + @r_vector
    @hitbox\moveTo @pos.x, @pos.y
    scene_corner = vector(0, config.scene_height)
    dr = scene_corner - @center_pos
    if dr\toPolar!["y"] < @r_vector\toPolar!["y"]
      @remove!
{
  :CircleBullet,
  :Bullet,
  :BulletManager
}
