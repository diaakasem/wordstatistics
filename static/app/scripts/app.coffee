module = angular.module('wordsApp', ['restangular'])

configs = ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
    .otherwise
      redirectTo: '/'

module.config configs
