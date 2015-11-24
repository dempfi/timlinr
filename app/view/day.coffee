React     = require 'react'
moment    = require 'moment'
Component = require './component'
Task      = require './task'
state     = require '../state'
{div, ul} = React.DOM

module.exports = Component ({day}) ->
  tasks = state.get(['dates', day]) or []
  f     = '-in-focus' if state.get('activeDate') is day
  div className : "day #{f}",
    div className : 'date-title', moment(day).format('DD dddd')
    ul className : 'tasks', _.map tasks, renderTask

renderTask = (id) ->
  Task key : id, id : id
