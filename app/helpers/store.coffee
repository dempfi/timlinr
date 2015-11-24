app =
if electron? then electron.require 'app'
else require 'app'

fs  = require 'fs-jetpack'
dir = fs.cwd app.getPath 'userData'

load = (key) ->
  dir.read "#{key}.json", 'json'

save = (key, data) ->
  dir.write "#{key}.json", data, atomic : on

module.exports =
  load : load
  save : save
