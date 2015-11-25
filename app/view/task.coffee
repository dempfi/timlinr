React     = require 'react'
Component = require './component'
Checker   = require './checker'
Field     = require './text-field'
state     = require '../state'
actions   = require '../actions'
{li}      = React.DOM

module.exports = Component ({id}) ->
  task      = state.get ['tasks', id]
  isEditing = state.get('inEdit') is id
  isActive  = state.get('activeTask') is id
  f         = '-in-focus' if isActive
  d         = '-is-done' if task.isDone
  e         = '-in-edit' if isEditing
  li className : "task #{f} #{d} #{e}",
    Checker(checked : task.isDone)
    if not isEditing then task.content or ' '
    else Field
      value    : task.content
      onChange : actions.saveContent.bind actions
