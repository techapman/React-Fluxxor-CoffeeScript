
Fluxxor = require 'fluxxor'
React = require 'react/addons'
FluxMixin = Fluxxor.FluxMixin(React)
StoreWatchMixin = Fluxxor.StoreWatchMixin

#child react components
TodoItem = require './todo-item'

Application = React.createClass
  mixins: [FluxMixin, StoreWatchMixin('TodoStore')]

  getInitialState: ->
    {newTodoText: ''}

  getStateFromFlux: ->
    TodoFluxxor = @getFlux()
    return TodoFluxxor.store('TodoStore').getState()

  handleTodoTextChange: (e)->
    @setState({newTodoText: e.target.value})

  onSubmitForm: (e)->
    e.preventDefault()
    if @state.newTodoText.trim()
      @getFlux().actions.addTodo @state.newTodoText
      @setState {newTodoText: ''}

  clearCompletedTodos: (e)->
    @getFlux().actions.clearTodos()

  render: ->
    { div, ul, li, form, input, button } = React.DOM
    #each html element above is a function from React.DOM.<element>
    #React.DOM element functions called like this:
    #      element({prop1: val, prop2: val2}, childrenElements...)
    #children elements above can either be React components or text strings
    (div {id:'TODOAPPDIV'}, [

      ul {key: 'allTodosList'}, @state.todos.map (currentTodo, i)->
        #console.log 'CURRENT TODO', currentTodo, i
        (li {key: currentTodo.id}, [
          React.createElement(TodoItem, {todo: currentTodo, key: i})
        ])

      form {
          onSubmit: @onSubmitForm
          key: 'todoInputForm'
        }, [
          input {
            type: 'text'
            size: '30'
            placeholder: 'New Todo'
            value: @state.newTodoText
            ref: 'todoInputText'
            key: 'todoInputText'
            onChange: @handleTodoTextChange
          }

          input {
            type: 'submit'
            value: 'Add Todo'
            ref: 'todoInputSubmit'
            key: 'todoInputSubmit'
          }
        ]

      button {
        onClick: @clearCompletedTodos
        key: 'clearCompletedButton'
      }, 'Clear Completed'

    ])

module.exports = Application
