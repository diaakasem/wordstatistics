'use strict'

controller = (scope, ParseCrud, http, ngTableParams, Alert)->

  scope.text = ''
  scope.entity = {}
  scope.success = ''
  scope.errors = []
  scope.data = []
  scope.selected = 'new'

  Processes = new ParseCrud 'Processes'

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
    scope.$apply ->
      scope.data = _.filter scope.data, (d)-> d.id isnt e.id
      scope.tableParams.reload()
      Alert.success 'Words list was removed successfully.'

  scope.remove = (e)->
    q = Processes.query()
    q.equalTo("wordslist", e)
    q.find
      success: (p)->
        if p.length > 0
          scope.$apply ->
            Alert.error "This words list is needed for process named #{p[0].get('name')}. Please, remove that process first."
        else
          WordsLists.remove(e, removeSuccess, onError)
      error: (err)->
        scope.$apply ->
          console.log err
          Alert.error "Error occured while removing."

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
      Alert.success "Words list was saved successfully."
    
  onError = (e)->
    console.log e
    scope.$apply ->
      Alert.error 'Error occured while saving changes'

angular.module('wordsApp')
  .controller 'UploadWordsCtrl',
  ['$scope', 'ParseCrud', '$http', 'ngTableParams', 'Alert', controller]

