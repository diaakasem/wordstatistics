'use strict'

describe 'Filter: noport', () ->

  # load the filter's module
  beforeEach module 'wordsApp'

  # initialize a new instance of the filter before each test
  noport = {}
  beforeEach inject ($filter) ->
    noport = $filter 'noport'

  it 'should return the input prefixed with "noport filter:"', () ->
    text = 'angularjs'
    expect(noport text).toBe ('noport filter: ' + text);
