controller = (scope, params, ParseCrud, timeout, http)->

  id = params.id
  scope.id = params.id

  scope.text = ''
  scope.entity = {}
  scope.success = ''
  scope.errors = []
  scope.selected = 'upload'
  DocumentUpload = new ParseCrud 'DocumentUpload'

  uploader = new plupload.Uploader
      browse_button: "browse"
      url: "/upload"
      filters:
        mime_types: [
          {title : "Text files", extensions : "txt"}
        ]

  uploader.init()

  scope.filesAdded = []

  uploader.bind "FilesAdded", (up, files) ->
    scope.$apply ->
      plupload.each files, (file) ->
        scope.filesAdded.push file

  saveSuccess = ->
    scope.$apply ->
      scope.selected = 'uploaded'
    
  saveError = ->
    debugger

  uploader.bind 'FileUploaded', (up, file, xhr)->
    res = JSON.parse xhr.response

    obj =
      file_name: file.name
      upload_name: res.result

    DocumentUpload.save obj, saveSuccess, saveError

  uploader.bind 'UploadProgress', (up, file) ->
    scope.$apply ->
      matches = _.filter scope.filesAdded, (f)-> f.id is file.id
      matches[0].percent = file.percent

  uploader.bind 'Error', (up, err) ->
    scope.$apply ->
      res = JSON.parse err.response
      scope.errors.push(res?.result)

  scope.upload = ->
    scope.errors.length = 0
    uploader.start()

angular.module('wordsApp')
  .controller 'UploadDocumentsCtrl',
  ['$scope', '$routeParams', 'ParseCrud', '$timeout', '$http', controller]
