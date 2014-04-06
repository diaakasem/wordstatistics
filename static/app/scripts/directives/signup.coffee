"use strict"
controller = (root, scope, ParseCrud)->
  scope.model = {}
  scope.signup = (form)->
    if form.$invalid
      return
    if form.$valid and (scope.model.password isnt scope.model.confirmpassword)
      form.confirmpassword.$error.nomatch = yes
      return

    delete scope.model.confirmpassword

    #
    # The code used to create administrator role from the console
    #
    #roleACL = new Parse.ACL()
    #roleACL.setPublicReadAccess true
    #role = new Parse.Role("Administrator", roleACL)
    #role.save()
      
    roleSuccess = (roles)->
      administrators = roles[0]
      user = new Parse.User()
      user.set "name", scope.model.name
      user.set "username", scope.model.email
      user.set "password", scope.model.password
      user.set "email", scope.model.email

      acl = new Parse.ACL()
      acl.setRoleReadAccess(administrators, true)
      user.set "ACL", acl
      user.signUp null,
        success: (user) ->
          root.user = user
          root.go '/'
        ,
        error: (user, error) ->
          console.error error
          alert("Error occured while signing up.")

      
    onError = (e)->
      scope.$apply ->
        console.log e
        Alert.error 'Error occured while saving user information.'

    query = new Parse.Query(Parse.Role)
    query.find success: roleSuccess, error: onError


angular.module("wordsApp").directive "signup", ->
  templateUrl: 'views/directives/signup.html'
  restrict: "E"
  replace: yes
  scope: true
  link: (scope, elm, attrs, ctrl) ->

  controller: ['$rootScope', '$scope', 'ParseCrud', controller]

