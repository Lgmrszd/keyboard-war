local colorize = require("lib.colorize")
local config = require("config")
local signal = require("hump.signal")
local graphics
graphics = love.graphics
local drawline
drawline = function(num)
  local arr
  do
    local _accum_0 = { }
    local _len_0 = 1
    for i = 1, num do
      _accum_0[_len_0] = "*"
      _len_0 = _len_0 + 1
    end
    arr = _accum_0
  end
  return table.concat(arr, " ")
end
local StatsPanel = {
  canvas = love.graphics.newCanvas(config.panel_width, config.scene_height),
  lives = 3,
  bombs = 3,
  draw = function(self)
    love.graphics.setFont(config.fonts.art_big)
    love.graphics.setCanvas(self.canvas)
    colorize({
      20,
      0,
      20
    }, function()
      return graphics.rectangle("fill", 0, 0, self.canvas:getWidth(), self.canvas:getHeight())
    end)
    graphics.printf("Lives: " .. drawline(self.lives), 10, 10, 200)
    graphics.printf("Bombs: " .. drawline(self.bombs), 10, 30, 200)
    graphics.setCanvas()
    return graphics.draw(self.canvas, config.scene_width, 0)
  end,
  update = function(self, dt) end
}
signal.register("bomb_exploded", function(arg)
  StatsPanel.bombs = arg.bombs
end)
signal.register("player_meets_bullet", function(arg)
  StatsPanel.lives = arg.lives
  StatsPanel.bombs = arg.bombs
end)
return StatsPanel
