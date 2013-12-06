unless String::trim
  String::trim = ->
    this.replace /^\s+|\s+$/gm, ''

controller = (scope, Service, http, timeout)->

  # Words to filter analysis against
  scope.model =
    words: []
    text: ''

  scope.success = ''
  scope.error = ''
  # The word to be added to the filter list
  scope.word = ''

  scope.addWord = ->
    if scope.word and scope.word.trim()
      scope.model.words.push scope.word
      scope.model.words = _.uniq scope.model.words
      scope.word = ''

  scope.removeWord = (word)->
    scope.model.words = _.filter scope.model.words, (w)-> w isnt word

  success = (res)->
    # Alert that document was saved successfully and move to another page
    scope.$apply ->
      scope.success = 'Document was saved successfully'
      scope.error = ''
      timeout -> scope.go 'files', 2000
      

  scope.analyze = (form)->
    h = http
      method: 'POST'
      url: '/analyze'
      data: scope.model

    h.success (d)->
      obj =
        excerpt: scope.model.text.substring(0, 100)
        filename: d.filename
        results: d.result
        words: scope.model.words
      Service.save(obj, success)

    h.error (e)->
      scope.success = ''
      scope.error = e
    
angular.module('wordsApp')
  .controller 'WordsCtrl',
  ['$scope', 'Texts', '$http', '$timeout', controller]
