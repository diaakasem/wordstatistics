service = () ->
  ->
    rest = {}
    entries = [
      'name': 'id'
      'faker': 'parseInt(Math.random()*100)'
    ,
      name: 'name'
      faker: 'Faker.Name.findName()'
    ]

    fakes = []

    # Simulating the return from the server
    reply = (obj, error=null)->
      'time': (+new Date())/1000
      'result': obj
      'error': error

    # Returns a fake list of the objects
    fake = (count)->
      ret = []
      _.times count, (i)->
        obj = {id: i}
        _.each entries, (e)->
          if _.isFunction e.faker
            e.faker (data)->
              obj[e.name] = data
          else
            obj[e.name] = eval(e.faker)
        ret.push obj
      ret

    config = (count, schema, replace=false) ->
      if replace
        entries = schema
      else
        entries = entries.concat schema
      fakes = fake(count)
      @

    list = (cb) ->
      data = reply(fakes)
      if data.error
        errCB?(data.error)
      else
        cb?(data.result)

    create = (obj, cb, errCB) ->
      obj.id = id()
      fakes.push obj
      data = reply(obj)
      if data.error
        errCB?(data.error)
      else
        cb?(data.result)

    update = (obj, cb, errCB) ->
      data = reply(true)
      if data.error
        errCB?(data.error)
      else
        cb?(data.result)
    
    getList = (ids, cb, errCB) ->
      # Making all ids strings
      ids = _.map ids, (id)-> "#{id}"
      list (res)->
        objects = _.filter res, (q)-> "#{q.id}" in ids
        data = reply(objects)
        if data.error
          errCB?(data.error)
        else
          cb?(data.result)

    get = (id, cb, errCB) ->
      obj = _.find fakes, (p)-> "#{p.id}" == "#{id}"
      data = reply(obj)
      if data.error
        errCB?(data.error)
      else
        cb?(data.result)

    remove = (id, cb, errCB) ->
      fakes = _.filter fakes, (p)-> "#{p.id}" != "#{id}"
      data = reply(true)
      if data.error
        errCB?(data.error)
      else
        cb?(data.result)

    id = ->
      p = _.max fakes, 'id'
      return parseInt(p.id) + 1

    sample = ->
      p = _.clone fakes[0]
      p.id = id()
      return p
    
    # Public API here
    config: config
    list: list
    get: get
    getList: getList
    create: create
    update: update
    remove: remove
    fake: fake
    sample: sample

angular.module('fleetApp').factory 'FakeCrud', service
