unless String::trim
  String::trim = ->
    this.replace /^\s+|\s+$/gm, ''

controller = (scope, Service, http) ->

  scope.model = {}
  # Words to filter analysis against
  scope.model.words = []

  scope.result = null
  scope.word = ''

  scope.addWord = ->
    if scope.word
      if scope.word.trim()
        scope.model.words.push scope.word
        scope.model.words = _.uniq scope.model.words
        scope.word = ''

  scope.removeWord = (word)->
    scope.model.words = _.filter scope.model.words, (w)-> w isnt word

  scope.analyze = (form)->
    h = http
      method: 'POST'
      url: '/analyze'
      data: scope.model

    h.success (d)->
      scope.result = d
    h.error (e)->
      alert "#{e}"
    
angular.module('wordsApp')
  .controller 'WordsCtrl',
  ['$scope', 'Words', '$http', controller]
