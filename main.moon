StateManager = require "lib.StateManager"
SceneManager = require "lib.SceneManager"
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

love.keypressed = (key_id) ->
  if key_id == "f1"
    lovelog.toggle!
  key_id = Controller.getActionByKey key_id
  SceneManager\keypressed key_id

love.keyreleased = (key_id) ->
  key_id = Controller.getActionByKey key_id
  SceneManager\keyreleased key_id

love.draw = ->
  if not config.settings.graphics
    return
  scene = StateManager\getState!
  if scene
    scene\draw!
