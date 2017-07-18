lovelog = require "lib.lovelog"
vector = require "hump.vector"
colorize = require "lib.colorize"
signal = require "hump.signal"
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

    BulletManager\addBullet @


  update: (dt) =>
    @pos += @speed * dt * @dir
    @hitbox\moveTo @pos.x, @pos.y
    if @pos.y < 0 or @pos.y > love.graphics.getHeight!
      @remove!

  draw: =>
    colorize {20, 20, 200}, -> graphics.circle "fill", @pos.x, @pos.y, @rad
    graphics.printf @char, @pos.x - @rad, @pos.y - @rad, 2 * @rad, "center"

  remove: =>
    HC\remove @hitbox
    BulletManager\removeBullet @

{
  :Bullet,
  :BulletManager
}
