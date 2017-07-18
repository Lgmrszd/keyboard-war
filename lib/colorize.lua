return function(color, f)
  local old_color = {love.graphics.getColor()}
  love.graphics.setColor(color)
  f()
  love.graphics.setColor(unpack(old_color))
end
