Vector = require "hump.vector"
signal = require "hump.signal"
lovelog = require "lib.lovelog"
colorize = require "lib.colorize"
config = require "config"
import Bullet, BulletManager from require "lib.Bullet"
import graphics from love
Controller = require "lib.Controller"
Basechar = require "lib.Basechar"
HC = require "HCWorld"
StateManager = require "lib.StateManager"

class Player extends Basechar
  initial_bomb_count = 3
  keys_locked = true
  text: "(=^･ω･^=)"
  width: 70
  speed: 300
  slowspeed: 100
  lives: 3 -- lives
  bombs: 3

  draw: =>
    super\draw!
    if @draw_hitbox
      colorize {255, 0, 0}, -> love.graphics.circle "fill", @pos.x, @pos.y, @hitbox_radius
    lovelog.print "Player hitbox rad: " .. @hitbox_radius
    lovelog.print "Player lives: " .. @lives
    lovelog.print "Player x: " .. @pos.x

  update: (dt) =>
    if keys_locked
      return
    vec = Vector 0
    if Controller.pressed "left" then
      vec.x = -1
    elseif Controller.pressed "right" then
      vec.x = 1

    if Controller.pressed "down" then
      vec.y = 1
    elseif Controller.pressed "up" then
      vec.y = -1

    if Controller.pressed "shoot" then
      @shoot!

    local speed
    if Controller.pressed "slowdown"
      speed = @slowspeed
      @draw_hitbox = true
    else
      speed = @speed
      @draw_hitbox = false

    @pos = @pos + dt * speed * vec\normalized!
    if @pos.x < 0
      @pos.x = 0
    elseif @pos.x > config.scene_width
      @pos.x = config.scene_width
    if @pos.y > graphics.getHeight!
      @pos.y = graphics.getHeight!
    elseif @pos.y < 0
      @pos.y = 0
    @hitbox\moveTo @pos.x, @pos.y

    if next(HC\collisions(@hitbox))
      for k, v in pairs HC\collisions(@hitbox)
        if k.type == "evil"
          @lives -= 1
          @bombs = initial_bomb_count
          signal.emit("player_meets_bullet", {lives: @lives, bombs: @bombs})
          if @lives == 0 -- TODO move this somewhere else
            StateManager.switch "GameOver"
            SceneManager = require "lib.SceneManager"
            SceneManager\clear!
          return

  shoot: =>
    dist = 20
    if Controller.pressed "slowdown"
      dist = 10
    Bullet{
      pos: @pos + Vector(-dist, -10),
      speed: 1500,
      dir: Vector 0, -1
      type: "good"
    }
    Bullet{
      pos: @pos + Vector(dist, -10),
      speed: 1500,
      dir: Vector 0, -1
      type: "good"
    }

  explodeBomb: =>
    BulletManager\removeAllBullets!

  keyreleased: (key) =>
    keys_locked = false

  keypressed: (key) =>
    if Controller.getActionByKey(key) == "bomb" then
      if @bombs > 0
        @explodeBomb!
        @bombs -= 1
        signal.emit "bomb_exploded", {bombs: @bombs}
