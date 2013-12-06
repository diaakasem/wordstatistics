controller = (scope, Service, ngTableParams) ->

  scope.data = []
  scope.success = ''
  scope.error = ''

  Service.list (d)->
    scope.data = d
    scope.tableParams.reload()

  removeFile = (name)->
    params =
      method: 'POST'
      url: '/remove'
      data:
        filename: name
    h = http params
    h.success (d)->
      scope.$apply ->
        scope.success = 'Removed successfully.'
        scope.tableParams.reload()
    h.error (e)->
      scope.success = ''
      scope.error = e

  scope.remove = (e)->

    filename = e.get('filename')
    removeSuccess = (e)->
      scope.data = _.filter scope.data, (d)-> d.id isnt e.id
      removeFile filename

    Service.remove(e, removeSuccess)

  scope.tableParams = new ngTableParams
    page: 1
    count: 10
  ,
    total: -> scope.data.length
    getData: ($defer, params) ->
      $defer.resolve scope.data.slice((params.page() - 1) * params.count(), params.page() * params.count())

angular.module('wordsApp')
  .controller 'FilesCtrl',
  ['$scope', 'Texts', 'ngTableParams', controller]
