
Fluxxor = require 'fluxxor'
uuid = require 'uuid'
constants = require '../constants/todo-constants'

#constant change event string
CHANGE = 'change'

TodoStore = Fluxxor.createStore
  initialize: ->
    @todos = {}
    @bindActions(
      constants.ADD_TODO, @onAddTodo,
      constants.TOGGLE_TODO, @onToggleComplete,
      constants.CLEAR_TODOS, @onClearTodos
    )

  onAddTodo: (payload)->
    identifier = @_uniqueID()
    newTodo = 
      text: payload.text
      id: identifier
      complete: false
    @todos[identifier] = newTodo
    #console.log 'ALL TODOS', @todos
    @emit CHANGE

  onToggleComplete: (payload)->
    payload.todo.complete = !payload.todo.complete
    @emit CHANGE

  onClearTodos: ->
    newTodoObject = {}
    for id, todo of @todos
      if not todo.complete
        newTodoObject[id] = todo
    @todos = newTodoObject
    @emit CHANGE

  getState: ->
    todoArray = (todo for id, todo of @todos)
    #console.log('getState TODOARRAY', todoArray)
    return {
      todos: todoArray
    }

  _uniqueID: ->
    uuid.v4()

module.exports = TodoStore