###
|--------------------------------------------------------------------------
| Weave - Angular Application Configurations
|--------------------------------------------------------------------------
###

app = angular.module 'Weaver', ['ui.router']

# Routing
partialsPath = '/public/html/partials'
app.config ['$stateProvider', ($stateProvider) ->
  home =
    name : 'home'
    url : '/'
    template: 'Hello Universe, this is Weaver. Speaking to you from Angular.'

  login =
    name : 'login'
    url : '/login'
    templateUrl : "#{partialsPath}/login.html"

  $stateProvider.state home
  $stateProvider.state login
]

# Initialize
app.run ['$state', ( $state ) ->
  $state.transitionTo 'home'
]

# Controllers
app.controller 'AppController', ( $scope ) ->
  console.log "AppController is alive"
