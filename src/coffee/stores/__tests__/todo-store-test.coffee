jest.dontMock '../todo-store'

describe 'TodoStore', ->

  TodoStore = null
  constants = null
  store = null

  beforeEach ->
    TodoStore = require '../todo-store'
    constants = require '../../constants/todo-constants'
    store = new TodoStore()
    #need to mock uuid return vals for unit testing
    store._uniqueID = jest.genMockFunction()
    store._uniqueID #set up 3 total return vals from the mock uuid function
      .mockReturnValueOnce("abc") #first return val is abc
      .mockReturnValueOnce("abcd") #2nd return val is abcd
      .mockReturnValueOnce("abcde") #3rd return val is abcde

  afterEach ->
    TodoStore = null
    store = null


  it 'handles addTodo actions in onAddTodo callback', ->
    #todos should start as an empty object
    expect(store.todos).toEqual({})

    #setup some action objects the dispatcher would call __handleAction__ with
    addTodoAction1 = {
      type: constants.ADD_TODO
      payload: {
        text: 'go to the store'
      }
    }
    addTodoAction2 = {
      type: constants.ADD_TODO
      payload: {
        text: 'get money get paid'
      }
    }

    #dispatcher would normally dispatch the appropriate callback
    #via __handleAction__, but this method isnt public. Hack around that...
    store.__handleAction__(addTodoAction1)

    expect(store.todos).toEqual({
      "abc": {
        id: "abc"
        text: "go to the store"
        complete: false
      }
    })

    #should be able to add multiple todos
    store.__handleAction__(addTodoAction2)

    expect(store.todos).toEqual({
      "abc": {
        id: "abc"
        text: "go to the store"
        complete: false
      },
      "abcd": {
        id: "abcd"
        text: "get money get paid"
        complete: false
      }
    })


  it 'handles toggleComplete action in onToggleComplete callback', ->
    #put a new todo object in the store
    addTodoAction1 = {
      type: constants.ADD_TODO
      payload: {
        text: 'go to the store'
      }
    }
    store.__handleAction__(addTodoAction1)
    #sanity check--was the new todo actually added to the store?
    expect(store.todos).toEqual({
      "abc": {
        id: "abc"
        text: "go to the store"
        complete: false
      }
    })
    #setup action object using a reference to the todo object
    toggleCompleteAction1 = {
      type: constants.TOGGLE_TODO
      payload: {todo: store.todos["abc"]} #must be a reference to the object
    }
    #toggle complete where function arg contains a reference to the todo item
    store.__handleAction__(toggleCompleteAction1)

    expect(store.todos).toEqual({
      "abc": {
        id: "abc"
        text: "go to the store"
        complete: true
      }
    })


  it 'removes completed todos in onClearTodos callback', ->
    #put mock todo items in the store with some complete and some incomplete
    store.todos = {
      "abc": {
        id: "abc"
        text: "go to the store"
        complete: true
      },
      "abcd": {
        id: "abcd"
        text: "do homework"
        complete: false
      },
      "abcde": {
        id: "abcde"
        text: "power up"
        complete: true
      }
    }
    #call clearTodos action--no payload needed
    clearTodosAction = {type: constants.CLEAR_TODOS, payload: undefined}
    store.__handleAction__(clearTodosAction)
    expect(store.todos).toEqual({
      "abcd": {
        id: "abcd"
        text: "do homework"
        complete: false
      }
    })


  it 'emits a CHANGE event in all its callbacks', ->
    store.emit = jest.genMockFunction()
    #setup some mock actions
    addTodoAction1 = {
      type: constants.ADD_TODO
      payload: {
        text: 'go to the store'
      }
    }
    addTodoAction2 = {
      type: constants.ADD_TODO
      payload: {
        text: 'get money get paid'
      }
    }
    store.__handleAction__(addTodoAction1) #should call emit (1)
    store.__handleAction__(addTodoAction2) #should call emit (2)

    toggleCompleteAction1 = {
      type: constants.TOGGLE_TODO
      payload: {todo: store.todos["abc"]} #must be a reference to the object
    }
    store.__handleAction__(toggleCompleteAction1) #should call emit (3)

    clearTodosAction = {type: constants.CLEAR_TODOS, payload: undefined}
    store.__handleAction__(clearTodosAction) #should call emit (4)

    expect(store.emit.mock.calls.length).toBe(4) #should have been called 4x
    #check whether each call to store.emit contained the argument 'change'
    for emitCall in store.emit.mock.calls
      firstArgInCall = emitCall[0]
      expect(firstArgInCall).toBe('change')
