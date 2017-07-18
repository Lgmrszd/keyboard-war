local yoffset = 0
local disabled
local disable
disable = function()
  disabled = true
end
local enable
enable = function()
  disabled = false
end
local toggle
toggle = function()
  disabled = not disabled
end
local reset
reset = function()
  yoffset = 0
end
local print
print = function(text)
  if disabled then
    return 
  end
  love.graphics.print(text, 0, yoffset)
  yoffset = yoffset + 15
end
return {
  reset = reset,
  print = print,
  disable = disable,
  enable = enable,
  toggle = toggle
}
