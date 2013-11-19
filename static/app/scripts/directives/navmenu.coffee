'use strict'
controller = (root, scope)->

  scope.signup = (email, password)->
    user = new Parse.User()
    user.set("username", email)
    user.set("password", password)
    user.set("email", email)
    debugger; 
    user.signUp {ACL: new Parse.ACL()},
      success: (user) ->
        root.user = user
        root.go '/'
      ,
      error: (user, error) ->
        alert("Invalid username or password. Please try again.")


  scope.signin = (email, password)->
    Parse.User.logIn email, password,
      success: (user) ->
        root.user = user
        root.go '/'
      ,
      error: (user, error) ->
        alert("Invalid username or password. Please try again.")


  scope.signout= ->
    Parse.User.logOut()
    root.user = null
    root.go '/'


angular.module('wordsApp')
  .directive 'navmenu', ->
    templateUrl: 'views/nav.html'
    restrict: 'E'
    controller: ['$rootScope', '$scope', controller]
