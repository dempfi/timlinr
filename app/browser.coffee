app           = require 'app'
BrowserWindow = require 'browser-window'
store         = require './helpers/store'
_             = require 'lodash'

state = store.load('window') or
  x      : 100
  y      : 200
  width  : 1000
  height : 500

app.on 'ready', ->

  win = new BrowserWindow _.merge state,
    'title-bar-style': 'hidden'

  if state.isMaximized
    win.maximize()

  # win.openDevTools()

  win.loadUrl "file://#{__dirname}/index.html"

  win.on 'close', ->
    pos = win.getPosition()
    size = win.getSize()
    store.save 'window',
      x           : pos[0]
      y           : pos[1]
      width       : size[0]
      height      : size[1]
      isMaximized : win.isMaximized()


app.on 'window-all-closed', -> app.quit()
