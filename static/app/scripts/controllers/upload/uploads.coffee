'use strict'

controller = (scope, ParseCrud, http, ngTableParams, Alert)->

  scope.text = ''
  scope.entity = {}
  scope.data = []
  scope.selected = 'upload'
  DocumentUpload = new ParseCrud 'DocumentUpload'
  DocumentUpload.list (d)->
    scope.data = d
    scope.tableParams.reload()

  removeFile = (name)->
    params =
      method: 'POST'
      url: '/removeupload'
      data:
        filename: name
    h = http params
    h.success (d)->
      Alert.success 'Removed successfully.'
      scope.tableParams.reload()
    h.error (e)->
      console.log e
      Alert.error "Error removing uploaded file."

  scope.remove = (e)->
    filename = e.get('uploadname')
    removeSuccess = (e)->
      scope.data = _.filter scope.data, (d)-> d.id isnt e.id
      removeFile filename

    DocumentUpload.remove(e, removeSuccess)

  scope.tableParams = new ngTableParams
    page: 1
    count: 10
  ,
    total: -> scope.data.length
    getData: ($defer, params) ->
      start = (params.page() - 1) * params.count()
      end = params.page() * params.count()
      $defer.resolve scope.data.slice(start, end)

  uploader = new plupload.Uploader
    browse_button: "browse"
    url: "/upload"
    filters:
      mime_types: [ {title : "Text files", extensions : "txt"} ]

  uploader.init()

  scope.filesAdded = []

  uploader.bind "FilesAdded", (up, files) ->
    scope.$apply ->
      plupload.each files, (file) ->
        scope.filesAdded.push file

  saveSuccess = (e)->
    scope.$apply ->
      scope.data.push e
      scope.tableParams.reload()
      scope.selected = 'uploaded'
      Alert.error "File was uploaded successfully."
    
  saveError = (e)->
    scope.$apply ->
      console.log e
      Alert.error "Error occured while saving upload info."

  uploader.bind 'FileUploaded', (up, file, xhr)->
    res = JSON.parse xhr.response
    obj =
      name: scope.name
      filename: file.name
      uploadname: res.result

    console.log "Saving Object "
    DocumentUpload.save obj, saveSuccess, saveError

  uploader.bind 'UploadComplete', (up, file) ->
    scope.$apply ->
      scope.filesAdded.length = 0
      scope.name = ''

  uploader.bind 'UploadProgress', (up, file) ->
    scope.$apply ->
      matches = _.filter scope.filesAdded, (f)-> f.id is file.id
      matches[0].percent = file.percent

  uploader.bind 'Error', (up, err) ->
    scope.$apply ->
      console.log err
      Alert.error "Error uploading the file."

  scope.upload = ->
    Alert.clear()
    uploader.start()

angular.module('wordsApp')
  .controller 'UploadsUploadsCtrl',
  ['$scope', 'ParseCrud', '$http', 'ngTableParams', 'Alert', controller]
