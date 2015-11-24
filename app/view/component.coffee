React = require 'react'
_     = require 'lodash'

component = (funcOrObject) ->
  # if to factory passed function then factory
  # will create react's wrapped stupid logicless
  # component — simple renderer thats perform all
  # he's actions to parent
  if _.isFunction(funcOrObject)
    return createSimpleRender(funcOrObject)

  # if to factory passed plain js object
  # then factory will constrcut react component
  # with mixed action's emmiter
  # us this for creating components in coffee files
  else if _.isPlainObject(funcOrObject)
    return createWrappedComponent(funcOrObject)

  else
    throw new Error 'Unexpected argument. CreateCompnent
    awaits for function or plain object.'

# we took passed render method, wrap it into
# react object and define statement for update
# based on point that we will work only with
# Immutable objects and then we just return
# wrapped method that works like simplified
# reacts own render method but with parent-child
# refs and actions emitter
# ```
# Some = createSimpleRender (data, trigger) ->
#   <div onClick={trigger.bind(@, 'action', 'value')}>
#     {data.someValue}
#   </div>
# ```
createSimpleRender = (render) ->
  createWrappedComponent
    shouldComponentUpdate : (newProps) -> newProps != @props
    render : -> render.call this, @props


createWrappedComponent = (obj) ->
  React.createElement.bind null, React.createClass obj

module.exports = component
