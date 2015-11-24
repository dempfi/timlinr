React         = require 'react'
moment        = require 'moment'
Component     = require './component'
{div, strong} = React.DOM

module.exports = Component ({date}) ->
  t = getTitle(date)
  div className : 'title-bar',
    div className : 'title',
      strong({}, t.m), ' ' + t.y


getTitle = (d) ->
  s = moment(d).startOf 'week'
  e = moment(d).endOf 'week'
  m =
  if s.isSame(e, 'month') then s.format('MMMM')
  else "#{s.format('MMMM')} — #{e.format('MMMM')}"
  y =
  if s.isSame(e, 'year') then s.format('YYYY')
  else "#{s.format('YYYY')} — #{e.format('YYYY')}"
  {m : m, y : y}
