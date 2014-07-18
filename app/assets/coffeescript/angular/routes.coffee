###
|--------------------------------------------------------------------------
| Weave - Angular Routes
|--------------------------------------------------------------------------
###

partialsPath = '/public/html/partials'
app.config ['$stateProvider', ( $stateProvider ) ->
  home =
    name : 'home'
    url : '/'
    template: 'Hello Universe, this is Weaver. Speaking to you from Angular.'

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