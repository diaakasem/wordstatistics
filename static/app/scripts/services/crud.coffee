crud = (Restangular) ->
  ->
    rest = {}

    list = (cb)->
      rest.getList().then(cb)

    get = (id, cb)->
      rest.one(id).get().then(cb)

    getList = (ids, cb)->
      #TODO: IMPLEMENT THIS METHOD
      cb()

    create = (obj, cb)->
      rest.post(obj).then(cb)

    update = (obj, cb)->
      rest.put(obj).then(cb)

    remove = (id, cb)->
      #TODO: fix this
      cb null

    config = (api, baseUrl='/app/api') ->
      rest = Restangular.withConfig(->
        Restangular.setBaseUrl baseUrl
      ).all(api)
      @

    # Public API here
    config: config
    list: list
    get: get
    getList: getList
    create: create
    update: update
    remove: remove

angular.module('fleetApp').factory 'Crud', ['Restangular', crud]
