filter = () ->
  (input) ->
    input.replace('0.0.0.0:5000', '#')

angular.module('wordsApp')
  .filter 'noport', [filter]
