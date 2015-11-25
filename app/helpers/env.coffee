fs = require 'fs-jetpack'
_ = require 'lodash'

get = (k) ->
  json =
  if typeof window is 'object'
    fs.read(__dirname + '/env_config.json', 'json')
  else
    fs.read(__dirname + '/../env_config.json', 'json')
  _.get json, k


module.exports =
  get : get
