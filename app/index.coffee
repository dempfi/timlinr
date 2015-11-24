window.electron = require 'remote'
_               = require 'lodash'
state           = require './state'
actions         = require './actions'
View            = require './view'
ReactDOM        = require 'react-dom'

render = () ->
  ReactDOM.render View(date : state.get('activeDate')),
    document.querySelector '#root'

state.on 'change', render
window.addEventListener 'DOMContentLoaded', render
