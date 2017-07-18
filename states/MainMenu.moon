StateManager = require "lib.StateManager"
colorize = require "lib.colorize"
config = require "config"

menu = {
  { id: "play", text: "Play", action: -> StateManager.switch "Stage1"}
  { id: "settings", text: "Settings", action: -> error "TODO" }
  { id: "exit", text: "Exit", action: -> love.event.quit(0)}
}

class MainMenu
  menu: menu
  active_node: 1

  enter: =>
    love.graphics.setFont config.fonts.menu

  keypressed: (key_id) =>
    if key_id == "down"
      @active_node += 1
      if @active_node > #@menu
        @active_node = 1
    elseif key_id == "up"
      @active_node -= 1
      if @active_node == 0
        @active_node = #@menu
    elseif key_id == "shoot"
      @menu[@active_node].action!

  update: (dt) =>
    -- error "wtf"

  draw: () =>
    x, y = 10, 10
    for i = 1, #@menu
      -- love.graphics.getFont()
      love.graphics.setNewFont 20
      -- love.graphics.printf(text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky)
      colorize (i == @active_node) and {200, 250, 200} or {200, 200, 200}, ->
        love.graphics.printf @menu[i].text, x, y, 300
      y += 30
