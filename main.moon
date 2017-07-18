StateManager = require "lib.StateManager"
lovelog = require "lib.lovelog"
-- require "lib.lovedebug"

love.load = ->
  math.randomseed os.time!
  if arg[#arg] == "-debug"
     require("mobdebug").start!
  love.graphics.setFont love.graphics.newFont "fonts/NotoSansCJK-Regular.ttc", 10
  StateManager.switch "Stage1"
  -- StateManager.load "Stage1", 2

love.keypressed = (kid) ->
  if kid == "f1"
    lovelog.toggle!
