local MainMenu
do
  local _class_0
  local _base_0 = {
    update = function(self, dt) end,
    draw = function(self)
      return love.graphics.print("draw", 100, 100)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "MainMenu"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  MainMenu = _class_0
  return _class_0
end
