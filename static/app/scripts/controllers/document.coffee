controller = (scope, params, Service, timeout, http)->

  id = params.id

  scope.text = ''
  scope.entity = {}
  scope.success = ''
  scope.error = ''

  Service.get id, (d)->
    scope.$apply ->
      scope.entity = d
      load(d)

  removeFile = (name)->
    params =
      method: 'POST'
      url: '/remove'
      data:
        filename: name
    h = http params
    h.success (d)->
      scope.success = 'Removed successfully.'
      timeout -> scope.go 'documents', 5000
    h.error (e)->
      scope.success = ''
      scope.error = e

  load = (d)->
    params =
      method: 'POST'
      url: '/load'
      data:
        filename: d.get('filename')
    h = http params
    h.success (d)->
      scope.text = d
      scope.success = ''
      scope.error = ''
    h.error (e)->
      scope.success = ''
      scope.error = e

  scope.remove = (e)->
    filename = e.get('filename')

    removeSuccess = ->
      removeFile filename

    Service.remove(e, removeSuccess)

angular.module('wordsApp')
  .controller 'DocumentCtrl',
  ['$scope', '$routeParams', 'Texts', '$timeout', '$http', controller]
