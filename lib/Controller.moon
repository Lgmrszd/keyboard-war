import binds from require "config"
import keyboard from love

reversed_binds = {}
for k, v in pairs binds
  if type(v) == "table"
    for _, key in pairs v do
      reversed_binds[key] = k
  else
    reversed_binds[v] = k

controller =
  pressed: (key) ->
    key = binds[key] or key
    return love.keyboard.isDown(key)
  getActionByKey: (key) ->
    return reversed_binds[key] or key

controller
