local colorize = require("lib.colorize")
local Matrix
do
  local _class_0
  local _base_0 = {
    update_time = 0.03,
    cur_time = 0,
    matrix = { },
    cols = 250,
    rows = 40,
    overall_time = 0,
    letters = {
      "a",
      "z",
      "0",
      "A",
      "?",
      "!"
    },
    randletter = function(self)
      return self.letters[math.random(1, #self.letters)]
    end,
    newrow = function(self, row)
      local ret = { }
      if not row then
        for i = 1, self.cols do
          ret[i] = (math.random() > 0.999) and self:randletter() or " "
        end
      else
        for i = 1, self.cols do
          if row[i] ~= " " then
            ret[i] = (math.random() > 0.3) and self:randletter() or " "
          else
            ret[i] = (math.random() > 0.99) and self:randletter() or " "
          end
        end
      end
      return ret
    end,
    update = function(self, dt)
      self.overall_time = self.overall_time + dt
      if self.overall_time > 2 then
        self:stop()
      end
      self.cur_time = self.cur_time + dt
      if self.cur_time < self.update_time then
        return 
      end
      self.cur_time = self.cur_time - self.update_time
      if #self.matrix == self.rows then
        table.remove(self.matrix, self.rows)
      end
      if not self.stopped then
        return table.insert(self.matrix, 1, self:newrow(self.matrix[1]))
      else
        return table.insert(self.matrix, 1, { })
      end
    end,
    draw = function(self)
      local yoffset = 0
      colorize({
        0,
        0,
        0,
        self.alpha
      }, function()
        return love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
      end)
      for _, row in ipairs(self.matrix) do
        colorize({
          10,
          200,
          10,
          self.alpha
        }, function()
          return love.graphics.print(table.concat(row), 0, yoffset)
        end)
        yoffset = yoffset + 15
      end
    end,
    setAlpha = function(self, alpha)
      self.alpha = alpha
    end,
    stop = function(self)
      self.stopped = true
    end,
    start = function(self)
      self.stopped = false
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "Matrix"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Matrix = _class_0
  return _class_0
end
