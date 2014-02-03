controller = (scope, ParseCrud,  ngTableParams, http, Alert) ->

  scope.data = []
  scope.selected = 'new'
  scope.entity = {}
  scope.files = {}

  Documents = new ParseCrud 'Documents'
  Documents.list (d)->
    scope.documents = d

  WordsLists = new ParseCrud 'WordsLists'
  WordsLists.list (d)->
    scope.wordslists = d

  Processes = new ParseCrud 'Processes'
  Processes.listWith ['wordslist', 'documents'], (d)->
    scope.data = d
    scope.tableParams.reload()

  Uploads = new ParseCrud 'DocumentUpload'

  scope.save = ->
    Processes.save scope.entity, saveSuccess, onError
    doProcess = _.after 2, ->
      scope.warn = 'Processing is in progress, please, be patient.'
      params =
        method: 'POST'
        url: '/analyzefiles'
        data: scope.files
          
      h = http params
      h.success (d)->
        scope.$apply ->
          scope.entity.result = d.result
          Processes.save scope.entity, saveSuccess, onError
          scope.tableParams.reload()
          Alert.success 'Processed successfully.'
      h.error (e)->
        scope.$apply ->
          Alert.error e

    scope.entity.documents.get('uploadedDocument').fetch
      success: (documentFile)->
        scope.$apply ->
          scope.files.document = documentFile.get('uploadname')
          doProcess()

    scope.entity.wordslist.get('uploadedDocument').fetch
      success: (wordsFile)->
        scope.$apply ->
          scope.files.words = wordsFile.get('uploadname')
          doProcess()

  scope.get = (parseObj, attr='name')->
    parseObj.fetch
      success: (obj)->
        obj.get(attr)
    
  saveSuccess = (e)->
    scope.data.push e
    scope.tableParams.reload()
    scope.selected = 'list'
    
  onError = ->
    debugger

  removeFile = (name)->
    params =
      method: 'POST'
      url: '/remove'
      data:
        filename: name
    h = http params
    h.success (d)->
      scope.$apply ->
        Alert.success 'Removed successfully.'
        scope.tableParams.reload()
    h.error (e)->
      scope.$apply ->
        Alert.error e

  scope.remove = (entity)->
    entity.destroy
      success: ->
        scope.$apply ->
          Alert.success 'Removed successfully.'
          scope.data = _.filter scope.data, (d)-> d.id isnt entity.id
          scope.tableParams.reload()
      error: (e)->
        console.log e
        scope.$apply ->
          Alert.error 'Error occurred while removing.'

  scope.tableParams = new ngTableParams
    page: 1
    count: 10
  ,
    total: -> scope.data.length
    getData: ($defer, params) ->
      $defer.resolve scope.data.slice((params.page() - 1) * params.count(), params.page() * params.count())

angular.module('wordsApp')
  .controller 'ProcessesCtrl',
  ['$scope', 'ParseCrud', 'ngTableParams', '$http', 'Alert', controller]
