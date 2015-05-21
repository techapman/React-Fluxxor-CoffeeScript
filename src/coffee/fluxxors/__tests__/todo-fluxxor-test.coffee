#integration tests for Fluxxor.Flux instance--DOES NOT mock actions or stores
jest.dontMock '../todo-fluxxor'
jest.dontMock '../../stores/todo-store'
jest.dontMock '../../actions/todo-actions'

describe 'TodoFluxInstance', ->
  flux = null

  beforeEach ->
    flux = require '../todo-fluxxor'

  afterEach ->
    flux = null

  it 'adds todo items to TodoStore', ->
    #TodoStore's todos.length should start at 0 and get bigger as we add todos
    expect(flux.store('TodoStore').getState().todos.length).toBe(0)
    flux.actions.addTodo('hang with my bae')
    flux.actions.addTodo('test my fluxxor app')
    expect(flux.store('TodoStore').getState().todos.length).toBe(2)


  it 'toggles complete on todo items in TodoStore', ->
    flux.actions.addTodo('hang with my bae')
    todoItem = flux.store('TodoStore').getState().todos[0] #get ref to todo item
    flux.actions.toggleComplete(todoItem)
    expect(flux.store('TodoStore').getState().todos[0].complete).toBe(true)
    flux.actions.toggleComplete(todoItem) #should be reversible
    expect(flux.store('TodoStore').getState().todos[0].complete).toBe(false)


  it 'has clearTodos method that removes completed todo items from TodoStore', ->
    flux.actions.addTodo('hang with my bae')
    flux.actions.addTodo('download the new jamie xx album')
    flux.actions.addTodo("make America's next top computational model")
    todoItem = flux.store('TodoStore').getState().todos[0] #get ref to todo item
    flux.actions.toggleComplete(todoItem)
    #sanity check
    expect(flux.store('TodoStore').getState().todos[0].complete).toBe(true)
    #here's the real test for clearTodos
    expect(flux.store('TodoStore').getState().todos.length).toBe(3)
    flux.actions.clearTodos()
    expect(flux.store('TodoStore').getState().todos.length).toBe(2)

  it 'invokes a callback when actions change the TodoStore', ->
    #TodoStore calls to this.emit were tested in todo-store-tests.coffee
    #This tests whether actions and stores integrate properly--stores must
    #call a callback on "change", which should be triggered by actions
    fakeCallback = jest.genMockFunction()
    #register a fake callback, StoreWatchMixin does this in React components
    flux.store('TodoStore').on('change', fakeCallback)
    
    flux.actions.addTodo('hang with my bae') #first change ev
    flux.actions.addTodo('download the new jamie xx album') #second change ev
    todoItem = flux.store('TodoStore').getState().todos[0] #get ref to todo item
    flux.actions.toggleComplete(todoItem) #third change ev
    flux.actions.clearTodos() #fourth change ev

    expect(fakeCallback.mock.calls.length).toBe(4)
