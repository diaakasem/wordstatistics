service = (Restangular) ->

  httpFields =
    headers:
      common:
        Accept: 'application/json'

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

    config = (api, baseUrl='app') ->
      rest = Restangular.withConfig((configurer)->
        configurer.setBaseUrl(baseUrl)
      ).all(api+'/')
      @

    # Public API here
    config: config
    list: list
    get: get
    getList: getList
    create: create
    update: update
    remove: remove

angular.module('wordsApp')
  .factory 'Crud',
    ['Restangular', service]
