jest.dontMock '../todo-store'

describe 'TodoStore', ->

  TodoStore = null
  constants = null
  store = null
  flux = null
  beforeEach ->
    #setup the store
    TodoStore = require '../todo-store'
    constants = require '../../constants/todo-constants'
    store = new TodoStore()
    #need to mock uuid return vals for unit testing
    store._uniqueID = jest.genMockFunction()
    store._uniqueID #set up 3 total return vals from the mock uuid function
      .mockReturnValueOnce("abc") #first return val is abc
      .mockReturnValueOnce("abcd") #2nd return val is abcd
      .mockReturnValueOnce("abcde") #3rd return val is abcde
    #setup the dispatcher
    stores = {"TodoStore": store}
    Fluxxor = require 'fluxxor'
    #flux actions undefined--tests will provide mock actions
    #we will call flux.dispatcher.dispatch directly to test store callbacks
    flux = new Fluxxor.Flux(stores)
  afterEach ->
    TodoStore = null
    store = null


  it 'handles addTodo actions in onAddTodo callback', ->
    #todos should start as an empty object
    expect(flux.store("TodoStore").todos).toEqual({})

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

    flux.dispatcher.dispatch(addTodoAction1)

    expect(flux.store("TodoStore").todos).toEqual({
      "abc": {
        id: "abc"
        text: "go to the store"
        complete: false
      }
    })

    #should be able to add multiple todos
    flux.dispatcher.dispatch(addTodoAction2)

    expect(flux.store("TodoStore").todos).toEqual({
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
    flux.dispatcher.dispatch(addTodoAction1)
    #sanity check--was the new todo actually added to the store?
    expect(flux.store("TodoStore").todos).toEqual({
      "abc": {
        id: "abc"
        text: "go to the store"
        complete: false
      }
    })
    #setup action object using a reference to the todo object
    toggleCompleteAction1 = {
      type: constants.TOGGLE_TODO
      payload: {todo: flux.store("TodoStore").todos["abc"]} #must be a reference
    }
    #toggle complete where function arg contains a reference to the todo item
    flux.dispatcher.dispatch(toggleCompleteAction1)

    expect(flux.store("TodoStore").todos).toEqual({
      "abc": {
        id: "abc"
        text: "go to the store"
        complete: true
      }
    })


  it 'removes completed todos in onClearTodos callback', ->
    #put mock todo items in the store with some complete and some incomplete
    flux.store("TodoStore").todos = {
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
    flux.dispatcher.dispatch(clearTodosAction)
    expect(flux.store("TodoStore").todos).toEqual({
      "abcd": {
        id: "abcd"
        text: "do homework"
        complete: false
      }
    })


  it 'emits a CHANGE event in all its callbacks', ->
    flux.store("TodoStore").emit = jest.genMockFunction()
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
    flux.dispatcher.dispatch(addTodoAction1) #should call emit (1)
    flux.dispatcher.dispatch(addTodoAction2) #should call emit (2)

    toggleCompleteAction1 = {
      type: constants.TOGGLE_TODO
      payload: {todo: flux.store("TodoStore").todos["abc"]} #must be a reference
    }
    flux.dispatcher.dispatch(toggleCompleteAction1) #should call emit (3)

    clearTodosAction = {type: constants.CLEAR_TODOS, payload: undefined}
    flux.dispatcher.dispatch(clearTodosAction) #should call emit (4)

    expect(flux.store("TodoStore").emit.mock.calls.length).toBe(4) #should have been called 4x
    #check whether each call to store.emit contained the argument 'change'
    for emitCall in flux.store("TodoStore").emit.mock.calls
      firstArgInCall = emitCall[0]
      expect(firstArgInCall).toBe('change')
