gamestate = require "hump.gamestate"
Matrix = require "states.Matrix"

local switcher

States = {}
local previousState, currentState

getState = (id) -> States[id] or  require ("states." .. id)

class Loader
  new: (id, time) =>
    @mx = Matrix!
    @time_had = time
    @time_left = time
    @state = id
    @newstate = getState id
    @newstate\enter!
    gamestate\switch @

  draw: =>
    @newstate\draw!
    @mx\draw!

  update: (dt) =>
    @mx\setAlpha 255 * @time_left / @time_had
    print @mx.alpha
    @time_left = @time_left - dt
    if @time_had/@time_left > 2
      @mx\stop!
    if @time_left <= 0
      switcher.switch @state
    @mx\update dt


switcher =
  switch: (id) ->
    previousState = currentState
    currentState = id
    gamestate.switch getState id

  getPrevious: ->
    return previousState

  getCurrent: ->
    return currentState

  getStateById: (id) ->
    return getState id

  load: (id, time) ->
    gamestate.switch Loader(id, time)

gamestate.registerEvents!

switcher
