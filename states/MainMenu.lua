local StateManager = require("lib.StateManager")
local Matrix = require("states.Matrix")
local colorize = require("lib.colorize")
local config = require("config")
local menu = {
  {
    id = "play",
    text = "Play",
    action = function()
      return StateManager.switch("TestStage1")
    end
  },
  {
    id = "settings",
    text = "Settings",
    action = function()
      return StateManager.switch("Settings")
    end
  },
  {
    id = "exit",
    text = "Exit",
    action = function()
      return love.event.quit(0)
    end
  }
}
local LCS = require("LuaCanSound")
local Synth
do
  local _class_0
  local sine, env
  local _base_0 = {
    play = function(self, arg)
      sine:start(arg.freq)
      env:start()
      local length = LCS.settings.sampleRate * arg.length
      local sample = love.sound.newSoundData(length, LCS.settings.sampleRate, 16, 1)
      for i = 0, length - 1 do
        sample:setSample(i, sine:tick() * env:tick() * 0.1)
      end
      return love.audio.play(love.audio.newSource(sample))
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "Synth"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  sine = LCS.generators.Triangle:new()
  env = LCS.envelopes.ASR:new()
  do
    local _with_0 = env
    _with_0:set({
      attack_seconds = 0.01
    })
    _with_0:set({
      sustain_seconds = 0.05
    })
    _with_0:set({
      decay_seconds = 0.01
    })
  end
  Synth = _class_0
end
local MainMenu
do
  local _class_0
  local _base_0 = {
    synth = Synth(),
    menu = menu,
    active_node = 1,
    matrix = Matrix(),
    enter = function(self) end,
    keypressed = function(self, key_id)
      if key_id == "down" then
        self.synth:play({
          freq = 700,
          length = 0.07
        })
        self.active_node = self.active_node + 1
        if self.active_node > #self.menu then
          self.active_node = 1
        end
      elseif key_id == "up" then
        self.synth:play({
          freq = 700 * 2 ^ (2 / 12),
          length = 0.07
        })
        self.active_node = self.active_node - 1
        if self.active_node == 0 then
          self.active_node = #self.menu
        end
      elseif key_id == "shoot" then
        self.synth:play({
          freq = 700 * 4 ^ (2 / 12),
          length = 0.07
        })
        return self.menu[self.active_node].action()
      end
    end,
    update = function(self, dt)
      love.graphics.setFont(config.fonts.menu)
      return self.matrix:update(dt)
    end,
    draw = function(self)
      self.matrix:draw()
      local x, y = 30, 30
      for i = 1, #self.menu do
        love.graphics.setNewFont(20)
        colorize((i == self.active_node) and {
          100,
          255,
          100
        } or {
          100,
          100,
          100
        }, function()
          return love.graphics.printf(self.menu[i].text, x, y, 300)
        end)
        y = y + 30
      end
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
