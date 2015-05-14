
Fluxxor = require 'fluxxor'
React = require 'react'
FluxMixin = Fluxxor.FluxMixin(React)

module.exports = React.createClass
  mixins: [FluxMixin]

  propTypes: {
    todo: React.PropTypes.object.isRequired
  }

  handleClick: ->
    @getFlux().actions.toggleComplete(@props.todo)

  render: ->
    { span } = React.DOM

    (span {
      onClick: @handleClick
    }, @props.todo.text)
