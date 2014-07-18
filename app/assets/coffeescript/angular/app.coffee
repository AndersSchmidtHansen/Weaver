###
|--------------------------------------------------------------------------
| Weave - Angular Application Configurations
|--------------------------------------------------------------------------
###

app = angular.module 'Weaver', ['ui.router']

#= require routes.coffee

# Initialize
app.run ['$state', ( $state ) ->
  $state.transitionTo 'home'
]

# Controllers
app.controller 'AppController', ( $scope ) ->
  console.log "AppController is alive"
