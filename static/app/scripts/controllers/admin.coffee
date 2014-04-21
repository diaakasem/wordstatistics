controller = (scope, ParseCrud,  ngTableParams, http, Alert, Admin) ->

  scope.data = []
  scope.selected = 'users'
  scope.entity = {}
  scope.files = {}
  scope.Admin = Admin

  scope.Admin.on scope.Admin.events.UPDATE, (users)->
    scope.$apply ->
      scope.users = users
      scope.tableParams.reload()

  scope.isAdmin = (user)->
    not not _.find scope.users, {'id': user.id}

  Users = new ParseCrud 'User'
  Users.list (d)->
    scope.data = d
    scope.tableParams.reload()
    scope.Admin.updateUsers()

  saveSuccess = (e)->
    scope.$apply ->
      scope.data.push e
      scope.tableParams.reload()
      scope.selected = 'list'
      Alert.success 'User information was saved successfully.'
    
  onError = (obj, e)->
    scope.$apply ->
      console.log e
      Alert.error 'Error occured while saving user information.'

  scope.switchAdmin = (user)->
    # Success Handler
    success = ->
      Alert.success 'Operation was successful.'
      scope.$apply ->
        scope.tableParams.reload()
    # Actual Call
    Admin.switchAdmin user, success, onError

  scope.tableParams = new ngTableParams
    page: 1
    count: 10
  ,
    total: -> scope.data.length
    getData: ($defer, params) ->
      $defer.resolve scope.data.slice((params.page() - 1) * params.count(), params.page() * params.count())

angular.module('wordsApp')
  .controller 'AdminCtrl',
  ['$scope', 'ParseCrud', 'ngTableParams', '$http', 'Alert', 'Admin', controller]
