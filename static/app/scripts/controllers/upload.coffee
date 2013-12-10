controller = (scope, params, Service, timeout, http)->

  id = params.id
  scope.id = params.id

  scope.text = ''
  scope.entity = {}
  scope.success = ''
  scope.error = ''
  scope.selected = 'documents'


angular.module('wordsApp')
  .controller 'UploadCtrl',
  ['$scope', '$routeParams', 'Texts', '$timeout', '$http', controller]
