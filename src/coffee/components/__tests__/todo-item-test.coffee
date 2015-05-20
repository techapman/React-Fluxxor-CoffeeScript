jest.dontMock '../todo-item'

describe 'TodoItem', ->
  TodoItem = null
  TestUtils = null
  React = null

  beforeEach ->
    TodoItem = require '../todo-item'
    React = require 'react/addons'
    TestUtils = React.addons.TestUtils

  afterEach ->
    TodoItem = null

  it 'renders a red <span> for incomplete todo items', ->
    todoElement = TestUtils.renderIntoDocument(
      React.createElement TodoItem, {
        todo:
          text: 'party rock'
          id: 'doesntmatter'
          complete: false
        flux: {} #need fake flux so FluxMixin doesn't throw error
      }
    )
    span = TestUtils.findRenderedDOMComponentWithTag(
      todoElement #jsdom tree
      'span'
    )

    expect(span.getDOMNode().textContent).toBe('party rock')
    expect(span.getDOMNode().style.color).toBe('red')


  it 'renders a green <span> for complete todo items', ->
    todoElement = TestUtils.renderIntoDocument(
      React.createElement TodoItem, {
        todo:
          text: 'party rock'
          id: 'doesntmatter'
          complete: true
        flux: {} #need fake flux so FluxMixin doesn't throw error
      }
    )
    span = TestUtils.findRenderedDOMComponentWithTag(
      todoElement #jsdom tree
      'span'
    )

    expect(span.getDOMNode().textContent).toBe('party rock')
    expect(span.getDOMNode().style.color).toBe('green')


  it 'calls actions.toggleComplete(todoObj) when clicked', ->
    todo =
      text: 'party rock'
      id: 'doesntmatter'
      complete: true
    flux =
      actions:
        toggleComplete: jest.genMockFunction() #mocked to spy on calls and args

    todoElement = TestUtils.renderIntoDocument(
      React.createElement TodoItem, {
        todo: todo
        flux: flux
      }
    )

    span = TestUtils.findRenderedDOMComponentWithTag(
      todoElement #jsdom tree
      'span'
    )

    #should not have been clicked before simulated click
    expect(flux.actions.toggleComplete.mock.calls.length).toBe(0)

    TestUtils.Simulate.click(span)

    expect(flux.actions.toggleComplete.mock.calls.length).toBe(1)

    #todo object should be the first argument to actions.toggleComplete
    arg = flux.actions.toggleComplete.mock.calls[0][0] #first call, first arg
    expect(arg).toEqual(todo)
