"use strict"

# We shouldn't repeat handlers
class Pubsub
  engage: (service, events) ->
    service.events = events
    service.handlers = {}
    service.handlersNames = {}

    service.on = (event, handler, name) ->
      unless @handlers[event]
        @handlers[event] = []
        @handlersNames[event] = []
      @handlers[event].push handler
      if name
        i = _.indexOf(@handlersNames[event], name)
        if i >= 0
          @handlers[event].splice i, 1
          @handlersNames[event].splice i, 1
        @handlersNames[event].push name

    service.notify = (event, message) ->
      _.each @handlers[event], (handler) ->
        handler message

    service.removeEvent = (event, name) ->
      i = _.indexOf(@handlersNames[event], name)
      if i >= 0
        @handlers[event].splice i, 1
        @handlersNames[event].splice i, 1

angular.module("wordsApp").service "Pubsub", Pubsub
