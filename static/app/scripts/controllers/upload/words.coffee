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

  WordsLists = new ParseCrud 'WordsLists'
  WordsLists.list (d)->
    scope.data = d
    scope.tableParams.reload()

  scope.save = ->
    WordsLists.save scope.entity, saveSuccess, onError

  removeSuccess = (e)->
    scope.data = _.filter scope.data, (d)-> d.id isnt e.id
    scope.tableParams.reload()

  scope.remove = (e)->
    WordsLists.remove(e, removeSuccess, onError)

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
  .controller 'UploadWordsCtrl',
  ['$scope', 'ParseCrud', '$http', 'ngTableParams', controller]

