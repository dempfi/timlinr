_         = require 'lodash'
moment    = require 'moment'
state     = require './state'
shortcuts = electron.require './helpers/win-shortcuts'

class Actions
  constructor : ->
    @bindAllShortcuts()

  unbindNav : ->
    _.each state.get('shortcuts'), (sh) ->
      shortcuts.remove(sh.accelerator) if sh.input

  bindAllShortcuts : ->
    _.each state.get('shortcuts'), (sh) =>
      method = "on#{_.capitalize _.camelCase(sh.key)}"
      shortcuts.add sh.accelerator, @[method].bind @, sh.argument

  saveContent : (c) ->
    @_contentInEdit = c

  onShortcuts : ->
    state.set 'showShortcuts', !state.get 'showShortcuts'

  onCut : ->
    @_taskToCopy = state.get 'activeTask'
    state.remove()

  onCopy : ->
    @_taskToCopy = state.get 'activeTask'

  onPaste : ->
    date = state.get 'activeDate'
    task = state.get 'activeTask'
    tasks = state.get(['dates', date]) or []
    return unless @_taskToCopy
    i = tasks.indexOf(task) or 0
    state.add i, state.get ['tasks', @_taskToCopy]
    state.set 'inEdit', null

  onNewTask : (i) ->
    @onStopEditing() if state.get 'inEdit' #save task in editinion
    state.add Number i
    @unbindNav()

  onStartEditing : ->
    state.set 'inEdit', state.get 'activeTask'
    @unbindNav()
    @_contentInEdit = ""

  onStopEditing : ->
    if state.get 'inEdit'
      state.update(content : @_contentInEdit) if @_contentInEdit
      state.set 'inEdit', null
      @bindAllShortcuts()
      @_contentInEdit = ""
    else
      @onNewTask(1)


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
