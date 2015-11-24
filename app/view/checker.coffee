React         = require 'react'
Component = require './component'
{div}     = React.DOM

module.exports = Component ({checked, onChange}) ->
  cn = '-checked' if checked
  div
    className : "checkbox #{cn}"
    onClick   : onChange
