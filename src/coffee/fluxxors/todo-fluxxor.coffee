
Fluxxor = require 'fluxxor'
actions = require '../actions/todo-actions'
TodoStore = require '../stores/todo-store'

stores = {
  'TodoStore': new TodoStore()
}

#actions is an object with methods that call this.dispatch
flux = new Fluxxor.Flux(stores, actions)

flux.on 'dispatch', (type, payload)->
  #console.log '[Dispatch]', type, payload

module.exports = flux
