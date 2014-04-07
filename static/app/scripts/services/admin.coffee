'use strict'

class Admin

  constructor: ->
    query = new Parse.Query(Parse.Role)
    #query.include "users"
    query.equalTo "name", "Administrator"
    query.first success: (@adminRole) =>
      @updateUsers()

  updateUsers: ->
      @users = @adminRole.getUsers()
      usersQuery = @users.query()
      usersQuery.find success: (@roleUsers)=>

  isAdmin: (user)->
    if @roleUsers
      _.find @roleUsers, (roleUser)->
        roleUser.id is user.id
    
  switchAdmin: (user, cb, errCB)->
    isAdmin = @isAdmin user
    roleACL = @adminRole.getACL()
    roleACL.setReadAccess user, !isAdmin
    roleACL.setWriteAccess user, !isAdmin
    if not isAdmin
      @adminRole.getUsers().add(user)
    else
      @adminRole.getUsers().remove(user)
      index = _.findIndex @roleUsers, (roleUser)->
        roleUser.id is user.id
    @adminRole.save
      success: (obj)=>
        @updateUsers()
        cb?(obj)
      error: (obj, err)=>
        errCB?(obj, err)

angular.module('wordsApp').service 'Admin', Admin
