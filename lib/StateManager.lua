local gamestate = require("hump.gamestate")
local Matrix = require("states.Matrix")
local switcher
local States = { }
local previousState, currentState
local getState
getState = function(id)
  return States[id] or require(("states." .. id))
end
local Loader
do
  local _class_0
  local _base_0 = {
    draw = function(self)
      self.newstate:draw()
      return self.mx:draw()
    end,
    update = function(self, dt)
      self.mx:setAlpha(255 * self.time_left / self.time_had)
      print(self.mx.alpha)
      self.time_left = self.time_left - dt
      if self.time_had / self.time_left > 2 then
        self.mx:stop()
      end
      if self.time_left <= 0 then
        switcher.switch(self.state)
      end
      return self.mx:update(dt)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, id, time)
      self.mx = Matrix()
      self.time_had = time
      self.time_left = time
      self.state = id
      self.newstate = getState(id)
      self.newstate:enter()
      return gamestate:switch(self)
    end,
    __base = _base_0,
    __name = "Loader"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Loader = _class_0
end
switcher = {
  switch = function(id)
    previousState = currentState
    currentState = id
    return gamestate.switch(getState(id))
  end,
  getPrevious = function()
    return previousState
  end,
  getCurrent = function()
    return currentState
  end,
  getStateById = function(id)
    return getState(id)
  end,
  load = function(id, time)
    return gamestate.switch(Loader(id, time))
  end
}
gamestate.registerEvents()
return switcher
