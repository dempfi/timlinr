_         = require 'lodash'
moment    = require 'moment'
state     = require './state'
shortcuts = electron.require './helpers/win-shortcuts'

class Actions
  constructor : ->
    @bindAllShortcuts()

  unbindNav : ->
    accs = ['right', 'left', 'up', 'down', 'alt+left', 'alt+right', 'backspace']
    _.each accs, shortcuts.remove

  bindAllShortcuts : ->
    _.each state.get('shortcuts'), (sh, key) =>
      if _.isArray(sh) then _.each sh, @addShortcut.bind @, key
      else @addShortcut key, sh

  addShortcut : (key, sh) ->
    method = "on#{_.capitalize _.camelCase(key)}"
    if @[method]
      shortcuts.add sh.accelerator, @[method].bind @, sh.argument

  saveContent : (c) ->
    @_contentInEdit = c

  onNewTask : (i) ->
    @onEnter() if state.get 'inEdit' #save task in editinion
    state.add Number i
    @unbindNav()

  onEnter : ->
    if state.get 'inEdit'
      state.update(content : @_contentInEdit) if @_contentInEdit
      state.set 'inEdit', null
      @bindAllShortcuts()
    else
      state.set 'inEdit', state.get 'activeTask'
      @unbindNav()
    @_contentInEdit = ""

  onDelete : ->
    state.remove()

  onToggle : ->
    task = state.get ['tasks', state.get('activeTask')]
    state.update isDone : !task.isDone

  onNavTask : (i) ->
    i     = Number i
    task  = state.get 'activeTask'
    date  = state.get 'activeDate'
    tasks = state.get ['dates', date]
    i    += tasks.indexOf task
    i     = tasks.length - 1 if i < 0
    i     = 0 if i > tasks.length - 1
    state.set 'activeTask', tasks[i]

  onCancel : ->
    @_contentInEdit = ""
    state.set 'inEdit', null
    @bindAllShortcuts()

  onNav : (i) ->
    i    = Number i
    date = state.get 'activeDate'
    date = moment(date).add(i, 'd')
    date = moment() if i is 0
    date = date.format 'YYYY-MM-DD'
    task = state.get(['dates', date])?[0]
    state.set 'activeDate', date
    state.set 'activeTask', task


module.exports = new Actions()
