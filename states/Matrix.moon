colorize = require "lib.colorize"
config = require "config"

class Matrix
  update_time: 0.03
  cur_time: 0
  matrix: {}
  cols: 370
  rows: 40
  overall_time: 0
  letters: { "a", "z", "0", "A", "?", "!"}

  randletter: =>
    return @letters[math.random(1, #@letters)]

  newrow: (row) =>
    ret = {}
    if not row
      for i = 1, @cols
        ret[i] = (math.random! > 0.999) and @randletter() or " "
    else
      for i = 1, @cols
        if row[i] ~= " "
          ret[i] = (math.random! > 0.3) and @randletter() or " "
        else
          ret[i] = (math.random! > 0.99) and @randletter() or " "

    return ret

  update: (dt) =>
    love.graphics.setFont config.fonts.art
    @overall_time += dt
    -- if @overall_time > 2
    --   @stop!
    @cur_time += dt
    if @cur_time < @update_time
      return
    @cur_time = @cur_time - @update_time
    if #@matrix == @rows
      table.remove @matrix, @rows
    if not @stopped
      table.insert @matrix, 1, @\newrow @matrix[1]
    else
      table.insert @matrix, 1, {}

  draw: =>
    yoffset = 0
    colorize {0, 0, 0, @alpha}, -> love.graphics.rectangle "fill", 0, 0, love.graphics.getWidth!, love.graphics.getHeight!
    for _, row in ipairs(@matrix)
      colorize {10, 200, 10, @alpha}, -> love.graphics.print table.concat(row), 0, yoffset
      yoffset += 15

  setAlpha: (alpha) =>
    @alpha = alpha

  stop: =>
    @stopped = true

  start: =>
    @stopped = false
