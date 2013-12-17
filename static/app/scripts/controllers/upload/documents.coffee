controller = (scope, params, Service, timeout, http)->

  id = params.id
  scope.id = params.id

  scope.text = ''
  scope.entity = {}
  scope.success = ''
  scope.errors = []
  scope.selected = 'documents'

  uploader = new plupload.Uploader
      browse_button: "browse"
      url: "/upload"

  uploader.init()

  scope.filesAdded = []

  uploader.bind "FilesAdded", (up, files) ->
    plupload.each files, (file) ->
      scope.filesAdded.push file

  uploader.bind 'Error', (up, err) ->
    scope.$apply ->
      res = JSON.parse err.response
      scope.errors.push(res?.result)

  scope.upload = ->
    scope.errors.length = 0
    uploader.start()

angular.module('wordsApp')
  .controller 'UploadDocumentsCtrl',
  ['$scope', '$routeParams', 'Texts', '$timeout', '$http', controller]
