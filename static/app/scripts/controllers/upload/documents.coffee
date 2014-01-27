'use strict'

controller = (scope, ParseCrud, http, ngTableParams)->

  scope.text = ''
  scope.entity = {}
  scope.success = ''
  scope.errors = []
  scope.data = []
  scope.selected = 'new'

  DocumentUpload = new ParseCrud 'DocumentUpload'
  DocumentUpload.list (d)->
    scope.uploads = d

  Documents = new ParseCrud 'Documents'
  Documents.list (d)->
    scope.data = d
    scope.tableParams.reload()

  scope.save = ->
    Documents.save scope.entity, saveSuccess, onError

  removeSuccess = (e)->
    scope.data = _.filter scope.data, (d)-> d.id isnt e.id
    scope.tableParams.reload()

  scope.remove = (e)->
    Documents.remove(e, removeSuccess, onError)

  scope.tableParams = new ngTableParams
    page: 1
    count: 10
  ,
    total: -> scope.data.length
    getData: ($defer, params) ->
      start = (params.page() - 1) * params.count()
      end = params.page() * params.count()
      $defer.resolve scope.data.slice(start, end)

  saveSuccess = (e)->
    scope.data.push e
    scope.tableParams.reload()
    scope.selected = 'list'
    
  onError = ->
    debugger


angular.module('wordsApp')
  .controller 'UploadDocumentsCtrl',
  ['$scope', 'ParseCrud', '$http', 'ngTableParams', controller]
