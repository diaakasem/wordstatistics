"use strict"
controller = (root, scope)->
  scope.model = {}
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

        query = new Parse.Query(Parse.Role)
        query.equalTo "name", "Administrator"
        query.first success: roleSuccess
        root.go '/'

      error: (user, error) ->
        alert("Invalid username or password. Please try again.")


angular.module("wordsApp").directive "signin", ->
  templateUrl: 'views/directives/signin.html'
  restrict: "E"
  replace: yes
  scope: on
  controller: ['$rootScope', '$scope', controller]

