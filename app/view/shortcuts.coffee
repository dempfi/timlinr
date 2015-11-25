React       = require 'react'
_           = require 'lodash'
Component   = require './component'
state       = require '../state'
{div, span, ul, li} = React.DOM

module.exports = Component () ->
  return null unless state.get 'showShortcuts'
  ul className : 'shortcuts', _.map state.get('shortcuts'), (s) ->
    li key : s.accelerator, className : 'shortcut',
      div className : 'accelerator', span {}, toView(s.accelerator)
      div className : 'description', s.description


toView = (str) ->
  symbols =
    'Cmd' : '⌘'
    'Alt' : '⌥'

  _(str)
  .words()
  .map _.capitalize
  .map (s) -> symbols[s] or s
  .join '+'
