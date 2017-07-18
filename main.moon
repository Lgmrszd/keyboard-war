StateManager = require "lib.StateManager"
Controller = require "lib.Controller"
lovelog = require "lib.lovelog"
config = require "config"

love.load = ->
  math.randomseed os.time!
  if arg[#arg] == "-debug"
     require("mobdebug").start!
  StateManager.switch "MainMenu"
  -- love.window.setFullscreen(true)
  love.window.setMode config.scene_width + config.panel_width, config.scene_height
  -- love.graphics.setPointSize(2)
  -- StateManager.load "Stage1", 2

love.keypressed = (kid) ->
  if kid == "f1"
    lovelog.toggle!
  state = StateManager.getState!
  if state.keypressed
    state\keypressed(Controller.getActionByKey kid)
