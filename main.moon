StateManager = require "lib.StateManager"
Controller = require "lib.Controller"
lovelog = require "lib.lovelog"
-- require "lib.lovedebug"

love.load = ->
  math.randomseed os.time!
  if arg[#arg] == "-debug"
     require("mobdebug").start!
  StateManager.switch "MainMenu"
  -- StateManager.load "Stage1", 2

love.keypressed = (kid) ->
  if kid == "f1"
    lovelog.toggle!
  state = StateManager.getState!
  if state.keypressed
    state\keypressed(Controller.getActionByKey kid)
