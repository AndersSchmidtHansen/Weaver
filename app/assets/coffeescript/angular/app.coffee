###
|--------------------------------------------------------------------------
| Weave - Angular Application Configurations
|--------------------------------------------------------------------------
###

#-------------------------------------------------
# Constants & Keys
#-------------------------------------------------

partialsPath = '/public/html/partials'
DATABASE_URL     = 'https://vivid-fire-5093.firebaseio.com/'
USERAPP_API_KEY  = '53825164061a0'

app = angular.module 'Weaver', ['ui.router', 'UserApp', 'firebase']

app

#-------------------------------------------------
# Configurations & Routes
#-------------------------------------------------
.config ['$stateProvider', ( $stateProvider ) ->
  home =
    name : 'home'
    url : '/'
    templateUrl: "/public/html/home.html"
    data :
      public : true

  login =
    name : 'login'
    url : '/login'
    templateUrl : "#{partialsPath}/login.html"
    data :
      login : true

  signup =
    name : 'signup'
    url : '/signup'
    templateUrl : "#{partialsPath}/signup.html"
    data :
      public : true

  $stateProvider.state home
  $stateProvider.state login
  $stateProvider.state signup
]

#-------------------------------------------------
# Initialize
#-------------------------------------------------
.run ['$state', 'user', ( $state, user ) ->
  $state.transitionTo 'home'
  user.init appId : "#{USERAPP_API_KEY}"
]


#-------------------------------------------------
# Controllers
#-------------------------------------------------
.controller 'AppController', [ "$scope", "$firebase", ( $scope, $firebase ) ->
  $scope.items = $firebase new Firebase "#{DATABASE_URL}/items"
]

