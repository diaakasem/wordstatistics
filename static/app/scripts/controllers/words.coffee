unless String::trim
  String::trim = ->
    this.replace /^\s+|\s+$/gm, ''

controller = (scope, Service, http) ->

  # Words to filter analysis against
  scope.model =
    words: []
    text: ''

  scope.result = null
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

  scope.analyze = (form)->
    h = http
      method: 'POST'
      url: '/analyze'
      data: scope.model

    h.success (d)->
      scope.result = d.result
      Service.save(d, success)

    h.error (e)->
      alert "#{e}"
    
angular.module('wordsApp')
  .controller 'WordsCtrl',
  ['$scope', 'Texts', '$http', controller]
