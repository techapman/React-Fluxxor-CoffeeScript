#tests for integration of all components/flux architecture, simulating user interaction
jest.dontMock '../cool-app'
jest.dontMock '../todo-item'
jest.dontMock '../../actions/todo-actions'
jest.dontMock '../../stores/todo-store'
jest.dontMock '../../constants/todo-constants'
jest.dontMock '../../fluxxors/todo-fluxxor'

describe 'TodoAppBehavior', ->
  React = null
  TestUtils = null
  flux = null
  AppComponent = null
  appElement = null

  beforeEach ->
    React = require 'react/addons'
    TestUtils = React.addons.TestUtils
    #flux is an instance of Fluxxor.Flux(stores, actions)
    flux = require '../../fluxxors/todo-fluxxor'
    AppComponent = require '../cool-app'
    appElement = TestUtils.renderIntoDocument(
      React.createElement AppComponent, {
        flux: flux
      }
    )

  afterEach ->
    React = null
    TestUtils = null
    flux = null
    AppComponent = null
    appElement = null


  it 'handles change events from user input', ->
    input = React.findDOMNode(appElement.refs.todoInputText)
    expect(input.value).toBe('') #should initially by empty string
    TestUtils.Simulate.change(input, {target: {value: 'go to the store'}})
    #user changes input text--should change state of the DOM
    expect(input.value).toBe('go to the store')


  it 'handles form submit to make a new todo item', ->
    ############# this just simulates changing input text
    input = React.findDOMNode(appElement.refs.todoInputText)
    expect(input.value).toBe('') #should initially by empty string
    TestUtils.Simulate.change(input, {target: {value: 'go to the store'}})
    #user changes input text--should change state of the DOM
    expect(input.value).toBe('go to the store')
    #############
    #now the real fun, submitting the form...
    form = TestUtils.findRenderedDOMComponentWithTag(
      appElement
      'form'
    )
    #we should not have any todo items on the DOM before adding one...
    listItemElementsArray = TestUtils.scryRenderedDOMComponentsWithTag(
      appElement
      'li'
    )
    expect(listItemElementsArray.length).toBe(0)

    spanElementsArray = TestUtils.scryRenderedDOMComponentsWithTag(
      appElement
      'span'
    )
    expect(spanElementsArray.length).toBe(0)

    TestUtils.Simulate.submit(form)
    #should add one TodoItem to the todo list (contains li and span tags)
    listItemElementsArray = TestUtils.scryRenderedDOMComponentsWithTag(
      appElement
      'li'
    )
    expect(listItemElementsArray.length).toBe(1)

    spanElementsArray = TestUtils.scryRenderedDOMComponentsWithTag(
      appElement
      'span'
    )
    expect(spanElementsArray.length).toBe(1)
    #should set input text back to empty string
    expect(input.value).toBe('')

  it 'marks todo items completed (green) when the user clicks them', ->
    makeNewTodo = (text)->
      input = React.findDOMNode(appElement.refs.todoInputText)
      TestUtils.Simulate.change(input, {target: {value: text}})
      form = TestUtils.findRenderedDOMComponentWithTag(
        appElement
        'form'
      )
      TestUtils.Simulate.submit(form)

    makeNewTodo('go to the store')
    makeNewTodo('check out hacker news')
    firstSpan = TestUtils.scryRenderedDOMComponentsWithTag(
      appElement
      'span'
    )[0]
    #expect span to change from red to green on user click
    expect(firstSpan.getDOMNode().style.color).toBe('red')
    TestUtils.Simulate.click(firstSpan)
    expect(firstSpan.getDOMNode().style.color).toBe('green')


  it 'clears completed todo items from the DOM', ->
    makeNewTodo = (text)->
      input = React.findDOMNode(appElement.refs.todoInputText)
      TestUtils.Simulate.change(input, {target: {value: text}})
      form = TestUtils.findRenderedDOMComponentWithTag(
        appElement
        'form'
      )
      TestUtils.Simulate.submit(form)

    makeNewTodo('finish writing integration tests')
    makeNewTodo('go the the bar')
    makeNewTodo('drank')
    firstSpan = TestUtils.scryRenderedDOMComponentsWithTag(
      appElement
      'span'
    )[0]
    thirdSpan = TestUtils.scryRenderedDOMComponentsWithTag(
      appElement
      'span'
    )[2]
    TestUtils.Simulate.click(firstSpan)
    TestUtils.Simulate.click(thirdSpan)

    #here's the real point of this test, user clicks 'Clear Completed' button
    button = TestUtils.findRenderedDOMComponentWithTag(
      appElement
      'button'
    )
    #should have 3 todo items on the DOM before button click
    spanElementsArray = TestUtils.scryRenderedDOMComponentsWithTag(
      appElement
      'span'
    )
    expect(spanElementsArray.length).toBe(3)
    TestUtils.Simulate.click(button)
    #should now only have 1 span element on the DOM
    spanElementsArray = TestUtils.scryRenderedDOMComponentsWithTag(
      appElement
      'span'
    )
    expect(spanElementsArray.length).toBe(1)
