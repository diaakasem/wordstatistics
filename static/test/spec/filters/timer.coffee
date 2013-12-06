'use strict'

describe 'Filter: timer', () ->

  # load the filter's module
  beforeEach module 'wordsApp'

  # initialize a new instance of the filter before each test
  timer = {}
  beforeEach inject ($filter) ->
    timer = $filter 'timer'

  it 'should return the input prefixed with "timer filter:"', () ->
    text = 'angularjs'
    expect(timer text).toBe ('timer filter: ' + text)
