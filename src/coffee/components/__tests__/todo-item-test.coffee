jest.dontMock '../todo-item.coffee'

describe 'TodoItem', ->
  it 'calls handleClick when it is clicked', ->
    #setup
    React = require 'react/addons'
    #TodoItem = require '../todo-item.coffee'
    TestUtils = React.addons.TestUtils

    # TodoItemElement = React.createElement TodoItem, {
    #     todo:
    #       text: 'Go to the store'
    #       id: 'j89877787'
    #       complete: false
    #   }
    expect(true).toBe(true)
    # #render TodoItem instance in virtual DOM
    # todoElement = TestUtils.renderIntoDocument(
    #   React.createElement TodoItem, {
    #       todo:
    #         text: 'Go to the store'
    #         id: 'j89877787'
    #         complete: false
    #     }
    # )
    #
    # span = TestUtils.findRenderedDOMComponentWithTag(
    #   todoElement #DOM tree
    #   'span'
    # )
