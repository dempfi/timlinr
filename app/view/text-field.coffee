React     = require 'react'
Component = require './component'
{input}   = React.DOM
ENTER     = 13
ESCAPE    = 27

module.exports = Component
  getInitialState : ->
    value : @props.value

  onChange : (e) ->
    @setState value : e.target.value
    @props.onChange e.target.value

  render : ->
    input
      value     : @state.value
      onChange  : @onChange
      autoFocus : true
