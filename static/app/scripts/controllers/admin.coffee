controller = (scope, ParseCrud,  ngTableParams, http, Alert) ->

  scope.data = []
  scope.selected = 'users'
  scope.entity = {}
  scope.files = {}

  Users = new ParseCrud 'User'
  Users.list (d)->
    scope.data = d
    scope.tableParams.reload()

  saveSuccess = (e)->
    scope.$apply ->
      scope.data.push e
      scope.tableParams.reload()
      scope.selected = 'list'
      Alert.success 'User information was saved successfully.'
    
  onError = (e)->
    scope.$apply ->
      console.log e
      Alert.error 'Error occured while saving user information.'


  scope.switchAdmin = (user)->
    roleSuccess = (result) ->
      role = result[0]
      roleACL = role.getACL()
      roleACL.setReadAccess(user, true)
      roleACL.setWriteAccess(user, true)
      role.getUsers().add(user)
      role.save
        success: ->
          Alert.success 'Operation was successful.'
          scope.$apply ->
            scope.tableParams.reload()
        error: (obj, e)->
          Alert.error e.message
      
    query = new Parse.Query(Parse.Role)
    query.equalTo "name", "Administrator"
    query.find success: roleSuccess


  scope.tableParams = new ngTableParams
    page: 1
    count: 10
  ,
    total: -> scope.data.length
    getData: ($defer, params) ->
      $defer.resolve scope.data.slice((params.page() - 1) * params.count(), params.page() * params.count())

angular.module('wordsApp')
  .controller 'AdminCtrl',
  ['$scope', 'ParseCrud', 'ngTableParams', '$http', 'Alert', controller]
