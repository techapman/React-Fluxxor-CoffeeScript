jest.dontMock '../cool-app'

describe 'TodoApp', ->
  React = null
  TestUtils = null
  App = null

  beforeEach ->
    React = require 'react/addons'
    TestUtils = React.addons.TestUtils
    App = require '../cool-app'

  afterEach ->
    React = null
    TestUtils = null
    App = null

  #UNIT TESTS (WITH MOCKED FLUX)
  it 'renders all the html on load', ->
    #make sure document has div, ul, form, input, and button tags
    appElement = TestUtils.renderIntoDocument(
      React.createElement App, {
        flux:
          store: jest.genMockFunction().mockImplementation((storeName)->
            if storeName is 'TodoStore'
              return {
                on: jest.genMockFunction() #need this so StoreWatchMixin doesnt throw error
                getState: -> return {todos: []} # fn that returns empty todo array
              }
          )
      }
    )
    tagsThatShouldRenderOnce = ['div', 'ul', 'form', 'button']
    for tag in tagsThatShouldRenderOnce
      findEl = -> #make a function that looks for tag on virtual DOM
        TestUtils.findRenderedDOMComponentWithTag appElement, tag
      expect(findEl).not.toThrow() #if tag doesnt exist, findEl with throw

    #should have 2 input tags
    inputElementsArray = TestUtils.scryRenderedDOMComponentsWithTag(
      appElement
      'input'
    )
    expect(inputElementsArray.length).toBe(2)
    #empty @state.todos should not render any TodoItem elements (aka li tags)
    listItemElementsArray = TestUtils.scryRenderedDOMComponentsWithTag(
      appElement
      'li'
    )
    expect(listItemElementsArray.length).toBe(0)


  it "renders a TodoItem for each todo in TodoStore (@state.todos)", ->
    #make sure document has div, ul, form, input, and button tags
    appElement = TestUtils.renderIntoDocument(
      React.createElement App, {
        flux:
          store: jest.genMockFunction().mockImplementation((storeName)->
            if storeName is 'TodoStore'
              return {
                on: jest.genMockFunction() #need this so StoreWatchMixin doesnt throw error
                getState: -> return {todos: [
                  {id: 'abc', text:'hang with bae', complete: true}
                  {id: 'abcd', text:'workout', complete: true}
                  {id: 'abcde', text:'watch game of thrones', complete: false}
                ]} # fn that returns populated todo array
              }
          )
      }
    )
    tagsThatShouldRenderOnce = ['div', 'ul', 'form', 'button']
    for tag in tagsThatShouldRenderOnce
      findEl = -> #make a function that looks for tag on virtual DOM
        TestUtils.findRenderedDOMComponentWithTag appElement, tag
      expect(findEl).not.toThrow() #if tag doesnt exist, findEl with throw

    #should have 2 input tags
    inputElementsArray = TestUtils.scryRenderedDOMComponentsWithTag(
      appElement
      'input'
    )
    expect(inputElementsArray.length).toBe(2)

    #should have 3 TodoItem elements (which have li tags)
    listItemElementsArray = TestUtils.scryRenderedDOMComponentsWithTag(
      appElement
      'li'
    )
    expect(listItemElementsArray.length).toBe(3)
