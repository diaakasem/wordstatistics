"use strict"
controller = (root, scope)->
  scope.model = {}
  scope.signup = (form)->
    if form.$invalid
      return
    if form.$valid and (scope.model.password isnt scope.model.confirmpassword)
      form.confirmpassword.$error.nomatch = yes
      return

    delete scope.model.confirmpassword
      
    user = new Parse.User()
    user.set "name", scope.model.name
    user.set "username", scope.model.email
    user.set "password", scope.model.password
    user.set "email", scope.model.email
    user.set "ACL", new Parse.ACL()
    user.signUp null,
      success: (user) ->
        root.user = user
        root.go '/'
      ,
      error: (user, error) ->
        alert("Invalid username or password. Please try again.")


angular.module("wordsApp").directive "signup", ->
  templateUrl: 'views/directives/signup.html'
  restrict: "E"
  replace: yes
  scope: true
  link: (scope, elm, attrs, ctrl) ->

  controller: ['$rootScope', '$scope', controller]

