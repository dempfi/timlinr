_       = require 'lodash'
emitter = require('eventemitter2').EventEmitter2
moment  = require 'moment'
store   = require './helpers/store'
uuid    = require 'uuid'
fs      = require 'fs-jetpack'
defs    = fs.cwd "#{__dirname}/defaults"


class State
  constructor : ->
    _.extend @, emitter.prototype
    state = store.load('state')
    state ?=
    # state =
      tasks      : {}
      dates      : {}
      activeDate : moment().format 'YYYY-MM-DD'
      activeTask : null
    @state = _.extend state,
      inEdit        : null
      showShortcuts : false
      shortcuts     : defs.read 'shortcuts.json', 'json'


  get : (path) ->
    _.get(@state, path) or null

  _set : (path, v) ->
    _.set @state, path, v

  set : (path, v) ->
    @_set path, v
    @inform()

  add : (place = 0, task) ->
    task     = _.extend content : '', isDone : false, task
    place    = 0 if place < 0
    id       = uuid.v1()
    day      = @get('activeDate')
    dayTasks = @get(['dates', day]) or []
    place   += dayTasks.indexOf @get 'activeTask'
    dayTasks.splice place, 0, id
    @_set 'activeTask', id
    @_set 'inEdit', id
    @_set ['dates', day], dayTasks
    @_set ['tasks', id], task
    @inform()

  update : (obj) ->
    id = @get 'activeTask'
    task = @get ['tasks', id]
    task = _.extend task, obj
    @_set ['tasks', id], task
    @inform()

  remove : ->
    id = @get 'activeTask'
    date = @get 'activeDate'
    tasks = @get ['dates', date]
    nextIndex = Math.max tasks.indexOf(id) - 1, 0
    tasks = _.remove tasks, (v) -> v isnt id
    @_set ['dates', date], tasks
    @_set 'activeTask', tasks[nextIndex]
    @inform()

  inform : ->
    store.save 'state', @state
    @emit 'change'


module.exports = new State()
