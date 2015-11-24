Shortcuts = require 'global-shortcut'
app       = require 'app'
_         = require 'lodash'
container = {}


bind = (accelerator, cb) ->
  container[accelerator] = cb
  unbindAll()
  bindAll()

unbind = (accelerator) ->
  delete container[accelerator]
  Shortcuts.unregisterAll()
  unbindAll()
  bindAll()

bindAll = ->
  _.each container, (v, k) ->
    Shortcuts.register(k, v)

unbindAll = ->
  Shortcuts.unregisterAll()

app.on 'browser-window-focus', bindAll
app.on 'browser-window-blur', unbindAll


module.exports =
  add : bind
  remove : unbind
