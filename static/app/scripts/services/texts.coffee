service = (ParseCrud)->
  new ParseCrud 'Texts'
  
angular.module('wordsApp')
  .service 'Texts',
  ['ParseCrud', service]
