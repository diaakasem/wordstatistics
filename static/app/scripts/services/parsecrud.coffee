Service = ->
  class Crud

    constructor: (@name)->
      @class = Parse.Object.extend @name

    save: (obj, cb, errCB)->
      instance = new @class()
      for k, v of obj
        instance.set k, v
      instance.setACL(new Parse.ACL(Parse.User.current()))
      instance.save null,
        success: cb
        error: errCB

    get: (id, cb, errCB)->
      query = new Parse.Query @class
      query.get id,
        success: cb
        error: errCB

    update: (model, cb, errCB)->
      model.save
        success: cb
        error: errCB

    remove: (model, cb, errCB)->
      model.destroy
        success: cb
        error: errCB

    list: (cb, errCB)->
      query = new Parse.Query @class
      query.descending('createdAt')
      query.find
        success: cb
        error: errCB
    
angular.module('wordsApp')
  .service 'ParseCrud',
  [Service]
