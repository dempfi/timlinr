React     = require 'react'
moment    = require 'moment'
Component = require './component'
TitleBar  = require './title-bar'
Day       = require './day'
{div}     = React.DOM

module.exports = Component ({date}) ->
  div className : 'app',
    TitleBar({date})
    div className : 'days',
      getDays(date).map renderDay

renderDay = (day) ->
  Day key : day, day : day

getDays = (day) ->
  fst = moment(day).startOf('week').subtract(1, 'd')
  lst = moment(day).endOf('week').add(1, 'd')
  days = until fst.add(1, 'd').isSame(lst, 'd') then moment(fst)
  days.map (d) -> d.format('YYYY-MM-DD')
