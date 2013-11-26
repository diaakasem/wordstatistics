controller = (scope, Service, http) ->
  scope.model = {}
  scope.result = null

  scope.analyze = (form)->
    h = http({method: 'POST', url: '/analyze', data: scope.model})
    h.success (d)->
      scope.result = d
    h.error (e)->
      alert "#{e}"

    
    
angular.module('wordsApp')
  .controller 'WordsCtrl',
  ['$scope', 'Words', '$http', controller]
