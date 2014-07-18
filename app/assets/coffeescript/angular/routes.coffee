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

  $stateProvider.state home
  $stateProvider.state login
]