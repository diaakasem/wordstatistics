'use strict'

describe 'Service: parsecrud', () ->

  # load the service's module
  beforeEach module 'wordsApp'

  # instantiate service
  parsecrud = {}
  beforeEach inject (_parsecrud_) ->
    parsecrud = _parsecrud_

  it 'should do something', () ->
    expect(!!parsecrud).toBe true
