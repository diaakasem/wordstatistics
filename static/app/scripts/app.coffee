app = angular.module 'wordsApp', ['ngRoute', 'ngTable', 'restangular']

app.config ($routeProvider) ->
  Parse.initialize "zCZ9afoU17xLzheYoVGnUxU85Wvqri3pasbdc0Q9",
                   "m1kKssfW6cek18eL9fa8AS0JR7siPCFPx5NmHDuR"
  $routeProvider
    .when '/',
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
      access: 'public'
    .when '/upload',
      templateUrl: 'views/upload.html',
      controller: 'UploadCtrl'
      access: 'user'
    .when '/documents',
      templateUrl: 'views/files.html',
      controller: 'FilesCtrl'
      access: 'user'
    .when '/documents/:id',
      templateUrl: 'views/document.html',
      controller: 'DocumentCtrl'
      access: 'user'
    .when '/segments',
      templateUrl: 'views/segments.html',
      controller: 'SegmentsCtrl'
      access: 'user'
    .when '/words',
      templateUrl: 'views/words.html',
      controller: 'WordsCtrl'
      access: 'user'
    .when '/visualize',
      templateUrl: 'views/visualize.html',
      controller: 'VisualizeCtrl'
      access: 'user'
    .otherwise
      redirectTo: '/words'

rootController = (root, location)->
  root.go = (url)->
    location.path('/' + url)

  root.user = Parse.User.current()

  root.$on '$routeChangeStart', (event, next)->
    if next.access isnt 'public' and not root.user
      root.go ''

app.run [ '$rootScope', '$location', rootController ]

