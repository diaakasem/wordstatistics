'use strict'

controller = (scope, ParseCrud, http, ngTableParams, Alert)->

  scope.text = ''
  scope.entity = {}
  scope.data = []
  scope.selected = 'new'

  DocumentUpload = new ParseCrud 'DocumentUpload'
  DocumentUpload.list (d)->
    scope.uploads = d

  Documents = new ParseCrud 'Documents'
  Documents.list (d)->
    scope.data = d
    scope.tableParams.reload()

  Processes = new ParseCrud 'Processes'

  scope.save = ->
    Documents.save scope.entity, saveSuccess, onError

  removeSuccess = (e)->
    scope.$apply ->
      scope.data = _.filter scope.data, (d)-> d.id isnt e.id
      scope.tableParams.reload()
      Alert.success 'Document was removed successfully.'

  scope.remove = (e)->
    q = Processes.query()
    q.equalTo("documents", e)
    q.find
      success: (p)->
        if p.length > 0
          scope.$apply ->
            Alert.error "This document is needed for process named #{p[0].get('name')}. Please, remove that process first."
        else
          Documents.remove(e, removeSuccess, onError)
      error: (err)->
        scope.errors.push err

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
    scope.$apply ->
      scope.data.push e
      scope.tableParams.reload()
      scope.selected = 'list'
      Alert.success 'Document was saved successfully.'
      
  onError = (e)->
    scope.$apply ->
      console.log e
      Alert.error 'Error occured while saving changes'


angular.module('wordsApp')
  .controller 'UploadDocumentsCtrl',
  ['$scope', 'ParseCrud', '$http', 'ngTableParams', 'Alert', controller]
