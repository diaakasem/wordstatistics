'use strict'

describe 'Service: words', () ->

  # load the service's module
  beforeEach module 'wordsApp'

  # instantiate service
  words = {}
  beforeEach inject (_words_) ->
    words = _words_

  it 'should do something', () ->
    expect(!!words).toBe true
