"use strict"
controller = (root, scope)->
  scope.model = {}
  scope.signin = (form)->
    if form.$invalid
      return
    
    Parse.User.logIn scope.model.email, scope.model.password,
      success: (user) ->
        root.user = user
        root.go '/'
      ,
      error: (user, error) ->
        alert("Invalid username or password. Please try again.")


angular.module("wordsApp").directive "signin", ->
  templateUrl: 'views/directives/signin.html'
  restrict: "E"
  replace: yes
  scope: on
  controller: ['$rootScope', '$scope', controller]

