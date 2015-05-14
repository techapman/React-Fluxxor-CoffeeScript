
constants = require '../constants/todo-constants'

module.exports = 
  addTodo: (userTextInput)->
    @dispatch constants.ADD_TODO, {text: userTextInput}

  toggleComplete: (completedTodo)->
    @dispatch constants.TOGGLE_TODO, {todo: completedTodo}

  clearTodos: ->
    @dispatch constants.CLEAR_TODOS
