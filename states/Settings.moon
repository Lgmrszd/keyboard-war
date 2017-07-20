config = require "config"
import settings from config
StateManager = require "lib.StateManager"
colorize = require "lib.colorize"

menu = {
  {
    id: "gfx"
    keypressed: (key) =>
      settings.graphics = not settings.graphics
    getText: =>
      return "Graphics: " .. (settings.graphics and "on" or "off")
  }
  {
    id: "back"
    text: "Back"
    keypressed: (key) =>
      if key == "shoot"
        StateManager.switch "MainMenu"
  }
}

class Settings
  menu: menu
  active_node: 1
  draw: =>
    love.graphics.setFont config.fonts.menu
    x, y = 30, 30
    for i, v in ipairs menu
      colorize (i == @active_node) and {100, 255, 100} or {100, 100, 100}, ->
        love.graphics.printf(v.text or v\getText!, x, y, 300)
      y += 30

  keypressed: (key) =>
    if key == "down"
      @active_node += 1
      if @active_node > #@menu
        @active_node = 1
    elseif key == "up"
      @active_node -= 1
      if @active_node == 0
        @active_node = #@menu
    elseif @menu[@active_node].keypressed
      @menu[@active_node]\keypressed key
