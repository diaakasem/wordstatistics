module = angular.module('wordsApp', ['restangular'])

configs = ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
    .when '/upload',
      templateUrl: 'views/upload.html',
      controller: 'UploadCtrl'
    .when '/files',
      templateUrl: 'views/files.html',
      controller: 'FilesCtrl'
    .when '/segments',
      templateUrl: 'views/segments.html',
      controller: 'SegmentsCtrl'
    .when '/words',
      templateUrl: 'views/words.html',
      controller: 'WordsCtrl'
    .otherwise
      redirectTo: '/'

module.config configs
