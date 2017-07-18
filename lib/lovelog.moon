yoffset = 0
local disabled

disable = ->
  disabled = true

enable = ->
  disabled = false

toggle = ->
  disabled = not disabled

reset = ->
  yoffset = 0

print = (text) ->
  if disabled
    return
  love.graphics.print text, 0, yoffset
  yoffset += 15

{
  :reset,
  :print,
  :disable,
  :enable,
  :toggle,
}
