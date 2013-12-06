'use strict'

angular.module('wordsApp')
  .filter 'timer', () ->
    (input) ->
      moment(input).format('llll')
