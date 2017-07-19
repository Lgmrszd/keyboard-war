local colorize = require("lib.colorize")
local config = require("config")
local signal = require("hump.signal")
local graphics
graphics = love.graphics
local StatsPanel = {
  canvas = love.graphics.newCanvas(config.panel_width, config.scene_height),
  lives = 3,
  bombs = 3,
  draw = function(self)
    love.graphics.setCanvas(self.canvas)
    colorize({
      20,
      0,
      20
    }, function()
      return graphics.rectangle("fill", 0, 0, self.canvas:getWidth(), self.canvas:getHeight())
    end)
    graphics.printf("Lives: " .. self.lives, 10, 10, 100)
    graphics.printf("Bombs: " .. self.bombs, 10, 30, 100)
    graphics.setCanvas()
    return graphics.draw(self.canvas, config.scene_width, 0)
  end,
  update = function(self, dt) end
}
signal.register("bomb_count_changed", function(count)
  StatsPanel.bombs = count
end)
signal.register("player_meets_bullet", function(arg)
  StatsPanel.lives = arg.lives
end)
return StatsPanel
