service = (Crud)->
  crud = Crud().config('people/')
  crud

angular.module('wordsApp')
  .factory 'People',
    ['Crud', service]
