controller = (scope, ParseCrud,  ngTableParams, http) ->

  scope.data = []
  scope.success = ''
  scope.error = ''
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
      params =
        method: 'POST'
        url: '/analyzefiles'
        data: scope.files
          
      h = http params
      h.success (d)->
        scope.entity.result = d.result
        Processes.save scope.entity, saveSuccess, onError
        scope.tableParams.reload()
        scope.success = 'Processed successfully'
      h.error (e)->
        scope.success = ''
        scope.error = e

    scope.entity.documents.get('uploadedDocument').fetch
      success: (documentFile)->
        scope.files.document = documentFile.get('uploadname')
        doProcess()

    scope.entity.wordslist.get('uploadedDocument').fetch
      success: (wordsFile)->
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
      scope.success = 'Removed successfully.'
      scope.tableParams.reload()
    h.error (e)->
      scope.success = ''
      scope.error = e

  scope.remove = (entity)->
    entity.destroy
      success: ->
        scope.$apply ->
          scope.success = 'Removed successfully.'
          scope.error = ''
          scope.data = _.filter scope.data, (d)-> d.id isnt entity.id
          scope.tableParams.reload()
      error: (e)->
        console.log e
        scope.$apply ->
          scope.success = ''
          scope.error = 'Error occurred while removing.'

  scope.tableParams = new ngTableParams
    page: 1
    count: 10
  ,
    total: -> scope.data.length
    getData: ($defer, params) ->
      $defer.resolve scope.data.slice((params.page() - 1) * params.count(), params.page() * params.count())

angular.module('wordsApp')
  .controller 'ProcessesCtrl',
  ['$scope', 'ParseCrud', 'ngTableParams', '$http', controller]
