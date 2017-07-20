StateManager = require "lib.StateManager"
Matrix = require "states.Matrix"
colorize = require "lib.colorize"
config = require "config"

menu = {
  { id: "play", text: "Play", action: -> StateManager.switch "TestStage1"}
  { id: "settings", text: "Settings", action: -> error "TODO" }
  { id: "exit", text: "Exit", action: -> love.event.quit(0)}
}

LCS = require "LuaCanSound"
class Synth
  sine = LCS.generators.Triangle\new()
  env = LCS.envelopes.ASR\new()
  with env
    \set{attack_seconds: 0.01}
    \set{sustain_seconds: 0.05}
    \set{decay_seconds: 0.01}

  play: (arg) =>
    sine\start arg.freq
    env\start!
    length = LCS.settings.sampleRate * arg.length
    sample = love.sound.newSoundData(length, LCS.settings.sampleRate, 16, 1)
    for i = 0, length-1
      sample\setSample i, sine\tick!*env\tick!*0.1
    love.audio.play love.audio.newSource sample


class MainMenu
  synth: Synth!
  menu: menu
  active_node: 1
  matrix: Matrix!

  enter: =>

  keypressed: (key_id) =>
    if key_id == "down"
      @synth\play {freq:700, length:0.07}
      @active_node += 1
      if @active_node > #@menu
        @active_node = 1
    elseif key_id == "up"
      @synth\play {freq:700*2^(2/12), length:0.07}
      @active_node -= 1
      if @active_node == 0
        @active_node = #@menu
    elseif key_id == "shoot"
      @synth\play {freq:700*4^(2/12), length:0.07}
      @menu[@active_node].action!

  update: (dt) =>
    love.graphics.setFont config.fonts.menu
    @matrix\update dt

  draw: () =>
    @matrix\draw!
    x, y = 30, 30
    for i = 1, #@menu
      -- love.graphics.getFont()
      love.graphics.setNewFont 20
      -- love.graphics.printf(text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky)
      colorize (i == @active_node) and {100, 255, 100} or {100, 100, 100}, ->
        love.graphics.printf @menu[i].text, x, y, 300
      y += 30
