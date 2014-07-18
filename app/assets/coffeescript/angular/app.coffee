###
|--------------------------------------------------------------------------
| Weave - Angular Application Configurations
|--------------------------------------------------------------------------
###

app = angular.module 'Weaver', ['ui.router', 'UserApp']

#= require routes.coffee

# Initialize
app.run ['$state', 'user', ( $state, user ) ->
  $state.transitionTo 'home'
  user.init appId : '53825164061a0'
]

# Controllers
app.controller 'AppController', ( $scope ) ->
  console.log "AppController is alive"
