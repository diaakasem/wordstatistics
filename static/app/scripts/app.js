// Generated by CoffeeScript 1.6.3
(function() {
  var app, fbCompile, fbService, rootController;

  app = angular.module('wordsApp', ['ngRoute', 'ngTable', 'restangular']);

  app.config(function($routeProvider) {
    Parse.initialize("zCZ9afoU17xLzheYoVGnUxU85Wvqri3pasbdc0Q9", "m1kKssfW6cek18eL9fa8AS0JR7siPCFPx5NmHDuR");
    return $routeProvider.when('/', {
      templateUrl: 'views/main.html',
      controller: 'MainCtrl',
      access: 'public'
    }).when('/processes', {
      templateUrl: 'views/processes.html',
      controller: 'ProcessesCtrl',
      access: 'user'
    }).when('/process/:id', {
      templateUrl: 'views/processeddocument.html',
      controller: 'ProcessedDocumentCtrl',
      access: 'user'
    }).when('/segments', {
      templateUrl: 'views/segments.html',
      controller: 'SegmentsCtrl',
      access: 'user'
    }).when('/words', {
      templateUrl: 'views/words.html',
      controller: 'WordsCtrl',
      access: 'user'
    }).when('/upload/documents', {
      templateUrl: 'views/upload/documents.html',
      controller: 'UploadDocumentsCtrl',
      access: 'user'
    }).when('/upload/words', {
      templateUrl: 'views/upload/words.html',
      controller: 'UploadWordsCtrl',
      access: 'user'
    }).when('/upload/uploads', {
      templateUrl: 'views/upload/uploads.html',
      controller: 'UploadsUploadsCtrl',
      access: 'admin'
    }).when('/admin', {
      templateUrl: 'views/admin.html',
      controller: 'AdminCtrl',
      access: 'admin'
    }).otherwise({
      redirectTo: '/processes'
    });
  });

  rootController = function(root, location, Alert) {
    var query, roleSuccess;
    root.go = function(url) {
      return location.path('/' + url);
    };
    root.user = Parse.User.current();
    root.isAdmin = false;
    roleSuccess = function(role) {
      var adminRelation, queryAdmins;
      if (!root.user) {
        return;
      }
      adminRelation = new Parse.Relation(role, "users");
      queryAdmins = adminRelation.query();
      queryAdmins.equalTo("objectId", root.user.id);
      return queryAdmins.first({
        success: function(result) {
          root.isAdmin = result;
          return root.$on('$routeChangeStart', function(event, next) {
            Alert.clear();
            if (next.access !== 'public' && !root.user) {
              return root.go('');
            } else if (next.access === 'admin' && !root.isAdmin) {
              return root.go('/upload/uploads');
            }
          });
        }
      });
    };
    query = new Parse.Query(Parse.Role);
    query.equalTo("name", "Administrator");
    return query.first({
      success: roleSuccess
    });
  };

  app.run(['$rootScope', '$location', 'Alert', rootController]);

  fbService = function($rootScope) {
    var fbLoaded, _fb;
    fbLoaded = false;
    _fb = {
      loaded: fbLoaded,
      _init: function(params) {
        if (window.FB) {
          angular.extend(window.FB, _fb);
          angular.extend(_fb, window.FB);
          _fb.loaded = true;
          window.FB.init(params);
          if (!$rootScope.$$phase) {
            return $rootScope.$apply();
          }
        }
      }
    };
    return _fb;
  };

  fbCompile = function($FB) {
    return function() {
      var fbAppId;
      fbAppId = "749434618429985";
      $FB.fbParams = {
        appId: fbAppId,
        cookie: true,
        status: true,
        xfbml: true
      };
      return $FB._init($FB.fbParams);
    };
  };

  app.factory("$FB", ["$rootScope", fbService]);

  app.directive("fb", [
    "$FB", function($FB) {
      return {
        restrict: "E",
        replace: true,
        template: "<div id='fb-root'></div>",
        compile: fbCompile($FB)
      };
    }
  ]);

}).call(this);

/*
//@ sourceMappingURL=app.map
*/
