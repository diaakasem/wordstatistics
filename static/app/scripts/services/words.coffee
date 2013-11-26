'use strict'
service = (Crud)->

angular.module('wordsApp')
  .service 'Words',
    ['Crud', service]
