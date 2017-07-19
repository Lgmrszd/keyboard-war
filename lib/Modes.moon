lovelog = require "lib.lovelog"
vector = require "hump.vector"
colorize = require "lib.colorize"
signal = require "hump.signal"
config = require "config"
HC = require "HCWorld"
import graphics from love

class Mode
  new: (args) =>
    @id = args.id
    @update_func = args.update_func
    @init_func = args.init_func
    @finished = false
    @total_time = 0

  update: (boss, dt) =>
    @total_time += dt
    @.update_func(boss, dt, @total_time)

  init: (boss) =>
    @total_time = 0
    @.init_func(boss)

{
  :Mode
}
