
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
    spanStyle = if @props.todo.complete then {color: "red"} else {color: "green"}
    (span {
      onClick: @handleClick,
      style: spanStyle
    }, @props.todo.text)
