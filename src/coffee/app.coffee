
React = require 'react'
AppFluxInstance = require './fluxxors/todo-fluxxor'
AppComponent = require './components/cool-app'

React.render(
  React.createElement(AppComponent, {flux: AppFluxInstance}),
  document.getElementById('container')
)