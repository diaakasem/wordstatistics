"use strict"
controller = (root, scope, fb)->
  scope.model = {}

  Parse.FacebookUtils.init(fb.fbParams)

  scope.signinFacebook = ->
    Parse.FacebookUtils.logIn null,
      success: (user) ->
        unless user.existed()
          alert "User signed up and logged in through Facebook!"
        else
          alert "User logged in through Facebook!"
      error: (user, error) ->
        alert "User cancelled the Facebook login or did not fully authorize."


  scope.signin = (form)->
    if form.$invalid
      return
    
    Parse.User.logIn scope.model.email, scope.model.password,
      success: (user) ->
        root.user = user
        roleSuccess = (role) ->
          adminRelation = new Parse.Relation(role, "users")
          queryAdmins = adminRelation.query()
          queryAdmins.equalTo "objectId", root.user.id
          queryAdmins.first success: (result)->
            root.isAdmin = result
            if root.isAdmin
              root.go '/'
            else
              root.go '/'

        query = new Parse.Query(Parse.Role)
        query.equalTo "name", "Administrator"
        query.first success: roleSuccess

      error: (user, error) ->
        console.log(error)
        alert("Invalid username or password. Please try again.")


angular.module("wordsApp").directive "signin", ->
  templateUrl: 'views/directives/signin.html'
  restrict: "E"
  replace: yes
  scope: on
  controller: ['$rootScope', '$scope', '$FB', controller]

