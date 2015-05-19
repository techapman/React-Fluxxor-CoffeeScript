jest.dontMock '../todo-actions'

describe 'TodoActions', ->

  TodoActions = null
  constants = null

  beforeEach ->
    constants = require '../../constants/todo-constants'
    TodoActions = require '../todo-actions'
    TodoActions.dispatch = jest.genMockFunction()
  afterEach ->
    TodoActions = null

  it 'has an addTodo method that calls dispatch with 2 args', ->

    TodoActions.addTodo 'go to the supermarket'

    firstCall = TodoActions.dispatch.mock.calls[0]
    firstArg = firstCall[0]
    secondArg = firstCall[1]

    expect(firstArg).toBe(constants.ADD_TODO)
    expect(secondArg).toEqual({text: 'go to the supermarket'})

  it 'has a toggleComplete method that calls dispatch with 2 args', ->
    todoItem = {text: 'blah', id: "fijsf", complete: false}

    TodoActions.toggleComplete(todoItem)

    firstCall = TodoActions.dispatch.mock.calls[0]
    firstArg = firstCall[0]
    secondArg = firstCall[1]

    expect(firstArg).toBe(constants.TOGGLE_TODO)
    expect(secondArg).toEqual({todo: todoItem})

  it 'has a clearTodos method that calls dispatch with 1 arg', ->

    TodoActions.clearTodos()

    firstCall = TodoActions.dispatch.mock.calls[0]
    firstArg = firstCall[0]

    expect(firstArg).toBe(constants.CLEAR_TODOS)
