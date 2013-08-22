alert = ($rootScope)->
 
  alert = (msg, level='success', icon='ok', iconColor='green')->
    $rootScope.alert =
      level : level
      icon : icon
      iconColor: iconColor
      msg : msg

  success = (msg)-> alert(msg, 'success', 'ok', 'green')
  warn = (msg)-> alert(msg, 'warning', 'ok', 'yellow')
  error = (msg)-> alert(msg, 'error', 'ok', 'red')
  clear = ->
    $rootScope.alert = null


  alert: alert
  warn: warn
  success: success
  error: error
  clear: clear

angular.module('fleetApp').factory 'Alert', ['$rootScope', alert]
