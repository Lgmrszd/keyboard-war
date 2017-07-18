gamestate = require "hump.gamestate"

local switcher

States = {}
local previousStateId, currentStateId, currentState

getState = (id) -> States[id] or require("states." .. id)!

switcher =
  switch: (id) ->
    previousStateId = currentStateId
    currentStateId = id
    currentState = getState id
    gamestate.switch currentState

  getPreviousStateId: ->
    return previousStateId

  getCurrentStateId: ->
    return currentStateId

  getStateById: (id) ->
    return getState id

  getState: ->
    return currentState


gamestate.registerEvents!

switcher
