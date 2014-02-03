app = angular.module 'wordsApp', ['ngRoute', 'ngTable', 'restangular']

app.config ($routeProvider) ->
  Parse.initialize "zCZ9afoU17xLzheYoVGnUxU85Wvqri3pasbdc0Q9",
                   "m1kKssfW6cek18eL9fa8AS0JR7siPCFPx5NmHDuR"
  $routeProvider
    .when '/',
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
      access: 'public'
    .when '/processes',
      templateUrl: 'views/processes.html',
      controller: 'ProcessesCtrl'
      access: 'user'
    .when '/process/:id',
      templateUrl: 'views/processeddocument.html',
      controller: 'ProcessedDocumentCtrl'
      access: 'user'
    .when '/segments',
      templateUrl: 'views/segments.html',
      controller: 'SegmentsCtrl'
      access: 'user'
    .when '/words',
      templateUrl: 'views/words.html',
      controller: 'WordsCtrl'
      access: 'user'
    .when '/upload/documents',
      templateUrl: 'views/upload/documents.html',
      controller: 'UploadDocumentsCtrl'
      access: 'user'
    .when '/upload/words',
      templateUrl: 'views/upload/words.html',
      controller: 'UploadWordsCtrl'
      access: 'user'
    .when '/upload/uploads',
      templateUrl: 'views/upload/uploads.html',
      controller: 'UploadsUploadsCtrl'
      access: 'user'
    .otherwise
      redirectTo: '/words'

rootController = (root, location, Alert)->
  root.go = (url)->
    location.path('/' + url)

  root.user = Parse.User.current()

  root.$on '$routeChangeStart', (event, next)->
    Alert.clear()
    if next.access isnt 'public' and not root.user
      root.go ''

app.run [ '$rootScope', '$location', 'Alert', rootController ]

