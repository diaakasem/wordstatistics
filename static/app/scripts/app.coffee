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
      access: 'admin'
    .when '/admin',
      templateUrl: 'views/admin.html'
      controller: 'AdminCtrl'
      access: 'admin'
    .otherwise
      redirectTo: '/processes'

rootController = (root, location, Alert)->
  root.go = (url)->
    location.path('/' + url)

  root.user = Parse.User.current()
  root.isAdmin = no
  roleSuccess = (role)->
    unless root.user
      return
    adminRelation = new Parse.Relation(role, "users")
    queryAdmins = adminRelation.query()
    queryAdmins.equalTo "objectId", root.user.id
    queryAdmins.first success: (result)->
      root.isAdmin = result
      root.$on '$routeChangeStart', (event, next)->
        Alert.clear()
        if next.access isnt 'public' and not root.user
          root.go ''
        else if next.access is 'admin' and not root.isAdmin
          root.go '/upload/uploads'

  query = new Parse.Query(Parse.Role)
  query.equalTo "name", "Administrator"
  query.first success: roleSuccess

app.run [ '$rootScope', '$location', 'Alert', rootController ]



fbService = ($rootScope) ->
  fbLoaded = false
  
  # Our own customisations
  _fb =
    loaded: fbLoaded
    _init: (params) ->
      if window.FB
        
        # FIXME: Ugly hack to maintain both window.FB
        # and our AngularJS-wrapped $FB with our customisations
        angular.extend window.FB, _fb
        angular.extend _fb, window.FB
        
        # Set the flag
        _fb.loaded = true
        
        # Initialise FB SDK
        window.FB.init params
        $rootScope.$apply()  unless $rootScope.$$phase

  _fb
fbCompile = ($FB) ->
    return ->
      fbAppId = "749434618429985"
      $FB.fbParams =
        appId: fbAppId
        cookie: true
        status: true
        xfbml: true
      
      $FB._init $FB.fbParams

app.factory "$FB", [ "$rootScope", fbService ]

app.directive "fb", [ "$FB", ($FB) ->
    return (
      restrict: "E"
      replace: true
      template: "<div id='fb-root'></div>"
      compile: fbCompile($FB)
    )
]
