'use strict'

controller = (scope, Alert)->

  scope.resetPassword = ->
    return  unless scope.email
    Parse.User.requestPasswordReset scope.email,
      success: ->
        Alert.success "An email has been sent to you with a reset link."
      error: (error) ->
        # Show the error message somewhere
        console.error("Error: " + error.code + " " + error.message)
        Alert.error "An error occured, please, try again later"

angular.module('wordsApp').controller 'PasswordresetCtrl', ['$scope', 'Alert', controller]

