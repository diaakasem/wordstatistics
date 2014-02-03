'use strict'

describe 'Service: Alert', () ->

  # load the service's module
  beforeEach module 'wordsApp'

  # instantiate service
  Alert = {}
  beforeEach inject (_Alert_) ->
    Alert = _Alert_

  it 'should do something', () ->
    expect(!!Alert).toBe true
